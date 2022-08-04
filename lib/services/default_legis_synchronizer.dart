import 'package:http/http.dart' as http;
import 'package:laws_browser/models/entities/article_model.dart';
import 'package:laws_browser/models/entities/category_model.dart';
import 'package:laws_browser/services/abstractions/legis_synchronizer.dart';
import 'package:laws_browser/utils/html_utils.dart';

class DefaultLegisSynchronizer implements LegisSynchronizer {
  final RegExp _sectionRegEx = RegExp(r'Sec.*iunea.+');
  final RegExp _subsectionRegEx = RegExp(r'Subsec.*iunea.+');
  final List<Category> _categories = <Category>[];
  int biggestPriority = 1;

  @override
  Future<List<Category>> parseLegis(String url) async {
    var response = await http.get(Uri.parse(url));
    var trimmedHtml = HtmlUtils.removeHtmlTags(response.body);
    var categories = _getCategories(trimmedHtml);

    String firstCategory = categories[0];
    String firstCategoryName =
        firstCategory.substring(0, firstCategory.indexOf(' '));

    biggestPriority = _getCategoryHierarchyProperty(firstCategoryName);

    _mapCategoriesRelations(Category(name: firstCategory), categories);

    return _categories;
  }

  List<String> _getCategories(String trimmedHtml) {
    var categoryRegEx = RegExp(
        r'(PARTEA.+(<br />)?(\n)?.+|'
        r'Cartea.+(<br />)?(\n)?.+|'
        r'T i t l u l.+(<br />)?(\n)?.+|'
        r'Capitolul.+(<br />)?(\n)?.+|'
        r'Sec.*iunea.+(<br />)?(\n)?.+|'
        r'Subsec.*iunea.+(<br />)?(\n)?.+|'
        r'§.+(<br />)?(\n)?.+|'
        r'Articolul.+\.?)');
    var indexA = 0;
    var indexB = 0;
    var resultList = <String>[];

    do {
      indexA = trimmedHtml.indexOf(categoryRegEx, indexA);
      indexB = trimmedHtml.indexOf(categoryRegEx, indexA + 1);

      if (indexB == -1 && indexA != -1)
      {
        indexB = trimmedHtml.indexOf(
            RegExp(r'^(?:[\t ]*(?:\r?\n|\r))+', multiLine: true),
            indexA + 1);
      }

      if (indexA == -1 || indexB == -1) break;

      var articleSubstring = trimmedHtml.substring(indexA, indexB);

      indexA = indexB;

      resultList.add(articleSubstring);
    } while (indexA != -1 && indexB != -1);

    return resultList;
  }

  void _mapCategoriesRelations(Category parent, List<String> categories,
      [int index = 1]) {
    if (index >= categories.length) return;

    parent.name = _trimCategory(parent.name);

    var parentPriority = _getCategoryHierarchyProperty(parent.name);

    parent.name = parent.name.contains('T i t l u l')
        ? parent.name.replaceFirst('T i t l u l', 'Titlul')
        : parent.name;

    var closestChildPrority = _getCategoryHierarchyProperty(categories[index]);

    while (index < categories.length) {
      var categoryPriority = _getCategoryHierarchyProperty(categories[index]);

      if (categoryPriority == parentPriority && parentPriority == biggestPriority) break;

      if (categoryPriority <= parentPriority) return;

      if (categoryPriority == closestChildPrority) {
        var categoryName = categories[index];

        if (categoryPriority < 8) {
          // categoryName = categoryPriority.toString() + (categoryName.contains('T i t l u l') ? categories[index].replaceFirst('T i t l u l', 'Titlul') : categoryName);
          // categoryName = HtmlUtils.removeHtmlTags(categoryName);

          var newCategory = Category(name: categoryName);

          parent.children!.add(newCategory);
          _mapCategoriesRelations(newCategory, categories, index + 1);
        } else {
          if (categoryPriority != 0) {
            var articleNumberIndex = categoryName.indexOf(RegExp(r'[0-9]'));
            var articleNameEnd = categoryName.indexOf(RegExp(r'[^0-9]'), articleNumberIndex);
            var articleId = categoryName.substring(articleNumberIndex, articleNameEnd);
            var articleName = categoryName.substring(0, articleNameEnd);
            var articleText = categoryName;

            parent.articles!.add(Article(
                id: int.tryParse(articleId) ?? 0,
                articleName: articleName.trim(),
                articleText: articleText.trim()));
          }
        }
      }

      index++;
    }

    if (parentPriority == biggestPriority) {
      _categories.add(parent);

      if (index < categories.length)
      {
        _mapCategoriesRelations(
            Category(name: categories[index]), categories, index + 1);
      }
    }
  }

  int _getCategoryHierarchyProperty(String categoryName) {
    if (categoryName.contains("PARTEA")) {
      return 1;
    } else if (categoryName.contains("Cartea")) {
      return 2;
    } else if (categoryName.contains("T i t l u l")) {
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
