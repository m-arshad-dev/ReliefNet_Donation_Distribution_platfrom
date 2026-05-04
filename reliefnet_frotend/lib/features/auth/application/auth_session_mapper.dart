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

class AuthSessionMapper {
  const AuthSessionMapper();

  AuthSessionPayload fromResponse(Map<String, dynamic> response) {
    final raw = response['data'] ?? response;
    if (raw is! Map) {
      throw const FormatException('Unexpected authentication response shape');
    }

    final data = Map<String, dynamic>.from(raw);
    final user = _safeMap(data['user']);
    final roles = _safeRoleList(data['roles']);
    final token = _extractToken(data);

    if (token == null) {
      throw const FormatException('Missing authentication token in response');
    }

    return AuthSessionPayload(token: token, user: user, roles: roles);
  }

  Map<String, dynamic> _safeMap(Object? value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return <String, dynamic>{};
  }

  List<Map<String, dynamic>> _safeRoleList(Object? value) {
    if (value is! List) {
      return const <Map<String, dynamic>>[];
    }

    return value
        .whereType<Map>()
        .map((role) => Map<String, dynamic>.from(role))
        .toList(growable: false);
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
