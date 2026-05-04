import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reliefnet_app/core/di/di.dart';
import 'package:reliefnet_app/core/navigation/app_session.dart';
import 'package:reliefnet_app/core/navigation/app_session_notifier.dart';
import 'package:reliefnet_app/features/auth/application/auth_service.dart';
import 'package:reliefnet_app/features/auth/data/providers/auth_providers.dart';
import 'package:reliefnet_app/features/auth/domain/repositories/auth_repository.dart';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.loginResponse, this.registerResponse});

  final Map<String, dynamic>? loginResponse;
  final Map<String, dynamic>? registerResponse;

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    return loginResponse ?? <String, dynamic>{};
  }

  @override
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    return registerResponse ?? <String, dynamic>{};
  }
}

void main() {
  group('AuthService', () {
    test('login stores token/user/roles and sets active session', () async {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            _FakeAuthRepository(
              loginResponse: {
                'data': {
                  'token': 'jwt-token',
                  'user': {'id': 10, 'is_pending_approval': false},
                  'roles': [
                    {'user_role_id': 7, 'is_active': true}
                  ],
                },
              },
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final service = container.read(authServiceProvider);
      await service.login(email: 'test@example.com', password: 'secret');

      expect(container.read(authTokenProvider), 'jwt-token');
      expect(container.read(authUserProvider)?['user']?['id'], 10);
      expect(container.read(appSessionProvider).status, AppStatus.active);
      expect(container.read(appSessionProvider).activeRole?['user_role_id'], 7);
    });

    test('login throws when token is missing and keeps user unauthenticated', () async {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            _FakeAuthRepository(
              loginResponse: {
                'data': {
                  'user': {'id': 1, 'is_pending_approval': false},
                  'roles': [
                    {'user_role_id': 1, 'is_active': true}
                  ],
                },
              },
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final service = container.read(authServiceProvider);

      expect(
        () => service.login(email: 'a@b.com', password: 'p'),
        throwsA(isA<FormatException>()),
      );
      expect(container.read(authTokenProvider), isNull);
      expect(container.read(appSessionProvider).status, AppStatus.unauthenticated);
    });

    test('login tolerates malformed roles and maps to role selection state', () async {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            _FakeAuthRepository(
              loginResponse: {
                'data': {
                  'token': 'jwt-token',
                  'user': {'id': 11, 'is_pending_approval': false},
                  'roles': ['invalid-role-shape'],
                },
              },
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final service = container.read(authServiceProvider);
      await service.login(email: 'test@example.com', password: 'secret');

      expect(container.read(appSessionProvider).status, AppStatus.roleSelectionRequired);
      expect(container.read(authUserProvider)?['roles'], isA<List<Map<String, dynamic>>>());
      expect((container.read(authUserProvider)?['roles'] as List).isEmpty, isTrue);
    });

    test('logout clears token, user and session state', () async {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            _FakeAuthRepository(
              loginResponse: {
                'data': {
                  'token': 'jwt-token',
                  'user': {'id': 10, 'is_pending_approval': false},
                  'roles': [
                    {'user_role_id': 7, 'is_active': true}
                  ],
                },
              },
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final service = container.read(authServiceProvider);
      await service.login(email: 'test@example.com', password: 'secret');
      service.logout();

      expect(container.read(authTokenProvider), isNull);
      expect(container.read(authUserProvider), isNull);
      expect(container.read(appSessionProvider).status, AppStatus.unauthenticated);
    });
  });
}
