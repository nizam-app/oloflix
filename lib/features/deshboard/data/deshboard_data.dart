// features/deshboard/logic/deshboard_reverport.dart
import 'dart:convert';
import 'package:Oloflix/features/deshboard/model/deshboard_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Oloflix/core/constants/api_control/auth_api.dart';

class ProfileRepository {
  /// GET profile with Bearer token from SharedPreferences
  Future<ProfileResponse> fetchProfile(String apiUrl) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('No token found in SharedPreferences');
    }

    final res = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      return ProfileResponse.fromJson(body);
    } else {
      throw Exception('Failed to load profile. Code: ${res.statusCode}');
    }
  }
}

/// API URL provider
final profileApiUrlProvider = Provider<String>((ref) {
  return "${AuthAPIController.dashboard}";
});

/// Repository provider
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});

/// Main profile fetcher
final profileProvider = FutureProvider<ProfileResponse>((ref) async {
  final repo = ref.read(profileRepositoryProvider);
  final url = ref.watch(profileApiUrlProvider);
  return repo.fetchProfile(url);
});

/// Expose only user
final userProvider = Provider<User?>((ref) {
  final asyncProfile = ref.watch(profileProvider);
  return asyncProfile.maybeWhen(
    data: (data) => data.user,
    orElse: () => null,
  );
});

/// Expose transactions
final transactionsProvider = Provider<List<Transaction>>((ref) {
  final asyncProfile = ref.watch(profileProvider);
  return asyncProfile.maybeWhen(
    data: (data) => data.transactions,
    orElse: () => const [],
  );
});