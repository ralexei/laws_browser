import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:laws_browser/components/activity_indicator.dart';
import 'package:laws_browser/models/entities/article_model.dart';
import 'package:laws_browser/models/entities/category_model.dart';
import 'package:laws_browser/models/search/search_request.dart';
import 'package:laws_browser/models/search/search_result.dart';
import 'package:laws_browser/pages/search_results_page.dart';
import 'package:laws_browser/persistence/repositories/categories.repository.dart';
import 'package:laws_browser/services/abstractions/search_service.dart';
import 'package:laws_browser/utils/models/code.dart';

class SearchPage extends StatelessWidget {
  final Code _code;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  SearchPage(this._code, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Cautare in ${_code.name}')),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _controller,
                        decoration: const InputDecoration(
                            hintText: 'Termenii de cautare'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Introduceti text';
                          }

                          return null;
                        },
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ActivityIndicator.of(context).show();
                              _executeSearch(_controller.text).then((searchResult) {
                                ActivityIndicator.of(context).hide();
                                Navigator
                                  .of(context)
                                  .push(MaterialPageRoute(builder: (context) => ActivityIndicator(child: SearchResultsPage(searchResult))));
                              });
                            }
                          },
                          child: const Text('Cauta'))
                    ]))));
  }

  Future<List<SearchResult<Article>>> _executeSearch(String term) async {
    var categories =
        await CategoriesRepository.instance.getHierarchized(_code.id);
    var searchService = GetIt.instance.get<SearchService>();

    return await searchService.execute(SearchRequest<Category>(items: categories, term: term));
  }
}
