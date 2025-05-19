import 'package:flutter/material.dart';

class DashboardCountCard extends StatelessWidget {
  final Color color;
  final String title;
  final int count;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isError;
  final double? fontSize;
  final double? iconSize;
  final IconData? icon;
  final double? width;

  const DashboardCountCard({
    super.key,
    required this.color,
    required this.title,
    required this.count,
    required this.isLoading,
    required this.isError,
    this.onTap,
    this.fontSize,
    this.iconSize,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        elevation: 6,
        shadowColor: color.withValues(alpha: 0.28),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: color,
        child: Container(
          width: width ?? double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null)
                Container(
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Icon(icon, color: Colors.white, size: iconSize ?? 32),
                ),
              Text(
                title,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.95), fontSize: fontSize ?? 17, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              if (isLoading)
                const Padding(padding: EdgeInsets.symmetric(vertical: 8.0), child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
              else if (isError)
                Icon(Icons.error_outline, color: Colors.white, size: iconSize ?? 34)
              else
                Text(
                  '$count',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: (fontSize ?? 38),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    shadows: [Shadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 6, offset: const Offset(0, 2))],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
