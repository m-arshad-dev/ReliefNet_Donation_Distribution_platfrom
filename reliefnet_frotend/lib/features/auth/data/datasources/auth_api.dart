import 'package:dio/dio.dart';

class AuthApi {
  final Dio dio;
  AuthApi(this.dio);

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

  final responseData = Map<String, dynamic>.from(res.data);

  if (responseData['success'] == false) {
    final errorMessage =
        responseData['error']?['message'] ?? 'Registration failed';
    throw Exception(errorMessage);
  }

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

  final responseData = Map<String, dynamic>.from(res.data);

  if (responseData['success'] == false) {
    final errorMessage =
        responseData['error']?['message'] ?? 'Login failed';
    throw Exception(errorMessage);
  }

  return responseData;
}
}