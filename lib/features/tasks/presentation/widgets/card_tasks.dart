import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/features/tasks/tasks_features.dart';

class CardTasks extends StatelessWidget {
  final Task task;
  const CardTasks({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.nome, style: TextStyle(fontSize: 18, fontWeight: .w300)),
            Text(
              task.dataHora.toIso8601String(),
              style: TextStyle(fontSize: 16),
            ),
            Text(task.localizacao.formatted, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
