import 'package:flutter/material.dart';

class ComicErrorState extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;
  const ComicErrorState({super.key, this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, size: 64, color: Colors.orange.shade300),
        const SizedBox(height: 16),
        Text(message ?? 'Erro ao carregar revistas.', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.orange.shade700)),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          icon: const Icon(Icons.refresh, color: Colors.white),
          label: const Text('Tentar novamente', style: TextStyle(color: Colors.white)),
          onPressed: onRetry ?? () => Navigator.of(context).maybePop(),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade200),
        ),
      ],
    );
  }
}
