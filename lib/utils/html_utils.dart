import 'package:html/dom.dart';
import 'package:html/parser.dart';

class HtmlUtils {
  static String removeHtmlStringTags(String htmlString) {
    htmlString = htmlString.replaceAll('<sup>', '-').replaceAll('</sup>', '');

    var document = parse(htmlString);
    var parsedString = parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  static String removeHtmlDocumentTags(Document document) {
    var parsedString = parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  static String fixSupTags(String htmlString) =>
      htmlString.replaceAll('<sup>', '-').replaceAll('</sup>', '');
}
