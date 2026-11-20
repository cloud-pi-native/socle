# Velero (sauvegarde)

Le socle peut installer le serveur Velero (controller, CRDs, node-agent optionnel) utilisé par le chart `dso-backup`. Sans Velero, les `Schedule`/`Backup` créés par `dso-backup` n'ont aucun effet.

Deux flags distincts, à activer **ensemble** :

- `dsc.velero.installEnabled` (défaut `false`) : installe le serveur Velero dans `dsc.velero.namespace` (défaut `dso-backup`).
- `dsc.global.backup.velero.enabled` : active la dépendance Helm `dso-backup` de chaque application.

Si `dsc.velero.installEnabled` est `false`, le socle ne déploie rien et suppose qu'un Velero existe déjà : le rendu des chart `dso-backup` reste celui d'avant.

Exemple minimal :

```yaml
spec:
  velero:
    installEnabled: true
    region: <region>   # obligatoire
  global:
    backup:
      s3:
        enabled: true
      velero:
        enabled: true
        retentionPolicy: 14d
```

## Stockage S3

- Le `BackupStorageLocation` pointe vers le bucket décrit par `dsc.global.backup.s3` (endpoint, bucket et clés lus dans les values Vault de l'application `global`).
- Seul le provider `aws` est câblé, y compris pour un stockage S3-compatible (URL personnalisée).
- `dsc.velero.region` est **obligatoire** : le plugin AWS exige une région même en S3-compatible.
- `dsc.velero.s3ForcePathStyle` (défaut `true`) : URL de la forme `https://endpoint/bucket/...`.
- `dsc.velero.pathPrefix` (défaut `velero`) : sous-dossier du bucket réservé à Velero. Il doit différer de tout `dsc.global.backup.*.pathPrefix` : Velero passe le `BackupStorageLocation` en `Unavailable` si la racine du préfixe contient d'autres dossiers.
- `dsc.velero.storageLocationName` (défaut `default`) : nom du `BackupStorageLocation`, repris par les chart `dso-backup`.
- Les identifiants sont ceux de l'application `global` (Secret `velero-s3-credentials`, format attendu par le plugin AWS).

## Rétention

`dsc.global.backup.velero.retentionPolicy` (défaut `14d`) fixe le TTL des `Backup`. Une valeur en jours est convertie en heures pour Velero.

## Node-agent (sauvegarde de volumes)

- `dsc.velero.nodeAgent.enabled` (défaut `false`) déploie le node-agent pour la sauvegarde de volumes au niveau fichier.
- Stratégie `vault` : les données sont protégées par le snapshot raft envoyé sur S3 par le pré-hook. `defaultVolumesToFsBackup` suit `nodeAgent.enabled` : sans node-agent, une copie de volumes ferait terminer chaque `Backup` en `PartiallyFailed`.
- Sécurité : le node-agent lit les volumes des pods sur l'hôte et garde donc l'utilisateur root du chart. Il tourne avec `allowPrivilegeEscalation: false` et le profil seccomp `RuntimeDefault` ; ses capabilities ne sont pas retirées, sinon il ne pourrait plus lire les fichiers appartenant à d'autres uid.

## Snapshots CSI

`dsc.velero.volumeSnapshots.enabled` (défaut `false`) sauvegarde les PVC par snapshots CSI, via le plugin CSI intégré à Velero (aucun node-agent requis). Quand il est actif :

- Velero démarre avec `EnableCSI` (sans ce flag, les `Backup` terminent en `Completed` sans aucun snapshot) ;
- les `Backup` des applications passent à `snapshotVolumes: true` et `defaultVolumesToFsBackup: false` (la stratégie `vault` n'est pas concernée) ;
- une `VolumeSnapshotClass` dédiée est créée (`className`, défaut `velero-csi-snapshot`, `deletionPolicy: Retain`, label `velero.io/csi-volumesnapshot-class: "true"`). `driver` est **obligatoire** et doit correspondre au provisioner de la `StorageClass` ;
- avec `createClass: false`, aucune classe n'est créée : une classe existante doit porter le label à la main. Velero n'accepte qu'une classe étiquetée par driver.

Prérequis et limites :

- le driver CSI doit gérer les snapshots et un snapshot controller doit être présent ;
- les snapshots restent chez le fournisseur de stockage : ils ne remplacent pas une copie hors plateforme ;
- les snapshots sont crash-consistent : les bases CNPG gardent leur sauvegarde Barman ;
- ne pas combiner avec le `fs-backup` du node-agent sur les mêmes volumes ;
- restauration : avec une `StorageClass` en `WaitForFirstConsumer`, restaurer aussi le pod ou le StatefulSet consommateur dans le même `Restore` (un PVC restauré seul peut rester `Pending`).

## Prérequis à l'installation

`check-prerequisite` échoue si l'API `velero.io/v1` ou un déploiement `app.kubernetes.io/name=velero` existe déjà (`dsc.velero.forcedInstall: true` pour passer outre), si `region` est vide, ou si `volumeSnapshots.driver` est vide alors que la classe doit être créée.

## Versions et désinstallation

- Version du chart Velero : `releases.yaml` (`velero.chartVersion`) ; version déployée : `admin-tools/get-versions.yaml` (tag `velero`).
- Désinstallation : tag `velero` de `uninstall.yaml`.
