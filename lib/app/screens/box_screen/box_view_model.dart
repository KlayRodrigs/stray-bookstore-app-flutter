import 'package:flutter/material.dart';
import 'package:stray_bookstore_app/app/core/safe_notifier.dart';
import '../../dtos/box_dto.dart';
import '../../repositories/box_repository.dart';

enum BoxState {
  loading,
  content,
  error;

  bool get isLoading => this == BoxState.loading;
  bool get isContent => this == BoxState.content;
  bool get isError => this == BoxState.error;
}

class BoxViewModel with ChangeNotifier, SafeNotifierMixin {
  final BoxRepository repository;
  BoxViewModel({required this.repository});

  List<BoxDto> boxes = [];
  BoxState state = BoxState.content;
  String? errorMessage;

  Future<void> fetchBoxes() async {
    try {
      emitState(BoxState.loading);
      errorMessage = null;
      boxes = await repository.getBoxes();
      emitState(BoxState.content);
    } catch (e) {
      emitState(BoxState.error);
      errorMessage = 'Erro ao buscar caixas: [${e.toString()}';
    }
  }

  Future<void> addBox(BoxDto box) async {
    try {
      emitState(BoxState.loading);
      errorMessage = null;
      await repository.addBox(box);
      await fetchBoxes();
    } catch (e) {
      errorMessage = 'Erro ao adicionar caixa: ${e.toString()}';
      emitState(BoxState.error);
    }
  }

  Future<void> removeBox(String id) async {
    try {
      emitState(BoxState.loading);
      await repository.removeBox(id);
      await fetchBoxes();
      emitState(BoxState.content);
    } catch (e) {
      errorMessage = 'Erro ao remover caixa: ${e.toString()}';
      emitState(BoxState.error);
    }
  }

  Future<void> updateBox(String id, BoxDto box) async {
    try {
      emitState(BoxState.loading);
      await repository.updateBox(id, box);
      await fetchBoxes();
      emitState(BoxState.content);
    } catch (e) {
      errorMessage = 'Erro ao atualizar caixa: ${e.toString()}';
      emitState(BoxState.error);
    }
  }

  void emitState(BoxState state) {
    this.state = state;
    notify();
  }
}
