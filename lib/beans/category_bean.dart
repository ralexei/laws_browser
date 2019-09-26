import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:laws_browser/beans/article_bean.dart';
import 'package:laws_browser/models/category-model.dart';
import 'package:laws_browser/models/article-model.dart';

part 'category_bean.jorm.dart';

@GenBean()
class CategoryBean extends Bean<Category> with _CategoryBean {
  CategoryBean(Adapter adapter) 
    : articleBean = ArticleBean(adapter),
      super(adapter);

  final ArticleBean articleBean;

  CategoryBean _categoryBean;
  CategoryBean get categoryBean => _categoryBean ??= this;

  String get tableName => 'Category';
}