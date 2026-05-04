import 'package:dio/dio.dart';

class AuthApi {
  final Dio dio;
  AuthApi(this.dio);

  Map<String, dynamic> _normalizeResponse(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw Exception('Unexpected response format from authentication API');
  }

  void _throwIfApiFailure(Map<String, dynamic> responseData, String fallback) {
    if (responseData['success'] == false) {
      final error = responseData['error'];
      if (error is Map && error['message'] is String) {
        throw Exception(error['message'] as String);
      }
      throw Exception(fallback);
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final res = await dio.post('/auth/register', data: {
      'name': name,
      'email': email,
      'password': password,
    });

    final responseData = _normalizeResponse(res.data);
    _throwIfApiFailure(responseData, 'Registration failed');

    return responseData;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });

    final responseData = _normalizeResponse(res.data);
    _throwIfApiFailure(responseData, 'Login failed');

    return responseData;
  }
}
