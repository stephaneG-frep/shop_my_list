import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/article_service.dart';
import '../widgets/article_card.dart';
import '../widgets/add_article_dialog.dart';

class CategoryScreen extends StatefulWidget {
  final Category category;
  final ArticleService articleService;
  final VoidCallback onDataChanged;

  const CategoryScreen({
    super.key,
    required this.category,
    required this.articleService,
    required this.onDataChanged,
  });

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late List<Article> _articles;
  List<Article> _filteredArticles = [];
  final TextEditingController _searchController = TextEditingController();
  bool _sortByDate = true;

  @override
  void initState() {
    super.initState();
    _loadArticles();
    _searchController.addListener(_onSearchChanged);
  }

  void _loadArticles() {
    _articles = widget.articleService
        .getArticlesByCategory(widget.category)
        .where((article) => !article.isChecked)
        .toList();

    final checkedArticles = widget.articleService
        .getArticlesByCategory(widget.category)
        .where((article) => article.isChecked)
        .toList();

    _sortArticles();
    _articles.addAll(checkedArticles);
    _filteredArticles = List.from(_articles);
  }

  void _sortArticles() {
    if (_sortByDate) {
      _articles.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else {
      _articles.sort((a, b) => a.name.compareTo(b.name));
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredArticles = List.from(_articles);
      } else {
        _filteredArticles = _articles
            .where((article) =>
            article.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  Future<void> _addArticle() async {
    await showDialog(
      context: context,
      builder: (context) => AddArticleDialog(
        initialCategory: widget.category,
        onSave: (name, quantity, category) async {
          await widget.articleService.addArticle(
            name: name,
            quantity: quantity,
            category: category,
          );
          _loadArticles();
          widget.onDataChanged();
          setState(() {});
        },
      ),
    );
  }

  Future<void> _editArticle(Article article) async {
    final nameController = TextEditingController(text: article.name);
    final quantityController = TextEditingController(text: article.quantity.toString());

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier l\'article'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Quantité'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              article.name = nameController.text;
              article.quantity = int.parse(quantityController.text);
              await widget.articleService.updateArticle(article);
              _loadArticles();
              widget.onDataChanged();
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('Sauvegarder'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final checkedArticles = _filteredArticles.where((a) => a.isChecked).toList();
    final uncheckedArticles = _filteredArticles.where((a) => !a.isChecked).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.displayName),
        actions: [
          IconButton(
            icon: Icon(_sortByDate ? Icons.sort_by_alpha : Icons.access_time),
            onPressed: () {
              setState(() {
                _sortByDate = !_sortByDate;
                _sortArticles();
                _onSearchChanged();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher dans ${widget.category.displayName}',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                if (uncheckedArticles.isNotEmpty) ...[
                  const Text(
                    'À acheter',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...uncheckedArticles.map((article) => ArticleCard(
                    article: article,
                    onDelete: () async {
                      await widget.articleService.deleteArticle(article.id);
                      _loadArticles();
                      widget.onDataChanged();
                      setState(() {});
                    },
                    onToggle: () async {
                      await widget.articleService.toggleArticleStatus(article.id);
                      _loadArticles();
                      widget.onDataChanged();
                      setState(() {});
                    },
                    onEdit: () => _editArticle(article),
                  )),
                  const SizedBox(height: 16),
                ],
                if (checkedArticles.isNotEmpty) ...[
                  const Text(
                    'Déjà achetés',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...checkedArticles.map((article) => ArticleCard(
                    article: article,
                    onDelete: () async {
                      await widget.articleService.deleteArticle(article.id);
                      _loadArticles();
                      widget.onDataChanged();
                      setState(() {});
                    },
                    onToggle: () async {
                      await widget.articleService.toggleArticleStatus(article.id);
                      _loadArticles();
                      widget.onDataChanged();
                      setState(() {});
                    },
                    onEdit: () => _editArticle(article),
                  )),
                ],
                if (_filteredArticles.isEmpty)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_basket,
                          size: 64,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucun article dans cette catégorie',
                          style: TextStyle(
                            color: Colors.grey.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addArticle,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}