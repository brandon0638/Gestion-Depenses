<div align="center">
  
# 💰 Budget App

### Gestion Financière Intelligente à Portée de Main

Une application multiplateforme élégamment conçue pour gérer votre budget et vos dépenses de manière simple, intuitive et visuellement magnifique.

[![Flutter](https://img.shields.io/badge/Flutter-3.41.9-0553B1?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11.5-00B4AB?style=flat-square&logo=dart&logoColor=white)](https://dart.dev)
[![Licence](https://img.shields.io/badge/Licence-MIT-green?style=flat-square)](LICENSE)
[![Plateforme](https://img.shields.io/badge/Plateforme-iOS%20%7C%20Android%20%7C%20Web%20%7C%20Windows%20%7C%20macOS%20%7C%20Linux-lightgrey?style=flat-square)](https://flutter.dev)
[![Style Code](https://img.shields.io/badge/Style%20Code-Dart%20Lint-informational?style=flat-square)](https://dart.dev/guides/language/analysis-options)

**[Fonctionnalités](#-fonctionnalités-principales)** • 
**[Démo](#-captures-décran)** • 
**[Installation](#-démarrage-rapide)** • 
**[Architecture](#-architecture--structure)** • 
**[Contribution](#-contribution)**

<br/>

</div>

---

## 🎯 Aperçu

**Budget App** est une solution complète de gestion financière conçue pour les utilisateurs qui veulent prendre le contrôle de leurs habitudes de dépense sans complexité. Avec une interface épurée en mode sombre, des analyses en temps réel et un support multiplateforme, suivez vos finances n'importe où, n'importe quand.

**Idéal pour:**
- 💼 Suivi budgétaire personnel
- 📊 Catégorisation et analyse des dépenses
- 📈 Visualisation des tendances financières
- 🚀 Construire de meilleures habitudes financières

---

## ✨ Fonctionnalités Principales

<table>
<tr>
<td>

### 📊 **Tableau de Bord Avancé**
- Vue d'ensemble du solde en temps réel
- Tendances de dépenses sur 6 mois avec FL Charts
- Répartition des 5 meilleures catégories
- Boutons d'action rapide revenus/dépenses
- Ratio visuel revenus vs dépenses

</td>
<td>

### 📱 **Transactions Intelligentes**
- Enregistrement instantané des transactions
- 15+ catégories personnalisables avec icônes
- Descriptions et notes optionnelles
- Contrôles gestuels (glissement pour supprimer)
- Modales de transactions belles avec animations

</td>
</tr>
<tr>
<td>

### 📅 **Vue Chronologique**
- Groupement jour par jour des transactions
- Calcul du solde quotidien
- Statistiques et insights mensuels
- Navigation intuitive des mois
- Sections des jours dépliables

</td>
<td>

### 📈 **Analyses & Insights**
- Graphiques camembert interactifs
- Répartition des dépenses par catégorie
- Analyse des modèles de dépense
- Distribution en pourcentages
- Métriques mensuelles de performance

</td>
</tr>
<tr>
<td>

### 📤 **Export & Partage**
- Génération de rapport en un clic
- Export de texte formaté
- Résumés par catégorie
- Partage via WhatsApp, Email, etc.
- Mise en page de rapport professionnel

</td>
<td>

### 💾 **Stockage Hors Ligne**
- Stockage local persistant
- Zéro dépendance cloud
- Données synchronisées entre les sessions
- Complètement fonctionnel hors ligne
- Accès ultra-rapide

</td>
</tr>
</table>

---

## 🎨 Système de Design & Interface

### **Thème Sombre Moderne**
- Esthétique inspirée par cyberpunk avec touches néo-brutalistes
- Palette de couleurs soigneusement élaborée pour l'accessibilité
- Animations fluides et micro-interactions
- Design entièrement réactif (mobile, tablette, desktop)
- Icônes de catégorie personnalisées pour plus de clarté

| Composant | Couleur | Code Hex |
|-----------|---------|----------|
| **Fond Primaire** | Espace Profond | `#0F1117` |
| **Fond Secondaire** | Ardoise Foncée | `#1E2130` |
| **Couleur Accent (Revenus)** | Néon Teal | `#00D4AA` |
| **Couleur Dépenses** | Rouge Vif | `#FF6B6B` |
| **Texte Primaire** | Blanc Cassé | `#E8EAF0` |
| **Texte Secondaire** | Gris Neutre | `#9EA3B8` |

---

## 🚀 Démarrage Rapide

### Prérequis
- **Flutter SDK** ≥ 3.4.0 ([Guide d'installation](https://flutter.dev/docs/get-started/install))
- **Dart** ≥ 3.1.0
- **Android Studio**, **VS Code**, ou **Xcode**
- Émulateur ou device physique

### Installation & Configuration

```bash
# 1. Cloner le dépôt
git clone https://github.com/votre-username/budget-app.git
cd budget-app

# 2. Installer les dépendances
flutter pub get

# 3. Lancer l'application
flutter run

# 4. Build pour la production
# Android
flutter build apk --release

# iOS (macOS uniquement)
flutter build ios --release

# Web
flutter build web --release

# Windows
flutter build windows --release
```

### Tester sur Différentes Plateformes

```bash
# Découvrir les appareils disponibles
flutter devices

# Lancer sur une plateforme spécifique
flutter run -d chrome      # Web
flutter run -d android     # Android
flutter run -d ios         # iOS
flutter run -d windows     # Windows
```

---

## 🏗️ Architecture & Structure

```
lib/
├── main.dart                          # Point d'entrée & configuration du thème
│
├── models/
│   ├── transaction.dart               # Modèle de données Transaction
│   └── transaction_store.dart         # Gestion d'état Provider & persistance
│
├── screens/
│   ├── dashboard_screen.dart          # Écran d'accueil avec tableau de bord
│   ├── transactions_screen.dart       # Vue chronologique détaillée
│   ├── statistics_screen.dart         # Analyses avancées & visualisations
│   └── export_screen.dart             # Génération & partage de rapports
│
└── widgets/
    ├── header_widget.dart             # En-tête avec affichage du solde
    ├── action_buttons.dart            # Boutons d'action revenus/dépenses
    ├── add_transaction_modal.dart     # Dialogue d'entrée de transaction
    ├── monthly_chart.dart             # Visualisation des tendances 6 mois
    ├── category_stats.dart            # Répartition des catégories
    └── transaction_item.dart          # Affichage de transaction individuelle
```

### Gestion d'État
L'application utilise le pattern **Provider** pour une gestion d'état efficace:
- `TransactionStore`: Store centralisé pour toutes les données de transactions
- Mises à jour automatiques de l'interface à la suite de changements d'état
- Persistance transparente au stockage local

---

## 📦 Stack Technologique

| Technologie | Version | Objectif | Documentation |
|-----------|---------|----------|---|
| **Flutter** | 3.41.9 | Framework multiplateforme | [flutter.dev](https://flutter.dev) |
| **Dart** | 3.11.5 | Langage de programmation | [dart.dev](https://dart.dev) |
| **Provider** | 6.1.0 | Gestion d'état | [pub.dev/packages/provider](https://pub.dev/packages/provider) |
| **SharedPreferences** | 2.2.0 | Persistance des données | [pub.dev/packages/shared_preferences](https://pub.dev/packages/shared_preferences) |
| **FL Chart** | 0.68.0 | Graphiques et camemberts | [pub.dev/packages/fl_chart](https://pub.dev/packages/fl_chart) |
| **Intl** | 0.19.0 | Internationalisation | [pub.dev/packages/intl](https://pub.dev/packages/intl) |
| **Share Plus** | 7.2.1 | Partage multiplateforme | [pub.dev/packages/share_plus](https://pub.dev/packages/share_plus) |

---

## 🎬 Captures d'Écran

### Écrans Principaux

**Écran Tableau de Bord**
- Vue d'ensemble du solde en temps réel
- Tendances mensuelles (graphique 6 mois)
- Catégories de dépenses avec indicateurs
- Boutons d'action rapide pour transactions

**Écran Transactions**
- Chronologie groupée par date
- Calculs du solde quotidien
- Résumé des statistiques mensuelles
- Sections des jours dépliables

**Écran Statistiques**
- Graphiques camembert interactifs
- Répartition par catégorie
- Distribution en pourcentages
- Modèles de dépenses

**Écran Export & Partage**
- Génération de rapports formatés
- Partage par plusieurs canaux
- Mise en page professionnelle

---

## 📋 Exigences & Dépendances

Voir [pubspec.yaml](pubspec.yaml) pour la liste complète des dépendances.

### Exigences Minimales
- **Flutter**: 3.4.0+
- **Dart**: 3.1.0+
- **iOS**: 12.0+
- **Android**: Niveau API 21+

---

## 🔄 Roadmap & Améliorations Futures

- [ ] 📈 Graphique d'évolution du solde
- [ ] 🏠 Intégration widget écran d'accueil
- [ ] 🔔 Notifications de rappel des dépenses
- [ ] ☁️ Sauvegarde cloud avec Firebase
- [ ] 💳 Support multi-comptes
- [ ] 🎨 Catégories personnalisables
- [ ] 📊 Export CSV/Excel
- [ ] 🌐 Tableau de bord web compagnon
- [ ] 💱 Support multi-devise
- [ ] 📱 Sortie App Store iOS & Google Play

---

## 🐛 Problèmes Connus & Limitations

- Export manuel des données requis (sync cloud à venir)
- Limité à la capacité de stockage de l'appareil
- Pas encore de système de sauvegarde intégré

---

## 🤝 Contribution

Les contributions sont les bienvenues ! Voici comment commencer:

### Processus
1. **Fork** le dépôt
2. **Créez** une branche de feature (`git checkout -b feature/fonction-amazing`)
3. **Committez** vos changements (`git commit -m 'Ajouter fonction amazing'`)
4. **Pushez** vers la branche (`git push origin feature/fonction-amazing`)
5. **Ouvrez** une Pull Request

### Directives de Contribution
- Suivez les [directives de style Dart](https://dart.dev/guides/language/effective-dart)
- Ajoutez des tests pour les nouvelles features
- Mettez à jour la documentation en conséquence
- Gardez les commits atomiques et descriptifs
- Assurez-vous que le code passe `flutter analyze`

### Signaler des Problèmes
Trouvé un bug? [Ouvrez une issue](https://github.com/votre-username/budget-app/issues) avec:
- Description claire
- Étapes pour reproduire
- Comportement attendu vs comportement réel
- Captures d'écran/logs si applicable

---


## 💬 Support & Communauté

- **Issues**: [GitHub Issues](https://github.com/votre-username/budget-app/issues)
- **Discussions**: [GitHub Discussions](https://github.com/votre-username/budget-app/discussions)
- **Email**: votre-email@example.com

---

## 👨‍💻 Auteur

Créé avec ❤️ par **[Votre Nom]**

[![GitHub](https://img.shields.io/badge/GitHub-Profil-black?style=flat-square&logo=github)](https://github.com/votre-username)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Profil-blue?style=flat-square&logo=linkedin)](https://linkedin.com/in/votre-profil)
[![Twitter](https://img.shields.io/badge/Twitter-Suivre-blue?style=flat-square&logo=twitter)](https://twitter.com/votre-profil)

---

## 🙏 Remerciements

- Communauté [Flutter](https://flutter.dev)
- Équipe du langage [Dart](https://dart.dev)
- Tous les contributeurs et utilisateurs

---

<div align="center">

### Créé avec 💙 par les développeurs, pour les développeurs

**[⬆ retour au sommet](#-budget-app)**

</div>