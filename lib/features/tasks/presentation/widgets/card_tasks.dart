import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/features/tasks/tasks_features.dart';

class CardTasks extends StatelessWidget {
  final Task task;
  final VoidCallback? onDelete;
  const CardTasks({super.key, required this.task, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.nome),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: .circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDeleteConfirmation(context);
      },
      onDismissed: (direction) {
        deleteTask(task);
        context.safeSnackBar("Tarefa removida!");
        onDelete?.call();
      },
      child:
    InkWell(
      borderRadius: .circular(12),
      onTap: () async {
        final update = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TaskDetailsPage(task: task)),
        );

        if (update == true && context.mounted) {
          onDelete?.call();
        }
      },
      child: Card(
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: .circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.task_alt, color: Colors.blue, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      task.nome,
                      style: const TextStyle(fontSize: 18, fontWeight: .w600),
                    ),
                  ),
                  if (onDelete != null)
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red.withValues(alpha: 0.7),
                      ),
                      splashRadius: 22,
                      onPressed: () => _handleDelete(context),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Data: ${brazilDateFormat(task.dataHora)}",
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "${task.localizacao.state}, ${task.localizacao.city}",
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }

  void _handleDelete(BuildContext context) async {
    final confirmed = await showDeleteConfirmation(context);

    if (confirmed == true && context.mounted) {
      deleteTask(task);

      context.safeSnackBar("Tarefa removida!");

      onDelete?.call();
    }
  }
}
