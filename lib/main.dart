import 'package:flutter/material.dart';
import 'home-page.dart';
void main() async {
  
  // var categories = await LegisSynchronizer.instance.parseLegis(); 

  // await CategoriesRepository.instance.insertRange(categories);
  runApp(LBApp());
}

class LBApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage()
    );
  }
}