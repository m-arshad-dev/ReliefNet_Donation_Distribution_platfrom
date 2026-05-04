// AUTH STATE (global)
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const String _defaultApiBaseUrl = String.fromEnvironment(
  'RELIEFNET_API_BASE_URL',
  defaultValue: 'http://10.0.2.2:3000',
);

// 🔹 Auth token (simple in-memory token storage)
final authTokenProvider = StateProvider<String?>((ref) => null);
// Store authenticated user payload (user, roles, permissions)
final authUserProvider = StateProvider<Map<String, dynamic>?>((ref) => null);

// HTTP CLIENT (GLOBAL)
final dioProvider = Provider<Dio>((ref) {
  final token = ref.watch(authTokenProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: _defaultApiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
    ),
  );

  dio.interceptors.clear();
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_isAuthRoute(options.path) || token == null || token.isEmpty) {
          options.headers.remove('Authorization');
        } else {
          options.headers['Authorization'] = 'Bearer $token';
        }

        return handler.next(options);
      },
    ),
  );

  return dio;
});

bool _isAuthRoute(String path) {
  final normalized = path.toLowerCase();
  return normalized == '/auth/login' || normalized == '/auth/register';
}
