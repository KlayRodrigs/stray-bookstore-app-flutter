import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stray_bookstore_app/app/core/safe_notifier.dart';
import 'package:stray_bookstore_app/app/repositories/auth_repository.dart';

enum SignupState {
  loading,
  content,
  error;

  bool get isLoading => this == SignupState.loading;
  bool get isContent => this == SignupState.content;
  bool get isError => this == SignupState.error;
}

class HomeViewModel with ChangeNotifier, SafeNotifierMixin {
  HomeViewModel({required this.authRepository});

  SignupState state = SignupState.content;

  final AuthRepository authRepository;

  User? get currentUser => authRepository.getCurrentUser();

  Future<void> logout() async {
    try {
      emitLoading();
      await authRepository.signOut();
      emitContent();
    } catch (e) {
      emitError();
    }
  }

  void emitError() {
    state = SignupState.error;
    notify();
  }

  void emitLoading() {
    state = SignupState.loading;
    notify();
  }

  void emitContent() {
    state = SignupState.content;
    notify();
  }
}
