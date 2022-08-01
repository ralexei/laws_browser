import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';

class ArticlePage extends StatelessWidget {
  final String? articleText;
  final String? categoryName;
  
  const ArticlePage({super.key, @required this.articleText, @required this.categoryName});

  @override
  Widget build(BuildContext context) {
    var articlePattern = r'Articolul \d+\.';

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
                  text: articleText!,
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