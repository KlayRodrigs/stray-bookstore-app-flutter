import 'package:flutter/material.dart';
import 'package:stray_bookstore_app/app/dtos/friend_dto.dart';

class BorrowFriendDropdown extends StatelessWidget {
  final String? selectedFriendId;
  final ValueChanged<String?> onChanged;
  final List<FriendDto> friends;

  const BorrowFriendDropdown({super.key, required this.selectedFriendId, required this.onChanged, required this.friends});

  @override
  Widget build(BuildContext context) {
    final validFriendIds = friends.map((f) => f.id).toSet();
    final isValid = selectedFriendId != null && validFriendIds.contains(selectedFriendId);
    return DropdownButtonFormField<String>(
      value: isValid ? selectedFriendId : null,
      decoration: const InputDecoration(labelText: 'Amiguinho', border: OutlineInputBorder()),
      items: friends.map((f) => DropdownMenuItem(value: f.id, child: Text(f.name))).toList(),
      onChanged: onChanged,
      validator: (v) => (v == null || v.isEmpty) ? 'Selecione o amiguinho' : null,
    );
  }
}
