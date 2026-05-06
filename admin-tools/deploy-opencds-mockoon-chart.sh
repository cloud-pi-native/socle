#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Starting deployment pre-flight checks..."
echo "----------------------------------------"

APPLICATION="opencds-mockoon"
CHART_PATH="$GITOPS_REPO_PATH/gitops/envs/conf-dso/apps/$APPLICATION"
RELEASE_NAME="argocd-$APPLICATION"
NAMESPACE="dso-$APPLICATION"

# 1. Directory and File Checks

if [[ ! -d "$CHART_PATH" ]]; then
    echo "❌ Error: Directory $CHART_PATH does not exist."
    exit 1
fi

if [[ ! -f "$CHART_PATH/values.yaml" ]]; then
    echo "❌ Error: The base 'values.yaml' was not found in $CHART_PATH."
    exit 1
fi

# 2. Confirmation prompt
echo ""
read -p "Do you want to install the dso-$APPLICATION chart? (y/n): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Installation aborted by administrator."
    exit 0
fi

echo "Proceeding with installation..."
echo "-------------------------------"

# 3. Render chart
helm dependency build "$CHART_PATH"
helm template "$RELEASE_NAME" "$CHART_PATH" \
    --namespace "$NAMESPACE" \
    --create-namespace \
    --values "$CHART_PATH/values.yaml" > "$FINAL_MANIFEST"

echo "✅ Manifest generated."

# 4. Apply the manifest
echo "Applying manifest..."
echo ""
if kubectl apply -f "$FINAL_MANIFEST" -n "$NAMESPACE" --server-side; then
    echo "🎉 Deployment of $APPLICATION completed successfully!"
else
    echo "❌ Error: kubectl apply failed."
    exit 1
fi
