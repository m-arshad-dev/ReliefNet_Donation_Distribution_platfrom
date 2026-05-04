import 'package:dio/dio.dart';

class AuthApi {
  AuthApi(this.dio);

  final Dio dio;

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _postAuth(
      '/auth/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
      },
      fallbackMessage: 'Registration failed',
    );
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) {
    return _postAuth(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
      fallbackMessage: 'Login failed',
    );
  }

  Future<Map<String, dynamic>> _postAuth(
    String path, {
    required Map<String, dynamic> data,
    required String fallbackMessage,
  }) async {
    try {
      final response = await dio.post(path, data: data);
      return _parseAuthResponse(response.data, fallbackMessage);
    } on DioException catch (error) {
      final payload = error.response?.data;
      if (payload is Map<String, dynamic>) {
        throw Exception(_extractErrorMessage(payload, fallbackMessage));
      }
      throw Exception(error.message ?? fallbackMessage);
    }
  }

  Map<String, dynamic> _parseAuthResponse(
    dynamic payload,
    String fallbackMessage,
  ) {
    if (payload is! Map) {
      throw Exception(fallbackMessage);
    }

    final responseData = Map<String, dynamic>.from(payload as Map);
    if (responseData['success'] == false) {
      throw Exception(_extractErrorMessage(responseData, fallbackMessage));
    }
    return responseData;
  }

  String _extractErrorMessage(
    Map<String, dynamic> responseData,
    String fallbackMessage,
  ) {
    final error = responseData['error'];
    if (error is Map && error['message'] is String) {
      return error['message'] as String;
    }
    if (responseData['message'] is String) {
      return responseData['message'] as String;
    }
    return fallbackMessage;
  }
}
