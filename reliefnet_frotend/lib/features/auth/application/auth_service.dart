import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/providers/auth_providers.dart';
import '../../../core/navigation/app_session_notifier.dart';

class AuthService {
  final Ref ref;

  AuthService(this.ref);

  Map<String, dynamic> _extractPayload(Map<String, dynamic> response) {
    final raw = response['data'] ?? response;
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    throw Exception('Invalid authentication payload');
  }

  List<Map<String, dynamic>> _extractRoles(Map<String, dynamic> data) {
    final rawRoles = data['roles'];
    if (rawRoles is! List) return const [];
    return rawRoles
        .whereType<Map>()
        .map((role) => Map<String, dynamic>.from(role))
        .toList();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final authRepo = ref.read(authRepositoryProvider);

    final res = await authRepo.login(email, password);

    final data = _extractPayload(res);
    final user = Map<String, dynamic>.from(data['user'] ?? {});
    final roles = _extractRoles(data);

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

    final data = _extractPayload(res);
    final user = Map<String, dynamic>.from(data['user'] ?? {});
    final roles = _extractRoles(data);

    ref.read(appSessionProvider.notifier).setAuthenticated(
      user: user,
      roles: roles,
    );
  }

  void logout() {
    ref.read(appSessionProvider.notifier).logout();
  }
}
