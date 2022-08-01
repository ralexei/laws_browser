import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laws_browser/pages/home_page.dart';

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(children: [
      DrawerHeader(child: Text('Laws Browser')),
      ListTile(
          title: Text('Coduri'),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => new HomePage())))
    ]));
  }
}
