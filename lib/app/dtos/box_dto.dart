class BoxDto {
  BoxDto({required this.label, required this.boxNumber, required this.color, this.id});

  final String? id;
  final String label;
  final int boxNumber;
  final String color;

  factory BoxDto.fromCollection(Map<String, dynamic> map, [String? id]) {
    return BoxDto(id: id, label: map['label'] as String, boxNumber: map['boxNumber'] as int, color: map['color'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'label': label, 'boxNumber': boxNumber, 'color': color};
  }
}
