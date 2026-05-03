import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/features/tasks/tasks_features.dart';

class TaskUpdatePage extends StatelessWidget {
  final Task task;
  const TaskUpdatePage({super.key, required this.task});

  void onUpdate(Task oldTask, Task newTask) =>
      TaskRepository(TaskStorage()).updateTask(oldTask, newTask);

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: "Editar Tarefa",
      child: TaskUpdateForm(task: task, onUpdate: onUpdate),
    );
  }
}
