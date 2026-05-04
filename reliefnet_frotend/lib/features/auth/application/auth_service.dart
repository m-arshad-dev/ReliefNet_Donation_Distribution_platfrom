import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/di.dart';
import '../../../core/navigation/app_session_notifier.dart';
import '../data/providers/auth_providers.dart';

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

  String? _extractToken(Map<String, dynamic> data) {
    final candidates = [
      data['token'],
      data['accessToken'],
      data['access_token']
    ];

    for (final candidate in candidates) {
      if (candidate is String && candidate.isNotEmpty) {
        return candidate;
      }
    }

    return null;
  }

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
    final data = _extractPayload(response);

    final user = Map<String, dynamic>.from(data['user'] ?? {});
    final roles = _extractRoles(data);
    final token = _extractToken(data);

    // Keep legacy providers in sync (if still used elsewhere)
    ref.read(authTokenProvider.notifier).state = token;
    ref.read(authUserProvider.notifier).state = {
      'user': user,
      'roles': roles,
    };

    // Single source of truth session
    ref.read(appSessionProvider.notifier).setAuthenticated(
      user: user,
      roles: roles,
    );
  }
}