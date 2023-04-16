import 'dart:developer';
import 'package:get_it/get_it.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:laws_browser/models/common/category_metadata.dart';
import 'package:laws_browser/models/entities/article_model.dart';
import 'package:laws_browser/models/entities/category_model.dart';
import 'package:laws_browser/models/enums/category_types.dart';
import 'package:laws_browser/services/abstractions/legis_http_service.dart';
import 'package:laws_browser/services/abstractions/legis_synchronizer.dart';
import 'package:laws_browser/utils/constants/categories_metadata.dart';
import 'package:laws_browser/utils/constants/category_patterns.dart' as patterns;
import 'package:laws_browser/utils/html_utils.dart';
import 'package:laws_browser/models/common/code.dart';
import 'package:tuple/tuple.dart';

class DefaultLegisSynchronizer implements LegisSynchronizer {
  final List<Category> _categories = <Category>[];
  late final String _documentText;
  int rootHI = 1;

  int lastArticleIndex = 0;

  @override
  Future<List<Category>> parseLegis(Code code) async {
    var response = await GetIt.instance.get<LegisHttpService>().downloadCode(code);

    if (response == null) {
      return [];
    }
    response = _removeCategoriesArtifacts(response);
    response = HtmlUtils.fixSupTags(response);
    var document = parse(response);

    _documentText = HtmlUtils.removeHtmlDocumentTags(document).replaceAll(RegExp(r'(?:[\t ]*(?:\r?\n|\r))+'), '\n');

    var rawCategories = await _getCategories(document);

    await _mapCategoriesRelations(rawCategories);

    return _categories;
  }

  /*
  ** Private methods
  */
  List<String> _getCategoriesBodies(Document document) {
    var categoryElements = document.getElementsByTagName('strong').map((e) => e.parent!.text.trim()).toList();
    List<Tuple2<int, List<String>>> indexedTokens = <Tuple2<int, List<String>>>[];

    for (int i = 1; i < categoryElements.length; i++) {
      if (categoryElements[i - 1].contains(categoryElements[i])) {
        if (categoryElements[i - 1].isNotEmpty) {
          categoryElements[i] = '';
        }
      } else if (categoryElements[i] == '.') {
        categoryElements[i - 1] += '.';
        categoryElements[i] = '';
      } else if (categoryElements[i].contains('\n')) {
        var tokens = _getTokens(categoryElements[i], i);

        categoryElements[i] = tokens.item2.first;
        tokens.item2.removeAt(0);
        indexedTokens.add(tokens);
      }
    }

    var offset = 0;

    for (var indexedToken in indexedTokens) {
      var tokens = indexedToken.item2;
      var i = 0;

      for (i = 0; i < tokens.length; i++) {
        categoryElements.insert(indexedToken.item1 + offset + i + 1, tokens[i].trim());
      }
      offset += i;
    }

    return categoryElements.where((element) => element.isNotEmpty).toList();
  }

  Tuple2<int, List<String>> _getTokens(String categoryBody, int index) {
    var tokens = categoryBody.split('\n').where((w) => w.isNotEmpty).toList();

    return Tuple2<int, List<String>>(index, tokens);
  }

  Future<List<Category>> _getCategories(Document document) async {
    var resultList = <Category>[];
    var categoriesBodies = _getCategoriesBodies(document);
    var lhi = 0; // last hierarchy index
    Category? lastCategory;

    for (int i = 0; i < categoriesBodies.length; i++) {
      var categoryRegEx = patterns.buildPattern(lhi);
      var currentCategory = categoriesBodies[i];
      var indexA = currentCategory.indexOf(categoryRegEx);

      if (indexA != 0) {
        if (lastCategory != null) {
          lastCategory.name += '\n$currentCategory';
        }

        continue;
      }

      var currentHierarchy = _getCategoryHierarchyProperty(currentCategory, lhi);

      if (lhi != CategoryTypes.articol.index && currentHierarchy < lhi) {
        if (lastCategory != null) {
          lastCategory.name += '\n$currentCategory';
        }

        continue;
      }

      var categoryBuffer = categoriesBodies[i];

      // Cut off the article name
      if (currentHierarchy == CategoryTypes.articol.index) {
        var articleNumberIndex = categoryBuffer.indexOf(RegExp(r'[0-9]'));

        articleNumberIndex = categoryBuffer.indexOf(RegExp(r'[^0-9]^-?'), articleNumberIndex);
        categoryBuffer = categoryBuffer.substring(0, articleNumberIndex < 0 ? categoryBuffer.length : articleNumberIndex);
      } else {
        if (categoryBuffer.contains('- abrogat')) {
          lastCategory = Category.create(categoryBuffer.trim(), currentHierarchy);
          resultList.add(lastCategory);
          continue;
        }
      }

      lhi = currentHierarchy;
      lastCategory = Category.create(categoryBuffer.trim(), currentHierarchy);
      resultList.add(lastCategory);
    }

    return resultList;
  }

  Future _mapCategoriesRelations(List<Category> categories) async {
    Stopwatch stopwatch = Stopwatch()..start();

    categories.where((e) => e.hierarchy == categories[0].hierarchy).forEach((element) {
      _categories.add(element);
    });

    for (int i = 0; i < _categories.length; i++) {
      final root = _categories[i];
      buildChildren(root, categories, categories.indexOf(root) + 1, root.hierarchy);
      root.name = _sanitizeCategory(root.name);
    }

    stopwatch.stop();
    log('_mapRelations executed: ${stopwatch.elapsed}');
  }

  void buildChildren(Category parent, List<Category> categories, int index, int rootHierarchy) {
    var childrenHierarchy = categories[index].hierarchy;

    while (index < categories.length) {
      final category = categories[index];
      final categoryHierarchy = category.hierarchy;

      if (categoryHierarchy <= rootHierarchy) {
        return;
      }

      if (childrenHierarchy != categoryHierarchy) {
        index++;
        continue;
      }

      if (categoryHierarchy == CategoryTypes.articol.index) {
        final categoryName = category.name;
        final articleId = _parseArticleId(categoryName);
        final articleName = _sanitizeArticleName(categoryName);
        var articleText = '';

        if (index + 1 < categories.length) {
          articleText = _parseArticleBody(articleName, categories[index + 1].name);
        } else {
          articleText = _parseArticleBody(articleName);
        }

        parent.articles.add(Article(id: articleId, articleName: articleName.trim(), articleText: articleText.trim()));
      } else {
        category.name = _sanitizeCategory(category.name);
        parent.children.add(category);
        buildChildren(category, categories, index + 1, category.hierarchy);
      }

      index++;
    }
  }

  void printTree(List<Category> roots) {
    for (var root in roots) {
      printNode(root, '');
    }
  }

  void printNode(Category node, String prefix) {
    log('$prefix ${node.name}');

    if (node.children.isNotEmpty) {
      for (var child in node.children) {
        printNode(child, '$prefix -- ');
      }
    } else {
      for (var article in node.articles) {
        log('$prefix -- ${article.articleName}');
      }
    }
  }

  int _parseArticleId(String articleName) {
    var articleId = articleName.replaceAll(RegExp(r'[^0-9]'), '');

    return int.tryParse(articleId) ?? 0;
  }

  String _parseArticleBody(String articleName, [String? nextCategory]) {
    var articleStartIndex = _documentText.indexOf(articleName, lastArticleIndex);
    var articleEndIndex = 0;

    if (nextCategory != null) {
      nextCategory = nextCategory.split(RegExp(r'(?:\r?\n|\r)')).first;

      articleEndIndex = _documentText.indexOf(nextCategory, articleStartIndex + 1);
    } else {
      articleEndIndex = _documentText.indexOf(RegExp(r'^(?:[\t ]*(?:\r?\n|\r))+', multiLine: true), articleStartIndex + 1);

      if (articleEndIndex == -1 || articleEndIndex >= _documentText.length) {
        articleEndIndex = _documentText.length;
      }
    }

    lastArticleIndex = articleEndIndex;

    return _documentText.substring(articleStartIndex, articleEndIndex);
  }

  int _getCategoryHierarchyProperty(String categoryName, int startIndex) {
    List<CategoryMetadata> tmp = categoriesMetadata;

    if (startIndex == CategoryTypes.articol.index) {
      tmp = tmp.reversed.toList();
      startIndex = 0;
    }

    tmp = tmp.where((e) => e.categoryType.index != 0).toList();

    for (var i = startIndex; i < tmp.length; i++) {
      if (categoryName.startsWith(tmp[i].pattern)) {
        return tmp[i].categoryType.index;
      }
    }

    return CategoryTypes.none.index;
  }

  String _capitalize(String m) {
    var lowerCase = m.toLowerCase().trim().replaceAll('\n', ' ');

    return lowerCase[0].toUpperCase() + lowerCase.substring(1);
  }

  String _sanitizeArticleName(String articleName) {
    final match = patterns.articleRegex.firstMatch(articleName);

    return (match?.group(0) ?? articleName).trim();
  }

  String _sanitizeCategory(String category) {
    var trimmedCategory = category.trim().replaceFirst('\n', '. ');
    var sentences = trimmedCategory.split('.');
    var firstSentence = sentences.removeAt(0);

    sentences.removeWhere((r) => r == '');
    sentences = sentences.map(_capitalize).toList();

    return '${firstSentence.trim()}. ${sentences.join('. ')}';
  }

  // Fix all inconsistencies
  String _removeCategoriesArtifacts(String input) {
    return input.replaceAll('T i t l u l', 'Titlul').replaceAll('TITLUL', 'Titlul').replaceAll('C A R T E A', 'Cartea').replaceAll('PARTEA', 'Partea').replaceAll('Aricolul', "Articolul");
  }
}
