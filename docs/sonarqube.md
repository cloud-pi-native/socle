# SonarQube Community Build

Le socle déploie SonarQube Community Build avec le chart `sonarqube` de SonarSource. Cette page décrit ce qui dépend de la version du chart et les points d'attention lors d'une montée de version.

## Version déployée

Le curseur est `sonarqube.chartVersion` (valeur par défaut dans `releases.yaml`, surchargeable dans la DSC). Le tag de l'image suit le chart.

- Le défaut est le chart **`2025.6.0`** (SonarQube Community Build 25.12.0). Il remplace le chart `10.8.1` utilisé jusqu'ici.
- Une DSC qui ne définit pas `sonarqube.chartVersion` passe donc sur la nouvelle version à la prochaine synchronisation : voir [Migration depuis le chart 10.8.1](#migration-depuis-le-chart-1081).

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

## Migration depuis le chart 10.8.1

### Avant

- Chemin de montée : la montée directe de la 10.8.1 vers la 25.12 est supportée (changement de numérotation des versions, par année).
- Vérifier les versions de PostgreSQL et de Java (serveur et scanners) supportées par 25.12 ; les scanners doivent passer en Java 21 (voir plus bas).
- Hors-ligne : déposer sur le miroir `sonarqube.pluginDownloadUrl` les trois jars de plugins et `sonarqube-webapp-<version>.zip` (voir plus haut), et rendre `busybox:1.37` disponible dans le registre d'images.
- **Sauvegarder la base** (cluster CNPG de SonarQube) : la migration du schéma n'est pas réversible. Vérifier que la sauvegarde est restaurable.

### Migration

- Ne pas définir `sonarqube.chartVersion` dans la DSC (ou le poser à `2025.6.0`) et lancer la synchronisation Argo CD de l'application SonarQube.
- Le StatefulSet est recréé par la synchronisation : aucun redémarrage manuel.
- Le job post-install déclenche la migration du schéma (`/api/system/migrate_db`) puis attend l'état du serveur (`/api/system/status`). Elle peut aussi être lancée à la main depuis `<url SonarQube>/setup`.

### Après

- Vérifier que `/api/system/status` renvoie `UP` et que l'interface charge (le plugin de branches remplace l'interface web : un échec du init container `download-webapp` se voit au démarrage du pod).
- Vérifier la connexion SSO (plugin `sonar-auth-oidc` 3.0.0) et la présence des trois plugins dans l'administration.
- Lancer une analyse sur un projet de test, avec Java 21.

### Retour arrière

- Le schéma de base migré n'est pas lisible par l'ancienne version : revenir en arrière suppose de **restaurer la sauvegarde** faite avant la migration.
- Pour rester sur l'ancien chart sans migrer, poser explicitement `sonarqube.chartVersion: 10.8.1` dans la DSC : le rendu historique est conservé pour tout chart `< 2025.6.0`. À faire **avant** la première synchronisation avec ce défaut.

## Montée de version ultérieure

- Une montée dans la même année civile est directe. Pour changer d'année, passer par la version de décembre.
- Ne pas sauter de palier sans lire les notes de version : des versions de PostgreSQL, de Java (serveur et scanners) et de plugins sont retirées au fil des versions.
- Les versions de plugins suivent `chartVersion` (table ci-dessus) : rien d'autre à renseigner, sauf le miroir hors-ligne.
- Même procédure que ci-dessus : sauvegarde, synchronisation, migration, vérifications.

## Prérequis côté scanners

`sonar-cnes-report` 5.0.3 et suivants sont compilés pour Java 21 et font échouer tout scanner en Java 17 au chargement du plugin :

```text
The plugin [cnesreport] does not support Java 17: ... class file version 65.0
```

Utiliser Java 21 pour les analyses, ou rester sur `sonar-cnes-report` 5.0.2 (dernière version Java 17).
