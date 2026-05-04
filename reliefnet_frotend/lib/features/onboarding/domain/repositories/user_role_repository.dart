import 'package:reliefnet_app/features/onboarding/domain/entities/user_role.dart';

abstract class UserRoleRepository {
  Future<UserRole> assignRole({
    required int userId,
    required int roleId,
  });

  Future<UserRole?> getActiveUserRole(int userId);

  Future<UserRole?> getUserRole(int userRoleId);
}