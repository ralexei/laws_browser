import 'package:laws_browser/models/entities/category_model.dart';
import 'package:laws_browser/utils/models/code.dart';

abstract class LegisSynchronizer {
  Future<List<Category>> parseLegis(Code code);
}