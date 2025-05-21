import 'package:flutter/material.dart';
import 'package:stray_bookstore_app/app/dtos/box_dto.dart';
import 'package:stray_bookstore_app/app/screens/borrow_screen/borrow_screen.dart';
import 'package:stray_bookstore_app/app/screens/comic_screen/comic_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:stray_bookstore_app/app/screens/box_screen/box_screen.dart';
import 'package:stray_bookstore_app/app/screens/friend_screen/friend_screen.dart';
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
  static final friendScreen = RouterProfile(name: "friend-screen", path: "friend-screen");
  static final comicScreen = RouterProfile(name: "comic-screen", path: "comic-screen");
  static final boxScreen = RouterProfile(name: "box-screen", path: "box-screen");
  static final borrowScreen = RouterProfile(name: "borrow-screen", path: "borrow-screen");

  final router = GoRouter(
    initialLocation: onboardingScreen.path,
    routes: [
      GoRoute(path: onboardingScreen.path, name: onboardingScreen.name, builder: (_, __) => OnboardingScreen.create()),
      GoRoute(
        path: homeScreen.path,
        name: homeScreen.name,
        builder: (_, __) {
          return HomeScreen.create();
        },
        routes: [
          GoRoute(path: friendScreen.path, name: friendScreen.name, builder: (_, __) => FriendScreen.create()),
          GoRoute(
            path: comicScreen.path,
            name: comicScreen.name,
            builder: (context, state) {
              final boxesFromHome = state.extra is Map ? (state.extra as Map)["boxesFromHome"] as List<BoxDto>? : null;
              return ComicScreen.create(boxesFromHome: boxesFromHome ?? []);
            },
          ),
          GoRoute(path: boxScreen.path, name: boxScreen.name, builder: (_, __) => BoxScreen.create()),
          GoRoute(path: borrowScreen.path, name: borrowScreen.name, builder: (_, __) => BorrowScreen.create()),
        ],
      ),
    ],
  );

  void navigateToOnboardingScreen(BuildContext context) {
    context.goNamed(onboardingScreen.name);
  }

  void navigateToHomeScreen(BuildContext context) {
    context.goNamed(homeScreen.name);
  }

  Future<void> navigateToFriendScreen(BuildContext context) async {
    if (context.mounted) await context.pushNamed(friendScreen.name);
  }

  Future<void> navigateToComicScreen(BuildContext context, List<BoxDto> boxesFromHome) async {
    if (context.mounted) await context.pushNamed(comicScreen.name, extra: {"boxesFromHome": boxesFromHome});
  }

  Future<void> navigateToBoxScreen(BuildContext context) async {
    if (context.mounted) await context.pushNamed(boxScreen.name);
  }

  Future<void> navigateToBorrowScreen(BuildContext context) async {
    if (context.mounted) await context.pushNamed(borrowScreen.name);
  }
}
