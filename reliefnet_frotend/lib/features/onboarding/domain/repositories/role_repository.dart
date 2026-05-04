

import 'package:reliefnet_app/features/onboarding/domain/entities/role.dart';

abstract class RoleRepository {
  Future<Role?> getRoleByName(String roleName);

  Future<List<Role>> getAllRoles();
}