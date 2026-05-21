class GeoLocation {
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? city;
  final String? country;
  final String? state;
  final String? uf;
  final String? street;

  GeoLocation({
    this.latitude,
    this.longitude,
    this.address,
    this.city,
    this.country,
    this.state,
    this.uf,
    this.street,
  });

  String get formatted =>
      address ?? 'Latitude: $latitude, Longitude: $longitude';
}
