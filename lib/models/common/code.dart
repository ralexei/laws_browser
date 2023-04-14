import 'package:flutter/foundation.dart';

class Code extends ChangeNotifier {
  String id = '';
  String name = '';
  String url = '';
  String searchTerm = '';
  String? lastUpdate;

  Code({required this.id, required this.name, required this.url, required this.searchTerm});

  void setLastUpdate(String? lastUpdateTime) {
    lastUpdate = lastUpdateTime;
    notifyListeners();
  }
}
