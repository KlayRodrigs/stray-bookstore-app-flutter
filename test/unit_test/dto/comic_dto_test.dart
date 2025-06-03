import 'package:flutter_test/flutter_test.dart';
import 'package:stray_bookstore_app/app/dtos/comic_dto.dart';

void main() {
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
