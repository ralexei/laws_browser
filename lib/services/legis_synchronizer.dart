import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:laws_browser/utils/html_utils.dart';
import 'package:sqflite/sqflite.dart';

class LegisSynchronizer {
  static final LegisSynchronizer _instance = new LegisSynchronizer._internalCtor();

  static LegisSynchronizer get instance => _instance;

  LegisSynchronizer._internalCtor();

  Future<void> parseLegis() async {
    var url = "http://www.legis.md/cautare/showdetails/112573";
    var response = await http.get(url);
    var trimmedHtml = HtmlUtils.removeHtmlTags(response.body);
    var patherino = await getDatabasesPath();
    var localFile = File('$patherino/shit.html');
    var jopa = await localFile.writeAsString(trimmedHtml);
    var a = 4;
  }
}