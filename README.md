# Documentation d'installation de la plateforme DSO

## Sommaire
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

L'installation de la forge DSO se fait via Ansible. Chaque éléme,nt sera donc installé d manière automatisé, certains peuvent prendre un peu de temps (keycloak)

## Prérequis

Cette installation s'effectue dans un cluster Openshift opérationnel et correctement démarré.

Elle nécessite l'utilisation de [ce dépôt](https://github.com/dnum-mi/dso-socle) qui devra donc être cloné sur votre environnement de déploiement.

Elle nécessitera l'installation des éléments suivants :

- Ansible (pour disposer de la commande ansible-playbook) :
  https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

  et ses collections:
  - kubernetes.core
  - community.general

- Ainsi que les dépendances python:
  - kubernetes

- La commande kubectl :
  https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

- Un accès admin au clusteur

- La commande helm :
  https://helm.sh/docs/intro/install/

- La commande yq (pour debug):
  https://github.com/mikefarah/yq/#install

## Configuration

Une fois le dépôt infra-socle cloné, copiez le fichier vars.example.yaml en vars.yaml puis adaptez les variables suivant votre environnement.

Note: Pour l'instant il est nécessaire de renseigner les variables PROXY

## Installation

### Lancement
Jouez la commande suivante

```ansible-playbook install.yaml```

Patientez...

### Récupération des secrets
Certains outils au moment de leur initialisation stockent des secrets qui ne sont plus disponible plus tard normalement.

Pour garantir l'idempotence ces secrets sont stockés dans plusieurs endroits, supprimer ces ressources indique à ansible qu'il doit réinitialiser les composants. **Faites donc bien attention !**

#### Vault
Les Unseal Keys sont accessibles par la commande
```kubectl get secrets vault-keys -n openshift-infra -o yaml```
Vous pouvez conservez ces valeurs ailleurs mais il est important de **ne pas le modifier ou le supprimer** sous peine de voir Vault être réinitialiser

#### Autres Composants
Les identifiants (mots de passes, tokens, clés) des autres outils sont stockés dans un ConfigMap
```kubectl get cm ansible-inventory -n openshift-infra -o yaml```

De la même manière que pour Vault ces informations définissent le comportement d'ansible en cas de nouvelle éxécution (regénération de token, réinitialisation de l'outil, **potentielle perte de données**)

### Debug
#### Réinstallation
Si vous rencontrez des problèmes lors de l'éxécution du playbook et que vous ne souhaitez relancer l'installation que d'un ou de plusieurs composants vous pouvez les tags associés au rôle dans le fichier install.yaml

```ansible-playbook install.yaml -t keycloak,console```

#### Keycloak
L'opérateur keycloak peut-être assez capricieux, son état souhaité est `status.phase == 'reconciling'`

En cas d'échec lors de l'installation vous vérifiez avec la commande `kubectl get keycloak dso-keycloak -n keycloak-system -o yaml`

Il se peut qu'il reste bloqué en status `Initializing` mais que tout soit provisionné. dans ce cas lancez plutôt
```ansible-playbook install.yaml -e KEYCLOAK_NO_CHECK=```

