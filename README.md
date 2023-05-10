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
      - [Vault](#vault)
      - [Autres Composants](#autres-composants)
    - [Debug](#debug)
      - [Réinstallation](#réinstallation)
      - [Keycloak](#keycloak)

## Introduction

L'installation de la forge DSO (DevSecOps) se fait via Ansible. Chaque élément sera donc installé de manière automatisée. Certains peuvent prendre un peu de temps (par exemple keycloak).

## Prérequis

Cette installation s'effectue dans un cluster OpenShift opérationnel et correctement démarré.

Elle nécessite l'utilisation de [ce dépôt](https://github.com/dnum-mi/dso-socle) qui devra donc être cloné sur votre environnement de déploiement.

Elle nécessitera d'avoir installé au préalable les éléments suivants :

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

- La dépendance python kubernetes.

- La commande [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/).

- Un accès admin au cluster.

- La commande [helm](https://helm.sh/docs/intro/install/).

- La commande [yq](https://github.com/mikefarah/yq/#install) (pour debug).

- L'outil d'encryption [age](https://github.com/FiloSottile/age), qui fournit les commandes `age` et `age-keygen`.

## Configuration

Une fois le dépôt dso-socle cloné, copiez le fichier `vars.example.yaml` vers `vars.yaml` puis adaptez les variables de ce dernier selon les caractéristiques propres à votre environnement.

Note : Pour l'instant il est nécessaire de renseigner les variables PROXY.

## Installation

### Lancement
Jouez la commande suivante :

```ansible-playbook install.yaml```

Patientez …

### Récupération des secrets
Au moment de leur initialisation, certains outils stockent des secrets qui ne sont en principe plus disponibles ultérieurement.

**Attention !** Pour garantir l'[idempotence](https://fr.wikipedia.org/wiki/Idempotence), ces secrets sont stockés dans plusieurs ressources du cluster. Supprimer ces ressources **indique à ansible qu'il doit réinitialiser les composants**.

#### Vault
Les "Unseal Keys" et le "root token" du composant Vault sont accessibles par la commande suivante :

```kubectl get secrets vault-keys -n vault-system -o yaml | yq .data```

Ces éléments sont encodés en base64.

Il est possible de décoder chaque valeur une par une, via la commande suivante :

```echo "valeur_ici" | base64 -d```

Pour obtenir tous les éléments décodés en une seule fois, on pourra utiliser la commande suivante :

```SAVEIFS=$IFS && IFS=$(echo -en "\n\b") && for i in $(kubectl get secrets vault-keys -n vault-system -o yaml | yq .data); do echo -n "$i" | cut -z -d " " -f 1 ; echo -n " " ; echo -n "$i" | cut -d " " -f 2 | base64 -d ; echo ; done && IFS=$SAVEIFS```

Vous pouvez conserver les valeurs ainsi obtenues ailleurs, par exemple dans un fichier de base de données chiffré de type KeePass ou Bitwarden, mais il est important de **ne pas les modifier ou les supprimer** sous peine de voir Vault être réinitialisé.

#### Autres Composants
Les identifiants (mots de passe, tokens, clés) des autres outils sont stockés dans un ConfigMap accessible via la commande suivante :

```kubectl get cm dso-config -n console-pi-system -o yaml | yq ".data"```

De la même manière que pour Vault, ces informations définissent le comportement d'ansible en cas de nouvelle exécution (regénération de token, réinitialisation de l'outil, **potentielle perte de données**).

### Debug
#### Réinstallation
Si vous rencontrez des problèmes lors de l'éxécution du playbook, vous voudrez certainement relancer l'installation d'un ou plusieurs composants plutôt que d'avoir à tout réinstaller.

Pour cela, vous pouvez utiliser les tags associés au rôle dans le fichier `install.yaml`. Voici par exemple comment réinstaller uniquement les composants keycloak et console, via les tags correspondants :

```ansible-playbook install.yaml -t keycloak,console```

#### Keycloak
L'opérateur keycloak peut-être assez capricieux. Son état souhaité est `status.phase == 'reconciling'`.

En cas d'échec lors de l'installation, vous vérifierez ce qu'il en est avec la commande :

```kubectl get keycloak dso-keycloak -n {{ KEYCLOAK.NAMESPACE }} -o yaml```

Il se peut que Keycloak reste bloqué en status "initializing" mais que tout soit provisionné. Dans ce cas, relancez plutôt le playbook comme ceci :

```ansible-playbook install.yaml -e KEYCLOAK_NO_CHECK=```

