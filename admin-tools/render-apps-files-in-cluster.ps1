<#
.SYNOPSIS
  Runs "ansible-playbook install-gitops.yaml -t rendering-apps-files" inside a
  temporary pod, for Windows machines that can't run Ansible (no WSL, no admin).

.DESCRIPTION
  1. Creates a dedicated namespace, a ServiceAccount bound to cluster-admin,
     and a pod using the git-ansible image.
  2. Copies the socle repo and the local GitOps clone into the pod.
  3. Builds a kubeconfig from the pod ServiceAccount token and runs the playbook.
  4. Copies the rendered GitOps repo back and mirrors it into the local clone
     (.git excluded), so the changes show up in "git status" / "git diff".
  5. Deletes the namespace and the ClusterRoleBinding (unless -KeepResources).

  Nothing is downloaded from the pod: on an offline cluster, point -Image to the
  internal registry mirror. The Ansible collections are copied from the local
  .venv ("uv sync" works on Windows even though ansible-playbook doesn't) when
  the image lacks them, and helm from -HelmTarball when the image lacks it.

  Requirements on the laptop: kubectl (with rights to create namespaces and
  ClusterRoleBindings), tar.exe and robocopy.exe (both ship with Windows 10+).

  KUBECONFIG_INFRA points to the same in-cluster kubeconfig, so the infra
  cluster is assumed to be this cluster. Otherwise, set VAULT_INFRA_TOKEN
  (and VAULT_INFRA_DOMAIN if needed) before running the script.

.EXAMPLE
  .\admin-tools\render-apps-files-in-cluster.ps1 -GitopsRepoPath C:\dev\gitops

.EXAMPLE
  $env:VAULT_INFRA_TOKEN = "hvs.xxx"
  .\admin-tools\render-apps-files-in-cluster.ps1 -GitopsRepoPath C:\dev\gitops -DscCr conf-perso -HelmTarball C:\Users\me\Downloads\helm-v3.19.0-linux-amd64.tar.gz
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [string]$GitopsRepoPath,

  # Defaults to the repo containing this script
  [string]$SocleRepoPath,

  [string]$Context,

  [ValidatePattern('^[a-z0-9]([-a-z0-9]*[a-z0-9])?$')]
  [string]$Namespace = "socle-render",

  [string]$Image = "ghcr.io/cloud-pi-native/git-ansible:1",

  [ValidatePattern('^[a-z0-9.-]*$')]
  [string]$DscCr = "",

  [ValidatePattern('^[a-z0-9,_-]+$')]
  [string]$Tags = "rendering-apps-files",

  # Linux helm tarball (https://get.helm.sh/helm-vX.Y.Z-linux-amd64.tar.gz), only needed if the image has no helm
  [string]$HelmTarball,

  # Folder containing ansible_collections (the one installed by "uv sync" by default), used if the image lacks the collections
  [string]$CollectionsPath,

  [switch]$KeepResources,

  [switch]$Yes
)

$ErrorActionPreference = "Stop"

# Windows PowerShell 5.1 may leave $PSScriptRoot empty in param() defaults, so defaults are set here
$scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
if (-not $SocleRepoPath) { $SocleRepoPath = Split-Path -Parent $scriptDir }
if (-not $CollectionsPath) { $CollectionsPath = Join-Path $SocleRepoPath ".venv\Lib\site-packages" }

$PodName = "socle-render"
$CrbName = "socle-render-$Namespace"
$Utf8NoBom = New-Object System.Text.UTF8Encoding $false

function Invoke-Kubectl {
  $kubectlArgs = @()
  if ($Context) { $kubectlArgs += "--context=$Context" }
  $kubectlArgs += $args
  & kubectl @kubectlArgs
  if ($LASTEXITCODE -ne 0) { throw "kubectl $($args -join ' ') failed (exit code $LASTEXITCODE)" }
}

function Write-LfFile([string]$Path, [string]$Content) {
  [System.IO.File]::WriteAllText($Path, ($Content -replace "`r`n", "`n"), $Utf8NoBom)
}

function Write-Step([string]$Message) {
  Write-Host ""
  Write-Host "==> $Message" -ForegroundColor Cyan
}

# --- Pre-flight checks -------------------------------------------------------

foreach ($cmd in @("kubectl", "tar", "robocopy")) {
  if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) { throw "'$cmd' not found in PATH." }
}

$GitopsRepoPath = (Resolve-Path $GitopsRepoPath).Path
$SocleRepoPath = (Resolve-Path $SocleRepoPath).Path
if (-not (Test-Path (Join-Path $SocleRepoPath "install-gitops.yaml"))) {
  throw "install-gitops.yaml not found in $SocleRepoPath (use -SocleRepoPath)."
}
if ($HelmTarball) { $HelmTarball = (Resolve-Path $HelmTarball).Path }
if (Test-Path $CollectionsPath) { $CollectionsPath = (Resolve-Path $CollectionsPath).Path }

$currentContext = if ($Context) { $Context } else { (& kubectl config current-context) }
Write-Host "Cluster context : $currentContext"
Write-Host "Namespace       : $Namespace"
Write-Host "Socle repo      : $SocleRepoPath"
Write-Host "GitOps repo     : $GitopsRepoPath"
Write-Host "Playbook        : install-gitops.yaml -t $Tags$(if ($DscCr) { " -e dsc_cr=$DscCr" })"
Write-Host ""
Write-Host "A ServiceAccount bound to cluster-admin will be created for the duration of the run." -ForegroundColor Yellow
if (-not $Yes) {
  $answer = Read-Host "Continue? (y/N)"
  if ($answer -notmatch '^(y|yes|o|oui)$') { Write-Host "Aborted."; exit 1 }
}

# Never delete a namespace this script didn't create
$existingNs = & kubectl @(if ($Context) { "--context=$Context" }) get namespace $Namespace -o name --ignore-not-found 2>$null
if ($existingNs) {
  $managedBy = & kubectl @(if ($Context) { "--context=$Context" }) get namespace $Namespace -o "jsonpath={.metadata.labels.app\.kubernetes\.io/managed-by}" 2>$null
  if ($managedBy -ne "socle-render") { throw "Namespace '$Namespace' already exists and was not created by this script. Use -Namespace." }
}

$work = Join-Path $env:TEMP ("socle-render-" + (Get-Date -Format "yyyyMMdd-HHmmss"))
New-Item -ItemType Directory -Path $work | Out-Null
Push-Location $work  # kubectl cp breaks on "C:" paths, so only relative paths are used below

try {
  # --- Archives ----------------------------------------------------------------

  Write-Step "Packing socle and GitOps repositories"
  & tar -czf socle.tgz --exclude=.git --exclude=.venv --exclude=node_modules -C $SocleRepoPath .
  if ($LASTEXITCODE -ne 0) { throw "tar failed on socle repo" }
  & tar -czf gitops.tgz --exclude=.git -C $GitopsRepoPath .
  if ($LASTEXITCODE -ne 0) { throw "tar failed on GitOps repo" }

  $collections = @("ansible_collections/kubernetes/core", "ansible_collections/community/hashi_vault", "ansible_collections/ansible/utils")
  $hasCollections = $true
  foreach ($c in $collections) {
    if (-not (Test-Path (Join-Path $CollectionsPath $c))) { $hasCollections = $false }
  }
  if ($hasCollections) {
    & tar -czf collections.tgz -C $CollectionsPath @collections
    if ($LASTEXITCODE -ne 0) { throw "tar failed on Ansible collections" }
  } else {
    Write-Host "Collections not found under $CollectionsPath, relying on the image ones." -ForegroundColor Yellow
  }

  # --- Kubernetes resources ----------------------------------------------------

  Write-Step "Creating namespace, ServiceAccount, ClusterRoleBinding and pod"
  Write-LfFile (Join-Path $work "resources.yaml") @"
apiVersion: v1
kind: Namespace
metadata:
  name: $Namespace
  labels:
    app.kubernetes.io/managed-by: socle-render
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: socle-render
  namespace: $Namespace
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: $CrbName
  labels:
    app.kubernetes.io/managed-by: socle-render
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: socle-render
    namespace: $Namespace
"@
  Invoke-Kubectl apply -f resources.yaml

  # Vault infra settings go through a Secret so they never appear in exec command lines
  $envLines = @()
  if ($env:VAULT_INFRA_TOKEN) { $envLines += "VAULT_INFRA_TOKEN=$($env:VAULT_INFRA_TOKEN)" }
  if ($env:VAULT_INFRA_DOMAIN) { $envLines += "VAULT_INFRA_DOMAIN=$($env:VAULT_INFRA_DOMAIN)" }
  if ($envLines.Count -gt 0) {
    Write-LfFile (Join-Path $work "vault.env") (($envLines -join "`n") + "`n")
    try {
      Invoke-Kubectl -n $Namespace delete secret socle-render-env --ignore-not-found
      Invoke-Kubectl -n $Namespace create secret generic socle-render-env --from-env-file=vault.env
    } finally {
      Remove-Item (Join-Path $work "vault.env") -Force
    }
  }

  Write-LfFile (Join-Path $work "pod.yaml") @"
apiVersion: v1
kind: Pod
metadata:
  name: $PodName
  namespace: $Namespace
spec:
  serviceAccountName: socle-render
  restartPolicy: Never
  # Safety net: the pod exits on its own after 2h if cleanup is skipped
  activeDeadlineSeconds: 7200
  containers:
    - name: ansible
      image: $Image
      imagePullPolicy: IfNotPresent
      command: ["sleep", "7200"]
      envFrom:
        - secretRef:
            name: socle-render-env
            optional: true
"@
  Invoke-Kubectl apply -f pod.yaml
  Invoke-Kubectl -n $Namespace wait "pod/$PodName" --for=condition=Ready --timeout=300s

  # --- Run ---------------------------------------------------------------------

  Write-Step "Copying files into the pod"
  Invoke-Kubectl cp socle.tgz "${Namespace}/${PodName}:/tmp/socle.tgz"
  Invoke-Kubectl cp gitops.tgz "${Namespace}/${PodName}:/tmp/gitops.tgz"
  if ($hasCollections) {
    Invoke-Kubectl cp collections.tgz "${Namespace}/${PodName}:/tmp/collections.tgz"
  }
  if ($HelmTarball) {
    Copy-Item $HelmTarball (Join-Path $work "helm.tgz")
    Invoke-Kubectl cp helm.tgz "${Namespace}/${PodName}:/tmp/helm.tgz"
  }

  Write-LfFile (Join-Path $work "run.sh") @"
#!/bin/sh
set -eu

TAGS='$Tags'
DSC_CR='$DscCr'
W=/tmp/work
SA=/var/run/secrets/kubernetes.io/serviceaccount

rm -rf "`$W"
mkdir -p "`$W/socle" "`$W/gitops" "`$W/home" "`$W/helm"
tar -xzf /tmp/socle.tgz -C "`$W/socle"
tar -xzf /tmp/gitops.tgz -C "`$W/gitops"

export HOME="`$W/home" LANG=C.UTF-8 LC_ALL=C.UTF-8

if [ -f /tmp/helm.tgz ]; then
  tar -xzf /tmp/helm.tgz -C "`$W/helm"
  export PATH="`$W/helm/linux-amd64:`$W/helm/linux-arm64:`$PATH"
fi
command -v helm >/dev/null || { echo "ERROR: helm not found in the image, rerun with -HelmTarball"; exit 2; }
command -v ansible-playbook >/dev/null || { echo "ERROR: ansible-playbook not found in the image"; exit 2; }

# Use the collections copied from the laptop only if the image doesn't ship them (the cluster is offline)
MISSING=""
ansible-doc -t module kubernetes.core.k8s_info >/dev/null 2>&1 || MISSING="`$MISSING kubernetes.core"
ansible-doc -t module community.hashi_vault.vault_kv2_get >/dev/null 2>&1 || MISSING="`$MISSING community.hashi_vault"
ansible-doc -t filter ansible.utils.remove_keys >/dev/null 2>&1 || MISSING="`$MISSING ansible.utils"
if [ -n "`$MISSING" ]; then
  [ -f /tmp/collections.tgz ] || { echo "ERROR: missing collections in the image:`$MISSING (rerun with -CollectionsPath)"; exit 2; }
  echo "Missing in the image:`$MISSING, using the collections copied from the laptop"
  mkdir -p "`$W/collections"
  tar -xzf /tmp/collections.tgz -C "`$W/collections"
  export ANSIBLE_COLLECTIONS_PATH="`$W/collections"
fi

cat > "`$W/kubeconfig" <<EOF
apiVersion: v1
kind: Config
clusters:
  - name: in-cluster
    cluster:
      server: https://kubernetes.default.svc
      certificate-authority: `$SA/ca.crt
users:
  - name: socle-render
    user:
      token: `$(cat `$SA/token)
contexts:
  - name: in-cluster
    context:
      cluster: in-cluster
      user: socle-render
current-context: in-cluster
EOF
chmod 600 "`$W/kubeconfig"

export KUBECONFIG="`$W/kubeconfig"
export KUBECONFIG_INFRA="`$W/kubeconfig"
export GITOPS_REPO_PATH="`$W/gitops"
export ANSIBLE_CONFIG="`$W/socle/ansible.cfg"

ansible --version | head -n 1
helm version --short

cd "`$W/socle"
set -- install-gitops.yaml -t "`$TAGS"
if [ -n "`$DSC_CR" ]; then set -- "`$@" -e "dsc_cr=`$DSC_CR"; fi
ansible-playbook "`$@"

tar -czf /tmp/gitops-out.tgz -C "`$W/gitops" .
"@
  Invoke-Kubectl cp run.sh "${Namespace}/${PodName}:/tmp/run.sh"

  Write-Step "Running ansible-playbook in the pod"
  Invoke-Kubectl -n $Namespace exec $PodName -- sh /tmp/run.sh

  # --- Fetch results -----------------------------------------------------------

  Write-Step "Copying rendered files back into $GitopsRepoPath"
  Invoke-Kubectl cp "${Namespace}/${PodName}:/tmp/gitops-out.tgz" gitops-out.tgz
  New-Item -ItemType Directory -Path (Join-Path $work "out") | Out-Null
  & tar -xzf gitops-out.tgz -C out
  if ($LASTEXITCODE -ne 0) { throw "tar failed while extracting the rendered files" }

  # /MIR also removes files the playbook deleted; .git is excluded from both copy and purge
  & robocopy (Join-Path $work "out") $GitopsRepoPath /MIR /XD .git /NJH /NJS /NDL /NP
  if ($LASTEXITCODE -ge 8) { throw "robocopy failed (exit code $LASTEXITCODE)" }

  Write-Step "Done. Review the changes with: git -C `"$GitopsRepoPath`" status"
}
finally {
  Pop-Location
  if ($KeepResources) {
    Write-Host ""
    Write-Host "Resources kept. Clean up later with:" -ForegroundColor Yellow
    Write-Host "  kubectl delete namespace $Namespace; kubectl delete clusterrolebinding $CrbName"
  } else {
    Write-Step "Cleaning up cluster resources"
    & kubectl @(if ($Context) { "--context=$Context" }) delete clusterrolebinding $CrbName --ignore-not-found
    & kubectl @(if ($Context) { "--context=$Context" }) delete namespace $Namespace --ignore-not-found --wait=false
  }
  Remove-Item -Recurse -Force $work -ErrorAction SilentlyContinue
}
