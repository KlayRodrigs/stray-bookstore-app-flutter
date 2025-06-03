import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stray_bookstore_app/app/dtos/borrow_dto.dart';
import 'package:stray_bookstore_app/app/dtos/comic_dto.dart';
import 'package:stray_bookstore_app/app/dtos/friend_dto.dart';
import 'package:stray_bookstore_app/app/screens/home_screen/home_view_model.dart';
import 'package:stray_bookstore_app/app/dtos/box_dto.dart';

import '../mocks/mocks.dart';

void main() {
  late AuthRepositoryMock authRepository;
  late FriendRepositoryMock friendRepository;
  late ComicRepositoryMock comicRepository;
  late BoxRepositoryMock boxRepository;
  late BorrowRepositoryMock borrowRepository;
  late HomeViewModel viewModel;

  setUp(() {
    authRepository = AuthRepositoryMock();
    friendRepository = FriendRepositoryMock();
    comicRepository = ComicRepositoryMock();
    boxRepository = BoxRepositoryMock();
    borrowRepository = BorrowRepositoryMock();

    viewModel = HomeViewModel(
      authRepository: authRepository,
      friendRepository: friendRepository,
      comicRepository: comicRepository,
      boxRepository: boxRepository,
      borrowRepository: borrowRepository,
    );
  });

  test('fetchAllData - sucesso', () async {
    when(() => friendRepository.getFriends()).thenAnswer((_) async => [FriendDto.fakeData(), FriendDto.fakeData()]);
    when(() => comicRepository.getComics()).thenAnswer((_) async => [ComicDto.fakeData()]);
    when(() => boxRepository.getBoxes()).thenAnswer((_) async => [BoxDto.fakeData()]);
    when(() => borrowRepository.getBorrows()).thenAnswer((_) async => [BorrowDto.fakeData(), BorrowDto.fakeData(), BorrowDto.fakeData()]);

    await viewModel.fetchAllData();

    expect(viewModel.state, HomeState.content);
    expect(viewModel.friendCount, 2);
    expect(viewModel.comicCount, 1);
    expect(viewModel.boxCount, 1);
    expect(viewModel.borrowCount, 3);
    expect(viewModel.boxes.length, 1);
  });

  test('fetchAllData - erro lança estado error', () async {
    when(() => friendRepository.getFriends()).thenThrow(Exception('erro'));
    when(() => comicRepository.getComics()).thenAnswer((_) async => []);
    when(() => boxRepository.getBoxes()).thenAnswer((_) async => []);
    when(() => borrowRepository.getBorrows()).thenAnswer((_) async => []);

    await viewModel.fetchAllData();

    expect(viewModel.state, HomeState.error);
  });

  test('fetchFriendCount atualiza friendCount', () async {
    when(() => friendRepository.getFriends()).thenAnswer((_) async => [FriendDto.fakeData()]);
    await viewModel.fetchFriendCount();
    expect(viewModel.friendCount, 1);
  });

  test('fetchComicCount atualiza comicCount', () async {
    when(() => comicRepository.getComics()).thenAnswer((_) async => [ComicDto.fakeData()]);
    await viewModel.fetchComicCount();
    expect(viewModel.comicCount, 1);
  });

  test('fetchBoxCount atualiza boxCount e boxes', () async {
    final boxes = [BoxDto(id: '1', label: 'Caixa 1', boxNumber: 1, color: 'blue'), BoxDto(id: '2', label: 'Caixa 2', boxNumber: 2, color: 'red')];
    when(() => boxRepository.getBoxes()).thenAnswer((_) async => boxes);
    await viewModel.fetchBoxCount();
    expect(viewModel.boxCount, 2);
    expect(viewModel.boxes, boxes);
  });

  test('fetchBorrowCount atualiza borrowCount', () async {
    when(() => borrowRepository.getBorrows()).thenAnswer((_) async => [BorrowDto.fakeData(), BorrowDto.fakeData()]);
    await viewModel.fetchBorrowCount();
    expect(viewModel.borrowCount, 2);
  });

  test('logout - sucesso', () async {
    when(() => authRepository.signOut()).thenAnswer((_) async {});
    await viewModel.logout();
    expect(viewModel.state, HomeState.content);
    verify(() => authRepository.signOut()).called(1);
  });

  test('logout - erro', () async {
    when(() => authRepository.signOut()).thenThrow(Exception('erro'));
    await viewModel.logout();
    expect(viewModel.state, HomeState.error);
  });
}
