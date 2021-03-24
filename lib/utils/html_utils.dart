import 'package:html/parser.dart';

class HtmlUtils {
  static String removeHtmlTags(String htmlString) {
    var document = parse(htmlString);
    var parsedString = parse(document.body!.text).documentElement!.text;

    return parsedString;
  }
}