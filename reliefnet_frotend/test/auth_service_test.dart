import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reliefnet_app/core/navigation/app_session.dart';
import 'package:reliefnet_app/core/navigation/app_session_notifier.dart';
import 'package:reliefnet_app/features/auth/application/auth_service.dart';
import 'package:reliefnet_app/features/auth/data/providers/auth_providers.dart';
import 'package:reliefnet_app/features/auth/domain/repositories/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  Map<String, dynamic>? loginResponse;
  Map<String, dynamic>? registerResponse;

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    return loginResponse ??
        {
          'data': {
            'token': 'token-login',
            'user': {'id': 1, 'is_pending_approval': false},
            'roles': [
              {'user_role_id': 11, 'is_active': true},
            ],
          },
        };
  }

  @override
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    return registerResponse ??
        {
          'data': {
            'access_token': 'token-register',
            'user': {'id': 2, 'is_pending_approval': false},
            'roles': [
              {'user_role_id': 22, 'is_active': false},
            ],
          },
        };
  }
}

void main() {
  group('AuthService', () {
    late ProviderContainer container;
    late FakeAuthRepository fakeRepository;

    setUp(() {
      fakeRepository = FakeAuthRepository();

      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(fakeRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('login stores token/user/roles and sets active session', () async {
      final service = container.read(authServiceProvider);

      await service.login(email: 'u@example.com', password: 'password');

      expect(container.read(authTokenProvider), 'token-login');
      expect(container.read(authUserProvider)?['user']['id'], 1);
      expect((container.read(authUserProvider)?['roles'] as List).length, 1);

      final session = container.read(appSessionProvider);
      expect(session.status, AppStatus.active);
      expect(session.activeRole?['user_role_id'], 11);
    });

    test('register sets onboardingRequired for inactive role', () async {
      final service = container.read(authServiceProvider);

      await service.register(
        name: 'n',
        email: 'u@example.com',
        password: 'password',
      );

      final session = container.read(appSessionProvider);

      expect(session.status, AppStatus.onboardingRequired);
      expect(session.activeRole?['user_role_id'], 22);
      expect(container.read(authTokenProvider), 'token-register');
    });

    test('throws FormatException when token is missing', () async {
      fakeRepository.loginResponse = {
        'data': {
          'user': {'id': 1, 'is_pending_approval': false},
          'roles': [
            {'user_role_id': 11, 'is_active': true},
          ],
        },
      };

      final service = container.read(authServiceProvider);

      expect(
        () => service.login(email: 'u@example.com', password: 'password'),
        throwsA(isA<FormatException>()),
      );

      expect(container.read(authTokenProvider), isNull);
      expect(
        container.read(appSessionProvider).status,
        AppStatus.unauthenticated,
      );
    });

    test('logout clears providers and session', () async {
      final service = container.read(authServiceProvider);

      await service.login(email: 'u@example.com', password: 'password');

      service.logout();

      expect(container.read(authTokenProvider), isNull);
      expect(container.read(authUserProvider), isNull);
      expect(
        container.read(appSessionProvider).status,
        AppStatus.unauthenticated,
      );
    });
  });
}