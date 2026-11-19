# Falco

Détection runtime optionnelle (avec Falcosidekick), désactivée par défaut. Activée via `dsc.falco.installEnabled: true`. Installe un DaemonSet avec un driver noyau et Falcosidekick pour transférer les événements.

```yaml
apiVersion: cloud-pi-native.fr/v1alpha
kind: DsoSocleConfig
metadata:
  name: conf-dso
spec:
  falco:
    installEnabled: true
    driver:
      kind: modern_ebpf
      leastPrivileged: true
    falcosidekick:
      enabled: true
```

- `dsc.falco.namespace` (défaut `dso-falco`) : namespace du chart.
- `dsc.falco.driver.kind` : `modern_ebpf` (défaut), `kmod` ou `auto`.
- `dsc.falco.driver.leastPrivileged` (défaut `true`) : avec `modern_ebpf`, l'agent reçoit des capabilities précises au lieu d'un conteneur privilégié. Sans effet pour les autres drivers.
- `dsc.falco.falcosidekick.enabled` (défaut `true`) : déploie Falcosidekick, sous-chart du même chart Helm.
- Les images sont tirées du registre configuré dans les values Vault de l'application `global`.

## Prérequis

- L'agent charge un driver noyau : il demande des montages `hostPath` et des privilèges. Le cluster ne doit pas appliquer de politique qui l'interdit sur le namespace de Falco.
- `modern_ebpf` exige un noyau récent compatible ; `kmod` demande les en-têtes du noyau ou un driver précompilé.
- Un seul Falco par nœud (le driver capte déjà tous les appels système) : `check-prerequisite` échoue si un DaemonSet Falco existe déjà ailleurs dans le cluster. `dsc.falco.forcedInstall: true` force une seconde installation.

## Security context

- **Falcosidekick** : `runAsNonRoot`, `seccompProfile: RuntimeDefault`, `allowPrivilegeEscalation: false` et `capabilities.drop: [ALL]`, posés dans les values du composant (indépendamment de tout moteur de politique).
- **Agent Falco (DaemonSet)** : le privilège minimal dépend du driver.
  - `modern_ebpf` + `leastPrivileged: true` (défaut) : capabilities dédiées à la place de `privileged: true`. Le profil seccomp n'est volontairement pas imposé au pod, au risque de bloquer l'appel système `bpf()`.
  - `kmod` : le conteneur reste privilégié (chargement du driver), pas d'alternative.
- Si `leastPrivileged` pose problème sur un noyau ou une distribution donnés, le passer à `false` rétablit le mode privilégié.

## Métriques

Si `dsc.global.metrics.enabled` est `true`, les métriques de Falco et de Falcosidekick sont exposées et un `ServiceMonitor` est créé pour chacun. Les CRD Prometheus Operator doivent être présentes.

## Désinstallation

```bash
ansible-playbook uninstall.yaml -t falco
```

Supprime la release Helm puis le namespace (voir la section de désinstallation par outil de `INSTALL.md`).
