import 'package:flutter/material.dart';
import 'package:stray_bookstore_app/app/dtos/friend_dto.dart';
import 'package:stray_bookstore_app/app/screens/friend_screen/components/friend_card.dart';
import 'package:stray_bookstore_app/app/screens/friend_screen/friend_view_model.dart';
import 'package:provider/provider.dart';
import 'add_friend_bottom_sheet.dart';

class FriendList extends StatelessWidget {
  final List<FriendDto> friends;
  const FriendList({super.key, required this.friends});

  void _editFriend(BuildContext context, FriendDto friend, FriendViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddFriendBottomSheet(viewModel: viewModel, initialFriend: friend),
    );
  }

  void _deleteFriend(BuildContext context, FriendDto friend, FriendViewModel viewModel) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Remover amigo'),
            content: Text('Tem certeza que deseja remover "${friend.name}"?'),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
              ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text('Remover')),
            ],
          ),
    );
    if (confirmed == true) {
      await viewModel.removeFriend(friend.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<FriendViewModel>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: friends.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final friend = friends[index];
          return FriendCard(friend: friend, onEdit: () => _editFriend(context, friend, viewModel), onDelete: () => _deleteFriend(context, friend, viewModel));
        },
      ),
    );
  }
}
