import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

void showAdaptativeSnackbar({
  required BuildContext context,
  required String title,
  required String message,
  required Color color,
  required IconData icon,
  Duration duration = const Duration(seconds: 3),
}) {
  Flushbar(
    margin: const EdgeInsets.all(16),
    borderRadius: BorderRadius.circular(12),
    backgroundColor: color,
    duration: duration,
    icon: Icon(icon, color: Colors.white),
    titleText: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
    messageText: Text(message, style: const TextStyle(color: Colors.white)),
    flushbarPosition: FlushbarPosition.TOP,
    animationDuration: const Duration(milliseconds: 500),
  ).show(context);
}
