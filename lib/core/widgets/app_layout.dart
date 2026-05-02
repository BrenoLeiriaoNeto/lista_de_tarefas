import 'package:flutter/material.dart';

class AppLayout extends StatelessWidget {
  final String title;
  final Widget? floatingActionButton;
  final Widget child;
  const AppLayout({
    super.key,
    required this.title,
    this.floatingActionButton,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(16.0), child: child),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
