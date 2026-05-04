/// Represents the overall app state for navigation decisions
enum AppStatus {
  unauthenticated,      // User not logged in
  roleSelectionRequired, // User needs to select a role
  onboardingRequired,   // User has role but not onboarded
  pendingApproval,      // User account is under review
  active,               // User is fully active in system
}

/// Core app session state - single source of truth for navigation
class AppSession {
  final AppStatus status;
  final Map<String, dynamic>? user;
  final List<Map<String, dynamic>> roles;
  final Map<String, dynamic>? activeRole;
  final bool onboardingCompleted;

  const AppSession({
    required this.status,
    this.user,
    this.roles = const [],
    this.activeRole,
    this.onboardingCompleted = false,
  });

  /// Factory for initial unauthenticated state
  factory AppSession.initial() => const AppSession(status: AppStatus.unauthenticated);

  /// Create copy with updated fields
  AppSession copyWith({
    AppStatus? status,
    Map<String, dynamic>? user,
    List<Map<String, dynamic>>? roles,
    Map<String, dynamic>? activeRole,
    bool? onboardingCompleted,
  }) {
    return AppSession(
      status: status ?? this.status,
      user: user ?? this.user,
      roles: roles ?? this.roles,
      activeRole: activeRole ?? this.activeRole,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  /// Computed properties for cleaner state checks
  bool get isAuthenticated => status != AppStatus.unauthenticated;
  bool get hasRole => activeRole != null;
  bool get isActive => status == AppStatus.active;
  bool get needsRoleSelection => status == AppStatus.roleSelectionRequired;
  bool get needsOnboarding => status == AppStatus.onboardingRequired;
}
