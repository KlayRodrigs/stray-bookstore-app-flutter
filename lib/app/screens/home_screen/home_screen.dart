import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stray_bookstore_app/app/core/inject.dart';
import 'package:stray_bookstore_app/app/core/router_manager.dart';
import 'package:stray_bookstore_app/app/repositories/auth_repository.dart';
import 'package:stray_bookstore_app/app/repositories/borrow_repository.dart';
import 'package:stray_bookstore_app/app/repositories/box_repository.dart';
import 'package:stray_bookstore_app/app/repositories/comic_repository.dart';
import 'package:stray_bookstore_app/app/repositories/friend_repository.dart';
import 'package:stray_bookstore_app/app/screens/home_screen/components/dashboard_count_card.dart';
import 'package:stray_bookstore_app/app/screens/home_screen/home_view_model.dart';
import 'package:stray_bookstore_app/app/shared/widgets/error_state_widget.dart';

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
            borrowRepository: inject<BorrowRepository>(),
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      model!.currentUser;
      await model!.fetchAllData();
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
            onPressed: () {
              model!.logout();
              if (context.mounted) router.navigateToOnboardingScreen(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (model!.state.isError)
              ErrorStateWidget(
                onTryAgain: () async {
                  await model!.fetchAllData();
                },
              ),
            if (model!.state.isContent)
              Column(
                children: [
                  DashboardCountCard(
                    color: Colors.blueGrey.withValues(alpha: 0.85),
                    title: 'Amigos cadastrados',
                    icon: Icons.people,
                    onTap: () async {
                      await router.navigateToFriendScreen(context);
                      await model!.fetchFriendCount();
                      setState(() {});
                    },
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
                        onTap: () async {
                          await router.navigateToComicScreen(context, model!.boxes);
                          await model!.fetchComicCount();
                          setState(() {});
                        },
                        count: model!.comicCount,
                        isLoading: model!.state.isLoading,
                        isError: model!.state.isError,
                      ),
                      DashboardCountCard(
                        color: Colors.teal.withValues(alpha: 0.85),
                        title: 'Caixas cadastradas',
                        width: 180,
                        icon: Icons.storage,
                        onTap: () async {
                          await router.navigateToBoxScreen(context);
                          await model!.fetchBoxCount();
                          setState(() {});
                        },
                        count: model!.boxCount,
                        isLoading: model!.state.isLoading,
                        isError: model!.state.isError,
                      ),
                    ],
                  ),
                  DashboardCountCard(
                    color: Colors.deepPurple.withValues(alpha: 0.85),
                    title: 'Empréstimos cadastrados',
                    icon: Icons.assignment_returned,
                    onTap: () async {
                      await router.navigateToBorrowScreen(context);
                      await model!.fetchBorrowCount();
                      setState(() {});
                    },
                    count: model!.borrowCount,
                    isLoading: model!.state.isLoading,
                    isError: model!.state.isError,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
