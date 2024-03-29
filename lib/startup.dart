import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:laws_browser/models/entities/article_model.dart';
import 'package:laws_browser/models/entities/category_model.dart';
import 'package:laws_browser/services/abstractions/codes_service.dart';
import 'package:laws_browser/services/abstractions/legis_http_service.dart';
import 'package:laws_browser/services/abstractions/legis_synchronizer.dart';
import 'package:laws_browser/services/abstractions/search_service.dart';
import 'package:laws_browser/services/default_codes_service.dart';
import 'package:laws_browser/services/default_legis_http_service.dart';
import 'package:laws_browser/services/default_search_service.dart';
import 'package:laws_browser/utils/constants/codes.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:laws_browser/services/default_legis_synchronizer.dart';

class Startup {
  static var initialized = false;
  static Future initialize() async {
    await _initializeHive();
    _setupServices();
    await _setDownloadedCodes();
  }

  static Future _initializeHive() async {
    if (initialized) {
      return;
    }

    var directory = await pathProvider.getApplicationDocumentsDirectory();

    Hive.init(directory.path);
    await _registerHiveAdapters();
    initialized = true;
  }

  static Future _registerHiveAdapters() async {
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(ArticleAdapter());
  }

  static _setupServices() {
    final getIt = GetIt.instance;

    if (!getIt.isRegistered<LegisSynchronizer>()) {
      getIt.registerFactory<LegisSynchronizer>(() => DefaultLegisSynchronizer());
      getIt.registerFactory<LegisHttpService>(() => DefaultLegisHttpService());
      getIt.registerFactory<CodesService>(() => DefaultCodesService());
      getIt.registerFactory<SearchService>(() => DefaultSearchService());
    }
  }

  static _setDownloadedCodes() async {
    final getIt = GetIt.instance;
    var codesService = getIt.get<CodesService>();

    for (var code in codes) {
      var lastUpdate = await codesService.getLastUpdate(code);

      code.setLastUpdate(lastUpdate);
    }
  }
}
