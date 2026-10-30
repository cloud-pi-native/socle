# NetworkPolicies

Le socle peut générer les NetworkPolicies des applications de la plateforme. Fonctionnalité **désactivée par défaut**.

## Prérequis

- `global.platform: kubernetes` (refusé sinon, vérifié par `socle-config`).
- CNI **Cilium** : certaines règles utilisent des `CiliumNetworkPolicy` (webhooks d'admission, entité `remote-node`) et le default-deny global est une `CiliumClusterwideNetworkPolicy`.
- Pods du contrôleur d'ingress avec le label `app.kubernetes.io/name=ingress-nginx`.

## Paramètres (`global.networkpolicies`)

- `enabled` (`false`) : génère les policies des applications. N'ajoute jamais le default-deny global.
- `ingressNamespaces` (`[ingress-nginx]`) : namespaces du contrôleur d'ingress, autorisés vers les applications exposées.
- `clusterDefaultDeny` (`false`) : ajoute le default-deny global (`enabled` doit être à `true`).
- `excludedNamespaces` (`[kube-system]`) : namespaces exclus du default-deny, en plus de `kube-system` et de `ingressNamespaces`.
- `cnpgOperatorNamespace` (`''`) : namespace de l'opérateur CloudNativePG s'il tourne hors de ce DSC. Vide : namespace du DSC si CloudNativePG y est installé, sinon n'importe quel namespace (restreint aux pods de l'opérateur).
- `scrapeNamespace` (`''`) : namespace du collecteur de métriques. **Obligatoire** quand `global.metrics.enabled` et `enabled` sont à `true` (le rendu échoue sinon).
- `scrapePodLabels` (`{}`) : labels des pods du collecteur dans `scrapeNamespace`. Vide : tous les pods de ce namespace.

## Politique générée

- Une policy d'isolation par application : trafic interne au namespace autorisé, ingress limité aux flux nécessaires (ingress controller, console, opérateur CNPG, collecteur de métriques, webhooks).
- La plupart des policies sont **ingress seulement** : l'egress n'est pas restreint, sauf par le default-deny global.
- Webhooks d'admission (cert-manager, CloudNativePG, GitLab Operator) : autorisés depuis le nœud API (`remote-node`).
- Pods de challenge ACME HTTP-01 : port 8089 ouvert quand `ingress.tls.type: acme`.
- Les `NetworkPolicy` du sous-chart Redis de glexporter sont désactivées : la policy du namespace couvre déjà `glexporter-redis`.

## Applications couvertes

- Argo CD, cert-manager, CloudNativePG, console, GitLab, GitLab Runner, glexporter, Harbor, Keycloak, Nexus, SonarQube, Vault.
- Rôles hors GitOps (`cert-manager`, `cloudnativepg`) : policies appliquées directement quand l'application n'est pas déployée par Argo CD. Les policies sont étiquetées (`app.kubernetes.io/managed-by: socle-networkpolicies`, `cloud-pi-native.fr/dsc`, `cloud-pi-native.fr/netpol-app`) et celles qui ne sont plus rendues sont supprimées.

## Ordre d'activation

1. Vérifier le prérequis Cilium et renseigner `scrapeNamespace` si les métriques sont activées.
2. Passer `enabled: true`, relancer le socle et synchroniser les applications.
3. Vérifier les flux (accès aux applications, métriques, webhooks, backups).
4. Lister dans `excludedNamespaces` tous les namespaces dont les flux ne sont pas couverts (notamment celui du contrôleur GitOps).
5. En **dernière étape** seulement, passer `clusterDefaultDeny: true`.

Retour arrière : repasser `enabled` à `false` supprime les policies générées.
