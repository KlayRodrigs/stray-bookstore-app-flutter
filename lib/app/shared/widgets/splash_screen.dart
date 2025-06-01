import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stray_bookstore_app/app/shared/styles/app_colors.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback? onFinish;
  const SplashScreen({super.key, this.onFinish});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int pawCount = 0;
  Timer? pawTimer;

  @override
  void initState() {
    super.initState();
    pawTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() => pawCount++);
      if (pawCount >= 3) {
        pawTimer?.cancel();
        Future.delayed(const Duration(milliseconds: 500), () {
          if (widget.onFinish != null) widget.onFinish!();
        });
      }
    });
  }

  @override
  void dispose() {
    pawTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(24), child: Image.asset('assets/images/logo.png', height: 120, fit: BoxFit.contain)),
            const SizedBox(height: 32),
            SizedBox(
              height: 36,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pawCount,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Transform.rotate(angle: index.isEven ? -0.3 : 0.3, child: Icon(Icons.pets, size: 36, color: AppColors.primary)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
