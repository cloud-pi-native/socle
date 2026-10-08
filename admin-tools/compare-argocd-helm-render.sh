#!/usr/bin/env bash
# Render every Helm-based Application of an Argo CD instance with two Helm versions and diff
# the output, to find what an Argo CD upgrade changes in already deployed apps before doing it.
# Defaults compare the Helm bundled in Argo CD v3.1.7 (3.18.4) with the one in v3.5.2 (4.2.1).
#
# Read-only: on the cluster it only runs `kubectl get applications`, `kubectl api-versions` and
# `kubectl version`. It then clones the git repos / pulls the charts the apps point at.
#
# Usage:
#   ./admin-tools/compare-argocd-helm-render.sh
#
# Env:
#   ARGO_NS            Argo CD namespace (default: dso-argocd)
#   HELM_OLD_VERSION   Helm in the current Argo CD (default: 3.18.4)
#   HELM_NEW_VERSION   Helm in the target Argo CD (default: 4.2.1)
#                      Versions are in argo-cd's hack/tool-versions.sh at the release tag.
#   GIT_TOKEN          token for private https git repos (sent as oauth2:<token>, works with GitLab)
#   ONLY               only process apps whose name matches this regex
#   OUT                output dir (default: ${TMPDIR:-/tmp}/argocd-helm-compare)
#   APPS_JSON, API_VERSIONS_FILE, KUBE_VERSION
#                      skip kubectl and use these instead (offline run)
#
# Public https dependency repos are added automatically, like the repo-server does. Private OCI
# registries need a login first, e.g. `helm registry login <harbor-domain>`; logging in to
# registry-1.docker.io also avoids Docker Hub's anonymous rate limit (429 toomanyrequests).
#
# Apps that already have a ComparisonError in Argo CD and fail here too are reported as
# ALREADY-BROKEN: they are broken today, independently of the upgrade.
set -uo pipefail

ARGO_NS="${ARGO_NS:-dso-argocd}"
HELM_OLD_VERSION="${HELM_OLD_VERSION:-3.18.4}"
HELM_NEW_VERSION="${HELM_NEW_VERSION:-4.2.1}"
OUT="${OUT:-${TMPDIR:-/tmp}/argocd-helm-compare}"
OUT="${OUT%/}"
ONLY="${ONLY:-.}"
BIN_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/socle-helm-compare"

for bin in jq yq git curl tar shasum; do
  command -v "$bin" >/dev/null || { echo "❌ Missing dependency: $bin" >&2; exit 1; }
done

# Download a Helm release once into the cache dir, print its path.
get_helm() {
  local v="$1" os arch path
  path="$BIN_DIR/helm-$v"
  if [ ! -x "$path" ]; then
    os=$(uname -s | tr '[:upper:]' '[:lower:]')
    case "$(uname -m)" in
      x86_64|amd64) arch=amd64 ;;
      arm64|aarch64) arch=arm64 ;;
      *) echo "❌ Unsupported architecture: $(uname -m)" >&2; return 1 ;;
    esac
    mkdir -p "$BIN_DIR"
    echo "Downloading Helm v$v..." >&2
    curl -sfL "https://get.helm.sh/helm-v$v-$os-$arch.tar.gz" | tar xz -C "$BIN_DIR" "$os-$arch/helm" \
      && mv "$BIN_DIR/$os-$arch/helm" "$path" && rmdir "$BIN_DIR/$os-$arch" \
      || { echo "❌ Could not download Helm v$v" >&2; return 1; }
  fi
  echo "$path"
}

HELM_OLD=$(get_helm "$HELM_OLD_VERSION") || exit 1
HELM_NEW=$(get_helm "$HELM_NEW_VERSION") || exit 1

# Only ever wipe an empty dir or the output of a previous run.
if [ -d "$OUT" ] && [ -n "$(ls -A "$OUT")" ] && [ ! -f "$OUT/summary.tsv" ]; then
  echo "❌ $OUT is not empty and is not a previous run's output, choose another OUT" >&2; exit 1
fi
rm -rf "$OUT"; mkdir -p "$OUT/git" "$OUT/apps"

if [ -z "${APPS_JSON:-}" ]; then
  command -v kubectl >/dev/null || { echo "❌ Missing dependency: kubectl" >&2; exit 1; }
  echo "Reading Applications from namespace $ARGO_NS (context: $(kubectl config current-context))..."
  APPS_JSON="$OUT/apps.json"
  kubectl get applications -n "$ARGO_NS" -o json >"$APPS_JSON" || exit 1
  API_VERSIONS_FILE="$OUT/api-versions.txt"
  kubectl api-versions >"$API_VERSIONS_FILE" || exit 1
  KUBE_VERSION=$(kubectl version -o json | jq -r .serverVersion.gitVersion) || exit 1
fi
: "${API_VERSIONS_FILE:?set API_VERSIONS_FILE with APPS_JSON}" "${KUBE_VERSION:?set KUBE_VERSION with APPS_JSON}"
for f in "$APPS_JSON" "$API_VERSIONS_FILE"; do
  [ -f "$f" ] || { echo "❌ File not found: $f" >&2; exit 1; }
done

API_ARGS=()
while read -r a; do [ -n "$a" ] && API_ARGS+=(--api-versions "$a"); done <"$API_VERSIONS_FILE"

# Clone repo@rev once, print the checkout dir.
checkout() {
  local url="$1" rev="$2" dir key auth_url
  [ -z "$rev" ] && rev=HEAD
  key=$(printf '%s@%s' "$url" "$rev" | shasum | cut -c1-12)
  dir="$OUT/git/$key"
  if [ ! -d "$dir/.git" ]; then
    auth_url="$url"
    if [ -n "${GIT_TOKEN:-}" ] && [[ "$url" == https://* ]]; then
      auth_url="https://oauth2:${GIT_TOKEN}@${url#https://}"
    fi
    mkdir -p "$dir"
    git -C "$dir" init -q
    git -C "$dir" fetch -q --depth 1 "$auth_url" "$rev" 2>"$dir.err" \
      && git -C "$dir" checkout -q FETCH_HEAD 2>>"$dir.err" \
      || { rm -rf "$dir"; return 1; }
  fi
  echo "$dir"
}

# Sort documents and drop comments so the diff only shows real content changes.
normalize() {
  yq ea -P '[.] | map(select(. != null)) | sort_by(.kind, .metadata.namespace // "", .metadata.name) | .[] | (... comments="") | sort_keys(..) | splitDoc' "$1" 2>/dev/null || cat "$1"
}

# Same as the repo-server before `helm dependency build`: `helm repo add` every https dependency
# of Chart.yaml (named like Argo CD does, "/" replaced by "-"). OCI ones rely on `helm registry login`.
add_dependency_repos() {
  local helm="$1" chart="$2" log="$3" url
  while IFS= read -r url; do
    [[ "$url" == https://* ]] || continue
    "$helm" repo add "${url//\//-}" "$url" --force-update >>"$log" 2>&1
  done < <(yq -r '.dependencies[]?.repository // ""' "$chart/Chart.yaml" 2>/dev/null)
}

is_missing_dependency() {
  grep -qE "found in (requirements.yaml|Chart.yaml), but missing in charts" "$1"
}

# render <helm-bin> <tag> <repo-dir|""> <workdir> <release> <ns> <src-json> <refs-json> <app-dir>
# Mirrors the repo-server: works inside the whole repo checkout (so ../ value files and file://
# dependencies resolve), runs helm template, and only on a missing-dependency error adds the
# dependency repos, runs helm dependency build and templates again.
render() {
  local helm="$1" tag="$2" repo_src="$3" work="$4" release="$5" ns="$6" src="$7" refs="$8" adir="$9"
  local chart args=() vf vfp f
  export HELM_CACHE_HOME="$OUT/cache-$tag"
  export HELM_REPOSITORY_CONFIG="$OUT/cache-$tag/repositories.yaml"
  export HELM_REPOSITORY_CACHE="$OUT/cache-$tag/repository"
  mkdir -p "$work"
  : >"$adir/$tag.dep.log"
  if [ -n "$repo_src" ]; then
    tar -C "$repo_src" --exclude .git -cf - . | tar -C "$work" -xf -
    chart="$work/$(jq -r '.path // "."' <<<"$src")"
  else
    local repo chartname ver
    repo=$(jq -r '.repoURL' <<<"$src"); chartname=$(jq -r '.chart' <<<"$src"); ver=$(jq -r '.targetRevision // ""' <<<"$src")
    if [[ "$repo" == oci://* || "$repo" != *://* ]]; then
      repo="${repo#oci://}"
      "$helm" pull "oci://$repo/$chartname" ${ver:+--version "$ver"} --untar -d "$work" >"$adir/$tag.dep.log" 2>&1 || return 2
    else
      "$helm" pull "$chartname" --repo "$repo" ${ver:+--version "$ver"} --untar -d "$work" >"$adir/$tag.dep.log" 2>&1 || return 2
    fi
    chart="$work/$chartname"
  fi

  # --name-template like Argo CD: unlike the positional name it is not limited to 53 characters
  args=(template "$chart" --name-template "$release" --namespace "$ns" --kube-version "$KUBE_VERSION" "${API_ARGS[@]}")
  [ "$(jq -r '.helm.skipCrds // false' <<<"$src")" = "true" ] || args+=(--include-crds)

  # valueFiles: relative to the chart, or "$ref/path" pointing at another source
  while IFS= read -r vf; do
    [ -z "$vf" ] && continue
    if [[ "$vf" == \$* ]]; then
      local ref="${vf%%/*}"; ref="${ref#\$}"
      vfp="$(jq -r --arg r "$ref" '.[$r] // ""' <<<"$refs")/${vf#*/}"
    elif [[ "$vf" == *://* ]]; then
      vfp="$vf"
    elif [[ "$vf" == /* && -n "$repo_src" ]]; then
      vfp="$work$vf"  # absolute paths are relative to the repo root
    else
      vfp="$chart/$vf"
    fi
    if [[ "$vfp" != *://* && ! -f "$vfp" ]]; then
      [ "$(jq -r '.helm.ignoreMissingValueFiles // false' <<<"$src")" = "true" ] && continue
      echo "missing value file: $vf" >"$adir/$tag.err"; return 3
    fi
    args+=(-f "$vfp")
  done < <(jq -r '.helm.valueFiles[]? // empty' <<<"$src")

  # inline values / valuesObject come after valueFiles, parameters last (same order as Argo CD)
  f="$adir/inline-values.yaml"
  if jq -e '.helm.valuesObject' <<<"$src" >/dev/null; then
    jq '.helm.valuesObject' <<<"$src" | yq -P >"$f"; args+=(-f "$f")
  elif jq -e '.helm.values' <<<"$src" >/dev/null; then
    jq -r '.helm.values' <<<"$src" >"$f"; args+=(-f "$f")
  fi
  while IFS=$'\t' read -r name value force; do
    [ -z "$name" ] && continue
    if [ "$force" = "true" ]; then args+=(--set-string "$name=$value"); else args+=(--set "$name=$value"); fi
  done < <(jq -r '.helm.parameters[]? | [.name, .value, (.forceString // false)] | @tsv' <<<"$src")

  if ! "$helm" "${args[@]}" >"$adir/$tag.raw.yaml" 2>"$adir/$tag.err"; then
    is_missing_dependency "$adir/$tag.err" || return 3
    add_dependency_repos "$helm" "$chart" "$adir/$tag.dep.log"
    ( cd "$chart" && "$helm" dependency build >>"$adir/$tag.dep.log" 2>&1 ) || return 2
    "$helm" "${args[@]}" >"$adir/$tag.raw.yaml" 2>"$adir/$tag.err" || return 3
  fi
  normalize "$adir/$tag.raw.yaml" >"$adir/$tag.yaml"
}

SUMMARY="$OUT/summary.tsv"
printf 'APP\tSOURCE\tRESULT\tDETAIL\n' >"$SUMMARY"
echo "Comparing Helm v$HELM_OLD_VERSION (old) with v$HELM_NEW_VERSION (new)..."

jq -c '.items[]' "$APPS_JSON" | while IFS= read -r app; do
  name=$(jq -r '.metadata.name' <<<"$app")
  [[ "$name" =~ $ONLY ]] || continue
  echo "  $name"
  ns=$(jq -r '.spec.destination.namespace // "default"' <<<"$app")
  sources=$(jq -c 'if .spec.sources then .spec.sources else [.spec.source] end' <<<"$app")
  argo_error=$(jq -r '[.status.conditions[]? | select(.type == "ComparisonError")] | length | select(. > 0)' <<<"$app")

  # Resolve every "ref" source first so $ref/... value files can be found.
  refs='{}'
  while IFS= read -r s; do
    ref=$(jq -r '.ref // ""' <<<"$s"); [ -z "$ref" ] && continue
    if d=$(checkout "$(jq -r .repoURL <<<"$s")" "$(jq -r '.targetRevision // ""' <<<"$s")"); then
      refs=$(jq -c --arg k "$ref" --arg v "$d" '. + {($k): $v}' <<<"$refs")
    fi
  done < <(jq -c '.[]' <<<"$sources")

  i=0
  while IFS= read -r s; do
    i=$((i+1)); label="$name#$i"
    adir="$OUT/apps/$name/$i"; mkdir -p "$adir"
    hv=$(jq -r '.helm.version // ""' <<<"$s")
    note=""; [ -n "$hv" ] && note="helm.version=$hv is ignored since Argo CD 3.5"

    if jq -e '.plugin' <<<"$s" >/dev/null; then
      printf '%s\tplugin\tSKIP\tCMP plugin, rendered by the plugin sidecar\n' "$label" >>"$SUMMARY"; continue
    fi
    if [ -n "$(jq -r '.ref // ""' <<<"$s")" ] && [ -z "$(jq -r '(.path // "") + (.chart // "")' <<<"$s")" ]; then
      continue  # pure ref source, only used for value files
    fi

    repo_dir=""
    if [ -z "$(jq -r '.chart // ""' <<<"$s")" ]; then
      if ! repo_dir=$(checkout "$(jq -r .repoURL <<<"$s")" "$(jq -r '.targetRevision // ""' <<<"$s")"); then
        printf '%s\tgit\t%s\t%s\n' "$label" "$([ -n "$argo_error" ] && echo ALREADY-BROKEN || echo CLONE-FAIL)" \
          "clone failed: $(jq -r .repoURL <<<"$s")" >>"$SUMMARY"; continue
      fi
      chart_dir="$repo_dir/$(jq -r '.path // "."' <<<"$s")"
      if [ ! -f "$chart_dir/Chart.yaml" ]; then
        printf '%s\tgit\tSKIP\tnot a Helm chart (kustomize or plain manifests)\n' "$label" >>"$SUMMARY"; continue
      fi
    fi

    release=$(jq -r --arg n "$name" '.helm.releaseName // $n' <<<"$s")
    rns=$(jq -r --arg n "$ns" '.helm.namespace // $n' <<<"$s")
    render "$HELM_OLD" old "$repo_dir" "$adir/work-old" "$release" "$rns" "$s" "$refs" "$adir"; r_old=$?
    render "$HELM_NEW" new "$repo_dir" "$adir/work-new" "$release" "$rns" "$s" "$refs" "$adir"; r_new=$?
    rm -rf "$adir/work-old" "$adir/work-new"

    if [ $r_old -ne 0 ] && [ $r_new -ne 0 ] && [ -n "$argo_error" ]; then
      res="ALREADY-BROKEN"; detail="Argo CD already reports ComparisonError for this app, see $adir/old.err or old.dep.log"
    elif [ $r_old -ne 0 ] && [ $r_new -ne 0 ]; then
      res="BOTH-FAIL"; detail="$adir/old.err or old.dep.log (fails with the old Helm too)"
    elif [ $r_new -ne 0 ]; then
      res="NEW-FAIL"; detail="$adir/new.err or new.dep.log  <-- breaks after the upgrade"
    elif [ $r_old -ne 0 ]; then
      res="OLD-FAIL"; detail="$adir/old.err or old.dep.log"
    elif diff -u "$adir/old.yaml" "$adir/new.yaml" >"$adir/diff.patch"; then
      res="SAME"; detail=""; rm -f "$adir/diff.patch"
    else
      # Render with the old Helm a second time: charts that generate certs/passwords differ on every run.
      render "$HELM_OLD" old2 "$repo_dir" "$adir/work-old2" "$release" "$rns" "$s" "$refs" "$adir"
      rm -rf "$adir/work-old2"
      if diff -u "$adir/old.yaml" "$adir/old2.yaml" >"$adir/noise.patch"; then
        rm -f "$adir/noise.patch"
        res="DIFF"; detail="$adir/diff.patch  <-- app goes OutOfSync, auto-sync would apply this"
      else
        res="DIFF-RANDOM"; detail="$adir/diff.patch vs noise.patch: chart output is random on every render, compare the two by hand"
      fi
    fi
    printf '%s\t%s\t%s\t%s\n' "$label" "$(jq -r 'if .chart then "chart" else "git" end' <<<"$s")" "$res" "${detail}${note:+  [$note]}" >>"$SUMMARY"
  done < <(jq -c '.[]' <<<"$sources")
done

echo
column -t -s $'\t' "$SUMMARY"
echo
echo "Full results: $OUT"
