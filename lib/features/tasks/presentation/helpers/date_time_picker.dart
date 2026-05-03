import 'package:flutter/material.dart';

Future<DateTime?> pickDateTime({
  required BuildContext context,
  required DateTime initialDate,
}) async {
  final date = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    locale: const Locale('pt', 'BR'),
  );

  if (date == null) return null;

  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initialDate),
  );

  if (time == null) return null;

  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}
