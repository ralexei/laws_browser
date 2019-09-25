import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:laws_browser/beans/category_bean.dart';

class Article {
  @PrimaryKey(auto: true, isNullable: false)
  int id;
  String articleName;
  String articleText;

  @BelongsTo(CategoryBean)
  int categoryId;

  static const String tableName = 'Article';

  Article({this.id, this.articleText, this.articleName});
}