import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:laws_browser/models/entities/article_model.dart';
import 'package:laws_browser/models/search/search_result.dart';
import 'package:laws_browser/pages/article_page.dart';
import 'package:laws_browser/utils/helpers/string_helpers.dart';

class SearchResultsList extends StatefulWidget {
  final List<SearchResult<Article>> searchResults;
  const SearchResultsList({required this.searchResults, super.key});

  @override
  State<StatefulWidget> createState() => _SearchResultsListState();
}

class _SearchResultsListState extends State<SearchResultsList> {
  final int previewLength = 200;
  final int previewBeforeMatchLength = 50;
  final int itemsPerPage = 3;

  int length = 0;

  @override
  void initState() {
    super.initState();

    setState(() {
      _loadNextPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: _getSearchResults(),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextButton(
            child: const Center(
              child: Text("Încarcă mai multe"),
            ),
            onPressed: () {
              setState(() {
                _loadNextPage();
              });
            },
          ),
        ),
      ],
    );
  }

  void _loadNextPage() {
    length += itemsPerPage;
  }

  List<Widget> _getSearchResults() {
    return widget.searchResults.getRange(0, length).map((e) => _buildResultItem(context, e)).toList();
  }

  Widget _buildResultItem(BuildContext context, SearchResult<Article> item) {
    var preview = _getPreview(item);

    return Card(
      elevation: 2.0,
      child: ExpansionTile(
        title: Text(item.result.articleName),
        initiallyExpanded: true,
        childrenPadding: const EdgeInsets.all(8.0),
        children: [
          GestureDetector(
            onTap: () => _redirectToArticle(context, item.result),
            child: Wrap(
              children: [
                ParsedText(
                  regexOptions: const RegexOptions(caseSensitive: false),
                  text: preview,
                  style: Theme.of(context).textTheme.bodyLarge,
                  parse: _getMatchers(context, item),
                ),
                const Center(
                  child: Icon(Icons.more_horiz),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _redirectToArticle(BuildContext context, Article article) {
    final newPage = ArticlePage(articles: [article], categoryName: article.articleName);

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => newPage));
  }

  String _getPreview(SearchResult<Article> searchResult) {
    final article = StringHelpers.removeDiacritics(searchResult.result.articleText);
    var previewStartIndex = 0;

    if (searchResult.matchedFullString.isNotEmpty) {
      previewStartIndex =
          article.toLowerCase().indexOf(StringHelpers.removeDiacritics(searchResult.matchedFullString.toLowerCase()));
    } else if (searchResult.matchedTerms.isNotEmpty) {
      previewStartIndex =
          article.toLowerCase().indexOf(StringHelpers.removeDiacritics(searchResult.matchedTerms.first.toLowerCase()));
    }

    previewStartIndex -= previewBeforeMatchLength;

    if (previewStartIndex < 0) {
      previewStartIndex = 0;
    }

    var previewEndIndex = previewStartIndex + previewLength;

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
