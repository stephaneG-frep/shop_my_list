import 'package:flutter/material.dart';
import '../models/article.dart';
import '../theme/app_theme.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onDelete;
  final VoidCallback onToggle;
  final VoidCallback onEdit;

  const ArticleCard({
    super.key,
    required this.article,
    required this.onDelete,
    required this.onToggle,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(article.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.red,
          size: 30,
        ),
      ),
      onDismissed: (direction) => onDelete(),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: AppTheme.lavenderColor.withOpacity(0.2),
            child: Text(
              article.category.icon,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  article.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    decoration: article.isChecked
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: article.isChecked
                        ? Colors.grey
                        : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'x${article.quantity}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  article.isChecked
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: article.isChecked
                      ? AppTheme.primaryColor
                      : Colors.grey,
                ),
                onPressed: onToggle,
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.grey),
                onPressed: onEdit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}