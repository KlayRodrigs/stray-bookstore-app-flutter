import 'package:flutter/material.dart';
import 'package:stray_bookstore_app/app/dtos/comic_dto.dart';

class BorrowComicDropdown extends StatelessWidget {
  final String? selectedComicId;
  final ValueChanged<String?> onChanged;
  final List<ComicDto> comics;

  const BorrowComicDropdown({super.key, required this.selectedComicId, required this.onChanged, required this.comics});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedComicId,
      decoration: const InputDecoration(labelText: 'Revista', border: OutlineInputBorder()),
      items: comics.map((c) => DropdownMenuItem(value: c.id, child: Text('${c.collection} (Edição ${c.editionNumber})'))).toList(),
      onChanged: onChanged,
      validator: (v) => (v == null || v.isEmpty) ? 'Selecione a revista' : null,
    );
  }
}
