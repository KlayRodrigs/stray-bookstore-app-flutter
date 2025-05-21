import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stray_bookstore_app/app/dtos/box_dto.dart';

class AddBoxBottomSheet extends StatefulWidget {
  const AddBoxBottomSheet({super.key, required this.onSave, this.onEdit, this.onDelete, this.initialBox});
  final Future<void> Function(BoxDto box) onSave;
  final Future<void> Function(BoxDto box)? onEdit;
  final Future<void> Function(BoxDto box)? onDelete;
  final BoxDto? initialBox;

  @override
  State<AddBoxBottomSheet> createState() => _AddBoxBottomSheetState();
}

class _AddBoxBottomSheetState extends State<AddBoxBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  String label = '';
  String color = '';
  String boxNumber = '';
  bool loading = false;

  @override
  void initState() {
    super.initState();
    final box = widget.initialBox;
    if (box != null) {
      label = box.label;
      color = box.color;
      boxNumber = box.boxNumber.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      padding: EdgeInsets.only(left: 24, right: 24, top: 32, bottom: MediaQuery.of(context).viewInsets.bottom + 24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.initialBox == null ? 'Cadastrar nova caixa' : 'Editar caixa', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop()),
              ],
            ),
            const SizedBox(height: 18),
            TextFormField(
              initialValue: label,
              decoration: const InputDecoration(labelText: 'Etiqueta', border: OutlineInputBorder()),
              onChanged: (v) => label = v,
              validator: (v) => (v == null || v.isEmpty) ? 'Informe a etiqueta' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: color,
              decoration: const InputDecoration(labelText: 'Cor', border: OutlineInputBorder()),
              onChanged: (v) => color = v,
              validator: (v) => (v == null || v.isEmpty) ? 'Informe a cor' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: boxNumber,
              decoration: const InputDecoration(labelText: 'Número da caixa', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (v) => boxNumber = v,
              validator: (v) => (v == null || v.isEmpty) ? 'Informe o número da caixa' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal.withValues(alpha: 0.85)),
              onPressed:
                  loading
                      ? null
                      : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => loading = true);
                          if (widget.initialBox == null) {
                            await widget.onSave(BoxDto(label: label, boxNumber: int.tryParse(boxNumber) ?? 0, color: color));
                          } else {
                            await widget.onEdit!(BoxDto(label: label, boxNumber: int.tryParse(boxNumber) ?? 0, color: color, id: widget.initialBox!.id));
                          }
                          setState(() => loading = false);
                          if (context.mounted) Navigator.of(context).pop();
                        }
                      },
              child:
                  loading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(widget.initialBox == null ? 'Cadastrar' : 'Salvar', style: const TextStyle(color: Colors.white)),
            ),
            if (widget.initialBox != null) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed:
                    loading
                        ? null
                        : () async {
                          await widget.onDelete!(BoxDto(label: label, boxNumber: int.tryParse(boxNumber) ?? 0, color: color, id: widget.initialBox!.id));
                          if (context.mounted) Navigator.of(context).pop();
                        },
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text('Remover', style: TextStyle(color: Colors.red)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
