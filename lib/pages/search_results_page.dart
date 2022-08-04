import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:laws_browser/models/entities/article_model.dart';
import 'package:laws_browser/pages/article_page.dart';
import 'package:laws_browser/utils/helpers/string_helpers.dart';

import '../models/search/search_result.dart';

class SearchResultsPage extends StatelessWidget {
  final List<SearchResult<Article>> searchResults;
  final int _previewLength = 200;
  final int _previewBeforeMatchLength = 50;

  const SearchResultsPage(this.searchResults, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search results')),
      body: ListView(
        children:
            searchResults.map((e) => _buildResultItem(context, e)).toList(),
      ),
    );
  }

  Widget _buildResultItem(BuildContext context, SearchResult<Article> item) {
    var preview = _getPreview(item);

    return Card(
      child: ExpansionTile(
        title: Text(item.result.articleName),
        initiallyExpanded: true,
        childrenPadding: const EdgeInsets.all(8.0),
        children: [
          GestureDetector(
            onTap: () => _redirectToArticle(context, item.result),
            child: Column(
              children: [
                ParsedText( 
                  regexOptions: const RegexOptions(caseSensitive: false),
                  text: preview,
                  style: Theme.of(context).textTheme.bodyText1,
                  parse: _getMatchers(context, item),
                ),
                const Icon(Icons.more_horiz)
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _redirectToArticle(BuildContext context, Article article) {
    final newPage =
        ArticlePage(articles: [article], categoryName: article.articleName);

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => newPage));
  }

  String _getPreview(SearchResult<Article> searchResult) {
    final article =
        StringHelpers.removeDiacritics(searchResult.result.articleText);
    var previewStartIndex = 0;

    if (searchResult.matchedFullString.isNotEmpty) {
      previewStartIndex = article.toLowerCase().indexOf(
          StringHelpers.removeDiacritics(
              searchResult.matchedFullString.toLowerCase()));
    } else if (searchResult.matchedTerms.isNotEmpty) {
      previewStartIndex = article.toLowerCase().indexOf(
          StringHelpers.removeDiacritics(
              searchResult.matchedTerms.first.toLowerCase()));
    }

    previewStartIndex -= _previewBeforeMatchLength;

    if (previewStartIndex < 0) {
      previewStartIndex = 0;
    }

    var previewEndIndex = previewStartIndex + _previewLength;

    if (previewEndIndex > article.length) {
      previewEndIndex = article.length;
    }

    return '${article.substring(previewStartIndex, previewEndIndex)}...';
  }

  List<MatchText> _getMatchers(BuildContext context, SearchResult<Article> item) {
    if (item.matchedFullString.isNotEmpty) {
      return [
        MatchText(
          onTap: (s) => _redirectToArticle(context, item.result),
          pattern: item.matchedFullString,
          style: const TextStyle(backgroundColor: Colors.yellow),
        )
      ];
    } else {
      if (item.matchedTerms.isNotEmpty) {
        return item.matchedTerms
            .map((e) => MatchText(
                onTap: (s) => _redirectToArticle(context, item.result),
                pattern: e,
                style: const TextStyle(backgroundColor: Colors.yellow)))
            .toList();
      }
    }

    return [];
  }
}
