import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reliefnet_app/features/auth/presentation/screens/auth_landing_page.dart';
import 'package:reliefnet_app/features/main_shell/main_shell.dart';
import 'package:reliefnet_app/features/onboarding/presentation/screens/onboarding_flow_page.dart';
import 'package:reliefnet_app/features/role_selection/presentation/screens/role_selection_screen.dart';
import 'app_session.dart';
import 'app_session_notifier.dart';
import '../../features/onboarding/presentation/screens/pending_approval_screen.dart';

/// Central navigation router - decides which screen to show based on app state
/// This replaces scattered Navigator.push() calls throughout the app
class AppRouter extends ConsumerWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(appSessionProvider);

    switch (session.status) {
      case AppStatus.unauthenticated:
        return const KeyedSubtree(
  key: ValueKey('auth_landing'),
  child: AuthLandingPage(),
);

      case AppStatus.roleSelectionRequired:
        return const RoleSelectionScreen();

      case AppStatus.onboardingRequired:
        final role = session.activeRole;


        if (role == null || role['user_role_id'] == null) {
          return const RoleSelectionScreen();
        }

        final userRoleId = int.parse(role['user_role_id'].toString());

        return OnboardingFlowPage(userRoleId: userRoleId);

      case AppStatus.pendingApproval:
        return const PendingApprovalScreen();

      case AppStatus.active:
        return const MainShell();
    }
  }
}