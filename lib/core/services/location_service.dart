import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lista_de_tarefas/features/tasks/tasks_features.dart';

Future<GeoLocation> getCurrentLocation() async {
  final permission = await Geolocator.requestPermission();

  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    throw Exception("Permissão de localização negada");
  }

  final position = await Geolocator.getCurrentPosition();

  return GeoLocation(position.latitude, position.longitude);
}

Future<String> getAddressFromLocation(GeoLocation location) async {
  try {
    final placemarks = await placemarkFromCoordinates(
      location.latitude,
      location.longitude,
    );

    final place = placemarks.first;

    return "${place.street}, ${place.administrativeArea}, ${place.subAdministrativeArea}, ${place.locality}";
  } catch (e) {
    throw Exception("Erro ao obter endereço");
  }
}
