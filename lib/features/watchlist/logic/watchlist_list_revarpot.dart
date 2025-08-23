import 'package:Oloflix/%20business_logic/models/movie_details_model.dart';
import 'package:Oloflix/features/movies_details/logic/get_movie_details.dart';
import 'package:Oloflix/features/watchlist/data/watchlish_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Oloflix/features/watchlist/model/watchlist_model.dart';
import 'package:Oloflix/core/constants/api_control/auth_api.dart';

/// Repository Provider
final watchlistRepositoryProvider = Provider<WatchlistRepository>((ref) {
  return WatchlistRepository();
});

/// FutureProvider for Watchlist
final watchlistProvider = FutureProvider<List<Watchlist>>((ref) async {
  final repo = ref.watch(watchlistRepositoryProvider);
  final data = await repo.fetchWatchlist(AuthAPIController.watchlist);
  return data;
});

final filteredWatchlistMoviesProvider = FutureProvider<List<MovieDetailsModel>>((ref) async {
  final watchlist = await ref.watch(watchlistProvider.future);
  final movies = await ref.watch(MovieDetailsController.movieDetailsProvider.future);

  // watchlist er shob post_id collect koro
  final watchlistIds = watchlist.map((e) => e.postId).toSet();

  // movie details er modhhe filter koro
  final filteredMovies = movies.where((movie) => watchlistIds.contains(movie.id)).toList();

  return filteredMovies;
});