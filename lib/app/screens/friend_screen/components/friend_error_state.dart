import 'package:flutter/material.dart';

class FriendErrorState extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;
  const FriendErrorState({super.key, this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Text(message ?? 'Ocorreu um erro ao carregar os amigos.', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.red.shade700)),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text('Tentar novamente', style: TextStyle(color: Colors.white)),
            onPressed: onRetry ?? () => Navigator.of(context).maybePop(),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade200),
          ),
        ],
      ),
    );
  }
}
