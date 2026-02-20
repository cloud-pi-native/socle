# Installation d'un Argo CD dans une nouvelle zone

Ce document décrit les étapes nécessaires à l'installation d'un Argo CD dans une nouvelle zone.

### Prérequis

L'installation se fait de manière automatisée et nécessite quelques prérequis.

#### Prérequis Console DSO

Vous devez au préalable avoir créé une zone dans la console DSO.

Pour cela, en tant que Administrateur, allez dans la page `Zones` dans la section `Administration` et suivez les instructions de la [documentation](https://cloud-pi-native.fr/administration/zones) pour créer une zone.

La création d'une zone déclenchera la création d'un repository GitLab DSO de la zone dans le groupe `infra` ainsi que la création d'un client OIDC (`argocd-{nom_court_zone}-zone`) dans le Keycloak DSO. Le client secret OIDC sera stocké dans le Vault DSO.

**NB: Une fois la zone créée, vous aurez besoin du nom court de la zone ainsi que du repository GitLab de la zone pour pouvoir l'utiliser dans l'installation.**

#### Prérequis cluster de la zone

Vous devez disposer d'un cluster dans la zone avec les éléments suivants installés :

- Ingress Controller
- VSO (Vault Secrets Operator)

#### Prérequis système

Veuillez suivre les étapes de la section [Installation du socle de la plateforme Cloud Pi Native](../../../INSTALL.md#prérequis-système) pour installer les prérequis système.

## Installation

Veuillez suivre les étapes suivantes dans l'ordre pour installer l'instance Argo CD dans la nouvelle zone.

L'installation de l'instance Argo CD se fait de manière automatisée via Ansible.
Le processus se passe en deux étapes :

1. Création du secret GitLab pour l'instance Argo CD: le secret est utilisé par l'instance Argo CD pour authentifier sur le GitLab DSO
2. Installation de l'instance Argo CD à partir du chart Helm Argo CD incluant une application pour la nouvelle zone qui va déployer un AppSet DSO. L'AppSet DSO sera en charge de déployer les applications de la zone

### 1. Declaration des variables d'environnement

Il est nécessaire de définir quelques variables d'environnement pour que le playbook Ansible puisse fonctionner correctement.

```bash
# Chemin absolu vers un fichier values qui contient les valeurs personnalisées pour l'instance Argo CD pour la zone
# Un exemple de fichier values est disponible dans le répertoire ./helm/argocd/values.yaml
export CUSTOM_VALUE_FILE_PATH=/chemin/absolu/vers/custom-values.yaml

# Chemin absolu vers votre kubeconfig pour le cluster zone
export K8S_AUTH_KUBECONFIG=/chemin/absolu/vers/votre/kubeconfig-cluster-zone

# Variables d'environnement pour le nom d'environnement DSO auquel appartient la zone
export ENV_NAME=cpin-console-hp

# Variables d'environnement pour le Vault d'infrastructure
export VAULT_INFRA_DOMAIN=infra-vault.example.com
export VAULT_INFRA_TOKEN=vault-infra-token
```

### 2. Lancement du playbook

Pour installer l'instance Argo CD dans la nouvelle zone, utilisez la commande suivante :

```bash
ansible-playbook admin-tools/install-zone-argocd.yaml
```

Cette commande va installer l'instance Argo CD dans la zone et configurer sont rattachement au DSO de l'`ENV_NAME` cible.
