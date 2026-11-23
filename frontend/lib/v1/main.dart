import 'package:flutter/material.dart';

import 'package:chronon/v1/Shared/chronon_colors.dart';
import 'package:chronon/v1/HomeSub/home_main.dart';

void main() {
  runApp(const ChrononApp());
}

// ---------------------------------------------------------------------------
// App Root  –  v1
// ---------------------------------------------------------------------------
class ChrononApp extends StatelessWidget {
  const ChrononApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chronon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: ChrononColors.abyss,
        colorScheme: const ColorScheme.dark(
          primary: ChrononColors.cyanAccent,
          secondary: ChrononColors.cobalt,
          surface: ChrononColors.navySurface,
        ),
        fontFamily: 'Segoe UI',
        useMaterial3: true,
      ),
      home: const ChrononHomePage(),
    );
  }
}
