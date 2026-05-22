import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lista_de_tarefas/core/core_features.dart';
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

    final baseLocation = GeoLocation(
      latitude: position.latitude,
      longitude: position.longitude,
    );

    final placemarks = await placemarkFromCoordinates(
      baseLocation.latitude ?? 0.0,
      baseLocation.longitude ?? 0.0,
    );

    late Placemark place;
    if (placemarks.isNotEmpty) {
      place = placemarks.first;
    }

    final address =
        "${place.street}, ${place.administrativeArea}, ${place.subAdministrativeArea}, ${place.locality}";

    return GeoLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      address: address,
      city: place.locality,
      country: place.country,
      state: place.administrativeArea,
      street: place.street,
    );
  }

  Future<GeoLocation?> getFromAddressString(String address) async {
    try {
      if (address.trim().isEmpty) return null;

      List<Location> locations = await locationFromAddress(address);

      if (locations.isEmpty) return null;

      final firstLocation = locations.first;

      List<Placemark> placemarks = await placemarkFromCoordinates(
        firstLocation.latitude,
        firstLocation.longitude,
      );

      if (placemarks.isEmpty) return null;
      final place = placemarks.first;

      String cityResult = place.locality ?? '';
      if (cityResult.isEmpty) {
        cityResult = place.subAdministrativeArea ?? '';
      }
      if (cityResult.isEmpty) {
        cityResult = place.subLocality ?? '';
      }

      String streetResult = place.street ?? '';

      final contemGraus = streetResult.contains('°');
      final pareceCoordenada = RegExp(
        r'\d+[SW]$|\d+,\s*-?\d+',
      ).hasMatch(streetResult);

      if (streetResult.isEmpty ||
          streetResult.toLowerCase().contains('unnamed') ||
          contemGraus ||
          pareceCoordenada ||
          streetResult.length <= 3) {
        streetResult = address;
      }

      String stateResult = place.administrativeArea ?? '';

      final stateAbbreviation = convertStateToAbbreviation(stateResult);

      return GeoLocation(
        latitude: firstLocation.latitude,
        longitude: firstLocation.longitude,
        city: cityResult.isEmpty ? address : cityResult,
        country: place.country,
        uf: stateAbbreviation,
        state: place.administrativeArea,
        street: streetResult,
      );
    } catch (e) {
      print("Erro ao obter localização a partir do endereço: $e");
      return null;
    }
  }
}
