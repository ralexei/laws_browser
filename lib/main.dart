import 'package:flutter/material.dart';
import 'package:laws_browser/pages/home-page.dart';
import 'package:laws_browser/pages/splash-screen.dart';
import 'package:laws_browser/startup.dart';
void main() async {
  
  // var categories = await LegisSynchronizer.instance.parseLegis(); 

  // await CategoriesRepository.instance.insertRange(categories);
  runApp(LBApp());
}

class LBApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: Startup.initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return HomePage();
          } else {
            return SplashScreen();
          }
        }
      )
    );
  }
}