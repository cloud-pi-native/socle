# GitLab

Options de configuration GitLab de la `dsc` (toutes désactivées par défaut). Installation générale : [INSTALL.md](../INSTALL.md).

- [Stockage objet S3 externe](#gitlab-sur-stockage-objet-s3-externe)
- [GitLab Pages](#gitlab-pages)
- [User namespaces du runner](#gitlab-runner--user-namespaces)

## GitLab sur stockage objet S3 externe

Par défaut, les données non-Git de GitLab (artifacts, LFS, uploads, packages…) sont stockées dans le MinIO embarqué du chart. `dsc.gitlab.s3ObjectStorage.enabled: true` les déplace vers un stockage S3 compatible externe :

- MinIO embarqué désactivé (`global.minio.enabled: false`) ;
- configuration consolidée du chart (`global.appConfig.object_store`, `proxy_download: true`) : une connexion, un bucket par type ;
- Gitaly (dépôts Git) reste sur volume persistant ;
- désactivé par défaut : sans ce paramètre, le rendu GitLab est inchangé.

Champs `dsc.gitlab.s3ObjectStorage` :

| Clé | Défaut | Rôle |
| --- | --- | --- |
| `enabled` | `false` | Active le stockage objet externe |
| `bucketPrefix` | aucun | Préfixe des noms de buckets (`<bucketPrefix>-<type>`) |
| `region` | aucun | Région S3 |
| `endpoint` | aucun | URL complète, schéma inclus |
| `pathStyle` | `true` | Adressage `path-style` ; `false` pour `virtual-host` |

Exemple :

```yaml
apiVersion: cloud-pi-native.fr/v1alpha
kind: DsoSocleConfig
metadata:
  name: conf-dso
spec:
  gitlab:
    s3ObjectStorage:
      enabled: true
      bucketPrefix: my-gitlab
      region: eu-west-1
      endpoint: https://s3.eu-west-1.example.com
      pathStyle: true
```

Identifiants :

- jamais dans la `dsc` : Vault d'infrastructure, app `gitlab`, clés `gitlab.s3ObjectStorage.accesskey` et `gitlab.s3ObjectStorage.secretkey` (à renseigner dans `/tmp/my-credentials.yaml`, voir [étape 7](../INSTALL.md#7-modification-des-secrets-dans-le-vault-dinfrastructure)) ;
- résolus au rendu par l'ArgoCD Vault Plugin dans les `Secret` `gitlab-object-storage` (connexion fog) et, si besoin, `gitlab-object-storage-s3cfg` (s3cmd du toolbox).

Buckets à **créer au préalable**, **sans règle de cycle de vie** (expiration, transition) : GitLab gère lui-même la durée de vie des objets, une suppression côté S3 casse les références en base.

| Bucket | Contenu | Bucket MinIO actuel |
| --- | --- | --- |
| `<bucketPrefix>-artifacts` | Artifacts CI | `gitlab-artifacts` |
| `<bucketPrefix>-lfs` | Objets Git LFS | `git-lfs` |
| `<bucketPrefix>-uploads` | Pièces jointes, avatars | `gitlab-uploads` |
| `<bucketPrefix>-packages` | Package registry | `gitlab-packages` |
| `<bucketPrefix>-mr-diffs` | Diffs externes des MR | `gitlab-mr-diffs` |
| `<bucketPrefix>-terraform-state` | États Terraform | `gitlab-terraform-state` |
| `<bucketPrefix>-ci-secure-files` | Fichiers sécurisés CI | `gitlab-ci-secure-files` |
| `<bucketPrefix>-dependency-proxy` | Dependency proxy | `gitlab-dependency-proxy` |
| `<bucketPrefix>-tmp` | Bucket temporaire de la restauration (toolbox) | `tmp` |
| `<bucketPrefix>-pages` | Sites GitLab Pages, seulement si `gitlab.pages.enabled` vaut `true` | `gitlab-pages` |
| `<bucketPrefix>-backups` | Sauvegardes toolbox, seulement si `global.backup.gitlab.enabled` vaut `false` | `gitlab-backups` |

Types optionnels :

- `externalDiffs`, `terraformState`, `ciSecureFiles` et `dependencyProxy` sont désactivés par défaut dans le chart : leurs buckets sont câblés mais l'activation reste inchangée ;
- pour en activer un, passer par `dsc.gitlab.values` :

```yaml
spec:
  gitlab:
    values:
      global:
        appConfig:
          terraformState:
            enabled: true
```

Sauvegardes (toolbox `backup-utility`) :

- `global.backup.gitlab.enabled: true` : bucket et `Secret` `gitlab-backup` inchangés (sauvegarde S3 globale). La même configuration s3cmd sert aussi à lire les buckets de données et `<bucketPrefix>-tmp` : même endpoint, et clé de sauvegarde avec droits sur **tous** les buckets GitLab ;
- `global.backup.gitlab.enabled: false` : sauvegardes dans `<bucketPrefix>-backups`, avec les identifiants du stockage objet (`Secret` `gitlab-object-storage-s3cfg`). Sans cela, le toolbox chercherait les identifiants du MinIO supprimé.

⚠️ **Aucune migration automatique** : activer le paramètre sur une instance existante fait perdre l'accès aux données déjà dans MinIO (artifacts, LFS, pièces jointes…). Avant de basculer :

- copier chaque bucket MinIO vers le bucket cible (tableau ci-dessus), avec `rclone sync` ou `mc mirror` ;
- limiter les écritures pendant la copie (fenêtre de maintenance), puis relancer une copie finale juste avant la bascule ;
- ne pas supprimer le volume MinIO avant d'avoir vérifié l'accès aux données dans GitLab.

```bash
mc mirror <alias-minio>/gitlab-artifacts <alias-s3>/<bucketPrefix>-artifacts
```

⚠️ **Proxy sortant** : si `dsc.proxy.enabled`, les pods GitLab joignent l'endpoint S3 via les variables `http(s)_proxy` ; l'endpoint ne doit pas figurer dans `no_proxy` s'il n'est joignable que par le proxy. Les `Secret` s3cmd (`gitlab-backup` et `gitlab-object-storage-s3cfg`) reprennent `proxy_host`/`proxy_port` depuis Vault (app `global`, clé `proxy`).

## GitLab Pages

Opt-in, désactivé par défaut (`dsc.gitlab.pages.enabled: false`) :

- `domain` (obligatoire) : domaine de base des sites, **pas un sous-domaine de l'hôte GitLab** (GitLab `gitlab.example.com` : `pages.example.com` convient, `pages.gitlab.example.com` non) ;
- enregistrement DNS wildcard `*.<domain>` et certificat TLS couvrant `<domain>` et `*.<domain>` (un wildcard via cert-manager impose un challenge DNS-01) ;
- `tlsSecretName` (optionnel) : par défaut `ingress.tls.tlsSecret.name` si `ingress.tls.type` vaut `tlsSecret`, sinon `gitlab-pages` ;
- le contenu des sites est stocké dans le stockage objet (MinIO embarqué, ou le bucket `<bucketPrefix>-pages` si `s3ObjectStorage` est activé) ;

```yaml
spec:
  gitlab:
    pages:
      enabled: true
      domain: pages.example.com
```

## GitLab Runner : user namespaces

`dsc.gitlabrunner.userNamespaces.enabled: true` (défaut `false`) exécute chaque pod de job dans son propre user namespace Kubernetes (`hostUsers: false`) : le conteneur de build peut être root dans le pod (ex. kaniko avec des étapes `RUN`) sans l'être sur le nœud.

- Prérequis : Kubernetes >= 1.33 et un runtime de conteneurs compatible user namespaces ;
- appliqué à tous les jobs du runner via un `pod_spec` du `config.toml`.

## Security contexts

Les composants GitLab portent des `securityContext` explicites (profil Pod Security Standard `restricted`), indépendants de toute politique d'admission :

- opérateur GitLab : `allowPrivilegeEscalation: false`, capabilities `ALL` retirées, `runAsNonRoot`, UID 65534, seccomp `RuntimeDefault` ;
- Gitaly et GitLab Runner : seccomp `RuntimeDefault` ;
- init containers de gitlab-shell, gitaly, gitlab-exporter et gitlab-pages : UID 1000 (celui du conteneur principal), pour que les secrets copiés restent lisibles ;
- exporter GitLab (`glexporter`) et CronJob de sauvegarde : non-root (UID 65534), pas d'élévation de privilèges, capabilities `ALL` retirées, seccomp `RuntimeDefault`.
