import 'package:laws_browser/models/entities/article-model.dart';

class ArticlesRepository {
  static final ArticlesRepository _instance = new ArticlesRepository._internalCtor();

  static ArticlesRepository get instance => _instance;

  ArticlesRepository._internalCtor();

  Future<Article> getById(int id) async {

    return Future.value(Article(articleName: '1', articleText: '1'));
    // var store = await BoxStore.getStore();

    // return store.box<Article>().get(id);
  }

  Future<void> add(Article article) async {
    // var store = await BoxStore.getStore();

    // store.box<Article>().put(article);
  }
}