import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:hulee_user_shifts_app/config/consts.dart';
import 'package:hulee_user_shifts_app/models/shift.dart';

class ShiftsApi {
  static Future<List<Shift>> getShifts() async {
    final url = Consts.apiUrl;
    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      final jsonData = jsonDecode(res.body);
      return jsonData.map((data) => Shift.fromJson(data)).toList();
    } else {
      throw Exception('Failed to get shifts');
    }
  }
}
