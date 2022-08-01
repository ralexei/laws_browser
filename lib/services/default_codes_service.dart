import 'package:get_it/get_it.dart';
import 'package:laws_browser/persistence/repositories/categories.repository.dart';
import 'package:laws_browser/services/abstractions/codes_service.dart';
import 'package:laws_browser/services/abstractions/legis_synchronizer.dart';
import 'package:laws_browser/utils/models/code.dart';

class DefaultCodesService implements CodesService {

  @override
  Future downloadCode(Code code) async {
    var parser = GetIt.instance.get<LegisSynchronizer>();
    var categories = await parser.parseLegis(code.url); 

    await CategoriesRepository.instance.tryClear(code.id);
    await CategoriesRepository.instance.insertRange(categories, code.id);
  }
}