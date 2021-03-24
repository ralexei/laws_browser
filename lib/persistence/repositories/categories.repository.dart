
import 'package:hive/hive.dart';
import 'package:laws_browser/models/entities/category-model.dart';

class CategoriesRepository{
  static final CategoriesRepository _instance = new CategoriesRepository._internalCtor();

  static CategoriesRepository get instance => _instance;

  CategoriesRepository._internalCtor();

  Future<List<Category>> getHierarchized() async {
    var box = Hive.box<Category>('categoriesBox');

    return Future.value(box.values.toList());
  }

  Future<void> insert(Category cat) async {
    // var store = await BoxStore.getStore();

    // store.box<Category>().put(cat);
  }

  Future<void> insertRange(List<Category> categories) async {
    var box = Hive.box<Category>('categoriesBox');

    await box.addAll(categories);
  }
}