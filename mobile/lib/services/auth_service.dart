import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const _tokenKey = 'access_token';
  static const _userNameKey = 'user_name';
  static const _userEmailKey = 'user_email';
  static const _userPhoneKey = 'user_phone';
  static const _userRoleKey = 'user_role';
  static const _userIdKey = 'user_id';

  static AuthService? _instance;
  static AuthService get instance => _instance ??= AuthService._();
  AuthService._();

  String? _token;
  UserModel? _currentUser;

  String? get token => _token;
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _token != null;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
    final id = prefs.getInt(_userIdKey);
    if (_token != null && id != null) {
      _currentUser = UserModel(
        id: id,
        name: prefs.getString(_userNameKey) ?? '',
        email: prefs.getString(_userEmailKey) ?? '',
        phone: prefs.getString(_userPhoneKey),
        role: prefs.getString(_userRoleKey) ?? 'model',
        isActive: true,
        createdAt: '',
      );
    }
  }

  Future<void> saveAuth(AuthResponse auth) async {
    _token = auth.accessToken;
    _currentUser = auth.user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, auth.accessToken);
    await prefs.setInt(_userIdKey, auth.user.id);
    await prefs.setString(_userNameKey, auth.user.name);
    await prefs.setString(_userEmailKey, auth.user.email);
    await prefs.setString(_userRoleKey, auth.user.role);
    if (auth.user.phone != null) {
      await prefs.setString(_userPhoneKey, auth.user.phone!);
    }
  }

  Future<void> logout() async {
    _token = null;
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void updateCurrentUser(UserModel user) {
    _currentUser = user;
  }
}
