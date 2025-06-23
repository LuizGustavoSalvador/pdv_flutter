import 'package:flutter/material.dart';

class AppTheme {
  // Define a cor semente principal para o seu tema.
  // Você pode adicionar mais cores semente se quiser que a paleta seja gerada
  // a partir de múltiplas cores.
  static const Color _seedColor = Color(0xFF1677FF); // Sua cor #1677ff

  // Tema claro
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true, // Habilita o Material 3
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.light,
      ),
      // Você pode personalizar outros aspectos do tema aqui, como fontes,
      // estilos de texto, etc.
    );
  }

  // Tema escuro
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true, // Habilita o Material 3
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.dark,
      ),
    );
  }
}
