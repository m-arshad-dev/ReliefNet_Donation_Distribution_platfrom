import 'package:flutter_test/flutter_test.dart';
import 'package:reliefnet_app/features/auth/application/parsers/auth_session_payload_parser.dart';

void main() {
  group('AuthSessionPayloadParser', () {
    const parser = AuthSessionPayloadParser();

    test('parses valid response payload', () {
      final payload = parser.parse({
        'data': {
          'token': 'abc',
          'user': {'id': 1},
          'roles': [
            {'user_role_id': 3, 'is_active': true}
          ],
        },
      });

      expect(payload.token, 'abc');
      expect(payload.user['id'], 1);
      expect(payload.roles.single['user_role_id'], 3);
    });

    test('supports access_token fallback keys', () {
      final payload = parser.parse({
        'data': {
          'access_token': 'xyz',
        },
      });

      expect(payload.token, 'xyz');
      expect(payload.user, isEmpty);
      expect(payload.roles, isEmpty);
    });

    test('throws when response data is not a map', () {
      expect(
        () => parser.parse({'data': 'invalid'}),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws when token is missing', () {
      expect(
        () => parser.parse({'data': {'user': {'id': 5}}}),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
