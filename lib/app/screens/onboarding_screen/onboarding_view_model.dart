import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stray_bookstore_app/app/core/safe_notifier.dart';
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

class OnboardingViewModel with ChangeNotifier, SafeNotifierMixin {
  OnboardingViewModel({required this.authRepository});
  final AuthRepository authRepository;

  OnboardingState state = OnboardingState.content;
  String? errorMessage;

  Future<void> login(String email, String password) async {
    emitState(OnboardingState.loading);
    errorMessage = null;
    notify();
    try {
      if (email.isEmpty) {
        throw FirebaseAuthException(code: 'invalid-email', message: 'O email não pode estar vazio');
      }
      if (password.isEmpty) {
        throw FirebaseAuthException(code: 'wrong-password', message: 'A senha não pode estar vazia');
      }
      await authRepository.signIn(email, password);
      emitState(OnboardingState.content);
      errorMessage = null;
    } on FirebaseAuthException catch (e) {
      emitState(OnboardingState.error);
      errorMessage = e.message;
    } catch (e) {
      emitState(OnboardingState.error);
      errorMessage = 'Erro desconhecido: ${e.toString()}';
    }
    notify();
  }

  Future<void> signup(String email, String password) async {
    emitState(OnboardingState.loading);
    try {
      final userCredential = await authRepository.signUp(email, password);
      if (userCredential != null) {
        emitState(OnboardingState.content);
      } else {
        emitState(OnboardingState.error);
      }
    } on SignupError catch (e) {
      emitState(OnboardingState.error);
      errorMessage = e.message;
    } on FirebaseAuthException catch (e) {
      emitState(OnboardingState.error);
      errorMessage = e.message;
    } catch (e) {
      emitState(OnboardingState.error);
      errorMessage = 'Erro desconhecido: ${e.toString()}';
    }
    notify();
  }

  void clearError() {
    errorMessage = null;
    if (state == OnboardingState.error) emitState(OnboardingState.content);
  }

  void emitState(OnboardingState state) {
    this.state = state;
    notify();
  }
}
