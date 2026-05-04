import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/providers/auth_providers.dart';
import '../../../core/navigation/app_session_notifier.dart';

class AuthService {
  final Ref ref;

  AuthService(this.ref);

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final authRepo = ref.read(authRepositoryProvider);

    final res = await authRepo.login(email, password);

    final data = (res['data'] ?? res) as Map<String, dynamic>;

    final user = Map<String, dynamic>.from(data['user'] ?? {});
    final roles = List<Map<String, dynamic>>.from(data['roles'] ?? []);

    // 🔥 SINGLE SOURCE OF TRUTH (session)
    ref.read(appSessionProvider.notifier).setAuthenticated(
      user: user,
      roles: roles,
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final authRepo = ref.read(authRepositoryProvider);

    final res = await authRepo.register(name, email, password);

    final data = (res['data'] ?? res) as Map<String, dynamic>;

    final user = Map<String, dynamic>.from(data['user'] ?? {});
    final roles = List<Map<String, dynamic>>.from(data['roles'] ?? []);

    ref.read(appSessionProvider.notifier).setAuthenticated(
      user: user,
      roles: roles,
    );
  }

  void logout() {
    ref.read(appSessionProvider.notifier).logout();
  }
}