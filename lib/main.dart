import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stray_bookstore_app/app/core/inject.dart';
import 'package:stray_bookstore_app/app_widget.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  setup();
  await inject.allReady();

  runApp(AppWidget());
}
