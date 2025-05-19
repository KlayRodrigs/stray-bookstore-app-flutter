import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stray_bookstore_app/app/repositories/auth_repository.dart';
import 'package:stray_bookstore_app/app/screens/onboarding_screen/onboarding_view_model.dart';
import 'package:stray_bookstore_app/app/screens/onboarding_screen/components/onboarding_form.dart';
import 'package:stray_bookstore_app/app/shared/styles/app_colors.dart';
import 'package:stray_bookstore_app/app/core/inject.dart';
import 'package:stray_bookstore_app/app/core/router_manager.dart';
import 'package:stray_bookstore_app/app/shared/widgets/splash_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(create: (_) => OnboardingViewModel(authRepository: inject<AuthRepository>()), child: const OnboardingScreen());
  }

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool isLogin = true;
  final emailController = TextEditingController(text: "klayrodrigsdev@gmail.com");
  final passwordController = TextEditingController(text: "Gabriel123@");
  bool showSplash = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() => showSplash = true);
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OnboardingViewModel>();

    void submit(BuildContext context) async {
      FocusScope.of(context).unfocus();
      if (isLogin) {
        await viewModel.login(emailController.text, passwordController.text);
        if (viewModel.state.isContent && viewModel.errorMessage == null) {
          if (context.mounted) {
            RouterManager().navigateToHomeScreen(context);
          }
        }
      } else {
        await viewModel.signup(emailController.text, passwordController.text);
        if (viewModel.state.isContent && viewModel.errorMessage == null) {
          setState(() => isLogin = true);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cadastro realizado com sucesso!')));
          }
        }
      }
    }

    if (showSplash) {
      return SplashScreen(onFinish: () => setState(() => showSplash = false));
    }
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.primary, AppColors.secondary])),
        child: Center(
          child: OnboardingForm(
            emailController: emailController,
            passwordController: passwordController,
            title: isLogin ? 'Entrar' : 'Cadastrar',
            buttonText: isLogin ? 'Entrar' : 'Cadastrar',
            onSubmit: (context) => submit(context),
            isLoading: viewModel.state.isLoading,
            errorMessage: viewModel.errorMessage,
            onSwitchMode: () {
              setState(() {
                isLogin = !isLogin;
                viewModel.clearError();
              });
            },
            switchModeText: isLogin ? 'Não tem conta? Cadastre-se' : 'Já tem conta? Entrar',
          ),
        ),
      ),
    );
  }
}
