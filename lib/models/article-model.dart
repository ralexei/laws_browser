import 'package:jaguar_orm/jaguar_orm.dart';

class Article {
  @PrimaryKey(auto: true, isNullable: false)
  int id;

  String articleText;

  static const String tableName = 'Article';

  Article({this.id, this.articleText});
}