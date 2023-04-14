import 'package:flutter/material.dart';
import 'package:laws_browser/utils/helpers/navigation_utils.dart';

PreferredSizeWidget customAppBar(BuildContext context, String title) {
  return AppBar(
    actions: [
      IconButton(
        onPressed: () {
          NavigationUtils.openGlobalSearch(context);
        },
        icon: const Icon(Icons.search))
    ],
  );
}