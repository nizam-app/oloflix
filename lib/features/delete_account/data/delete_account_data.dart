// lib/features/profile/data/delete_account_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class DeleteAccountRepository {
  const DeleteAccountRepository();

  Future<void> deleteAccount({
    required String url,   // AuthApi.deleteAccount
    required String token, // Bearer token from SharedPreferences
  }) async {
    final res = await http.get(       // ⬅️ এখানে GET ব্যবহার করেছি
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode >= 200 && res.statusCode < 300) return;

    try {
      final body = jsonDecode(res.body);
      final msg = body['message']?.toString();
      throw Exception(msg ?? 'Delete failed (${res.statusCode}).');
    } catch (_) {
      throw Exception('Delete failed (${res.statusCode}).');
    }
  }
}