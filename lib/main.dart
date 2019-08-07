import 'package:flutter/material.dart';

import 'home/pages/home-page.dart';

void main() => runApp(LBApp());

class LBApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage()
    );
  }
}