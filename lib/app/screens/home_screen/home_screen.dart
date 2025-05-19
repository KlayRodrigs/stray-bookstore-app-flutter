import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stray_bookstore_app/app/core/inject.dart';
import 'package:stray_bookstore_app/app/core/router_manager.dart';
import 'package:stray_bookstore_app/app/repositories/auth_repository.dart';
import 'package:stray_bookstore_app/app/repositories/box_repository.dart';
import 'package:stray_bookstore_app/app/repositories/comic_repository.dart';
import 'package:stray_bookstore_app/app/repositories/friend_repository.dart';
import 'package:stray_bookstore_app/app/screens/home_screen/components/dashboard_count_card.dart';
import 'package:stray_bookstore_app/app/screens/home_screen/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create:
          (context) => HomeViewModel(
            authRepository: inject<AuthRepository>(),
            friendRepository: inject<FriendRepository>(),
            comicRepository: inject<ComicRepository>(),
            boxRepository: inject<BoxRepository>(),
          ),
      child: const HomeScreen(),
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final router = inject<RouterManager>();
  HomeViewModel? model;

  @override
  void initState() {
    super.initState();
    model = context.read();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model!.currentUser;
      model!.fetchFriendCount();
      model!.fetchComicCount();
      model!.fetchBoxCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    model = context.watch();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stray Bookstore"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            tooltip: 'Logout',
            onPressed: () async {
              await model!.logout();
              if (context.mounted) router.navigateToOnboardingScreen(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Center(child: Text(model!.currentUser?.email ?? "")),
          DashboardCountCard(
            color: Colors.blueGrey.withValues(alpha: 0.85),
            title: 'Amigos cadastrados',
            icon: Icons.people,
            onTap: () => router.navigateToFriendScreen(context),
            count: model!.friendCount,
            isLoading: model!.state.isLoading,
            isError: model!.state.isError,
          ),
          Row(
            children: [
              DashboardCountCard(
                color: Colors.orange.withValues(alpha: 0.85),
                title: 'Revistas cadastradas',
                width: 180,
                icon: Icons.menu_book,
                onTap: () => router.navigateToComicScreen(context, model!.boxes),
                count: model!.comicCount,
                isLoading: model!.state.isLoading,
                isError: model!.state.isError,
              ),
              DashboardCountCard(
                color: Colors.teal.withValues(alpha: 0.85),
                title: 'Caixas cadastradas',
                width: 180,
                icon: Icons.storage,
                onTap: () => router.navigateToBoxScreen(context),
                count: model!.boxCount,
                isLoading: model!.state.isLoading,
                isError: model!.state.isError,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
