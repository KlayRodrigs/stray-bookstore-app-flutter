import 'package:flutter_test/flutter_test.dart';
import 'package:stray_bookstore_app/app/dtos/box_dto.dart';

void main() {
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
}
