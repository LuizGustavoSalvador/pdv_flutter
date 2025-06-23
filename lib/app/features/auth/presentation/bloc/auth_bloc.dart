// lib/app/features/auth/presentation/bloc/auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoadRememberedUser>(_onLoadRememberedUser);
    on<LoginRequested>(_onLoginRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Simula uma chamada de rede
      await Future.delayed(const Duration(seconds: 2));

      // Simula sucesso
      if (event.email == 'admin' && event.password == 'admin') {
        emit(AuthSuccess());

        // Salva as preferências após o login bem-sucedido
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('remember_email', event.rememberEmail);
        if (event.rememberEmail) {
          await prefs.setString('saved_email', event.email);
        } else {
          await prefs.remove('saved_email');
        }
      } else {
        emit(AuthFailure('Login ou senha inválidos!'));
      }
    } catch (e) {
      emit(AuthFailure('Erro de login: ${e.toString()}'));
    }
  }

  Future<void> _onLoadRememberedUser(
    AuthLoadRememberedUser event,
    Emitter<AuthState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('saved_email');
    final remember = prefs.getBool('remember_email') ?? false;
    emit(AuthRememberUserLoaded(email: email, remember: remember));
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Aqui você pode limpar tokens, etc.
    emit(AuthInitial());
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Simula uma chamada de API para enviar o link de recuperação
      await Future.delayed(const Duration(seconds: 2));
      // Aqui você faria a chamada real para sua API de recuperação de senha
      // Ex: await _authRepository.sendPasswordResetEmail(event.email);
      emit(ForgotPasswordSuccess());
    } catch (e) {
      emit(
        ForgotPasswordFailure('Erro ao solicitar recuperação: ${e.toString()}'),
      );
    }
  }
}
