import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/features/tasks/tasks_features.dart';

class TasksListPage extends StatefulWidget {
  const TasksListPage({super.key});

  @override
  State<TasksListPage> createState() => _TasksListPageState();
}

class _TasksListPageState extends State<TasksListPage> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  List<Task> fetchTasks() => TaskRepository(TaskStorage()).getTasks();

  @override
  Widget build(BuildContext context) {
    final allTasks = fetchTasks();
    final bool hasTasks = allTasks.isNotEmpty;
    final filteredTasks = allTasks.where((task) {
      return task.nome.toLowerCase().contains(_searchQuery);
    }).toList();

    return AppLayout(
      title: "Lista de Tarefas",
      controller: hasTasks ? _searchController : null,
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
      child: TasksList(tasks: filteredTasks, onDelete: () => setState(() {})),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
