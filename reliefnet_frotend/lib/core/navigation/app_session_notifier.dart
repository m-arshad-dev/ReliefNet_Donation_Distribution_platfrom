import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_session.dart';

/// Notifier that manages the global app session state
/// This is the single source of truth for navigation decisions
class AppSessionNotifier extends Notifier<AppSession> {
  @override
  AppSession build() => AppSession.initial();

  /// Called after successful login/register
  void setAuthenticated({
    required Map<String, dynamic> user,
    required List<Map<String, dynamic>> roles,
  }) {
    final isPendingApproval = user['is_pending_approval'] == true;
    final hasActiveRole = roles.any((role) => role['is_active'] == true);
    final hasAnyRole = roles.isNotEmpty;

    AppStatus newStatus;
    Map<String, dynamic>? activeRole;

    if (isPendingApproval) {
      newStatus = AppStatus.pendingApproval;
    } else if (!hasAnyRole) {
      // No roles assigned - need role selection
      newStatus = AppStatus.roleSelectionRequired;
    } else if (!hasActiveRole) {
      // Has roles but none active - needs onboarding
      newStatus = AppStatus.onboardingRequired;
      // Find the first inactive role (user can select which one to onboard)
      activeRole = roles.firstWhere(
        (role) => role['is_active'] != true,
        orElse: () => roles.first,
      );
    } else {
      // Has active role - fully active
      newStatus = AppStatus.active;
      activeRole = roles.firstWhere((role) => role['is_active'] == true);
    }

    state = AppSession(
      status: newStatus,
      user: user,
      roles: roles,
      activeRole: activeRole,
    );
  }

  /// Called when user selects a role
  void setRoleSelected(Map<String, dynamic> selectedRole) {
    state = state.copyWith(
      status: AppStatus.onboardingRequired,
      activeRole: selectedRole,
    );
  }

  /// Called when onboarding is completed
  void setOnboardingCompleted() {
    state = state.copyWith(
      status: AppStatus.active,
      onboardingCompleted: true,
    );
  }

  /// Called on logout
  void logout() {
    state = AppSession.initial();
  }

  /// Force refresh session state (useful after backend changes)
  void refreshSession({
    required Map<String, dynamic> user,
    required List<Map<String, dynamic>> roles,
  }) {
    setAuthenticated(user: user, roles: roles);
  }
}

/// Global provider for app session state
final appSessionProvider = NotifierProvider<AppSessionNotifier, AppSession>(() {
  return AppSessionNotifier();
});
