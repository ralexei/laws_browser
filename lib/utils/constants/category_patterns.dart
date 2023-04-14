import 'package:laws_browser/models/enums/category_types.dart';

RegExp parteaRegex = RegExp(r'Partea.+(<br \/>)?(\\n)?.+');
RegExp carteaRegex = RegExp(r'Cartea.+(<br \/>)?(\\n)?.+');
RegExp titlulRegex = RegExp(r'Titlul.+(<br \/>)?(\\n)?.+');
RegExp moduleRegex = RegExp(
    r'\W?(A-?\d*\s*\.|B-?\d*\s*\.|C-?\d*\s*\.|D-?\d*\s*\.|E-?\d*\s*\.).+(<br \/>)?(\\n)?.+');
RegExp capitolRegex = RegExp(r'Capitolul.+(<br \/>)?(\\n)?.+');
RegExp sectionRegex = RegExp(r'Sec.*iunea.+(<br \/>)?(\\n)?.+');
RegExp subsectionRegex = RegExp(r'Subsec.*iunea.+(<br \/>)?(\\n)?.+');
RegExp paragraphRegex = RegExp(r'§.+(<br \/>)?(\\n)?.+');
RegExp articleRegex = RegExp(r'Articolul\s*\d+(\.|\s)?');

List<RegExp> sectionPatterns = <RegExp>[
  parteaRegex,
  carteaRegex,
  titlulRegex,
  moduleRegex,
  capitolRegex,
  sectionRegex,
  subsectionRegex,
  paragraphRegex,
  articleRegex
];

RegExp anyCategoryRegExp = RegExp(r'(Articolul.+\.?|'
    r'§.+(<br />)?(\n)?.+|'
    r'Subsec.*iunea.+(<br />)?(\n)?.+|'
    r'Sec.*iunea.+(<br />)?(\n)?.+|'
    r'Capitolul.+(<br />)?(\n)?.+|'
    r'\W?(A|B|C)-?\d*\s*\.(\n)?.+'
    r'Titlul.+(<br />)?(\n)?.+|'
    r'Cartea.+(<br />)?(\n)?.+|'
    r'Partea.+(<br />)?(\n)?.+)');

RegExp buildPattern(int startingIndex) {
  if (startingIndex > CategoryTypes.articol.index) {
    startingIndex = CategoryTypes.articol.index;
  }

  Iterable<RegExp> patterns = sectionPatterns;

  if (startingIndex == CategoryTypes.articol.index) {
    patterns = sectionPatterns.reversed.toList();
    startingIndex = 0;
  }
  var joinedPatterns = patterns
      .where((e) => e.pattern.isNotEmpty)
      .map((e) => e.pattern)
      .skip(startingIndex)
      .take(patterns.length - startingIndex)
      .join('|');

  return RegExp('($joinedPatterns)');
}

// String _escape(String value) {
//   const pattern = '[\\W]';
//   return value.replaceAllMapped(RegExp(pattern), (Match match) {
//     return '\\${match.group(0)}';
//   });
// }
// RegExp sectionRegex = RegExp(r'Sec.*iunea.+');
// RegExp subsectionRegex = RegExp(r'Subsec.*iunea.+');
// RegExp moduleRegex = RegExp(r'\W(A-?\d*\s*\.|B-?\d*\s*\.|C-?\d*\s*\.)');
// RegExp anyCategoryRegExp = RegExp(r'(Articolul.+\.?|'
//     r'§.+(<br />)?(\n)?.+|'
//     r'Subsec.*iunea.+(<br />)?(\n)?.+|'
//     r'Sec.*iunea.+(<br />)?(\n)?.+|'
//     r'Capitolul.+(<br />)?(\n)?.+|'
//     r'\W(A-?\d*\s*\.|B-?\d*\s*\.|C-?\d*\s*\..+(<br />)?(\n)?.+)|'
//     r'Titlul.+(<br />)?(\n)?.+|'
//     r'Cartea.+(<br />)?(\n)?.+|'
//     r'Partea.+(<br />)?(\n)?.+)');
