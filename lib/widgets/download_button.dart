import 'package:flutter/material.dart';
import 'package:laws_browser/utils/constants/download_messages.dart';
import 'package:laws_browser/utils/helpers/download_helper.dart';
import 'package:laws_browser/models/common/code.dart';
import 'package:provider/provider.dart';

class DownloadButton extends StatefulWidget {
  const DownloadButton(this.code, {super.key});

  final Code code;

  @override
  State<StatefulWidget> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.code,
      child: Consumer<Code>(
        builder: (context, code, child) => _getDownloadButton(code),
      ),
    );
  }

  Widget _getDownloadButton(Code code) {
    if (code.lastUpdate != null) {
      return IconButton(
          icon: const Icon(Icons.download_for_offline_rounded),
          color: Colors.green,
          onPressed: () async {
            await DownloadHelper.askForDownload(context, code, DownloadMessages.redownloadCode); // process result
          });
    } else {
      return IconButton(
          icon: const Icon(Icons.download),
          onPressed: () async {
            await DownloadHelper.askForDownload(context, code, DownloadMessages.downloadCode);
          });
    }
  }
}
