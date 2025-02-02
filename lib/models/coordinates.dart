class Coordinates {
  final double longitude;
  final double latitude;
  final bool? useRotaCloud;

  Coordinates({
    required this.longitude,
    required this.latitude,
    this.useRotaCloud,
  });

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      longitude: json['longitude'],
      latitude: json['latitude'],
      useRotaCloud: json['useRotaCloud'] ?? false,
    );
  }
}
