import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stray_bookstore_app/app/core/inject.dart';
import 'package:stray_bookstore_app/app/repositories/comic_repository.dart';
import 'package:stray_bookstore_app/app/repositories/friend_repository.dart';
import 'package:stray_bookstore_app/app/dtos/friend_dto.dart';
import 'package:stray_bookstore_app/app/screens/borrow_screen/borrow_view_model.dart';
import 'package:stray_bookstore_app/app/repositories/borrow_repository.dart';
import 'package:stray_bookstore_app/app/screens/borrow_screen/components/borrow_bottom_sheet/borrow_bottom_sheet.dart';
import 'package:stray_bookstore_app/app/screens/borrow_screen/components/confirm_delete_dialog.dart';
import 'package:stray_bookstore_app/app/shared/widgets/error_state_widget.dart';

class BorrowScreen extends StatefulWidget {
  const BorrowScreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => BorrowViewModel(repository: inject<BorrowRepository>(), friendRepository: inject<FriendRepository>(), comicRepository: inject<ComicRepository>()),
      child: const BorrowScreen(),
    );
  }

  @override
  State<BorrowScreen> createState() => _BorrowScreenState();
}

class _BorrowScreenState extends State<BorrowScreen> {
  BorrowViewModel? model;

  @override
  void initState() {
    super.initState();
    model = context.read();
    WidgetsBinding.instance.addPostFrameCallback((_) async => await model!.fetchBorrows());
  }

  @override
  Widget build(BuildContext context) {
    model = context.watch();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        title: const Text('Empréstimos'),
        backgroundColor: Colors.deepPurple.withValues(alpha: 0.85),
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
      ),
      body: Column(
        children: [
          if (model!.state.isError)
            ErrorStateWidget(
              onTryAgain: () async {
                await model!.fetchBorrows();
              },
            ),

          if (model!.state.isContent)
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (model!.state.isLoading)
                      SizedBox(height: _bodyHeight, child: const Center(child: CircularProgressIndicator(color: Colors.deepPurple)))
                    else if (model!.state.isError)
                      SizedBox(
                        height: _bodyHeight,
                        child: Center(
                          child: Card(
                            color: Colors.deepPurple.withValues(alpha: 0.10),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Text(model!.errorMessage ?? 'Erro ao buscar empréstimos', style: const TextStyle(color: Colors.deepPurple)),
                            ),
                          ),
                        ),
                      )
                    else if (model!.borrows.isEmpty)
                      SizedBox(
                        height: _bodyHeight,
                        child: Center(
                          child: Card(
                            color: Colors.deepPurple.withValues(alpha: 0.10),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            child: const Padding(padding: EdgeInsets.all(24.0), child: Text('Nenhum empréstimo cadastrado')),
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Text(
                              'Você possui ${model!.borrows.length} empréstimo(s) cadastrado(s)',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                            ),
                            const SizedBox(height: 16),
                            ...model!.borrows.map(
                              (borrow) => Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  leading: const Icon(Icons.assignment_returned, color: Colors.deepPurple),
                                  title: Text(
                                    'Amigo: ${model!.friends.firstWhere((friend) => friend.id == borrow.friendId, orElse: () => FriendDto(id: '', name: 'Amigo removido', motherName: '', phone: '', fromWhere: '')).name}',
                                    style: const TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                  subtitle: Text(
                                    'Revista: ${model!.comics.firstWhere((comic) => comic.id == borrow.comicId).collection}\nEmpréstimo: ${borrow.loanDate.day}/${borrow.loanDate.month}/${borrow.loanDate.year}\nDevolução: ${borrow.returnDate.day}/${borrow.returnDate.month}/${borrow.returnDate.year}',
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.deepPurple),
                                        tooltip: 'Editar empréstimo',
                                        onPressed: () async {
                                          await showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return AddBorrowBottomSheet.create(
                                                currentBorrows: model!.borrows,
                                                onValue: () async {
                                                  await model!.fetchBorrows();
                                                  if (context.mounted) context.pop();
                                                },
                                                initialBorrow: borrow,
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                                        onPressed: () async {
                                          final confirmed = await showConfirmDeleteDialog(context, message: 'Deseja remover este empréstimo?');
                                          if (confirmed == true) {
                                            await model!.removeBorrow(borrow.id!);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton:
          (!model!.state.isError)
              ? FloatingActionButton(
                backgroundColor: Colors.deepPurple.withValues(alpha: 0.85),
                onPressed: () async {
                  await showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return AddBorrowBottomSheet.create(
                        currentBorrows: model!.borrows,
                        onValue: () async {
                          await model!.fetchBorrows();
                          if (context.mounted) context.pop();
                        },
                      );
                    },
                  );
                },
                tooltip: 'Cadastrar novo empréstimo',
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
