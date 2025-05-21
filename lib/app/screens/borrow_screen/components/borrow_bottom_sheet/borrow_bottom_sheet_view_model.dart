import 'package:flutter/material.dart';
import 'package:stray_bookstore_app/app/core/safe_notifier.dart';
import 'package:stray_bookstore_app/app/dtos/borrow_dto.dart';
import 'package:stray_bookstore_app/app/dtos/comic_dto.dart';
import 'package:stray_bookstore_app/app/dtos/friend_dto.dart';
import 'package:stray_bookstore_app/app/repositories/borrow_repository.dart';
import 'package:stray_bookstore_app/app/repositories/comic_repository.dart';
import 'package:stray_bookstore_app/app/repositories/friend_repository.dart';
import 'package:stray_bookstore_app/app/shared/widgets/adaptative_snackbar.dart';

enum AddBorrowState { loading, content, error }

class AddBorrowViewModel with ChangeNotifier, SafeNotifierMixin {
  Future<bool> updateBorrow(BuildContext context, BorrowDto borrow) async {
    try {
      await borrowRepository.updateBorrow(borrow);
      showAdaptativeSnackbar(
        context: context,
        title: 'Sucesso',
        message: 'Empréstimo atualizado com sucesso.',
        color: Colors.green,
        icon: Icons.check_circle,
      );
      return true;
    } catch (e) {
      if (context.mounted) {
        showAdaptativeSnackbar(context: context, title: 'Erro', message: 'Erro ao atualizar empréstimo: ${e.toString()}', color: Colors.red, icon: Icons.error);
      }
      return false;
    }
  }

  AddBorrowViewModel({
    required this.borrowRepository,
    required this.friendRepository,
    required this.comicRepository,
    required this.currentBorrows,
  });
  final BorrowRepository borrowRepository;
  final FriendRepository friendRepository;
  final ComicRepository comicRepository;
  final List<BorrowDto> currentBorrows;

  AddBorrowState state = AddBorrowState.loading;
  List<FriendDto> friends = [];
  List<ComicDto> comics = [];
  String? errorMessage;

  Future<void> fetchData() async {
    try {
      emitState(AddBorrowState.loading);
      friends = await friendRepository.getFriends();
      comics = await comicRepository.getComics();
      emitState(AddBorrowState.content);
    } catch (e) {
      emitState(AddBorrowState.error);
      errorMessage = 'Erro ao carregar dados: ${e.toString()}';
    }
  }

  Future<bool> addBorrow(BuildContext context, BorrowDto borrow) async {
    try {
      if (currentBorrows.any((b) => b.friendId == borrow.friendId)) {
        showAdaptativeSnackbar(
          context: context,
          title: 'Atenção',
          message: 'Este amiguinho já possui um empréstimo ativo.',
          color: Colors.orange,
          icon: Icons.warning_amber_rounded,
        );
        return false;
      }
      await borrowRepository.addBorrow(borrow);
      return true;
    } catch (e) {
      if (context.mounted) {
        showAdaptativeSnackbar(context: context, title: 'Erro', message: 'Erro ao adicionar empréstimo: ${e.toString()}', color: Colors.red, icon: Icons.error);
      }
      return false;
    }
  }

  void emitState(AddBorrowState state) {
    this.state = state;
    notify();
  }
}
