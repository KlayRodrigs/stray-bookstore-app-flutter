import 'package:flutter/material.dart';
import 'package:stray_bookstore_app/app/core/safe_notifier.dart';
import 'package:stray_bookstore_app/app/repositories/friend_repository.dart';

enum FriendCountState {
  loading,
  content,
  error;

  bool get isLoading => this == FriendCountState.loading;
  bool get isContent => this == FriendCountState.content;
  bool get isError => this == FriendCountState.error;
}

class FriendCountViewModel with ChangeNotifier, SafeNotifierMixin {
  FriendCountViewModel({required this.repository});
  final FriendRepository repository;

  int count = 0;
  FriendCountState state = FriendCountState.loading;
  String? errorMessage;

  Future<void> fetchFriendCount() async {
    try {
      emitState(FriendCountState.loading);
      final friends = await repository.getFriends();
      count = friends.length;
      emitState(FriendCountState.content);
    } catch (e) {
      errorMessage = 'Erro ao buscar amigos: ${e.toString()}';
      emitState(FriendCountState.error);
    }
  }

  emitState(FriendCountState state) {
    this.state = state;
    notify();
  }
}
