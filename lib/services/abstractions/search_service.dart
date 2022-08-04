import 'package:laws_browser/models/entities/article_model.dart';
import 'package:laws_browser/models/entities/category_model.dart';
import 'package:laws_browser/models/search/search_request.dart';
import 'package:laws_browser/models/search/search_result.dart';

abstract class SearchService {
  Future<List<SearchResult<Article>>> execute(SearchRequest<Category> request);
}