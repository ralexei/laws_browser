import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:laws_browser/pages/code-content-page.dart';
import 'package:laws_browser/persistence/repositories/categories.repository.dart';
import 'package:laws_browser/services/legis_synchronizer.dart';
import 'package:laws_browser/utils/constants/codes.dart' as Codes;
import 'package:laws_browser/utils/models/code.dart';

class CodesListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(title: Text('Coduri')),
        body: ListView.builder(
            itemCount: Codes.codes.length,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Text(Codes.codes[index].name),
                  onTap: () async =>
                      await _codeTap(context, Codes.codes[index]));
            }));
  }

  Future<void> _codeTap(BuildContext context, Code code) async {
    var commonBox = await Hive.openBox('common');

    var boxi = await Hive.openBox(code.id);
    var size = File(boxi.path!).lengthSync();

    if (!commonBox.containsKey(code.id)) {
      var categories = await LegisSynchronizer.instance.parseLegis(code.url);

      await CategoriesRepository.instance.insertRange(categories, code.id);
    }

    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => CodeContentPage(code: code)));
  }
}
