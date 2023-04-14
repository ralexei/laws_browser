import 'package:laws_browser/models/entities/article_model.dart';
import 'package:laws_browser/models/entities/category_model.dart';
import 'package:laws_browser/models/search/search_request.dart';
import 'package:laws_browser/models/search/search_result.dart';
import 'package:laws_browser/services/abstractions/search_service.dart';
import 'package:laws_browser/utils/helpers/string_helpers.dart';

class DefaultSearchService extends SearchService {
  @override
  Future<List<SearchResult<Article>>> execute(SearchRequest<Category> request) async {
    var searchResults = _getSearchResults(request);

    searchResults.sort(((a, b) => compareResults(a, b)));

    return searchResults;
  }

  int compareResults(SearchResult<Article> a, SearchResult<Article> b) {
    var cmp = b.score.compareTo(a.score);

    if (cmp != 0) {
      return cmp;
    }

    var articleA = a.result.articleName;
    var articleB = b.result.articleName;

    return StringHelpers.getIntegerFromString(articleA).compareTo(StringHelpers.getIntegerFromString(articleB));
  }

  List<SearchResult<Article>> _getSearchResults(SearchRequest<Category> request) {
    var result = <SearchResult<Article>>[];
    var extremeCategories = _getExtremeCategories(request.items).toList();

    for (var item in extremeCategories) {
      if (item.articles.isEmpty) {
        continue;
      }

      for (var article in item.articles) {
        var fullTermResult = _findFullTermMatch(article, request);

        if (fullTermResult != null) {
          result.add(fullTermResult);
          continue;
        }

        var containsTermsResult = _findContainingTerms(article, request);

        if (containsTermsResult != null) {
          result.add(containsTermsResult);
          continue;
        }
      }
    }

    return result;
  }

  // For debug only. TO DELETE
  // void _count(List<Category> categories) {
  //   for (var category in categories) {
  //     if (category.articles!.isNotEmpty) {
  //       cnt++;
  //     } else {
  //       _count(category.children ?? []);
  //     }
  //   }
  // }

  SearchResult<Article>? _findFullTermMatch(Article article, SearchRequest<Category> request) {
    var articleText = StringHelpers.removeDiacritics(article.articleText);
    var term = StringHelpers.removeDiacritics(request.term);

    if (StringHelpers.removeDiacritics(articleText).contains(term)) {
      return SearchResult.fullMatch(result: article, score: 1, matchedFullString: request.term);
    }

    return null;
  }

  SearchResult<Article>? _findContainingTerms(Article article, SearchRequest<Category> request) {
    var term = StringHelpers.removeDiacritics(request.term);
    var termTokens = _tokenize(term).toSet();
    var articleText = StringHelpers.removeDiacritics(article.articleText);
    var articleTokens = _tokenize(articleText);
    var scorePerTerm = 0.8 / termTokens.length;
    var totalScore = 0.0;
    var matchedTerms = <String>{};

    for (int i = 0; i < termTokens.length; i++) {
      var termToken = termTokens.elementAt(i);
      if (articleTokens.any((a) => a.toLowerCase().contains(termToken.toLowerCase()))) {
        matchedTerms.add(termToken);
        totalScore += scorePerTerm - (i / 100);
      }
    }

    if (matchedTerms.isNotEmpty) {
      return SearchResult.containsTerms(result: article, score: totalScore, matchedTerms: matchedTerms);
    }

    return null;
  }

  Iterable<Category> _getExtremeCategories(List<Category> categories) sync* {
    for (var category in categories) {
      if (category.articles.isNotEmpty) {
        yield category;
      } else {
        yield* _getExtremeCategories(category.children);
      }
    }
  }

  List<String> _tokenize(String input) {
    if (input.isEmpty) {
      return [];
    }

    return input.split(RegExp(r'\s+'));
  }
}
