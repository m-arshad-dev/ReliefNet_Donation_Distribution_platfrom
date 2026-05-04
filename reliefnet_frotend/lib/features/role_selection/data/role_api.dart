import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reliefnet_app/core/di/di.dart';

/// API client for role-related operations
class RoleApi {
  final Dio _dio;

  RoleApi(this._dio);

  /// Assign a role to the current user
  Future<Map<String, dynamic>> assignRole(int roleId) async {
    try {
      final response = await _dio.post(
        '/users/assign-role',
        data: {'roleId': roleId},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'];
      } else {
        throw Exception(response.data['message'] ?? 'Failed to assign role');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data?['message'] ?? 'Network error');
      }
      rethrow;
    }
  }

  /// Get available roles (for role selection)
  Future<List<Map<String, dynamic>>> getAvailableRoles() async {
    try {
      final response = await _dio.get('/roles');

      if (response.statusCode == 200 && response.data['success'] == true) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch roles');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data?['message'] ?? 'Network error');
      }
      rethrow;
    }
  }
}

/// Provider for RoleApi
final roleApiProvider = Provider<RoleApi>((ref) {
  final dio = ref.watch(dioProvider);
  return RoleApi(dio);
});