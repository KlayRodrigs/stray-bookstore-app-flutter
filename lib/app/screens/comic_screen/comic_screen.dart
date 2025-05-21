import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stray_bookstore_app/app/core/inject.dart';
import 'package:stray_bookstore_app/app/repositories/comic_repository.dart';
import 'package:stray_bookstore_app/app/screens/comic_screen/comic_view_model.dart';
import 'package:stray_bookstore_app/app/screens/comic_screen/components/comic_error_state.dart';
import 'package:stray_bookstore_app/app/screens/comic_screen/components/comic_not_found.dart';
import 'package:stray_bookstore_app/app/screens/comic_screen/components/add_comic_bottom_sheet.dart';
import 'package:stray_bookstore_app/app/screens/comic_screen/components/comic_card.dart';
import 'package:stray_bookstore_app/app/dtos/box_dto.dart';
import 'package:stray_bookstore_app/app/shared/styles/app_colors.dart';

class ComicScreen extends StatefulWidget {
  final List<BoxDto> boxesFromHome;
  const ComicScreen({super.key, required this.boxesFromHome});

  static Widget create({required List<BoxDto> boxesFromHome}) {
    return ChangeNotifierProvider(create: (_) => ComicViewModel(repository: inject<ComicRepository>()), child: ComicScreen(boxesFromHome: boxesFromHome));
  }

  @override
  State<ComicScreen> createState() => _ComicScreenState();
}

class _ComicScreenState extends State<ComicScreen> {
  ComicViewModel? model;

  @override
  void initState() {
    super.initState();
    model = context.read();
    WidgetsBinding.instance.addPostFrameCallback((_) async => await model!.fetchComics());
  }

  @override
  Widget build(BuildContext context) {
    model = context.watch();
    final boxes = widget.boxesFromHome;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(title: const Text('Revistas'), backgroundColor: AppColors.orange400),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (model!.state.isLoading)
              SizedBox(height: _bodyHeight, child: const Center(child: CircularProgressIndicator(color: AppColors.orange)))
            else if (model!.state.isError)
              SizedBox(height: _bodyHeight, child: Center(child: ComicErrorState(message: model!.errorMessage, onRetry: () => model!.fetchComics())))
            else if (model!.comics.isEmpty)
              SizedBox(height: _bodyHeight, child: const Center(child: ComicNotFound()))
            else
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      'Você possui ${model!.comics.length} revista(s) cadastrada(s)',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.orange),
                    ),
                    const SizedBox(height: 16),
                    ...model!.comics.map(
                      (comic) => ComicCard(
                        comic: comic,
                        viewModel: model!,
                        parentContext: context,
                        box: boxes.firstWhere((b) => b.id == comic.boxId, orElse: () => BoxDto(label: 'Não encontrada', boxNumber: 0, color: '', id: null)),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),

      floatingActionButton:
          (!model!.state.isError)
              ? FloatingActionButton(
                backgroundColor: AppColors.orange400,
                onPressed:
                    () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: AppColors.transparent,
                      builder: (context) => AddComicBottomSheet(viewModel: model!),
                    ),
                tooltip: 'Cadastrar nova revista',
                child: const Icon(Icons.add, color: AppColors.white),
              )
              : null,
    );
  }

  double get _bodyHeight {
    final contextHeight = MediaQuery.of(context).size.height;
    return (contextHeight * 0.9) - kToolbarHeight;
  }
}
