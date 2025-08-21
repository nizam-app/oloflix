class MovieDetailsModel {
  final String? id;
  final int? categoryId;
  final String videoAccess;
  final double? price;
  final int? expDate;
  final int movieLangId;
  final String movieGenreId;
  final int upcoming;
  final String videoTitle;
  final int releaseDate;
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
    required this.id,
    this.categoryId,
    required this.videoAccess,
    this.price,
    this.expDate,
    required this.movieLangId,
    required this.movieGenreId,
    required this.upcoming,
    required this.videoTitle,
    required this.releaseDate,
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
      id: json['id']?.toString() ?? "",
      categoryId: json['category_id'],
      videoAccess: json['video_access'] ?? "free",
      price: json['price'] != null ? double.tryParse(json['price'].toString()) : 0.0,
      expDate: json['exp_date'],
      movieLangId: json['movie_lang_id'] ?? 0,
      movieGenreId: json['movie_genre_id']?.toString() ?? "",
      upcoming: json['upcoming'] ?? 0,
      videoTitle: json['video_title'] ?? "No Title",
      releaseDate: json['release_date'] ?? 0,
      duration: json['duration'] ?? "0 min",
      videoDescription: json['video_description'] ?? "",
      actorId: json['actor_id'],
      directorId: json['director_id'],
      videoSlug: json['video_slug'] ?? "",
      videoImageThumb: json['video_image_thumb'] ?? "",
      videoImage: json['video_image'] ?? "",
      trailerUrl: json['trailer_url'],
      videoType: json['video_type'] ?? "movie",
      videoQuality: json['video_quality'] ?? 0,
      videoUrl: json['video_url'] ?? "",
      videoUrl480: json['video_url_480'],
      videoUrl720: json['video_url_720'],
      videoUrl1080: json['video_url_1080'],
      downloadEnable: json['download_enable'] ?? 0,
      downloadUrl: json['download_url'] ?? "",
      subtitleOnOff: json['subtitle_on_off'] ?? 0,
      subtitleLanguage1: json['subtitle_language1'],
      subtitleUrl1: json['subtitle_url1'],
      subtitleLanguage2: json['subtitle_language2'],
      subtitleUrl2: json['subtitle_url2'],
      subtitleLanguage3: json['subtitle_language3'],
      subtitleUrl3: json['subtitle_url3'],
      imdbId: json['imdb_id'],
      imdbRating: json['imdb_rating']?.toString(),
      imdbVotes: json['imdb_votes']?.toString(),
      seoTitle: json['seo_title'] ?? "",
      seoDescription: json['seo_description'] ?? "",
      seoKeyword: json['seo_keyword'] ?? "",
      views: json['views'] ?? 0,
      contentRating: json['content_rating'] ?? "N/A",
      status: json['status'] ?? 0,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }}