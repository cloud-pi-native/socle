# SonarQube Community Build

Le socle déploie SonarQube Community Build avec le chart `sonarqube` de SonarSource. Cette page décrit ce qui dépend de la version du chart et les points d'attention lors d'une montée de version.

## Version déployée

Le curseur est `sonarqube.chartVersion` (valeur par défaut dans `releases.yaml`, surchargeable dans la DSC). Le tag de l'image suit le chart.

| Chart | SonarQube | Plugins |
| --- | --- | --- |
| `< 2025.6.0` | 24.12 et antérieur | `sonar-auth-oidc` 2.1.1, `sonarqube-community-branch-plugin` 1.23.0, `sonar-cnes-report` 5.0.0 |
| `>= 2025.6.0` | 25.12 | `sonar-auth-oidc` 3.0.0, `sonarqube-community-branch-plugin` 25.12.0, `sonar-cnes-report` 5.0.4 |
| `>= 2026.1.0` | 26.1 | idem, `sonarqube-community-branch-plugin` 26.1.0 |

Les templates (`roles/gitops/rendering-apps-files/templates/sonarqube/values/`) sont conditionnés par `chartVersion`. Un chart antérieur à `2025.6.0` garde le rendu historique.

## Rendu à partir du chart 2025.6.0

- `community.enabled: true` : sans lui, le chart déploie l'image d'une édition payante.
- Plugin de branches (tiers, non supporté par SonarSource) :
  - le jar est un `-javaagent`, déclaré par `sonar.web.javaAdditionalOpts` et `sonar.ce.javaAdditionalOpts` (ils s'ajoutent aux options par défaut, contrairement à `jvmOpts` et `jvmCeOpts`, dépréciés) ;
  - l'interface web du plugin remplace `/opt/sonarqube/web` : un init container (`download-webapp`, non-root, sans `chown`) la dépose dans un `emptyDir`.
- Les versions des plugins sont codées dans les templates, sans clé DSC. Le jar, le `-javaagent` et le webapp du plugin de branches doivent avoir la **même version**, alignée sur celle de SonarQube : les templates la déduisent de `chartVersion`.

### Mode hors-ligne

Le miroir indiqué par `sonarqube.pluginDownloadUrl` doit contenir les trois jars de plugins et `sonarqube-webapp-<version>.zip` (le `sonarqube-webapp.zip` du plugin de branches, renommé). Le registre d'images doit fournir `busybox:1.37`.

## Montée de version

- Une montée dans la même année civile est directe. Pour changer d'année, passer par la version de décembre.
- Ne pas sauter de palier sans lire les notes de version : des versions de PostgreSQL, de Java (serveur et scanners) et de plugins sont retirées au fil des versions.
- **Sauvegarder la base avant** : la migration du schéma n'est pas réversible.
- La migration est lancée par le job post-install (`/api/system/migrate_db`). Elle peut aussi l'être depuis `<url SonarQube>/setup`.
- Le StatefulSet est recréé par la synchronisation : aucun redémarrage manuel.

## Prérequis côté scanners

`sonar-cnes-report` 5.0.3 et suivants sont compilés pour Java 21 et font échouer tout scanner en Java 17 au chargement du plugin :

```text
The plugin [cnesreport] does not support Java 17: ... class file version 65.0
```

Utiliser Java 21 pour les analyses, ou rester sur `sonar-cnes-report` 5.0.2 (dernière version Java 17).
