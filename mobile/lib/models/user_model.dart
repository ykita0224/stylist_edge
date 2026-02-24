class UserModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String role; // "model" or "stylist"
  final bool isActive;
  final String createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    required this.isActive,
    required this.createdAt,
  });

  bool get isStylist => role == 'stylist';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      isActive: json['is_active'],
      createdAt: json['created_at'],
    );
  }
}

class AuthResponse {
  final String accessToken;
  final UserModel user;

  const AuthResponse({required this.accessToken, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'],
      user: UserModel.fromJson(json['user']),
    );
  }
}
