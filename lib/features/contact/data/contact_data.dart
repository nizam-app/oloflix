import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ContactRepository {
  const ContactRepository({this.prefKey = 'token'});
  final String prefKey;

  Future<void> send({
    required String url,
    required Map<String, dynamic> data,
    Map<String, String>? extraHeaders,
  }) async {
    final sp = await SharedPreferences.getInstance();
    final t = sp.getString(prefKey);
    final h = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (t?.isNotEmpty == true) 'Authorization': 'Bearer $t', // 👈 exact header
      ...?extraHeaders,
    };

    final r = await http.post(Uri.parse(url), headers: h, body: jsonEncode(data));
    if (r.statusCode ~/ 100 == 2) return;
    throw Exception('Failed (${r.statusCode}): ${r.body}');
  }
}