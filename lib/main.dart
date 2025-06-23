import 'dart:io'; // Import necessário para checar a plataforma

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdv_flutter/app/core/database/sqlite_connection_factory.dart';
import 'package:pdv_flutter/app/core/l10n/app_localizations.dart';
import 'package:pdv_flutter/app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pdv_flutter/app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:pdv_flutter/app/features/auth/presentation/pages/login_page.dart';
import 'package:pdv_flutter/app/features/home/presentation/pages/home_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  // Garante que os "bindings" do Flutter estejam prontos.
  WidgetsFlutterBinding.ensureInitialized();

  // Verifica se o app está rodando em Windows, macOS ou Linux.
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Inicializa a "fábrica" de bancos de dados para usar a implementação FFI.
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Agora, com a fábrica correta inicializada, esta linha vai funcionar sem erros.
  await SqliteConnectionFactory().openConnection();

  runApp(const TopedindoPDVApp());
}

// O resto do seu código continua exatamente igual, não precisa mudar nada.
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
      onGenerateTitle: (context) {
        return AppLocalizations.of(context)!.systemTitle;
      },
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => BlocProvider(
          create: (context) => AuthBloc(),
          child: LoginPage(
            themeMode: _themeMode,
            onThemeToggle: _toggleThemeMode,
          ),
        ),
        '/home': (context) =>
            HomePage(themeMode: _themeMode, onThemeModeChanged: _setThemeMode),
        '/forgot_password': (context) => BlocProvider(
          create: (context) => AuthBloc(),
          child: ForgotPasswordPage(
            themeMode: _themeMode,
            onThemeToggle: _toggleThemeMode,
          ),
        ),
      },
    );
  }
}
