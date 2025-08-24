 import 'package:Oloflix/core/constants/api_control/slider_api.dart';
import 'package:Oloflix/core/utils/global_get_data_frame.dart';
import 'package:Oloflix/%20business_logic/models/movie_details_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieDetailsController {
  static final movieDetailsProvider = FutureProvider<List<MovieDetailsModel>>((ref) async {
    try {
      final data = await GlobalGetDataFrame.getDataFrame<MovieDetailsModel>(
        "${SliderApi.sliderMovie}",
        key: "movies",
        fromJson: (map) => MovieDetailsModel.fromJson(map),
      );

      return data;
    } catch (e) {
      print("Error fetching movies: $e");
      return [];
    }
  });



  static final movieByIdProvider = FutureProvider.family<MovieDetailsModel?,int>((ref, int id) async {
    final movies = await ref.watch(movieDetailsProvider.future); // future থেকে data আনুন
                 print("Fetching movie by: ${movies.length}");
    try {
      final movie = movies.firstWhere((m) => m.id == id);
      print(movie.id);
      return movie;
    } catch (e) {
      print("Error fetching movie by id: $e");
      return null;
    }
  });


 
}