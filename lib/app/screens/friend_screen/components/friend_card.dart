import 'package:flutter/material.dart';
import 'package:stray_bookstore_app/app/dtos/friend_dto.dart';
import 'package:stray_bookstore_app/app/shared/styles/app_colors.dart';

class FriendCard extends StatelessWidget {
  final FriendDto friend;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  const FriendCard({super.key, required this.friend, required this.onDelete, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Colors.blueGrey.withValues(alpha: 0.85),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Text(friend.name.isNotEmpty ? friend.name[0].toUpperCase() : '?', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(friend.name.isNotEmpty ? friend.name : '(Sem nome)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  if (friend.motherName.isNotEmpty)
                    Padding(padding: const EdgeInsets.only(top: 4), child: Text('Mãe: ${friend.motherName}', style: const TextStyle(fontSize: 14))),
                  if (friend.phone.isNotEmpty)
                    Padding(padding: const EdgeInsets.only(top: 2), child: Text('Telefone: ${friend.phone}', style: const TextStyle(fontSize: 14))),
                  if (friend.fromWhere.isNotEmpty)
                    Padding(padding: const EdgeInsets.only(top: 2), child: Text('De onde: ${friend.fromWhere}', style: const TextStyle(fontSize: 14))),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(icon: const Icon(Icons.edit, color: AppColors.white), tooltip: 'Editar', onPressed: onEdit),
                IconButton(icon: const Icon(Icons.delete, color: AppColors.dangerColor), tooltip: 'Remover', onPressed: onDelete),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
