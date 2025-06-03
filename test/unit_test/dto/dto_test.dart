import 'package:flutter_test/flutter_test.dart';
import 'package:stray_bookstore_app/app/dtos/borrow_dto.dart';
import 'package:stray_bookstore_app/app/dtos/box_dto.dart';
import 'package:stray_bookstore_app/app/dtos/friend_dto.dart';
import 'package:stray_bookstore_app/app/dtos/comic_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  test('BorrowDto.fromCollection e toJson', () {
    final timestamp = Timestamp.fromDate(DateTime(2023, 1, 1));
    final mockDoc = MockDocumentSnapshot();
    when(() => mockDoc.id).thenReturn('10');
    when(() => mockDoc['friendId']).thenReturn('f1');
    when(() => mockDoc['comicId']).thenReturn('c1');
    when(() => mockDoc['loanDate']).thenReturn(timestamp);
    when(() => mockDoc['returnDate']).thenReturn(timestamp);

    final dto = BorrowDto.fromCollection(mockDoc);
    expect(dto.id, '10');
    expect(dto.friendId, 'f1');
    expect(dto.comicId, 'c1');
    expect(dto.loanDate, timestamp.toDate());
    expect(dto.returnDate, timestamp.toDate());

    final json = dto.toJson();
    expect(json['friendId'], 'f1');
    expect(json['comicId'], 'c1');
    expect(json['loanDate'], timestamp.toDate().toIso8601String());
    expect(json['returnDate'], timestamp.toDate().toIso8601String());
  });

  test('BoxDto.fromCollection e toJson', () {
    final map = {'label': 'Caixa 1', 'boxNumber': 10, 'color': 'Azul'};
    final dto = BoxDto.fromCollection(map, 'b1');
    expect(dto.id, 'b1');
    expect(dto.label, 'Caixa 1');
    expect(dto.boxNumber, 10);
    expect(dto.color, 'Azul');

    final json = dto.toJson();
    expect(json['label'], 'Caixa 1');
    expect(json['boxNumber'], 10);
    expect(json['color'], 'Azul');
  });

  test('FriendDto.fromCollection e toJson', () {
    final map = {'name': 'Ana', 'motherName': 'Maria', 'phone': '123', 'fromWhere': 'Brasil'};
    final dto = FriendDto.fromCollection(map, 'f1');
    expect(dto.id, 'f1');
    expect(dto.name, 'Ana');
    expect(dto.motherName, 'Maria');
    expect(dto.phone, '123');
    expect(dto.fromWhere, 'Brasil');

    final json = dto.toJson();
    expect(json['name'], 'Ana');
    expect(json['motherName'], 'Maria');
    expect(json['phone'], '123');
    expect(json['fromWhere'], 'Brasil');
  });

  test('ComicDto.fromCollection e toJson', () {
    final map = {'boxId': 'b1', 'collection': 'Marvel', 'editionNumber': 5, 'publishDate': '2020-01-01'};
    final dto = ComicDto.fromCollection(map, 'c1');
    expect(dto.id, 'c1');
    expect(dto.boxId, 'b1');
    expect(dto.collection, 'Marvel');
    expect(dto.editionNumber, 5);
    expect(dto.publishDate, '2020-01-01');

    final json = dto.toJson();
    expect(json['boxId'], 'b1');
    expect(json['collection'], 'Marvel');
    expect(json['editionNumber'], 5);
    expect(json['publishDate'], '2020-01-01');
  });
}
