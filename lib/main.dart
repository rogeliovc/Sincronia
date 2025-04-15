import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:async';
import 'screens/home_page.dart';
import 'main_scaffold.dart';

import 'services/tidal_api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Instanciamos el servicio aquí para pasarlo a LoginPage
    final tidalService = TidalApiService();
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'),
        Locale('en', 'US'),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Sincronía',
      theme: ThemeData(
        fontFamily: 'Lora',
        primaryColor: const Color(0xFF02395D),
        scaffoldBackgroundColor: const Color(0xFF02395D),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF02395D),
          elevation: 0,
          centerTitle: true,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontFamily: 'Lora', fontWeight: FontWeight.bold, color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: MainScaffold(),
    );
  }
}
