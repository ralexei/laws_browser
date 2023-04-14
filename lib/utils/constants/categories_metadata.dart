import 'package:laws_browser/models/common/category_metadata.dart';
import 'package:laws_browser/models/enums/category_types.dart';
import 'package:laws_browser/utils/constants/category_patterns.dart' as patterns;

List<CategoryMetadata> categoriesMetadata = <CategoryMetadata>[
  CategoryMetadata('Partea', CategoryTypes.partea),
  CategoryMetadata('Cartea', CategoryTypes.cartea),
  CategoryMetadata('Titlul', CategoryTypes.titlul),
  CategoryMetadata(patterns.moduleRegex, CategoryTypes.letterModule),
  CategoryMetadata('Capitolul', CategoryTypes.capitolul),
  CategoryMetadata(patterns.sectionRegex, CategoryTypes.sectiune),
  CategoryMetadata(patterns.subsectionRegex, CategoryTypes.subsectiune),
  CategoryMetadata('§', CategoryTypes.paragraf),
  CategoryMetadata('Articolul', CategoryTypes.articol)
];
