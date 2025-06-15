# Notes de Configuration Amazon Cognito

## User Pool Clients (Chauffeurs/Managers)
- Nom du Pool: `saas_taxi_suisse_clients_pool`
- Attributs standards: email (utilisé comme username), phone_number
- Attributs personnalisés: `custom:tenant_id` (String), `custom:role` (String, ex: 'driver', 'manager')
- MFA: Activée (TOTP préférée)
- App Client (Mobile): `mobile_app_client`, public, PKCE activé, callbacks: `saastaximobile://callback`
- App Client (Web Manager): `web_app_manager_client`, public, PKCE activé, callbacks: `https://localhost:3000/callback` (pour dev), `https://[PROD_URL_MANAGER]/callback`
- Domaine: `[saas-taxi-prefix].auth.[region].amazoncognito.com`

## User Pool Administrateurs SaaS
- Nom du Pool: `saas_taxi_suisse_admins_pool`
- Configuration similaire mais pour les admins de la plateforme.
- App Client (Web Admin Portal): `web_admin_portal_client`, public, PKCE activé, callbacks: `https://localhost:3001/callback` (pour dev), `https://[PROD_URL_ADMIN]/callback`

## Backend API Protection
- Utilisation de jetons JWT (Access Tokens).
- Validation de la signature (JWKS), issuer, audience.
- Extraction des claims `sub`, `custom:tenant_id`, `custom:role` pour la logique d'autorisation.
