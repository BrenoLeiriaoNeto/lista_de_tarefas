import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/features/tasks/tasks_features.dart';

Future<GeoLocation?> pickLocation({
  required BuildContext context,
  required LocationService locationService,
}) async {
  try {
    final location = await locationService.getFullLocation();

    return location;
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Erro ao obter localização: $e")));
    return null;
  }
}
