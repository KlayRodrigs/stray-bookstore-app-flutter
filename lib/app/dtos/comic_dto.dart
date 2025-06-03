class ComicDto {
  ComicDto({required this.id, required this.boxId, required this.collection, required this.editionNumber, required this.publishDate});
  final String id;
  final String boxId;
  final String collection;
  final int editionNumber;
  final String publishDate;

  factory ComicDto.fromCollection(Map<String, dynamic> data, String id) {
    return ComicDto(
      id: id,
      boxId: data['boxId'] ?? '',
      collection: data['collection'] ?? '',
      editionNumber: data['editionNumber'] is int ? data['editionNumber'] : int.tryParse(data['editionNumber']?.toString() ?? '') ?? 0,
      publishDate: data['publishDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'boxId': boxId,
      'collection': collection,
      'editionNumber': editionNumber,
      'publishDate': publishDate,
    };
  }

  factory ComicDto.fakeData() {
    return ComicDto(
      id: '1',
      boxId: '1',
      collection: 'collection',
      editionNumber: 1,
      publishDate: '2022-01-01',
    );
  }
}
