
import 'package:Oloflix/business_logic/models/movie_slider_model.dart';
import 'package:Oloflix/core/constants/api_control/slider_api.dart';
import 'package:Oloflix/core/utils/global_get_data_frame.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SliderControl{
 static final sliderProvider = FutureProvider<List<MovieSliderModel>>((ref) async {
    try {
      print("🎬 Fetching sliders from: ${SliderApi.sliderMovie}");
      final sliders = await GlobalGetDataFrame.getDataFrame<MovieSliderModel>(
        "${SliderApi.sliderMovie}",
        key: "slider",
        fromJson: (map) => MovieSliderModel.fromJson(map),
      );
      print("✅ Sliders loaded successfully: ${sliders.length} items");
      return sliders;
    } catch (e) {
      print("❌ Error loading sliders: $e");
      // Return empty list instead of throwing to prevent app crash
      return <MovieSliderModel>[];
    }
  });

 static final sliderIndexProvider = StateProvider<int>((ref) => 0);
}