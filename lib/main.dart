import 'package:flutter/material.dart';
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';
import 'package:laws_browser/repositories/categories_repository.dart';
import 'package:laws_browser/services/legis_synchronizer.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as pathUtils;

import 'home-page.dart';
import 'constants.dart';
import 'package:laws_browser/repositories/articles_repository.dart';

void main() async {
  var dbPath = await getDatabasesPath();
  var dbAdapter = new SqfliteAdapter(pathUtils.join(dbPath, Constants.DbName));
  await dbAdapter.connect();
  await ArticlesRepository.instance.init(dbAdapter);
  await CategoriesRepository.instance.init(dbAdapter);
  
  // var categories = await LegisSynchronizer.instance.parseLegis();

  // await CategoriesRepository.instance.insertRange(categories);

  runApp(LBApp());
}

class LBApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage()
    );
  }
}