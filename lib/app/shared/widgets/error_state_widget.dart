import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stray_bookstore_app/app/shared/styles/app_colors.dart';

class ErrorStateWidget extends StatefulWidget {
  const ErrorStateWidget({super.key, required this.onTryAgain});
  final VoidCallback onTryAgain;

  @override
  State<ErrorStateWidget> createState() => _ErrorStateWidgetState();
}

class _ErrorStateWidgetState extends State<ErrorStateWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Lottie.asset('assets/lottie/error.json', frameRate: FrameRate.max, width: 300),
            const Spacer(),
            TextButton(
              onPressed: widget.onTryAgain,
              style: TextButton.styleFrom(foregroundColor: Colors.white, backgroundColor: AppColors.secondary, fixedSize: const Size(300, 48)),
              child: const Text("Tente novamente"),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
