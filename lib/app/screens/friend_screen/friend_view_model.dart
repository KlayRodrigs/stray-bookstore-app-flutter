import 'package:flutter/material.dart';
import 'package:stray_bookstore_app/app/core/safe_notifier.dart';
import '../../dtos/friend_dto.dart';
import '../../repositories/friend_repository.dart';

enum FriendState {
  loading,
  content,
  error;

  bool get isLoading => this == FriendState.loading;
  bool get isContent => this == FriendState.content;
  bool get isError => this == FriendState.error;
}

class FriendViewModel with ChangeNotifier, SafeNotifierMixin {
  final FriendRepository repository;
  FriendViewModel({required this.repository});

  List<FriendDto> friends = [];
  FriendState state = FriendState.content;
  String? errorMessage;

  Future<void> fetchFriends() async {
    try {
      emitState(FriendState.loading);
      errorMessage = null;
      friends = await repository.getFriends();
      emitState(FriendState.content);
    } catch (e) {
      emitState(FriendState.error);
      errorMessage = 'Erro ao buscar amigos: ${e.toString()}';
    }
  }

  Future<void> addFriend(FriendDto friend) async {
    try {
      emitState(FriendState.loading);
      errorMessage = null;
      await repository.addFriend(friend);
      await fetchFriends();
    } catch (e) {
      errorMessage = 'Erro ao adicionar amigo: ${e.toString()}';
      emitState(FriendState.error);
    }
  }

  Future<void> removeFriend(String id) async {
    try {
      emitState(FriendState.loading);
      await repository.removeFriend(id);
      await fetchFriends();
      emitState(FriendState.content);
    } catch (e) {
      errorMessage = 'Erro ao remover amigo: ${e.toString()}';
      emitState(FriendState.error);
    }
  }

  Future<void> updateFriend(FriendDto friend) async {
    try {
      emitState(FriendState.loading);
      await repository.updateFriend(friend);
      await fetchFriends();
      emitState(FriendState.content);
    } catch (e) {
      errorMessage = 'Erro ao atualizar amigo: ${e.toString()}';
      emitState(FriendState.error);
    }
  }

  void emitState(FriendState state) {
    this.state = state;
    notify();
  }
}
