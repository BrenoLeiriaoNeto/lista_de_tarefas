import 'package:flutter/material.dart';

class AppLayout extends StatelessWidget {
  final String title;
  final Widget? floatingActionButton;
  final Widget child;
  final TextEditingController? controller;
  const AppLayout({
    super.key,
    required this.title,
    this.floatingActionButton,
    required this.child,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        bottom: controller == null
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: controller,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Pesquisar Tarefa...",
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: const Icon(Icons.search),
                      prefixIconColor: Colors.white,
                    ),
                  ),
                ),
              ),
      ),
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(16.0), child: child),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
