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
    return _sendAuthRequest(
      endpoint: '/auth/register',
      payload: {
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
    return _sendAuthRequest(
      endpoint: '/auth/login',
      payload: {
        'email': email,
        'password': password,
      },
      fallbackMessage: 'Login failed',
    );
  }

  Future<Map<String, dynamic>> _sendAuthRequest({
    required String endpoint,
    required Map<String, dynamic> payload,
    required String fallbackMessage,
  }) async {
    try {
      final response = await dio.post(endpoint, data: payload);

      if (response.data is! Map) {
        throw const AuthApiException('Unexpected API response format');
      }

      final responseData = Map<String, dynamic>.from(response.data as Map);
      final isSuccess = responseData['success'] != false;

      if (!isSuccess) {
        throw AuthApiException(
          _extractErrorMessage(responseData, fallbackMessage),
        );
      }

      return responseData;
    } on DioException catch (error) {
      throw AuthApiException(_mapDioErrorToMessage(error, fallbackMessage));
    }
  }

  String _mapDioErrorToMessage(DioException error, String fallbackMessage) {
    final statusCode = error.response?.statusCode;

    if (statusCode == _unauthorizedStatus) {
      return 'Invalid credentials';
    }

    if (statusCode == _tooManyRequestsStatus) {
      return 'Too many attempts. Please retry later.';
    }

    return fallbackMessage;
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
