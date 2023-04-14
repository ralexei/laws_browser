import 'package:flutter/material.dart';
import 'package:laws_browser/models/common/code.dart';
import 'package:laws_browser/models/entities/article_model.dart';
import 'package:laws_browser/widgets/search_results_list.dart';

import '../models/search/search_result.dart';

class SearchResultsPage extends StatelessWidget {
  final Map<Code, List<SearchResult<Article>>> searchResults;

  const SearchResultsPage(this.searchResults, {super.key});

  SearchResultsPage.single(Code code, List<SearchResult<Article>> searchResult, {super.key}) :
    searchResults = <Code, List<SearchResult<Article>>>{
      code: searchResult
    };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search results')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: _getSearchResultsLists(),
        ),
      ),
    );
  }

  List<Widget> _getSearchResultsLists() {
    return searchResults.entries
        .map(
          (e) => Card(
            elevation: 2.0,
            child: ExpansionTile(
              title: Text(e.key.name),
              initiallyExpanded: searchResults.length > 1 ? false : true,
              childrenPadding: const EdgeInsets.all(8),
              children: [
                SearchResultsList(searchResults: e.value),
              ],
            ),
          ),
        )
        .toList();
  }
}
