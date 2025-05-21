import 'package:flutter/material.dart';

class BorrowSaveButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Future<void> Function() onSave;

  const BorrowSaveButton({super.key, required this.formKey, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          await onSave();
        }
      },
      child: const Text('Salvar', style: TextStyle(color: Colors.white)),
    );
  }
}
