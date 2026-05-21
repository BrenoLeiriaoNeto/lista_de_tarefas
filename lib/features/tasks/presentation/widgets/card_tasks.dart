import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/core/core_features.dart';
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
      child: InkWell(
        borderRadius: .circular(12),
        onTap: () async {
          final update = await Navigator.pushNamed(
            context,
            AppRoutes.taskDetails,
            arguments: task,
          );

          if (update == true && context.mounted) {
            onDelete?.call();
          }
        },
        child: Card(
          elevation: 2,
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: .circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      getTaskIcon(task.dataHora),
                      color: _taskStatus(task.dataHora),
                      size: 25,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        task.nome,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: .bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    if (onDelete != null)
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red.withValues(alpha: 0.7),
                        ),
                        splashRadius: 22,
                        style: IconButton.styleFrom(
                          backgroundColor: Color(0xFFededed),
                          side: BorderSide(color: Colors.black12, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: .circular(20),
                          ),
                        ),
                        onPressed: () => _handleDelete(context),
                      ),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1, thickness: 0.5),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    _buildInfoChip(
                      Icons.calendar_month_rounded,
                      brazilDateFormat(task.dataHora),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Align(
                        alignment: .centerLeft,
                        child: _buildInfoChip(
                          Icons.location_on_outlined,
                          "${task.localizacao.city}",
                        ),
                      ),
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

  IconData getTaskIcon(DateTime data) {
    final agora = DateTime.now();

    if (data.isBefore(agora)) {
      return Icons.error_outline;
    }
    if (data.year == agora.year &&
        data.month == agora.month &&
        data.day == agora.day) {
      return Icons.task_alt;
    }
    return Icons.calendar_today_outlined;
  }

  Color _taskStatus(DateTime data) {
    final agora = DateTime.now();
    if (data.isBefore(agora)) {
      return Colors.red;
    }
    if (data.year == agora.year &&
        data.month == agora.month &&
        data.day == agora.day) {
      return Colors.green;
    }
    return Colors.blue;
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: _taskStatus(task.dataHora).withValues(alpha: 0.1),
        borderRadius: .circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: _taskStatus(task.dataHora)),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: .w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
