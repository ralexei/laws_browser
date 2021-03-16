import 'package:laws_browser/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';

class BoxStore {
  static Store store;

  static Future<Store> getStore() async {
    if (store == null) {
      var dir = await getApplicationDocumentsDirectory();

      store = Store(getObjectBoxModel(), directory: dir.path + '/objectbox');
    }

    return store;
  }
}