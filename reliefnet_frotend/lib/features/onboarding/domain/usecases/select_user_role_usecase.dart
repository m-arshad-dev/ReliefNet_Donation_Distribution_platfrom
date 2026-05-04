import 'package:reliefnet_app/features/onboarding/domain/entities/user_role.dart';
import 'package:reliefnet_app/features/onboarding/domain/repositories/role_repository.dart';
import 'package:reliefnet_app/features/onboarding/domain/repositories/user_role_repository.dart';

class SelectUserRoleUseCase {
  final UserRoleRepository userRoleRepository;
  final RoleRepository roleRepository;

  SelectUserRoleUseCase(
    this.userRoleRepository,
    this.roleRepository,
  );

  Future<UserRole> execute({
    required int userId,
    required String roleName,
  }) async {
    final role = await roleRepository.getRoleByName(roleName);
    if (role == null) {
      throw Exception("Role not found");
    }

    return await userRoleRepository.assignRole(
      userId: userId,
      roleId: role.id,
    );
  }
}