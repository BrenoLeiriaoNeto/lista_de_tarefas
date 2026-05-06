import 'package:lista_de_tarefas/features/tasks/data/task_storage.dart';
import 'package:lista_de_tarefas/features/tasks/domain/task.dart';

class TaskRepository {
  final TaskStorage storage;

  TaskRepository(this.storage);

  List<Task> getTasks() => storage.getTasks();
  void addTask(Task task) => storage.add(task);
  void removeTask(Task task) => storage.remove(task);
  void updateTask(Task oldTask, Task newTask) =>
      storage.update(oldTask, newTask);
}
