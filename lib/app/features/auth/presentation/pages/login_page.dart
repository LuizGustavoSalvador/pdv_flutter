import 'package:flutter/material.dart';
import 'package:pdv_flutter/app/core/l10n/strings.dart';

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

  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      body: Stack(
        children: [
          Center(
            child: Card(
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
                          Strings.systemTitle,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _userController,
                          decoration: const InputDecoration(
                            labelText: Strings.loginTitle,
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? Strings.requiredLoginFields
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passController,
                          decoration: const InputDecoration(
                            labelText: Strings.password,
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) => value == null || value.isEmpty
                              ? Strings.requiredPasswordFields
                              : null,
                        ),
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _isLoading = true;
                                        _errorMessage = null;
                                      });
                                      // Mock login, substitua pela lógica real
                                      await Future.delayed(
                                        const Duration(seconds: 1),
                                      );
                                      if (_userController.text == 'admin' &&
                                          _passController.text == '1234') {
                                        if (!mounted) return;
                                        Navigator.of(
                                          context,
                                        ).pushReplacementNamed('/home');
                                      } else {
                                        setState(() {
                                          _errorMessage = Strings.loginError;
                                        });
                                      }
                                      setState(() => _isLoading = false);
                                    }
                                  },
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                : const Text(Strings.loginButton),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
                  ? Strings.lightMode
                  : Strings.darkMode,
              onPressed: widget.onThemeToggle,
            ),
          ),
        ],
      ),
    );
  }
}
