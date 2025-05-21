import 'package:flutter/material.dart';

Future<bool?> showConfirmDeleteDialog(BuildContext context, {String? message}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirmar remoção'),
      content: Text(message ?? 'Tem certeza que deseja remover este empréstimo?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Remover', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
