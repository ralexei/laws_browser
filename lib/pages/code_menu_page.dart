import 'package:flutter/material.dart';
import 'package:laws_browser/components/activity_indicator.dart';
import 'package:laws_browser/components/actualize_button.dart';
import 'package:laws_browser/pages/code_content_page.dart';
import 'package:laws_browser/pages/search_page.dart';
import 'package:laws_browser/utils/models/code.dart';

class CodeMenuPage extends StatelessWidget {
  final Code code;

  const CodeMenuPage({super.key, required this.code});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(code.name)),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: const Text('Navigheaza'),
              leading: const Icon(Icons.read_more),
              onTap: () => _navigate(context),
            )
          ),
          Card(
            child: ListTile(
              title: const Text('Cautare'),
              leading: const Icon(Icons.search),
              onTap: () => _openSearch(context)
            )
          ),
          Card(
            child: ActualizeButton(code),
          )
        ],
      ),
    );
  }

  void _openSearch(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ActivityIndicator(child: SearchPage(code))));
  }

  void _navigate(BuildContext context) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => CodeContentPage(code: code)));
  }
}