import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/features/tasks/tasks_features.dart';

class TaskCreatePage extends StatelessWidget {
  const TaskCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    void onSubmit(Task task) {
      TaskRepository(TaskStorage()).addTask(task);
      context.safeSnackBar("Tarefa criada!");
      Navigator.pop(context, true);
    }

    return AppLayout(
      title: "Nova Tarefa",
      child: TaskForm(onSubmit: onSubmit),
    );
  }
}
