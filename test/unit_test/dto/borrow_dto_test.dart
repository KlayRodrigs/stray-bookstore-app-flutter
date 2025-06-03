import 'package:flutter_test/flutter_test.dart';
import 'package:stray_bookstore_app/app/dtos/borrow_dto.dart';
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
}
