import 'package:flutter/material.dart';
import 'package:stray_bookstore_app/app/shared/styles/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:stray_bookstore_app/app/screens/comic_screen/comic_view_model.dart';
import 'package:stray_bookstore_app/app/dtos/comic_dto.dart';
import 'package:stray_bookstore_app/app/repositories/box_repository.dart';
import 'package:stray_bookstore_app/app/dtos/box_dto.dart';

class AddComicBottomSheet extends StatefulWidget {
  final ComicViewModel viewModel;
  final ComicDto? initialComic;
  const AddComicBottomSheet({super.key, required this.viewModel, this.initialComic});

  @override
  State<AddComicBottomSheet> createState() => _AddComicBottomSheetState();
}

class _AddComicBottomSheetState extends State<AddComicBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  String collection = '';
  String? boxId;
  String editionNumber = '';
  String publishDate = '';
  bool loading = false;
  List<BoxDto> boxes = [];
  bool loadingBoxes = true;

  @override
  void initState() {
    super.initState();
    final comic = widget.initialComic;
    if (comic != null) {
      collection = comic.collection;
      boxId = comic.boxId;
      editionNumber = comic.editionNumber.toString();
      publishDate = comic.publishDate;
    }
    _loadBoxes();
  }

  Future<void> _loadBoxes() async {
    final repo = BoxRepository();
    final fetched = await repo.getBoxes();
    setState(() {
      boxes = fetched;
      loadingBoxes = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
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
                Text(widget.initialComic == null ? 'Cadastrar nova revista' : 'Editar revista', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop()),
              ],
            ),
            const SizedBox(height: 18),
            TextFormField(
              initialValue: collection,
              decoration: const InputDecoration(labelText: 'Coleção', border: OutlineInputBorder()),
              onChanged: (v) => collection = v,
              validator: (v) => (v == null || v.isEmpty) ? 'Informe o nome da coleção' : null,
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: boxes.any((box) => box.id == boxId) ? boxId : null,
              decoration: const InputDecoration(labelText: 'Caixa', border: OutlineInputBorder()),
              items: boxes.map((box) => DropdownMenuItem<String>(value: box.id, child: Text('${box.label} (Nº ${box.boxNumber}, ${box.color})'))).toList(),
              onChanged: (v) => setState(() => boxId = v),
              validator: (v) => (v == null || v.isEmpty) ? 'Selecione a caixa' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: editionNumber,
              decoration: const InputDecoration(labelText: 'Edição', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (v) => editionNumber = v,
              validator: (v) => (v == null || v.isEmpty) ? 'Informe a edição' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: publishDate,
              decoration: const InputDecoration(labelText: 'Data de publicação', border: OutlineInputBorder()),
              onChanged: (v) => publishDate = v,
              validator: (v) => (v == null || v.isEmpty) ? 'Informe a data de publicação' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed:
                  loading
                      ? null
                      : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => loading = true);
                          if (widget.initialComic == null) {
                            await widget.viewModel.addComic(
                              ComicDto(id: '', boxId: boxId ?? '', collection: collection, editionNumber: int.tryParse(editionNumber) ?? 0, publishDate: publishDate),
                            );
                          } else {
                            await widget.viewModel.updateComic(
                              ComicDto(
                                id: widget.initialComic!.id,
                                boxId: boxId ?? '',
                                collection: collection,
                                editionNumber: int.tryParse(editionNumber) ?? 0,
                                publishDate: publishDate,
                              ),
                            );
                          }
                          setState(() => loading = false);
                          if (context.mounted) Navigator.of(context).pop();
                        }
                      },
              child:
                  loading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2))
                      : Text(widget.initialComic == null ? 'Cadastrar' : 'Salvar', style: const TextStyle(color: AppColors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
