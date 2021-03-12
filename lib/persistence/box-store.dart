import 'package:laws_browser/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';

class BoxStore {
  static Future<Store> getStore() async {
    var dir = await getApplicationDocumentsDirectory();

    return Store(getObjectBoxModel(), directory: dir.path + '/objectbox');
  }
}