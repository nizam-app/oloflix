// lib/features/subscription/data/plans_repository.dart
import 'dart:convert';
import 'package:Oloflix/features/subscription/model/plan_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:Oloflix/core/constants/api_control/auth_api.dart';

class PlansRepository {
  static Future<List<Plan>> fetchPlans() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null || token.isEmpty) {
      throw Exception('No token found. Please login first.');
    }

    // ⬇️ তোমার প্ল্যান API এন্ডপয়েন্ট বসাও
    final url = Uri.parse(
      '${AuthAPIController.membership_plan}?t=${DateTime.now().millisecondsSinceEpoch}',
    );

    final resp = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Cache-Control': 'no-cache, no-store, must-revalidate',
        'Pragma': 'no-cache',
      },
    );

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      return PlansResponse.fromJson(data).plans;
    } else {
      throw Exception('Failed to load plans. Code: ${resp.statusCode}');
    }
  }
}