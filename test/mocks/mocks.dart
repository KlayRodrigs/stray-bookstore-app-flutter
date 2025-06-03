// ignore_for_file: subtype_of_sealed_class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stray_bookstore_app/app/repositories/auth_repository.dart';
import 'package:stray_bookstore_app/app/repositories/borrow_repository.dart';
import 'package:stray_bookstore_app/app/repositories/box_repository.dart';
import 'package:stray_bookstore_app/app/repositories/comic_repository.dart';
import 'package:stray_bookstore_app/app/repositories/friend_repository.dart';
import 'package:mocktail/mocktail.dart';

class AuthRepositoryMock extends Mock implements AuthRepository {}

class FriendRepositoryMock extends Mock implements FriendRepository {}

class ComicRepositoryMock extends Mock implements ComicRepository {}

class BoxRepositoryMock extends Mock implements BoxRepository {}

class BorrowRepositoryMock extends Mock implements BorrowRepository {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

class MockTimestamp extends Mock implements Timestamp {}

