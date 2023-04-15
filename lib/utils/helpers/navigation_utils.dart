import 'package:flutter/material.dart';
import 'package:laws_browser/pages/code_content_page.dart';
import 'package:laws_browser/pages/code_menu_page.dart';
import 'package:laws_browser/pages/global_search_page.dart';
import 'package:laws_browser/pages/search_page.dart';
import 'package:laws_browser/models/common/code.dart';

class NavigationUtils {
  static void openSearch(NavigatorState navigator, Code code) {
    navigator.push(MaterialPageRoute(builder: (context) => SearchPage(code)));
  }

  static void openCodeMenu(NavigatorState navigator, Code code) {
    navigator.push(MaterialPageRoute(builder: (BuildContext context) => CodeMenuPage(code: code)));
  }

  static void openCode(NavigatorState navigator, Code code) {
    navigator.push(MaterialPageRoute(builder: (context) => CodeContentPage(code: code)));
  }

  static void openGlobalSearch(NavigatorState navigator) {
    navigator.push(MaterialPageRoute(builder: (context) => const GlobalSearchPage()));
  }
}
