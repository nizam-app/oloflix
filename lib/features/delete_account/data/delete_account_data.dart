// lib/features/delete_account/data/delete_account_repository.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class DeleteAccountRepository {
  const DeleteAccountRepository();

  Future<void> deleteAccount({
    required String url,   // AuthAPIController.account_delete
    required String token, // Bearer token
  }) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      // 'X-Requested-With': 'XMLHttpRequest', // লাগলে আনকমেন্ট করো
    };

    http.Response res;

    try {
      // 1) Try DELETE first
      res = await http.get(Uri.parse(url), headers: headers);
      debugPrint('[DEL] DELETE $url → ${res.statusCode} ${res.body}');
    } catch (e) {
      throw Exception('Network error while deleting: $e');
    }

    // Success (200-299 or 204 No Content)
    if ((res.statusCode >= 200 && res.statusCode < 300) || res.statusCode == 204) {
      return;
    }

    // 405 হলে কিছু Laravel সেটাপে POST + _method=DELETE লাগে
    if (res.statusCode == 405) {
      try {
        final res2 = await http.post(
          Uri.parse(url),
          headers: {
            ...headers,
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'_method': 'DELETE'}),
        );
        debugPrint('[DEL] POST _method=DELETE $url → ${res2.statusCode} ${res2.body}');
        if ((res2.statusCode >= 200 && res2.statusCode < 300) || res2.statusCode == 204) {
          return;
        }
        _throwWithMessage(res2);
      } catch (e) {
        throw Exception('Network error while deleting (override): $e');
      }
    }

    _throwWithMessage(res);
  }

  Never _throwWithMessage(http.Response r) {
    try {
      final body = jsonDecode(r.body);
      final msg = body is Map ? body['message']?.toString() : null;
      throw Exception(msg ?? 'Delete failed (${r.statusCode}).');
    } catch (_) {
      throw Exception('Delete failed (${r.statusCode}). ${r.body}');
    }
  }
}