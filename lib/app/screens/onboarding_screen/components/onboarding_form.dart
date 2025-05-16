import 'package:flutter/material.dart';
import 'onboarding_text_field.dart';
import 'onboarding_button.dart';
import 'package:stray_bookstore_app/app/shared/styles/app_colors.dart';

class OnboardingForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String title;
  final String buttonText;
  final void Function(BuildContext)? onSubmit;
  final bool isLoading;
  final String? errorMessage;
  final void Function()? onSwitchMode;
  final String switchModeText;

  const OnboardingForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.title,
    required this.buttonText,
    required this.onSubmit,
    required this.isLoading,
    this.errorMessage,
    this.onSwitchMode,
    required this.switchModeText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Column(
                    children: [
                      ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.asset('assets/images/logo.png', height: 90, fit: BoxFit.contain)),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                const SizedBox(height: 32),
                OnboardingTextField(controller: emailController, label: 'Email', enabled: !isLoading, keyboardType: TextInputType.emailAddress, icon: Icons.email),
                const SizedBox(height: 16),
                OnboardingTextField(controller: passwordController, label: 'Senha', enabled: !isLoading, obscureText: true, icon: Icons.lock),
                const SizedBox(height: 24),
                if (errorMessage != null) Padding(padding: const EdgeInsets.only(bottom: 16), child: Text(errorMessage!, style: const TextStyle(color: Colors.red))),
                OnboardingButton(text: buttonText, onPressed: isLoading ? null : () => onSubmit?.call(context), isLoading: isLoading),
                const SizedBox(height: 20),
                if (onSwitchMode != null)
                  TextButton(
                    onPressed: isLoading ? null : () => onSwitchMode?.call(),
                    style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColors.primary)),
                    child: Text(switchModeText, style: const TextStyle(color: AppColors.white, fontSize: 16)),

                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
