import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/job_model.dart';
import '../models/application_model.dart';
import '../models/hair_info_model.dart';
import '../models/salon_model.dart';
import 'auth_service.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiService {
  // On iOS simulator, localhost from the device refers to the host machine
  static const String baseUrl = 'http://127.0.0.1:8001';

  static ApiService? _instance;
  static ApiService get instance => _instance ??= ApiService._();
  ApiService._();

  Map<String, String> get _headers {
    final headers = {'Content-Type': 'application/json'};
    final token = AuthService.instance.token;
    if (token != null) headers['Authorization'] = 'Bearer $token';
    return headers;
  }

  Future<dynamic> _handleResponse(http.Response response) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }
    String message = 'エラーが発生しました (${response.statusCode})';
    try {
      final body = jsonDecode(response.body);
      message = body['detail'] ?? message;
    } catch (_) {}
    throw ApiException(message, statusCode: response.statusCode);
  }

  // ── Auth ─────────────────────────────────────────────────────────────────

  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? phone,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: _headers,
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'role': role,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
      }),
    );
    return AuthResponse.fromJson(await _handleResponse(res));
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password}),
    );
    return AuthResponse.fromJson(await _handleResponse(res));
  }

  // ── Users ─────────────────────────────────────────────────────────────────

  Future<UserModel> getMe() async {
    final res = await http.get(Uri.parse('$baseUrl/users/me'), headers: _headers);
    return UserModel.fromJson(await _handleResponse(res));
  }

  Future<HairInfoModel> getMyHairInfo() async {
    final res = await http.get(Uri.parse('$baseUrl/users/me/hair-info'), headers: _headers);
    return HairInfoModel.fromJson(await _handleResponse(res));
  }

  Future<HairInfoModel> upsertHairInfo(Map<String, dynamic> data) async {
    final res = await http.put(
      Uri.parse('$baseUrl/users/me/hair-info'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return HairInfoModel.fromJson(await _handleResponse(res));
  }

  // ── Salons ────────────────────────────────────────────────────────────────

  Future<SalonModel> getMySalon() async {
    final res = await http.get(Uri.parse('$baseUrl/salons/me'), headers: _headers);
    return SalonModel.fromJson(await _handleResponse(res));
  }

  Future<SalonModel> createSalon(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/salons/me'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return SalonModel.fromJson(await _handleResponse(res));
  }

  Future<SalonModel> updateSalon(Map<String, dynamic> data) async {
    final res = await http.put(
      Uri.parse('$baseUrl/salons/me'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return SalonModel.fromJson(await _handleResponse(res));
  }

  // ── Jobs ──────────────────────────────────────────────────────────────────

  Future<List<JobModel>> getJobs({String? area, String? menu}) async {
    final params = <String, String>{};
    if (area != null && area != 'すべて') params['area'] = area;
    if (menu != null && menu != 'すべて') params['menu'] = menu;
    final uri = Uri.parse('$baseUrl/jobs').replace(queryParameters: params.isNotEmpty ? params : null);
    final res = await http.get(uri, headers: _headers);
    final data = await _handleResponse(res);
    return (data['jobs'] as List).map((j) => JobModel.fromJson(j)).toList();
  }

  Future<List<JobModel>> getMyJobs() async {
    final res = await http.get(Uri.parse('$baseUrl/jobs/mine'), headers: _headers);
    final data = await _handleResponse(res);
    return (data['jobs'] as List).map((j) => JobModel.fromJson(j)).toList();
  }

  Future<DashboardStats> getDashboardStats() async {
    final res = await http.get(Uri.parse('$baseUrl/jobs/mine/stats'), headers: _headers);
    return DashboardStats.fromJson(await _handleResponse(res));
  }

  Future<JobModel> createJob(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/jobs'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return JobModel.fromJson(await _handleResponse(res));
  }

  // ── Applications ──────────────────────────────────────────────────────────

  Future<ApplicationModel> applyToJob(int jobId, {String? message}) async {
    final res = await http.post(
      Uri.parse('$baseUrl/jobs/$jobId/apply'),
      headers: _headers,
      body: jsonEncode({if (message != null) 'message': message}),
    );
    return ApplicationModel.fromJson(await _handleResponse(res));
  }

  Future<List<ApplicationModel>> getMyApplications() async {
    final res = await http.get(Uri.parse('$baseUrl/applications/me'), headers: _headers);
    final data = await _handleResponse(res) as List;
    return data.map((a) => ApplicationModel.fromJson(a)).toList();
  }

  Future<List<ApplicantModel>> getApplicants(int jobId) async {
    final res = await http.get(Uri.parse('$baseUrl/jobs/$jobId/applicants'), headers: _headers);
    final data = await _handleResponse(res) as List;
    return data.map((a) => ApplicantModel.fromJson(a)).toList();
  }

  Future<void> updateApplicationStatus(int applicationId, String status) async {
    final res = await http.put(
      Uri.parse('$baseUrl/applications/$applicationId/status'),
      headers: _headers,
      body: jsonEncode({'status': status}),
    );
    await _handleResponse(res);
  }
}
