import 'package:laws_browser/models/common/code.dart';

abstract class LegisHttpService {
  Future<String?> downloadCode(Code code);
}