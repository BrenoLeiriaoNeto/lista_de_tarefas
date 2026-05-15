import 'package:flutter/material.dart';

extension ContextX on BuildContext {
  void safeSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }
}
