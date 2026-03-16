import 'package:hive/hive.dart';

part 'article.g.dart';

@HiveType(typeId: 0)
class Article {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int quantity;

  @HiveField(3)
  final Category category;

  @HiveField(4)
  bool isChecked;

  @HiveField(5)
  DateTime createdAt;

  Article({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
    this.isChecked = false,
    required this.createdAt,
  });
}

@HiveType(typeId: 1)
enum Category {
  @HiveField(0)
  fresh,

  @HiveField(1)
  grocery,

  @HiveField(2)
  cleaning,

  @HiveField(3)
  laundry,

  @HiveField(4)
  other,

  @HiveField(5)  // Nouveau
  press,

  @HiveField(6)  // Nouveau
  pastry,

  @HiveField(7)  // Nouveau
  diy,
}

extension CategoryExtension on Category {
  String get displayName {
    switch (this) {
      case Category.fresh:
        return 'Produits frais';
      case Category.grocery:
        return 'Épicerie';
      case Category.cleaning:
        return 'Produits d\'entretien';
      case Category.laundry:
        return 'Linge';
      case Category.other:
        return 'Autres';
      case Category.press:       // Nouveau
        return 'Presse';
      case Category.pastry:      // Nouveau
        return 'Viennoiserie';
      case Category.diy:         // Nouveau
        return 'Bricolage';
    }
  }

  String get icon {
    switch (this) {
      case Category.fresh:
        return '🥦';
      case Category.grocery:
        return '🥫';
      case Category.cleaning:
        return '🧼';
      case Category.laundry:
        return '👕';
      case Category.other:
        return '📦';
      case Category.press:       // Nouveau
        return '📰';
      case Category.pastry:      // Nouveau
        return '🥐';
      case Category.diy:         // Nouveau
        return '🔨';
    }
  }
}