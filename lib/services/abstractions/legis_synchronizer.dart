import 'package:laws_browser/models/entities/category_model.dart';

abstract class LegisSynchronizer {
  Future<List<Category>> parseLegis(String url);
}