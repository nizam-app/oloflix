class UserModel {
  final int id;
  final String usertype;
  final int loginStatus;
  final String? googleId;
  final String? facebookId;
  final String name;
  final String email;
  final String password;
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

  UserModel({
    required this.id,
    required this.usertype,
    required this.loginStatus,
    this.googleId,
    this.facebookId,
    required this.name,
    required this.email,
    required this.password,
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      usertype: json['usertype'] ?? '',
      loginStatus: json['login_status'] ?? 0,
      googleId: json['google_id'],
      facebookId: json['facebook_id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
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
  }
}

class ProfileResponse {
  final String status;
  final UserModel user;

  ProfileResponse({
    required this.status,
    required this.user,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      status: json['status'] ?? '',
      user: UserModel.fromJson(json['user']),
    );
  }
}