import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:laws_browser/beans/article_bean.dart';
import 'package:laws_browser/beans/category_bean.dart';

import 'article-model.dart';

class Category {
  int id;
  String name;
  // @HasMany(CategoryBean)
  // List<Category> children;
  @HasMany(ArticleBean)
  List<Article> articles;
  
  static const String tableName = 'Category';

  Category({this.name}){
    // children = List<Category>();
    articles = List<Article>();
  }
}