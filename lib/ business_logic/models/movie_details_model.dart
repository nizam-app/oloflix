class MovieDetailsModel {
  final int? id;
  final String? categoryId;
  final String videoAccess;
  final double? price;
  final int? expDate;
  final int movieLangId;
  final String movieGenreId;
  final int upcoming;
  final String videoTitle;
  final int? releaseDate; // <-- nullable korlam
  final String duration;
  final String videoDescription;
  final int? actorId;
  final int? directorId;
  final String videoSlug;
  final String videoImageThumb;
  final String videoImage;
  final String? trailerUrl;
  final String videoType;
  final int videoQuality;
  final String videoUrl;
  final String? videoUrl480;
  final String? videoUrl720;
  final String? videoUrl1080;
  final int downloadEnable;
  final String downloadUrl;
  final int subtitleOnOff;
  final String? subtitleLanguage1;
  final String? subtitleUrl1;
  final String? subtitleLanguage2;
  final String? subtitleUrl2;
  final String? subtitleLanguage3;
  final String? subtitleUrl3;
  final String? imdbId;
  final String? imdbRating;
  final String? imdbVotes;
  final String seoTitle;
  final String seoDescription;
  final String seoKeyword;
  final int views;
  final String contentRating;
  final int status;
  final String? createdAt;
  final String? updatedAt;

  MovieDetailsModel({
    this.id,
    this.categoryId,
    required this.videoAccess,
    this.price,
    this.expDate,
    required this.movieLangId,
    required this.movieGenreId,
    required this.upcoming,
    required this.videoTitle,
    this.releaseDate,
    required this.duration,
    required this.videoDescription,
    this.actorId,
    this.directorId,
    required this.videoSlug,
    required this.videoImageThumb,
    required this.videoImage,
    this.trailerUrl,
    required this.videoType,
    required this.videoQuality,
    required this.videoUrl,
    this.videoUrl480,
    this.videoUrl720,
    this.videoUrl1080,
    required this.downloadEnable,
    required this.downloadUrl,
    required this.subtitleOnOff,
    this.subtitleLanguage1,
    this.subtitleUrl1,
    this.subtitleLanguage2,
    this.subtitleUrl2,
    this.subtitleLanguage3,
    this.subtitleUrl3,
    this.imdbId,
    this.imdbRating,
    this.imdbVotes,
    required this.seoTitle,
    required this.seoDescription,
    required this.seoKeyword,
    required this.views,
    required this.contentRating,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailsModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      categoryId: json['category_id']?.toString(),
      videoAccess: json['video_access']?.toString() ?? "free",
      price: json['price'] != null ? double.tryParse(json['price'].toString()) : null,
      expDate: json['exp_date'] != null ? int.tryParse(json['exp_date'].toString()) : null,
      movieLangId: int.tryParse(json['movie_lang_id']?.toString() ?? "0") ?? 0,
      movieGenreId: json['movie_genre_id']?.toString() ?? "",
      upcoming: int.tryParse(json['upcoming']?.toString() ?? "0") ?? 0,
      videoTitle: json['video_title']?.toString() ?? "No Title",

      // 🟢 releaseDate safe parse (null হলে null, 0 এলে null)
      releaseDate: (json['release_date'] != null && json['release_date'].toString() != "0")
          ? int.tryParse(json['release_date'].toString())
          : null,

      // 🟢 duration fallback
      duration: (json['duration']?.toString().isNotEmpty ?? false)
          ? json['duration'].toString()
          : "N/A",

      videoDescription: json['video_description']?.toString() ?? "",
      actorId: json['actor_id'] != null ? int.tryParse(json['actor_id'].toString()) : null,
      directorId: json['director_id'] != null ? int.tryParse(json['director_id'].toString()) : null,
      videoSlug: json['video_slug']?.toString() ?? "",
      videoImageThumb: json['video_image_thumb']?.toString() ?? "",
      videoImage: json['video_image']?.toString() ?? "",
      trailerUrl: json['trailer_url']?.toString(),
      videoType: json['video_type']?.toString() ?? "movie",
      videoQuality: int.tryParse(json['video_quality']?.toString() ?? "0") ?? 0,
      videoUrl: json['video_url']?.toString() ?? "",
      videoUrl480: json['video_url_480']?.toString(),
      videoUrl720: json['video_url_720']?.toString(),
      videoUrl1080: json['video_url_1080']?.toString(),
      downloadEnable: int.tryParse(json['download_enable']?.toString() ?? "0") ?? 0,
      downloadUrl: json['download_url']?.toString() ?? "",
      subtitleOnOff: int.tryParse(json['subtitle_on_off']?.toString() ?? "0") ?? 0,
      subtitleLanguage1: json['subtitle_language1']?.toString(),
      subtitleUrl1: json['subtitle_url1']?.toString(),
      subtitleLanguage2: json['subtitle_language2']?.toString(),
      subtitleUrl2: json['subtitle_url2']?.toString(),
      subtitleLanguage3: json['subtitle_language3']?.toString(),
      subtitleUrl3: json['subtitle_url3']?.toString(),
      imdbId: json['imdb_id']?.toString(),
      imdbRating: json['imdb_rating']?.toString(),
      imdbVotes: json['imdb_votes']?.toString(),
      seoTitle: json['seo_title']?.toString() ?? "",
      seoDescription: json['seo_description']?.toString() ?? "",
      seoKeyword: json['seo_keyword']?.toString() ?? "",
      views: int.tryParse(json['views']?.toString() ?? "0") ?? 0,
      contentRating: json['content_rating']?.toString() ?? "N/A",
      status: int.tryParse(json['status']?.toString() ?? "0") ?? 0,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}