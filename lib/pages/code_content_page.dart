import 'package:flutter/material.dart';
import 'package:laws_browser/models/entities/category_model.dart';
import 'package:laws_browser/pages/article_page.dart';
import 'package:laws_browser/persistence/repositories/categories.repository.dart';
import 'package:laws_browser/utils/models/code.dart';

class CodeContentPage extends StatelessWidget {
  final double _paddingCoeficient = 14;
  final Code code;

  const CodeContentPage({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(code.name)),
      body: FutureBuilder<List<Category>>(
        builder: (context, projectSnap) {
          if (projectSnap.hasData) {
            return ListView.builder(
                itemCount: projectSnap.data!.length,
                itemBuilder: (context, index) {
                  return _buildTree(projectSnap.data![index], 0, context);
                });
          }
          return const Center(child: Text('Something went wrong'));
        },
        future: CategoriesRepository.instance.getHierarchized(code.id),
      ),
    );
  }

  Widget _buildTree(Category rootCategory, int level, BuildContext context) {
    if (rootCategory.children!.isEmpty && rootCategory.articles!.isNotEmpty) {
      return ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ArticlePage(
                      articleText: rootCategory.articles!
                          .map((f) => f.articleText)
                          .join('\n\n'),
                      categoryName: rootCategory.name)));
        },
        title: Padding(
            padding:
                EdgeInsets.only(left: _paddingCoeficient * level.toDouble()),
            child: Text(rootCategory.name)),
      );
    }

    return ExpansionTile(
        title: Padding(
            padding:
                EdgeInsets.only(left: _paddingCoeficient * level.toDouble()),
            child: Text(rootCategory.name)),
        key: PageStorageKey<Category>(rootCategory),
        children: rootCategory.children!
            .map((m) => _buildTree(m, level + 1, context))
            .toList());
  }
}
