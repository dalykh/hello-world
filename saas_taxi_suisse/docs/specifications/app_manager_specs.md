# Spécifications Fonctionnelles - Application Manager

## 1. Introduction
*   Objectif de l'application manager.
*   Public cible (propriétaires/gestionnaires d'entreprises de taxi).

## 2. Authentification et Accès Sécurisé
*   Processus de connexion (identifiant/mot de passe).
*   Authentification multi-facteurs (MFA).
*   Gestion des rôles (Manager, Comptable - si applicable).

## 3. Tableau de Bord Principal
*   Vue d'ensemble des indicateurs clés de performance (KPIs) en temps réel:
    *   Recettes totales (jour, semaine, mois).
    *   Nombre total de courses.
    *   Chauffeurs actifs.
    *   Utilisation des véhicules.
    *   Frais totaux.
*   Graphiques et visualisations des tendances.
*   Raccourcis vers les sections fréquemment utilisées.

## 4. Gestion des Chauffeurs
*   Liste des chauffeurs.
*   Ajout/modification/désactivation d'un chauffeur.
*   Informations personnelles du chauffeur (nom, contact, numéro de permis, etc.).
*   Affectation à un ou plusieurs véhicules.
*   Consultation de l'historique d'activité d'un chauffeur.
*   Gestion des documents du chauffeur (permis de conduire, assurances, etc. - upload et dates d'expiration).

## 5. Gestion des Véhicules
*   Liste des véhicules.
*   Ajout/modification/désactivation d'un véhicule.
*   Informations du véhicule (marque, modèle, immatriculation, assurance, date de contrôle technique).
*   Historique d'utilisation du véhicule.
*   Suivi des maintenances (optionnel, évolution future).
*   Gestion des documents du véhicule (carte grise, assurance, etc. - upload et dates d'expiration).

## 6. Visualisation des Feuilles de Route
*   Vue agrégée des feuilles de route de tous les chauffeurs.
*   Filtrage par chauffeur, par date, par véhicule.
*   Détail de chaque trajet et frais saisis par les chauffeurs.
*   Validation/correction des entrées (si nécessaire).

## 7. Statistiques et Rapports
*   Génération de rapports personnalisables:
    *   Rapports de revenus (par chauffeur, par véhicule, par période).
    *   Rapports de frais.
    *   Rapports d'activité.
*   KPIs avancés (ex: revenu moyen par course, taux d'occupation).
*   Export des rapports en formats Excel et PDF.

## 8. Module Comptabilité Automatisée
### 8.1. Gestion des revenus
    *   Suivi des recettes (espèces, cartes, factures entreprises).
    *   Ventilation par taux de TVA.
### 8.2. Gestion des frais
    *   Catégorisation des frais.
    *   Suivi des paiements de frais.
### 8.3. Amortissements des véhicules
    *   Calculs de base.
### 8.4. Calcul des cotisations sociales
    *   Basé sur les revenus, configurable.
### 8.5. Préparation de la déclaration de TVA
    *   Résumé des montants de TVA collectée et déductible.
### 8.6. Préparation pour la déclaration fiscale suisse annuelle
    *   Export des données financières structurées.
    *   Bilan simplifié (Actifs/Passifs).
    *   Compte de résultat simplifié.

## 9. Gestion Documentaire Centralisée
*   Stockage sécurisé des documents d'entreprise (contrats, licences, etc.).
*   Organisation par catégories.
*   Rappels pour les dates d'expiration.

## 10. Paramètres de l'Entreprise
*   Informations de l'entreprise (Nom, Adresse, N° IDE, etc.).
*   Configuration des taux de TVA.
*   Paramétrage des types de frais.
*   Gestion des utilisateurs managers (ajout/suppression de comptes manager).

## 11. Notifications et Alertes
*   Alertes pour les documents arrivant à expiration (chauffeurs, véhicules, entreprise).
*   Notifications importantes (ex: anomalies détectées).

## 12. Interface Utilisateur (UI) et Expérience Utilisateur (UX)
*   Accessible sur web et appareils mobiles (responsive design).
*   Navigation claire et structurée.
*   Disponibilité en plusieurs langues (Français, Allemand, Italien).
