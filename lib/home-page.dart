import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laws_browser/models/category-model.dart';
import 'package:laws_browser/repositories/categories_repository.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<Category>>(
        builder: (context, projectSnap){
          if (projectSnap.hasData){
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(
                color: Colors.black
              ),
              itemCount: projectSnap.data.length,
              itemBuilder: (context, index) {
                return _buildTree(projectSnap.data[index]);
              }
            );
          }
          return Center(child: Text('Something went wrong'));
        },
        future: CategoriesRepository.instance.getHierarchized(),
      ),
    );
  }

  Widget _buildTree(Category rootCategory){
    if (rootCategory.children.isEmpty)
      return ListTile(title: Text(rootCategory.name));
    
    return ExpansionTile(
      title: Text(rootCategory.name),
      key: PageStorageKey<Category>(rootCategory),
      children: rootCategory.children.map(_buildTree).toList(),
    );
  }
}