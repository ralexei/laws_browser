import 'package:flutter/material.dart';
import 'package:laws_browser/models/common/code.dart';
import 'package:laws_browser/utils/constants/download_messages.dart';
import 'package:laws_browser/utils/helpers/download_helper.dart';
import 'package:provider/provider.dart';

class ActualizeButton extends StatefulWidget {
  final Code code;

  const ActualizeButton(this.code, {super.key});

  @override
  State<StatefulWidget> createState() => _ActualizeButtonState();
}

class _ActualizeButtonState extends State<ActualizeButton> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.code,
      child: ListTile(
        title: const Text('Actualizeaza'),
        leading: const Icon(Icons.refresh),
        trailing: Consumer<Code>(
          builder: (context, code, child) {
            return Text(code.lastUpdate ?? '');
          },
        ),
        onTap: () async {
          await _redownloadCode(context);
        },
      ),
    );
  }

  Future _redownloadCode(BuildContext context) async {
    await DownloadHelper.askForDownload(context, widget.code, DownloadMessages.downloadCode);
  }
}
