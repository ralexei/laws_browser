import 'package:flutter/material.dart';
import 'package:laws_browser/components/actualize_button.dart';
import 'package:laws_browser/utils/helpers/navigation_utils.dart';
import 'package:laws_browser/models/common/code.dart';
import 'package:loader_overlay/loader_overlay.dart';

class CodeMenuPage extends StatelessWidget {
  final Code code;

  const CodeMenuPage({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(title: Text(code.name)),
        body: ListView(
          children: [
            Card(
              child: ListTile(
                title: const Text('Navigheaza'),
                leading: const Icon(Icons.read_more),
                onTap: () => NavigationUtils.openCode(Navigator.of(context), code),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Cautare'),
                leading: const Icon(Icons.search),
                onTap: () => NavigationUtils.openSearch(Navigator.of(context), code),
              ),
            ),
            Card(
              child: ActualizeButton(code),
            ),
          ],
        ),
      ),
    );
  }
}
