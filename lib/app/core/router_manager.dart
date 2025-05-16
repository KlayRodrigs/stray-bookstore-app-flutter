import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:stray_bookstore_app/app/screens/home_screen/home_screen.dart';
import 'package:stray_bookstore_app/app/screens/onboarding_screen/onboarding_screen.dart';

class RouterProfile {
  final String name;
  final String path;

  RouterProfile({required this.name, required this.path});
}

class RouterManager {
  static final onboardingScreen = RouterProfile(name: "onboarding-screen", path: "/onboarding-screen");
  static final homeScreen = RouterProfile(name: "home-screen", path: "/home-screen");

  final router = GoRouter(
    initialLocation: onboardingScreen.path,
    routes: [
      GoRoute(path: onboardingScreen.path, name: onboardingScreen.name, builder: (_, __) => OnboardingScreen.create()),
      GoRoute(path: homeScreen.path, name: homeScreen.name, builder: (_, __) => HomeScreen.create()),
    ],
  );

  void navigateToOnboardingScreen(BuildContext context) {
    context.goNamed(onboardingScreen.name);
  }

  void navigateToHomeScreen(BuildContext context) {
    context.goNamed(homeScreen.name);
  }
}
