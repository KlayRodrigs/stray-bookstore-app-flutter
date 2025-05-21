import 'package:flutter/material.dart';

class BorrowDatePickerField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateSelected;
  final DateTime? firstDate;
  final String? Function()? validator;

  const BorrowDatePickerField({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
    this.firstDate,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      controller: TextEditingController(
        text: selectedDate != null ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}' : '',
      ),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: firstDate ?? DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) onDateSelected(picked);
      },
      validator: (v) => validator != null ? validator!() : null,
    );
  }
}
