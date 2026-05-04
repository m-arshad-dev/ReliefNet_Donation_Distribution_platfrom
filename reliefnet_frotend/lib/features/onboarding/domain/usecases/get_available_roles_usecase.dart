import 'package:reliefnet_app/features/onboarding/domain/entities/role.dart';
import 'package:reliefnet_app/features/onboarding/domain/repositories/role_repository.dart';

class GetAvailableRolesUseCase {
  final RoleRepository roleRepository;

  GetAvailableRolesUseCase(this.roleRepository);

  Future<List<Role>> execute() {
    return roleRepository.getAllRoles();
  }
}