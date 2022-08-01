import 'package:hive/hive.dart';

part 'article-model.g.dart';

@HiveType(typeId: 1)
class Article {
  @HiveField(0)
  int id = 0;
  @HiveField(1)
  String articleName;
  @HiveField(2)
  String articleText;

  Article({required this.articleText, required this.articleName});
}