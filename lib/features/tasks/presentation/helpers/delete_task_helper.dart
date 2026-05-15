import 'package:lista_de_tarefas/features/tasks/tasks_features.dart';

void deleteTask(Task task) => TaskRepository(TaskStorage()).removeTask(task);
