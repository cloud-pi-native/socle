# SonarQube Community Build

Le socle déploie SonarQube Community Build avec le chart `sonarqube` de SonarSource. Cette page décrit ce qui dépend de la version du chart et la procédure de montée de version.

## Version déployée

Le curseur est `sonarqube.chartVersion` (valeur par défaut dans `releases.yaml`, surchargeable dans la DSC).

- Le défaut reste le chart **`10.8.1`** (SonarQube Community Build 24.12). Une DSC qui ne définit pas `sonarqube.chartVersion` ne change donc pas de version.
- La montée de version se fait **uniquement en posant `sonarqube.chartVersion` dans la DSC**, au moment choisi (sauvegarde faite, coupure annoncée) : voir [Montée de version](#montée-de-version).

| `chartVersion` | SonarQube | `sonar-auth-oidc` | `sonarqube-community-branch-plugin` | `sonar-cnes-report` |
| --- | --- | --- | --- | --- |
| `< 2025.6.0` (défaut `10.8.1`) | 24.12.0.100206 | 2.1.1 | 1.23.0 | 5.0.0 |
| `2025.6.x` | 25.12.0.117093 | 3.0.0 | 25.12.0 | 5.0.4 |
| `2026.1.x` | 26.1.0.118079 | 3.0.0 | 26.1.0 | 5.0.4 |
| `2026.5.x` | **26.10.0.133078** (le chart déploie 26.9 par défaut) | 3.0.0 | 26.10.0 | 5.0.5 |

À partir du chart `2025.6.0`, ces versions sont définies dans une seule table : `sonarqube_community_builds` dans `roles/gitops/rendering-apps-files/vars/main.yaml`, indexée par série de chart (`<année>.<mois>`). Le socle fixe la version de SonarQube (`community.buildNumber`) au lieu de laisser celle du chart, parce que le plugin de branches doit avoir **exactement** la même version.

Une série de chart absente de la table fait **échouer le render**, avec un message explicite. Pour supporter un nouveau chart, ajouter une entrée après avoir vérifié qu'une version du plugin de branches existe pour la version de SonarQube visée.

Ne pas surcharger `community.buildNumber` dans `sonarqube.values` : le plugin de branches ne suivrait pas.

## Rendu à partir du chart 2025.6.0

- `community.enabled: true` : sans lui, le chart déploie l'image d'une édition payante.
- `community.buildNumber` : la version de SonarQube de la table ci-dessus.
- Plugin de branches (tiers, non supporté par SonarSource) :
  - le jar est un `-javaagent`, déclaré par `sonar.web.javaAdditionalOpts` et `sonar.ce.javaAdditionalOpts`. Ces propriétés s'ajoutent aux options par défaut, contrairement à `jvmOpts` et `jvmCeOpts`, dépréciés ;
  - l'interface web du plugin remplace `/opt/sonarqube/web` : un init container (`download-webapp`, non-root, sans `chown`) la dépose dans un `emptyDir`.
- Le jar, le `-javaagent` et la webapp du plugin de branches ont la même version, tirée de la table.
- Mitigation CVE-2026-114938 : `-XX:-UseBASE64Intrinsics` est ajouté à `sonar.web.javaAdditionalOpts`, `sonar.ce.javaAdditionalOpts` et `sonar.search.javaAdditionalOpts`, comme dans le rendu historique (`jvmOpts`, `jvmCeOpts`). À conserver tant que le JDK de l'image n'est pas corrigé.

Quand les métriques sont activées (`global.metrics.enabled`), le chart met le javaagent Prometheus dans `SONAR_WEB_JAVAOPTS` et `SONAR_CE_JAVAOPTS`. Ces variables **remplacent** les tailles de heap par défaut de SonarQube : chaque JVM prend alors la taille par défaut de Java (1/4 de la limite mémoire du conteneur). C'est déjà le cas avec le chart `10.8.1`.

### Mode hors-ligne

Pour chaque version déployée, le miroir indiqué par `sonarqube.pluginDownloadUrl` doit contenir les trois jars de plugins et `sonarqube-webapp-<version>.zip`, c'est-à-dire le `sonarqube-webapp.zip` du plugin de branches, renommé. Le registre d'images doit fournir `busybox:1.37` et l'image `sonarqube:<buildNumber>-community` de chaque étape.

## Montée de version

### Chemin

À l'intérieur d'une même année, la montée vers n'importe quelle version est directe. Pour changer d'année, il faut passer par la version de décembre. SonarSource recommande en plus de passer par 26.1, à cause d'un bug de la 25.12 sur certaines bases.

Depuis le défaut `10.8.1` (24.12), les étapes sont donc :

| Étape | `sonarqube.chartVersion` | SonarQube |
| --- | --- | --- |
| 1 | `2025.6.1` | 25.12.0.117093 |
| 2 | `2026.1.8` | 26.1.0.118079 |
| 3 | `2026.5.1005` | 26.10.0.133078 |

Le serveur peut rester sur les étapes intermédiaires juste le temps de la migration de la base.

### Avant

- **Sauvegarder la base** (cluster CNPG `pg-cluster-sonar`, par exemple `kubectl cnpg backup pg-cluster-sonar`) et vérifier que la sauvegarde est restaurable. Les migrations de schéma ne sont pas réversibles.
- Prévenir les équipes et suspendre les analyses pendant la coupure.
- Scanners : **Java 21 obligatoire** à partir de 26.8 (et dès 25.12 avec `sonar-cnes-report` ≥ 5.0.3, voir plus bas). La propriété `sonar.password` n'existe plus depuis 25.2 : utiliser `sonar.token`.
- Hors-ligne : remplir le miroir et le registre pour chaque étape (voir plus haut).
- Prévoir du temps et de la CPU : la 26.8 embarque Elasticsearch 9 et réindexe tout au premier démarrage. Sur une grosse instance, augmenter temporairement les ressources via `sonarqube.values.resources`.

### Pour chaque étape

1. Poser `sonarqube.chartVersion` dans la DSC, faire le render, puis synchroniser l'application SonarQube dans Argo CD. Le StatefulSet est recréé : aucun redémarrage manuel n'est nécessaire.
2. Le job post-install déclenche la migration du schéma (`/api/system/migrate_db`), puis attend l'état du serveur (`/api/system/status`). La migration peut aussi être lancée à la main depuis `<url SonarQube>/setup`.
3. Vérifier que `/api/system/status` renvoie `UP` et que l'interface s'affiche. Comme le plugin de branches remplace l'interface web, un échec de l'init container `download-webapp` se voit au démarrage du pod.
4. Vérifier la connexion SSO et la présence des trois plugins, aux versions de la table, dans l'administration.

À la fin, lancer une analyse de branche et une analyse de MR avec un scanner Java 21.

### Retour arrière

Le schéma migré n'est pas lisible par une version antérieure. Pour revenir en arrière :

1. Remettre l'ancienne `sonarqube.chartVersion` dans la DSC.
2. **Restaurer la sauvegarde** faite avant la montée, sur un nouveau cluster CNPG en `recovery` ou par `pg_restore`.
3. Les données Elasticsearch sont dans un `emptyDir` : elles sont reconstruites au redémarrage.

## Prérequis côté scanners

`sonar-cnes-report` 5.0.3 et suivants sont compilés pour Java 21 et font échouer tout scanner en Java 17 au chargement du plugin :

```text
The plugin [cnesreport] does not support Java 17: ... class file version 65.0
```

À partir de SonarQube 26.8, Java 17 n'est de toute façon plus supporté pour les scanners. Utiliser Java 21 pour les analyses.
