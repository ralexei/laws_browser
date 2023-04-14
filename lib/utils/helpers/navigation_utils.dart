import 'package:flutter/material.dart';
import 'package:laws_browser/pages/code_content_page.dart';
import 'package:laws_browser/pages/code_menu_page.dart';
import 'package:laws_browser/pages/global_search_page.dart';
import 'package:laws_browser/pages/search_page.dart';
import 'package:laws_browser/models/common/code.dart';

class NavigationUtils {
  static void openSearch(BuildContext context, Code code) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchPage(code)));
  }

  static void openCodeMenu(BuildContext context, Code code) {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CodeMenuPage(code: code)));
  }

  static void openCode(BuildContext context, Code code) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CodeContentPage(code: code)));
  }

  static void openGlobalSearch(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => GlobalSearchPage()));
  }
}
