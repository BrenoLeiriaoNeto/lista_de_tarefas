class GeoLocation {
  final double latitude;
  final double longitude;
  final String? address;

  GeoLocation(this.latitude, this.longitude, {this.address});

  String get formatted =>
      address ?? 'Latitude: $latitude, Longitude: $longitude';
}
