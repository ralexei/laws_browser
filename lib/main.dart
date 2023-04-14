import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:laws_browser/pages/home_page.dart';
import 'package:laws_browser/pages/splash_screen.dart';
import 'package:laws_browser/startup.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loader_overlay/loader_overlay.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const LBApp());
}

class LBApp extends StatelessWidget {
  const LBApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('ro', '')
        ],
        home: FutureBuilder(
            future: Startup.initialize(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return const LoaderOverlay(child: HomePage());
              } else {
                return const SplashScreen();
              }
            }));
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
