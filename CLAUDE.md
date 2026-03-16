# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Commandes essentielles / Essential Commands

```bash
# Récupérer les dépendances / Get dependencies
flutter pub get

# Lancer l'application / Run the app
flutter run

# Générer les adaptateurs Hive (après modification du modèle) / Generate Hive adapters (after model changes)
dart run build_runner build --delete-conflicting-outputs

# Watcher pour la génération continue / Watcher for continuous generation
dart run build_runner watch --delete-conflicting-outputs

# Lancer les tests / Run tests
flutter test

# Lancer un test spécifique / Run a single test
flutter test test/widget_test.dart

# Analyser le code / Lint the code
flutter analyze

# Compiler pour Android / Build for Android
flutter build apk
```

---

## Architecture

### Gestion de l'état / State Management
L'application utilise **setState()** natif Flutter, sans bibliothèque externe (pas de Provider, BLoC, Riverpod).
The app uses native Flutter **setState()**, no external state management library.

La navigation principale est un `IndexedStack` qui conserve l'état de chaque écran.
Main navigation is an `IndexedStack` that preserves each screen's state.

> **Point critique / Critical point :** Chaque `CategoryScreen` gère son propre état local (`_articles`, `_filteredArticles`). Si une modification vient d'un écran parent, il faut appeler `_loadArticles()` + `setState()` dans le `CategoryScreen` concerné, pas seulement `setState()` dans le parent. C'est la source du bug historique "les ajouts n'apparaissent qu'au redémarrage".

### Persistance / Persistence
- **Hive** est utilisé comme base de données locale (NoSQL clé-valeur).
- Le service `ArticleService` est le seul point d'accès aux données.
- `article.g.dart` est **auto-généré** par `build_runner` — ne pas modifier à la main.
- Après toute modification de `Article` ou `Category` (annotations `@HiveType`/`@HiveField`), relancer la génération.

### Flux de données / Data flow
```
UI Widget
  └── ArticleService (lib/services/article_service.dart)
        └── Hive Box<Article>
```

### Écrans / Screens
- **Screen 0 — HomeScreen** : Vue synthétique avec compteurs par catégorie et barre de recherche globale.
- **Screens 1–8 — CategoryScreen** : Un écran par catégorie `Category` (enum). Articles séparés en "À acheter" / "Déjà achetés".

### Modèle / Model
`Category` est un enum (8 valeurs : `fresh`, `grocery`, `cleaning`, `laundry`, `other`, `press`, `pastry`, `diy`) avec une extension `CategoryExtension` fournissant `displayName` et `icon`.

`Article` stocke : `id` (UUID), `name`, `quantity`, `category`, `isChecked`, `createdAt`.

### Thème / Theme
Couleurs centralisées dans `AppTheme` (`lib/theme/app_theme.dart`). Support light/dark via `ThemeMode.system`. Couleur primaire : `#4CAF90`.
