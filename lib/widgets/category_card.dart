import 'package:flutter/material.dart';

import '../models/article.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final int count;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: _getCategoryColor(category).withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // L'icône peut rester telle quelle
              Text(
                category.icon,
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 4),
              // Nom de la catégorie avec gestion de débordement

                Text(
                  category.displayName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  maxLines: 1, // Permettre jusqu'à 2 lignes
                  overflow: TextOverflow.ellipsis, // ... si le texte est trop long
                ),
              const SizedBox(height: 2),
              // Compteur d'articles
              Text(
               '$count article',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(Category category) {
    switch (category) {
      case Category.fresh:
        return Colors.green;
      case Category.grocery:
        return Colors.orange;
      case Category.cleaning:
        return Colors.blue;
      case Category.laundry:
        return Colors.purple;
      case Category.other:
        return Colors.brown;
      case Category.press:
        return Colors.red;
      case Category.pastry:
        return Colors.grey;
      case Category.diy:
        return Colors.teal;
    }
  }
}