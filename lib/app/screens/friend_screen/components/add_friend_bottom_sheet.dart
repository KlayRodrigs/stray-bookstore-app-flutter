import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stray_bookstore_app/app/dtos/friend_dto.dart';
import 'package:stray_bookstore_app/app/shared/styles/app_colors.dart';
import '../friend_view_model.dart';

class AddFriendBottomSheet extends StatefulWidget {
  final FriendViewModel viewModel;
  final FriendDto? initialFriend;
  const AddFriendBottomSheet({super.key, required this.viewModel, this.initialFriend});

  @override
  State<AddFriendBottomSheet> createState() => _AddFriendBottomSheetState();
}

class _AddFriendBottomSheetState extends State<AddFriendBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController motherNameController;
  late final TextEditingController phoneController;
  late final TextEditingController fromWhereController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialFriend?.name ?? '');
    motherNameController = TextEditingController(text: widget.initialFriend?.motherName ?? '');
    phoneController = TextEditingController(text: widget.initialFriend?.phone ?? '');
    fromWhereController = TextEditingController(text: widget.initialFriend?.fromWhere ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    motherNameController.dispose();
    phoneController.dispose();
    fromWhereController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      final isEditing = widget.initialFriend != null;
      final friend = FriendDto(
        id: widget.initialFriend?.id ?? '',
        name: nameController.text.trim(),
        motherName: motherNameController.text.trim(),
        phone: phoneController.text.trim(),
        fromWhere: fromWhereController.text.trim(),
      );
      if (isEditing) {
        await widget.viewModel.updateFriend(friend);
      } else {
        await widget.viewModel.addFriend(friend);
      }
      if (mounted) Navigator.of(context).pop();
      setState(() => isLoading = false);
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Remover amigo'),
            content: Text('Tem certeza que deseja remover este amigo?'),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
              ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text('Remover')),
            ],
          ),
    );
    if (confirmed == true) {
      await widget.viewModel.removeFriend(widget.initialFriend!.id);
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: BoxDecoration(color: theme.cardColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(widget.initialFriend != null ? 'Editar Amigo' : 'Cadastrar Amigo', style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome', prefixIcon: Icon(Icons.person)),
                validator: (v) => v == null || v.trim().isEmpty ? 'Informe o nome' : null,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: motherNameController,
                decoration: const InputDecoration(labelText: 'Nome da mãe', prefixIcon: Icon(Icons.woman)),
                validator: (v) => v == null || v.trim().isEmpty ? 'Informe o nome da mãe' : null,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Telefone', prefixIcon: Icon(Icons.phone)),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: fromWhereController,
                decoration: const InputDecoration(labelText: 'De onde conhece?', prefixIcon: Icon(Icons.location_on)),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: isLoading ? null : _save,
                icon:
                    isLoading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save, color: AppColors.white),
                label: Text(widget.initialFriend != null ? 'Salvar alterações' : 'Salvar', style: const TextStyle(color: AppColors.white)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              if (widget.initialFriend != null) ...[
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: isLoading ? null : _delete,
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text('Remover', style: TextStyle(color: Colors.red)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
