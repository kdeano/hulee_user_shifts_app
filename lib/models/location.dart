import 'package:hulee_user_shifts_app/models/coordinates.dart';

class Location {
  final String id;
  final String name;
  final String postCode;
  final double distance;
  final String constituency;
  final String adminDistrict;
  final Coordinates coordinates;

  Location({
    required this.id,
    required this.name,
    required this.postCode,
    required this.distance,
    required this.constituency,
    required this.adminDistrict,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['_id'],
      name: json['name'],
      postCode: json['postCode'],
      distance: json['distance'],
      constituency: json['constituency'],
      adminDistrict: json['adminDistrict'],
      coordinates: Coordinates.fromJson(
          json['cordinates']), // Spelling mistake in the JSON data
    );
  }
}
