// lib/features/movies_details/logic/related_movies_provider.dart
import 'package:Oloflix/%20business_logic/models/movie_details_model.dart';
import 'package:Oloflix/features/movies_details/data/related_movie_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final relatedMoviesRepositoryProvider = Provider<RelatedMoviesRepository>((ref) {
  return RelatedMoviesRepository();
});

/// Named record argument for clarity: (slug, id)
final relatedMoviesProvider = FutureProvider.family
    .autoDispose<List<MovieDetailsModel>, ({String slug, int id})>((ref, args) async {
  final repo = ref.watch(relatedMoviesRepositoryProvider);
  return repo.fetchRelatedBySlugAndId(slug: args.slug, id: args.id);
});