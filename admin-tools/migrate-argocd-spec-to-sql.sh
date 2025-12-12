#!/usr/bin/env bash

set -euo pipefail

# Namespace ArgoCD si différent
ARGO_NS="dso-argocd"

OUTPUT_SQL="update_repository.sql"
> "$OUTPUT_SQL"

echo "-- Script SQL généré automatiquement" >> "$OUTPUT_SQL"
echo "-- Date : $(date)" >> "$OUTPUT_SQL"
echo "" >> "$OUTPUT_SQL"

# Récupère la liste des noms des anciennes applications en JSON 
old_app_names=($(kubectl get applications -n "$ARGO_NS" -o json \
  | jq -r '.items[] | select(.metadata.annotations["argocd.argoproj.io/tracking-id"] | not) | .metadata.name' | grep -v "\-root"))

COUNT=${#old_app_names[@]}

if [ "$COUNT" -eq 0 ]; then
    echo "Aucune Application trouvée" >&2
    exit 0
fi

for APP in "${old_app_names[@]}"; do

    echo "Analyse de l'application: $ARGO_NS/$APP" >&2

    ITEM=$(kubectl get applications -n "$ARGO_NS" "$APP" -o json)

    REPO_ID=$(echo "$ITEM" | jq -r '.metadata.labels["dso/repository.id"] // empty')
    DEPLOY_PATH=$(echo "$ITEM" | jq -r '.spec.source.path // ""')
    TARGET_REVISION=$(echo "$ITEM" | jq -r '.spec.source.targetRevision // ""')

    VALUE_FILES=$(echo "$ITEM" | jq -r '
        if .spec.source.helm.valueFiles then
            .spec.source.helm.valueFiles | join(",")
        else
            ""
        end
    ')

    if [ -z "$REPO_ID" ]; then
        echo "  -> ATTENTION : pas de label dso/repository.id, ignoré." >&2
        continue
    fi

    # Génération de la requête SQL
    cat >> "$OUTPUT_SQL" <<EOF
-- Application : $ARGO_NS/$APP
UPDATE "Repository"
SET
    "deployPath" = '$(echo "$DEPLOY_PATH" | sed "s/'/''/g")',
    "deployRevision" = '$(echo "$TARGET_REVISION" | sed "s/'/''/g")',
    "helmValuesFiles" = '$(echo "$VALUE_FILES" | sed "s/'/''/g")'
WHERE id = '$(echo "$REPO_ID" | sed "s/'/''/g")';
EOF

    echo "" >> "$OUTPUT_SQL"
done

echo "Script SQL généré dans $OUTPUT_SQL"
