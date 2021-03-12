
import 'package:laws_browser/models/entities/category.model.dart';
import 'package:laws_browser/persistence/box-store.dart';

class CategoriesRepository{
  static final CategoriesRepository _instance = new CategoriesRepository._internalCtor();

  static CategoriesRepository get instance => _instance;

  CategoriesRepository._internalCtor();

  Future<List<Category>> getHierarchized() async {
    var store = await BoxStore.getStore();

    return store.box<Category>().getAll();
  }

  Future<void> insertRange(List<Category> categories) async {
    var store = await BoxStore.getStore();

    store.box<Category>().putMany(categories);
  }
}