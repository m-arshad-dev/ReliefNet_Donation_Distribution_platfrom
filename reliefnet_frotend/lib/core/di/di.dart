// AUTH STATE (global)
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';


// 🔹 Auth token (simple in-memory token storage)
final authTokenProvider = StateProvider<String?>((ref) => null);
// store authenticated user payload (user, roles, permissions)
final authUserProvider = StateProvider<Map<String, dynamic>?>((ref) => null);


// HTTP CLIENT (GLOBAL)
final dioProvider = Provider<Dio>((ref) {
  final token = ref.watch(authTokenProvider);

  final dio = Dio(BaseOptions(
    baseUrl: "http://10.0.2.2:3000", // or your real IP
  ));

  dio.interceptors.clear();
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        if (!options.path.contains('/auth/') &&
            token != null &&
            token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ),
  );

  return dio;
});