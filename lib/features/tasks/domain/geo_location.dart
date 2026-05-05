class GeoLocation {
  final double latitude;
  final double longitude;
  final String? address;
  final String? city;
  final String? country;
  final String? state;

  GeoLocation(
    this.latitude,
    this.longitude, {
    this.address,
    this.city,
    this.country,
    this.state,
  });

  String get formatted =>
      address ?? 'Latitude: $latitude, Longitude: $longitude';
}
