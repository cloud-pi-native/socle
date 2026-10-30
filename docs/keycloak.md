# Keycloak

Options de configuration Keycloak (`keycloakx`) de la `dsc`. Installation générale : [INSTALL.md](../INSTALL.md).

- [Clients du realm applicatif](#clients-du-realm-applicatif)
- [Ingress public](#ingress-public)
- [SMTP désactivé](#smtp-désactivé)

## Clients du realm applicatif

Certains clients ne sont plus créés systématiquement :

- `portail-client` (portail externe, non déployé par le socle) : créé seulement avec `dsc.keycloakx.portailClientEnabled: true` (défaut `false`). Ses `redirectUris` et `webOrigins` valent `*` : les restreindre avant de l'activer ;
- `awx-client` : créé seulement si `dsc.awx.installEnabled: true`. L'URI de redirection `*` est supprimée, seul le callback AWX est accepté.

Migration :

- les clients déjà créés dans Keycloak ne sont pas supprimés, ils ne sont simplement plus réconciliés ;
- pour retirer `portail-client` d'un environnement existant, le supprimer à la main dans le realm applicatif ;
- avec AWX installé, `awx-client` est mis à jour à la prochaine exécution (le `*` disparaît).

## Ingress public

Pour que les utilisateurs s'authentifient sans accès privé, Keycloak peut être exposé sur Internet **sur la même URL** que l'accès interne (DNS split-horizon : le DNS public pointe vers un load balancer public, le DNS interne vers le load balancer privé). `dsc.keycloakx.publicIngress` crée un second Ingress `keycloakx-public` :

```yaml
keycloakx:
  publicIngress:
    enabled: true            # défaut : false (aucun Ingress public)
    className: nginx-public  # IngressClass d'un second contrôleur, derrière un LB public
```

- mêmes host, Secret TLS, labels et annotations que l'Ingress du chart, sauf `cert-manager.io/*` (l'Ingress du chart reste l'unique propriétaire du certificat) ;
- seuls les chemins OIDC du realm applicatif sont routés : `/realms/<applicationRealm>/protocol/openid-connect/`, `/login-actions/`, `/.well-known/`, `/device` et `/resources/`. Console d'administration, realm de gestion, console de compte, `/metrics` et `/health` ne sont pas exposés (le contrôleur public répond 404 par défaut) ;
- le socle n'installe pas le contrôleur : l'IngressClass `className` doit exister (second ingress-nginx, `controller.scope` limité au namespace Keycloak, snippets désactivés recommandé) ;
- avant d'ouvrir le realm applicatif à Internet : restreindre les `redirectUris` des clients, imposer le MFA et régler les seuils de brute-force.

## SMTP désactivé

Avec `global.smtp.enabled: false`, un `smtpServer` vide est envoyé au realm. Keycloak 26.6 refuse un `smtpServer` partiel (adresse d'expéditeur invalide) ; en l'omettant, celui enregistré par une version précédente serait renvoyé tel quel.

## Sécurité

Sur Kubernetes (hors OpenShift, où la SCC attribue l'uid), le pod, le conteneur Keycloak et l'init container `realm-ext-provider` s'exécutent avec un `securityContext` restreint : non-root (uid 1000), profil seccomp `RuntimeDefault`, pas d'élévation de privilèges et toutes les capabilities retirées.
