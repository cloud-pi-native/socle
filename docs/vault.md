# Vault Secrets Operator (VSO)

Activé via `dsc.vso.installEnabled: true`. Déploie l'opérateur, une `VaultConnection` et une `VaultAuth` (AppRole) pointant vers un Vault existant — VSO consomme Vault, il n'en déploie pas.

```yaml
apiVersion: cloud-pi-native.fr/v1alpha
kind: DsoSocleConfig
metadata:
  name: conf-dso
spec:
  vso:
    installEnabled: true
    vault:
      approleMountPath: approle
```

## URL de Vault

`dsc.vso.vault.address` est optionnel :

- renseigné → utilisé tel quel (prioritaire) ;
- sinon, si `dsc.vault.installEnabled: true` sur ce DSC (même cluster) → `Service` interne de Vault en `http://` (le listener n'a pas de TLS, terminé à l'ingress) ;
- sinon (clusters séparés) → URL externe en `https://` déduite de `dsc.vault.domain` (ou `subDomain` + `infraRootDomain`).

Exemple avec Vault sur un cluster distinct :

```yaml
spec:
  vso:
    installEnabled: true
    vault:
      address: https://vault.tools.example.org   # optionnel : déduit sinon de vault.subDomain + infraRootDomain
      approleMountPath: approle
```

`dsc.vso.vault.skipTLSVerify` et `dsc.vso.vault.caCertSecretName` (Secret Kubernetes du namespace VSO) gèrent un Vault au certificat non reconnu publiquement.

Le `roleId`/`secretId` de l'AppRole ne sont jamais dans la `dsc` : déclarés dans `vault_values` (app `vso`), poussés dans Vault, résolus au rendu via le plugin AVP d'ArgoCD (`VaultAuth` et `Secret` `vso-approle-secret`).

⚠️ Le `secretId` doit déjà exister dans le Vault cible avant le premier rendu : VSO ne peut pas résoudre un secret porté par le Vault qu'il sert à déverrouiller.

Une seconde instance de VSO cause des conflits (`secrets.hashicorp.com`) : `check-prerequisite` échoue si l'API ou un déploiement VSO existe déjà. `dsc.vso.forcedInstall: true` pour forcer.

## Plusieurs DSC sur un même cluster (un seul opérateur, un Vault par DSC)

Un seul opérateur VSO par cluster. Une DSC qui réutilise l'opérateur déployé par une autre garde `installEnabled: false` et active uniquement sa connexion :

```yaml
spec:
  vso:
    installEnabled: false          # l'opérateur est celui d'une autre DSC du cluster
    namespace: my-dsc-vso        # unique par DSC sur le cluster
    vault:
      connectionEnabled: true      # rend VaultConnection + VaultAuth + Secret AppRole de cette DSC
      approleMountPath: approle-my-dsc   # un mount par DSC : évite la confusion entre DSC
```

- `connectionEnabled` vaut `installEnabled` par défaut (comportement historique inchangé). `false` avec `installEnabled: true` : opérateur seul, aucun `roleId`/`secretId` requis (DSC qui ne consomme aucun secret via VSO).
- `vso.namespace` doit être unique par DSC : les noms `vault-connection`, `vault-auth` et `vso-approle-secret` sont fixes, l'isolation est portée par le namespace. Les consommateurs référencent `<vso.namespace>/vault-auth` (`vaultAuthRef` des `VaultStaticSecret`).
- `allowedNamespaces` de la `VaultAuth` : liste explicite des namespaces des composants installés par la DSC dont le nom commence par `global.gitOps.namespacePrefix`, plus `dsc.vso.vault.allowedNamespaces`. VSO compare les noms à l'identique (seul `"*"` seul est un joker), un motif `<préfixe>*` n'est donc pas utilisable.
- Le `roleId`/`secretId` sont lus sous `env/<dsc>/apps/vso/values#vault` du Vault infra, comme pour l'opérateur.
- Images : le `manager` suit le registre `repository.docker` et le conteneur `kube-rbac-proxy` le registre `repository.quay` de l'application `global` (le chart le tire sinon de `quay.io`).

## VSO sur le cluster infra

⚠️ VSO doit rester désactivé (`dsc.vso.installEnabled: false`, défaut) sur le cluster infra : ses secrets transitent par le plugin AVP d'ArgoCD au rendu, pas par un opérateur vivant.

## Durcissement (securityContext)

Profil Pod Security `restricted`, rendu hors OpenShift (`dsc.global.platform: kubernetes`) sauf pour VSO :

- opérateur VSO : `runAsNonRoot`, `seccompProfile: RuntimeDefault`, `allowPrivilegeEscalation: false`, toutes les capabilities retirées (manager et `kube-rbac-proxy`) ;
- serveur et injecteur Vault : `seccompProfile: RuntimeDefault` en plus de `runAsNonRoot`/`fsGroup` ; capabilities retirées sur le serveur (pas d'`IPC_LOCK` : le chart force `disable_mlock = true`) ;
- job de sauvegarde Vault : uid 100 / gid 1000 explicites (l'image déclare l'utilisateur `vault`, non numérique, incompatible avec `runAsNonRoot`), `seccompProfile: RuntimeDefault`, capabilities retirées.
