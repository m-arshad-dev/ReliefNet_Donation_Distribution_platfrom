import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_api.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi api;

  AuthRepositoryImpl(this.api);

  @override
  Future<Map<String, dynamic>> login(String email, String password) {
    return api.login(email: email, password: password);
  }

  @override
  Future<Map<String, dynamic>> register(String name, String email, String password) {
    return api.register(name: name, email: email, password: password);
  }
}