import 'dart:io';

import 'package:laws_browser/models/entities/category_model.dart';
import 'package:path_provider/path_provider.dart';

class CategoriesDbDebugger {
  static final CategoriesDbDebugger _instance =
      CategoriesDbDebugger._internal();

  static CategoriesDbDebugger get instance => _instance;

  CategoriesDbDebugger._internal();

  Future writeCategoriesToFile(String name, List<Category> categories) async {
    var directory = '${await _getSaveDirectory()}/categories_debug/$name.txt';
    var result = '';

    for (var category in categories) {
      result += '${await _getCategoryChildren(category, '', 0)}\n';
    }

    final file = File(directory);
    await file.writeAsString(result);
  }

  Future writeRawCategoriesToFile(String name, List<String> categories) async {
    var directory = '${await _getSaveDirectory()}/categories_debug/$name.txt';
    var result = '';

    for (var category in categories) {
      result += '$category\n';
    }

    final file = File(directory);
    await file.writeAsString(result);
  }

  Future<String> _getCategoryChildren(
      Category rootCategory, String text, int level) async {
    for (var child in rootCategory.children) {
      text += '${'+' * level}${child.name}\n';

      if (child.children.isNotEmpty) {
        text += '${await _getCategoryChildren(child, text, level + 1)}\n';
      } else if (child.articles.isNotEmpty) {
        for (var article in child.articles) {
          text += '${'+' * (level + 1)}${article.articleName}\n';
        }
      }
    }

    return text;
  }

  Future<String> _getSaveDirectory() async {
    var directory = Directory('/storage/emulated/0/Download');

    if (!(await directory.exists())) {
      directory = await getExternalStorageDirectory() ?? Directory('');
    }

    return directory.path;
  }
}
