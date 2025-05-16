import 'package:flutter/material.dart';

mixin SafeNotifierMixin on ChangeNotifier {
  bool _mounted = true;

  void notify() {
    if (_mounted) notifyListeners();
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}
