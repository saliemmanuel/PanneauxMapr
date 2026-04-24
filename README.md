# PanneauxMapr 📍

**PanneauxMapr** est une application mobile développée avec Flutter pour le recensement, la géolocalisation et la gestion des panneaux publicitaires dans la ville de Maroua, Cameroun.

## 🚀 Fonctionnalités

- **📍 Géolocalisation Précise** : Capture automatique des coordonnées GPS (Latitude/Longitude) lors de l'enregistrement.
- **📸 Capture de Photos** : Prise de vue directe des panneaux pour documentation visuelle.
- **📁 Stockage Local (Offline)** : Sauvegarde des données sur une base de données locale SQLite, permettant un travail sans connexion internet.
- **🗺️ Carte Interactive** : Visualisation de tous les panneaux recensés sur une carte interactive (OpenStreetMap).
- **📊 Exportation de Données** : 
  - **CSV** : Pour analyse dans Excel ou Google Sheets.
  - **GeoJSON** : Pour intégration directe dans des logiciels SIG (QGIS, ArcGIS).
- **🎨 Interface Moderne** : Design intuitif avec mode sombre/clair harmonisé.

## 🛠️ Stack Technique

- **Framework** : [Flutter](https://flutter.dev) (Dart)
- **Gestion d'état** : [GetX](https://pub.dev/packages/get)
- **Base de données** : [sqflite](https://pub.dev/packages/sqflite)
- **Cartographie** : [flutter_map](https://pub.dev/packages/flutter_map) (Leaflet/OSM)
- **Localisation** : [geolocator](https://pub.dev/packages/geolocator)
- **Multimédia** : [image_picker](https://pub.dev/packages/image_picker)

## 📦 Installation

1. **Cloner le projet**
   ```bash
   git clone https://github.com/votre-utilisateur/panneaux_mapr.git
   cd panneaux_mapr
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Lancer l'application**
   ```bash
   flutter run
   ```

## 📂 Structure du Projet

```text
lib/
├── controllers/    # Logique métier (GetX)
├── core/           # Thèmes et configurations globales
├── data/           # Modèles de données et Helper SQLite
├── services/       # Services (Localisation, Caméra, Export)
└── views/          # Écrans de l'interface utilisateur
```

## 🤝 Contribution

Les contributions sont les bienvenues ! Pour des changements majeurs, veuillez d'abord ouvrir une issue pour discuter de ce que vous aimeriez changer.

## 📄 Licence

Distribué sous la licence MIT. Voir `LICENSE` pour plus d'informations.

---
*Développé pour l'amélioration de la gestion urbaine à Maroua.*
