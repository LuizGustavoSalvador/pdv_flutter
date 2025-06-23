abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

/// Estado emitido após carregar as preferências do usuário.
class AuthRememberUserLoaded extends AuthState {
  final String? email;
  final bool remember;

  AuthRememberUserLoaded({this.email, required this.remember});
}

class AuthSuccess extends AuthState {
  // final UserEntity user;
  // AuthSuccess(this.user);
}

/// Estado de sucesso na recuperação de senha.
class ForgotPasswordSuccess extends AuthState {}

/// Estado de falha na recuperação de senha.
class ForgotPasswordFailure extends AuthState {
  final String message;
  ForgotPasswordFailure(this.message);
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}
