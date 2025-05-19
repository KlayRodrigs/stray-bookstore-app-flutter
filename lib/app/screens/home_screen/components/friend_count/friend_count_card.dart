import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stray_bookstore_app/app/core/inject.dart';
import 'package:stray_bookstore_app/app/core/router_manager.dart';
import 'package:stray_bookstore_app/app/repositories/friend_repository.dart';
import 'package:stray_bookstore_app/app/shared/styles/app_colors.dart';
import 'frind_count_view_model.dart';

class FriendCountCard extends StatefulWidget {
  const FriendCountCard({super.key});

  static Widget create() {
    return ChangeNotifierProvider<FriendCountViewModel>(
      create: (_) => FriendCountViewModel(repository: inject<FriendRepository>()),
      builder: (context, child) => const FriendCountCard(),
    );
  }

  @override
  State<FriendCountCard> createState() => _FriendCountCardState();
}

class _FriendCountCardState extends State<FriendCountCard> {
  final router = inject<RouterManager>();
  FriendCountViewModel? model;

  @override
  void initState() {
    super.initState();
    model = context.read();
    WidgetsBinding.instance.addPostFrameCallback((_) async => await model!.fetchFriendCount());
  }

  @override
  Widget build(BuildContext context) {
    model = context.watch();

    return InkWell(
      onTap: () => router.navigateToFriendScreen(context),
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: AppColors.primary.withValues(alpha: 0.85),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Amigos cadastrados', style: TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 18),
              if (model!.state.isLoading)
                const CircularProgressIndicator(color: AppColors.white)
              else if (model!.state.isError)
                const Icon(Icons.error_outline, color: AppColors.white, size: 36)
              else
                Text('${model!.count}', style: const TextStyle(color: AppColors.white, fontSize: 48, fontWeight: FontWeight.bold, letterSpacing: 2)),
            ],
          ),
        ),
      ),
    );
  }
}
