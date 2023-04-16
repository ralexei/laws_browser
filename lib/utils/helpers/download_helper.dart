import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:laws_browser/services/abstractions/codes_service.dart';
import 'package:laws_browser/models/common/code.dart';
import 'package:laws_browser/utils/constants/codes.dart';
import 'package:laws_browser/utils/helpers/dialogs.dart';
import 'package:loader_overlay/loader_overlay.dart';

class DownloadHelper {
  static Future<bool> askForDownload(BuildContext context, Code code, String message) async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      if (!context.mounted) return false;

      await showAlert(context, 'Eroare', 'Lipsește conexiunea cu internet');

      return false;
    }

    if (!context.mounted) return false;

    var confirmationResult = await openConfirmationDialog(context, 'Atenție', message);

    if (!context.mounted) return false;

    if (confirmationResult != null && confirmationResult) {
      context.loaderOverlay.show();

      var result = await _downloadCode(context, code);

      if (context.mounted) {
        context.loaderOverlay.hide();
      }

      return result;
    }

    return false;
  }

  static Future<bool> askForDownloadAll(BuildContext context) async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      if (!context.mounted) return false;

      await showAlert(context, 'Eroare', 'Lipsește conexiunea cu internet');

      return false;
    }

    if (!context.mounted) return false;
    var confirmationMessage = 'Doriți să descărcați toate codurile care lispesc?\nAceastă operațiune poate dura câteva minute.';
    var confirmationResult = await openConfirmationDialog(context, 'Atenție', confirmationMessage);

    if (!context.mounted) return false;

    if (confirmationResult != null && confirmationResult) {
      context.loaderOverlay.show();
      
      var result = await _downloadAllCodes(context);

      if (context.mounted) {
        context.loaderOverlay.hide();
      }

      return result;
    }

    return false;
  }

  static Future<bool> _downloadCode(BuildContext context, Code code) async =>
      await GetIt.instance.get<CodesService>().downloadCode(code);

  static Future<bool> _downloadAllCodes(BuildContext context) async {
    try {
      final missingCodes = codes.where((w) => w.lastUpdate == null);

      for (var code in missingCodes) {
        await _downloadCode(context, code);
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
