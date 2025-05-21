import 'package:cloud_firestore/cloud_firestore.dart';
import '../dtos/borrow_dto.dart';

class BorrowRepository {
  final _collection = FirebaseFirestore.instance.collection('borrows');

  Future<List<BorrowDto>> getBorrows() async {
    final snapshot = await _collection.get();
    return snapshot.docs
        .map(
          (doc) => BorrowDto(
            id: doc.id,
            friendId: doc['friendId'],
            comicId: doc['comicId'],
            loanDate: (doc['loanDate'] as Timestamp).toDate(),
            returnDate: (doc['returnDate'] as Timestamp).toDate(),
          ),
        )
        .toList();
  }

  Future<void> addBorrow(BorrowDto borrow) async => await _collection.add({
    'friendId': borrow.friendId,
    'comicId': borrow.comicId,
    'loanDate': Timestamp.fromDate(borrow.loanDate),
    'returnDate': Timestamp.fromDate(borrow.returnDate),
  });

  Future<void> removeBorrow(String id) async => await _collection.doc(id).delete();

  Future<void> updateBorrow(BorrowDto borrow) async => await _collection.doc(borrow.id).update({
    'friendId': borrow.friendId,
    'comicId': borrow.comicId,
    'loanDate': Timestamp.fromDate(borrow.loanDate),
    'returnDate': Timestamp.fromDate(borrow.returnDate),
  });
}
