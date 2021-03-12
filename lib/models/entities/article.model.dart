import 'package:objectbox/objectbox.dart';

@Entity()
class Article {
  int id;
  String articleName;
  String articleText;

  int categoryId;

  static const String tableName = 'Article';

  Article({this.articleText, this.articleName});
}