import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/features/tasks/tasks_features.dart';

class TasksListPage extends StatefulWidget {
  const TasksListPage({super.key});

  @override
  State<TasksListPage> createState() => _TasksListPageState();
}

class _TasksListPageState extends State<TasksListPage> {
  List<Task> fetchTasks() => TaskRepository(TaskStorage()).getTasks();

  @override
  Widget build(BuildContext context) {
    final tasks = fetchTasks();

    return AppLayout(
      title: "Lista de Tarefas",
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TaskCreatePage()),
          );

          if (created == true) {
            setState(() {});
          }
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      child: TasksList(tasks: tasks),
    );
  }
}
