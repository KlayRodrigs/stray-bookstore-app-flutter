import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stray_bookstore_app/app/core/inject.dart';
import 'package:stray_bookstore_app/app/repositories/friend_repository.dart';
import 'package:stray_bookstore_app/app/screens/friend_screen/components/friend_not_found.dart';
import 'package:stray_bookstore_app/app/screens/friend_screen/components/friend_error_state.dart';
import 'package:stray_bookstore_app/app/screens/friend_screen/components/add_friend_bottom_sheet.dart';
import 'package:stray_bookstore_app/app/screens/friend_screen/components/friend_list.dart';
import 'package:stray_bookstore_app/app/shared/widgets/error_state_widget.dart';
import 'friend_view_model.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(create: (_) => FriendViewModel(repository: inject<FriendRepository>()), child: const FriendScreen());
  }

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  FriendViewModel? model;

  @override
  void initState() {
    super.initState();
    model = context.read();
    WidgetsBinding.instance.addPostFrameCallback((_) async => await model!.fetchFriends());
  }

  @override
  Widget build(BuildContext context) {
    model = context.watch();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        title: const Text('Amigos'),
        backgroundColor: Colors.blueGrey.withValues(alpha: 0.85),
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
      ),
      body: Column(
        children: [
          if (model!.state.isError)
            ErrorStateWidget(
              onTryAgain: () async {
                await model!.fetchFriends();
              },
            ),

          if (model!.state.isContent)
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (model!.state.isLoading)
                      SizedBox(height: _bodyHeight, child: const Center(child: CircularProgressIndicator(color: Colors.blueGrey)))
                    else if (model!.state.isError)
                      SizedBox(
                        height: _bodyHeight,
                        child: Center(
                          child: Card(
                            color: Colors.blueGrey.withValues(alpha: 0.10),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: FriendErrorState(message: model!.errorMessage, onRetry: () => model!.fetchFriends()),
                            ),
                          ),
                        ),
                      )
                    else if (model!.friends.isEmpty)
                      SizedBox(
                        height: _bodyHeight,
                        child: Center(
                          child: Card(
                            color: Colors.blueGrey.withValues(alpha: 0.10),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            child: const Padding(padding: EdgeInsets.all(24.0), child: FriendNotFound()),
                          ),
                        ),
                      )
                    else
                      FriendList(friends: model!.friends),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton:
          (!model!.state.isError)
              ? FloatingActionButton(
                backgroundColor: Colors.blueGrey.withValues(alpha: 0.85),
                onPressed:
                    () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => AddFriendBottomSheet(onSave: model!.addFriend),
                    ),
                tooltip: 'Cadastrar novo amigo',
                child: const Icon(Icons.add, color: Colors.white),
              )
              : null,
    );
  }

  double get _bodyHeight {
    final contextHeight = MediaQuery.of(context).size.height;
    return (contextHeight * 0.9) - kToolbarHeight;
  }
}
