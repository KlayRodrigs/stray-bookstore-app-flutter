import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stray_bookstore_app/app/core/inject.dart';
import 'package:stray_bookstore_app/app/core/root_context_holder.dart';
import 'package:stray_bookstore_app/app/dtos/borrow_dto.dart';
import 'package:stray_bookstore_app/app/repositories/borrow_repository.dart';
import 'package:stray_bookstore_app/app/repositories/comic_repository.dart';
import 'package:stray_bookstore_app/app/repositories/friend_repository.dart';
import 'package:stray_bookstore_app/app/screens/borrow_screen/components/borrow_bottom_sheet/borrow_bottom_sheet_view_model.dart';
import 'borrow_bottom_sheet_header.dart';
import 'borrow_friend_dropdown.dart';
import 'borrow_comic_dropdown.dart';
import 'borrow_date_picker_field.dart';
import 'borrow_save_button.dart';

class AddBorrowBottomSheet extends StatefulWidget {
  final BorrowDto? initialBorrow;
  const AddBorrowBottomSheet({super.key, required this.onValue, this.initialBorrow});
  final void Function()? onValue;

  static Widget create({required List<BorrowDto> currentBorrows, required void Function()? onValue, BorrowDto? initialBorrow}) {
    return ChangeNotifierProvider(
      create:
          (_) => AddBorrowViewModel(
            borrowRepository: inject<BorrowRepository>(),
            friendRepository: inject<FriendRepository>(),
            comicRepository: inject<ComicRepository>(),
            currentBorrows: currentBorrows,
          ),
      child: AddBorrowBottomSheet(onValue: onValue, initialBorrow: initialBorrow),
    );
  }

  @override
  State<AddBorrowBottomSheet> createState() => _AddBorrowBottomSheetState();
}

class _AddBorrowBottomSheetState extends State<AddBorrowBottomSheet> {
  late RootContextHolder rootContext;
  final _formKey = GlobalKey<FormState>();

  AddBorrowViewModel? model;
  String? selectedFriendId;
  String? selectedComicId;
  DateTime? loanDate;
  DateTime? returnDate;

  @override
  void initState() {
    super.initState();
    rootContext = inject<RootContextHolder>(instanceName: "rootContext");
    model = context.read();
    if (widget.initialBorrow != null) {
      selectedFriendId = widget.initialBorrow!.friendId;
      selectedComicId = widget.initialBorrow!.comicId;
      loanDate = widget.initialBorrow!.loanDate;
      returnDate = widget.initialBorrow!.returnDate;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async => await model!.fetchData());
  }

  @override
  Widget build(BuildContext context) {
    model = context.watch();

    if (model!.state == AddBorrowState.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (model!.state == AddBorrowState.error) {
      return Center(child: Text(model!.errorMessage ?? 'Erro ao carregar dados'));
    }

    return Container(
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      padding: EdgeInsets.only(left: 24, right: 24, top: 32, bottom: MediaQuery.of(context).viewInsets.bottom + 24),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const BorrowBottomSheetHeader(),
              const SizedBox(height: 18),
              BorrowFriendDropdown(selectedFriendId: selectedFriendId, onChanged: (v) => setState(() => selectedFriendId = v), friends: model!.friends),
              const SizedBox(height: 12),
              BorrowComicDropdown(selectedComicId: selectedComicId, onChanged: (v) => setState(() => selectedComicId = v), comics: model!.comics),
              const SizedBox(height: 12),
              BorrowDatePickerField(
                label: 'Data de empréstimo',
                selectedDate: loanDate,
                onDateSelected: (date) => setState(() => loanDate = date),
                validator: () => loanDate == null ? 'Selecione a data de empréstimo' : null,
              ),
              const SizedBox(height: 12),
              BorrowDatePickerField(
                label: 'Data de devolução',
                selectedDate: returnDate,
                onDateSelected: (date) => setState(() => returnDate = date),
                firstDate: loanDate ?? DateTime.now(),
                validator: () => returnDate == null ? 'Selecione a data de devolução' : null,
              ),
              const SizedBox(height: 24),
              BorrowSaveButton(
                formKey: _formKey,
                onSave: () async {
                  if (widget.initialBorrow != null) {
                    await model!.updateBorrow(
                      context,
                      BorrowDto(id: widget.initialBorrow!.id, friendId: selectedFriendId!, comicId: selectedComicId!, loanDate: loanDate!, returnDate: returnDate!),
                    );
                  } else {
                    await model!.addBorrow(context, BorrowDto(friendId: selectedFriendId!, comicId: selectedComicId!, loanDate: loanDate!, returnDate: returnDate!));
                  }
                  if (widget.onValue != null) widget.onValue!();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
