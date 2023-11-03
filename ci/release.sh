#!/bin/bash

# Fichier YAML d'entrée
input_file="./roles/socle-config/files/releases.yaml"

# Chemin vers le champ .spec
spec_path=".spec"
echo "| Outil | Version | Source |" > ./versions.md
echo "| ----- | ------- | ------ |" >> ./versions.md

# Fonction pour extraire les clés, valeurs et commentaires
yq eval ".spec | to_entries | .[] | .key" "$input_file" | while read -r key; do
    # Génère une ligne en utilisant le modèle
    export key=$key
    yq '.spec[env(key)]' "$input_file" | while read -r comment && read -r value; do
        export comment=$(cut -c 3- <<<$comment)
        export version=$(awk '{print $2}' <<< $value | tr -d '\"')
        echo "| $key | $version | [$key]($comment) |" >> ./versions.md
    done
done
