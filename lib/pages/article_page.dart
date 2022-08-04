import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:laws_browser/models/entities/article_model.dart';

class ArticlePage extends StatelessWidget {
  final List<Article> articles;
  final String? categoryName;
  
  const ArticlePage({super.key, required this.articles, @required this.categoryName});

  @override
  Widget build(BuildContext context) {
    var articlePattern = r'Articolul \d+\.';
    var content = articles.map((f) => f.articleText).join('\n\n');

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName!)
      ),
      body:
      SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8),
                child: ParsedText(
                  text: content,
                  style: Theme.of(context).textTheme.bodyText1,
                  parse: <MatchText>[
                     MatchText(
                      pattern: articlePattern,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      )
                    ),
                  ],
                )
              )
            ]
          )
        )
      )
    );
  }
}