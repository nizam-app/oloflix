import 'dart:convert';

/// Root Response
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
      status: json['status'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
      transactions: (json['transactions'] as List? ?? [])
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'user': user.toJson(),
    'transactions': transactions.map((e) => e.toJson()).toList(),
  };

  static ProfileResponse fromRawJson(String str) =>
      ProfileResponse.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());
}

/// User
class User {
  final int id;
  final String usertype;
  final int loginStatus;
  final String? googleId;
  final String? facebookId;
  final String name;
  final String email;
  final String? password;
  final String? phone;
  final String? userAddress;
  final String? userImage;
  final int status;
  final int planId;
  final String? startDate;
  final String? expDate;
  final String planAmount;
  final String? confirmationCode;
  final String? rememberToken;
  final String? sessionId;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  User({
    required this.id,
    required this.usertype,
    required this.loginStatus,
    this.googleId,
    this.facebookId,
    required this.name,
    required this.email,
    this.password,
    this.phone,
    this.userAddress,
    this.userImage,
    required this.status,
    required this.planId,
    this.startDate,
    this.expDate,
    required this.planAmount,
    this.confirmationCode,
    this.rememberToken,
    this.sessionId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] ?? 0,
    usertype: json['usertype'] ?? '',
    loginStatus: json['login_status'] ?? 0,
    googleId: json['google_id'],
    facebookId: json['facebook_id'],
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    password: json['password'],
    phone: json['phone'],
    userAddress: json['user_address'],
    userImage: json['user_image'],
    status: json['status'] ?? 0,
    planId: json['plan_id'] ?? 0,
    startDate: json['start_date'],
    expDate: json['exp_date'],
    planAmount: json['plan_amount'] ?? '0',
    confirmationCode: json['confirmation_code'],
    rememberToken: json['remember_token'],
    sessionId: json['session_id'],
    createdAt: json['created_at'] ?? '',
    updatedAt: json['updated_at'] ?? '',
    deletedAt: json['deleted_at'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'usertype': usertype,
    'login_status': loginStatus,
    'google_id': googleId,
    'facebook_id': facebookId,
    'name': name,
    'email': email,
    'password': password,
    'phone': phone,
    'user_address': userAddress,
    'user_image': userImage,
    'status': status,
    'plan_id': planId,
    'start_date': startDate,
    'exp_date': expDate,
    'plan_amount': planAmount,
    'confirmation_code': confirmationCode,
    'remember_token': rememberToken,
    'session_id': sessionId,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'deleted_at': deletedAt,
  };
}

/// Transaction (তোমার JSON-এ এখন খালি লিস্ট, তাই flexible রাখা হলো)
class Transaction {
  final int? id;
  final String? type;
  final String? amount;
  final String? date;

  Transaction({this.id, this.type, this.amount, this.date});

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json['id'],
    type: json['type'],
    amount: json['amount'],
    date: json['date'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'amount': amount,
    'date': date,
  };
}