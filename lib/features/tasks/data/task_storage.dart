import 'package:lista_de_tarefas/features/tasks/domain/task.dart';

class TaskStorage {
  final List<Task> _tasks = [];

  List<Task> getTasks() => List.unmodifiable(_tasks);

  void add(Task task) {
    _tasks.add(task);
  }

  void remove(Task task) {
    _tasks.remove(task);
  }

  void update(Task oldTask, Task newTask) {
    final index = _tasks.indexOf(oldTask);
    if (index != -1) {
      _tasks[index] = newTask;
    }
  }
}
