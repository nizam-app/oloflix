
import 'package:Oloflix/core/constants/api_control/slider_api.dart';
import 'package:Oloflix/core/utils/global_get_data_frame.dart';
import 'package:Oloflix/%20business_logic/models/movie_slider_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SliderControl{
 static final sliderProvider = FutureProvider<List<MovieSliderModel>>((ref) async {
    return GlobalGetDataFrame.getDataFrame<MovieSliderModel>(
      "${SliderApi.sliderMovie}",
      key: "slider",
      fromJson: (map) => MovieSliderModel.fromJson(map),
    );
  });

 static final sliderIndexProvider = StateProvider<int>((ref) => 0);
}