import 'package:flutter/material.dart';

class ComicNotFound extends StatelessWidget {
  const ComicNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.menu_book, size: 60, color: Colors.orange.shade300),
        const SizedBox(height: 18),
        const Text('Nenhuma revista encontrada', style: TextStyle(fontSize: 18, color: Colors.black54)),
      ],
    );
  }
}
