# Intégration UI et Cartographique - Application Chauffeur

Les widgets dans ce répertoire (`new_ride_form.dart`, `new_expense_form.dart`, `ride_list_widget.dart`, etc.) doivent être développés pour correspondre aux maquettes haute-fidélité (Tâche 3.2).

## Intégration Cartographique (pour `new_ride_form.dart` ou un widget dédié `address_picker_map.dart`):
- **Bibliothèque:** `flutter_map` (pour OpenStreetMap) ou `google_maps_flutter`.
- **Fonctionnalités MVP:**
    - Affichage d'une carte interactive.
    - Champ de recherche d'adresse avec auto-complétion (via API de géocodage Nominatim/Google).
    - Possibilité de placer/déplacer un marqueur sur la carte pour sélectionner une adresse.
    - Récupération des coordonnées et de l'adresse formatée.
- **Dépendances (pubspec.yaml):** `flutter_map`, `http` (ou `dio`).
