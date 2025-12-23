
import 'package:Oloflix/business_logic/models/movie_details_model.dart';
import 'package:Oloflix/features/movies_details/logic/get_movie_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryFindController {

  static final categoryFiendProvider =
  FutureProvider.family<List<MovieDetailsModel>, String>((ref, id) async {
    final movies = await ref.watch(MovieDetailsController.movieDetailsProvider.future);
    try {
      final filteredMovies = movies.where((m) => m.movieGenreId == "$id").toList();

      print("Found movies: ${filteredMovies.length}");
      return filteredMovies;
    } catch (e) {
      print("Error fetching movies by id: $e");
      return [];
    }
  });
  static final PayPerViewFiendProvider =
  FutureProvider.family<List<MovieDetailsModel>, String>((ref, ppv) async {
    final movies = await ref.watch(MovieDetailsController.movieDetailsProvider.future);
    try {
      final filteredMovies = movies.where((m) => m.videoAccess == "$ppv").toList();

      print("Found movies: ${filteredMovies.length}");
      return filteredMovies;
    } catch (e) {
      print("Error fetching movies by id: $e");
      return [];
    }
  });



}