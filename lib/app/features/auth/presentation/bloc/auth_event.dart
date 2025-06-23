abstract class AuthEvent {}

/// Evento para carregar o e-mail e a preferência "Lembrar e-mail" salvos.
class AuthLoadRememberedUser extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  final bool rememberEmail;

  LoginRequested({
    required this.email,
    required this.password,
    required this.rememberEmail,
  });
}

/// Evento para solicitar a recuperação de senha.
class ForgotPasswordRequested extends AuthEvent {
  final String email;
  ForgotPasswordRequested({required this.email});
}

class LogoutRequested extends AuthEvent {}
