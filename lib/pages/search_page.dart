import 'package:flutter/material.dart';
import 'package:laws_browser/components/activity_indicator.dart';
import 'package:laws_browser/utils/models/code.dart';

class SearchPage extends StatelessWidget {
  final Code _code;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SearchPage(this._code, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cautare in ${_code.name}')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Termenii de cautare'
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Introduceti text';
                }
                
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ActivityIndicator.of(context).show();
                  _executeSearch().then((value) {
                    ActivityIndicator.of(context).hide();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ActivityIndicator(child: child)));
                  });
                }
              },
              child: const Text('Cauta'))
          ],
        )
      )
    );
  }

  Future<void> _executeSearch() async {

  }
}