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
      id: (json['id'] is int) ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      usertype: json['usertype']?.toString() ?? '',
      loginStatus: (json['login_status'] is int) ? json['login_status'] : int.tryParse(json['login_status'].toString()) ?? 0,
      googleId: json['google_id']?.toString(),
      facebookId: json['facebook_id']?.toString(),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      phone: json['phone']?.toString(), // ✅ int আসলেও String হয়ে যাবে
      userAddress: json['user_address']?.toString(),
      userImage: json['user_image']?.toString().isNotEmpty == true
          ? json['user_image'].toString()
          : "https://static.vecteezy.com/system/resources/previews/036/594/092/original/man-empty-avatar-photo-placeholder-for-social-networks-resumes-forums-and-dating-sites-male-and-female-no-photo-images-for-unfilled-user-profile-free-vector.jpg",
      status: (json['status'] is int) ? json['status'] : int.tryParse(json['status'].toString()) ?? 0,
      planId: (json['plan_id'] is int) ? json['plan_id'] : int.tryParse(json['plan_id'].toString()) ?? 0,
      startDate: json['start_date']?.toString(),
      expDate: json['exp_date']?.toString(),
      planAmount: json['plan_amount']?.toString() ?? '0', // ✅ এখানে fix
      confirmationCode: json['confirmation_code']?.toString(),
      rememberToken: json['remember_token']?.toString(),
      sessionId: json['session_id']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      deletedAt: json['deleted_at']?.toString(),
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
      status: json['status']?.toString() ?? '',
      user: UserModel.fromJson(json['user']),
    );
  }
}