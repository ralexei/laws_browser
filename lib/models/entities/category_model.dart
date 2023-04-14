import 'package:hive/hive.dart';

import 'article_model.dart';

part 'category_model.g.dart';

@HiveType(typeId: 0)
class Category {
  @HiveField(0)
  int id = 0;

  @HiveField(1)
  String name;

  @HiveField(2)
  Category? parent;

  @HiveField(3)
  List<Category> children = <Category>[];

  @HiveField(4)
  List<Article> articles = <Article>[];

  // Unmappable
  int hierarchy = 0;

  Category(this.name);
  Category.create(this.name, this.hierarchy);
}
