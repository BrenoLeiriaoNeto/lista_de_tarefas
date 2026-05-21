import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/core/core_features.dart';
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

    final mainLocation =
        _localizacao.street ?? "Toque para selecionar a localização";
    final subLocation = "${_localizacao.city}, ${_localizacao.state}";

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: "Tarefa"),
              validator: (value) =>
                  value == null || value.isEmpty ? "Campo obrigatório" : null,
            ),

            const SizedBox(height: 20),

            FormFieldButton(
              label: "Data e Hora",
              value: dateFormatted,
              icon: Icons.calendar_month,
              onTap: () async {
                final result = await pickDateTime(
                  context: context,
                  initialDate: _dataHora,
                );

                if (result != null) {
                  setState(() => _dataHora = result);
                }
              },
            ),

            const SizedBox(height: 20),

            FormFieldButton(
              label: "Localização",
              value: mainLocation,
              subtitle: subLocation,
              icon: Icons.location_on,
              onTap: () async {
                final result = await showLocationOptionsSheet(
                  context: context,
                  locationService: _locationService,
                );

                if (result != null) {
                  setState(() => _localizacao = result);
                }
              },
            ),

            const SizedBox(height: 30),

            ValueListenableBuilder(
              valueListenable: _nomeController,
              builder: (context, value, child) {
                final bool isNameFilled = value.text.isNotEmpty;
                final bool isFormValid = isNameFilled;
                return SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isFormValid ? _onUpdate : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: .circular(10),
                      ),
                    ),
                    child: const Text(
                      "Salvar Alterações",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
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

    context.safeSnackBar("Tarefa atualizada!");

    Navigator.pop(context, true);
  }
}
