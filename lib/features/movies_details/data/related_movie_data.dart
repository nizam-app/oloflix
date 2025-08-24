import 'dart:convert';

import 'package:Oloflix/%20business_logic/models/movie_details_model.dart';
import 'package:Oloflix/core/constants/api_control/auth_api.dart';
import 'package:http/http.dart' as http;

class RelatedMoviesRepository {
  final String baseEndpoint;

  RelatedMoviesRepository({String? baseEndpoint})
      : baseEndpoint = baseEndpoint ?? AuthAPIController.related_movie;

  Future<List<MovieDetailsModel>> fetchRelatedBySlugAndId({
    required String slug,
    required int id,
  }) async {
    if (slug.isEmpty || id <= 0) return [];

    // slug safe-encode + base URL-এ trailing slash নিশ্চিত
    final encodedSlug = Uri.encodeComponent(slug);
    final base = baseEndpoint.endsWith('/') ? baseEndpoint : '$baseEndpoint/';
    final url = Uri.parse(base).resolve('$encodedSlug/$id');

    final headers = <String, String>{"Accept": "application/json"};

    // (যদি টোকেন লাগে)
    // final prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString("token");
    // if (token != null) headers["Authorization"] = "Bearer $token";

    final res = await http.get(url, headers: headers);
    if (res.statusCode != 200) {
      throw Exception("Failed to load related movies. Code: ${res.statusCode}");
    }

    final map = jsonDecode(res.body) as Map<String, dynamic>;
    final List related = (map['related_movies'] as List?) ?? const [];
    return related.map((e) => MovieDetailsModel.fromJson(e)).toList();
  }
}