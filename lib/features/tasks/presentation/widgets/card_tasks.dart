import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lista_de_tarefas/features/tasks/tasks_features.dart';

class CardTasks extends StatelessWidget {
  final Task task;
  const CardTasks({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tarefa: ${task.nome}",
              style: TextStyle(fontSize: 18, fontWeight: .w500),
            ),
            Text(
              "Data: ${DateFormat("dd/MM/yyyy HH:mm", "pt_BR").format(task.dataHora)}",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "Localização: ${task.localizacao.formatted}",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
