import 'package:hulee_user_shifts_app/models/location.dart';
import 'package:hulee_user_shifts_app/models/user.dart';

class Shift {
  final String? id;
  final String? title;
  final String? role;
  final List<String>? typeOfShift;
  final User? user;
  final String? startTime;
  final String? finishTime;
  final int? numOfShiftsPerDay;
  final Location? location;
  final String? date;

  Shift({
    this.id,
    this.title,
    this.role,
    this.typeOfShift,
    this.user,
    this.startTime,
    this.finishTime,
    this.numOfShiftsPerDay,
    this.location,
    this.date,
  });

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      id: json['_id'],
      title: json['title'],
      role: json['role'],
      typeOfShift: json['typeOfShift'] != null
          ? List<String>.from(json['typeOfShift'])
          : [],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      startTime: json['startTime'],
      finishTime: json['finishTime'],
      numOfShiftsPerDay: json['numOfShiftsPerDay'],
      location:
          json['location'] != null ? Location.fromJson(json['location']) : null,
      date: json['date'],
    );
  }
}
