import 'package:laws_browser/models/entities/category.model.dart';
import 'package:laws_browser/persistence/repositories/categories.repository.dart';
import 'package:laws_browser/services/legis_synchronizer.dart';

class Startup {
  static Future initialize() async {
    // var test_cats = <Category>[Category(name: "Cat3"), Category(name: "Cat4")];
    //   test_cats[0].children.add(Category(name: "Child1"));
    //   test_cats[0].children.add(Category(name: "Child2"));
    //   test_cats[0].children.add(Category(name: "Child3"));
    //   test_cats[0].children.add(Category(name: "Child4"));
    //   test_cats[0].children.add(Category(name: "Child5"));
    //   test_cats[0].children.add(Category(name: "Child6"));
    //   test_cats[0].children.add(Category(name: "Child7"));
    //   test_cats[0].children.forEach((element) {
    //     element.children.add(Category(name: "GrandChild1"));
    //     element.children.add(Category(name: "GrandChild2"));
    //     element.children.add(Category(name: "GrandChild3"));
    //     element.children.add(Category(name: "GrandChild4"));
    //   });
      var categories = await LegisSynchronizer.instance.parseLegis();
      // var t = await CategoriesRepository.instance.getHierarchized();
      // await CategoriesRepository.instance.insert(Category(name: "Cat1"));
      // for (var i = 0; i < 30; i++) {
        await CategoriesRepository.instance.insertRange(categories);
      // }
      var t2 = await CategoriesRepository.instance.getHierarchized();
      var a = 4;
  }
}