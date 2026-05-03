import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
        : DateFormat("dd/MM/yyyy HH:mm", "pt_BR").format(_dataHora!);

    final locationFormatted =
        _localizacao?.formatted ?? "Usar minha localização atual";

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nomeController,
            decoration: const InputDecoration(labelText: "Nome da tarefa"),
            validator: (value) =>
                value == null || value.isEmpty ? "Campo obrigatório" : null,
          ),
          const SizedBox(height: 16),

          ElevatedButton(onPressed: _pickDateTime, child: Text(dateFormatted)),

          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: _isLoadingLocation ? null : _pickLocation,
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
            onPressed: _submit,
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.blue),
              foregroundColor: WidgetStatePropertyAll(Colors.white),
            ),
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('pt', 'BR'),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      _dataHora = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _pickLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      final pos = await _locationService.getCurrentLocation();
      final address = await _locationService.getAddressFromLocation(pos);

      setState(() {
        _localizacao = GeoLocation(
          pos.latitude,
          pos.longitude,
          address: address,
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Não foi possível obter a localização: $e")),
      );
    } finally {
      setState(() => _isLoadingLocation = false);
    }
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
