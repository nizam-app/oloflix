class MovieSliderModel {
  final int id;
  final String title;
  final String image;
  final String type;
  final int postId;
  final String? displayOn;
  final String? url;
  final int? status;

  MovieSliderModel({
    required this.id,
    required this.title,
    required this.image,
    required this.type,
    required this.postId,
    this.displayOn,
    this.url,
    this.status,
  });
  
  factory MovieSliderModel.fromJson(Map<String, dynamic> json) {
    return MovieSliderModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['slider_title']?.toString() ?? '',
      image: json['slider_image']?.toString() ?? '',
      type: json['slider_type']?.toString() ?? '',
      postId: (json['slider_post_id']?.toInt() ?? 0),
      displayOn: json['slider_display_on']?.toString(),
      url: json['slider_url'] as String?,
      status: (json['status'] as num?)?.toInt(),
    );
  }
}