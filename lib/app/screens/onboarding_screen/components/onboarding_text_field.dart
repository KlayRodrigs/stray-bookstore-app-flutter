import 'package:flutter/material.dart';
import 'package:stray_bookstore_app/app/shared/styles/app_colors.dart';

class OnboardingTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool enabled;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? icon;

  const OnboardingTextField({
    super.key,
    required this.controller,
    required this.label,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, color: Theme.of(context).primaryColor) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: enabled ? AppColors.white : AppColors.grey,
      ),
    );
  }
}
