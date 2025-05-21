import 'package:cloud_firestore/cloud_firestore.dart';

class BorrowDto {
  BorrowDto({this.id, required this.friendId, required this.comicId, required this.loanDate, required this.returnDate});

  final String? id;
  final String friendId;
  final String comicId;
  final DateTime loanDate;
  final DateTime returnDate;

  factory BorrowDto.fromCollection(DocumentSnapshot doc) {
    return BorrowDto(
      id: doc.id,
      friendId: doc['friendId'] as String,
      comicId: doc['comicId'] as String,
      loanDate: (doc['loanDate'] as Timestamp).toDate(),
      returnDate: (doc['returnDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'friendId': friendId, 'comicId': comicId, 'loanDate': loanDate.toIso8601String(), 'returnDate': returnDate.toIso8601String()};
  }
}
