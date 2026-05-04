import 'package:dio/dio.dart';

class AuthApiException implements Exception {
  final String message;

  const AuthApiException(this.message);

  @override
  String toString() => message;
}

class AuthApi {
  static const int _unauthorizedStatus = 401;
  static const int _tooManyRequestsStatus = 429;

  final Dio dio;

  AuthApi(this.dio);

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
      final statusCode = error.response?.statusCode;
      final payload = error.response?.data;

      // Status-specific handling
      if (statusCode == _unauthorizedStatus) {
        throw const AuthApiException('Invalid credentials');
      }

      if (statusCode == _tooManyRequestsStatus) {
        throw const AuthApiException(
          'Too many attempts. Please retry later.',
        );
      }

      if (payload is Map<String, dynamic>) {
        throw AuthApiException(
          _extractErrorMessage(payload, fallbackMessage),
        );
      }

      throw AuthApiException(error.message ?? fallbackMessage);
    }
  }

  Map<String, dynamic> _parseAuthResponse(
    dynamic payload,
    String fallbackMessage,
  ) {
    if (payload is! Map) {
      throw const AuthApiException('Unexpected API response format');
    }

    final responseData = Map<String, dynamic>.from(payload as Map);

    final isSuccess = responseData['success'] != false;

    if (!isSuccess) {
      throw AuthApiException(
        _extractErrorMessage(responseData, fallbackMessage),
      );
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