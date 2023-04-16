import 'package:flutter/material.dart';
import 'package:laws_browser/utils/constants/about.dart';
import 'package:laws_browser/widgets/drawer.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Despre')),
      drawer: getDrawer(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          children: [
            Text(
              appDescription,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              tncWarning,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            RichText(
                text: TextSpan(style: Theme.of(context).textTheme.bodyLarge, children: [
              TextSpan(text: emailWarning),
              TextSpan(text: contactEmail, style: const TextStyle(fontWeight: FontWeight.bold))
            ]))
          ],
        ),
      ),
    );
  }
}
