# Harbor

Options de configuration Harbor de la `dsc`. Installation générale : [INSTALL.md](../INSTALL.md).

- [Cache interne : Redis ou Valkey](#cache-interne--redis-ou-valkey)
- [Stockage S3 des images](#stockage-s3-des-images)

## Cache interne : Redis ou Valkey

À partir de la version 1.19 du chart Harbor, le cache interne (Redis) est remplacé par Valkey. Le socle choisit l'image selon `harbor.chartVersion` :

- chart `< 1.19` : `goharbor/redis-photon` ;
- chart `>= 1.19` : `goharbor/valkey-photon`.

Aucun paramètre à ajouter dans la `dsc`, la sélection suit la version du chart. L'image est tirée du registre `global.registry` s'il est défini, comme les autres composants Harbor.

Points d'attention :

- en mode air gap, l'image `goharbor/valkey-photon` doit être présente dans le registre miroir avant de passer à un chart `>= 1.19` ;
- pour figer le tag via `harbor.values`, utiliser `valkey-photon` avec un chart `>= 1.19` (tags : voir le [README](../README.md#harbor)) ;
- ce cache ne contient que des données reconstructibles (cache, file de jobs) : lors du passage de `< 1.19` à `>= 1.19`, les jobs en cours peuvent être perdus, planifier la montée de version hors des fenêtres de réplication ou de scan ;
- la taille du volume reste pilotée par `harbor.pvcRedisSize`.

## Stockage S3 des images

Le stockage des images et charts sur un bucket S3 s'active avec `harbor.s3ImageChartStorage` (désactivé par défaut) :

```yaml
harbor:
  s3ImageChartStorage:
    enabled: true
    bucket: my-harbor
    region: eu-west-1
    regionendpoint: https://s3.example.com
```

Les clés d'accès (`accesskey`, `secretkey`) sont saisies dans le Vault d'infrastructure. La migration depuis `harbor.values.persistence.imageChartStorage` est décrite dans [Harbor GitOps](../README.md#harbor-gitops).
