import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/core/core_features.dart';

Future<DateTime?> pickDateTime({
  required BuildContext context,
  required DateTime initialDate,
  bool isEditing = false,
}) async {
  final dateNow = DateTime.now();

  DateTime validInitialDate = initialDate;
  if (!isEditing && initialDate.isBefore(dateNow)) {
    validInitialDate = dateNow;
  }

  final date = await showDatePicker(
    context: context,
    initialDate: validInitialDate,
    firstDate: isEditing
        ? DateTime(2000)
        : DateTime(dateNow.year, dateNow.month, dateNow.day),
    lastDate: DateTime(2100),
    locale: const Locale('pt', 'BR'),
  );

  if (date == null) return null;
  if (!context.mounted) return null;

  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(validInitialDate),
  );

  if (time == null) return null;

  final finalDate = DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  );

  if (!isEditing && finalDate.isBefore(DateTime.now())) {
    if (context.mounted) {
      context.safeSnackBar("Por favor, selecione uma data e hora futura.");
    }
    return null;
  }

  return finalDate;
}
