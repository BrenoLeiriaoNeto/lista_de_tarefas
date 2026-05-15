import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/core/core_features.dart';
import 'package:lista_de_tarefas/features/tasks/tasks_features.dart';

class TaskForm extends StatefulWidget {
  final void Function(Task task) onSubmit;
  const TaskForm({super.key, required this.onSubmit});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  bool _isLoadingLocation = false;
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _locationService = LocationService();

  DateTime? _dataHora;
  GeoLocation? _localizacao;

  @override
  Widget build(BuildContext context) {
    final dateFormatted = _dataHora == null
        ? "Selecione a data e hora"
        : brazilDateFormat(_dataHora!);

    final mainLocation = _localizacao?.street ?? "Usar minha localização atual";
    final subLocation = _localizacao != null
        ? "${_localizacao!.city}, ${_localizacao!.state}"
        : "Usar minha localização atual";

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: "Nome da tarefa"),
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
                  initialDate: _dataHora ?? DateTime.now(),
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
              subtitle: _localizacao != null ? subLocation : null,
              icon: Icons.location_on,
              loading: _isLoadingLocation,
              onTap: () async {
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
            ),

            const SizedBox(height: 30),

            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _nomeController,
              builder: (context, value, child) {
                final bool isNameFilled = value.text.isNotEmpty;
                final bool isFormValid =
                    isNameFilled && _dataHora != null && _localizacao != null;
                return SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isFormValid && !_isLoadingLocation
                        ? _submit
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: .circular(10),
                      ),
                    ),
                    child: const Text("Salvar", style: TextStyle(fontSize: 18)),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_dataHora == null) return;
    if (_localizacao == null) return;

    final task = Task(
      nome: _nomeController.text,
      dataHora: _dataHora!,
      localizacao: _localizacao!,
    );

    widget.onSubmit(task);
  }
}
