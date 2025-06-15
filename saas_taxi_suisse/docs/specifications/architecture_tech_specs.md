# Spécifications - Architecture Technique

## 1. Choix du Fournisseur Cloud

**Fournisseur Cloud Sélectionné:** AWS (Amazon Web Services)

**Justification:**

*   **Maturité et Gamme de Services:** AWS est le leader du marché du cloud public et offre la gamme la plus étendue et la plus mature de services. Cela inclut des services managés robustes pour PostgreSQL (Amazon RDS), l'authentification (Amazon Cognito), l'hébergement d'applications backend (EC2, Elastic Beanstalk, Lambda, ECS/EKS), et le déploiement d'applications frontend et mobiles (Amplify, S3/CloudFront).
*   **Scalabilité et Fiabilité:** AWS fournit une infrastructure globalement distribuée, hautement scalable et fiable, ce qui est crucial pour une application SaaS destinée à croître.
*   **Écosystème et Communauté:** Un vaste écosystème de partenaires, une documentation complète et une grande communauté de développeurs facilitent la recherche de solutions, de support et de talents qualifiés.
*   **Gestion Multi-Tenant:** AWS offre plusieurs approches pour implémenter l'isolation multi-tenant au niveau de l'infrastructure et des services, ce qui est un requis clé pour notre solution.
*   **Sécurité:** AWS propose des outils et des services de sécurité complets pour aider à protéger les données au repos et en transit, et pour répondre aux exigences de conformité comme le RGPD.

Bien que GCP et Azure soient également des plateformes cloud compétentes, AWS est choisi pour sa position de leader, la richesse de ses services adaptés à nos besoins spécifiques, et la flexibilité qu'il offre pour faire évoluer la solution.

## 2. Architecture de la Base de Données

**Système de Gestion de Base de Données (SGBD):** PostgreSQL

**Hébergement:** Amazon RDS (Relational Database Service)

**Stratégie Multi-Tenant:** Schéma Séparé par Tenant au sein d'une Base de Données Partagée

**Justification et Description:**

Cette approche offre un bon équilibre entre l'isolation des données, la facilité de gestion, la performance et les coûts pour une application SaaS B2B.

*   **Isolation Logique Forte:** Chaque entreprise cliente (tenant) se verra attribuer un schéma PostgreSQL dédié (par exemple, `tenant_acme`, `tenant_globex`). Toutes les tables et données spécifiques à un tenant résideront dans son propre schéma. Cela empêche l'accès direct aux données d'un tenant par un autre au niveau de la base de données si les permissions sont correctement configurées.
*   **Gestion Centralisée:** Une seule instance de base de données PostgreSQL sur Amazon RDS sera utilisée pour héberger les schémas de plusieurs tenants. Cela simplifie la maintenance globale de la base de données (mises à jour, sauvegardes de l'instance).
*   **Efficacité des Ressources:** Comparé à une base de données distincte par tenant, cette approche est plus efficace en termes d'utilisation des ressources de l'instance RDS, surtout lorsque de nombreux tenants ont des besoins de stockage et de calcul modérés.
*   **Mise en Œuvre Applicative:**
    *   L'application backend sera responsable de gérer la connexion à la base de données et de s'assurer que les requêtes sont exécutées dans le contexte du bon schéma de tenant.
    *   Ceci sera typiquement réalisé en configurant le `search_path` de PostgreSQL au début de chaque session ou requête pour pointer vers le schéma du tenant concerné (ex: `SET search_path TO tenant_acme, public;`).
    *   Une table de métadonnées centrale (par exemple, dans le schéma `public`) pourrait être utilisée pour mapper les identifiants des tenants aux noms de leurs schémas respectifs et pour stocker d'autres informations de configuration globales.
*   **Sauvegarde et Restauration:**
    *   Les sauvegardes au niveau de l'instance RDS couvriront toutes les données de tous les tenants.
    *   La restauration d'un tenant spécifique nécessitera une stratégie plus fine (par exemple, restauration de l'instance dans un environnement temporaire et extraction des données du schéma concerné via `pg_dump`, ou utilisation d'outils de sauvegarde/restauration par schéma si disponibles et compatibles). Ceci est un point d'attention pour la maintenance.
*   **Évolutivité:** Cette approche peut bien évoluer. Si un tenant devient très grand ou a des besoins de performance spécifiques, il pourrait à l'avenir être migré vers sa propre instance de base de données dédiée.

**Alternative Considérée et Rejetée (pour le MVP):**

*   **Table Partagée avec Colonne d'Identification du Tenant:** Bien que potentiellement plus simple à démarrer pour certains aspects, cette approche a été écartée en raison des risques de sécurité plus élevés liés à la fuite de données entre tenants (si les filtres `tenant_id` ne sont pas appliqués rigoureusement partout) et de la complexité accrue pour la personnalisation et la gestion des données à long terme.
*   **Base de Données Séparée par Tenant:** Rejetée pour le MVP en raison de la complexité de gestion et des coûts potentiellement plus élevés pour un grand nombre de petits tenants. Pourrait être une option future pour de très gros clients.

## 3. Stratégie d'Authentification

**Standard Principal:** OAuth 2.0 / OpenID Connect (OIDC)
**Format des Jetons:** JWT (JSON Web Tokens)
**Fournisseur d'Identité (IdP) Recommandé:** Amazon Cognito

**Composants et Justifications:**

1.  **Amazon Cognito comme Fournisseur d'Identité (IdP):**
    *   **Intégration AWS:** S'aligne avec le choix d'AWS comme fournisseur cloud principal, facilitant l'intégration avec d'autres services AWS.
    *   **Support OAuth 2.0 & OIDC:** Fournit une implémentation robuste des standards OAuth 2.0 et OpenID Connect.
    *   **Gestion des Utilisateurs:** Offre des "User Pools" pour gérer l'enregistrement, la connexion, la confirmation de compte, la réinitialisation de mot de passe, et le stockage sécurisé des informations d'identification des utilisateurs.
    *   **Authentification Multi-Facteurs (MFA):** Supporte nativement l'ajout d'une couche de sécurité MFA (via SMS ou application TOTP comme Google Authenticator/Authy), ce qui est une exigence.
    *   **Sécurité:** Gère la génération et la validation des jetons, le hachage sécurisé des mots de passe, et d'autres aspects de sécurité liés à l'authentification.
    *   **Scalabilité:** Service managé par AWS, conçu pour être scalable.

2.  **Flux d'Authentification:**
    *   **Pour les applications clientes (Mobile Flutter, Web React/Vue.js):** Le flux **Authorization Code Grant avec PKCE (Proof Key for Code Exchange)** sera utilisé. Ce flux est le plus sécurisé pour les clients publics et les Single Page Applications (SPA).
        *   L'application initie la connexion et redirige vers la page de connexion hébergée par Cognito (UI personnalisable).
        *   Après authentification réussie (identifiants + MFA), Cognito retourne un code d'autorisation à l'application.
        *   L'application échange ce code (avec la preuve PKCE) contre des jetons (ID, Access, Refresh) directement auprès du point de terminaison token de Cognito.
    *   **Pour la communication entre services (Backend):** Si nécessaire, le flux Client Credentials pourra être utilisé pour des services backend s'appelant mutuellement de manière sécurisée, sans contexte utilisateur.

3.  **Types de Jetons (JWT):**
    *   **ID Token:** Conforme OIDC, il contiendra les "claims" (informations) sur l'utilisateur authentifié (ex: `sub` pour l'ID utilisateur, `email`, `custom:tenant_id`, `custom:role`). Il sera utilisé par l'application cliente pour personnaliser l'expérience utilisateur et par le backend pour identifier l'utilisateur.
    *   **Access Token:** Utilisé pour autoriser l'accès aux APIs protégées du backend. Il contiendra les "scopes" (permissions) accordées. Les APIs valideront la signature, l'expiration et l'audience de ce jeton avant d'autoriser l'accès.
    *   **Refresh Token:** Utilisé pour obtenir de nouveaux ID et Access Tokens lorsque ceux-ci expirent, permettant ainsi de maintenir la session utilisateur sans nouvelle saisie des identifiants. Ces jetons doivent être stockés de manière sécurisée par les applications clientes (par exemple, dans le Keystore/Keychain pour mobile, et de manière appropriée pour le web, potentiellement en HttpOnly cookie pour le refresh token si le backend gère l'échange).

4.  **Authentification Multi-Facteurs (MFA):**
    *   Sera configurée et gérée via Amazon Cognito.
    *   Les utilisateurs seront invités à configurer la MFA lors de leur première connexion ou via leur profil.
    *   L'utilisation d'applications TOTP sera privilégiée par rapport aux SMS pour une meilleure sécurité.

5.  **Gestion des Rôles et des Accès (RBAC):**
    *   Les rôles des utilisateurs (ex: `chauffeur`, `manager_taxi`, `admin_saas`) et l'identifiant du tenant (`tenant_id`) seront inclus comme des "claims" personnalisés dans l'ID Token et/ou l'Access Token.
    *   Les APIs backend utiliseront ces claims pour appliquer une logique d'autorisation fine, s'assurant que les utilisateurs ne peuvent accéder qu'aux fonctionnalités et aux données correspondant à leurs droits et à leur entreprise.

6.  **Séparation des Utilisateurs:**
    *   Un User Pool Cognito principal sera utilisé pour les utilisateurs des entreprises clientes (chauffeurs, managers).
    *   Un User Pool Cognito distinct (ou un groupe d'utilisateurs spécifique avec des permissions élevées au sein du même User Pool, à évaluer) sera utilisé pour les administrateurs de la plateforme SaaS accédant au Portail Administrateur. Cela garantit une séparation claire des privilèges.

Cette stratégie d'authentification est conçue pour être sécurisée, standardisée, et capable de supporter les besoins de l'application SaaS multi-tenant.
