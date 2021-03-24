import 'package:hive/hive.dart';
import 'package:laws_browser/models/entities/article-model.dart';
import 'package:laws_browser/models/entities/category-model.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:laws_browser/persistence/repositories/categories.repository.dart';
import 'package:laws_browser/services/legis_synchronizer.dart';

class Startup {
  static Future initialize() async {
    await initializeHive();
    await initializeDatabase();

    var t2 = await CategoriesRepository.instance.getHierarchized();
    var a = 4;
  }

  static Future initializeHive() async {
    var directory = await pathProvider.getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    await registerHiveAdapters();

    await Hive.openBox('common');
    await Hive.openBox<Category>('categoriesBox'); 
  }

  static Future registerHiveAdapters() async {
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(ArticleAdapter());
  }

  static Future initializeDatabase() async {
    final commonBox = Hive.box('common');
    final isDatabaseFresh = (commonBox.get('isDatabaseFresh') ?? false) as bool;

    if (!isDatabaseFresh) {
      var categories = await LegisSynchronizer.instance.parseLegis();

      await CategoriesRepository.instance.insertRange(categories);

      commonBox.put('isDatabaseFresh', true);
    }
  }
}