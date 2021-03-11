import 'package:laws_browser/services/legis_synchronizer.dart';

class Startup {
  static Future initialize() async {
      var categories = await LegisSynchronizer.instance.parseLegis(); 
  }
}