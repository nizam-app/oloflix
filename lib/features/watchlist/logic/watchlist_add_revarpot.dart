import 'package:Oloflix/features/watchlist/data/watchlish_add.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final watchlistAddControllerProvider =
StateNotifierProvider<WatchlistAddController, AsyncValue<bool>>((ref) {
  return WatchlistAddController();
});

class WatchlistAddController extends StateNotifier<AsyncValue<bool>> {
  WatchlistAddController() : super(const AsyncValue.data(false));

  Future<void> addMovie(String apiUrl, int postId, String postType) async {
    state = const AsyncValue.loading();
    try {
      final repo = WatchlistAddRepository();
      final result = await repo.addToWatchlist(apiUrl, postId, postType);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}