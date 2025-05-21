import 'package:flutter/material.dart';

class BorrowBottomSheetHeader extends StatelessWidget {
  const BorrowBottomSheetHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Cadastrar empréstimo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
      ],
    );
  }
}
