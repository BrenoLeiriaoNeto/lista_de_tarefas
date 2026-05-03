import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/features/tasks/tasks_features.dart';

class TaskUpdateForm extends StatefulWidget {
  final Task task;
  final void Function(Task oldTask, Task newTask) onUpdate;

  const TaskUpdateForm({super.key, required this.task, required this.onUpdate});

  @override
  State<TaskUpdateForm> createState() => _TaskUpdateFormState();
}

class _TaskUpdateFormState extends State<TaskUpdateForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nomeController;
  late DateTime _dataHora;
  late GeoLocation _localizacao;

  final _locationService = LocationService();
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.task.nome);
    _dataHora = widget.task.dataHora;
    _localizacao = widget.task.localizacao;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatted = brazilDateFormat(_dataHora);
    final locationFormatted = _localizacao.formatted;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nomeController,
            decoration: const InputDecoration(labelText: "Tarefa"),
            validator: (value) =>
                value == null || value.isEmpty ? "Campo obrigatório" : null,
          ),

          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: () async {
              final result = await pickDateTime(
                context: context,
                initialDate: _dataHora,
              );

              if (result != null) {
                setState(() => _dataHora = result);
              }
            },
            child: Text(dateFormatted),
          ),

          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: () async {
              setState(() => _isLoadingLocation = true);

              final result = await pickLocation(
                context: context,
                locationService: _locationService,
              );

              if (result != null) {
                setState(() => _localizacao = result);
              }

              setState(() => _isLoadingLocation = false);
            },
            child: _isLoadingLocation
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(locationFormatted),
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _onUpdate,
            child: const Text("Salvar Alterações"),
          ),
        ],
      ),
    );
  }

  void _onUpdate() {
    if (!_formKey.currentState!.validate()) return;

    final updatedTask = Task(
      nome: _nomeController.text,
      dataHora: _dataHora,
      localizacao: _localizacao,
    );

    widget.onUpdate(widget.task, updatedTask);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Tarefa atualizada!")));

    Navigator.pop(context, true);
  }
}
