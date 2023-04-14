import 'package:get_it/get_it.dart';
import 'package:laws_browser/persistence/repositories/categories.repository.dart';
import 'package:laws_browser/services/abstractions/codes_service.dart';
import 'package:laws_browser/services/abstractions/legis_synchronizer.dart';
import 'package:laws_browser/models/common/code.dart';

class DefaultCodesService implements CodesService {
  @override
  Future<bool> downloadCode(Code code) async {
    try {
      var parser = GetIt.instance.get<LegisSynchronizer>();
      var categories = await parser.parseLegis(code);

      await CategoriesRepository.instance.tryClear(code.id);
      await CategoriesRepository.instance.insertRange(categories, code.id);
      var lastUpdate = await CategoriesRepository.instance.setLastUpdateNow(code.id);

      code.setLastUpdate(lastUpdate);
    } catch (e) {
      return false;
    }

    return true;
  }

  @override
  Future<String?> getLastUpdate(Code code) async =>
    await CategoriesRepository.instance.getLastUpdate(code.id);
}
