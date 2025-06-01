import 'package:flutter/material.dart';
import 'package:stray_bookstore_app/app/shared/styles/app_colors.dart';

class OnboardingButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const OnboardingButton({super.key, required this.text, required this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColors.primary), fixedSize: WidgetStatePropertyAll(Size(double.infinity, 48))),
        onPressed: onPressed,
        child:
            isLoading
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white))
                : Text(text, style: const TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
