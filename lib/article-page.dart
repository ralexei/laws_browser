import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArticlePage extends StatelessWidget {
  final articleText;
  final categoryName;
  
  ArticlePage({@required this.articleText, @required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName)
      ),
      body:
      SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                child: Text(articleText),
                padding: EdgeInsets.all(8),
              )
            ]
          )
        )
      )
    );
  }
}