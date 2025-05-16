import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stray_bookstore_app/app/repositories/auth_repository.dart';
import 'package:stray_bookstore_app/app/repositories/errors/signup_error.dart';

enum OnboardingState {
  loading,
  content,
  error;

  bool get isLoading => this == OnboardingState.loading;
  bool get isContent => this == OnboardingState.content;
  bool get isError => this == OnboardingState.error;
}

class OnboardingViewModel with ChangeNotifier {
  OnboardingViewModel({required this.authRepository});
  final AuthRepository authRepository;

  OnboardingState state = OnboardingState.content;
  String? errorMessage;

  Future<void> login(String email, String password) async {
    state = OnboardingState.loading;
    errorMessage = null;
    notifyListeners();
    try {
      if (email.isEmpty) {
        throw FirebaseAuthException(code: 'invalid-email', message: 'O email não pode estar vazio');
      }
      if (password.isEmpty) {
        throw FirebaseAuthException(code: 'wrong-password', message: 'A senha não pode estar vazia');
      }
      await authRepository.signIn(email, password);
      state = OnboardingState.content;
      errorMessage = null;
    } on FirebaseAuthException catch (e) {
      state = OnboardingState.error;
      errorMessage = e.message;
    } catch (e) {
      state = OnboardingState.error;
      errorMessage = 'Erro desconhecido: ${e.toString()}';
    }
    notifyListeners();
  }

  Future<void> signup(String email, String password) async {
    state = OnboardingState.loading;
    try {
      final userCredential = await authRepository.signUp(email, password);
      if (userCredential != null) {
        state = OnboardingState.content;
      } else {
        state = OnboardingState.error;
      }
    } on SignupError catch (e) {
      state = OnboardingState.error;
      errorMessage = e.message;
    } on FirebaseAuthException catch (e) {
      state = OnboardingState.error;
      errorMessage = e.message;
    } catch (e) {
      state = OnboardingState.error;
      errorMessage = 'Erro desconhecido: ${e.toString()}';
    }
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    if (state == OnboardingState.error) {
      state = OnboardingState.content;
      notifyListeners();
    }
  }
}
