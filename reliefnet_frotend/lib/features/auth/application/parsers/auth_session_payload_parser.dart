import '../../domain/entities/auth_session_payload.dart';

class AuthSessionPayloadParser {
  static const List<String> _tokenKeys = [
    'token',
    'accessToken',
    'access_token',
  ];

  const AuthSessionPayloadParser();

  AuthSessionPayload parse(Map<String, dynamic> response) {
    final raw = response['data'] ?? response;
    if (raw is! Map) {
      throw const FormatException('Unexpected authentication response shape');
    }

    final data = Map<String, dynamic>.from(raw);
    final token = _extractToken(data);

    if (token == null) {
      throw const FormatException('Missing authentication token in response');
    }

    return AuthSessionPayload(
      token: token,
      user: _safeMap(data['user']),
      roles: _safeRoleList(data['roles']),
    );
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
    for (final key in _tokenKeys) {
      final candidate = data[key];
      if (candidate is String && candidate.isNotEmpty) {
        return candidate;
      }
    }

    return null;
  }
}
