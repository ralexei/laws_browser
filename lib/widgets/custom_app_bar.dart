import 'package:flutter/material.dart';
import 'package:laws_browser/utils/helpers/download_helper.dart';
import 'package:laws_browser/utils/helpers/navigation_utils.dart';

PreferredSizeWidget customAppBar(BuildContext context, String title) {
  return AppBar(
    actions: [
      IconButton(
        onPressed: () async {
          await DownloadHelper.askForDownloadAll(context);
        },
        icon: const Icon(Icons.file_download),
      ),
      IconButton(
        onPressed: () {
          NavigationUtils.openGlobalSearch(Navigator.of(context));
        },
        icon: const Icon(Icons.search),
      ),
    ],
  );
}
