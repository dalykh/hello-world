# Intégration UI et Cartographique - Application Web Manager

Les composants dans ce répertoire et dans `pages/` (`DriverTable.jsx`, `DriverForm.jsx`, `DriverManagementPage.jsx`, `RoadsheetViewerPage.jsx`, etc.) doivent être développés pour correspondre aux maquettes haute-fidélité (Tâche 3.2) en utilisant React (ou Vue.js) et une bibliothèque de composants UI (ex: Material-UI, Ant Design).

## Intégration Cartographique (pour visualiser les trajets dans les détails des feuilles de route):
- **Bibliothèque:** `react-leaflet` (pour OpenStreetMap/Leaflet) ou `google-maps-react`.
- **Fonctionnalités MVP:**
    - Affichage d'une carte statique ou interactive simple.
    - Affichage des marqueurs pour les adresses de départ et d'arrivée d'une course.
- **Dépendances (package.json):** `leaflet`, `react-leaflet`.
