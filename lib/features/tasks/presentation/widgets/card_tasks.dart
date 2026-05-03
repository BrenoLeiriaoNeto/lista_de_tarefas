import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/features/tasks/tasks_features.dart';

class CardTasks extends StatelessWidget {
  final Task task;
  final VoidCallback? onDelete;
  const CardTasks({super.key, required this.task, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: .circular(8),
      onTap: () async {
        final update = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TaskDetailsPage(task: task)),
        );

        if (update == true) {
          onDelete?.call();
        }
      },
      child: Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tarefa: ${task.nome}",
                    style: TextStyle(fontSize: 18, fontWeight: .w500),
                  ),
                  if (onDelete != null)
                    IconButton(
                      onPressed: () async {
                        final confirm = await showDeleteConfirmation(context);

                        if (confirm == true) {
                          TaskRepository(TaskStorage()).removeTask(task);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Tarefa removida!")),
                          );

                          onDelete?.call();
                        }
                      },
                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
                ],
              ),
              Text(
                "Data: ${brazilDateFormat(task.dataHora)}",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
