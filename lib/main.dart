import 'package:flutter/material.dart';
import 'package:projet_flutter/pages/declaration/declaration_form_page.dart';
import 'package:projet_flutter/pages/home/home.page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:projet_flutter/pages/login/login.page.dart';
import 'package:projet_flutter/pages/seance/seance.page.dart';
import 'package:projet_flutter/pages/seance/seance_admin_page.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        SfGlobalLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('fr', 'FR'),
      ],
      locale: const Locale('fr', 'FR'),
      debugShowCheckedModeBanner: false,
      title: 'Gestion Scolaire',
      home: const HomePage(),
      initialRoute: "/home",
      routes: {
        "/home": (context) => const HomePage(),
        "/login": (context) => const LoginPage(),
        "/seance": (context) => const SeancePage(),
        "/admin/seance": (context) => const SeanceAdminPage(),
        "/declaration/form": (context) => const DeclarationFormPage(),
      },
    );
  }
}
