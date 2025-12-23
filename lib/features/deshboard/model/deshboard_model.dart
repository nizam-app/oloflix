// features/deshboard/model/deshboard_model.dart
import 'dart:convert';

/// Top-level response
class ProfileResponse {
  final String status;
  final User user;
  final List<Transaction> transactions;

  ProfileResponse({
    required this.status,
    required this.user,
    required this.transactions,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      status: json['status']?.toString() ?? '',
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      transactions: (json['transactions'] as List<dynamic>? ?? [])
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  static ProfileResponse fromRaw(String raw) =>
      ProfileResponse.fromJson(jsonDecode(raw) as Map<String, dynamic>);
}

/// User node
class User {
  final int id;
  final String? usertype;
  final int? loginStatus;
  final String name;
  final String email;
  final String? phone;
  final int planId;
  final String planAmount; // keep as string to match API
  final int? startDateEpoch; // seconds
  final int? expDateEpoch;   // seconds

  User({
    required this.id,
    this.usertype,
    this.loginStatus,
    required this.name,
    required this.email,
    this.phone,
    required this.planId,
    required this.planAmount,
    this.startDateEpoch,
    this.expDateEpoch,
  });

  /// Computed: DateTime in local time
  DateTime? get startDate => _epochToDate(startDateEpoch);
  DateTime? get expDate => _epochToDate(expDateEpoch);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: _toInt(json['id']),
      usertype: json['usertype']?.toString(),
      loginStatus: _toIntNullable(json['login_status']),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      planId: _toInt(json['plan_id']),
      planAmount: json['plan_amount']?.toString() ?? '0',
      startDateEpoch: _toIntNullable(json['start_date']),
      expDateEpoch: _toIntNullable(json['exp_date']),
    );
  }
}

/// Transaction node
class Transaction {
  final int id;
  final int userId;
  final String email;
  final int planId;
  final String gateway;
  final String paymentAmount; // string from API
  final String paymentId;
  final int dateEpoch; // seconds

  Transaction({
    required this.id,
    required this.userId,
    required this.email,
    required this.planId,
    required this.gateway,
    required this.paymentAmount,
    required this.paymentId,
    required this.dateEpoch,
  });

  DateTime get date => DateTime.fromMillisecondsSinceEpoch(dateEpoch * 1000).toLocal();

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: _toInt(json['id']),
      userId: _toInt(json['user_id']),
      email: json['email']?.toString() ?? '',
      planId: _toInt(json['plan_id']),
      gateway: json['gateway']?.toString() ?? '',
      paymentAmount: json['payment_amount']?.toString() ?? '0',
      paymentId: json['payment_id']?.toString() ?? '',
      dateEpoch: _toInt(json['date']),
    );
  }
}

/// -------- Helpers & Plan Labels --------

int _toInt(dynamic v) {
  if (v is int) return v;
  if (v is String) return int.tryParse(v) ?? 0;
  if (v is num) return v.toInt();
  return 0;
}

int? _toIntNullable(dynamic v) {
  if (v == null) return null;
  return _toInt(v);
}

DateTime? _epochToDate(int? sec) =>
    (sec == null) ? null : DateTime.fromMillisecondsSinceEpoch(sec * 1000).toLocal();

/// Plan label mapping as requested
String planLabelFromId(int? id) {
  switch (id) {
    case 8:
      return 'Yearly Plan';
    case 12:
      return 'Yearly Plan (\$) (International)';
    default:
      return (id == null) ? '—' : 'Plan #$id';
  }
}