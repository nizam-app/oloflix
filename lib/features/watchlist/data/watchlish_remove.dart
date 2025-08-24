// lib/features/watchlist/data/watchlist_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class WatchlistRemoveRepository {
  WatchlistRemoveRepository({required this.removeUrl});
  final String removeUrl;

  Future<void> removeFromWatchlist({
    required String token,
    required int postId,
    required String postType,
  }) async {
    final res = await http.post(
      Uri.parse(removeUrl),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "post_id": postId,
        "post_type": postType,
      }),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("Failed to remove. Code: ${res.statusCode} Body: ${res.body}");
    }
    // চাইলে success JSON চেক করতে পারো
  }
}