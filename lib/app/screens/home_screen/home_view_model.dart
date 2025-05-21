import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stray_bookstore_app/app/core/safe_notifier.dart';
import 'package:stray_bookstore_app/app/repositories/auth_repository.dart';
import 'package:stray_bookstore_app/app/repositories/borrow_repository.dart';
import 'package:stray_bookstore_app/app/repositories/comic_repository.dart';
import 'package:stray_bookstore_app/app/repositories/friend_repository.dart';
import 'package:stray_bookstore_app/app/repositories/box_repository.dart';
import 'package:stray_bookstore_app/app/dtos/box_dto.dart';

enum HomeState {
  loading,
  content,
  error;

  bool get isLoading => this == HomeState.loading;
  bool get isContent => this == HomeState.content;
  bool get isError => this == HomeState.error;
}

class HomeViewModel with ChangeNotifier, SafeNotifierMixin {
  HomeViewModel({
    required this.authRepository,
    required this.friendRepository,
    required this.comicRepository,
    required this.boxRepository,
    required this.borrowRepository,
  });

  HomeState state = HomeState.content;

  final AuthRepository authRepository;
  final FriendRepository friendRepository;
  final ComicRepository comicRepository;
  final BoxRepository boxRepository;
  final BorrowRepository borrowRepository;

  int friendCount = 0;
  int comicCount = 0;
  int boxCount = 0;
  int borrowCount = 0;
  List<BoxDto> boxes = [];

  User? get currentUser => authRepository.getCurrentUser();

  Future<void> logout() async {
    try {
      emitState(HomeState.loading);
      await authRepository.signOut();
      emitState(HomeState.content);
    } catch (e) {
      emitState(HomeState.error);
    }
  }

  Future<void> fetchFriendCount() async {
    try {
      emitState(HomeState.loading);
      final friends = await friendRepository.getFriends();
      friendCount = friends.length;
      emitState(HomeState.content);
    } catch (e) {
      emitState(HomeState.error);
    }
  }

  Future<void> fetchComicCount() async {
    try {
      emitState(HomeState.loading);
      final comics = await comicRepository.getComics();
      comicCount = comics.length;
      emitState(HomeState.content);
    } catch (e) {
      emitState(HomeState.error);
    }
  }

  Future<void> fetchBoxCount() async {
    try {
      emitState(HomeState.loading);
      boxes = await boxRepository.getBoxes();
      boxCount = boxes.length;
      emitState(HomeState.content);
    } catch (e) {
      emitState(HomeState.error);
    }
  }

  Future<void> fetchBorrowCount() async {
    try {
      emitState(HomeState.loading);
      final borrows = await borrowRepository.getBorrows();
      borrowCount = borrows.length;
      emitState(HomeState.content);
    } catch (e) {
      emitState(HomeState.error);
    }
  }

  emitState(HomeState state) {
    this.state = state;
    notify();
  }
}
