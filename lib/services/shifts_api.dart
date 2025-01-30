import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:hulee_user_shifts_app/config/consts.dart';
import 'package:hulee_user_shifts_app/models/shift.dart';

class ShiftsApi {
  static Future<List<Shift>> getShifts() async {
    final url = Consts.apiUrl;
    try {
      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        final jsonData = res.body;
        if (jsonData.isNotEmpty) {
          try {
            final decodedJson = jsonDecode(jsonData);
            if (decodedJson is List<dynamic>) {
              return decodedJson
                  .where((data) => data != null)
                  .map((data) => Shift.fromJson(data))
                  .toList();
            } else {
              throw Exception('Invalid JSON response');
            }
          } catch (e) {
            return [];
          }
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to get shifts');
      }
    } catch (e) {
      return [];
    }
  }
}
