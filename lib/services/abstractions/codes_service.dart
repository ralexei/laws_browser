import 'package:laws_browser/models/common/code.dart';

abstract class CodesService {
  Future<bool> downloadCode(Code code);
  Future<String?> getLastUpdate(Code code);
}
