#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Starting deployment pre-flight checks..."
echo "----------------------------------------"

# 1. Environment Variable Checks
MISSING_VARS=0

if [[ -z "$GITOPS_REPO_PATH" ]]; then
    echo "❌ Error: Environment variable GITOPS_REPO_PATH is not defined or is empty."
    MISSING_VARS=1
fi

if [[ -z "$VAULT_INFRA_TOKEN" ]]; then
    echo "❌ Error: Environment variable VAULT_INFRA_TOKEN is not defined or is empty."
    MISSING_VARS=1
fi

if [[ -z "$VAULT_INFRA_DOMAIN" ]]; then
    echo "❌ Error: Environment variable VAULT_INFRA_DOMAIN is not defined or is empty."
    MISSING_VARS=1
fi

if [[ $MISSING_VARS -ne 0 ]]; then
    echo ""
    echo "⚠️  Please set the missing environment variables and relaunch the script."
    exit 1
fi

echo "✅ Environment variables are set."

# 2. Dependency Check: argocd-vault-plugin
if ! command -v argocd-vault-plugin &> /dev/null; then
    echo "❌ Error: 'argocd-vault-plugin' CLI is not installed."
    echo ""
    echo "To install it via Homebrew, run:"
    echo "  brew install argocd-vault-plugin"
    echo ""
    echo "For Linux or other methods via curl, refer to:"
    echo "  https://argocd-vault-plugin.readthedocs.io/en/stable/installation/#on-linux-or-macos-via-curl"
    echo ""
    echo "⚠️  Please install the CLI, then relaunch this script."
    exit 1
fi

echo "✅ argocd-vault-plugin is installed."

# 3. Directory and File Checks
TARGET_DIR="$GITOPS_REPO_PATH/gitops/envs/conf-dso/apps/argocd"

if [[ ! -d "$TARGET_DIR" ]]; then
    echo "❌ Error: Directory $TARGET_DIR does not exist."
    exit 1
fi

if [[ ! -f "$TARGET_DIR/values.yaml" ]]; then
    echo "❌ Error: The base 'values.yaml' was not found in $TARGET_DIR."
    exit 1
fi

# Find all zone files matching the naming convention
shopt -s nullglob
ZONE_FILES=("$TARGET_DIR"/zone-*-values.yaml)
shopt -u nullglob

if [[ ${#ZONE_FILES[@]} -eq 0 ]]; then
    echo "❌ Error: No files matching 'zone-<zoneName>-values.yaml' found in $TARGET_DIR."
    exit 1
fi

# 4. Zone Selection
ZONES=()
for file in "${ZONE_FILES[@]}"; do
    filename=$(basename "$file")
    # Extract zoneName by stripping 'zone-' prefix and '-values.yaml' suffix
    zone=${filename#zone-}
    zone=${zone%-values.yaml}
    ZONES+=("$zone")
done

SELECTED_ZONE=""
if [[ ${#ZONES[@]} -eq 1 ]]; then
    SELECTED_ZONE="${ZONES[0]}"
    echo "✅ Found a single zone configuration: $SELECTED_ZONE"
else
    echo ""
    echo "Multiple zone configurations found. Please select which zone you want to install:"
    PS3="Enter the number of the zone: "
    select zone_choice in "${ZONES[@]}"; do
        if [[ -n "$zone_choice" ]]; then
            SELECTED_ZONE="$zone_choice"
            break
        else
            echo "Invalid selection. Please try again."
        fi
    done
fi

# 5. Confirmation prompt
echo ""
read -p "Do you want to install the '$SELECTED_ZONE' Zone ArgoCD? (y/n): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Installation aborted by administrator."
    exit 0
fi

echo "Proceeding with installation for zone: $SELECTED_ZONE..."
echo "----------------------------------------"

# 6. Render Secrets with argocd-vault-plugin
# Map the provided environment variables to standard AVP expected variables
export AVP_TYPE=vault
export AVP_AUTH_TYPE=token
export VAULT_ADDR="https://$VAULT_INFRA_DOMAIN"
export VAULT_TOKEN="$VAULT_INFRA_TOKEN"

# 7. Use AVP as a Helm Wrapper
# This method renders the chart, injects the values, AND replaces placeholders in templates.

CHART_PATH="$GITOPS_REPO_PATH/gitops/envs/conf-dso/apps/argocd"
RELEASE_NAME="argocd-$SELECTED_ZONE"
NAMESPACE="argocd"

echo "Step 1: Generating fully rendered manifest (Helm + AVP)..."

# We use 'helm template' to build the manifest, then pipe it to AVP to swap placeholders.
# We save this to a temporary file to pipe into 'kubectl apply' or 'helm install'.
FINAL_MANIFEST=$(mktemp)
# Ensure the temporary manifest is deleted when the script exits
trap 'rm -f "$FINAL_MANIFEST"' EXIT

echo "Ensuring namespace '$NAMESPACE' exists..."
if ! kubectl get namespace "$NAMESPACE" &> /dev/null; then
    echo "Creating namespace '$NAMESPACE'..."
    kubectl create namespace "$NAMESPACE"
else
    echo "✅ Namespace '$NAMESPACE' already exists."
fi

helm template "$RELEASE_NAME" "$CHART_PATH" \
    --namespace "$NAMESPACE" \
    --values "$CHART_PATH/values.yaml" \
    --values "$CHART_PATH/zone-$SELECTED_ZONE-values.yaml" \
    | argocd-vault-plugin generate - > "$FINAL_MANIFEST"

if [[ $? -ne 0 ]]; then
    echo "❌ Error: argocd-vault-plugin failed to generate the manifest."
    exit 1
fi

echo "✅ Manifest generated and secrets injected."

# 8. Deploy to Cluster
echo "Step 2: Deploying to cluster..."

# Since the manifest is now "raw" YAML with secrets injected, we use kubectl or helm's capability
# to install from a rendered file. 
# NOTE: 'helm upgrade --install' with a rendered manifest is best done via 'kubectl apply' 
# or by using the --post-renderer flag in a standard helm command.
# For simplicity and reliability with AVP, we'll apply the generated manifest:

kubectl apply -f "$FINAL_MANIFEST" -n "$NAMESPACE"

echo ""
echo "🎉 Deployment of $SELECTED_ZONE completed successfully!"