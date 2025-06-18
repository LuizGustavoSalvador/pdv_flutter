// lib/app/features/auth/presentation/bloc/auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // No futuro, vamos injetar o LoginUseCase aqui
  // final LoginUseCase loginUseCase;

  AuthBloc(/*this.loginUseCase*/) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        // Simula uma chamada de rede
        await Future.delayed(const Duration(seconds: 2));

        // No futuro, chamaríamos o usecase:
        // await loginUseCase(email: event.email, password: event.password);

        // Simula sucesso
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure('Erro de login: ${e.toString()}'));
      }
    });
  }
}
