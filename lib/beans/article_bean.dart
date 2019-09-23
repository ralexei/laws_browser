import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:laws_browser/models/article-model.dart';

part 'article_bean.jorm.dart';

@GenBean()
class ArticleBean extends Bean<Article> with _ArticleBean {
  ArticleBean(Adapter adapter) : super(adapter);

  String get tableName => 'Article';
}