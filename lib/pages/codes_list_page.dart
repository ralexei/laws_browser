import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:laws_browser/components/activity_indicator.dart';
import 'package:laws_browser/pages/code_menu_page.dart';
import 'package:laws_browser/services/abstractions/codes_service.dart';
import 'package:laws_browser/utils/constants/codes.dart' as codes;
import 'package:laws_browser/utils/models/code.dart';

class CodesListPage extends StatelessWidget {

  const CodesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Coduri')),
        body: ListView.builder(
            itemCount: codes.codes.length,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Text(codes.codes[index].name),
                  onTap: () {
                    ActivityIndicator.of(context).show();
                    _codeTap(context, codes.codes[index])
                      .then((value) {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ActivityIndicator(child: CodeMenuPage(code: codes.codes[index]))));
                        ActivityIndicator.of(context).hide();
                      });
                  });
            })
          );
  }

  Future<void> _codeTap(BuildContext context, Code code) async {
    var commonBox = await Hive.openBox('common');

    if (!commonBox.containsKey(code.id)) {
      await GetIt.instance.get<CodesService>().downloadCode(code);
    }
  }
}
