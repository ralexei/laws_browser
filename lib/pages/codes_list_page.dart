import 'package:flutter/material.dart';
import 'package:laws_browser/utils/constants/codes.dart';
import 'package:laws_browser/utils/constants/download_messages.dart';
import 'package:laws_browser/utils/helpers/download_helper.dart';
import 'package:laws_browser/utils/helpers/navigation_utils.dart';
import 'package:laws_browser/models/common/code.dart';
import 'package:laws_browser/widgets/custom_app_bar.dart';
import 'package:laws_browser/widgets/download_button.dart';

import 'code_content_page.dart';

class CodesListPage extends StatelessWidget {
  const CodesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context, 'Coduri'),
        body: ListView.builder(
            itemCount: codes.length,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Text(codes[index].name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DownloadButton(codes[index]),
                      IconButton(
                        onPressed: () {
                          NavigationUtils.openSearch(context, codes[index]);
                        },
                        icon: const Icon(Icons.search),
                      ),
                      IconButton(
                          onPressed: () {
                            NavigationUtils.openCodeMenu(context, codes[index]);
                          },
                          icon: const Icon(Icons.settings))
                    ],
                  ),
                  onTap: () async {
                    await _onTap(context, codes[index]);
                  });
            }));
  }

  Future<bool?> _onTap(BuildContext context, Code code) async {
    if (code.lastUpdate != null) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CodeContentPage(code: code)));
    }

    return DownloadHelper.askForDownload(context, code, DownloadMessages.codeMissingDownload)
        .then((value) {
      if (value) {
        NavigationUtils.openCode(context, code); // redirect
      }

      return value;
    });
  }
}
