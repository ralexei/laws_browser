import 'package:hive/hive.dart';
import 'package:laws_browser/models/entities/category-model.dart';

class CategoriesRepository {
  static final CategoriesRepository _instance =
      new CategoriesRepository._internalCtor();

  static CategoriesRepository get instance => _instance;

  CategoriesRepository._internalCtor();

  Future<List<Category>> getHierarchized() async {
    var box = Hive.box<Category>('categoriesBox');
    var categories = box.values.toList();
    return Future.value(categories);
  }

  Future<void> insert(Category cat) async {}

  Future<void> insertRange(List<Category> categories, String codeName) async {
    var articlesBox = await Hive.openLazyBox<Category>(codeName);

    await articlesBox.addAll(categories);
  }
}
