import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stray_bookstore_app/app/repositories/auth_repository.dart';
import 'package:stray_bookstore_app/app/screens/onboarding_screen/onboarding_view_model.dart';
import 'package:stray_bookstore_app/app/screens/onboarding_screen/components/onboarding_form.dart';
import 'package:stray_bookstore_app/app/core/inject.dart';
import 'package:stray_bookstore_app/app/core/router_manager.dart';
import 'package:stray_bookstore_app/app/shared/widgets/error_state_widget.dart';
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
    final model = context.watch<OnboardingViewModel>();

    void submit(BuildContext context) async {
      FocusScope.of(context).unfocus();
      if (isLogin) {
        await model.login(emailController.text, passwordController.text);
        if (model.state.isContent && model.errorMessage == null) {
          if (context.mounted) {
            RouterManager().navigateToHomeScreen(context);
          }
        }
      } else {
        await model.signup(emailController.text, passwordController.text);
        if (model.state.isContent && model.errorMessage == null) {
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
      body: Center(
        child: Column(
          children: [
            if (model.state.isError)
              ErrorStateWidget(
                onTryAgain: () async {
                  if (isLogin) {
                    await model.login(emailController.text, passwordController.text);
                  } else {
                    await model.signup(emailController.text, passwordController.text);
                  }
                },
              ),

            if (model.state.isContent || model.state.isLoading)
              Expanded(
                child: OnboardingForm(
                  emailController: emailController,
                  passwordController: passwordController,
                  title: isLogin ? 'Entrar' : 'Cadastrar',
                  buttonText: isLogin ? 'Entrar' : 'Cadastrar',
                  onSubmit: (context) => submit(context),
                  isLoading: model.state.isLoading,
                  errorMessage: model.errorMessage,
                  onSwitchMode: () {
                    setState(() {
                      isLogin = !isLogin;
                      model.clearError();
                    });
                  },
                  switchModeText: isLogin ? 'Não tem conta? Cadastre-se' : 'Já tem conta? Entrar',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
