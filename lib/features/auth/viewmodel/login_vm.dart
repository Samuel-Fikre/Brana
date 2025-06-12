import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginState {
  final bool isLoading;
  final String? errorMessage;

  LoginState({this.isLoading = false, this.errorMessage});

  LoginState copyWith({bool? isLoading, String? errorMessage}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class LoginViewModel extends StateNotifier<LoginState> {
  LoginViewModel() : super(LoginState());

  Future<bool> loginWithEmail(String email, String password) async {
    // Client-side validation
    if (email.trim().isEmpty || password.isEmpty) {
      state = state.copyWith(errorMessage: 'Please enter email and password.');
      return false;
    }
    if (!email.contains('@')) {
      state =
          state.copyWith(errorMessage: 'Please enter a valid email address.');
      return false;
    }
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      state = state.copyWith(isLoading: false);
      return response.user != null;
    } on AuthException catch (e) {
      String message = e.message;
      if (message.toLowerCase().contains('email not confirmed')) {
        message =
            'Your email is not confirmed. Please check your inbox for a confirmation link.';
      } else if (message.toLowerCase().contains('invalid login credentials')) {
        message = 'Incorrect email or password.';
      } else if (message.toLowerCase().contains('network')) {
        message = 'Network error. Please check your connection.';
      }
      state = state.copyWith(isLoading: false, errorMessage: message);
      return false;
    } catch (e) {
      state = state.copyWith(
          isLoading: false, errorMessage: 'Unexpected error: $e');
      return false;
    }
  }

  Future<bool> loginWithGoogle(String googleWebClientId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: googleWebClientId,
      );
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in
        state = state.copyWith(
            isLoading: false, errorMessage: 'Google sign-in cancelled.');
        return false;
      }
      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;
      if (accessToken == null || idToken == null) {
        state = state.copyWith(
            isLoading: false,
            errorMessage: 'Google sign-in failed: Missing token.');
        return false;
      }
      await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
      state = state.copyWith(isLoading: false);
      return true;
    } on AuthException catch (e) {
      String message = e.message;
      if (message.toLowerCase().contains('network')) {
        message = 'Network error. Please check your connection.';
      }
      state = state.copyWith(isLoading: false, errorMessage: message);
      return false;
    } catch (e) {
      state = state.copyWith(
          isLoading: false, errorMessage: 'Google sign-in error: $e');
      return false;
    }
  }

  void clearError() => state = state.copyWith(errorMessage: null);
}

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>(
  (ref) => LoginViewModel(),
);
