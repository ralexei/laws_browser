import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:laws_browser/pages/home-page.dart';
import 'package:laws_browser/pages/splash-screen.dart';
import 'package:laws_browser/startup.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  runApp(LBApp());
}

class LBApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: [
          Locale('en', ''),
          Locale('ro', '')
        ],
        home: FutureBuilder(
            future: Startup.initialize(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return HomePage();
              } else {
                return SplashScreen();
              }
            }));
  }
}
