import 'package:flutter/material.dart';
import '../../../dtos/box_dto.dart';
import '../box_view_model.dart';
import 'add_box_bottom_sheet.dart';

class BoxCard extends StatelessWidget {
  final BoxDto box;
  final BoxViewModel viewModel;
  final BuildContext parentContext;
  const BoxCard({super.key, required this.box, required this.viewModel, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: _parseColor(box.color), child: Text(box.boxNumber.toString(), style: const TextStyle(color: Colors.white))),
        title: Text(box.label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Cor: ${box.color}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.orange),
              onPressed:
                  () => showModalBottomSheet(
                    context: parentContext,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => AddBoxBottomSheet(viewModel: viewModel, initialBox: box),
                  ),
              tooltip: 'Editar',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder:
                      (ctx) => AlertDialog(
                        title: const Text('Remover caixa'),
                        content: const Text('Tem certeza que deseja remover esta caixa?'),
                        actions: [
                          TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.of(ctx).pop(false)),
                          TextButton(child: const Text('Remover', style: TextStyle(color: Colors.red)), onPressed: () => Navigator.of(ctx).pop(true)),
                        ],
                      ),
                );
                if (confirm == true) {
                  await viewModel.removeBox(box.id!);
                }
              },
              tooltip: 'Remover',
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String colorString) {
    try {
      if (colorString.startsWith('#')) {
        return Color(int.parse(colorString.substring(1), radix: 16) + 0xFF000000);
      }
      switch (colorString.toLowerCase()) {
        case 'vermelho':
        case 'red':
          return Colors.red;
        case 'azul':
        case 'blue':
          return Colors.blue;
        case 'verde':
        case 'green':
          return Colors.green;
        case 'amarelo':
        case 'yellow':
          return Colors.yellow;
        case 'laranja':
        case 'orange':
          return Colors.orange;
        default:
          return Colors.grey;
      }
    } catch (_) {
      return Colors.grey;
    }
  }
}
