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
  final _formKey = GlobalKey<FormState>();

  bool _showManualAddressFields = false;

  final _nomeController = TextEditingController();
  final _ruaController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  final _paisController = TextEditingController();
  final _locationService = LocationService();

  DateTime? _dataHora;
  GeoLocation? _localizacao;

  @override
  Widget build(BuildContext context) {
    final dateFormatted = _dataHora == null
        ? "Selecione a data e hora"
        : brazilDateFormat(_dataHora!);

    final mainLocation =
        _localizacao?.street ?? "Toque para selecionar a localização";
    final subLocation = _localizacao != null
        ? "${_localizacao!.city}, ${_localizacao!.state}"
        : "Toque para selecionar a localização";

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomFormField(
              controller: _nomeController,
              label: "Nome da tarefa",
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

                  _nomeController.text = _nomeController.text;
                }
              },
            ),

            const SizedBox(height: 20),

            FormFieldButton(
              label: "Localização",
              value: mainLocation,
              subtitle: _localizacao != null ? subLocation : null,
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
                    _clearAddressFields();
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
                    onPressed: isFormValid ? _submit : null,
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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_dataHora == null) return;

    String stateFullName = '';

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

    final task = Task(
      nome: _nomeController.text,
      dataHora: _dataHora!,
      localizacao: finalLocation,
    );

    widget.onSubmit(task);
  }
}
