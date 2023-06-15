# Installation de la plateforme DSO

## Sommaire
- [Installation de la plateforme DSO](#installation-de-la-plateforme-dso)
  - [Sommaire](#sommaire)
  - [Introduction](#introduction)
  - [Prérequis](#prérequis)
  - [Configuration](#configuration)
  - [Installation](#installation)
    - [Lancement](#lancement)
  - [Récupération des secrets](#récupération-des-secrets)
  - [Debug](#debug)
    - [Réinstallation](#réinstallation)
    - [Keycloak](#keycloak)

## Introduction

L'installation de la forge DSO (DevSecOps) se fait **via Ansible**. Chaque élément sera donc installé de manière automatisée. Certains peuvent prendre un peu de temps (par exemple keycloak ou gitlab).

## Prérequis

Cette installation s'effectue dans un cluster OpenShift opérationnel et correctement démarré.

Elle nécessite l'utilisation de [ce dépôt](https://github.com/cloud-pi-native/socle) qui devra donc être cloné sur votre environnement de déploiement ([Ansible control node](https://docs.ansible.com/ansible/latest/network/getting_started/basic_concepts.html#control-node)).

Elle nécessitera d'avoir installé au préalable les éléments suivants **sur l'environnement de déploiement** :

- Modules python :
  - pyyaml
  - kubernetes
  - python-gitlab

Exemple d'installation du module python-gitlab pour l'utilisateur courant :

```python3 -m pip install --user python-gitlab```

- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) (pour disposer de la commande ansible-playbook).

  - Ainsi que les collections suivantes :
    - [kubernetes.core](https://github.com/ansible-collections/kubernetes.core)
    - [community.general](https://github.com/ansible-collections/community.general)

- La commande [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/).

- Un accès administrateur au cluster.

- Le fichier de configuration ```~/.kube/config``` paramétré avec les accès administrateur pour l'appel à l'API du cluster (section users).

- La commande [helm](https://helm.sh/docs/intro/install/).

- La commande [yq](https://github.com/mikefarah/yq/#install) (facultative, utile pour debug).

- L'outil d'encryption [age](https://github.com/FiloSottile/age), qui fournit les commandes `age` et `age-keygen` nécessaires pour l'installation de SOPS.

## Configuration

Une fois le dépôt dso-socle cloné, lancez une première fois la commande suivante depuis votre environnement de déploiement :

```ansible-playbook install.yaml```

Elle vous signalera que vous n'avez encore jamais installé le socle sur votre cluster, puis vous invitera à modifier la resource de type **dsc** nommée **conf-dso** et de scope cluster
via la commande suivante :

```kubectl edit dsc conf-dso```

Lancer la commande ci-dessus pour éditer la ressource indiquée.

Alternativement, et comme précisé, vous pourrez aussi déclarer la ressource conf-dso dans un fichier YAML, nommé par exemple 'ma-conf-dso.yaml', puis la créer via la commande suivante :

```kubectl apply -f ma-conf-dso.yaml```

Voici un **exemple** de fichier de configuration valide, à adapter à partir de la section **spec**, notamment au niveau des mots de passe ou des numéros de versions :

````
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
  certmanager:
    version: v1.11.0
  console:
    dbPassword: AnotherPassBitesTheDust
    namespace: mynamespace-console
    release: 4.1.0
    subDomain: console
  gitlab:
    insecureCI: true
    namespace: mynamespace-gitlab
    subDomain: gitlab
    version: "6.11.5"
  global:
    projectsRootDir:
      - my-root-dir
      - projects-sub-dir
    rootDomain: .example.com
  harbor:
    adminPassword: WhoWantsToPassForever
    namespace: mynamespace-harbor
    subDomain: harbor
  ingress:
    tls:
      type: tlsSecret
      tlsSecret:
        name: ingress-tls
        method: in-namespace
  keycloak:
    namespace: mynamespace-keycloak
    subDomain: keycloak
  nexus:
    namespace: mynamespace-nexus
    subDomain: nexus
    storageSize: 100Gi
  proxy:
    enabled: true
    host: "192.168.xx.xx"
    http_proxy: http://192.168.xx.xx:3128/
    https_proxy: http://192.168.xx.xx:3128/
    no_proxy: .cluster.local,.svc,10.0.0.0/8,127.0.0.1,192.168.0.0/16,api-int.example.com,canary-openshift-ingress-canary.apps.example.com,console-openshift-console.apps.example.com,localhost,oauth-openshift.apps.example.com,svc.cluster.local,localdomain
    port: "3128"
  sonarqube:
    namespace: mynamespace-sonarqube
    subDomain: sonarqube
  sops:
    namespace: mynamespace-sops
  vault:
    namespace: mynamespace-vault
    subDomain: vault
````
## Installation

### Lancement
Jouez la commande suivante :

```ansible-playbook install.yaml```

Patientez …

## Récupération des secrets
Au moment de leur initialisation, certains outils stockent des secrets qui ne sont en principe plus disponibles ultérieurement.

**Attention !** Pour garantir l'[idempotence](https://fr.wikipedia.org/wiki/Idempotence), ces secrets sont stockés dans plusieurs ressources du cluster. Supprimer ces ressources **indique à ansible qu'il doit réinitialiser les composants**.

Afin de faciliter la récupération des secrets, un playbook d'administration nommé 'get-credentials.yaml' est mis à disposition dans le répertoire admin-tools.

Pour le lancer :

```ansible-playbook admin-tools/get-credentials.yaml```

Ce playbook permet également de cibler un outil en particulier, grâce à l'utilisation de tags qui sont listés au début de l'exécution, exemple avec keycloak :

```ansible-playbook admin-tools/get-credentials.yaml -t keycloak```

Vous pouvez conserver les valeurs ainsi obtenues ailleurs, par exemple dans un fichier de base de données chiffré de type KeePass ou Bitwarden, mais il est important de **ne pas les modifier ou les supprimer** sous peine de voir certains composants, par exemple Vault, être réinitialisés.
## Debug
### Réinstallation
Si vous rencontrez des problèmes lors de l'éxécution du playbook, vous voudrez certainement relancer l'installation d'un ou plusieurs composants plutôt que d'avoir à tout réinstaller.

Pour cela, vous pouvez utiliser les tags associés au rôle dans le fichier `install.yaml`. Voici par exemple comment réinstaller uniquement les composants keycloak et console, via les tags correspondants :

```ansible-playbook install.yaml -t keycloak,console```

### Keycloak
L'opérateur keycloak peut être assez capricieux. Son état souhaité est `status.phase == 'reconciling'`.

En cas d'échec lors de l'installation, vous vérifierez ce qu'il en est avec la commande :

```kubectl get keycloak dso-keycloak -n mynamespace-keycloak -o yaml```

Il se peut que Keycloak reste bloqué en status "initializing" mais que tout soit provisionné. Dans ce cas, relancez plutôt le playbook à partir de l'outil immédiatement suivant, à savoir  :

```ansible-playbook install.yaml -t nexus```
