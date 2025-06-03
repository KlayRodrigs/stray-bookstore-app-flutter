import 'package:flutter_test/flutter_test.dart';
import 'package:stray_bookstore_app/app/dtos/friend_dto.dart';

void main() {
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
}
