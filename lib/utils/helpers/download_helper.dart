import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:laws_browser/services/abstractions/codes_service.dart';
import 'package:laws_browser/models/common/code.dart';
import 'package:loader_overlay/loader_overlay.dart';

class DownloadHelper {
  static Future<bool> askForDownload(BuildContext context, Code code, String message) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Atenție'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Da')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Nu'))
          ],
        );
      },
    ).then((value) async {
      if (value!) {
        context.loaderOverlay.show();

        var result = await _downloadCode(context, code).then((value) {
          context.loaderOverlay.hide();
          return value;
        });

        return result;
      }
      return true;
    });
  }

  static Future<bool> _downloadCode(BuildContext context, Code code) async =>
      await GetIt.instance.get<CodesService>().downloadCode(code);
}
