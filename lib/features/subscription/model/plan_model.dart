// lib/features/subscription/models/plan.dart
class Plan {
  final int id;
  final String name;
  final int planDays;
  final String duration;        // "1"
  final String durationType;    // "365"
  final String price;           // "15000.00" / "25.00"
  final int deviceLimit;
  final bool isInternational;
  final int status;

  Plan({
    required this.id,
    required this.name,
    required this.planDays,
    required this.duration,
    required this.durationType,
    required this.price,
    required this.deviceLimit,
    required this.isInternational,
    required this.status,
  });

  factory Plan.fromJson(Map<String, dynamic> j) => Plan(
    id: j['id'] as int,
    name: j['plan_name'] as String,
    planDays: j['plan_days'] as int,
    duration: j['plan_duration']?.toString() ?? '',
    durationType: j['plan_duration_type']?.toString() ?? '',
    price: j['plan_price']?.toString() ?? '0',
    deviceLimit: j['plan_device_limit'] as int,
    isInternational: (j['is_international'] == 1),
    status: j['status'] as int,
  );
}

class PlansResponse {
  final List<Plan> plans;
  PlansResponse({required this.plans});

  factory PlansResponse.fromJson(Map<String, dynamic> j) {
    final list = (j['plans'] as List<dynamic>? ?? [])
        .map((e) => Plan.fromJson(e as Map<String, dynamic>))
        .toList();
    return PlansResponse(plans: list);
  }
}