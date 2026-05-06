#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Starting deployment pre-flight checks..."
echo "----------------------------------------"

APPLICATION="opencds-mockoon"
HELM_REPOSITORY="https://cloud-pi-native.github.io/helm-charts"
HELM_REPOSITORY_ALIAS="cloud-pi-native"
RELEASE_NAME="cpn-$APPLICATION"
NAMESPACE="dso-$APPLICATION"

# 1. Confirmation prompt
echo ""
read -p "Do you want to install the $RELEASE_NAME chart? (y/n): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Installation aborted by administrator."
    exit 0
fi

echo "Proceeding with installation..."
echo "-------------------------------"

# 3. Render chart
helm repo add "$HELM_REPOSITORY_ALIAS" "$HELM_REPOSITORY"
helm repo update

echo "Installing release..."
if helm install "$RELEASE_NAME" "$HELM_REPOSITORY_ALIAS/$RELEASE_NAME" --wait --namespace "$NAMESPACE" --create-namespace; then
    echo "🎉 Release $RELEASE_NAME installed successfully !"
else
    echo "❌ Error: helm install failed."
    exit 1
fi
