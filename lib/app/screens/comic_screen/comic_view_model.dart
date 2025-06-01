import 'package:flutter/material.dart';
import 'package:stray_bookstore_app/app/core/safe_notifier.dart';
import '../../dtos/comic_dto.dart';
import '../../repositories/comic_repository.dart';

enum ComicState {
  loading,
  content,
  error;

  bool get isLoading => this == ComicState.loading;
  bool get isContent => this == ComicState.content;
  bool get isError => this == ComicState.error;
}

class ComicViewModel with ChangeNotifier, SafeNotifierMixin {
  final ComicRepository repository;
  ComicViewModel({required this.repository});

  List<ComicDto> comics = [];
  ComicState state = ComicState.content;
  String? errorMessage;

  Future<void> fetchComics() async {
    try {
      emitState(ComicState.loading);
      errorMessage = null;
      comics = await repository.getComics();
      emitState(ComicState.content);
    } catch (e) {
      emitState(ComicState.error);
      errorMessage = 'Erro ao buscar revistas: [${e.toString()}';
    }
  }

  Future<void> addComic(ComicDto comic) async {
    try {
      emitState(ComicState.loading);
      errorMessage = null;
      await repository.addComic(comic);
      await fetchComics();
    } catch (e) {
      errorMessage = 'Erro ao adicionar revista: ${e.toString()}';
      emitState(ComicState.error);
    }
  }

  Future<void> removeComic(String id) async {
    try {
      emitState(ComicState.loading);
      await repository.removeComic(id);
      await fetchComics();
      emitState(ComicState.content);
    } catch (e) {
      errorMessage = 'Erro ao remover revista: ${e.toString()}';
      emitState(ComicState.error);
    }
  }

  Future<void> updateComic(ComicDto comic) async {
    try {
      emitState(ComicState.loading);
      await repository.updateComic(comic);
      await fetchComics();
      emitState(ComicState.content);
    } catch (e) {
      errorMessage = 'Erro ao atualizar revista: ${e.toString()}';
      emitState(ComicState.error);
    }
  }

  void emitState(ComicState state) {
    this.state = state;
    notify();
  }
}
