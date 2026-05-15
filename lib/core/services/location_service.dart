import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lista_de_tarefas/features/tasks/tasks_features.dart';

class LocationService {
  Future<GeoLocation> getFullLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("O serviço de localização está desativado.");
    }
    final permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception("Permissão de localização negada");
    }

    final position = await Geolocator.getCurrentPosition();

    final baseLocation = GeoLocation(position.latitude, position.longitude);

    final placemarks = await placemarkFromCoordinates(
      baseLocation.latitude,
      baseLocation.longitude,
    );

    late Placemark place;
    if (placemarks.isNotEmpty) {
      place = placemarks.first;
    }

    final address =
        "${place.street}, ${place.administrativeArea}, ${place.subAdministrativeArea}, ${place.locality}";

    return GeoLocation(
      position.latitude,
      position.longitude,
      address: address,
      city: place.locality,
      country: place.country,
      state: place.administrativeArea,
      street: place.street,
    );
  }
}
