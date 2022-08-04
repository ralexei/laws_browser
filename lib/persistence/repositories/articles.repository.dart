import 'package:laws_browser/models/entities/article_model.dart';

class ArticlesRepository {
  static final ArticlesRepository _instance = ArticlesRepository._internalCtor();

  static ArticlesRepository get instance => _instance;

  ArticlesRepository._internalCtor();

  Future<void> add(Article article) async {
    // var store = await BoxStore.getStore();

    // store.box<Article>().put(article);
  }
}