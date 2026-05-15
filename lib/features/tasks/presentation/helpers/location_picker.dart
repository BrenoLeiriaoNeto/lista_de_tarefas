import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/core/core_features.dart';
import 'package:lista_de_tarefas/features/tasks/tasks_features.dart';

Future<GeoLocation?> pickLocation({
  required BuildContext context,
  required LocationService locationService,
}) async {
  try {
    final location = await locationService.getFullLocation();

    return location;
  } catch (e) {
    if (context.mounted) {
      context.safeSnackBar("Erro ao obter localização: $e");
    }
    return null;
  }
}
