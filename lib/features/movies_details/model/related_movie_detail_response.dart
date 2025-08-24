// features/movies_details/model/movie_detail_response.dart
import 'package:Oloflix/%20business_logic/models/movie_details_model.dart';

class RelatedMovieDetailResponse {
  final MovieDetailsModel movie;
  final List<MovieDetailsModel> related;

  RelatedMovieDetailResponse({required this.movie, required this.related});

  factory RelatedMovieDetailResponse.fromJson(Map<String, dynamic> json) {
    final movie = MovieDetailsModel.fromJson(json['movie']);
    final rel = (json['related_movies'] as List? ?? [])
        .map((e) => MovieDetailsModel.fromJson(e))
        .toList();
    return RelatedMovieDetailResponse(movie: movie, related: rel);
  }
}