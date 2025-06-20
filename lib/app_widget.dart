import 'package:flutter/material.dart';
import 'package:stray_bookstore_app/app/core/inject.dart';
import 'package:stray_bookstore_app/app/core/root_context_holder.dart';
import 'package:stray_bookstore_app/app/core/router_manager.dart';

class AppWidget extends StatelessWidget {
  AppWidget({super.key});
  final router = inject<RouterManager>().router;

  @override
  Widget build(BuildContext context) {
    inject<RootContextHolder>(instanceName: "rootContext").context = context;

    return MaterialApp.router(routerConfig: router, title: 'Stray Bookstore', debugShowCheckedModeBanner: false);
  }
}
