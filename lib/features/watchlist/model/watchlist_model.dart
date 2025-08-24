class Watchlist {
  final int id;
  final int userId;
  final int postId;
  final String postType;

  Watchlist({
    required this.id,
    required this.userId,
    required this.postId,
    required this.postType,
  });

  factory Watchlist.fromJson(Map<String, dynamic> json) {
    return Watchlist(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      userId: json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id'].toString()) ?? 0,
      postId: json['post_id'] is int ? json['post_id'] : int.tryParse(json['post_id'].toString()) ?? 0,
      postType: json['post_type']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'post_id': postId,
      'post_type': postType,
    };
  }
}