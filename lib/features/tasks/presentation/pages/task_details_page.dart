import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/features/tasks/tasks_features.dart';

class TaskDetailsPage extends StatelessWidget {
  final Task task;
  const TaskDetailsPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: "Detalhes da Tarefa",
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailsField(
              label: "Tarefa",
              value: task.nome,
              icon: Icons.task_alt,
            ),

            const SizedBox(height: 20),

            DetailsField(
              label: "Data e Hora",
              value: brazilDateFormat(task.dataHora),
              icon: Icons.calendar_month,
            ),

            const SizedBox(height: 20),

            DetailsField(
              label: "País",
              value: task.localizacao.country ?? "",
              icon: Icons.flag,
            ),

            const SizedBox(height: 20),

            DetailsField(
              label: "Cidade",
              value: task.localizacao.city ?? "",
              icon: Icons.location_city,
            ),

            const SizedBox(height: 20),

            DetailsField(
              label: "Estado",
              value: task.localizacao.state ?? "",
              icon: Icons.location_on,
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    label: Text("Editar"),
                    icon: const Icon(Icons.edit),
                    onPressed: () => _handleEdit(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    label: const Text("Excluir"),
                    icon: Icon(Icons.delete),
                    onPressed: () => _handleDelete(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleDelete(BuildContext context) async {
    final confirmed = await showDeleteConfirmation(context);

    if (confirmed == true && context.mounted) {
      deleteTask(task);

      context.safeSnackBar("Tarefa removida!");

      Navigator.pop(context, true);
    }
  }

  void _handleEdit(BuildContext context) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TaskUpdatePage(task: task)),
    );

    if (updated == true && context.mounted) {
      Navigator.pop(context, true);
    }
  }
}
