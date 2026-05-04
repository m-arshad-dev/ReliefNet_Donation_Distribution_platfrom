import 'package:dio/dio.dart';

class UserRoleApi {
  final Dio dio;

  UserRoleApi(this.dio);

  Future<Map<String, dynamic>> assignRole({
    required int userId,
    required int roleId,
  }) async {
    final res = await dio.post(
      '/user-roles',
      data: {
        'userId': userId,
        'roleId': roleId,
      },
    );
    return res.data;
  }

  Future<Map<String, dynamic>?> getActiveUserRole(int userId) async {
    final res = await dio.get('/user-roles/active/$userId');
    return res.data;
  }
}