import 'package:flutter/material.dart';
import 'package:stray_bookstore_app/app/core/app_colors.dart';
import 'package:provider/provider.dart';
import '../../core/inject.dart';
import '../../repositories/box_repository.dart';
import 'box_view_model.dart';
import 'components/add_box_bottom_sheet.dart';
import 'components/box_card.dart';

class BoxScreen extends StatefulWidget {
  const BoxScreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(create: (_) => BoxViewModel(repository: inject<BoxRepository>()), child: const BoxScreen());
  }

  @override
  State<BoxScreen> createState() => _BoxScreenState();
}

class _BoxScreenState extends State<BoxScreen> {
  BoxViewModel? model;

  @override
  void initState() {
    super.initState();
    model = context.read();
    WidgetsBinding.instance.addPostFrameCallback((_) async => await model!.fetchBoxes());
  }

  @override
  Widget build(BuildContext context) {
    model = context.watch();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Caixas'), backgroundColor: AppColors.teal85),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (model!.state.isLoading)
                SizedBox(height: _bodyHeight, child: const Center(child: CircularProgressIndicator(color: AppColors.orange)))
              else if (model!.state.isError)
                SizedBox(
                  height: _bodyHeight,
                  child: Center(
                    child: Card(
                      color: Colors.orange.withValues(alpha: 0.10),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(model!.errorMessage ?? 'Erro ao buscar caixas', style: const TextStyle(color: AppColors.orange)),
                      ),
                    ),
                  ),
                )
              else if (model!.boxes.isEmpty)
                SizedBox(
                  height: _bodyHeight,
                  child: Center(
                    child: Card(
                      color: Colors.orange.withValues(alpha: 0.10),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      child: const Padding(padding: EdgeInsets.all(24.0), child: Text('Nenhuma caixa cadastrada')),
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        'Você possui ${model!.boxes.length} caixa(s) cadastrada(s)',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                      const SizedBox(height: 16),
                      ...model!.boxes.map((box) => BoxCard(box: box, viewModel: model!, parentContext: context)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton:
          (!model!.state.isError)
              ? FloatingActionButton(
                backgroundColor: Colors.teal.withOpacity(0.85),
                onPressed:
                    () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => AddBoxBottomSheet(viewModel: model!),
                    ),
                tooltip: 'Cadastrar nova caixa',
                child: const Icon(Icons.add, color: Colors.white),
              )
              : null,
    );
  }

  double get _bodyHeight {
    final contextHeight = MediaQuery.of(context).size.height;
    return (contextHeight * 0.9) - kToolbarHeight;
  }
}
