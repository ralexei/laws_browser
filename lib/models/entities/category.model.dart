import 'package:objectbox/objectbox.dart';

import 'article.model.dart';

@Entity()
class Category {
  int id;
  String name;
  final articles = ToMany<Article>();
  final parent = ToOne<Category>();
  final children = ToMany<Category>();
  
  static const String tableName = 'Categories';

  Category({this.name});
}