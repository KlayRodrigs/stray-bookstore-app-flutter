import 'package:flutter/material.dart';
import 'package:stray_bookstore_app/app/core/app_colors.dart';
import '../../../../../app/dtos/comic_dto.dart';
import '../comic_view_model.dart';
import 'add_comic_bottom_sheet.dart';

import '../../../dtos/box_dto.dart';

class ComicCard extends StatelessWidget {
  final ComicDto comic;
  final ComicViewModel viewModel;
  final BuildContext parentContext;
  final BoxDto? box;
  const ComicCard({super.key, required this.comic, required this.viewModel, required this.parentContext, this.box});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.menu_book, color: AppColors.orange),
        title: Text(comic.collection, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          """Edição: ${comic.editionNumber}\nData: ${comic.publishDate}${box != null ? '\nCaixa: Nº ${box!.boxNumber}, ${box!.color}' : '\nCaixa: não encontrada'}""",
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.orange),
              tooltip: 'Editar',
              onPressed:
                  () => showModalBottomSheet(
                    context: parentContext,
                    isScrollControlled: true,
                    backgroundColor: AppColors.transparent,
                    builder: (context) => AddComicBottomSheet(viewModel: viewModel, initialComic: comic),
                  ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.redAccent),
              tooltip: 'Remover',
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: parentContext,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Remover revista'),
                        content: const Text('Tem certeza que deseja remover esta revista?'),
                        actions: [
                          TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.of(context).pop(false)),
                          TextButton(child: const Text('Remover', style: TextStyle(color: AppColors.redAccent)), onPressed: () => Navigator.of(context).pop(true)),
                        ],
                      ),
                );
                if (confirm == true) await viewModel.removeComic(comic.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
