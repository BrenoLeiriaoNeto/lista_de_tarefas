class GeoLocation {
  final double latitude;
  final double longitude;

  GeoLocation(this.latitude, this.longitude);

  String get formatted => 'Latitude: $latitude, Longitude: $longitude';
}
