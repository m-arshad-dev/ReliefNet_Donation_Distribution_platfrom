import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reliefnet_app/core/navigation/app_session.dart';
import 'package:reliefnet_app/core/navigation/app_session_notifier.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  test('pending approval user is routed to pendingApproval', () {
    container.read(appSessionProvider.notifier).setAuthenticated(
      user: {'is_pending_approval': true},
      roles: [
        {'is_active': true},
      ],
    );

    expect(container.read(appSessionProvider).status, AppStatus.pendingApproval);
  });

  test('no roles results in roleSelectionRequired', () {
    container.read(appSessionProvider.notifier).setAuthenticated(
      user: {'is_pending_approval': false},
      roles: const [],
    );

    expect(
      container.read(appSessionProvider).status,
      AppStatus.roleSelectionRequired,
    );
  });
}
