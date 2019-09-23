import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';
import 'package:laws_browser/beans/article_bean.dart';
import 'package:laws_browser/models/article-model.dart';

class ArticlesRepository {
  static final ArticlesRepository _instance = new ArticlesRepository._internalCtor();

  ArticleBean articleBean;

  static ArticlesRepository get instance => _instance;

  ArticlesRepository._internalCtor();

  void init(Adapter dbAdapter) async {
    articleBean = new ArticleBean(dbAdapter);
  }

  Future<Article> getById(int id) async {
    return articleBean.find(id);
  }

  void add(Article article) async {
    await articleBean.insert(article);
  }
}