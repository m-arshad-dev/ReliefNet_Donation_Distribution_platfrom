class AuthSessionPayload {
  final String token;
  final Map<String, dynamic> user;
  final List<Map<String, dynamic>> roles;

  const AuthSessionPayload({
    required this.token,
    required this.user,
    required this.roles,
  });
}
