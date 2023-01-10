import 'package:get_it/get_it.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:laws_browser/models/entities/article_model.dart';
import 'package:laws_browser/models/entities/category_model.dart';
import 'package:laws_browser/services/abstractions/legis_http_service.dart';
import 'package:laws_browser/services/abstractions/legis_synchronizer.dart';
import 'package:laws_browser/utils/html_utils.dart';
import 'package:laws_browser/utils/models/code.dart';

enum CategoryTypes {
  none,
  partea,
  cartea,
  titlul,
  capitolul,
  sectiune,
  subsectiune,
  paragraf,
  articol
}

class DefaultLegisSynchronizer implements LegisSynchronizer {
  final RegExp _sectionRegEx = RegExp(r'Sec.*iunea.+');
  final RegExp _subsectionRegEx = RegExp(r'Subsec.*iunea.+');
  final List<Category> _categories = <Category>[];
  late final String _documentText;
  int rootPriority = 1;

  int lastArticleIndex = 0;

  @override
  Future<List<Category>> parseLegis(Code code) async {
    var response =
        await GetIt.instance.get<LegisHttpService>().downloadCode(code);

    if (response == null) {
      return [];
    }

    response = _removeCategoriesArtifacts(response);
    var document = parse(response);
    _documentText = HtmlUtils
      .removeHtmlTags(response)
      .replaceAll(RegExp(r'(?:[\t ]*(?:\r?\n|\r))+'), '\n');

    // var trimmedHtml = HtmlUtils.removeHtmlTags(response);
    var categories = await _getCategories(document);

    String firstCategory = categories[0];
    String firstCategoryName =
        firstCategory.substring(0, firstCategory.indexOf(' '));

    rootPriority = _getCategoryHierarchyProperty(firstCategoryName);

    await _mapCategoriesRelations(Category(name: firstCategory), categories);

    return _categories;
  }

  Future<List<String>> _getCategories(Document document) async {
    var categoryRegEx = RegExp(r'(Partea.+(<br />)?(\n)?.+|'
        r'Cartea.+(<br />)?(\n)?.+|'
        r'Titlul.+(<br />)?(\n)?.+|'
        r'Capitolul.+(<br />)?(\n)?.+|'
        r'Sec.*iunea.+(<br />)?(\n)?.+|'
        r'Subsec.*iunea.+(<br />)?(\n)?.+|'
        r'§.+(<br />)?(\n)?.+|'
        r'Articolul.+\.?)');
    var resultList = <String>[];
    var categoryElements = document.getElementsByTagName('strong');
    var categoriesBodies =  categoryElements
        .map((e) => e.parent!.text.trim())
        .toList();
    var categoriesConcatinated = categoriesBodies
        .join('\n');
    var indexA = 0;
    var indexB = 0;
    var previousHierarchy = 0;

    do {
      indexA = categoriesConcatinated.indexOf(categoryRegEx, indexA);
      indexB = categoriesConcatinated.indexOf(categoryRegEx, indexA + 1);

      if (indexB == -1 && indexA != -1) {
        // The case when it's the last article, so we should only parse
        // till the dot.
        indexB = categoriesConcatinated.indexOf('.', indexA + 1);

        if (indexB == -1) {
          indexB = categoriesConcatinated.length;
        }
      }

      if (indexA == -1 || indexB == -1) break;

      var articleSubstring = categoriesConcatinated.substring(indexA, indexB);
      var currentHierarchy = _getCategoryHierarchyProperty(articleSubstring);

      if (previousHierarchy != 0 && previousHierarchy > currentHierarchy) {
        indexB = categoriesConcatinated.indexOf(categoryRegEx, indexB + 1);
        
        articleSubstring = categoriesConcatinated.substring(indexA, indexB);
        currentHierarchy = _getCategoryHierarchyProperty(articleSubstring);
      }

      if (currentHierarchy == CategoryTypes.articol.index) {
        var articleNumberIndex = articleSubstring.indexOf(RegExp(r'[0-9]'));
        
        articleNumberIndex =  articleSubstring.indexOf(RegExp(r'[^0-9]'), articleNumberIndex);
        articleSubstring = articleSubstring.substring(0, articleNumberIndex < 0 ? articleSubstring.length : articleNumberIndex);
        previousHierarchy = 0;
      } else {
        if (previousHierarchy != 8 && previousHierarchy > currentHierarchy) {
          indexA++;
          continue;
        } else {
          previousHierarchy = currentHierarchy;
        }
      }

      indexA = indexB;
      resultList.add(articleSubstring.trim());
    } while (indexA != -1 && indexB != -1);

    return resultList;
  }

  Future _mapCategoriesRelations(Category parent, List<String> categories,
      [int index = 1]) async {
    if (index >= categories.length) return;

    parent.name = _trimCategory(parent.name);

    var parentPriority = _getCategoryHierarchyProperty(parent.name);
    var currentCategoryPrority =
        _getCategoryHierarchyProperty(categories[index]);

    while (index < categories.length) {
      var categoryPriority = _getCategoryHierarchyProperty(categories[index]);

      if (categoryPriority == parentPriority &&
          parentPriority == rootPriority) {
        break;
      }
      if (categoryPriority <= parentPriority) {
        return;
      }

      if (categoryPriority == currentCategoryPrority) {
        var categoryName = categories[index];

        if (categoryPriority < CategoryTypes.articol.index) {
          var newCategory = Category(name: categoryName);

          parent.children!.add(newCategory);
          _mapCategoriesRelations(newCategory, categories, index + 1);
        } else {
          final articleName = categoryName;
          final articleId = _parseArticleId(categoryName);
          var articleText = '';

          if (index + 1 < categories.length) {
            articleText = _parseArticleBody(categoryName, categories[index + 1]);
          } else {
            articleText = _parseArticleBody(categoryName);
          }

          parent.articles!.add(Article(
              id: articleId,
              articleName: articleName.trim(),
              articleText: articleText.trim()));
        }
      }

      index++;
    }

    if (parentPriority == rootPriority) {
      _categories.add(parent);

      if (index < categories.length) {
        _mapCategoriesRelations(
            Category(name: categories[index]), categories, index + 1);
      }
    }
  }

  int _getCategoryHierarchyProperty(String categoryName) {
    if (categoryName.contains("Partea")) {
      return 1;
    } else if (categoryName.contains("Cartea")) {
      return 2;
    } else if (categoryName.contains("Titlul")) {
      return 3;
    } else if (categoryName.contains("Capitolul")) {
      return 4;
    } else if (categoryName.contains(_sectionRegEx)) {
      return 5;
    } else if (categoryName.contains(_subsectionRegEx)) {
      return 6;
    } else if (categoryName.contains('§')) {
      return 7;
    } else if (categoryName.contains("Articolul")) {
      return 8;
    }

    return 0;
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
      articleEndIndex = _documentText.indexOf(
          RegExp(r'^(?:[\t ]*(?:\r?\n|\r))+', multiLine: true),
          articleStartIndex + 1);

      if (articleEndIndex == -1 || articleEndIndex >= _documentText.length) {
        articleEndIndex = _documentText.length;
      }
    }

    lastArticleIndex = articleEndIndex;

    return _documentText.substring(articleStartIndex, articleEndIndex);
  }

  String _capitalize(String m) {
    var lowerCase = m.toLowerCase().trim().replaceAll('\n', ' ');

    return lowerCase[0].toUpperCase() + lowerCase.substring(1);
  }

  String _trimCategory(String category) {
    var trimmedCategory = category.trim().replaceFirst('\n', '. ');
    var sentences = trimmedCategory.split('.');
    var firstSentence = sentences.removeAt(0);

    sentences.removeWhere((r) => r == '');
    sentences = sentences.map(_capitalize).toList();

    return '${firstSentence.trim()}. ${sentences.join('. ')}';
  }

  // Fix all inconsistencies
  String _removeCategoriesArtifacts(String input) {
    return input
        .replaceAll('T i t l u l', 'Titlul')
        .replaceAll('C A R T E A', 'Cartea')
        .replaceAll('PARTEA', 'Partea')
        .replaceAll('Aricolul', "Articolul");
  }
  /* For the bad days
  List<String> _getArticles(String trimmedHtml) {
    var indexA = 0;
    var indexB = 0;
    var resultList = List<String>();
    var articleRegExp = RegExp(r'Articolul \d+\.');

    do {
      indexA = trimmedHtml.indexOf(articleRegExp, indexA);
      
      indexB = trimmedHtml.indexOf(articleRegExp, indexA + 1);
 
      if (indexB == -1 && indexA != -1)
        indexB = trimmedHtml.indexOf(RegExp(r'^(?:[\t ]*(?:\r?\n|\r))+', multiLine: true), indexA + 1);
      
      if (indexA == -1 || indexB == -1)
        break;

      var articleSubstring = trimmedHtml.substring(indexA, indexB);
      
      indexA = indexB;

      resultList.add(articleSubstring);
    }
    while (indexA != -1 && indexB != -1);
    
    return resultList;
  }
  */
}
