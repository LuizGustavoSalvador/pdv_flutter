import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdv_flutter/app/core/database/sqlite_connection_factory.dart';
import 'package:pdv_flutter/app/core/l10n/app_localizations.dart';
import 'package:pdv_flutter/app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pdv_flutter/app/features/auth/presentation/pages/login_page.dart';
import 'package:pdv_flutter/app/features/home/presentation/pages/home_page.dart';

Future<void> main() async {
  // 1. Garante que os "bindings" do Flutter estejam prontos.
  //    É obrigatório quando a função main é assíncrona.
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Abre a conexão com o banco de dados SQLite local
  //    e o mantém pronto para uso.
  await SqliteConnectionFactory().openConnection();

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
        // 3. A rota de login agora é envolvida por um BlocProvider.
        //    Isso "provê" uma instância do AuthBloc para a LoginPage
        //    e todos os seus widgets filhos.
        '/': (context) => BlocProvider(
          create: (context) => AuthBloc(),
          child: LoginPage(
            themeMode: _themeMode,
            onThemeToggle: _toggleThemeMode,
          ),
        ),
        '/home': (context) =>
            HomePage(themeMode: _themeMode, onThemeModeChanged: _setThemeMode),
      },
    );
  }
}
