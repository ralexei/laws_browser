import 'package:laws_browser/utils/models/code.dart';

abstract class CodesService {
  Future downloadCode(Code code);
}