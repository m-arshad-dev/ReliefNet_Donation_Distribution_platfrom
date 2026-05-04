import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/di.dart';
import '../../../core/navigation/app_session_notifier.dart';
import 'auth_session_mapper.dart';
import '../data/providers/auth_providers.dart';

class AuthService {
  final Ref ref;
  final AuthSessionMapper sessionMapper;

  AuthService(this.ref, {AuthSessionMapper? sessionMapper})
    : sessionMapper = sessionMapper ?? const AuthSessionMapper();

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
    final payload = sessionMapper.fromResponse(response);

    ref.read(authTokenProvider.notifier).state = payload.token;
    ref.read(authUserProvider.notifier).state = {
      'user': payload.user,
      'roles': payload.roles,
    };

    ref.read(appSessionProvider.notifier).setAuthenticated(
      user: payload.user,
      roles: payload.roles,
    );
  }
}
