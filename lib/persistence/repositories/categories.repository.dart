import 'package:hive/hive.dart';
import 'package:laws_browser/models/entities/category-model.dart';

class CategoriesRepository {
  static final CategoriesRepository _instance =
      new CategoriesRepository._internalCtor();

  static CategoriesRepository get instance => _instance;

  CategoriesRepository._internalCtor();

  Future<List<Category>> getHierarchized(String boxName) async {
    var box = await Hive.openBox<Category>(boxName);
    var categories = box.values.toList();

    return Future.value(categories);
  }

  Future<void> insert(Category cat) async {}

  Future<void> insertRange(List<Category> categories, String boxName) async {
    var commonBox = await Hive.openBox('common');

    if (!commonBox.containsKey(boxName)) {
      var box = await Hive.openBox<Category>(boxName);

      await commonBox.put(boxName, true);
      await box.addAll(categories);
    }
  }
}
