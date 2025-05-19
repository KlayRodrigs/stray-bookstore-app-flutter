import 'package:cloud_firestore/cloud_firestore.dart';
import '../dtos/box_dto.dart';

class BoxRepository {
  final _collection = FirebaseFirestore.instance.collection('boxes');

  Future<List<BoxDto>> getBoxes() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map((doc) => BoxDto.fromCollection(doc.data(), doc.id)).toList();
  }

  Future<void> addBox(BoxDto box) async => await _collection.add(box.toJson());

  Future<void> removeBox(String id) async => await _collection.doc(id).delete();

  Future<void> removeBoxAndUpdateComics(String id) async {
    await _collection.doc(id).delete();
    final comics = await FirebaseFirestore.instance.collection('comics').where('boxId', isEqualTo: id).get();
    for (final doc in comics.docs) {
      await doc.reference.update({'boxId': null});
    }
  }

  Future<void> updateBox(String id, BoxDto box) async => await _collection.doc(id).update(box.toJson());
}
