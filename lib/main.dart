import 'package:flutter/material.dart';
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'home-page.dart';

void main() => runApp(LBApp());

class LBApp extends StatelessWidget {
  String _dbPath;
  SqfliteAdapter _adapter;

  @override
  Widget build(BuildContext context) {
    // _getDbPath();
    _tmp();
    print("Path:" + _dbPath);
    _adapter = new SqfliteAdapter(path.join("MDLaws.db"));
    _init();

    return MaterialApp(
      home: HomePage()
    );
  }

  void _getDbPath() async {
    _dbPath = await getDatabasesPath();
  }

  void _init() async {
    await _adapter.connect();
  }

  void _tmp() async {
    Directory dir = await getApplicationDocumentsDirectory();
    _dbPath = dir.path;
  }
}