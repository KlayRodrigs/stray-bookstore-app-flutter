import 'package:flutter/material.dart';
import 'package:stray_bookstore_app/app/core/safe_notifier.dart';
import 'package:stray_bookstore_app/app/dtos/borrow_dto.dart';
import 'package:stray_bookstore_app/app/dtos/comic_dto.dart';
import 'package:stray_bookstore_app/app/dtos/friend_dto.dart';
import 'package:stray_bookstore_app/app/repositories/borrow_repository.dart';
import 'package:stray_bookstore_app/app/repositories/comic_repository.dart';
import 'package:stray_bookstore_app/app/repositories/friend_repository.dart';
import 'package:stray_bookstore_app/app/shared/widgets/adaptative_snackbar.dart';

enum BorrowState {
  loading,
  content,
  error;

  bool get isLoading => this == BorrowState.loading;
  bool get isContent => this == BorrowState.content;
  bool get isError => this == BorrowState.error;
}

class BorrowViewModel with ChangeNotifier, SafeNotifierMixin {
  final BorrowRepository repository;
  final FriendRepository friendRepository;
  final ComicRepository comicRepository;

  BorrowViewModel({required this.repository, required this.friendRepository, required this.comicRepository});

  List<BorrowDto> borrows = [];
  List<FriendDto> friends = [];
  List<ComicDto> comics = [];
  BorrowState state = BorrowState.content;
  String? errorMessage;

  Future<void> fetchBorrows() async {
    try {
      emitState(BorrowState.loading);
      errorMessage = null;
      borrows = await repository.getBorrows();
      friends = await friendRepository.getFriends();
      comics = await comicRepository.getComics();
      emitState(BorrowState.content);
    } catch (e) {
      emitState(BorrowState.error);
      errorMessage = 'Erro ao buscar empréstimos: ${e.toString()}';
    }
  }

  Future<void> addBorrow(BuildContext context, {required BorrowDto borrow}) async {
    try {
      emitState(BorrowState.loading);
      errorMessage = null;
      if (borrows.any((b) => b.friendId == borrow.friendId)) {
        showAdaptativeSnackbar(
          context: context,
          title: 'Atenção',
          message: 'Este amiguinho já possui um empréstimo ativo.',
          color: Colors.orange,
          icon: Icons.warning_amber_rounded,
        );
        emitState(BorrowState.content);
        return;
      }
      await repository.addBorrow(borrow);
      await fetchBorrows();
    } catch (e) {
      errorMessage = 'Erro ao adicionar empréstimo: ${e.toString()}';
      emitState(BorrowState.error);
    }
  }

  Future<void> removeBorrow(String id) async {
    try {
      emitState(BorrowState.loading);
      await repository.removeBorrow(id);
      await fetchBorrows();
      emitState(BorrowState.content);
    } catch (e) {
      errorMessage = 'Erro ao remover empréstimo: ${e.toString()}';
      emitState(BorrowState.error);
    }
  }

  Future<void> updateBorrow(BorrowDto borrow) async {
    try {
      emitState(BorrowState.loading);
      await repository.updateBorrow(borrow);
      await fetchBorrows();
      emitState(BorrowState.content);
    } catch (e) {
      errorMessage = 'Erro ao atualizar empréstimo: ${e.toString()}';
      emitState(BorrowState.error);
    }
  }

  void emitState(BorrowState state) {
    this.state = state;
    notify();
  }
}
