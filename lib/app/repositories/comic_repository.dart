import 'package:cloud_firestore/cloud_firestore.dart';
import '../dtos/comic_dto.dart';

class ComicRepository {
  final _collection = FirebaseFirestore.instance.collection('comics');

  Future<List<ComicDto>> getComics() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map((doc) => ComicDto.fromCollection(doc.data(), doc.id)).toList();
  }

  Future<void> addComic(ComicDto comic) async => await _collection.add(comic.toJson());

  Future<void> removeComic(String id) async => await _collection.doc(id).delete();

  Future<void> updateComic(ComicDto comic) async => await _collection.doc(comic.id).update(comic.toJson());
}
