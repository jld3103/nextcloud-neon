import 'package:account_repository/src/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nextcloud/nextcloud.dart';

void main() {
  group('AuthenticationClient', () {
    test('AuthenticationClientExtension', () {
      final client = NextcloudClient(Uri());

      expect(
        client.authentication,
        isA<AuthenticationClient>(),
      );
    });
  });
}
