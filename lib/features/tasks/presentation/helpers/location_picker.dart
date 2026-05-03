import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/features/tasks/tasks_features.dart';

Future<GeoLocation?> pickLocation({
  required BuildContext context,
  required LocationService locationService,
}) async {
  try {
    final pos = await locationService.getCurrentLocation();
    final address = await locationService.getAddressFromLocation(pos);

    return GeoLocation(pos.latitude, pos.longitude, address: address);
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Erro ao obter localização: $e")));
    return null;
  }
}
