
import 'package:laws_browser/models/entities/category.model.dart';
import 'package:laws_browser/persistence/box-store.dart';

class CategoriesRepository{
  static final CategoriesRepository _instance = new CategoriesRepository._internalCtor();

  static CategoriesRepository get instance => _instance;

  CategoriesRepository._internalCtor();

  Future<List<Category>> getHierarchized() async {
    
    // var store = await BoxStore.getStore();

    // var result = store.box<Category>().getAll();

    // return result;
  }

  Future<void> insert(Category cat) async {
    var store = await BoxStore.getStore();

    store.box<Category>().put(cat);
  }

  Future<void> insertRange(List<Category> categories) async {
    // var store = await BoxStore.getStore();

    // store.box<Category>().putMany(categories);
  }
}