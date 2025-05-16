import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stray_bookstore_app/app/core/inject.dart';
import 'package:stray_bookstore_app/app/core/router_manager.dart';
import 'package:stray_bookstore_app/app/repositories/auth_repository.dart';
import 'package:stray_bookstore_app/app/screens/home_screen/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(create: (context) => HomeViewModel(authRepository: inject<AuthRepository>()), child: const HomeScreen());
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
    WidgetsBinding.instance.addPostFrameCallback((_) => model!.currentUser);
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
      body: Center(child: Text(model!.currentUser?.email ?? "")),
    );
  }
}
