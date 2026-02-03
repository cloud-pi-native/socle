# Installation du socle de la plateforme Cloud π Native

Ce document décrit les étapes nécessaires à l'installation du socle de la plateforme Cloud π Native (aussi appelée `DSO` pour `DevSecOps`).

### Prérequis

L'installation du socle se fait de manière automatisée et nécessite quelques prérequis.

#### Prérequis système

Vous aurez besoin d'une machine avec les outils suivants installés :

- [Git](https://git-scm.com/install/)
- [uv](https://docs.astral.sh/uv/)
- [Python 3](https://www.python.org/downloads/)
- [Ansible 12+](https://docs.ansible.com/projects/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible-with-pip)
  - [Ansible Galaxy](https://galaxy.ansible.com/docs/install/index.html) pour la gestion des collections Ansible (par défaut, elle est installée avec Ansible)
  - La collection [kubernetes.core](https://docs.ansible.com/projects/ansible/latest/collections/kubernetes/core/index.html)
  - La collection [community.hashi_vault](https://docs.ansible.com/projects/ansible/latest/collections/community/hashi_vault/index.html)
- [kubectl](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/)
- [Helm](https://helm.sh/fr/docs/intro/install/)
- [yq](https://github.com/mikefarah/yq/#install)
- [k9s](https://k9scli.io/topics/install/) (utile pour debug et administration)

Pour installer les pre-requis Python et Ansible, utilisez la commande suivante :

```bash
uv sync
source .venv/bin/activate
```

Les dépendances (incluant Ansible et ses modules requis) sont gérées via [uv](https://docs.astral.sh/uv/) pour garantir un environnement isolé et reproductible.

Une fois l'environnement activé, installez les collections Ansible :

```bash
ansible-galaxy collection install kubernetes.core community.hashi_vault
```

#### Prérequis cluster d'administration

Vous devez disposer d'un cluster d'administration comportant les instances suivantes :

- **Vault** (pour stocker les secrets des applications du Socle mots de passe, URLs, etc.).
- **Argo CD**, disposant du [**plugin Vault**](https://argocd-vault-plugin.readthedocs.io/en/stable/) paramétré pour communiquer avec le Vault.
- (Optionnel) **Keycloak** (pour la connexion aux deux outils précédents).

Nous appellerons ces instances **Vault d'infrastructure** et **Argo CD d'infrastructure**.

Argo CD d'infrastructure utilise des `applicationSet` pour déployer des `applications` du Socle dans le cluster cible.

#### Prérequis cluster cible (cluster socle DSO)

Vous devez disposer d'un cluster cible Kubernetes ou OpenShift fonctionnel ou nous installerons le socle de la plateforme Cloud Pi Native.

Nous appellerons ce cluster **cluster socle**.

## Installation

L'installation de la plateforme Cloud Pi Native se fait de manière automatisée via Ansible.  
Veuillez suivre les étapes suivantes dans l'ordre pour installer la plateforme.

### 1. Création du dépôt GitOps

La première étape consiste à créer un dépôt Git sur GitHub ou sur votre serveur GitLab. Ce dépôt sera utilisé comme référentiel pour stocker les fichiers [IaC](https://fr.wikipedia.org/wiki/Infrastructure_as_code) (manifests, helm charts, etc...) de la plateforme Cloud Pi Native.

Une fois le dépôt créé, vous pouvez cloner le dépôt sur votre machine locale.

_**NB**: Veuillez sauvegarder dans un petit coin le chemin absolu du dépôt en local pour les prochaines étapes._

### 2. Récupération du dépôt Socle (Cloud Pi Native)

Dans un repertoire différent, récupérez le dépôt `socle` depuis le dépôt GitHub de Cloud Pi Native en exécutant la commande suivante :

```bash
git clone https://github.com/cloud-pi-native/socle.git
```

Ce dépôt contient les fichiers de configuration et des rôles Ansible pour l'installation de la plateforme Cloud Pi Native.

### 3. Création de la CRD de configuration pour la plateforme Cloud Pi Native

Pour des besoins de configurations, nous avons mis à disposition une [CRD](https://kubernetes.io/fr/docs/concepts/extend-kubernetes/api-extension/custom-resources/#customresourcedefinitions) qui sera utilisée pour configurer les paramètres de la plateforme Cloud Pi Native.

Sur le **cluster socle**, veuillez créer la custom resource definition de configuration avec la commande suivante :

```bash
kubectl apply -f roles/socle-config/templates/crd-conf-dso.yaml
```

### 4. Configuration (DSC) pour la plateforme Cloud Pi Native

Afin de paramétrer l'installation de la plateforme, créez la ressource de configuration `dsc` pour le paramétrage de la plateforme Cloud Pi Native et éditez-la en fonction du besoin de votre installation.

Sur le **cluster socle**, créez la `dsc` avec la commande suivante :

```bash
kubectl apply -f roles/socle-config/files/cr-conf-dso-default.yaml
kubectl edit dsc conf-dso
```

Veuillez consulter la section [Configuration DSC](#configuration-dsc) pour plus de détails.

Une fois la configuration créée, nous allons pouvoir passer aux étapes suivantes.

### 5. Variables d'environnement

Il est nécessaire de définir quelques variables d'environnement pour que le playbook Ansible puisse fonctionner correctement.

```bash
# Chemin absolu vers le dépôt GitOps (le dépôt de la première étape)
export GITOPS_REPO_PATH=/chemin/absolu/vers/votre/dépôt-gitops

# Chemin absolu vers votre kubeconfig pour le cluster d'administration
export KUBECONFIG_INFRA=/chemin/absolu/vers/votre/kubeconfig-cluster-infra

# Variables d'environnement pour le Vault d'infrastructure
export VAULT_INFRA_DOMAIN=infra-vault.example.com
export VAULT_INFRA_TOKEN=vault-infra-token
```

Si vous utilisez un proxy pour accéder à votre cluster d'administration, vous devez également définir la variable d'environnement `KUBECONFIG_PROXY_INFRA` avec le chemin absolu vers votre configuration proxy.  
Exemple :

```bash
export KUBECONFIG_PROXY_INFRA=http://proxy.server.com:3128
```

### 6. Génération des fichiers IaC pour la plateforme Cloud Pi Native

Pour générer les fichiers IaC pour la plateforme Cloud Pi Native, assurez-vous d'avoir bien les prérequis (configuration, variables d'environnement, création de la configuration DSC) et exécutez la commande suivante :

```bash
ansible-playbook install-gitops.yaml
```

Cette commande va générer les fichiers IaC pour la plateforme Cloud Pi Native dans le dépôt GitOps local. Ce playbook va également générer un secret engine `KeyValue` avec le chemin `dso-<envName>` dans le vault d'infrastructure pour stocker les secrets des outils de la plateforme Cloud Pi Native.

### 7. Modification des secrets dans le vault d'infrastructure

Afin d'apporter les informations d'authentification nécessaires pour les connexions au bucket S3, au docker Hub et au service SMTP, modifier les secrets générés par l'étape précédente dans le vault d'infra pour les chemins suivants :

- `dso-<envName>/env/conf-dso/apps/global/values`
- `dso-<envName>/env/conf-dso/apps/harbor/values`

Afin de vous faciliter cette étape, nous proposons le playbook `credentials-to-vault.yaml` situé dans le répertoire `admin-tools`.

Pour le lancer en utilisant la configuration par défaut (dsc `conf-dso`) :

```shell
ansible-playbook admin-tools/credentials-to-vault.yaml
```

La commande créera pour vous le fichier `/tmp/my-credentials.yaml` qu'il vous invitera **à remplir avant de relancer le playbook** pour mettre à jour les secrets dans le vault d'infrastructure.

### 8. Configuration première installation de Nexus

En cas de premiere installation de l'outil Nexus, il faudra mettre le champs `nexus.chownDataDir` à `true` dans le fichier `values.yaml` du chart Helm générés par le playbook `rendering-apps-files.yaml` situé dans le répertoire `gitops/envs/conf-dso/apps/nexus`.

**NB**: Une fois Nexus installé et configuré, il est recommandé de mettre à jour le champs `nexus3.chownDataDir` à `false` pour éviter de modifier les permissions des fichiers de Nexus.

### 9. Pousser les fichiers IaC générés dans le dépôt GitOps

Une fois les fichiers IaC générés, poussez-les dans le dépôt GitOps pour qu'ils soient disponibles pour l'installation de la plateforme Cloud Pi Native.

```bash
git add .
git commit -m "feat: init CPiN install"
git push
```

### 10. Installation de la plateforme Cloud Pi Native

Si dans votre configuration, vous avez activé le paramètre `global.gitOps.watchpointEnabled`, vous devez finaliser la configuration de votre depot GitOps sur le Argo CD d'infrastructure.

Pour cela, exécutez la commande suivante :

```bash
ansible-playbook install-gitops.yaml -t dso-app
```

Cette commande va créer l'`applicationSet` `<envName>-dso-install-manager` dans l'Argo CD d'infrastructure et la synchronisation installera les applications du Socle dans le cluster cible.

Si le paramètre `global.gitOps.watchpointEnabled` est désactivé, l'`applicationSet` `<envName>-dso-install-manager` sera automatiquement créée, vous pouvez lancer la synchronisation manuellement sur l'Argo CD d'infrastructure.

### 11. Acceptation des conditions de service

Une fois la plateforme Cloud Pi Native installée, vous devez accepter les conditions de service de certains outils de la plateforme. Pour le moment, il ne s'agit que de l'outil Nexus.

Connectez-vous au Nexus et acceptez les conditions de service.

**NB**: Une [issue](https://github.com/cloud-pi-native/socle/issues/752) est actuellement ouverte pour nous permettre de configurer automatiquement les conditions de service de Nexus.

### 12. Ajout d'un cluster d'applications mutualisées

Connectez-vous en tant que administrateur à la console Cloud Pi Native et ajoutez un cluster d'applications mutualisées.

Pour cela, allez dans la page `Clusters` dans la section `Administration` et suivez les instructions de la [documentation](https://cloud-pi-native.fr/administration/clusters) pour ajouter un cluster.

### 13. Ajout d'utilisateurs à la plateforme Cloud Pi Native

Sur le dépôt GitOps, effectuez une modification du fichier `gitops/envs/conf-dso/apps/keycloak/templates/users.yaml` pour ajouter des utilisateurs au Keycloak de la plateforme Cloud Pi Native. Une fois le fichier modifié, poussez-le dans le dépôt GitOps.

```bash
git add .
git commit -m "feat: add users"
git push
```

### 14. Initialisation avec le projet Test

Une fois le cluster mutualisé créé, connectez vous en tant qu'utilisateur et initialisez un premier projet test avec le projet GitHub suivant :

https://github.com/cloud-pi-native/socle-project-test

Ajoutez ce projet en tant que repo infra.

Suivez la procédure décrite dans la [documentation](https://cloud-pi-native.fr/guide/projects-management) sur la gestion des projets

Une fois le projet créé, veuillez synchroniser le dépôt du projet avec la fonctionnalité synchronisation sur la console Cloud Pi Native.

Cette synchronisation va dupliquer le dépôt dans le GitLab de la plateforme. Le dépôt contient des pipelines de test de la plateforme Cloud Pi Native pour confirmer le bon fonctionnement de la plateforme DSO

## Configuration DSC

Pour configurer la ressource `dsc` nommée `conf-dso`, vous pouvez soit la modifier directement via la commande suivante :

```bash
kubectl edit dsc conf-dso
```

Ou vous pouvez déclarer la ressource `dsc` nommée `conf-dso` dans un fichier YAML, par exemple « ma-conf-dso.yaml », puis la créer via la commande suivante :

```bash
kubectl apply -f ma-conf-dso.yaml
```

Pour vous aider à démarrer, le fichier [cr-conf-dso-default.yaml](roles/socle-config/files/cr-conf-dso-default.yaml) est un **exemple** de configuration également utilisé lors de la première installation. Il surcharge les valeurs par défaut des fichiers [config.yaml](roles/socle-config/files/config.yaml) et [releases.yaml](roles/socle-config/files/releases.yaml). Ce fichier doit être adapté à partir de la section **spec**, en particulier pour les éléments suivants :

- du paramètre `global.rootDomain` (votre domaine principal précédé d'un point),
- des mots de passe de certains outils,
- du paramètre `global.platform` (définir à `kubernetes` si vous n'utilisez pas OpenShift),
- de la taille de certains PVCs,
- de l'activation ou non des métriques,
- du proxy si besoin ainsi que des sections CA et ingress.

Les champs utilisables dans cette ressource de type **dsc** peuvent être décrits pour chaque outil à l'aide de la commande `kubectl explain`. Exemple avec Argo CD :

```shell
kubectl explain dsc.spec.argocd
```

Avant de lancer l'installation avec la dsc configurée, n'hésitez pas à lancer la commande ci-dessus pour obtenir la description de tout champ sur lequel vous avez un doute.

Par ailleurs, les valeurs des helm charts peuvent être surchargées en ajoutant le paramètre `values` au service concerné. Ces `values` dépendent de la [version du helm chart](/versions.md) et peuvent être consultées avec la commande `helm show values`. Exemple avec l'opérateur GitLab :

```shell
helm show values gitlab-operator/gitlab-operator --version 2.4.1
```

### Utilisation de vos propres values

Comme nous pouvons le voir dans l'exemple de configuration fourni ci-dessus, plusieurs outils sont notamment configurés à l'aide d'un champ `values`.

Il s'agit de valeurs de chart [Helm](https://helm.sh/fr). Vous pouvez les utiliser ici pour surcharger les valeurs par défaut.

Voici les liens vers les documentations de chart Helm pour les outils concernés :

- [Argo CD](https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd)
- [Console Cloud π Native](https://github.com/cloud-pi-native/console#readme)
- [GitLab](https://gitlab.com/gitlab-org/charts/gitlab)
- [Harbor](https://github.com/goharbor/harbor-helm)
- [Keycloak](https://github.com/bitnami/charts/tree/main/bitnami/keycloak)
- [SonarQube](https://github.com/SonarSource/helm-chart-sonarqube)
- [HashiCorp Vault](https://github.com/hashicorp/vault-helm)

S'agissant du gel des versions de charts ou d'images pour les outils en question, **nous vous invitons fortement à consulter la section détaillée [Gel des versions](#gel-des-versions)** située plus bas dans le présent document.

### Configuration du domaine et certificat TLS pour l’Ingress

Les applications **d'infrastructure** doivent être exposées via le **domaine configuré** dans la ressource `conf-dso`.
Le cluster doit disposer d’un **Ingress** configuré avec un certificat TLS valide (fourni par une autorité de certification reconnue).

##### Cas 1 : certificat signé par une autorité valide

Aucune configuration supplémentaire n’est nécessaire, l’Ingress est directement utilisable.

##### Cas 2 : certificat auto-signé

Si vous utilisez un certificat auto-signé, vous devez exposer la **CA racine** pour que les autres composants puissent valider ce certificat.
Pour cela, ajoutez la CA racine dans un `Secret` ou un `ConfigMap`, puis référencez-le dans le champ `exposedCA` de la ressource `DSC`.

Exemple avec un Secret :

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: root-ca
  namespace: ingress-nginx
type: Opaque
stringData:
  ca: |
    -----BEGIN CERTIFICATE-----
    MIID...
    -----END CERTIFICATE-----
```

Et puis dans la configuration `dsc`:

```yaml
apiVersion: dso.cloud-pi-native.io/v1alpha1
kind: DSC
metadata:
  name: conf-dso
spec:
  exposedCA:
    type: secret
    secret:
      namespace: ingress-nginx
      name: root-ca
      key: ca
```

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
  - **Cert-manager** déployé dans le namespace `cert-manager`.
  - **CloudNativePG** déployé dans le namespace spécifié par le fichier « config.yaml » du role `socle-config`, déclaré lors de l'installation avec la `dsc` par défaut `conf-dso`.
  - **GitLab Operator** déployé dans le namespace spécifié par le fichier « config.yaml » du role `socle-config`, déclaré lors de l'installation avec la `dsc` par défaut `conf-dso`.
  - **Kyverno** déployé dans le namespace spécifié par le fichier « config.yaml » du role `socle-config`, déclaré lors de l'installation avec la `dsc` par défaut `conf-dso`.
- Les cinq composants en question pourraient en effet être utilisés par une autre instance de la chaîne DSO, voire par d'autres ressources dans le cluster. Si vous avez conscience des risques et que vous voulez malgré tout désinstaller l'un de ces outils, vous pourrez le faire via l'utilisation des tags correspondants :
  - Pour Cert-manager : `-t cert-manager`
  - Pour CloudNativePG : `-t cnpg` (ou bien `-t cloudnativepg`)
  - Pour GitLab Operator : `-t gitlab-operator`
  - Pour Kyverno : `-t kyverno`
- La fonctionnalité actuellement remplie par le role Kyverno était auparavant gérée par un role kubed. C'est la raison pour laquelle la désinstallation de kubed est toujours disponible. Si kubed est encore présent dans votre cluster hébergeant le socle DSO, nous vous recommandons sa désinstallation via l'utilisation du tag `-t kubed` (ou `-t confSyncer`).

### Désinstaller un ou plusieurs outils

Le playbook de désinstallation peut aussi être utilisé pour supprimer un ou plusieurs outils **de manière ciblée**, via les tags associés.

L'idée est de faciliter leur réinstallation complète, en utilisant ensuite le playbook d'installation (voir la sous-section [Réinstallation](#réinstallation) de la section Debug).

Par exemple, pour désinstaller uniquement les outils Keycloak et Argo CD configurés avec la `dsc` par défaut (`conf-dso`), la commande sera la suivante :

```bash
ansible-playbook uninstall.yaml -t keycloak,argocd
```

Pour faire la même chose sur les mêmes outils, mais s'appuyant sur une autre configuration (via une `dsc` nommée `ma-dsc`), vous rajouterez là encore l'[extra variable](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#defining-variables-at-runtime) `dsc_cr`. Exemple :

```bash
ansible-playbook uninstall.yaml -t keycloak,argocd -e dsc_cr=ma-dsc
```

**Remarque importante** : Si vous désinstallez la ressource **console** via le tag approprié, et que vous souhaitez ensuite la réinstaller, vous devrez impérativement **relancer une installation complète** du socle DSO (sans tags) plutôt que de réinstaller la console seule. En effet, la configmap `dso-config` qui lui est associée est alimentée par les autres outils à mesure de leur installation.
