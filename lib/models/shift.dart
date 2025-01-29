import 'package:hulee_user_shifts_app/models/location.dart';
import 'package:hulee_user_shifts_app/models/user.dart';

class Shift {
  final String id;
  final String title;
  final String role;
  final List<String> typeOfShift;
  final User user;
  final String startTime;
  final String finishTime;
  final int numOfShiftsPerDay;
  final Location location;
  final String date;

  Shift({
    required this.id,
    required this.title,
    required this.role,
    required this.typeOfShift,
    required this.user,
    required this.startTime,
    required this.finishTime,
    required this.numOfShiftsPerDay,
    required this.location,
    required this.date,
  });

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      id: json['_id'],
      title: json['title'],
      role: json['role'],
      typeOfShift: List<String>.from(json['typeOfShift']),
      user: User.fromJson(json['user']),
      startTime: json['startTime'],
      finishTime: json['finishTime'],
      numOfShiftsPerDay: json['numOfShiftsPerDay'],
      location: Location.fromJson(json['location']),
      date: json['date'],
    );
  }
}
