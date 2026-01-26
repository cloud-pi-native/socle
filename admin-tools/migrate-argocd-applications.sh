#!/usr/bin/env bash
set -euo pipefail

# Namespace ArgoCD si différent
ARGO_NS="dso-argocd"
OUTPUT_SQL="disable_autosync.sql"

# Récupère la liste des noms des anciennes applications en JSON 
old_app_names=($(kubectl get applications -n "$ARGO_NS" -o json \
  | jq -r '.items[] | select(.metadata.annotations["argocd.argoproj.io/tracking-id"] | not) | .metadata.name' | grep -v "\-root")) || true

echo "Anciennes applications (sans tracking-id) : "
echo "${old_app_names[*]}"

# Fonction: récupérer la valeur d'un label
get_label() {
    echo "$1" \
        | jq -r ".metadata.labels[\"$2\"] // empty"
}

# Fonction : récupère le .spec d'une application
get_spec_source() {
    kubectl get applications -n "$ARGO_NS" "$1" -o yaml \
        | yq ".spec.source"
}

echo ""
echo "=== Recherche des correspondances ==="

for src_name in "${old_app_names[@]}"; do
    echo ""
    echo "--- Application source : $src_name ---"

    # Récupération des 3 labels clés
    src=$(kubectl get applications -n "$ARGO_NS" "$src_name" -o json)
    env_val=$(get_label "$src" "dso/environment")
    proj_val=$(get_label "$src" "dso/project.slug")
    repo_val=$(get_label "$src" "dso/repository")

    # Vérification
    if [[ -z "$env_val" || -z "$proj_val" || -z "$repo_val" ]]; then
        echo "❌ L'application $src_name ne comporte pas les 3 labels requis."
        echo ""
        continue
    fi

    echo "Labels source :
      dso/environment=$env_val
      dso/project.slug=$proj_val
      dso/repository=$repo_val"

    # Recherche de l'application destination via kubectl label selectors
    selector="dso/environment=$env_val,dso/project.slug=$proj_val,dso/repository=$repo_val"

    apps_match=($(kubectl get applications -n "$ARGO_NS" -o json \
        -l "$selector" \
        | jq -r '.items[] | .metadata.name // empty'))

    # Filtrer la source pour ne garder que les autres
    dst_name=""
    for a in "${apps_match[@]}"; do
        if [[ "$a" != "$src_name" ]]; then
            dst_name="$a"
        fi
    done

    if [[ -z "$dst_name" ]]; then
        echo "❌ Aucune application cible trouvée pour $src_name"
        echo ""
        continue
    fi

    echo "➡️ Destination trouvée : $dst_name"
    echo ""

    # Specs
    spec_src=$(get_spec_source "$src_name")
    spec_dst=$(get_spec_source "$dst_name")

    diff --color -y <(echo "$spec_src") <(echo "$spec_dst") || true

    read -p "  Voulez-vous appliquer le .spec.source de $src_name (gauche) sur $dst_name (droite) ? (y/N) " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        patch_src=$(echo "$spec_src" | yq -o=json '. | {"spec": {"source": .}}')
        kubectl patch application "$dst_name" -n "$ARGO_NS" -p "$patch_src"
        echo "  ✔ Patch appliqué à $dst_name"
        spec_dst=$(get_spec_source "$dst_name")
        diff --color -y <(echo "$spec_src") <(echo "$spec_dst") || true
    else
        echo "  ❌ Patch annulé"
    fi

    read -p "  Voulez-vous réactiver l'autosync par la Console de $dst_name ? (y/N) " confirm2
    if [[ "$confirm2" =~ ^[Yy]$ ]]; then
        # Récupération de l'ID de l'environnement
        env_id=$(get_label "$src" "dso/environment.id")
        # Génération de la requête SQL
        cat >> "$OUTPUT_SQL" <<EOF
-- Application : $dst_name - Environnement : $env_val
UPDATE "Environment" SET "autosync" = TRUE
WHERE id = '$(echo "$env_id" | sed "s/'/''/g")';
EOF
        echo "" >> "$OUTPUT_SQL"
        echo "  ✔ Autosync réactivé pour $dst_name"
    else
        echo "  ❌ Update autosync annulé"
    fi

    read -p "  Voulez-vous supprimer l'application $src_name (non-cascading delete) ? (y/N) " confirm3
    if [[ "$confirm3" =~ ^[Yy]$ ]]; then
        kubectl -n "$ARGO_NS" patch app "$src_name" -p $'{"metadata": {"finalizers": null}}' --type merge
        kubectl -n "$ARGO_NS" delete app "$src_name"
        echo "  ✔ Suppression de $src_name effectuée"
    else
        echo "  ❌ Suppression annulée"
    fi

done

echo ""
echo "=== Terminé ==="
