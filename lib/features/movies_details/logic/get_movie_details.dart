 import 'package:Oloflix/business_logic/models/movie_details_model.dart';
import 'package:Oloflix/core/constants/api_control/slider_api.dart';
import 'package:Oloflix/core/utils/global_get_data_frame.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieDetailsController {
  static final movieDetailsProvider = FutureProvider<List<MovieDetailsModel>>((ref) async {
    try {
      print("🎬 Fetching all movies from: ${SliderApi.sliderMovie}");
      final data = await GlobalGetDataFrame.getDataFrame<MovieDetailsModel>(
        "${SliderApi.sliderMovie}",
        key: "movies",
        fromJson: (map) => MovieDetailsModel.fromJson(map),
      );
      print("✅ Movies loaded successfully: ${data.length} items");
      return data;
    } catch (e) {
      print("❌ Error fetching movies: $e");
      return [];
    }
  });



  static final movieByIdProvider = FutureProvider.family<MovieDetailsModel?,int>((ref, int id) async {
    print("🔍 Fetching movie by ID: $id");
    final movies = await ref.watch(movieDetailsProvider.future);
    print("   Total movies available: ${movies.length}");
    
    try {
      final movie = movies.firstWhere((m) => m.id == id);
      print("✅ Movie found: ${movie.videoTitle}");
      print("   Video URL: ${movie.videoUrl}");
      return movie;
    } catch (e) {
      print("❌ Error: Movie with ID $id not found");
      return null;
    }
  });


 
}