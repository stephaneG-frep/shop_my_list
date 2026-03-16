import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/article_service.dart';
import '../theme/app_theme.dart';
import '../widgets/category_card.dart';

class HomeScreen extends StatelessWidget {
  final ArticleService articleService;

  const HomeScreen({super.key, required this.articleService});

  @override
  Widget build(BuildContext context) {
    final articles = articleService.getAllArticles();
    final categoryCounts = articleService.getCategoryCounts();

    final totalArticles = articles.length;
    final purchasedArticles = articles.where((a) => a.isChecked).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listes de courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ArticleSearchDelegate(articleService: articleService),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
            children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Résumé',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSummaryItem(
                          'Total',
                          '$totalArticles',
                          Icons.shopping_cart,
                          AppTheme.primaryColor,
                        ),
                        _buildSummaryItem(
                          'Achetés',
                          '$purchasedArticles',
                          Icons.check_circle,
                          Colors.green,
                        ),
                        _buildSummaryItem(
                          'Restants',
                          '${totalArticles - purchasedArticles}',
                          Icons.pending,
                          AppTheme.mustardColor,
                        ),
                      ],
                    ),
                  ],
              ),
            ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Catégories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0,
              children: Category.values.map((category) {
                return CategoryCard(
                  category: category,
                  count: categoryCounts[category] ?? 0,
                  onTap: () {
                    final index = Category.values.indexOf(category);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      DefaultTabController.of(context).animateTo(index + 1);
                    });
                  },
                );
              }).toList(),
            ),
        ],
        ),

    );
  }

  Widget _buildSummaryItem(
      String title,
      String value,
      IconData icon,
      Color color,
      ) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class ArticleSearchDelegate extends SearchDelegate {
  final ArticleService articleService;

  ArticleSearchDelegate({required this.articleService});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = articleService.getAllArticles().where((article) {
      return article.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final article = results[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(article.category.icon),
          ),
          title: Text(article.name),
          subtitle: Text(article.category.displayName),
          trailing: Text('x${article.quantity}'),
          onTap: () {
            // Naviguer vers la catégorie de l'article
            close(context, null);
          },
        );
      },
    );
  }
}