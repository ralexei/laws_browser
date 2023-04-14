import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:laws_browser/models/entities/category_model.dart';

class CategoriesRepository {
  static final CategoriesRepository _instance =
      CategoriesRepository._internalCtor();

  static CategoriesRepository get instance => _instance;

  CategoriesRepository._internalCtor();

  Future<List<Category>> getHierarchized(String boxName) async {
    var box = await Hive.openBox<Category>(boxName);
    var categories = box.values.toList();

    return Future.value(categories);
  }

  Future<void> tryClear(String boxName) async {
    var box = await Hive.openBox<Category>(boxName);

    if (box.isEmpty) {
      return;
    }

    await box.clear();
  }

  Future<void> insertRange(List<Category> categories, String categoryId) async {
    var commonBox = await Hive.openBox('common');
    var box = await Hive.openBox<Category>(categoryId);
    var date = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');

    await commonBox.put(categoryId, formatter.format(date));
    await box.addAll(categories);
  }

  Future<String> setLastUpdateNow(String codeId) async {
    var commonBox = await Hive.openBox('common');
    var date = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    var formattedDate = formatter.format(date);

    await commonBox.put(codeId, formattedDate);

    return formattedDate;
  }

  Future<String?> getLastUpdate(String codeId) async {
    var commonBox = await Hive.openBox('common');

    if (!commonBox.containsKey(codeId)) {
      return null;
    }

    return commonBox.get(codeId);
  }

  Future<bool> exists(String boxName) async {
    var box = await Hive.openBox<Category>(boxName);

    return box.isNotEmpty;
  }
}
