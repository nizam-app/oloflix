// lib/features/ads/data/ads_model.dart
class AdModel {
  final int id;
  final String title;
  final String? image; // "upload/xxx.jpg"
  final String? url;
  final int order;
  final int status;

  AdModel({
    required this.id,
    required this.title,
    this.image,
    this.url,
    required this.order,
    required this.status,
  });

  factory AdModel.fromJson(Map<String, dynamic> j) => AdModel(
    id: j['id'] is int ? j['id'] : int.tryParse(j['id'].toString()) ?? 0,
    title: j['title']?.toString() ?? '',
    image: j['image']?.toString(),
    url: j['url']?.toString(),
    order: j['order'] is int ? j['order'] : int.tryParse(j['order'].toString()) ?? 0,
    status: j['status'] is int ? j['status'] : int.tryParse(j['status'].toString()) ?? 0,
  );
}

class AdsResponse {
  final String status;
  final List<AdModel> ads;

  AdsResponse({required this.status, required this.ads});

  factory AdsResponse.fromJson(Map<String, dynamic> j) => AdsResponse(
    status: j['status']?.toString() ?? '',
    ads: (j['ads'] as List? ?? []).map((e) => AdModel.fromJson(e)).toList(),
  );
}