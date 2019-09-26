import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:laws_browser/beans/category_bean.dart';
import 'package:laws_browser/models/article-model.dart';
import 'package:laws_browser/models/category-model.dart';

part 'article_bean.jorm.dart';

@GenBean()
class ArticleBean extends Bean<Article> with _ArticleBean {
  ArticleBean(Adapter adapter) : super(adapter);
  
  CategoryBean _categoryBean;

  CategoryBean get categoryBean => _categoryBean ??= new CategoryBean(adapter);

  String get tableName => 'Article';
}