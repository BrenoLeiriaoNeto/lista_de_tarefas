import 'package:flutter/material.dart';

class NoTasks extends StatelessWidget {
  const NoTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.warning_amber_outlined, size: 48, color: Colors.orange),
            SizedBox(height: 16),
            Text("Nenhuma tarefa cadastrada"),
          ],
        ),
      ),
    );
  }
}
