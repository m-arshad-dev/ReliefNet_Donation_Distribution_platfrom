import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/di.dart';
import '../../../core/navigation/app_session_notifier.dart';
import '../data/providers/auth_providers.dart';

class AuthService {
  final Ref ref;

  AuthService(this.ref);

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final authRepo = ref.read(authRepositoryProvider);
    final response = await authRepo.login(email, password);
    _applyAuthenticatedSession(response);
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final authRepo = ref.read(authRepositoryProvider);
    final response = await authRepo.register(name, email, password);
    _applyAuthenticatedSession(response);
  }

  void logout() {
    ref.read(authTokenProvider.notifier).state = null;
    ref.read(authUserProvider.notifier).state = null;
    ref.read(appSessionProvider.notifier).logout();
  }

  void _applyAuthenticatedSession(Map<String, dynamic> response) {
    final data = (response['data'] ?? response) as Map<String, dynamic>;
    final user = Map<String, dynamic>.from(data['user'] ?? const {});
    final roles = List<Map<String, dynamic>>.from(data['roles'] ?? const []);
    final token = _extractToken(data);

    ref.read(authTokenProvider.notifier).state = token;
    ref.read(authUserProvider.notifier).state = {
      'user': user,
      'roles': roles,
    };

    ref.read(appSessionProvider.notifier).setAuthenticated(
      user: user,
      roles: roles,
    );
  }

  String? _extractToken(Map<String, dynamic> data) {
    final candidates = [data['token'], data['accessToken'], data['access_token']];

    for (final candidate in candidates) {
      if (candidate is String && candidate.isNotEmpty) {
        return candidate;
      }
    }

    return null;
  }
}
