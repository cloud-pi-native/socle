# Observabilité

L'application Argo CD `observability` regroupe Observatorium, Grafana (avec grafana-operator) et, en option, kube-state-metrics. Elle est déployée dès que l'un de ces composants est activé.

```yaml
apiVersion: cloud-pi-native.fr/v1alpha
kind: DsoSocleConfig
metadata:
  name: conf-dso
spec:
  observatorium:
    installEnabled: true
  kubeStateMetrics:
    installEnabled: true
```

## Observatorium et Grafana

- `dsc.observatorium.installEnabled` déploie Observatorium et Grafana (`dsc.grafana.namespace`). Les applications Argo CD et les values correspondantes ne sont générées que dans ce cas : kube-state-metrics seul n'a besoin d'aucune valeur dans Vault.
- Les instances Observatorium et Grafana sont nommées d'après l'application Argo CD (`<envName>-dso-observatorium`). L'URL interne d'Observatorium utilisée par Grafana et le sélecteur d'anti-affinité en dérivent.
- grafana-operator est limité à son namespace (`namespaceScope`). Avec plusieurs DSC sur un même cluster, chaque opérateur ne réconcilie que ses propres ressources Grafana.
- Le certificat de l'Ingress Grafana est émis par le `ClusterIssuer` de la plateforme :
  - la valeur de l'annotation `cert-manager.io/cluster-issuer` de `dsc.ingress.annotations`, si elle existe ;
  - sinon `acme-issuer` pour `dsc.ingress.tls.type: acme`, `ca-issuer` pour `ca` ;
  - sinon aucun `ClusterIssuer` n'est positionné (`tlsSecret`, `none`).

## kube-state-metrics

Exporteur de métriques sur l'état des objets Kubernetes, désactivé par défaut. Activé via `dsc.kubeStateMetrics.installEnabled: true`.

- `dsc.kubeStateMetrics.namespace` (défaut `dso-ksm`) : namespace du chart.
- `dsc.kubeStateMetrics.helmRepoUrl` : dépôt du chart (défaut `https://prometheus-community.github.io/helm-charts`).
- `dsc.kubeStateMetrics.values` : values Helm complémentaires, prioritaires sur celles du socle.
- Si `dsc.global.metrics.enabled` est `true`, un `ServiceMonitor` est créé (`honorLabels` activé pour conserver le namespace de l'objet mesuré). Les CRD Prometheus Operator doivent être présentes.

## Security context

- **Observatorium** (api, gubernator) : `runAsNonRoot`, `seccompProfile: RuntimeDefault`, `allowPrivilegeEscalation: false` et `capabilities.drop: [ALL]`.
- **Reverse proxy nginx** : mêmes réglages. Le système de fichiers racine reste en écriture, nginx écrit dans `/var/cache` et `/tmp`.
- **grafana-operator** : `allowPrivilegeEscalation: false`, `capabilities.drop: [ALL]`, `runAsNonRoot` et `seccompProfile: RuntimeDefault`, fusionnés avec les défauts du chart.
- Ces réglages demandent `observatorium` 0.6.0 et `dso-grafana` 1.9.0 (versions épinglées dans `releases.yaml`).

## Règles d'alerte

Les `PrometheusRule` de cert-manager et de CloudNativePG portent le label `app.kubernetes.io/name` de leur composant (`cert-manager`, `cloudnative-pg`).

## Désinstallation

```bash
ansible-playbook uninstall.yaml -t kubestatemetrics
```

Supprime le namespace de kube-state-metrics (voir la section de désinstallation par outil de `INSTALL.md`).
