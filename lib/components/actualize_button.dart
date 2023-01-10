import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:laws_browser/persistence/repositories/categories.repository.dart';
import 'package:laws_browser/services/abstractions/codes_service.dart';
import 'package:laws_browser/utils/models/code.dart';

import 'activity_indicator.dart';

class ActualizeButton extends StatefulWidget {

  final Code _code;

  const ActualizeButton(this._code, {super.key});

  @override
  State<StatefulWidget> createState() => _ActualizeButtonState();
}

class _ActualizeButtonState extends State<ActualizeButton> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
            title: const Text('Actualizeaza'),
            leading: const Icon(Icons.refresh),
            trailing: FutureBuilder<String>(
              future: _getLastUpdateDate(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!);
                } else if (snapshot.hasError) {
                  return const Text('Failed');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            onTap: () => _redownloadCode(context)
          );
  }

  void _redownloadCode(BuildContext context) {
    var codeService = GetIt.instance.get<CodesService>();

    ActivityIndicator.of(context).show();
    codeService.downloadCode(widget._code)
      .then((value) {
        setState(() {});
      })
      .whenComplete(() {
        ActivityIndicator.of(context).hide();
      });
  }

    Future<String> _getLastUpdateDate() async {
    final lastUpdate = await CategoriesRepository.instance.getLastUpdate(widget._code.id);

    return lastUpdate ?? '';
  }
}