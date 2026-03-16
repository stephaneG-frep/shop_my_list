// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArticleAdapter extends TypeAdapter<Article> {
  @override
  final int typeId = 0;

  @override
  Article read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Article(
      id: fields[0] as String,
      name: fields[1] as String,
      quantity: fields[2] as int,
      category: fields[3] as Category,
      isChecked: fields[4] as bool,
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Article obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.isChecked)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 1;

  @override
  Category read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Category.fresh;
      case 1:
        return Category.grocery;
      case 2:
        return Category.cleaning;
      case 3:
        return Category.laundry;
      case 4:
        return Category.other;
      case 5:
        return Category.press;
      case 6:
        return Category.pastry;
      case 7:
        return Category.diy;
      default:
        return Category.fresh;
    }
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    switch (obj) {
      case Category.fresh:
        writer.writeByte(0);
        break;
      case Category.grocery:
        writer.writeByte(1);
        break;
      case Category.cleaning:
        writer.writeByte(2);
        break;
      case Category.laundry:
        writer.writeByte(3);
        break;
      case Category.other:
        writer.writeByte(4);
        break;
      case Category.press:
        writer.writeByte(5);
        break;
      case Category.pastry:
        writer.writeByte(6);
        break;
      case Category.diy:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
