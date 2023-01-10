import 'package:laws_browser/utils/models/code.dart';

abstract class LegisHttpService {
  Future<String?> downloadCode(Code code);
}