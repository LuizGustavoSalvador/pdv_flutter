import 'package:flutter/material.dart';
import 'package:pdv_flutter/app/features/auth/presentation/pages/login_page.dart';
import 'package:pdv_flutter/app/features/home/presentation/pages/home_page.dart';

void main() {
  runApp(const TopedindoPDVApp());
}

class TopedindoPDVApp extends StatefulWidget {
  const TopedindoPDVApp({super.key});

  @override
  State<TopedindoPDVApp> createState() => _TopedindoPDVAppState();
}

class _TopedindoPDVAppState extends State<TopedindoPDVApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleThemeMode() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  void _setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Topedindo PDV Fiscal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) =>
            LoginPage(themeMode: _themeMode, onThemeToggle: _toggleThemeMode),
        '/home': (context) =>
            HomePage(themeMode: _themeMode, onThemeModeChanged: _setThemeMode),
      },
    );
  }
}
