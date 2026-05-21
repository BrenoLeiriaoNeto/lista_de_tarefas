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

  bool _showManualAddressFields = false;

  late TextEditingController _nomeController;
  late TextEditingController _ruaController;
  late TextEditingController _cidadeController;
  late TextEditingController _estadoController;
  late TextEditingController _paisController;
  late DateTime? _dataHora;
  late GeoLocation? _localizacao;

  final _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.task.nome);
    _ruaController = TextEditingController(
      text: widget.task.localizacao.street,
    );
    _cidadeController = TextEditingController(
      text: widget.task.localizacao.city,
    );
    _estadoController = TextEditingController(
      text: widget.task.localizacao.state,
    );
    _paisController = TextEditingController(
      text: widget.task.localizacao.country,
    );
    _dataHora = widget.task.dataHora;
    _localizacao = widget.task.localizacao;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatted = brazilDateFormat(_dataHora!);

    final mainLocation = _ruaController.text;
    final subLocation = "${_cidadeController.text}, ${_estadoController.text}";
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
                  initialDate: _dataHora ?? DateTime.now(),
                  isEditing: true,
                );

                if (result != null) {
                  setState(() => _dataHora = result);

                  _nomeController.text = _nomeController.text;
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
                if (result == "MANUAL_MODE") {
                  setState(() {
                    _showManualAddressFields = true;
                    _localizacao = null;
                    //_clearAddressFields();
                  });
                } else if (result is GeoLocation) {
                  setState(() {
                    _showManualAddressFields = true;
                    _localizacao = result;
                    _updateAddressFields(result);
                  });
                }
              },
            ),

            if (_showManualAddressFields) ...[
              const SizedBox(height: 10),
              Divider(color: Colors.grey),
              const SizedBox(height: 10),
              CustomFormField(
                controller: _ruaController,
                label: "Rua / Logradouro",
                hint: "Digite o nome da rua",
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo obrigatório" : null,
              ),

              const SizedBox(height: 16),

              CustomFormField(
                enabled: _localizacao == null ? true : false,
                controller: _cidadeController,
                label: "Cidade",
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo obrigatório" : null,
              ),
              const SizedBox(height: 16),

              CustomFormField(
                enabled: _localizacao == null ? true : false,
                controller: _estadoController,
                label: "Estado / UF",
                validator: (value) =>
                    value == null || value.isEmpty ? "Obrigatório" : null,
              ),

              const SizedBox(height: 16),

              CustomFormField(
                enabled: _localizacao == null ? true : false,
                controller: _paisController,
                label: "País",
                hint: "Digite o nome do país",
              ),
            ],

            Text(
              "Campos com * são obrigatórios",
              style: TextStyle(fontSize: 12, color: Colors.redAccent),
            ),

            const SizedBox(height: 30),

            AnimatedBuilder(
              animation: Listenable.merge([
                _nomeController,
                _ruaController,
                _cidadeController,
                _estadoController,
                _paisController,
              ]),
              builder: (context, child) {
                final bool isFormValid = _validateRequiredFields();
                return SizedBox(
                  height: 50,
                  width: .infinity,
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

  void _clearAddressFields() {
    _ruaController.clear();
    _cidadeController.clear();
    _estadoController.clear();
    _paisController.clear();
  }

  bool _validateRequiredFields() {
    if (_nomeController.text.trim().isNotEmpty &&
        _dataHora != null &&
        _ruaController.text.trim().isNotEmpty &&
        _cidadeController.text.trim().isNotEmpty &&
        _estadoController.text.trim().isNotEmpty) {
      return true;
    }
    return false;
  }

  void _updateAddressFields(GeoLocation location) {
    _ruaController.text = location.street ?? "";
    _cidadeController.text = location.city ?? "";
    _estadoController.text = location.state ?? "";
    _paisController.text = location.country ?? "";
  }

  void _onUpdate() {
    if (!_formKey.currentState!.validate()) return;
    if (_dataHora == null) return;

    String stateFullName;

    String inputUf = _estadoController.text.trim();
    final inputCountry = _localizacao?.country ?? _paisController.text.trim();

    if (inputCountry.toLowerCase().contains("brazil") ||
        inputCountry.toLowerCase().contains("brasil")) {
      if (inputUf.length == 2) {
        stateFullName = convertAbbreviationToState(inputUf);
      } else {
        inputUf = convertStateToAbbreviation(inputUf);
        stateFullName = convertAbbreviationToState(inputUf);
      }
    } else {
      stateFullName = inputUf;
      inputUf = "";
    }

    final finalLocation = GeoLocation(
      street: _ruaController.text.trim(),
      city: _cidadeController.text.trim(),
      uf: inputUf,
      country: inputCountry,
      state: stateFullName,
    );

    final updatedTask = Task(
      nome: _nomeController.text,
      dataHora: _dataHora!,
      localizacao: finalLocation,
    );

    widget.onUpdate(widget.task, updatedTask);

    context.safeSnackBar("Tarefa atualizada!");

    Navigator.pop(context, true);
  }
}
