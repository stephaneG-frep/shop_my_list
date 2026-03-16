import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/article.dart';

class ArticleService {
  static const String _boxName = 'articlesBox';
  Box<Article>? _articlesBox; // Nullable

  final Uuid _uuid = const Uuid();

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ArticleAdapter());
      Hive.registerAdapter(CategoryAdapter());
    }
    _articlesBox = await Hive.openBox<Article>(_boxName);
  }

  // Getter sécurisé
  Box<Article> get _box {
    if (_articlesBox == null) {
      throw Exception('ArticleService non initialisé. Appelez init() d\'abord.');
    }
    return _articlesBox!;
  }

  Future<void> addArticle({
    required String name,
    required int quantity,
    required Category category,
  }) async {
    final article = Article(
      id: _uuid.v4(),
      name: name,
      quantity: quantity,
      category: category,
      createdAt: DateTime.now(),
    );
    await _box.add(article); // Utilise _box
  }

  Future<void> updateArticle(Article updatedArticle) async { // Paramètre nommé 'updatedArticle'
    final index = _box.values.toList().indexWhere((a) => a.id == updatedArticle.id); // Utilise updatedArticle
    if (index != -1) {
      await _box.putAt(index, updatedArticle); // Utilise updatedArticle
    }
  }

  Future<void> deleteArticle(String id) async { // Paramètre 'id'
    final index = _box.values.toList().indexWhere((a) => a.id == id); // Utilise 'id'
    if (index != -1) {
      await _box.deleteAt(index);
    }
  }

  Future<void> deleteAllArticles() async {
    await _box.clear();
  }

  List<Article> getAllArticles() {
    return _box.values.toList();
  }

  List<Article> getArticlesByCategory(Category category) {
    return _box.values
        .where((article) => article.category == category)
        .toList();
  }

  Map<Category, int> getCategoryCounts() {
    final articles = getAllArticles();
    final Map<Category, int> counts = {};

    for (final category in Category.values) {
      counts[category] = articles.where((a) => a.category == category).length;
    }

    return counts;
  }

  Future<void> toggleArticleStatus(String id) async { // Paramètre 'id'
    final index = _box.values.toList().indexWhere((a) => a.id == id); // Utilise 'id'
    if (index != -1) {
      final article = _box.getAt(index)!;
      article.isChecked = !article.isChecked;
      await _box.putAt(index, article);
    }
  }

  void close() {
    _articlesBox?.close();
  }
}