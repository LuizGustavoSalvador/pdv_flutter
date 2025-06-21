import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdv_flutter/app/core/l10n/app_localizations.dart';
import 'package:pdv_flutter/app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pdv_flutter/app/features/auth/presentation/bloc/auth_event.dart';
import 'package:pdv_flutter/app/features/auth/presentation/bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback onThemeToggle;

  const LoginPage({
    super.key,
    required this.themeMode,
    required this.onThemeToggle,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Usando AppLocalizations para pegar os textos traduzidos
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      // O BlocListener serve para executar ações que não reconstroem a tela,
      // como navegar para outra página ou mostrar um SnackBar.
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // Se o login for bem-sucedido, navega para a home
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (state is AuthFailure) {
            // Se der erro, mostra uma mensagem
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        child: Stack(
          children: [
            Center(
              // O BlocBuilder reconstrói a UI com base no estado do BLoC.
              // Ideal para mostrar/esconder um indicador de loading.
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final isLoading = state is AuthLoading;

                  return Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: SizedBox(
                        width: 350,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                l10n.systemTitle,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                controller: _userController,
                                decoration: InputDecoration(
                                  labelText: l10n.loginTitle,
                                  prefixIcon: const Icon(Icons.person),
                                  border: const OutlineInputBorder(),
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? l10n.requiredLoginFields
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _passController,
                                decoration: InputDecoration(
                                  labelText: l10n.password,
                                  prefixIcon: const Icon(Icons.lock),
                                  border: const OutlineInputBorder(),
                                ),
                                obscureText: true,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? l10n.requiredPasswordFields
                                    : null,
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: isLoading
                                      ? null // Desabilita o botão enquanto carrega
                                      : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            // Dispara o evento para o BLoC
                                            context.read<AuthBloc>().add(
                                              LoginRequested(
                                                email: _userController.text,
                                                password: _passController.text,
                                              ),
                                            );
                                          }
                                        },
                                  child: isLoading
                                      // Se estiver carregando, mostra o spinner
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      // Senão, mostra o texto
                                      : Text(l10n.loginButton),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: Icon(
                  widget.themeMode == ThemeMode.dark
                      ? Icons.wb_sunny_outlined
                      : Icons.nights_stay_outlined,
                ),
                tooltip: widget.themeMode == ThemeMode.dark
                    ? l10n.lightMode
                    : l10n.darkMode,
                onPressed: widget.onThemeToggle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
