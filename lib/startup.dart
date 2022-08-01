import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:laws_browser/models/entities/article_model.dart';
import 'package:laws_browser/models/entities/category_model.dart';
import 'package:laws_browser/services/abstractions/codes_service.dart';
import 'package:laws_browser/services/abstractions/legis_synchronizer.dart';
import 'package:laws_browser/services/default_codes_service.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:laws_browser/services/default_legis_synchronizer.dart';

class Startup {
  static var initialized = false;
  static Future initialize() async {
    await _initializeHive();
    await _initializeDatabase();
    _setupServices();
  }

  static Future _initializeHive() async {
    if (initialized) return;
    var directory = await pathProvider.getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    await _registerHiveAdapters();

    await Hive.openBox('common');
    // await Hive.openBox<Category>('categoriesBox');
    initialized = true;
  }

  static Future _registerHiveAdapters() async {
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(ArticleAdapter());
  }

  static Future _initializeDatabase() async {
    final commonBox = Hive.box('common');
    final isDatabaseFresh = (commonBox.get('isDatabaseFresh') ?? false) as bool;

    if (!isDatabaseFresh) {
      commonBox.put('isDatabaseFresh', true);
    }
  }

  static _setupServices() {
    final getIt = GetIt.instance;

    getIt.reset();
    getIt.registerFactory<LegisSynchronizer>(() => DefaultLegisSynchronizer());
    getIt.registerFactory<CodesService>(() => DefaultCodesService());
  }
}
