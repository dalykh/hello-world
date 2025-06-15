# Plan de Test - MVP SaaS Taxi Suisse

## 1. Application Chauffeur (MVP)

### 1.1. Authentification
-   [TC_CH_AUTH_01] Connexion réussie avec identifiants valides (email/mot de passe).
-   [TC_CH_AUTH_02] Échec de connexion avec mot de passe incorrect.
-   [TC_CH_AUTH_03] Échec de connexion avec email inconnu.
-   [TC_CH_AUTH_04] Processus de "mot de passe oublié".
-   [TC_CH_AUTH_05] Connexion avec MFA (TOTP) si configurée et activée.
-   [TC_CH_AUTH_06] Déconnexion de l'application.
-   [TC_CH_AUTH_07] Persistance de la session après fermeture/ouverture de l'app.
-   [TC_CH_AUTH_08] Rafraîchissement automatique du token d'accès.

### 1.2. Saisie Feuille de Route
-   [TC_CH_FR_01] Enregistrer une nouvelle course avec tous les champs obligatoires.
-   [TC_CH_FR_02] Vérifier que la course enregistrée apparaît dans l'historique local.
-   [TC_CH_FR_03] Enregistrer un nouveau frais avec tous les champs obligatoires.
-   [TC_CH_FR_04] Attacher une photo à un frais (si MVP).
-   [TC_CH_FR_05] Vérifier que le frais enregistré apparaît dans l'historique local.
-   [TC_CH_FR_06] Validation des champs (montant numérique, format de date).

### 1.3. Calculs Locaux
-   [TC_CH_CALC_01] Vérifier le calcul du total des recettes journalières.
-   [TC_CH_CALC_02] Vérifier le calcul du total des frais journaliers.

### 1.4. Synchronisation (Basique)
-   [TC_CH_SYNC_01] Vérifier l'envoi des données au backend avec connexion réseau.
-   [TC_CH_SYNC_02] Enregistrer des données sans connexion réseau (stockage local).
-   [TC_CH_SYNC_03] Vérifier la synchronisation des données en attente après rétablissement du réseau.

### 1.5. Interface Utilisateur (Basique)
-   [TC_CH_UI_01] Naviguer entre les écrans principaux.
-   [TC_CH_UI_02] Vérifier la lisibilité et facilité d'utilisation des formulaires.

## 2. Application Manager (Web - MVP)

### 2.1. Authentification
-   [TC_MG_AUTH_01] Connexion réussie avec identifiants valides (manager).
-   [TC_MG_AUTH_02] Échec de connexion (identifiants incorrects).
-   [TC_MG_AUTH_03] Connexion avec MFA (TOTP) si configurée.
-   [TC_MG_AUTH_04] Déconnexion.

### 2.2. Visualisation des Données
-   [TC_MG_VIEW_01] Afficher la liste des chauffeurs de l'entreprise.
-   [TC_MG_VIEW_02] Visualiser les feuilles de route (courses/frais).
-   [TC_MG_VIEW_03] Filtrer les feuilles de route par date.
-   [TC_MG_VIEW_04] Filtrer les feuilles de route par chauffeur.
-   [TC_MG_VIEW_05] Vérifier la correspondance des données avec l'app chauffeur.

### 2.3. Gestion des Chauffeurs (CRUD Basique)
-   [TC_MG_DR_01] Créer un nouveau chauffeur.
-   [TC_MG_DR_02] Vérifier l'apparition du nouveau chauffeur dans la liste.
-   [TC_MG_DR_03] Modifier les informations d'un chauffeur.
-   [TC_MG_DR_04] Vérifier la sauvegarde des modifications.
-   [TC_MG_DR_05] Désactiver/réactiver un chauffeur (si MVP).

### 2.4. Interface Utilisateur (Basique)
-   [TC_MG_UI_01] Naviguer entre les sections.
-   [TC_MG_UI_02] Vérifier la réactivité de l'interface (responsive).

## 3. Flux d'Authentification Global (Backend/Cognito)

### 3.1. Validation des Jetons JWT par le Backend
-   [TC_BK_JWT_01] Accès API protégée avec token valide -> Succès.
-   [TC_BK_JWT_02] Accès API protégée sans token -> Erreur 401.
-   [TC_BK_JWT_03] Accès API protégée avec token expiré -> Erreur 401.
-   [TC_BK_JWT_04] Accès API protégée avec token malformé -> Erreur 401.
-   [TC_BK_JWT_05] Accès API protégée avec token d'audience incorrecte -> Erreur 401.
-   [TC_BK_JWT_06] Accès API protégée avec token d'émetteur incorrect -> Erreur 401.

### 3.2. Isolation des Tenants (Backend)
-   [TC_BK_TEN_01] Utilisateur Tenant A ne peut pas accéder aux données Tenant B.
-   [TC_BK_TEN_02] Données créées par Tenant A sont bien associées au schéma Tenant A.

### 3.3. Gestion des Rôles (Backend - Basique)
-   [TC_BK_ROLE_01] Chauffeur ne peut pas accéder aux API de gestion des chauffeurs.
