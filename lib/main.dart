import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/category_screen.dart';
import 'services/article_service.dart';
import 'models/article.dart';

void main() async {
  // 1. Obligatoire pour tout initialisation asynchrone avant runApp
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialise Hive avec le chemin Flutter
  await Hive.initFlutter();

  // 3. Lance l'application
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liste de courses',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const AppLoader(), // Écran intermédiaire qui initialise le service
    );
  }
}

// Widget qui gère l'initialisation asynchrone
class AppLoader extends StatefulWidget {
  const AppLoader({super.key});

  @override
  _AppLoaderState createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {
  late Future<ArticleService> _initializationFuture;

  @override
  void initState() {
    super.initState();
    _initializationFuture = _initializeApp();
  }

  Future<ArticleService> _initializeApp() async {
    // 1. Initialise le service
    final articleService = ArticleService();
    await articleService.init(); // Attend que Hive soit prêt

    // 2. (Optionnel) Charge quelques données de test si la boîte est vide
    final articles = articleService.getAllArticles();
    if (articles.isEmpty) {
      // Exemple : ajoute un article par défaut pour le test
      await articleService.addArticle(
        name: 'Pommes',
        quantity: 6,
        category: Category.fresh,
      );
    }

    return articleService;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ArticleService>(
      future: _initializationFuture,
      builder: (context, snapshot) {
        // 1. En cours de chargement
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        }

        // 2. Erreur
        if (snapshot.hasError) {
          return ErrorScreen(error: snapshot.error.toString());
        }

        // 3. Succès : passe au vrai écran de l'application
        return ShoppingListApp(articleService: snapshot.data!);
      },
    );
  }
}

// Écran de chargement simple
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Chargement de votre liste...'),
          ],
        ),
      ),
    );
  }
}

// Écran d'erreur simple
class ErrorScreen extends StatelessWidget {
  final String error;

  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 64),
              const SizedBox(height: 20),
              const Text(
                'Erreur de chargement',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                error,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Redémarre l'application
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const AppLoader(),
                    ),
                  );
                },
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// L'application principale
class ShoppingListApp extends StatefulWidget {
  final ArticleService articleService;

  const ShoppingListApp({super.key, required this.articleService});

  @override
  _ShoppingListAppState createState() => _ShoppingListAppState();
}

class _ShoppingListAppState extends State<ShoppingListApp> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _refreshData() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(articleService: widget.articleService),
      CategoryScreen(
        category: Category.fresh,
        articleService: widget.articleService,
        onDataChanged: _refreshData,
      ),
      CategoryScreen(
        category: Category.grocery,
        articleService: widget.articleService,
        onDataChanged: _refreshData,
      ),
      CategoryScreen(
        category: Category.cleaning,
        articleService: widget.articleService,
        onDataChanged: _refreshData,
      ),
      CategoryScreen(
        category: Category.laundry,
        articleService: widget.articleService,
        onDataChanged: _refreshData,
      ),
      CategoryScreen(
        category: Category.other,
        articleService: widget.articleService,
        onDataChanged: _refreshData,
      ),
      CategoryScreen(
        category: Category.press,
        articleService: widget.articleService,
        onDataChanged: _refreshData,
      ),
      CategoryScreen(
        category: Category.pastry,
        articleService: widget.articleService,
        onDataChanged: _refreshData,
      ),
      CategoryScreen(
        category: Category.diy,
        articleService: widget.articleService,
        onDataChanged: _refreshData,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0
            ? 'Accueil'
            : Category.values[_selectedIndex - 1].displayName),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
              ),
              child: Text(
                'Listes de courses',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Accueil'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ...Category.values.asMap().entries.map((entry) {
              final index = entry.key;
              final category = entry.value;
              return ListTile(
                leading: Text(category.icon),
                title: Text(category.displayName),
                selected: _selectedIndex == index + 1,
                onTap: () {
                  _onItemTapped(index + 1);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
    );
  }

  @override
  void dispose() {
    widget.articleService.close();
    super.dispose();
  }
}