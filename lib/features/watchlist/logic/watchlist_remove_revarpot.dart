// lib/features/watchlist/logic/watchlist_controller.dart
import 'package:Oloflix/core/constants/api_control/auth_api.dart';
import 'package:Oloflix/features/watchlist/data/watchlish_remove.dart';
import 'package:Oloflix/features/watchlist/logic/watchlist_list_revarpot.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


// ---------- Repo provider ----------
final watchlistRepositoryProvider = Provider<WatchlistRemoveRepository>((ref) {
  // তোমার গ্লোবাল API কনস্ট্যান্ট বসাও
  return WatchlistRemoveRepository(removeUrl: AuthAPIController.removeWatchlist);
});

// ---------- Action controller ----------
class WatchlistController extends StateNotifier<AsyncValue<void>> {
  WatchlistController(this.ref) : super(const AsyncData(null));
  final Ref ref;

  Future<void> remove({
    required int postId,
    String postType = "Movies",
  }) async {
    state = const AsyncLoading();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      if (token == null || token.isEmpty) {
        throw Exception("Not logged in");
      }

      await ref.read(watchlistRepositoryProvider).removeFromWatchlist(
        token: token,
        postId: postId,
        postType: postType,
      );

      state = const AsyncData(null);

      // ✅ Watchlist refresh করে দাও (তোমার যেটা লিস্ট দেয় সেটাই invalidate করো)
      ref.invalidate(filteredWatchlistMoviesProvider);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

// ---------- Controller provider ----------
final watchlistControllerProvider =
StateNotifierProvider<WatchlistController, AsyncValue<void>>(
      (ref) => WatchlistController(ref),
);