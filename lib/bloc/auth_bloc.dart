import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  AuthBloc() : super(AuthInitial()) {

    /// 🔍 CHECK AUTH STATUS
    on<CheckAuthStatus>((event, emit) async {
      emit(AuthLoading());

      try {
        final prefs = await SharedPreferences.getInstance();

        final email = prefs.getString('email');
        final password = prefs.getString('password');

        if (email != null && password != null) {
          emit(AuthAuthenticated(
            email: email,
            password: password,
          ));
        } else {
          emit(AuthUnauthenticated());
        }
      } catch (e) {
        emit(AuthError("Failed to check auth status"));
      }
    });

    /// 🔐 LOGIN
    on<LoginEvent>((event, emit) async {
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(AuthError("Email and Password cannot be empty"));
        return;
      }

      emit(AuthLoading());

      try {
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('email', event.email);
        await prefs.setString('password', event.password);

        emit(AuthAuthenticated(
          email: event.email,
          password: event.password,
        ));
      } catch (e) {
        emit(AuthError("Login failed"));
      }
    });

    /// 🚪 LOGOUT
    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());

      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        emit(AuthUnauthenticated());
      } catch (e) {
        emit(AuthError("Logout failed"));
      }
    });
  }
}