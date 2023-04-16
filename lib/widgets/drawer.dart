import 'package:flutter/material.dart';
import 'package:laws_browser/pages/about_page.dart';
import 'package:laws_browser/pages/codes_list_page.dart';
import 'package:laws_browser/pages/terms_and_conditions_page.dart';

Widget getDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      children: ListTile.divideTiles(
        context: context,
        tiles: [
          ListTile(
            title: Text(
              'Lex MD',
              style: TextStyle(
                color: Colors.white,
                fontSize: Theme.of(context).textTheme.titleLarge?.fontSize
              ),
            ),
            tileColor: Colors.blue,
          ),
          ListTile(
            title: const Text('Codurile'),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const CodesListPage()));
            },
          ),
          ListTile(
            title: const Text('Termenii și condiții'),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const TermsAndConditionsPage()));
            },
          ),
          ListTile(
            title: const Text('Despre'),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AboutPage()));
            },
          )
        ],
      ).toList(),
    ),
  );
}
