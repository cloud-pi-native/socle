# Trivy Operator

Scan de vulnérabilités cluster-wide optionnel, désactivé par défaut. Activé via `dsc.trivyOperator.installEnabled: true`. Il surveille les workloads du cluster et génère un `VulnerabilityReport` (CRD) par ressource scannée.

```yaml
apiVersion: cloud-pi-native.fr/v1alpha
kind: DsoSocleConfig
metadata:
  name: conf-dso
spec:
  trivyOperator:
    installEnabled: true
```

- `dsc.trivyOperator.namespace` (défaut `dso-trivy-operator`) : namespace du chart.
- Par défaut, seule la génération des `VulnerabilityReport` est activée (`operator.vulnerabilityScannerEnabled`). Les autres types de rapport (`ConfigAuditReport`, `RbacAssessmentReport`, `InfraAssessmentReport`, `ClusterComplianceReport`, `ExposedSecretReport`, `SbomReport`) sont désactivés pour limiter le volume stocké dans etcd. Ils peuvent être réactivés via `dsc.trivyOperator.values`.
- Aucun serveur Trivy dédié n'est déployé (`operator.builtInTrivyServer: false`) : chaque scan tourne en mode `Standalone`.
- Une seconde instance dupliquerait les scans et les rapports : `check-prerequisite` échoue si un déploiement Trivy Operator existe déjà dans le cluster. `dsc.trivyOperator.forcedInstall: true` permet de passer outre.

## Security context

Posé dans les values du composant, indépendamment de tout moteur de politique.

- **Opérateur** : `runAsNonRoot`, `seccompProfile: RuntimeDefault`, `allowPrivilegeEscalation: false`, `privileged: false`, `readOnlyRootFilesystem: true` et `capabilities.drop: [ALL]`.
- **Jobs de scan** : mêmes restrictions (pod et conteneur). L'image Trivy ne déclare pas d'utilisateur numérique : `runAsUser` et `runAsGroup` valent `10000`, sauf si `dsc.global.platform` vaut `openshift` (la plateforme attribue elle-même l'UID).
- Ces valeurs peuvent être ajustées via `dsc.trivyOperator.values`.

## Métriques

Si `dsc.global.metrics.enabled` est `true`, un `ServiceMonitor` est créé (CRD Prometheus Operator requises).

## Désinstallation

```bash
ansible-playbook uninstall.yaml -t trivy-operator
```

Supprime la release Helm puis le namespace (voir la section de désinstallation par outil de `INSTALL.md`).
