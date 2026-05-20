# 💰 Budget App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.41.9-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.11.5-blue?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Windows-lightgrey)

**Application moderne de gestion de budget et de dépenses**

[Fonctionnalités](#-fonctionnalités) •
[Captures d'écran](#-captures-décran) •
[Installation](#-installation) •
[Technologies](#-technologies)

</div>

---

## 📱 Aperçu

Budget App est une application complète de gestion de budget qui vous permet de suivre vos revenus et dépenses de manière intuitive. Avec une interface moderne et sombre, elle offre une expérience utilisateur fluide sur mobile, web et desktop.

---

## ✨ Fonctionnalités

### 📊 Dashboard principal
- **Solde total** en temps réel
- **Répartition revenus/dépenses** avec indicateurs visuels
- **Graphique mensuel** (6 derniers mois) avec fl_chart
- **Top 5 catégories de dépenses** du mois avec progress bars

### 💸 Gestion des transactions
- ➕ Ajout rapide de **revenus** et **dépenses**
- 🏷️ **Catégories personnalisables** (Nourriture, Transport, Loyer, etc.)
- 📝 **Description optionnelle**
- 🗑️ Suppression par **glissement** ou **appui long**
- 📱 **Modal d'ajout** élégant avec animation

### 📅 Écran Transactions
- **Groupement par jour** avec en-têtes cliquables
- **Solde quotidien** affiché pour chaque jour
- **Stats mensuelles** : revenus, dépenses, solde, moyenne par jour
- **Sélecteur de mois** avec navigation intuitive
- **Expansion des jours** pour voir les détails

### 📊 Statistiques détaillées
- **Camembert interactif** pour la répartition des dépenses
- **Détail par catégorie** avec pourcentages
- **Total des dépenses** mis en avant

### 📄 Export de rapport
- **Génération de rapport texte** formaté
- **Groupement par jour** dans le rapport
- **Top dépenses par catégorie**
- **Partage facile** via WhatsApp, Email, etc.

### 💾 Stockage persistant
- **Sauvegarde locale** avec SharedPreferences
- **Données conservées** entre les sessions
- **100% hors ligne** (après premier chargement)

### 🎨 Design
- **Thème sombre moderne** (Dark Mode)
- **Animations fluides**
- **UI néo-brutaliste** avec tons cyberpunk
- **Icônes personnalisées** par catégorie
- **Responsive** (mobile, tablette, web)

---

## 🛠️ Technologies

| Technologie | Version | Utilisation |
|-------------|---------|-------------|
| **Flutter** | 3.41.9 | Framework principal |
| **Dart** | 3.11.5 | Langage de programmation |
| **Provider** | 6.1.0 | Gestion d'état |
| **SharedPreferences** | 2.2.0 | Stockage local |
| **fl_chart** | 0.68.0 | Graphiques et camembert |
| **intl** | 0.19.0 | Formatage des dates |
| **share_plus** | 7.2.1 | Partage de rapport |

---

## 📦 Installation

### Prérequis

- Flutter SDK installé ([Instructions](https://docs.flutter.dev/get-started/install))
- Android Studio / VS Code
- Device (Android/iOS) ou émulateur

### Étapes d'installation

```bash
# 1. Cloner le projet
git clone https://github.com/votre-username/budget-app.git
cd budget-app

# 2. Installer les dépendances
flutter pub get

# 3. Lancer l'application
flutter run

# 4. Build APK (Android)
flutter build apk --release
# APK généré dans : build/app/outputs/flutter-apk/app-release.apk

# 5. Build iOS (Mac uniquement)
flutter build ios --release