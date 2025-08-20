 import 'package:Oloflix/core/constants/api_control/slider_api.dart';
import 'package:Oloflix/core/utils/global_get_data_frame.dart';
import 'package:Oloflix/%20business_logic/models/movie_details_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final MovieDetailsProvider = FutureProvider<List<MovieDetailsModel>>((ref) async {
  return GlobalGetDataFrame.getDataFrame<MovieDetailsModel>(
    "${SliderApi.sliderMovie}",
    key: "movies",
    fromJson: (map) => MovieDetailsModel.fromJson(map),
  );
});