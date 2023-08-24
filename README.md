# Installation de la plateforme DSO

## Sommaire
- [Installation de la plateforme DSO](#installation-de-la-plateforme-dso)
  - [Sommaire](#sommaire)
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
    - [Keycloak](#keycloak)
  - [Désinstallation](#désinstallation)
    - [Chaîne complète](#chaîne-complète)
    - [Un ou plusieurs outils](#un-ou-plusieurs-outils)
  - [Gel des versions](#gel-des-versions)
    - [Introduction](#introduction-1)
    - [Argo CD](#argo-cd)
      - [Gel de l'image](#gel-de-limage)
    - [Cert-manager](#cert-manager)
    - [CloudNativePG](#cloudnativepg)
      - [Gel de l'image](#gel-de-limage-1)
    - [Console Cloud π Native](#console-cloud-π-native)
    - [GitLab](#gitlab)
    - [Harbor](#harbor)
      - [Gel des images](#gel-des-images)
    - [Keycloak](#keycloak-1)
      - [Gel de l'image Keycloak](#gel-de-limage-keycloak)
      - [Gel de l'image PostgreSQL pour Keycloak](#gel-de-limage-postgresql-pour-keycloak)
    - [Kubed (config-syncer)](#kubed-config-syncer)
    - [Sonatype Nexus Repository](#sonatype-nexus-repository)
    - [SonarQube Community Edition](#sonarqube-community-edition)
    - [SOPS](#sops)
      - [Gel de l'image](#gel-de-limage-2)
    - [Vault](#vault)
      - [Gel des images](#gel-des-images-1)

## Introduction

L'installation de la forge DSO (DevSecOps) s'effectue de manière automatisée avec **Ansible**.

Les éléments déployés seront les suivants :

| Outil                       | Site officiel                                                                |
| --------------------------- | ---------------------------------------------------------------------------- |
| Argo CD                     | https://argo-cd.readthedocs.io                                               |
| Cert-manager                | https://cert-manager.io                                                      |
| Console Cloud π Native      | https://github.com/cloud-pi-native/console                                   |
| CloudNativePG               | https://cloudnative-pg.io                                                    |
| GitLab                      | https://about.gitlab.com                                                     |
| GitLab Runner               | https://docs.gitlab.com/runner                                               |
| Harbor                      | https://goharbor.io                                                          |
| Keycloak                    | https://www.keycloak.org                                                     |
| Kubed                       | https://appscode.com/products/kubed                                          |
| Sonatype Nexus Repository   | https://www.sonatype.com/products/sonatype-nexus-repository                  |
| SonarQube Community Edition | https://www.sonarsource.com/open-source-editions/sonarqube-community-edition |
| SOPS                        | https://github.com/isindir/sops-secrets-operator                             |
| HashiCorp Vault             | https://www.vaultproject.io                                                  |

Certains outils peuvent prendre un peu de temps pour s'installer, par exemple Keycloak ou GitLab.
## Prérequis

Cette installation s'effectue dans un cluster OpenShift opérationnel et correctement démarré.

Vous devrez disposer d'un **accès administrateur au cluster**.

Vous aurez besoin d'une machine distincte du cluster, tournant sous GNU/Linux avec une distribution de la famille Debian ou Red Hat. Cette machine vous servira en tant qu'**environnement de déploiement** [Ansible control node](https://docs.ansible.com/ansible/latest/network/getting_started/basic_concepts.html#control-node). Elle nécessitera donc l'installation d'[Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html), et plus précisément du paquet **ansible**, pour disposer au moins de la commande `ansible-playbook` ainsi que de la collection [community.general](https://github.com/ansible-collections/community.general).

Toujours sur votre environnement de déploiement, vous devrez :
- Clôner le présent [dépôt](https://github.com/cloud-pi-native/socle).
- Disposer d'un fichier de configuration ```~/.kube/config``` paramétré avec les accès administrateur, pour l'appel à l'API du cluster (section users du fichier en question).

L'installation de la suite des prérequis **sur l'environnement de déploiement'** s'effectue à l'aide du playbook nommé `install-requirements.yaml`. Il est mis à disposition dans le répertoire `admin-tools` du dépôt socle que vous aurez clôné.

Si l'utilisateur avec lequel vous exécutez ce playbook dispose des droits sudo sans mot de passe (option NOPASSWD du fichier sudoers), vous pourrez le lancer directement sans options :

```bash
ansible-playbook admin-tools/install-requirements.yaml
```

Sinon vous devrez utiliser l'option `-K` (abréviation de l'option `--ask-become-pass`) qui vous demandera le mot de passe sudo :

```bash
ansible-playbook -K admin-tools/install-requirements.yaml
```
Pour information, le playbook `install-requirements.yaml` vous installera les éléments suivants **sur l'environnement de déploiement** :

- Collection Ansible [kubernetes.core](https://github.com/ansible-collections/kubernetes.core) si elle n'est pas déjà présente.

- Modules python :
  - pyyaml
  - kubernetes
  - python-gitlab

- La commande [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/).

- La commande [helm](https://helm.sh/docs/intro/install/).

- Le gestionnaire de paquets [Snap](https://snapcraft.io/docs/installing-snapd) pour l'installation de la commande `yq`.

- La commande [yq](https://github.com/mikefarah/yq/#install) (facultative mais utile pour debug).

- L'outil d'encryption [age](https://github.com/FiloSottile/age#installation), qui fournit les commandes `age` et `age-keygen` nécessaires pour l'installation de SOPS.

## Configuration

Une fois le dépôt socle cloné, lancez une première fois la commande suivante depuis votre environnement de déploiement :

```bash
ansible-playbook install.yaml
```

Elle vous signalera que vous n'avez encore jamais installé le socle sur votre cluster, puis vous invitera à modifier la ressource de scope cluster et de type **dsc** nommée **conf-dso** via la commande suivante :

```bash
kubectl edit dsc conf-dso
```

Lancer la commande ci-dessus pour éditer la ressource indiquée.

Alternativement, et comme précisé, vous pourrez aussi déclarer la ressource `dsc` nommée `conf-dso` dans un fichier YAML, par exemple « ma-conf-dso.yaml », puis la créer via la commande suivante :

```bash
kubectl apply -f ma-conf-dso.yaml
```

Voici un **exemple** de fichier de configuration valide, à adapter à partir de la section **spec**, notamment au niveau du "rootDomain" (votre domaine principal précédé d'un point), des mots de passe, des numéros de versions et des namespaces :

```yaml
---
kind: DsoSocleConfig
apiVersion: cloud-pi-native.fr/v1alpha
metadata:
  name: conf-dso
spec:
  additionalsCA:
    - kind: ConfigMap
      name: kube-root-ca.crt
  exposedCA:
    type: configmap
    configmap:
      namespace: default
      name: ca-cert
      key: ingress.crt
  argocd:
    admin:
      enabled: true
      password: WeAreThePasswords
    namespace: mynamespace-argocd
    subDomain: argocd
    chartVersion: "4.7.13"
    values:
      image:
        registry: docker.io
        repository: bitnami/argo-cd
        tag: 2.7.6-debian-11-r2
  certmanager:
    version: v1.11.0
  cloudnativepg:
    namespace: mynamespace-cloudnativepg
    chartVersion: 0.18.2
  console:
    dbPassword: AnotherPassBitesTheDust
    namespace: mynamespace-console
    release: 5.4.0
    subDomain: console
  gitlab:
    insecureCI: true
    namespace: mynamespace-gitlab
    subDomain: gitlab
    version: "7.0.8"
  global:
    environment: production
    projectsRootDir:
      - my-root-dir
      - projects-sub-dir
    rootDomain: .example.com
  harbor:
    adminPassword: WhoWantsToPassForever
    namespace: mynamespace-harbor
    subDomain: harbor
    chartVersion: "1.12.2"
    values:
      persistence:
        persistentVolumeClaim:
          registry:
            size: 100Gi
      nginx:
        image:
          repository: docker.io/goharbor/nginx-photon
          tag: v2.8.2
      portal:
        image:
          repository: docker.io/goharbor/harbor-portal
          tag: v2.8.2
      core:
        image:
          repository: docker.io/goharbor/harbor-core
          tag: v2.8.2
      jobservice:
        image:
          repository: docker.io/goharbor/harbor-jobservice
          tag: v2.8.2
      registry:
        registry:
          image:
            repository: docker.io/goharbor/registry-photon
            tag: v2.8.2
        controller:
          image:
            repository: docker.io/goharbor/harbor-registryctl
            tag: v2.8.2
      trivy:
        image:
          repository: docker.io/goharbor/trivy-adapter-photon
          tag: v2.8.2
      notary:
        server:
          image:
            repository: docker.io/goharbor/notary-server-photon
            tag: v2.8.2
        signer:
          image:
            repository: docker.io/goharbor/notary-signer-photon
            tag: v2.8.2
      database:
        internal:
          image:
            repository: docker.io/goharbor/harbor-db
            tag: v2.8.2
      redis:
        internal:
          image:
            repository: docker.io/goharbor/redis-photon
            tag: v2.8.2
      exporter:
        image:
          repository: docker.io/goharbor/harbor-exporter
          tag: v2.8.2
  ingress:
    tls:
      type: tlsSecret
      tlsSecret:
        name: ingress-tls
        method: in-namespace
  keycloak:
    namespace: mynamespace-keycloak
    subDomain: keycloak
    chartVersion: "16.0.3"
    postgreSQLimageName: "ghcr.io/cloudnative-pg/postgresql:15.4"
    values:
      image:
        registry: docker.io
        repository: bitnami/keycloak
        tag: 19.0.3-debian-11-r22
  kubed:
    chartVersion: "v0.13.2"
  nexus:
    namespace: mynamespace-nexus
    subDomain: nexus
    storageSize: 100Gi
    imageTag: 3.56.0
  proxy:
    enabled: true
    host: "192.168.xx.xx"
    http_proxy: http://192.168.xx.xx:3128/
    https_proxy: http://192.168.xx.xx:3128/
    no_proxy: .cluster.local,.svc,10.0.0.0/8,127.0.0.1,192.168.0.0/16,api.example.com,api-int.example.com,canary-openshift-ingress-canary.apps.example.com,console-openshift-console.apps.example.com,localhost,oauth-openshift.apps.example.com,svc.cluster.local,localdomain
    port: "3128"
  sonarqube:
    namespace: mynamespace-sonarqube
    subDomain: sonarqube
    imageTag: 9.9-community
  sops:
    namespace: mynamespace-sops
    chartVersion: "0.15.1"
    values:
      image:
        tag: 0.9.1
  vault:
    namespace: mynamespace-vault
    subDomain: vault
    chartVersion: 0.25.0
    values:
      injector:
        image:
          repository: "docker.io/hashicorp/vault-k8s"
          tag: "1.2.1"
          pullPolicy: IfNotPresent
        agentImage:
          repository: "docker.io/hashicorp/vault"
          tag: "1.14.0"
      server:
        image:
          repository: "docker.io/hashicorp/vault"
          tag: "1.14.0"
          pullPolicy: IfNotPresent
        updateStrategyType: "RollingUpdate"
```

Les champs utilisables dans cette ressource de type **dsc** peuvent être décrits pour chaque outil à l'aide de la commande `kubectl explain`. Exemple avec argocd :
```
kubectl explain dsc.spec.argocd
```

### Utilisation de vos propres values

Comme nous pouvons le voir dans l'exemple de configuration fourni ci-dessus, plusieurs outils sont notamment configurés à l'aide d'un champ `values`.

Il s'agit de valeurs de chart helm. Vous pouvez les utiliser ici pour surcharger les valeurs par défaut.

Voici les liens vers les documentations de chart helm pour les outils concernés :

- [Argo CD](https://github.com/bitnami/charts/tree/main/bitnami/argo-cd)
- [GitLab](https://docs.gitlab.com/charts)
- [Harbor](https://github.com/goharbor/harbor-helm)
- [Keycloak](https://github.com/bitnami/charts/tree/main/bitnami/keycloak)
- [SOPS](https://github.com/isindir/sops-secrets-operator/tree/master/chart/helm3/sops-secrets-operator)
- [HashiCorp Vault](https://github.com/hashicorp/vault-helm)

## Installation

### Lancement
Dès que votre [configuration](#configuration) est prête, c'est à dire que la ressource `dsc` par défaut  `conf-dso` a bien été mise à jour, relancez la commande suivante :

```bash
ansible-playbook install.yaml
```

Patientez …

Pendant l'installation, et si vous avez correctement nommé vos namespaces en utilisant un même suffixe ou préfixe, vous pourrez surveiller l'arrivée de ces namespaces dans le cluster comme ceci (exemple avec des namespaces préfixés « mynamespace- »):

```bash
watch "kubectl get ns | grep 'mynamespace-'"
```

### Déploiement de plusieurs forges DSO dans un même cluster

Suite à une première installation réussie et selon vos besoins, il est possible d'installer dans un même cluster une ou plusieurs autres forges DSO, en parallèle de celle installée par défaut.

Pour cela, il vous suffit de déclarer une **nouvelle ressource de type dsc dans le cluster**, en la nommant différemment de la ressource `dsc` par défaut qui pour rappel se nomme `conf-dso`, et en y modifiant les noms des namespaces.

Comme vu plus haut dans la section [Configuration](#configuration), déclarez votre ressource de type `dsc` personnalisée **dans un fichier YAML**.

Il s'agira simplement de **modifier le nom de la ressource dsc** (section `metadata`, champ `name`) puis **adapter le nom de tous les namespaces de vos outils** (en les préfixant ou suffixant différemment de ceux déclarés dans la `dsc` nommée `conf-dso`).

Adaptez également si nécessaire les autres éléments de votre nouvelle configuration (mots de passe, ingress, CA, domaines, proxy …).

Lorsque celle-ci est prête, et déclarée par exemple dans le fichier « ma-conf-perso.yaml », créez-là dans le cluster comme ceci :

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

Dès lors, il vous sera possible de déployer une nouvelle chaîne DSO  dans ce cluster, en plus de celle existante. Pour cela, vous utiliserez l'[extra variable](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#defining-variables-at-runtime) prévue à cet effet, nommée `dsc_cr` (pour DSO Socle Config Custom Resource).

Par exemple, si votre nouvelle ressource `dsc` se nomme `ma-dsc`, alors vous lancerez l'installation correspondante comme ceci : 

```bash
ansible-playbook install.yaml -e dsc_cr=ma-dsc
```

## Récupération des secrets
Au moment de leur initialisation, certains outils stockent des secrets qui ne sont en principe plus disponibles ultérieurement.

**Attention !** Pour garantir l'[idempotence](https://fr.wikipedia.org/wiki/Idempotence), ces secrets sont stockés dans plusieurs ressources du cluster. Supprimer ces ressources **indique à ansible qu'il doit réinitialiser les composants**.

Afin de faciliter la récupération des secrets, un playbook d'administration nommé « get-credentials.yaml » est mis à disposition dans le répertoire « admin-tools ».

Pour le lancer :

```bash
ansible-playbook admin-tools/get-credentials.yaml
```

Ce playbook permet également de cibler un outil en particulier, grâce à l'utilisation de tags qui sont listés au début de l'exécution, exemple avec keycloak :

```bash
ansible-playbook admin-tools/get-credentials.yaml -t keycloak
```

Enfin, dans le cas où plusieurs chaînes DSO sont déployées dans le même cluster, il permet de cibler la chaîne DSO voulue via l'utilisation de l'[extra variable](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#defining-variables-at-runtime) `dsc_cr`, exemple avec la chaîne utilisant la `dsc` nommée `ma-conf` :

```bash
ansible-playbook admin-tools/get-credentials.yaml -e dsc_cr=ma-conf
```

Et bien sûr cibler un ou plusieurs outils en même temps, via les tags, exemple :

```bash
ansible-playbook admin-tools/get-credentials.yaml -e dsc_cr=ma-conf -t keycloak,argocd
```

**Remarque importante** : Il est **vivement encouragé** de conserver les valeurs qui vous sont fournies par le playbook « get-credentials.yaml ». Par exemple dans un fichier de base de données chiffré de type KeePass ou Bitwarden. Il est toutefois important de **ne pas les modifier ou les supprimer** sous peine de voir certains composants, par exemple Vault, être réinitialisés.

## Debug
### Réinstallation
Si vous rencontrez des problèmes lors de l'éxécution du playbook, vous voudrez certainement relancer l'installation d'un ou plusieurs composants plutôt que d'avoir à tout réinstaller.

Pour cela, vous pouvez utiliser les tags associés aux rôles dans le fichier « install.yaml ».

Voici par exemple comment réinstaller uniquement les composants keycloak et console, dans la chaîne DSO paramétrée avec la `dsc` par défaut (`conf-dso`), via les tags correspondants :

```bash
ansible-playbook install.yaml -t keycloak,console
```

Si vous voulez en faire autant sur une autre chaîne DSO, paramétrée avec votre propre `dsc` (nommée par exemple `ma-dsc`), alors vous utiliserez l'[extra variable](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#defining-variables-at-runtime) `dsc_cr` comme ceci :

```bash
ansible-playbook install.yaml -e dsc_cr=ma-dsc -t keycloak,console
```

### Keycloak

La BDD PostgreSQL du composant Keycloak est installée à l'aide de l'opérateur communautaire [CloudNativePG](https://cloudnative-pg.io/), via le role "cloudnativepg".

Le playbook d'installation, en s'appuyant sur le role en question, s'assurera préalablement que cet opérateur n'est pas déjà installé dans le cluster. Il vérifiera pour cela la présence de deux éléments :
- L'API "postgresql.cnpg.io/v1".
- La "MutatingWebhookConfiguration" nommée "cnpg-mutating-webhook-configuration".

Si l'un ou l'autre de ces éléments sont absents du cluster, cela signifie que l'opérateur CloudNativePG n'est pas installé. Le rôle associé procédera donc à son installation.

**Attention !** Assurez-vous que si une précédente instance de CloudNativePG a été désinstallée du cluster elle l'a été proprement. En effet, si l'opérateur CloudNativePG avait déjà été installé auparavant, mais qu'il n'a pas été correctement désinstallé au préalable, alors il est possible que les deux éléments vérifiés par le role soient toujours présents. Dans ce cas de figure, l'installation de Keycloak échouera car l'opérateur CloudNativePG n'aura pas été installé par le role.  

## Désinstallation

### Chaîne complète

Un playbook de désinstallation nommé « uninstall.yaml » est disponible.

Il permet de désinstaller **toute la chaîne DSO en une seule fois**.

Pour le lancer, en vue de désinstaller la chaîne DSO qui utilise la `dsc` par défaut `conf-dso` :

```bash
ansible-playbook uninstall.yaml
```

**Attention !** Si vous souhaitez plutôt désinstaller une autre chaîne, déployée en utilisant votre propre ressource de type `dsc`, alors vous devrez utiliser l'[extra variable](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#defining-variables-at-runtime) `dsc_cr`, comme ceci (exemple avec une `dsc` nommée `ma-dsc`) :

```bash
ansible-playbook uninstall.yaml -e dsc_cr=ma-dsc
```

Selon les performances ou la charge de votre cluster, la désinstallation de certains composants (par exemple Harbor) pourra prendre un peu de temps.

Pour surveiller l'état d'une désinstallation en cours il sera possible, si vous avez correctement préfixé ou suffixé vos namespaces dans votre configuration, de vous appuyer sur la commande suivante (exemple avec le préfixe « mynamespace- ») :

```bash
watch "kubectl get ns | grep 'mynamespace-'"
```

**Remarques importantes** :
- Par défaut le playbook de désinstallation, s'il est lancé sans aucun tag, ne supprimera pas les ressources suivantes :
  - **Kubed** déployé dans le namespace `openshift-infra`.
  - **Cert-manager** déployé dans le namespace `cert-manager`.
  - **CloudNativePG** déployé dans le namespace spécifié par la ressource `dsc` de configuration utilisée lors de l'installation.
- Les trois composants en question pourraient en effet être utilisés par une autre instance de la chaîne DSO, voire même par d'autres ressources dans le cluster. Si vous avez conscience des risques et que vous voulez malgré tout désinstaller l'un des ces trois outils, vous pourrez le faire via l'utilisation des tags correspondants :
  - Pour Kubed : `-t kubed` (ou bien `-t confSyncer`).
  - Pour Cert-manager : `-t cert-manager`.
  - Pour CloudNativePG : `-t cnpg` (ou bien `-t cloudnativepg`).

### Un ou plusieurs outils

Le playbook de désinstallation peut aussi être utilisé pour supprimer un ou plusieurs outils **de manière ciblée**, via les tags associés.

L'idée est de faciliter leur réinstallation complète, en utilisant ensuite le playbook d'installation (voir la sous-section [Réinstallation](#réinstallation) de la section Debug).

Par exemple, pour désinstaller uniquement les outils Keycloak et ArgoCD configurés avec la `dsc` par défaut (`conf-dso`), la commande sera la suivante :

````
ansible-playbook uninstall.yaml -t keycloak,argocd
````

Pour faire la même chose sur les mêmes outils, mais s'appuyant sur une autre configuration (via une `dsc` nommée `ma-dsc`), vous rajouterez là encore l'[extra variable](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#defining-variables-at-runtime) `dsc_cr`. Exemple :

````
ansible-playbook uninstall.yaml -t keycloak,argocd -e dsc_cr=ma-dsc
````

**Remarque importante** : Si vous désinstallez la resource **console** via le tag approprié, et que vous souhaitez ensuite la réinstaller, il sera préférable de **relancer une installation complète** du socle DSO (sans tags) plutôt que de réinstaller la console seule. En effet, la configmap `dso-config` qui lui est associée est alimentée par les autres outils à mesure de l'installation.

## Gel des versions

### Introduction

Selon le type d'infrastructure dans laquelle vous déployez, et **en particulier dans un environnement de production**, vous voudrez certainement pouvoir geler (freeze) les versions d'outils ou composants utilisés.

Ceci est géré par divers paramètres que vous pourrez spécifier dans la ressource `dsc` de configuration par défaut (`conf-dso`) ou votre propre `dsc`.

Les sections suivantes détaillent comment procéder, outil par outil.

**Remarques importantes** :
 * Comme vu dans la section d'installation (sous-section [Déploiement de plusieurs forges DSO dans un même cluster](#déploiement-de-plusieurs-forges-dso-dans-un-même-cluster )), si vous utilisez votre propre ressource `dsc` de configuration, distincte de `conf-dso`, alors toutes les commandes `ansible-playbook` indiquées ci-dessous devront être complétées par l'[extra variable](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#defining-variables-at-runtime) `dsc_cr` appropriée.
 * Pour le gel des versions d'images, il est recommandé, si possible, de positionner un **tag d'image en adéquation avec la version du chart Helm utilisé**, c'est à dire d'utiliser le numéro "APP VERSION" retourné par la commande `helm search repo`.

### Argo CD

Tel qu'il est conçu, et s'il est utilisé avec la `dsc` de configuration par défaut sans modification, le rôle argocd déploiera la dernière version du [chart helm Bitnami Argo CD](https://docs.bitnami.com/kubernetes/infrastructure/argo-cd) disponible dans le cache des dépôts helm de l'utilisateur.

Ceci est lié au fait que le paramètre de configuration `chartVersion` d'Argo CD, présent dans la `dsc` par défaut `conf-dso`, est laissé vide (`chartVersion: ""`).

Pour connaître la dernière version du chart helm et de l'application actuellement disponibles dans votre cache local, utilisez la commande suivante : 

```bash
helm search repo argo-cd
```

Exemple de sortie avec un cache de dépôts qui n'est pas à jour :

```
NAME            CHART VERSION   APP VERSION     DESCRIPTION                                       
bitnami/argo-cd 4.7.9          2.7.4           Argo CD is a continuous delivery tool for Kuber...
```

Pour mettre à jour votre cache de dépôts helm, et obtenir ainsi la dernière version du chart et de l'application :

```bash
helm repo update
```

Relancer immédiatement la commande de recherche :

```bash
helm search repo argo-cd
```

Si votre cache n'était pas déjà à jour, la sortie doit alors vous indiquer des versions plus récentes.

Pour connaître la liste des versions de charts helm d'Argo CD que vous pouvez maintenant installer, utilisez la commande suivante : 

```bash
helm search repo -l argo-cd
```

Si vous souhaitez fixer la version du chart helm, et donc celle d'Argo CD, il vous suffira de relever le **numéro de version du chart** désiré, puis l'indiquer dans votre ressource `dsc` de configuration.

Par exemple, si vous utilisez la `dsc` par défaut nommée `conf-dso`, vous pourrez éditer le fichier YAML que vous aviez utilisé pour la paramétrer lors de l'installation, puis adapter la section suivante en y spécifiant le numéro souhaité au niveau du paramètre **chartVersion**. Exemple :

```yaml
  argocd:
    admin:
      enabled: true
      password: WeAreThePasswords
    namespace: mynamespace-argocd
    subDomain: argocd
    chartVersion: "4.7.13"
```

Il vous suffit alors de mettre à jour votre configuration, exemple :

```bash
kubectl apply -f ma-conf-dso.yaml
```

Puis de relancer l'installation d'Argo CD, laquelle mettra à jour la version du chart et l'image associée, sans coupure de service :

```bash
ansible-playbook install.yaml -t argocd
```
#### Gel de l'image

En complément de l'usage du paramètre `chartVersion`, il est également possible de fixer la version d'image d'Argo CD de façon plus fine, en utilisant un tag dit "[immutable](https://docs.bitnami.com/kubernetes/infrastructure/argo-cd/configuration/understand-rolling-immutable-tags)" (**recommandé en production**). 

Les différents tags utilisables pour l'image d'Argo CD sont disponibles ici : https://hub.docker.com/r/bitnami/argo-cd/tags

Les tags dits "immutables" sont ceux qui possèdent un suffixe de type rXX, lequel correspond au numéro de révision. Ils pointent toujours vers la même image. Par exemple le tag "2.7.6-debian-11-r2" est un tag immutable.

Pour spécifier un tel tag, il nous suffira d'éditer la ressource `dsc` de configuration (par défaut ce sera la `dsc` nommée `conf-dso`) et de surcharger les "values" correspondantes du chart helm, en ajoutant celles dont nous avons besoin. Exemple :

```yaml
  argocd:
    admin:
      enabled: true
      password: WeAreThePasswords
    namespace: mynamespace-argocd
    subDomain: argocd
    chartVersion: "4.7.13"
    values:
      image:
        registry: docker.io
        repository: bitnami/argo-cd
        tag: 2.7.6-debian-11-r2
        imagePullPolicy: IfNotPresent
```

Appliquer le changement en utilisant votre fichier de définition, exemple :

```bash
kubectl apply -f ma-conf-dso.yaml
```

Puis relancer l'installation avec le tag `argocd` pour procéder au remplacement par l'image spécifiée, sans coupure de service :

```bash
ansible-playbook install.yaml -t argocd
```

Pour mémoire, les values utilisables sont disponibles ici : https://github.com/bitnami/charts/blob/main/bitnami/argo-cd/values.yaml

Les releases d'Argo CD et leurs changelogs se trouvent ici : https://github.com/argoproj/argo-cd/releases
### Cert-manager

**Attention !** Cert-manager est déployé dans le namespace "cert-manager", **commun à toutes les instances de la chaîne DSO**. Si vous modifiez sa version, ceci affectera toutes les instances DSO installées dans un même cluster. Ce n'est pas forcément génant, car un retour arrière sur la version est toujours possible, mais l'impact est à évaluer si votre cluster héberge un environnement de production.

Le composant cert-manager est déployé directement via son manifest, téléchargé sur GitHub.

La liste des versions ("releases") est disponible ici : https://github.com/cert-manager/cert-manager/releases

Si vous utilisez la `dsc` par défaut nommée `conf-dso` c'est la release "v1.11.0" qui sera déployée.

Pour déployer une autre version, il suffira d'éditer cette même `dsc`, de préférence avec le fichier YAML que vous avez initialement utilisé pendant l'installation, puis modifier la valeur du paramètre **version**. Exemple :

```yaml
  certmanager:
    version: v1.11.1
```
Il vous faudra ensuite appliquer le changement de configuration en utisant votre fichier de définition, exemple :

```bash
kubectl apply -f ma-conf-dso.yaml
```
Puis relancer l'installation de cert-manager, laquelle procédera à la mise à jour de version sans coupure de service :

```bash
ansible-playbook install.yaml -t cert-manager
```

### CloudNativePG

**Attention !** Pour un cluster donné, **une seule instance** de CloudNativePG devra être déployée. Si vous souhaitez donc modifier la version de chart utilisée par CloudNativePG, assurez vous préalablement que cette instance n'est pas aussi utilisée par d'autres chaînes DSO ou toute autre application, car cela pourrait les affecter également.

Tel qu'il est conçu, et s'il est utilisé avec la `dsc` de configuration par défaut sans modification, le rôle cloudnativepg déploiera la dernière version du [chart helm CloudNativePG](https://github.com/cloudnative-pg/charts) disponible dans le cache des dépôts helm de l'utilisateur.

Ceci est lié au fait que le paramètre de configuration `chartVersion` de CloudNativePG, présent dans la `dsc` par défaut `conf-dso`, est laissé vide (`chartVersion: ""`).

Pour connaître la dernière version du chart helm et de l'application actuellement disponibles dans votre cache local, utilisez la commande suivante : 

```bash
helm search repo cloudnative-pg
```

Exemple de sortie avec un cache de dépôts qui n'est pas à jour :

```
NAME                    CHART VERSION   APP VERSION     DESCRIPTION                                       
cnpg/cloudnative-pg     0.18.0          1.20.0          CloudNativePG Helm Chart
```

Pour mettre à jour votre cache de dépôts helm, et obtenir ainsi la dernière version du chart et de l'application :

```bash
helm repo update
```

Relancer immédiatement la commande de recherche :

```bash
helm search repo cloudnative-pg
```

Si votre cache n'était pas déjà à jour, la sortie doit alors vous indiquer des versions plus récentes.

Pour connaître la liste des versions de charts helm de CloudNativePG que vous pouvez maintenant installer, utilisez la commande suivante : 

```bash
helm search repo -l cloudnative-pg
```

Si vous souhaitez fixer la version du chart helm, et donc celle de CloudNativePG, il vous suffira de relever le **numéro de version du chart** désiré, puis l'indiquer dans votre ressource `dsc` de configuration.

Par exemple, si vous utilisez la `dsc` par défaut nommée `conf-dso`, vous pourrez éditer le fichier YAML que vous aviez utilisé pour la paramétrer lors de l'installation, puis adapter la section suivante en y spécifiant le numéro souhaité au niveau du paramètre **chartVersion**. Exemple :

```yaml
  cloudnativepg:
    namespace: mynamespace-cloudnativepg
    chartVersion: 0.18.2
```

Il vous suffit alors de mettre à jour votre configuration, exemple :

```bash
kubectl apply -f ma-conf-dso.yaml
```

Puis de relancer l'installation de CloudNativePG, laquelle mettra à jour la version du chart et l'image associée, sans coupure de service :

```bash
ansible-playbook install.yaml -t cloudnativepg
```
#### Gel de l'image

Il existe une correspondance biunivoque entre la version de chart utilisée et la version d'application ("APP VERSION") de l'opérateur.

Ainsi, spécifier une version de chart est suffisant pour geler la version d'image au niveau de l'opérateur.

Comme indiqué dans sa [documentation officielle](https://cloudnative-pg.io/documentation/1.20/quickstart/#part-3-deploy-a-postgresql-cluster), par défaut CloudNativePG installera la dernière version mineure disponible de la dernière version majeure de PostgreSQL au moment de la publication de l'opérateur.

De plus, comme l'indique la [FAQ officielle](https://cloudnative-pg.io/documentation/1.20/faq/), CloudNativePG utilise des conteneurs d'application immutables. Cela signifie que le conteneur ne sera pas modifié durant tout son cycle de vie (aucun patch, aucune mise à jour ni changement de configuration).

Si dans nos applications qui s'appuient sur l'opérateur CloudNativePG pour leurs bases de données, nous voulons utiliser une version spécifique de PostgreSQL, et ainsi geler l'image de conteneur correspondante, nous devrons le faire au niveau de la définition de la ressource de type `Cluster`, en principe dans le namespace de notre application.

Le gel d'image de conteneur PostgreSQL est géré par l'installation du socle DSO au niveau de chaque outil faisant appel à l'opérateur CloudNativePG. Il est donc documenté dans la section correspondante des outils en question.

### Console Cloud π Native

Le composant console est déployé directement via son manifest, téléchargé sur GitHub.

La liste des versions ("releases") est disponible ici : https://github.com/cloud-pi-native/console/releases

Si vous utilisez la `dsc` par défaut nommée `conf-dso` c'est la release "v4.1.0" qui sera déployée.

Pour déployer une autre version, il suffira d'éditer cette même `dsc`, de préférence avec le fichier YAML que vous avez initialement utilisé pendant l'installation, puis modifier la section suivante en y indiquant le numéro désiré au niveau du paramètre **release**. Exemple :

```yaml
  console:
    dbPassword: AnotherPassBitesTheDust
    namespace: mynamespace-console
    release: 4.0.0
    subDomain: console
```

Puis appliquer le changement de configuration, exemple :

```bash
kubectl apply -f ma-conf-dso.yaml
```
Et relancer l'installation de la console, laquelle procédera à la mise à jour de version sans coupure de service :

```bash
ansible-playbook install.yaml -t console
```
### GitLab

Tel qu'il est conçu, et s'il est utilisé avec la `dsc` de configuration par défaut sans modification, le rôle gitlab déploiera la dernière version **stable** de l'[opérateur GitLab](https://operatorhub.io/operator/gitlab-operator-kubernetes).

La version exacte de l'opérateur déployé pourra être obtenue à l'aide de la commande suivante (à adapter en fonction de votre namespace) :

```bash
kubectl get operator gitlab-operator-kubernetes.mynamespace-gitlab -o yaml | grep -o "gitlab-operator-kubernetes.v.*"
```

Ou bien de manière plus ciblée :

```bash
kubectl get operator gitlab-operator-kubernetes.mynamespace-gitlab -o yaml | yq '.status.components.refs[8].name'
```

Via cet opérateur, le rôle tentera de déployer par défaut la version 6.11.10 du chart Helm GitLab.

La version de GitLab installée est donc déjà figée via la version du chart utilisée, car il existe une correspondance biunivoque entre les deux.

Les correspondances entre versions du chart et versions de GitLab sont fournies ici :
https://docs.gitlab.com/charts/installation/version_mappings.html

L'opérateur sera en capacité de proposer différentes versions du chart à l'installation.

Pour connaître les versions de chart **utilisables**, il sera possible de se référer à la page suivante, exemple avec la branche 0.21 stable de l'opérateur :
https://gitlab.com/gitlab-org/cloud-native/gitlab-operator/-/blob/0-21-stable/CHART_VERSIONS

Ces versions de charts proposées par l'opérateur évolueront dans le temps, afin de tenir compte notamment des mises à jour de sécurité.

C'est la raison pour laquelle, selon le moment où nous tentons d'installer GitLab, il se peut que la version du chart Helm que nous tentons d'utiliser soit déjà obsolète.

Si tel est le cas, le playbook échouera avec une erreur explicite de type "Invalid value" semblable à ceci :

```
TASK [gitlab : Install gitlab instance] *********************************************************************************************************************
fatal: [localhost]: FAILED! => {"changed": false, "msg": "Failed to create object: b'{\"kind\":\"Status\",\"apiVersion\":\"v1\",\"metadata\":{},\"status\":\"Failure\",\"message\":\"admission webhook \\\\\"vgitlab.kb.io\\\\\" denied the request: gitlab.apps.gitlab.com \\\\\"gitlab\\\\\" is invalid: spec.chart.version: Invalid value: \\\\\"6.11.9\\\\\": chart version 6.11.9 not supported; please use one of the following: 6.11.10, 7.0.6, 7.1.1\",\"reason\":\"Invalid\",\"details\":{\"name\":\"gitlab\",\"group\":\"apps.gitlab.com\",\"kind\":\"gitlab\",\"causes\":[{\"reason\":\"FieldValueInvalid\",\"message\":\"Invalid value: \\\\\"6.11.9\\\\\": chart version 6.11.9 not supported; please use one of the following: 6.11.10, 7.0.6, 7.1.1\",\"field\":\"spec.chart.version\"}]},\"code\":422}\\n'", "reason": "Unprocessable Entity"}
```

Dans l'exemple ci-dessus, nous avons tenté une installation de GitLab avec la version 6.11.9 du chart Helm mais, comme indiqué, au moment de notre tentative l'opérateur ne supporte que les versions 6.11.10, 7.0.6 et 7.1.1. La version 6.11.10 correspond à une mise à jour mineure de la version 6.11.9.

Il nous faudra donc spécifier une version valide, en l'occurence 6.11.10 si nous voulons rester sur la branche 15.11 de GitLab au moment de l'installation, ou bien l'une des deux autres version supérieures proposées.

Rappel : les correspondances entre versions du chart et versions de GitLab sont fournies ici :
https://docs.gitlab.com/charts/installation/version_mappings.html

Si vous souhaitez changer la version du chart helm utilisé, il vous suffira de relever le **numéro de version du chart** désiré **parmi ceux supportés par l'opérateur**, puis l'indiquer dans votre ressource `dsc` de configuration.

Par exemple, si vous utilisez la `dsc` par défaut nommée `conf-dso`, vous pourrez éditer le fichier YAML que vous aviez utilisé pour la paramétrer lors de l'installation, puis adapter la section suivante en y spécifiant le numéro souhaité au niveau du paramètre **chartVersion**. Exemple :

```yaml
  gitlab:
    insecureCI: true
    namespace: mynamespace-gitlab
    subDomain: gitlab
    version: "6.11.10"
```

Il vous suffit alors de mettre à jour votre configuration, exemple :

```bash
kubectl apply -f ma-conf-dso.yaml
```

Puis de relancer l'installation de GitLab :

```bash
ansible-playbook install.yaml -t gitlab
```

### Harbor

Tel qu'il est conçu, et s'il est utilisé avec la `dsc` de configuration par défaut sans modification, le rôle harbor déploiera la dernière version du [chart helm Harbor](https://github.com/goharbor/harbor-helm) disponible dans le cache des dépôts helm de l'utilisateur.

Ceci est lié au fait que le paramètre de configuration `chartVersion` de Harbor, présent dans la `dsc` par défaut `conf-dso`, est laissé vide (`chartVersion: ""`).

Pour connaître la dernière version du chart helm et de l'application actuellement disponibles dans votre cache local, utilisez la commande suivante : 

```bash
helm search repo harbor/harbor
```

Exemple de sortie avec un cache de dépôts qui n'est pas à jour :

```
NAME            CHART VERSION   APP VERSION     DESCRIPTION                                       
harbor/harbor   1.12.0          2.8.0           An open source trusted cloud native registry th...
```

Pour mettre à jour votre cache de dépôts helm, et obtenir ainsi la dernière version du chart et de l'application :

```bash
helm repo update
```

Relancer immédiatement la commande de recherche :

```bash
helm search repo harbor/harbor
```

Si votre cache n'était pas déjà à jour, la sortie doit alors vous indiquer des versions plus récentes.

Pour connaître la liste des versions de charts helm Harbor que vous pouvez maintenant installer, utilisez la commande suivante : 

```bash
helm search repo -l harbor/harbor
```

Si vous souhaitez fixer la version du chart helm, il vous suffira de relever le **numéro de version du chart** désiré, puis l'indiquer dans votre ressource `dsc` de configuration.

Par exemple, si vous utilisez la `dsc` par défaut nommée `conf-dso`, vous pourrez éditer le fichier YAML que vous aviez utilisé pour la paramétrer lors de l'installation, puis adapter la section suivante en y spécifiant le numéro souhaité au niveau du paramètre **chartVersion**. Exemple :

```yaml
  harbor:
    adminPassword: WhoWantsToPassForever
    namespace: mynamespace-harbor
    subDomain: harbor
    chartVersion: "1.12.2"
```

Il vous suffit alors de mettre à jour votre configuration, exemple :

```bash
kubectl apply -f ma-conf-dso.yaml
```
**Remarques importantes** :
* Il est fortement recommnandé de **sauvegarder votre base de données** avant de poursuivre, sauf s'il s'agit d'une première installation de Harbor, ou d'une [suppression complète](#un-ou-plusieurs-outils) suivie d'une réinstallation sans persistance des données.
* S'il s'agit d'un **upgrade** de version sans désinstallation préalable, il est également plutôt recommandé de réaliser cet upgrade **vers une version directement supérieure** et ainsi de suite, jusqu'à parvenir à la version désirée. Par exemple de "1.12.0" vers "1.12.1" puis vers "1.12.2".
* Le **downgrade** par mise à jour de la version du chart est source de problèmes. Il est susceptible de mal se passer et n'est donc pas recommandé. Mieux vaut désinstaller Harbor (cf. [désinstallation](#un-ou-plusieurs-outils)), puis procéder à sa réinstallation en spécifiant le numéro de version du chart souhaité, puis en important vos données sauvegardées.
* Fixer le numéro de version du chart Helm sera normalement suffisant pour fixer aussi le numéro de version des images associées. Le numéro de version de ces images sera celui visible dans la colonne "APP VERSION" de la commande `helm search repo -l harbor/harbor`.

Si vous avez bien pris connaissance des avertissements ci-dessus, vous pouvez maintenant relancer l'installation de Harbor, laquelle mettra à jour la version du chart et de l'application **avec coupure de service** :

```bash
ansible-playbook install.yaml -t harbor
```

Veuillez noter qu'un upgrade de version prendra facilement 8 à 10 minutes pour être pleinement finalisé, voire davantage selon les performances de votre cluster.

Pour fixer les versions d'images, voir ci-dessous.

#### Gel des images

En complément de l'usage du paramètre `chartVersion`, il est également possible de fixer les versions d'images de Harbor de façon plus fine (**recommandé en production**). 

Il sera ainsi possible de fixer l'image de chacun des composants.

Les différents tags utilisables sont disponibles ici :
* nginx : https://hub.docker.com/r/goharbor/nginx-photon/tags
* portal : https://hub.docker.com/r/goharbor/harbor-portal/tags
* core : https://hub.docker.com/r/goharbor/harbor-core/tags
* jobservice : https://hub.docker.com/r/goharbor/harbor-jobservice/tags
* registry (registry) : https://hub.docker.com/r/goharbor/registry-photon/tags
* registry (controller) : https://hub.docker.com/r/goharbor/harbor-registryctl/tags
* trivy : https://hub.docker.com/r/goharbor/trivy-adapter-photon/tags
* notary (server) : https://hub.docker.com/r/goharbor/notary-server-photon/tags
* notary (signer) : https://hub.docker.com/r/goharbor/notary-signer-photon/tags
* database : https://hub.docker.com/r/goharbor/harbor-db/tags
* redis : https://hub.docker.com/r/goharbor/redis-photon/tags
* exporter : https://hub.docker.com/r/goharbor/harbor-exporter/tags

**Rappel** : Il est néanmoins recommandé, si possible, de positionner des tags d'images en adéquation avec la version du chart Helm utilisé, c'est à dire d'utiliser le numéro "APP VERSION" retourné par la commande `helm search repo -l harbor/harbor` vue précédemment.

Pour spécifier nos tags, il nous suffira d'éditer la ressource `dsc` de configuration (par défaut ce sera la `dsc` nommée `conf-dso`) et de surcharger les "values" correspondantes du chart helm, en ajoutant celles dont nous avons besoin. Exemple :

```yaml
  harbor:
    adminPassword: WhoWantsToPassForever
    namespace: mynamespace-harbor
    subDomain: harbor
    chartVersion: 1.12.2
    values:
      persistence:
        persistentVolumeClaim:
          registry:
            size: 100Gi
      nginx:
        image:
          repository: docker.io/goharbor/nginx-photon
          tag: v2.8.2
      portal:
        image:
          repository: docker.io/goharbor/harbor-portal
          tag: v2.8.2
      core:
        image:
          repository: docker.io/goharbor/harbor-core
          tag: v2.8.2
      jobservice:
        image:
          repository: docker.io/goharbor/harbor-jobservice
          tag: v2.8.2
      registry:
        registry:
          image:
            repository: docker.io/goharbor/registry-photon
            tag: v2.8.2
        controller:
          image:
            repository: docker.io/goharbor/harbor-registryctl
            tag: v2.8.2
      trivy:
        image:
          repository: docker.io/goharbor/trivy-adapter-photon
          tag: v2.8.2
      notary:
        server:
          image:
            repository: docker.io/goharbor/notary-server-photon
            tag: v2.8.2
        signer:
          image:
            repository: docker.io/goharbor/notary-signer-photon
            tag: v2.8.2
      database:
        internal:
            image:
            repository: docker.io/goharbor/harbor-db
            tag: v2.8.2
      redis:
        internal:
            image:
            repository: docker.io/goharbor/redis-photon
            tag: v2.8.2
      exporter:
        image:
          repository: docker.io/goharbor/harbor-exporter
          tag: v2.8.2
```

Pour mémoire, les values utilisables sont disponibles et documentées ici : https://github.com/goharbor/harbor-helm/tree/master

Lorsque vos values sont à jour avec les versions désirées, appliquez le changement en utilisant votre fichier de définition, exemple :

```bash
kubectl apply -f ma-conf-dso.yaml
```

Puis relancez l'installation avec le tag `harbor` pour procéder au remplacement par les images spécifiées :

```bash
ansible-playbook install.yaml -t harbor
```

Lorsque l'installation a été relancée, surveillez les ressources présentes dans votre namespace Harbor, exemple :

```bash
watch "oc get all -n mynamespace-harbor"
```

Vous devriez observer la suppression et le remplacement des pods impactés par vos changements.

### Keycloak

Tel qu'il est conçu, et s'il est utilisé avec la `dsc` de configuration par défaut sans modification, le rôle keycloak déploiera la dernière version du [chart helm Bitnami Keycloak](https://bitnami.com/stack/keycloak/helm) disponible dans le cache des dépôts helm de l'utilisateur.

Ceci est lié au fait que le paramètre de configuration `chartVersion` de Keycloak, présent dans la `dsc` par défaut `conf-dso`, est laissé vide (`chartVersion: ""`).

Pour connaître la dernière version du chart helm et de l'application actuellement disponibles dans votre cache local, utilisez la commande suivante : 

```bash
helm search repo bitnami/keycloak
```

Exemple de sortie avec un cache de dépôts qui n'est pas à jour :

```
NAME                    CHART VERSION   APP VERSION     DESCRIPTION                                       
bitnami/keycloak        15.1.7          21.1.2          Keycloak is a high performance Java-based ident...
```

Pour mettre à jour votre cache de dépôts helm, et obtenir ainsi la dernière version du chart et de l'application :

```bash
helm repo update
```

Relancer immédiatement la commande de recherche :

```bash
helm search repo bitnami/keycloak
```

Si votre cache n'était pas déjà à jour, la sortie doit alors vous indiquer des versions plus récentes.

Pour connaître la liste des versions de charts helm de Keycloak que vous pouvez maintenant installer, utilisez la commande suivante : 

```bash
helm search repo -l bitnami/keycloak
```

Si vous souhaitez fixer la version du chart helm, et donc celle de Keycloak, il vous suffira de relever le **numéro de version du chart** désiré, puis l'indiquer dans votre ressource `dsc` de configuration.

Par exemple, si vous utilisez la `dsc` par défaut nommée `conf-dso`, vous pourrez éditer le fichier YAML que vous aviez utilisé pour la paramétrer lors de l'installation, puis adapter la section suivante en y spécifiant le numéro souhaité au niveau du paramètre **chartVersion**. Exemple :

```yaml
  keycloak:
    namespace: mynamespace-keycloak
    subDomain: keycloak
    chartVersion: "16.0.3"
```

Il vous suffit alors de mettre à jour votre configuration, exemple :

```bash
kubectl apply -f ma-conf-dso.yaml
```

Puis de relancer l'installation de Keycloak, laquelle mettra à jour la version du chart et l'image associée, sans coupure de service :

```bash
ansible-playbook install.yaml -t keycloak
```
#### Gel de l'image Keycloak

En complément de l'usage du paramètre `chartVersion`, il est également possible de fixer la version d'image de Keycloak de façon plus fine, en utilisant un tag dit "[immutable](https://docs.bitnami.com/kubernetes/apps/keycloak/configuration/understand-rolling-immutable-tags/)" (**recommandé en production**).

Les différents tags utilisables pour l'image de Keycloak sont disponibles ici : https://hub.docker.com/r/bitnami/keycloak/tags

Les tags dits "immutables" sont ceux qui possèdent un suffixe de type rXX, lequel correspond au numéro de révision. Ils pointent toujours vers la même image. Par exemple le tag "19.0.3-debian-11-r22" est un tag immutable.

Pour spécifier un tel tag, il nous suffira d'éditer la ressource `dsc` de configuration (par défaut ce sera la `dsc` nommée `conf-dso`) et de surcharger les "values" correspondantes du chart helm, en ajoutant celles dont nous avons besoin. Exemple :

```yaml
  keycloak:
    namespace: mynamespace-keycloak
    subDomain: keycloak
    chartVersion: "16.0.3"
    values:
      image:
        registry: docker.io
        repository: bitnami/keycloak
        tag: 19.0.3-debian-11-r22
```

Appliquer le changement en utilisant votre fichier de définition, exemple :

```bash
kubectl apply -f ma-conf-dso.yaml
```

Puis relancer l'installation avec le tag `keycloak` pour procéder au remplacement par l'image spécifiée, sans coupure de service :

```bash
ansible-playbook install.yaml -t keycloak
```

Pour mémoire, les values utilisables sont disponibles ici : https://github.com/bitnami/charts/blob/main/bitnami/keycloak/values.yaml

Les release notes de Keycloak se trouvent ici : https://github.com/keycloak/keycloak/releases
#### Gel de l'image PostgreSQL pour Keycloak

Tel qu'il est déployé, Keycloak s'appuie sur un cluster de base de donnée PostgreSQL géré par l'opérateur CloudNativePG.

Comme indiqué dans sa [documentation officielle](https://cloudnative-pg.io/documentation/1.20/quickstart/#part-3-deploy-a-postgresql-cluster), par défaut CloudNativePG installera la dernière version mineure disponible de la dernière version majeure de PostgreSQL au moment de la publication de l'opérateur.

De plus, comme l'indique la [FAQ officielle](https://cloudnative-pg.io/documentation/1.20/faq/), CloudNativePG utilise des conteneurs d'application immutables. Cela signifie que le conteneur ne sera pas modifié durant tout son cycle de vie (aucun patch, aucune mise à jour ni changement de configuration).

Il est toutefois possible et **recommandé en production** de fixer la version d'image de BDD pour Keycloak.

Pour cela, nous utiliserons l'un des tags d'image immutables proposés par CloudNativePG.

Les tags en question sont disponibles ici : https://github.com/cloudnative-pg/postgres-containers/pkgs/container/postgresql

Pour spécifier un tel tag, il nous suffira d'éditer la ressource `dsc` de configuration (par défaut ce sera la `dsc` nommée `conf-dso`) et d'indiquer le tag souhaité au niveau du paramètre `postgreSQLimageName`. Exemple :

```yaml
  keycloak:
    namespace: mynamespace-keycloak
    subDomain: keycloak
    chartVersion: "16.0.3"
    postgreSQLimageName: "ghcr.io/cloudnative-pg/postgresql:15.4"
    values:
      image:
        registry: docker.io
        repository: bitnami/keycloak
        tag: 19.0.3-debian-11-r22
```

**Attention !** : Comme indiqué dans la [documentation officielle de CloudNativePG](https://cloudnative-pg.io/documentation/1.20/quickstart/#part-3-deploy-a-postgresql-cluster) il ne faudra **jamais** utiliser en production de tag tel que `latest` ou juste `15` (sans numéro de version mineure).

Appliquer le changement en utilisant votre fichier de définition, exemple :

```bash
kubectl apply -f ma-conf-dso.yaml
```

Puis relancer l'installation avec le tag `keycloak` pour procéder au remplacement par l'image spécifiée, sans coupure de service :

```bash
ansible-playbook install.yaml -t keycloak
```

### Kubed (config-syncer)

**Attention !** Kubed est déployé dans le namespace "openshift-infra", **commun à toutes les instances de la chaîne DSO**. Si vous modifiez sa version, ceci affectera toutes les instances DSO installées dans un même cluster. Ce n'est pas forcément génant, car un retour arrière sur la version est toujours possible, mais l'impact est à évaluer si votre cluster héberge un environnement de production.

Tel qu'il est conçu, et s'il est utilisé avec la `dsc` de configuration par défaut sans modification, le rôle confSyncer qui sert à installer Kubed déploie par défaut la dernière version du [chart helm ](https://github.com/appscode/charts/tree/master/stable/kubed) disponible dans le cache des dépôts helm de l'utilisateur.

Ceci est lié au fait que le paramètre de configuration `chartVersion` de Kubed, présent dans la `dsc` par défaut `conf-dso`, est laissé vide (`chartVersion: ""`).

Pour connaître la dernière version du chart helm et de l'application actuellement disponibles dans votre cache local, utilisez la commande suivante : 

```bash
helm search repo kubed
```

Exemple de sortie avec un cache de dépôts qui n'est pas à jour :

```
NAME                                    CHART VERSION   APP VERSION     DESCRIPTION                                       
appscode/kubed                          v0.13.1         v0.13.1         Config Syncer by AppsCode - Kubernetes daemon
```

Pour mettre à jour votre cache de dépôts helm, et obtenir ainsi la dernière version du chart et de l'application :

```bash
helm repo update
```

Relancez alors la commande de recherche :

```bash
helm search repo kubed
```

Si votre cache n'était pas déjà à jour, la sortie doit alors vous indiquer des versions plus récentes.

Pour connaître la liste des versions de charts helm de Kubed que vous pouvez maintenant installer, utilisez la commande suivante : 

```bash
helm search repo -l kubed
```

Si vous souhaitez fixer la version du chart helm, et donc celle de Kubed, il vous suffira de relever le **numéro de version du chart** désiré, puis l'indiquer dans votre ressource `dsc` de configuration.

Par exemple, si vous utilisez la `dsc` par défaut nommée `conf-dso`, vous pourrez éditer le fichier YAML que vous aviez utilisé pour la paramétrer lors de l'installation, puis adapter la section suivante :

```yaml
  kubed:
    chartVersion: "v0.13.2"
```

Il vous suffit alors de mettre à jour votre configuration, exemple :

```bash
kubectl apply -f ma-conf-dso.yaml
```

Puis de relancer l'installation de Kubed, laquelle mettra à jour la version du chart et l'image associée, sans coupure de service :

```bash
ansible-playbook install.yaml -t kubed
```
**Remarque importante** : Le numéro de version du chart Helm est corrélé à celui de l'image utilisée pour l'application, de sorte que fixer ce numéro de version fixe aussi celui de l'image.

### Sonatype Nexus Repository

Le composant nexus est installé directement via le manifest de deployment "nexus.yml.j2" intégré au role associé.

Si vous utilisez la `dsc` par défaut nommée `conf-dso` c'est l'image "3.56.0" qui sera déployée.

Les tags d'images utilisables sont disponibles ici : https://hub.docker.com/r/sonatype/nexus3/tags

Pour déployer une autre version, il suffira d'éditer la `dsc`, de préférence avec le fichier YAML que vous avez initialement utilisé pendant l'installation, puis modifier la section suivante en y indiquant la version d'image désirée au niveau du paramètre **imageTag**. Exemple :

```yaml
  nexus:
    namespace: mynamespace-nexus
    subDomain: nexus
    storageSize: 100Gi
    imageTag: 3.55.0
```

Puis appliquer le changement de configuration, exemple :

```bash
kubectl apply -f ma-conf-dso.yaml
```
Et relancer l'installation de nexus, laquelle procédera à la mise à jour de version, **avec coupure de service** :

```bash
ansible-playbook install.yaml -t nexus
```

### SonarQube Community Edition

Le composant sonarqube est installé directement via le manifest de deployment "sonar-deployment.yaml.j2" intégré au role associé.

Si vous utilisez la `dsc` par défaut nommée `conf-dso` c'est l'image "9.9-community" qui sera déployée.

Les tags d'images utilisables pour l'édition community sont disponibles ici : https://hub.docker.com/_/sonarqube/tags?name=community

Pour déployer une autre version, il suffira d'éditer la `dsc`, de préférence avec le fichier YAML que vous avez initialement utilisé pendant l'installation, puis modifier la section suivante en y indiquant la version d'image désirée au niveau du paramètre **imageTag**. Exemple :

```yaml
  sonarqube:
    namespace: mynamespace-sonarqube
    subDomain: sonarqube
    imageTag: 9.9.1-community
```

Puis appliquer le changement de configuration, exemple :

```bash
kubectl apply -f ma-conf-dso.yaml
```
Et relancer l'installation de sonarqube, laquelle procédera à la mise à jour de version **avec coupure de service** :

```bash
ansible-playbook install.yaml -t sonarqube
```

### SOPS

Tel qu'il est conçu, et s'il est utilisé avec la `dsc` de configuration par défaut sans modification, le rôle sops déploiera la dernière version du [chart helm SOPS](https://github.com/isindir/sops-secrets-operator) disponible dans le cache des dépôts helm de l'utilisateur.

Ceci est lié au fait que le paramètre de configuration `chartVersion` de SOPS, présent dans la `dsc` par défaut `conf-dso`, est laissé vide (`chartVersion: ""`).

Pour connaître la dernière version du chart helm et de l'application actuellement disponibles dans votre cache local, utilisez la commande suivante : 

```bash
helm search repo sops/sops-secrets-operator
```

Exemple de sortie avec un cache de dépôts qui n'est pas à jour :

```
NAME                            CHART VERSION   APP VERSION     DESCRIPTION                             
sops/sops-secrets-operator      0.14.2          0.8.2           Helm chart deploys sops-secrets-operator
```

Pour mettre à jour votre cache de dépôts helm, et obtenir ainsi la dernière version du chart et de l'application :

```bash
helm repo update
```

Relancer immédiatement la commande de recherche :

```bash
helm search repo sops/sops-secrets-operator
```

Si votre cache n'était pas déjà à jour, la sortie doit alors vous indiquer des versions plus récentes.

Pour connaître la liste des versions de charts helm de SOPS que vous pouvez maintenant installer, utilisez la commande suivante : 

```bash
helm search repo -l sops/sops-secrets-operator
```

Si vous souhaitez fixer la version du chart helm, il vous suffira de relever le **numéro de version du chart** désiré, puis l'indiquer dans votre ressource `dsc` de configuration.

Par exemple, si vous utilisez la `dsc` par défaut nommée `conf-dso`, vous pourrez éditer le fichier YAML que vous aviez utilisé pour la paramétrer lors de l'installation, puis adapter la section suivante en y spécifiant le numéro souhaité au niveau du paramètre **chartVersion**. Exemple :

```yaml
  sops:
    namespace: mynamespace-sops
    chartVersion: "0.15.1"
```

Il vous suffit alors de mettre à jour votre configuration, exemple :

```bash
kubectl apply -f ma-conf-dso.yaml
```

Puis de relancer l'installation de SOPS, laquelle mettra à jour la version du chart sans coupure de service :

```bash
ansible-playbook install.yaml -t sops
```

Pour fixer la version d'image, voir ci-dessous.

#### Gel de l'image

En complément de l'usage du paramètre `chartVersion`, il est également possible de fixer la version d'image de SOPS de façon plus fine (**recommandé en production**). 

Pour spécifier cette version d'image, il nous suffira d'éditer la ressource `dsc` de configuration (par défaut ce sera la `dsc` nommée `conf-dso`) et de surcharger les "values" correspondantes du chart helm, en ajoutant celles dont nous avons besoin. Exemple :

```yaml
  sops:
    namespace: mynamespace-sops
    chartVersion: "0.15.1"
    values:
      image:
        tag: 0.9.1
```

Pour mémoire, les values utilisables sont disponibles et documentées ici : https://github.com/isindir/sops-secrets-operator/tree/master/chart/helm3/sops-secrets-operator

Les numéros de version de chart Helm et d'image se trouvent ici : https://github.com/isindir/sops-secrets-operator/blob/master/README.md#versioning

S'agissant de l'image, ces numéros correspondent à la colonne "Operator".

Il est également possible de les retrouver via la commande de recherche dans vos dépôts Helm vue précédemment :

```bash
helm search repo -l sops/sops-secrets-operator
```

Ceci à condition que vos dépôts soient à jour.

Lorsque vos values ont été actualisées, avec la version d'image désirée, appliquez le changement en utilisant votre fichier de définition, exemple :

```bash
kubectl apply -f ma-conf-dso.yaml
```
Puis relancez l'installation avec le tag `sops` pour procéder à la mise à jour et au gel de l'image :

```bash
ansible-playbook install.yaml -t sops
```

La mise à jour du pod s'effectuera sans coupure de service.

### Vault

Tel qu'il est conçu, et s'il est utilisé avec la `dsc` de configuration par défaut sans modification, le rôle vault déploiera la dernière version du [chart helm Hashicorp Vault](https://developer.hashicorp.com/vault/docs/platform/k8s/helm) disponible dans le cache des dépôts helm de l'utilisateur.

Ceci est lié au fait que le paramètre de configuration `chartVersion` de Vault, présent dans la `dsc` par défaut `conf-dso`, est laissé vide (`chartVersion: ""`).

Pour connaître la dernière version du chart helm et de l'application actuellement disponibles dans votre cache local, utilisez la commande suivante : 

```bash
helm search repo hashicorp/vault
```

Exemple de sortie avec un cache de dépôts qui n'est pas à jour :

```
NAME                                    CHART VERSION   APP VERSION     DESCRIPTION                               
hashicorp/vault                         0.24.1          1.13.1          Official HashiCorp Vault Chart
```

Pour mettre à jour votre cache de dépôts helm, et obtenir ainsi la dernière version du chart et de l'application :

```bash
helm repo update
```

Relancer immédiatement la commande de recherche :

```bash
helm search repo hashicorp/vault
```

Si votre cache n'était pas déjà à jour, la sortie doit alors vous indiquer des versions plus récentes.

Pour connaître la liste des versions de charts helm de Vault que vous pouvez maintenant installer, utilisez la commande suivante : 

```bash
helm search repo -l hashicorp/vault
```

Si vous souhaitez fixer la version du chart helm, il vous suffira de relever le **numéro de version du chart** désiré, puis l'indiquer dans votre ressource `dsc` de configuration.

Par exemple, si vous utilisez la `dsc` par défaut nommée `conf-dso`, vous pourrez éditer le fichier YAML que vous aviez utilisé pour la paramétrer lors de l'installation, puis adapter la section suivante en y spécifiant le numéro souhaité au niveau du paramètre **chartVersion**. Exemple :

```yaml
  vault:
    namespace: mynamespace-vault
    subDomain: vault
    chartVersion: 0.25.0
```

Il vous suffit alors de mettre à jour votre configuration, exemple :

```bash
kubectl apply -f ma-conf-dso.yaml
```

Puis de relancer l'installation de Vault, laquelle mettra à jour la version du chart sans coupure de service :

```bash
ansible-playbook install.yaml -t vault
```

**Remarque importante** : Le changement du paramètre `chartVersion` et la relance de l'installation ne mettra à jour que la version du chart Helm, et éventuellement l'image utilisée par le pod agent-injector si vous n'en avez pas déjà fixé la version.

Pour fixer les versions d'images, voir ci-dessous.

#### Gel des images

En complément de l'usage du paramètre `chartVersion`, il est également possible de fixer les versions d'images de Vault de façon plus fine (**recommandé en production**). 

Il sera ainsi possible de fixer l'image :
* du Vault Agent Sidecar Injector (via le repository hashicorp/vault-k8s),
* du Vault Agent (via le repository hashicorp/vault).

Les différents tags d'images utilisables sont disponibles ici :
* Pour le Vault Agent Sidecar Injector : https://hub.docker.com/r/hashicorp/vault-k8s/tags
* Pour le Vault Agent : https://hub.docker.com/r/hashicorp/vault/tags

Pour spécifier nos tags, il nous suffira d'éditer la ressource `dsc` de configuration (par défaut ce sera la `dsc` nommée `conf-dso`) et de surcharger les "values" correspondantes du chart helm, en ajoutant celles dont nous avons besoin. Exemple :

```yaml
  vault:
    namespace: mynamespace-vault
    subDomain: vault
    chartVersion: 0.25.0
    values:
      injector:
        image:
          repository: "docker.io/hashicorp/vault-k8s"
          tag: "1.2.1"
          pullPolicy: IfNotPresent
        agentImage:
          repository: "docker.io/hashicorp/vault"
          tag: "1.13.4"
      server:
        image:
          repository: "docker.io/hashicorp/vault"
          tag: "1.13.4"
          pullPolicy: IfNotPresent
        updateStrategyType: "RollingUpdate"
```

**Remarque importante** : Dans la section `server` de vos values, le paramètre `updateStrategyType` doit impérativement être présent et positionné sur "RollingUpdate" pour que l'image du serveur Vault puisse se mettre à jour avec le tag que vous avez indiqué.

Pour mémoire, les values utilisables sont disponibles et documentées ici : https://developer.hashicorp.com/vault/docs/platform/k8s/helm/configuration

Lorsque vos values sont à jour avec les versions désirées, appliquez le changement en utilisant votre fichier de définition, exemple :

```bash
kubectl apply -f ma-conf-dso.yaml
```

Puis relancez l'installation avec le tag `vault` pour procéder au remplacement par les images spécifiées :

```bash
ansible-playbook install.yaml -t vault
```

La mise à jour des pods s'effectuera **avec coupure de service**.

Lorsque l'installation a été relancée, vérifiez les ressources présentes dans votre namespace de Vault, exemple :

```bash
oc get all -n mynamespace-vault
```

Il se peut que le pod vault-0 se retrouve en "STATUS Running" mais ne soit pas "READY".

Si tel est la cas, relancez simplement l'installation avec le tag `vault`, comme vu plus haut :

```bash
ansible-playbook install.yaml -t vault
```

Puis revérifiez l'état du vault-0 qui devrait maintenant être déployé comme attendu.
