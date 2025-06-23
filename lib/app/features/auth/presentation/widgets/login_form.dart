import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdv_flutter/app/core/l10n/app_localizations.dart';
import 'package:pdv_flutter/app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pdv_flutter/app/features/auth/presentation/bloc/auth_event.dart';
import 'package:pdv_flutter/app/features/auth/presentation/bloc/auth_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _rememberEmail = false;

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthLoadRememberedUser());
  }

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthRememberUserLoaded) {
          setState(() {
            _rememberEmail = state.remember;
            if (state.remember && state.email != null) {
              _userController.text = state.email!;
            }
          });
        }
      },
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Container(
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(51),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/topedindo-logo.svg',
                    height: 80,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.loginSubtitle,
                    style: textTheme.bodyLarge?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _userController,
                    decoration: InputDecoration(
                      labelText: l10n.loginTitle,
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: colorScheme.primary,
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? l10n.requiredLoginFields
                        : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: l10n.password,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: colorScheme.primary,
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? l10n.requiredPasswordFields
                        : null,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _rememberEmail = !_rememberEmail;
                          });
                        },
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: _rememberEmail,
                                onChanged: (value) => setState(
                                  () => _rememberEmail = value ?? false,
                                ),
                              ),
                              Text(l10n.rememberEmail),
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/forgot_password');
                        },
                        child: Text(l10n.forgotPassword),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final isLoading = state is AuthLoading;
                        return ElevatedButton(
                          onPressed: isLoading ? null : _onLoginPressed,
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : Text(
                                  l10n.loginButton,
                                  style: const TextStyle(fontSize: 16),
                                ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginRequested(
          email: _userController.text,
          password: _passController.text,
          rememberEmail: _rememberEmail,
        ),
      );
    }
  }
}
