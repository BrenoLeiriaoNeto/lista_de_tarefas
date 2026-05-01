import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/features/tasks/tasks_features.dart';

class TasksList extends StatelessWidget {
  const TasksList({super.key});

  List<Task> fetchTasks() => TaskRepository(TaskStorage()).getTasks();

  @override
  Widget build(BuildContext context) {
    final tasks = fetchTasks();

    return Scaffold(
      appBar: AppBar(title: const Text("Lista de tarefas")),
      body: tasks.isEmpty
          ? Center(child: NoTasks())
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CardTasks(task: tasks[index]),
                );
              },
            ),
    );
  }
}
