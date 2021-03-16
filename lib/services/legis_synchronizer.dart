import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:laws_browser/models/entities/article.model.dart';
import 'package:laws_browser/models/entities/category.model.dart';
import 'package:laws_browser/utils/html_utils.dart';

class LegisSynchronizer {
  static final LegisSynchronizer _instance = new LegisSynchronizer._internalCtor();

  static LegisSynchronizer get instance => _instance;

  final RegExp _sectionRegEx = new RegExp(r'Sec.*iunea.+');
  final RegExp _subsectionRegEx = new RegExp(r'Subsec.*iunea.+');

  List<Category> _categories = <Category>[];

  LegisSynchronizer._internalCtor();

  Future<List<Category>> parseLegis() async {
    var url = "https://www.legis.md/cautare/showdetails/112573";
    var response = await http.get(url);
    var unescaper = new HtmlUnescape();
    var trimmedHtml = HtmlUtils.removeHtmlTags(response.body);
    var categories = _getCategories(trimmedHtml);

    _mapCategoriesRelations(Category(name: categories[0]), categories);
    
    return _categories;
  }

  List<String> _getCategories(String trimmedHtml) {
    var categoryRegEx = new RegExp(r'(Cartea.+(<br />)?(\n).+|T i t l u l.+(<br />)?(\n)?.+|Capitolul.+(<br />)?(\n)?.+|Sec.*iunea.+(<br />)?(\n)?.+|Subsec.*iunea.+(<br />)?(\n)?.+|§.+(<br />)?(\n)?.+|Articolul.+\.?)');
    var indexA = 0;
    var indexB = 0;
    var resultList = <String>[];

    do {
      indexA = trimmedHtml.indexOf(categoryRegEx, indexA);
      indexB = trimmedHtml.indexOf(categoryRegEx, indexA + 1);
 
      if (indexB == -1 && indexA != -1)
        indexB = trimmedHtml.indexOf(new RegExp(r'^(?:[\t ]*(?:\r?\n|\r))+', multiLine: true), indexA + 1);
      
      if (indexA == -1 || indexB == -1)
        break;

      var articleSubstring = trimmedHtml.substring(indexA, indexB);
      
      indexA = indexB;

      resultList.add(articleSubstring);
    }
    while (indexA != -1 && indexB != -1);
    
    return resultList;
  }

  void _mapCategoriesRelations(Category parent, List<String> categories, [int index = 1]){
    if (index >= categories.length)
      return;

    parent.name = _trimCategory(parent.name);

    var parentPriority = _getCategoryHierarchyProperty(parent.name);

    parent.name = parent.name.contains('T i t l u l') ? parent.name.replaceFirst('T i t l u l', 'Titlul') : parent.name;

    var closestChildPrority = _getCategoryHierarchyProperty(categories[index]);

    while (index < categories.length)
    {
      var categoryPriority = _getCategoryHierarchyProperty(categories[index]);

      if (categoryPriority == parentPriority && parentPriority == 1)
        break;

      if (categoryPriority <= parentPriority)
        return;

      if (categoryPriority == closestChildPrority)
      {
        if (categoryPriority < 7){
          var categoryName = categories[index];

          // categoryName = categoryPriority.toString() + (categoryName.contains('T i t l u l') ? categories[index].replaceFirst('T i t l u l', 'Titlul') : categoryName);
          // categoryName = HtmlUtils.removeHtmlTags(categoryName);

          var newCategory = Category(name: categoryName);

          parent. children.add(newCategory);
          _mapCategoriesRelations(newCategory, categories, index + 1);
        }        
        else
        {
          if (categoryPriority != 0){
            var articleNameEnd = categories[index].indexOf(new RegExp(r'[^a-z]'));
            var articleName = categories[index].substring(0, articleNameEnd);
            var articleText = categories[index];

            parent.articles.add(Article(articleName: articleName.trim(), articleText: articleText.trim()));
          }
        }
      }

      index++;
    }

    if (parentPriority == 1)
    {
      _categories.add(parent);

      if (index < categories.length)
        _mapCategoriesRelations(Category(name: categories[index]), categories, index + 1);
    }
  }

  int _getCategoryHierarchyProperty(String categoryName){
    if (categoryName.contains("Cartea"))
				return 1;
			else if (categoryName.contains("T i t l u l"))
				return 2;
			else if (categoryName.contains("Capitolul"))
				return 3;
			else if (categoryName.contains(_sectionRegEx))
				return 4;
			else if (categoryName.contains(_subsectionRegEx))
				return 5;
      else if (categoryName.contains('§'))
        return 6;
			else if (categoryName.contains("Articolul"))
				return 7;

			return 0;
  }

  String _capitalize(String m){
    var lowerCase = m.toLowerCase().trim().replaceAll('\n', ' ');

    return lowerCase[0].toUpperCase() + lowerCase.substring(1);
  }

  String _trimCategory(String category){
    var trimmedCategory = category.trim().replaceFirst('\n', '. ');
    var sentences = trimmedCategory.split('.');
    var firstSentence = sentences.removeAt(0);
    
    sentences.removeWhere((r) => r == '');
    sentences = sentences.map(_capitalize).toList();
    
    return firstSentence.trim() + '. ' + sentences.join('. ');
  }

  /* For the bad days
  List<String> _getArticles(String trimmedHtml) {
    var indexA = 0;
    var indexB = 0;
    var resultList = List<String>();
    var articleRegExp = new RegExp(r'Articolul \d+\.');

    do {
      indexA = trimmedHtml.indexOf(articleRegExp, indexA);
      
      indexB = trimmedHtml.indexOf(articleRegExp, indexA + 1);
 
      if (indexB == -1 && indexA != -1)
        indexB = trimmedHtml.indexOf(new RegExp(r'^(?:[\t ]*(?:\r?\n|\r))+', multiLine: true), indexA + 1);
      
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