import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laws_browser/models/article-model.dart';
import 'package:laws_browser/repositories/articles_repository.dart';

class HomePage extends StatelessWidget {
  final List<String> _codes = [
    "Codul Civil",
    "Codul Penal",
    "Codul AltCod",
    "Codul Inca un cod"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: FlatButton(
          color: Colors.blue,
          textColor: Colors.white,
          onPressed: () async {
            var newArticles = Article(articleText: "Article 1");
            ArticlesRepository.instance.add(newArticles);
          },
          child: Text(
            "Insert article"
          ),
        )
      )
      // body: Column
    );
  }
}