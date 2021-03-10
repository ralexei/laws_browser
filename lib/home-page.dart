import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laws_browser/article-page.dart';
import 'package:laws_browser/models/category-model.dart';
import 'package:laws_browser/repositories/categories_repository.dart';

class HomePage extends StatelessWidget {
  final _paddingCoeficient = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cod Civil')
      ),
      body: FutureBuilder<List<Category>>(
        builder: (context, projectSnap){
          if (projectSnap.hasData){
            return ListView.builder(
              itemCount: projectSnap.data.length,
              itemBuilder: (context, index) {
                return _buildTree(projectSnap.data[index], 0, context);
              }
            );
          }
          return Center(child: Text('Something went wrong'));
        },
        // future: CategoriesRepository.instance.getHierarchized(),
      ),
    );
  }

  Widget _buildTree(Category rootCategory, int level, BuildContext context) {
    // if (rootCategory.children.isEmpty && rootCategory.articles.isNotEmpty)
    //   return ListTile(
    //     // contentPadding: EdgeInsetsDirectional.only(start: 18 * level.toDouble()),
    //     onTap: () {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(builder: (context) => ArticlePage(articleText: rootCategory.articles.map((f) => f.articleText).join('\n\n'), categoryName: rootCategory.name))
    //       );
    //     },
    //     title: Padding(
    //       child: Text(rootCategory.name),
    //       padding: EdgeInsetsDirectional.only(start: _paddingCoeficient * level.toDouble())
    //     )
    //   );
    return ExpansionTile(
      // leading: Icon(Icons.play_circle_outline),
      title: Padding(
        child: Text('rootCategory.name'),
        padding: EdgeInsetsDirectional.only(start: _paddingCoeficient * level.toDouble())
      ),
      key: PageStorageKey<Category>(rootCategory),
      // children: rootCategory.children.map((m) => _buildTree(m, level + 1, context)).toList(),
    );
  }
}