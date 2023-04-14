import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:laws_browser/models/common/code.dart';
import 'package:laws_browser/models/entities/article_model.dart';
import 'package:laws_browser/models/entities/category_model.dart';
import 'package:laws_browser/models/search/search_request.dart';
import 'package:laws_browser/models/search/search_result.dart';
import 'package:laws_browser/pages/search_results_page.dart';
import 'package:laws_browser/persistence/repositories/categories.repository.dart';
import 'package:laws_browser/services/abstractions/search_service.dart';
import 'package:laws_browser/utils/constants/codes.dart';
import 'package:loader_overlay/loader_overlay.dart';

class GlobalSearchPage extends StatefulWidget {
  const GlobalSearchPage({super.key});

  @override
  State<StatefulWidget> createState() => _GlobalSearchPageState();
}

class _GlobalSearchPageState extends State<GlobalSearchPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String searchTerms = '';
  Code? searchCode;

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(title: const Text("Căutare")),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField(
                  onSaved: (newValue) => searchCode = newValue,
                  items: _getDropdownItems(),
                  onChanged: (Code? code) {},
                ),
                TextFormField(
                  onSaved: (newValue) => searchTerms = newValue!,
                  validator: (value) => _validateInput(value),
                  decoration: const InputDecoration(hintText: 'Termenii de căutare'),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async => await _submitForm(context),
                      child: const Text('Caută'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Introduceti text';
    }

    return null;
  }

  Future _submitForm(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    if (searchCode == null) {
      await _getSearchResults()
        .then((value) => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchResultsPage(value))));
    } else {
      await _getSearchResultsForCode(searchCode!)
        .then((value) => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchResultsPage.single(searchCode!, value))));
    }
  }

  Future<List<SearchResult<Article>>> _getSearchResultsForCode(Code code) async {
    var categories = await CategoriesRepository.instance.getHierarchized(code.id);
    var searchService = GetIt.instance.get<SearchService>();

    return await searchService.execute(SearchRequest<Category>(items: categories, term: searchTerms));
  }

  Future<Map<Code, List<SearchResult<Article>>>> _getSearchResults() async {
    var availableCodes = codes.where((w) => w.lastUpdate != null);
    var results = <Code, List<SearchResult<Article>>>{};

    for (var code in availableCodes) {
      results[code] = await _getSearchResultsForCode(code);
    }

    return results;
  }

  List<DropdownMenuItem<Code>> _getDropdownItems() {
    const DropdownMenuItem<Code> defaultItem = DropdownMenuItem<Code>(
      value: null,
      child: Text('Toate disponibile'),
    );

    return codes
        .where((w) => w.lastUpdate != null)
        .map<DropdownMenuItem<Code>>((e) => DropdownMenuItem<Code>(
              value: e,
              child: Text(e.name),
            ))
        .toList()
      ..insert(0, defaultItem);
  }
}
