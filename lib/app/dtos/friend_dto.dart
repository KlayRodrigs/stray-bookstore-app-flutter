class FriendDto {
  FriendDto({required this.id, required this.name, required this.motherName, required this.phone, required this.fromWhere});
  final String id;
  final String name;
  final String motherName;
  final String phone;
  final String fromWhere;

  factory FriendDto.fromCollection(Map<String, dynamic> data, String id) {
    return FriendDto(
      id: id,
      name: data['name'] ?? '',
      motherName: data['motherName'] ?? '',
      phone: data['phone'] ?? '',
      fromWhere: data['fromWhere'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'motherName': motherName,
      'phone': phone,
      'fromWhere': fromWhere,
    };
  }

  factory FriendDto.fakeData() {
    return FriendDto(
      id: '1',
      name: 'John Doe',
      motherName: 'Jane Doe',
      phone: '123456789',
      fromWhere: 'Brazil',
    );
  }
}
