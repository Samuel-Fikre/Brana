import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpState {
  final bool isLoading;
  final String? errorMessage;
  final bool emailConfirmationRequired;

  SignUpState({
    this.isLoading = false,
    this.errorMessage,
    this.emailConfirmationRequired = false,
  });

  SignUpState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? emailConfirmationRequired,
  }) {
    return SignUpState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      emailConfirmationRequired:
          emailConfirmationRequired ?? this.emailConfirmationRequired,
    );
  }
}

class SignUpViewModel extends StateNotifier<SignUpState> {
  SignUpViewModel() : super(SignUpState());

  Future<bool> signUp(String email, String password) async {
    state = state.copyWith(
        isLoading: true, errorMessage: null, emailConfirmationRequired: false);
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user != null) {
        if (response.user!.emailConfirmedAt == null) {
          state =
              state.copyWith(isLoading: false, emailConfirmationRequired: true);
        } else {
          state = state.copyWith(isLoading: false);
        }
        return true;
      } else {
        state =
            state.copyWith(isLoading: false, errorMessage: 'Sign up failed.');
        return false;
      }
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(
          isLoading: false, errorMessage: 'Unexpected error: $e');
      return false;
    }
  }

  void clearError() => state = state.copyWith(errorMessage: null);
}

// Riverpod provider
final signUpViewModelProvider =
    StateNotifierProvider<SignUpViewModel, SignUpState>(
  (ref) => SignUpViewModel(),
);
