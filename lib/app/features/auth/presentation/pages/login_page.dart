import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdv_flutter/app/core/l10n/app_localizations.dart';
import 'package:pdv_flutter/app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pdv_flutter/app/features/auth/presentation/bloc/auth_state.dart';
import 'package:pdv_flutter/app/features/auth/presentation/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  final ThemeMode themeMode;
  final VoidCallback onThemeToggle;

  const LoginPage({
    super.key,
    required this.themeMode,
    required this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        child: Container(
          // Fundo com gradiente, inspirado na sua imagem de referência
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2E3192), Color(0xFF1B1464)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Conteúdo principal (o formulário)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: LoginForm(),
                ),
              ),
              // Botão para trocar o tema
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: Icon(
                    themeMode == ThemeMode.dark
                        ? Icons.wb_sunny_outlined
                        : Icons.nights_stay_outlined,
                    color: Colors.white,
                  ),
                  tooltip: themeMode == ThemeMode.dark
                      ? l10n.lightMode
                      : l10n.darkMode,
                  onPressed: onThemeToggle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
