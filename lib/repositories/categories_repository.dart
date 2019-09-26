import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:laws_browser/beans/category_bean.dart';
import 'package:laws_browser/models/category-model.dart';

class CategoriesRepository{
  static final CategoriesRepository _instance = new CategoriesRepository._internalCtor();

  CategoryBean categoryBean;

  static CategoriesRepository get instance => _instance;

  CategoriesRepository._internalCtor();

  Future<void> init(Adapter dbAdapter) async {
    categoryBean = new CategoryBean(dbAdapter);
    // await categoryBean.drop();
    // await categoryBean.createTable();
  }

  Future<void> insertRange(List<Category> categories) async {
    await categoryBean.insertMany(categories, cascade: true);
  }

  Future<List<Category>> getHierarchized() async {
    var result = await categoryBean.preloadAll(await categoryBean.getAll(), cascade: true);
    
    result.removeWhere((w) => w.parentId != null);

    return result;
  }
}