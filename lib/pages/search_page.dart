import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:laws_browser/models/entities/article_model.dart';
import 'package:laws_browser/models/entities/category_model.dart';
import 'package:laws_browser/models/search/search_request.dart';
import 'package:laws_browser/models/search/search_result.dart';
import 'package:laws_browser/pages/search_results_page.dart';
import 'package:laws_browser/persistence/repositories/categories.repository.dart';
import 'package:laws_browser/services/abstractions/search_service.dart';
import 'package:laws_browser/models/common/code.dart';
import 'package:loader_overlay/loader_overlay.dart';

class SearchPage extends StatelessWidget {
  final Code code;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  SearchPage(this.code, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Căutare în ${code.name}')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                validator: (value) => _validateInput(value),
                decoration: const InputDecoration(hintText: 'Termenii de căutare'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.loaderOverlay.show();
                        _executeSearch(_controller.text).then((searchResult) {
                          context.loaderOverlay.hide();
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchResultsPage.single(code, searchResult)));
                        });
                      }
                    },
                    child: const Text('Caută'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<SearchResult<Article>>> _executeSearch(String term) async {
    var categories = await CategoriesRepository.instance.getHierarchized(code.id);
    var searchService = GetIt.instance.get<SearchService>();

    return await searchService.execute(SearchRequest<Category>(items: categories, term: term));
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Introduceti text';
    }

    return null;
  }
}
