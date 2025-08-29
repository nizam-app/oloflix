import 'dart:convert';
import 'package:http/http.dart' as http;

class ContactRepository {
  const ContactRepository();

  Future<void> send({
    required String url,
    required Map<String, String> headers,
    required Map<String, dynamic> data,
  }) async {
    final res = await http.post(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        ...headers,
      },
      body: jsonEncode(data),
    );

    if (res.statusCode >= 200 && res.statusCode < 300) return;

    try {
      final b = jsonDecode(res.body);
      throw Exception((b is Map ? b['message'] : null) ?? 'Failed (${res.statusCode})');
    } catch (_) {
      throw Exception('Failed (${res.statusCode}). ${res.body}');
    }
  }
}