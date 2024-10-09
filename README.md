# Installation de la plateforme Cloud π Native <!-- omit in toc -->

## Sommaire <!-- omit in toc -->

- [Introduction](#introduction)
- [Prérequis](#prérequis)
- [Configuration](#configuration)
  - [Utilisation de vos propres values](#utilisation-de-vos-propres-values)
- [Installation](#installation)
  - [Lancement](#lancement)
  - [Déploiement de plusieurs forges DSO dans un même cluster](#déploiement-de-plusieurs-forges-dso-dans-un-même-cluster)
- [Récupération des secrets](#récupération-des-secrets)
- [Debug](#debug)
  - [Réinstallation](#réinstallation)
  - [AWX Operator et instance AWX](#awx-operator-et-instance-awx)
  - [Cert-manager](#cert-manager)
  - [CloudNativePG](#cloudnativepg)
  - [GitLab Operator](#gitlab-operator)
  - [Grafana Operator et instance Grafana](#grafana-operator-et-instance-grafana)
  - [Kyverno](#kyverno)
  - [Kubed (config-syncer)](#kubed-config-syncer)
  - [Prometheus](#prometheus)
- [Désinstallation](#désinstallation)
  - [Chaîne complète](#chaîne-complète)
  - [Désinstaller un ou plusieurs outils](#désinstaller-un-ou-plusieurs-outils)
- [Gel des versions](#gel-des-versions)
  - [Introduction](#introduction-1)
  - [Modification des versions de charts](#modification-des-versions-de-charts)
  - [Gel des versions d'images](#gel-des-versions-dimages)
    - [Argo CD](#argo-cd)
    - [Cert-manager](#cert-manager-1)
    - [CloudNativePG](#cloudnativepg-1)
    - [Console Cloud π Native](#console-cloud-π-native)
    - [GitLab](#gitlab)
    - [GitLab CI pipelines exporter](#gitlab-ci-pipelines-exporter)
    - [GitLab Runner](#gitlab-runner)
    - [Harbor](#harbor)
    - [Instance AWX](#instance-awx)
    - [Instance Grafana](#instance-grafana)
    - [Keycloak](#keycloak)
    - [Kyverno](#kyverno-1)
    - [Sonatype Nexus Repository](#sonatype-nexus-repository)
    - [SonarQube Community Edition](#sonarqube-community-edition)
    - [Vault](#vault)
- [Backups](#backups)
- [Offline / air gap](#offline--air-gap)
- [Platform](#platform)
- [Profile CIS](#profile-cis)
- [Utilisation de credentials Docker Hub pour le pull des images](#utilisation-de-credentials-docker-hub-pour-le-pull-des-images)
- [Contributions](#contributions)
  - [Les commandes de l'application](#les-commandes-de-lapplication)
  - [Conventions](#conventions)

## Introduction

L'installation de la plateforme Cloud π Native (aussi appelée `DSO` pour `DevSecOps`) s'effectue de manière automatisée avec **Ansible**.

Les éléments déployés seront les suivants :

| Outil                                | Site officiel                                                                                                                                               |
| ------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Argo CD                              | <https://argo-cd.readthedocs.io>                                                                                                                            |
| AWX-Operator (optionnel)             | <https://github.com/ansible/awx-operator>                                                                                                                   |
| Cert-manager                         | <https://cert-manager.io>                                                                                                                                   |
| CloudNativePG                        | <https://cloudnative-pg.io>                                                                                                                                 |
| Console Cloud π Native               | <https://github.com/cloud-pi-native/console>                                                                                                                |
| GitLab                               | <https://about.gitlab.com>                                                                                                                                  |
| gitLab-ci-catalog                    | <https://github.com/cloud-pi-native/gitlab-ci-catalog>                                                                                                      |
| gitLab-ci-pipelines-exporter         | <https://github.com/mvisonneau/helm-charts/tree/main/charts/gitlab-ci-pipelines-exporter>                                                                   |
| GitLab Operator                      | <https://docs.gitlab.com/operator>                                                                                                                          |
| GitLab Runner                        | <https://docs.gitlab.com/runner>                                                                                                                            |
| Grafana (optionnel)                  | <https://grafana.com>                                                                                                                                       |
| Grafana Operator (optionnel)         | <https://grafana.github.io/grafana-operator/>                                                                                                               |
| Harbor                               | <https://goharbor.io>                                                                                                                                       |
| HashiCorp Vault                      | <https://www.vaultproject.io>                                                                                                                               |
| Keycloak                             | <https://www.keycloak.org>                                                                                                                                  |
| Kyverno                              | <https://kyverno.io>                                                                                                                                        |
| Prometheus Operator CRDs (optionnel) | <https://github.com/prometheus-operator/prometheus-operator/releases><br>Fichier `stripped-down-crds.yaml`<br>Disponible dans les Assets de chaque version. |
| SonarQube Community Edition          | <https://www.sonarsource.com/open-source-editions/sonarqube-community-edition>                                                                              |
| Sonatype Nexus Repository            | <https://www.sonatype.com/products/sonatype-nexus-repository>                                                                                               |

Certains outils peuvent prendre un peu de temps pour s'installer. Ce sera le cas de Keycloak, Nexus, SonarQube et en particulier GitLab.

Vous pouvez trouver la version des outils installés dans le fichier [versions.md](versions.md).

Comme précisé dans le tableau ci-dessus, certains éléments sont optionnels :
* L'opérateur AWX et l'instance AWX ne s'installeront que sur demande explicite, via l'utilisation des tags appropriés. Ceci afin de vous permettre d'opter ou non pour cette solution pour gérer vos serveurs distants.
* L'opérateur Grafana et l'instance Grafana ne s'installeront que sur demande explicite, via l'utilisation des tags appropriés. Ceci afin de vous permettre d'opter ou non pour cette solution d'affichage des métriques.
* Les CRDs de l'opérateur Prometheus ne s'installent que s'il est déjà présent dans le cluster (paramètre `managed` dans notre configuration).

## Prérequis

Cette installation s'effectue par défaut dans un cluster [OpenShift](https://www.redhat.com/fr/technologies/cloud-computing/openshift) opérationnel et correctement démarré.

La plateforme [Kubernetes](https://kubernetes.io/fr/) ([vanilla](https://fr.wikipedia.org/wiki/Logiciel_vanilla)) est également supportée si besoin, via l'option de configuration `global.platform` (cf. section [Configuration](#configuration) ci-dessous).

Vous devrez disposer d'un **accès administrateur au cluster**.

Vous aurez besoin d'une machine distincte du cluster, tournant sous GNU/Linux avec une distribution de la famille Debian ou Red Hat. Cette machine vous servira en tant qu'**environnement de déploiement** [Ansible control node](https://docs.ansible.com/ansible/latest/network/getting_started/basic_concepts.html#control-node). Elle nécessitera donc l'installation d'[Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html), et plus précisément du paquet **ansible**, pour disposer au moins de la commande `ansible-playbook` ainsi que de la collection [community.general](https://github.com/ansible-collections/community.general).

Toujours sur votre environnement de déploiement, vous devrez :

- Clôner le présent [dépôt](https://github.com/cloud-pi-native/socle).
- Disposer d'un fichier de configuration `~/.kube/config` paramétré avec les accès administrateur, pour l'appel à l'API du cluster (section users du fichier en question).

L'installation de la suite des prérequis **sur l'environnement de déploiement** s'effectue à l'aide du playbook nommé `install-requirements.yaml`. Il est mis à disposition dans le répertoire `admin-tools` du dépôt socle que vous aurez clôné.

Si l'utilisateur avec lequel vous exécutez ce playbook dispose des droits sudo sans mot de passe (option `NOPASSWD` du fichier sudoers), vous pourrez le lancer directement sans options :

```bash
ansible-playbook admin-tools/install-requirements.yaml
```

Sinon, vous devrez utiliser l'option `-K` (abréviation de l'option `--ask-become-pass`) qui vous demandera le mot de passe sudo de l'utilisateur :

```bash
ansible-playbook -K admin-tools/install-requirements.yaml
```

Pour information, le playbook `install-requirements.yaml` vous installera les éléments suivants **sur l'environnement de déploiement** :

- Paquet requis pour l'installation des modules python :
  - python3-pip

- Paquets requis pour l'installation du gestionnaire de paquets Homebrew :
  - git
  - ruby
  - tar

- Modules python requis par certains modules Ansible :
  - pyyaml
  - kubernetes
  - python-gitlab
  - jmespath

- Collection Ansible [kubernetes.core](https://github.com/ansible-collections/kubernetes.core) si elle n'est pas déjà présente.

- Gestionnaire de paquets [Homebrew](https://brew.sh/) pour une installation simplifiée des prérequis restants sur la plupart des distributions GNU/Linux utilisables en production. Testé sous Debian, Ubuntu, Red Hat Enterprise Linux et Rocky Linux.

- Commandes installées avec Homebrew :
  - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
  - [helm](https://helm.sh/docs/intro/install/)
  - [yq](https://github.com/mikefarah/yq/#install) (Facultative mais utile pour debug.)

## Configuration

Lorsque vous avez cloné le présent dépôt socle, lancez une première fois la commande suivante depuis votre environnement de déploiement :

```bash
ansible-playbook install.yaml
```

Elle vous signalera que vous n'avez encore jamais installé le socle sur votre cluster, puis vous invitera à modifier la ressource de scope cluster et de type **dsc** nommée **conf-dso** via la commande suivante :

```bash
kubectl edit dsc conf-dso
```

Vous pourrez procéder comme indiqué si vous le souhaitez, mais pour des raisons de traçabilité et de confort d'édition vous préférerez peut-être déclarer la ressource `dsc` nommée `conf-dso` dans un fichier YAML, par exemple « ma-conf-dso.yaml », puis la créer via la commande suivante :

```bash
kubectl apply -f ma-conf-dso.yaml
```

Pour vous aider à démarrer, le fichier [cr-conf-dso-default.yaml](roles/socle-config/files/cr-conf-dso-default.yaml) est un **exemple** de configuration également utilisé lors de la première installation. Il surcharge les valeurs par défaut des fichiers [config.yaml](roles/socle-config/files/config.yaml) et [releases.yaml](roles/socle-config/files/releases.yaml). Ce fichier doit être adapté à partir de la section **spec**, en particulier pour les éléments suivants :
* du paramètre `global.rootDomain` (votre domaine principal précédé d'un point),
* des mots de passe de certains outils,
* du paramètre `global.platform` (définir à `kubernetes` si vous n'utilisez pas OpenShift),
* de la taille de certains PVCs,
* de l'activation ou non des métriques,
* du proxy si besoin ainsi que des sections CA et ingress.

Les champs utilisables dans cette ressource de type **dsc** peuvent être décrits pour chaque outil à l'aide de la commande `kubectl explain`. Exemple avec ArgoCD :

```shell
kubectl explain dsc.spec.argocd
```

Les valeurs des helm charts peuvent être surchargés en ajoutant le paramètre `values` au service concerné. Ces `values` dépendent de la [version du helm chart](versions.md) et peuvent être consultés avec la command `helm show values`. Exemple avec l'opérateur GitLab :

```shell
helm show values gitlab-operator/gitlab-operator --version 1.1.2
```

Avant de relancer l'installation avec la dsc configurée, n'hésitez pas à lancer la commande ci-dessus pour obtenir la description de tout champ sur lequel vous avez un doute.

### Utilisation de vos propres values

Comme nous pouvons le voir dans l'exemple de configuration fourni ci-dessus, plusieurs outils sont notamment configurés à l'aide d'un champ `values`.

Il s'agit de valeurs de chart [Helm](https://helm.sh/fr). Vous pouvez les utiliser ici pour surcharger les valeurs par défaut.

Voici les liens vers les documentations de chart Helm pour les outils concernés :

- [Argo CD](https://github.com/bitnami/charts/tree/main/bitnami/argo-cd)
- [Console Cloud π Native](https://github.com/cloud-pi-native/console#readme)
- [GitLab](https://gitlab.com/gitlab-org/charts/gitlab)
- [Harbor](https://github.com/goharbor/harbor-helm)
- [Keycloak](https://github.com/bitnami/charts/tree/main/bitnami/keycloak)
- [SonarQube](https://github.com/bitnami/charts/tree/main/bitnami/sonarqube)
- [HashiCorp Vault](https://github.com/hashicorp/vault-helm)

S'agissant du gel des versions de charts ou d'images pour les outils en question, **nous vous invitons fortement à consulter la section détaillée [Gel des versions](#gel-des-versions)** située plus bas dans le présent document.

## Installation

### Lancement

Dès que votre [configuration](#configuration) est prête, c'est-à-dire que la ressource `dsc` par défaut  `conf-dso` a bien été mise à jour avec les éléments nécessaires et souhaités, relancez la commande suivante :

```bash
ansible-playbook install.yaml
```

Patientez …

Pendant l'installation, vous pourrez surveiller l'arrivée des namespaces correspondants dans le cluster, via la commande suivante :

```bash
watch "kubectl get ns | grep 'dso-'"
```

Par défaut, ils sont en effet tous préfixés « dso- ».

### Déploiement de plusieurs forges DSO dans un même cluster

Suite à une première installation réussie et selon vos besoins, il est possible, selon sa capacité, d'installer dans un même cluster une ou plusieurs autres forges DSO, en parallèle de celle installée par défaut.

Pour cela, il vous suffit de déclarer une **nouvelle ressource de type dsc dans le cluster**, en la nommant différemment de la ressource `dsc` par défaut qui pour rappel se nomme `conf-dso`, et en y modifiant les éléments souhaités.

Comme vu plus haut dans la section [Configuration](#configuration), déclarez votre ressource de type `dsc` personnalisée **dans un fichier YAML**.

Il s'agira simplement de **modifier le nom de la ressource dsc** (section `metadata`, champ `name`) puis **adapter les paramètres souhaités** (mots de passe, ingress, CA, proxy, values …).

Pensez également à déclarer pour chaque outil **un `namespace` et un `subDomain` différents** de ceux déjà déclarés lors de la première installation du socle DSO.

Exemple pour Argo CD :

```yaml
argocd:
  namespace: mynamespace-argocd
  subDomain: argocd-perso
  admin:
    enabled: true
    password: PasswordForEveryone
```

Pour mémoire, les namespaces et subDomains par défaut, déclarés lors de la première installation du socle, peuvent être listés en se positionnant préalablement dans le répertoire socle, puis en affichant le fichier « config.yaml » du role socle-config, exemple en ligne de commande :

```bash
cat ./roles/socle-config/files/config.yaml
```

Lorsque votre nouvelle configuration est prête, et déclarée par exemple dans le fichier « ma-conf-perso.yaml », créez-la dans le cluster comme ceci :

```bash
kubectl apply -f ma-conf-perso.yaml
```

Vous pourrer ensuite la retrouver via la commande :

```bash
kubectl get dsc
```

Puis éventuellement l'afficher (exemple avec une `dsc` nommée `ma-dsc`) :

```bash
kubectl get dsc ma-dsc -o yaml
```

Dès lors, il vous sera possible de déployer une nouvelle chaîne DSO dans ce cluster, en plus de celle existante. Pour cela, vous utiliserez l'[extra variable](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#defining-variables-at-runtime) Ansible prévue à cet effet, nommée `dsc_cr` (pour DSO Socle Config Custom Resource).

Par exemple, si votre nouvelle ressource `dsc` se nomme `ma-dsc`, alors vous lancerez l'installation correspondante comme ceci :

```bash
ansible-playbook install.yaml -e dsc_cr=ma-dsc
```

Pendant l'installation, et si vous avez nommé vos namespaces en utilisant un même suffixe ou préfixe, vous pourrez surveiller l'arrivée de ces namespaces dans le cluster.

Exemple avec des namespaces préfixés `mynamespace-` :

```bash
watch "kubectl get ns | grep 'mynamespace-'"
```

Exemple avec des namespaces dont le suffixe est `-mynamespace` :

```bash
watch "kubectl get ns | grep '\-mynamespace'"
```

## Récupération des secrets

Au moment de leur initialisation, certains outils stockent des secrets qui ne sont en principe plus disponibles ultérieurement.

**Attention !** Pour garantir l'[idempotence](https://fr.wikipedia.org/wiki/Idempotence), ces secrets sont stockés dans plusieurs ressources du cluster. Supprimer ces ressources **indique à Ansible qu'il doit réinitialiser les composants associés**.

Afin de faciliter la récupération des secrets, un playbook d'administration nommé `get-credentials.yaml` est mis à disposition dans le répertoire `admin-tools/`.

Pour le lancer :

```bash
ansible-playbook admin-tools/get-credentials.yaml
```

Ce playbook permet également de cibler un outil en particulier, grâce à l'utilisation de tags qui sont listés au début de l'exécution, exemple avec keycloak :

```bash
ansible-playbook admin-tools/get-credentials.yaml -t keycloak
```

Enfin, dans le cas où plusieurs chaînes DSO sont déployées dans le même cluster, il permet de cibler la chaîne DSO voulue via l'utilisation de l'[extra variable](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#defining-variables-at-runtime) `dsc_cr`, exemple avec une chaîne utilisant la `dsc` nommée `ma-conf` :

```bash
ansible-playbook admin-tools/get-credentials.yaml -e dsc_cr=ma-conf
```

Et bien sûr cibler un ou plusieurs outils en même temps, via les tags. Exemple :

```bash
ansible-playbook admin-tools/get-credentials.yaml -e dsc_cr=ma-conf -t keycloak,argocd
```

**Remarque importante** : Il est **vivement encouragé** de **sauvegarder les valeurs** qui vous sont fournies par le playbook `get-credentials.yaml`. Par exemple dans un fichier de base de données chiffré de type KeePass, Vaultwarden ou Bitwarden. Il est toutefois important de **ne pas les modifier ou les supprimer** sous peine de voir certains composants, par exemple Vault, être réinitialisés.

## Debug

### Réinstallation

Si vous rencontrez des problèmes lors de l'exécution du playbook, vous voudrez certainement relancer l'installation d'un ou plusieurs composants plutôt que d'avoir à tout réinstaller.

Pour cela, vous pouvez utiliser les tags qui sont associés aux rôles dans le fichier « install.yaml ».

Voici par exemple comment réinstaller uniquement les composants keycloak et console, dans la chaîne DSO paramétrée avec la `dsc` par défaut (`conf-dso`), via les tags correspondants :

```bash
ansible-playbook install.yaml -t keycloak,console
```

Si vous voulez en faire autant sur une autre chaîne DSO, paramétrée avec votre propre `dsc` (nommée par exemple `ma-dsc`), alors vous utiliserez l'[extra variable](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#defining-variables-at-runtime) `dsc_cr` comme ceci :

```bash
ansible-playbook install.yaml -e dsc_cr=ma-dsc -t keycloak,console
```

### AWX Operator et instance AWX

Toute instance d'AWX sera installé en s'appuyant sur l'[opérateur AWX](https://github.com/ansible/awx-operator/), via le role `awx-operator`.

Rappel : l'installation de l'opérateur AWX et de l'instance AWX sont optionnels. Ils ne s'installeront que sur demande, via l'utilisation des tags appropriés.

Suite à une première installation du socle, l'instance AWX et les ressources AWX par défaut pourront s'installer via la commande suivante :

```bash
ansible-playbook install.yaml -t awx
```

### Cert-manager

L'outil cert-manager est installé à l'aide de son [chart helm officiel](https://cert-manager.io/docs/installation/helm), via le role `cert-manager`.

Le playbook d'installation, en s'appuyant sur le role en question, s'assurera préalablement qu'il n'est pas déjà installé dans le cluster. Il vérifiera pour cela la présence de deux éléments :

- L'APIVERSION `cert-manager.io/v1`.
- La `MutatingWebhookConfiguration` nommée `cert-manager-webhook`.

Si l'un ou l'autre de ces éléments sont absents du cluster, cela signifie que cert-manager n'est pas installé. Le rôle associé procédera donc à son installation.

**Attention !** Assurez-vous que si une précédente instance de cert-manager a été désinstallée du cluster, elle l'a été proprement. En effet, si l'outil avait déjà été installé auparavant, mais qu'il n'a pas été correctement désinstallé au préalable, alors il est possible que les deux ressources vérifiées par le role soient toujours présentes. Dans ce cas de figure, et si un ingress avec tls de type acme est déclaré dans votre ressource `dsc`, les déploiements de ressources ingress et les routes associées échoueront à se créer, car cert-manager n'aura pas été installé par le role.

### CloudNativePG

La BDD PostgreSQL des composants suivants est installée à l'aide de l'opérateur communautaire [CloudNativePG](https://cloudnative-pg.io/) (lui-même installé via le role `cloudnativepg`) :
* console-dso
* harbor
* keycloak
* sonarqube

Le playbook d'installation, en s'appuyant sur le role en question, s'assurera préalablement que cet opérateur n'est pas déjà installé dans le cluster. Il vérifiera pour cela la présence de deux éléments :

- L'API `postgresql.cnpg.io/v1`.
- La `MutatingWebhookConfiguration` nommée `cnpg-mutating-webhook-configuration`.

Si l'un ou l'autre de ces éléments sont absents du cluster, cela signifie que l'opérateur CloudNativePG n'est pas installé. Le rôle associé procédera donc à son installation.

**Attention !** Assurez-vous que si une précédente instance de CloudNativePG a été désinstallée du cluster, elle l'a été proprement. En effet, si l'opérateur CloudNativePG avait déjà été installé auparavant, mais qu'il n'a pas été correctement désinstallé au préalable, alors il est possible que les deux ressources vérifiées par le role soient toujours présentes. Dans ce cas de figure, l'installation de Keycloak ou de SonarQube échouera, car l'opérateur CloudNativePG n'aura pas été installé par le role.

### GitLab Operator

Toute instance de GitLab sera installée en s'appuyant sur l'[opérateur GitLab](https://docs.gitlab.com/operator), via le role `gitlab-operator`.

Le playbook d'installation, en s'appuyant sur le role en question, s'assurera préalablement que cet opérateur n'est pas déjà installé dans le cluster. Il vérifiera pour cela la présence de deux éléments :

- L'APIVERSION `apps.gitlab.com/v1beta1`.
- La `ValidatingWebhookConfiguration` nommée `gitlab-validating-webhook-configuration`.

Si l'un ou l'autre de ces éléments sont absents du cluster, cela signifie que l'opérateur GitLab n'est pas installé. Le rôle associé procédera donc à son installation.

**Attention !** Assurez-vous que si une précédente instance de GitLab Operator a été désinstallée du cluster, elle l'a été proprement. En effet, si l'opérateur GitLab avait déjà été installé auparavant, mais qu'il n'a pas été correctement désinstallé au préalable, alors il est possible que les deux ressources vérifiées par le role soient toujours présentes. Dans ce cas de figure, l'installation de GitLab échouera, car l'opérateur associé n'aura pas été installé par le role.

### Grafana Operator et instance Grafana

Toute instance de Grafana et les éléments par défaut associés (datasource et dashboards) seront installés en s'appuyant sur l'[opérateur Grafana](https://grafana.github.io/grafana-operator/), via le role `grafana-operator`.

Rappel : l'installation de l'opérateur Grafana, de l'instance Grafana et des éléments par défaut associés (datasource, dashboards) sont optionnels. Ils ne s'installeront que sur demande, via l'utilisation des tags appropriés.

Suite à une première installation du socle avec les métriques activées (section `spec.global.metrics.enabled` de la `dsc`), l'instance Grafana et les ressources Grafana par défaut pourront s'installer via la commande suivante :

```bash
ansible-playbook install.yaml -t grafana-operator,grafana,grafana-datasource,grafana-dashboards
```

Remarques :
* Il est tout à fait possible de ne pas utiliser la datasource ou les dashboards que nous proposons par défaut, et de déployer à la place vos propres datasources et dashboards. Dans ce cas, vous devrez les déclarer par vos soins, en utilisant vos propres fichiers YAML de définitions s'appuyant sur la [documentation de l'opérateur](https://grafana.github.io/grafana-operator/docs/).
* Si au contraire, vous souhaitez installer l'intégralité de la stack Grafana que nous proposons, vous pouvez utiliser le tag unique `-t grafana-stack`.

Le playbook d'installation, via le role `grafana-operator`, s'assurera préalablement que l'opérateur Grafana n'est pas déjà installé dans le cluster. Il vérifiera pour cela la présence de deux éléments :

- L'APIVERSION `grafana.integreatly.org/v1beta1`.
- Le `ClusterRole` nommé `grafana-operator-permissions`.

Si l'un ou l'autre de ces éléments sont absents du cluster, cela signifie que l'opérateur Grafana n'est pas installé. Le rôle associé procédera donc à son installation.

**Attention !** Assurez-vous que si une précédente instance de Grafana Operator a été désinstallée du cluster, elle l'a été proprement. En effet, si l'opérateur Grafana avait déjà été installé auparavant, mais qu'il n'a pas été correctement désinstallé au préalable, alors il est possible que les deux ressources vérifiées par le role soient toujours présentes. Dans ce cas de figure, l'installation de Grafana échouera, car l'opérateur associé n'aura pas été installé par le role.

### Kyverno

Kyverno est installé via le role `kyverno`. Il est utilisé pour déployer une ClusterPolicy qui automatise la réplication des secrets et configmaps portant le label `ns.kyverno.io/all-sync: ""` dans tous les namespaces de la chaîne DSO.

Pour l'instant, seuls les secrets et configmaps présents dans le namespace `default` et portant ce label sont ainsi répliqués.

Le playbook d'installation, via le role `kyverno`, s'assurera préalablement que cet outil n'est pas déjà installé dans le cluster. Il vérifiera pour cela la présence d'éventuels pods Kyverno, en se basant sur le label `app.kubernetes.io/part-of: kyverno`.

Si aucun pod Kyverno n'est détecté, le rôle associé procédera donc à l'installation.

**Attention !** Assurez-vous que si une précédente instance de Kyverno a été désinstallée du cluster, elle l'a été proprement, c'est-à-dire en supprimant également les resources cluster scoped associées. Si ce n'est pas le cas, l'installation de Kyverno échouera. Pour faciliter cette désinstallation préalable au besoin, vous pouvez utiliser la commande de désinstallation associée (voir [section suivante](#désinstallation)).

### Kubed (config-syncer)

Le rôle kyverno remplit désormais les mêmes fonctionnalités que celles qui étaient précédemment proposées par le role confSyncer.

C'est pourquoi, dans un cluster dédié à une utilisation à jour du socle DSO, nous vous recommandons de **désinstaller Kubed** (voir [section suivante](#désinstallation)).

### Prometheus

Les tâches du rôle prometheus ne se lancent que si le paramètre `prometheus.crd.type` de la `dsc` est positionné sur `managed` comme dans l'exemple suivant :

```yaml
prometheus:
  crd:
    type: managed
```

Il faudra positionner cette valeur `managed` dans le cas de figure où l'opérateur Prometheus est installé dans notre cluster.

Le rôle en lui-même sert à installer séparément les CRDs de l'opérateur Prometheus, ce qui est recommandé en production.

## Désinstallation

### Chaîne complète

Un playbook de désinstallation nommé « uninstall.yaml » est disponible.

Il permet de désinstaller **toute la chaîne DSO en une seule fois**.

Pour le lancer, en vue de désinstaller la chaîne DSO qui utilise la `dsc` par défaut `conf-dso` :

```bash
ansible-playbook uninstall.yaml
```

Vous pourrez ensuite surveiller la désinstallation des namespaces par défaut via la commande suivante :

```bash
watch "kubectl get ns | grep 'dso-'"
```

**Attention !** Si vous souhaitez plutôt désinstaller une autre chaîne, déployée en utilisant votre propre ressource de type `dsc`, alors vous devrez utiliser l'[extra variable](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#defining-variables-at-runtime) `dsc_cr`, comme ceci (exemple avec une `dsc` nommée `ma-dsc`) :

```bash
ansible-playbook uninstall.yaml -e dsc_cr=ma-dsc
```

Selon les performances ou la charge de votre cluster, la désinstallation de certains composants (par exemple GitLab) pourra prendre un peu de temps.

Pour surveiller l'état d'une désinstallation en cours, si vous avez correctement préfixé ou suffixé vos namespaces dans votre configuration, il sera possible de vous appuyer sur la commande suivante. Exemple avec le préfixe `mynamespace-` :

```bash
watch "kubectl get ns | grep 'mynamespace-'"
```

Même exemple, mais avec le suffixe `-mynamespace` :

```bash
watch "kubectl get ns | grep '\-mynamespace'"
```

**Remarques importantes** :

- Par défaut le playbook de désinstallation, s'il est lancé sans aucun tag, ne supprimera pas les ressources suivantes :
  - **AWX Operator** déployé dans le namespace spécifié par le fichier « config.yaml » du role `socle-config`, déclaré lors de l'installation avec la `dsc` par défaut `conf-dso`.
  - **Cert-manager** déployé dans le namespace `cert-manager`.
  - **CloudNativePG** déployé dans le namespace spécifié par le fichier « config.yaml » du role `socle-config`, déclaré lors de l'installation avec la `dsc` par défaut `conf-dso`.
  - **GitLab Operator** déployé dans le namespace spécifié par le fichier « config.yaml » du role `socle-config`, déclaré lors de l'installation avec la `dsc` par défaut `conf-dso`.
  - **Grafana Operator** déployé dans le namespace spécifié par le fichier « config.yaml » du role `socle-config`, déclaré lors de l'installation avec la `dsc` par défaut `conf-dso`.
  - **Kyverno** déployé dans le namespace spécifié par le fichier « config.yaml » du role `socle-config`, déclaré lors de l'installation avec la `dsc` par défaut `conf-dso`.
- Les cinq composants en question pourraient en effet être utilisés par une autre instance de la chaîne DSO, voire par d'autres ressources dans le cluster. Si vous avez conscience des risques et que vous voulez malgré tout désinstaller l'un de ces outils, vous pourrez le faire via l'utilisation des tags correspondants :
  - Pour AWX Operator : `-t awx-operator` (ou bien `-t awx`)
  - Pour Cert-manager : `-t cert-manager`
  - Pour CloudNativePG : `-t cnpg` (ou bien `-t cloudnativepg`)
  - Pour GitLab Operator : `-t gitlab-operator`
  - Pour Grafana Operator : `-t grafana-operator`
  - Pour Kyverno : `-t kyverno`
- La fonctionnalité actuellement remplie par le role Kyverno était auparavant gérée par un role kubed. C'est la raison pour laquelle la désinstallation de kubed est toujours disponible. Si kubed est encore présent dans votre cluster hébergeant le socle DSO, nous vous recommandons sa désinstallation via l'utilisation du tag `-t kubed` (ou `-t confSyncer`).

### Désinstaller un ou plusieurs outils

Le playbook de désinstallation peut aussi être utilisé pour supprimer un ou plusieurs outils **de manière ciblée**, via les tags associés.

L'idée est de faciliter leur réinstallation complète, en utilisant ensuite le playbook d'installation (voir la sous-section [Réinstallation](#réinstallation) de la section Debug).

Par exemple, pour désinstaller uniquement les outils Keycloak et ArgoCD configurés avec la `dsc` par défaut (`conf-dso`), la commande sera la suivante :

```bash
ansible-playbook uninstall.yaml -t keycloak,argocd
```

Pour faire la même chose sur les mêmes outils, mais s'appuyant sur une autre configuration (via une `dsc` nommée `ma-dsc`), vous rajouterez là encore l'[extra variable](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#defining-variables-at-runtime) `dsc_cr`. Exemple :

```bash
ansible-playbook uninstall.yaml -t keycloak,argocd -e dsc_cr=ma-dsc
```

**Remarque importante** : Si vous désinstallez la ressource **console** via le tag approprié, et que vous souhaitez ensuite la réinstaller, vous devrez impérativement **relancer une installation complète** du socle DSO (sans tags) plutôt que de réinstaller la console seule. En effet, la configmap `dso-config` qui lui est associée est alimentée par les autres outils à mesure de leur installation.

## Gel des versions

### Introduction

Selon le type d'infrastructure dans laquelle vous déployez, et **en particulier dans un environnement de production**, vous voudrez certainement pouvoir geler (freeze) les versions d'outils ou composants utilisés.

Pour chaque version du socle DSO, les numéros de version de charts utilisés sont gelés par défaut.

Ils peuvent être consultés dans le fichier [versions.md](versions.md), situé à la racine du présent dépôt socle que vous avez initialement cloné.

Vous pouvez également geler les versions d'images utilisées par les charts Helm de chaque outil.

Ceci est géré par le champ `values` que vous pourrez spécifier, pour chaque outil concerné, dans la ressource `dsc` de configuration par défaut (`conf-dso`) ou votre propre `dsc`.

Les sections suivantes détaillent comment procéder, outil par outil.

**Remarques importantes** :

- Comme vu dans la section d'installation (sous-section [Déploiement de plusieurs forges DSO dans un même cluster](#déploiement-de-plusieurs-forges-dso-dans-un-même-cluster )), si vous utilisez votre propre ressource `dsc` de configuration, distincte de `conf-dso`, alors toutes les commandes `ansible-playbook` indiquées ci-dessous devront être complétées par l'[extra variable](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#defining-variables-at-runtime) `dsc_cr` appropriée.
- Pour le gel des versions d'images, il est recommandé, si possible, de positionner un **tag d'image en adéquation avec la version du chart Helm utilisé**, c'est-à-dire d'utiliser le numéro "APP VERSION" retourné par la commande `helm search repo`.

### Modification des versions de charts

Techniquement, la modification des versions de charts utilisés est possible, mais elle **n'est pas recommandée**.

Ceci parce que la version de la Console Cloud π Native déployée par le socle, composant central qui s'interface avec tous les outils de la chaîne, a été testée et développée avec les versions d'outils telles qu'elles sont fixées au moment de la publication.

Aussi, **nous ne pouvons garantir le bon fonctionnement** de la forge DSO dans un contexte où les versions de charts seraient modifiées.

De plus, et comme indiqué plus haut, les outils cert-manager, CloudNativePG, GitLab Operator, Grafana Operator et Kyverno seront communs à toutes les instances de la chaine DSO ou à toute autre application déployée dans le cluster. En modifier la version n'est donc pas anodin.

Si vous souhaitez malgré tout tenter une modification de version d'un chart en particulier, Vous devrez **avoir au moins installé le socle DSO une première fois**. En effet, le playbook et les roles associés installeront les dépôts Helm de chaque outil. Ceci vous permettra ensuite d'utiliser la commande `helm` pour rechercher plus facilement les versions de charts disponibles.

Pensez également à effectuer au moins un backup du namespace et des ressources cluster scoped associées.

Vous devrez ensuite **afficher le fichier « releases.yaml »** du role `socle-config` afin de connaître le nom du champ à insérer dans la `dsc` et le numéro de version de chart par défaut pour l'outil concerné.

Une fois que nous sommes positionnés dans le répertoire socle, la commande pour afficher ce fichier sera :

```bash
cat ./roles/socle-config/files/releases.yaml
```

Pour connaître la dernière version du chart Helm et de l'application actuellement disponibles dans votre cache local, utilisez les commandes suivantes, exemple avec argo-cd :

```bash
helm repo update
```

```bash
helm search repo argo-cd
```

Pour une liste détaillée de toutes les versions disponibles, ajouter l'option `-l` comme ceci, exemple pour Argo CD :

```bash
helm search repo -l argo-cd
```

Pour fixer une version de chart dans la ressource `dsc`, il vous suffira d'ajouter la ligne que vous aurez trouvée dans le fichier « releases.yaml » vu plus haut, au niveau de l'outil concerné, exemple pour Argo CD :

```yaml
argocd:
  chartVersion: 4.7.19
```

### Gel des versions d'images

Comme indiqué précédemment, le gel des versions d'images peut être géré par le champ `values` que vous pourrez spécifier, pour chaque outil concerné, dans la ressource `dsc` de configuration par défaut (`conf-dso`) ou votre propre `dsc`.

Ce champ correspond rigoureusement à ce qui est utilisable pour une version donnée du chart Helm de l'outil en question.

Pour certains outils (instance grafana, nexus), l'image est fixée par défaut et nous proposons directement un champ dédié dans la `dsc`.

Si vous souhaitez connaître le champ en question, il vous suffit d'afficher le fichier « releases.yaml »** du role `socle-config`.

Rappel : une fois que nous sommes positionnés dans le répertoire socle, la commande pour afficher ce fichier sera la suivante.

```bash
cat ./roles/socle-config/files/releases.yaml
```

Lors d'une **première installation du socle**, nous vous recommandons toutefois de **ne pas geler immédiatement vos versions d'images dans la `dsc`**. En effet, le playbook et les roles associés installeront les dépôts Helm de chaque outil et utiliseront la version d'image qui correspond à la version du chart définie par défaut.

Ceci vous permettra ensuite d'utiliser la commande `helm` pour rechercher plus facilement les versions d'images disponibles et à quelles versions de charts, elles sont associées.

Lorsque vous gelez vos images dans la `dsc`, il est **fortement recommandé** d'utiliser un tag d'image en adéquation avec la version de chart utilisée, tel que fourni par la commande `helm search repo -l nom-de-mon-outil-ici --version version-de-chart-ici`.

Lorsque vos values sont à jour **pour tous les outils concernés**, avec les versions d'images désirées, appliquez le changement en utilisant votre fichier de définition. Exemple :

```bash
kubectl apply -f ma-conf-dso.yaml
```

Puis relancez l'[Installation](#installation).

Les sections suivantes détaillent la façon de procéder au gel de version d'image pour chaque outil :
  - [Argo CD](#argo-cd)
  - [Cert-manager](#cert-manager)
  - [CloudNativePG](#cloudnativepg-1)
  - [Console Cloud π Native](#console-cloud-π-native)
  - [GitLab](#gitlab)
  - [GitLab Runner](#gitlab-runner)
  - [Harbor](#harbor)
  - [Instance AWX](#instance-awx)
  - [Instance Grafana](#instance-grafana)
  - [Keycloak](#keycloak)
  - [Kyverno](#kyverno-1)
  - [Sonatype Nexus Repository](#sonatype-nexus-repository)
  - [SonarQube Community Edition](#sonarqube-community-edition)
  - [Vault](#vault)

#### Argo CD

Le composant Argo CD est installé à l'aide de son chart Helm officiel.

La version d'image utilisée est directement liée à la version de chart déployée. Elle est donc déjà gelée par défaut.

Il est recommandé de ne pas modifier cette version de chart, sauf si vous savez ce que vous faites.

#### Cert-manager

La version d'image utilisée par cert-manager est directement liée à la version de chart déployée. Elle est donc déjà gelée par défaut.

Il est recommandé de ne pas modifier cette version de chart, sauf si vous savez ce que vous faites.

#### CloudNativePG

Comme avec cert-manager, il existe une correspondance biunivoque entre la version de chart utilisée et la version d'application ("APP VERSION") de l'opérateur.

Ainsi, spécifier une version de chart est suffisant pour geler la version d'image au niveau de l'opérateur.

Il est recommandé de ne pas modifier cette version de chart, sauf si vous savez ce que vous faites.

Comme indiqué dans sa [documentation officielle](https://cloudnative-pg.io/documentation/1.20/quickstart/#part-3-deploy-a-postgresql-cluster), par défaut CloudNativePG installera la dernière version mineure disponible de la dernière version majeure de PostgreSQL au moment de la publication de l'opérateur.

De plus, comme l'indique la [FAQ officielle](https://cloudnative-pg.io/documentation/1.20/faq/), CloudNativePG utilise des conteneurs d'application immutables. Cela signifie que le conteneur ne sera pas modifié durant tout son cycle de vie (aucun patch, aucune mise à jour ni changement de configuration).

#### Console Cloud π Native

La version d'image utilisée par la Console Cloud π Native est directement liée à la version de chart déployée. Elle est donc déjà gelée par défaut.

Il est recommandé de ne pas modifier cette version de chart, sauf si vous savez ce que vous faites.

#### GitLab

La version d'image utilisée par GitLab est directement liée à la version de chart déployée. Elle est donc déjà gelée par défaut.

Par ailleurs le chart Helm de GitLab est déployé via l'opérateur GitLab, lui-même déployé via Helm.

Il existe ainsi une correspondance directe entre la version de chart utilisée pour déployer l'opérateur et les versions de charts GitLab que cet opérateur sera en mesure d'installer.

Cette correspondance est fournie par la page de documentation suivante :

https://gitlab.com/gitlab-org/cloud-native/gitlab-operator/-/tags

Dans le même ordre d'idée, une version de chart GitLab correspond à une version d'instance GitLab.

La correspondance entre versions de charts GitLab et versions d'instances Gitlab est fournie par la page de documentation suivante :

https://docs.gitlab.com/charts/installation/version_mappings.html

Il est donc recommandé de ne pas modifier les versions de charts déjà fixées au moment de la sortie du socle, sauf si vous savez ce que vous faites. Dans le cas où vous souhaiteriez les modifier, gardez à l'esprit les correspondances signalées précédemment, entre version du chart de l'opérateur et versions de chart GitLab qu'il peut installer.

#### GitLab CI pipelines exporter

La version d'image utilisée par GitLab CI pipelines exporter est directement liée à la version de chart déployée. Elle est donc déjà gelée par défaut.

Il est recommandé de ne pas modifier cette version de chart, sauf si vous savez ce que vous faites.

#### GitLab Runner

La version d'image utilisée par GitLab Runner est directement liée à la version de chart déployée. Elle est donc déjà gelée par défaut.

Il est recommandé de ne pas modifier cette version de chart, sauf si vous savez ce que vous faites.

Si toutefois vous souhaitez la modifier, sachez que la version `majeure.mineure` de l'instance GitLab Runner doit idéalement correspondre à celle de l'instance GitLab, comme expliqué ici :

https://docs.gitlab.com/runner/#gitlab-runner-versions

#### Harbor

Fixer le numéro de version du chart Helm sera normalement suffisant pour fixer aussi le numéro de version des images associées. Le numéro de version de ces images sera celui visible dans la colonne "APP VERSION" de la commande `helm search repo -l harbor/harbor`.

Il est toutefois possible de fixer les versions d'images pour Harbor de façon plus fine (**recommandé en production**).

Il sera ainsi possible de fixer l'image de chacun des composants.

Les différents tags utilisables sont disponibles ici :

- nginx : <https://hub.docker.com/r/goharbor/nginx-photon/tags>
- portal : <https://hub.docker.com/r/goharbor/harbor-portal/tags>
- core : <https://hub.docker.com/r/goharbor/harbor-core/tags>
- jobservice : <https://hub.docker.com/r/goharbor/harbor-jobservice/tags>
- registry (registry) : <https://hub.docker.com/r/goharbor/registry-photon/tags>
- registry (controller) : <https://hub.docker.com/r/goharbor/harbor-registryctl/tags>
- trivy : <https://hub.docker.com/r/goharbor/trivy-adapter-photon/tags>
- notary (server) : <https://hub.docker.com/r/goharbor/notary-server-photon/tags>
- notary (signer) : <https://hub.docker.com/r/goharbor/notary-signer-photon/tags>
- database : <https://hub.docker.com/r/goharbor/harbor-db/tags>
- redis : <https://hub.docker.com/r/goharbor/redis-photon/tags>
- exporter : <https://hub.docker.com/r/goharbor/harbor-exporter/tags>

**Rappel** : Il est néanmoins recommandé de positionner des tags d'images en adéquation avec la version du chart Helm utilisée et documentée dans le fichier [versions.md](versions.md), situé à la racine du socle, c'est-à-dire d'utiliser le numéro "APP VERSION" retourné par la commande `helm search repo -l harbor/harbor --version numero-de-version-de-chart`.

Pour spécifier nos tags, il nous suffira d'éditer la ressource `dsc` de configuration (par défaut, ce sera la `dsc` nommée `conf-dso`) et de surcharger les "values" correspondantes du chart Helm, en ajoutant celles dont nous avons besoin. Exemple, pour la version 1.14.1 du chart :

```yaml
harbor:
  adminPassword: WhoWantsToPassForever
  pvcRegistrySize: 50Gi
  values:
    nginx:
      image:
        repository: docker.io/goharbor/nginx-photon
        tag: v2.10.1
    portal:
      image:
        repository: docker.io/goharbor/harbor-portal
        tag: v2.10.1
    core:
      image:
        repository: docker.io/goharbor/harbor-core
        tag: v2.10.1
    jobservice:
      image:
        repository: docker.io/goharbor/harbor-jobservice
        tag: v2.10.1
    registry:
      registry:
        image:
          repository: docker.io/goharbor/registry-photon
          tag: v2.10.1
      controller:
        image:
          repository: docker.io/goharbor/harbor-registryctl
          tag: v2.10.1
    trivy:
      image:
        repository: docker.io/goharbor/trivy-adapter-photon
        tag: v2.10.1
    notary:
      server:
        image:
          repository: docker.io/goharbor/notary-server-photon
          tag: v2.10.1
      signer:
        image:
          repository: docker.io/goharbor/notary-signer-photon
          tag: v2.10.1
    database:
      internal:
        image:
          repository: docker.io/goharbor/harbor-db
          tag: v2.10.1
    redis:
      internal:
        image:
          repository: docker.io/goharbor/redis-photon
          tag: v2.10.1
    exporter:
      image:
        repository: docker.io/goharbor/harbor-exporter
        tag: v2.10.1
```

Pour mémoire, les values utilisables sont disponibles et documentées ici : <https://github.com/goharbor/harbor-helm/tree/master>

#### Instance AWX

L'instance AWX est déployée par l'opérateur AWX.

L'image utilisée est déjà gelée. Son numéro de version est spécifié dans le fichier [versions.md](versions.md) situé à la racine du socle.

Il est recommandé de ne pas modifier cette version, sauf si vous savez ce que vous faites.

Si toutefois vous souhaitez la modifier, les tags d'images utilisables sont disponibles ici : <https://github.com/ansible/awx-operator/tags>

Pour déployer une autre version, il suffira d'éditer la `dsc`, de préférence avec le fichier YAML que vous avez initialement utilisé pendant l'installation, puis modifier la section suivante en y indiquant la version du chart désirée au niveau du paramètre **chartVersion** et la version de l'image AWX associée au niveau du paramètre **defaultAwxVersion**. Exemple :

```yaml
awx:
  chartVersion: 2.19.1
  defaultAwxVersion: 24.6.1
```

#### Instance Grafana

L'instance Grafana est déployée par l'opérateur Grafana.

L'image utilisée est déjà gelée. Son numéro de version est spécifié dans le fichier [versions.md](versions.md) situé à la racine du socle.

Il est recommandé de ne pas modifier cette version, sauf si vous savez ce que vous faites.

Si toutefois vous souhaitez la modifier, les tags d'images utilisables sont disponibles ici : <https://github.com/grafana/grafana/tags>

Pour déployer une autre version, il suffira d'éditer la `dsc`, de préférence avec le fichier YAML que vous avez initialement utilisé pendant l'installation, puis modifier la section suivante en y indiquant la version d'image désirée au niveau du paramètre **imageVersion**. Exemple :

```yaml
grafana:
  imageVersion: 9.5.6
```

#### Keycloak

Le composant Keycloak est installé à l'aide du chart Helm Bitnami.

Nous utiliserons un tag dit "[immutable](https://docs.bitnami.com/kubernetes/apps/keycloak/configuration/understand-rolling-immutable-tags/)" (**recommandé en production**).

Les différents tags utilisables pour l'image de Keycloak sont disponibles ici : <https://hub.docker.com/r/bitnami/keycloak/tags>

Les tags dits "immutables" sont ceux qui possèdent un suffixe de type rXX, lequel correspond au numéro de révision. Ils pointent toujours vers la même image. Par exemple le tag "19.0.3-debian-11-r22" est un tag immutable.

Pour spécifier un tel tag, il nous suffira d'éditer la ressource `dsc` de configuration (par défaut, ce sera la `dsc` nommée `conf-dso`) et de surcharger les "values" correspondantes du chart Helm, en ajoutant celles dont nous avons besoin. Exemple :

```yaml
keycloak:
  values:
    image:
      registry: docker.io
      repository: bitnami/keycloak
      tag: 23.0.7-debian-12-r4
```

Pour mémoire, les values utilisables sont disponibles ici : <https://github.com/bitnami/charts/blob/main/bitnami/keycloak/values.yaml>

Les release notes de Keycloak se trouvent ici : <https://github.com/keycloak/keycloak/releases>

#### Kyverno

La version d'image utilisée par Kyverno est directement liée à la version de chart déployée. Elle est donc déjà gelée par défaut.

Il est recommandé de ne pas modifier cette version de chart, sauf si vous savez ce que vous faites.

#### Sonatype Nexus Repository

Le composant nexus est installé directement via le manifest de deployment « nexus.yml.j2 » intégré au role associé.

L'image utilisée est déjà gelée. Son numéro de version est spécifié dans le fichier [versions.md](versions.md) situé à la racine du socle.

Il est recommandé de ne pas modifier cette version, sauf si vous savez ce que vous faites.

Si toutefois vous souhaitez la modifier, les tags d'images utilisables sont disponibles ici : <https://hub.docker.com/r/sonatype/nexus3/tags>

Pour déployer une autre version, il suffira d'éditer la `dsc`, de préférence avec le fichier YAML que vous avez initialement utilisé pendant l'installation, puis modifier la section suivante en y indiquant la version d'image désirée au niveau du paramètre **imageTag**. Exemple :

```yaml
nexus:
  storageSize: 25Gi
  imageTag: 3.68.1
```

#### SonarQube Community Edition

Le composant SonarQube est installé via son [chart Helm officiel](https://github.com/SonarSource/helm-chart-sonarqube/tree/master/charts/sonarqube).

Les tags d'images utilisables sont ceux retournés par la commande suivante, au niveau de la colonne "APP VERSION" :

```bash
helm search repo -l sonarqube/sonarqube
```

Il faudra juste leur ajouter le suffixe "-community" qui correspond à l'édition utilisée, ou bien le suffixe `-{{ .Values.edition }}` si nous précisons aussi l'édition dans nos values.

Pour spécifier un tel tag, il nous suffira d'éditer la ressource `dsc` de configuration (par défaut, ce sera la `dsc` nommée `conf-dso`) et de surcharger les "values" correspondantes du chart Helm, en ajoutant celles dont nous avons besoin. Exemple :

```yaml
sonarqube:
  postgresPvcSize: 25Gi
  values:
    image:
      registry: docker.io
      repository: sonarqube
      edition: community
      tag: 10.4.1-{{ .Values.edition }}
```

#### Vault

Fixer les versions d'images de Vault est **recommandé en production**.

Les values utilisables sont disponibles et documentées ici : <https://developer.hashicorp.com/vault/docs/platform/k8s/helm/configuration>

Il sera possible de fixer l'image :
- du Vault Agent Sidecar Injector (via le repository hashicorp/vault-k8s),
- du Vault Agent (via le repository hashicorp/vault).

Les différents tags d'images utilisables sont disponibles ici :
- Pour le Vault Agent Sidecar Injector : <https://hub.docker.com/r/hashicorp/vault-k8s/tags>
- Pour le Vault Agent : <https://hub.docker.com/r/hashicorp/vault/tags>

Pour spécifier nos tags, il nous suffira d'éditer la ressource `dsc` de configuration (par défaut, ce sera la `dsc` nommée `conf-dso`) et de surcharger les "values" correspondantes du chart Helm, en ajoutant celles dont nous avons besoin. Exemple :

```yaml
vault:
  values:
    injector:
      image:
        repository: docker.io/hashicorp/vault-k8s
        tag: 1.2.1
        pullPolicy: IfNotPresent
      agentImage:
        repository: docker.io/hashicorp/vault
        tag: 1.14.0
    server:
      image:
        repository: docker.io/hashicorp/vault
        tag: 1.14.0
        pullPolicy: IfNotPresent
      updateStrategyType: RollingUpdate
```

**Remarque importante** : En cas de tentative de mise à jour des versions d'images, dans la section `server` de vos values, le paramètre `updateStrategyType` doit impérativement être présent et positionné sur "RollingUpdate" pour que l'image du serveur Vault puisse éventuellement se mettre à jour avec le tag que vous avez indiqué.

## Backups

Selon les possibilités de votre cluster, nous proposons dans la resource `dsc` de configuration différentes options de backup :
* Backup des namespaces avec Velero.
* Backup dans un bucket S3 des BDD PostgreSQL déployées via CNPG.

Ceci est géré au niveau du paramètre `global.backup`.

Vous pouvez obtenir plus de renseignements sur le paramétrage des champs de backup proposés via les commandes suivantes.

Pour les backups de namespaces avec Velero :

```shell
kubectl explain dsc.spec.global.backup.velero
```

Pour les backups S3 des BDD PostgreSQL déployées via CNPG :

```shell
kubectl explain dsc.spec.global.backup.cnpg
```

## Offline / air gap

En mode air gap ou déconnecté d'internet, certaines valeurs de la `dsc` devront être adaptées.
- `dsc.sonarqube:`
  - `pluginDownloadUrl` et `prometheusJavaagentVersion`
- `dsc.gitlabCatalog.catalogRepoUrl`
- `dsc.argocd.privateGitlabDomain`
- `dsc.grafanaOperator.ociChartUrl`
- `helmRepoUrl` pour chaque service à savoir :
  - `argocd`, `awx`, `certmanager`, `cloudnativepg`, `console`, `gitlabCiPipelinesExporter`, `gitlabOperator`, `gitlabRunner`, `harbor`, `keycloak`, `kyverno`, `sonarqube` et `vault`

## Platform

Par défaut, le déploiement du socle DSO se fait sur un cluster de la famille Openshift, mais il est possible de déployer sur les autres types de distribution Kubernetes (Vanilla, K3s, RKE2, EKS, GKE...) en spécifiant comme suit dans la dsc.
```
platform: kubernetes
```

## Profile CIS

Pour un déploiement sur un cluster qui n'est pas de la famille d'Openshift, par exemple sur un Kubernetes Vanilla, il est possible d'activer le profil de sécurité CIS pour enforcer la partie securityContext, en spécifiant comme suit dans la dsc.
```
profile: cis
```

## Utilisation de credentials Docker Hub pour le pull des images

Si vous disposez d'un compte Docker Hub, il est possible de l'utiliser pour le pull d'images des outils de la plateforme elle-même.

Ceci peut se révéler utile si vous effectuez de nombreux tests d'installation, et que vous vous retrouvez confronté à la problématique des [pull rate limits](https://www.docker.com/increase-rate-limits) de Docker Hub.

Pour cela, générez tout d'abord un secret de type `kubernetes.io/dockerconfigjson` en mode dry run et qui contiendra vos identifiants Docker Hub.

Vous en récupérerez le contenu encodé en base64, en une seule fois, via la commande suivante (à adapter avec vos identifiants) :

```bash
k create secret docker-registry docker-hub-creds \
    --docker-server="https://index.docker.io/v1" \
    --docker-username="email@example.com" \
    --docker-password="mot_de_passe_ici" \
    --docker-email="email@example.com" \
    --dry-run=client \
    -o yaml \
    | yq '.data[.dockerconfigjson]'
```

Notez que du fait de l'utilisation de l'option `dry-run`, le secret n'est pas véritablement créé. La partie qui nous intéresse, encodée en base64, est simplement affichée sur la sortie standard.

Copiez cette sortie, et collez-la dans la section `spec.global.imagePullSecretsData` de votre resource dsc (par défaut conf-dso), exemple :

```yaml
global:
  imagePullSecretsData: valeur_récupérée_ici
```

Une fois le changement appliqué à la dsc, relancez l'installation de l'outil souhaité ou de la chaîne DSO complète. Le processus d'installation va maintenant s'appuyer sur le secret `dso-config-pull-secret` créé dans le namespace `default`, utilisant vos identifiants Docker Hub, et répliqué dans le namespace de chaque outil.

Si vous constatez que la réplication du secret n'a pas lieu ou qu'elle prend trop de temps, supprimez préalablement la ClusterPolicy Kyverno `replace-kubed` :

```bash
kubectl delete cpol replace-kubed
```

Puis relancez l'installation de Kyverno, qui va simplement recréer et appliquer immédiatement la policy :

```bash
ansible-playbook install.yaml -t kyverno
```

Vérifiez la présence du secret `dso-config-pull-secret` dans le(s) namespace(s) souhaité(s) :

```bash
kubectl get secrets -A | egrep 'NAME|dso-config-pull-secret'
```

Puis relancez l'installation de l'outil voulu ou de la chaîne complète.

## Contributions

### Les commandes de l'application

```shell
# Lancer la vérification syntaxique
pnpm install && pnpm run lint

# Lancer le formattage du code
pnpm install && pnpm run format
```

### Conventions

Cf. [Conventions - MIOM Fabrique Numérique](https://docs.fabrique-numerique.fr/conventions/nommage.html).

Les commits doivent suivre la spécification des [Commits Conventionnels](https://www.conventionalcommits.org/en/v1.0.0/), il est possible d'ajouter l'[extension VSCode](https://github.com/vivaxy/vscode-conventional-commits) pour faciliter la création des commits.

Une PR doit être faite avec une branche à jour avec la branche `develop` en rebase (et sans merge) avant demande de fusion, et la fusion doit être demandée dans `develop`.
