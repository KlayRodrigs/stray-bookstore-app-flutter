import 'package:cloud_firestore/cloud_firestore.dart';
import '../dtos/friend_dto.dart';

class FriendRepository {
  final _collection = FirebaseFirestore.instance.collection('friends');

  Future<List<FriendDto>> getFriends() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map((doc) => FriendDto.fromCollection(doc.data(), doc.id)).toList();
  }

  Future<void> addFriend(FriendDto friend) async => await _collection.add(friend.toJson());

  Future<void> removeFriend(String id) async => await _collection.doc(id).delete();

  Future<void> updateFriend(FriendDto friend) async => await _collection.doc(friend.id).update(friend.toJson());
}
