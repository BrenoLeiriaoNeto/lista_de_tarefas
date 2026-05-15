import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/features/tasks/tasks_features.dart';

class TasksList extends StatelessWidget {
  final List<Task> tasks;
  final VoidCallback? onDelete;
  const TasksList({super.key, required this.tasks, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty
        ? Center(child: NoTasks())
        : ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CardTasks(task: tasks[index], onDelete: onDelete),
              );
            },
          );
  }
}
