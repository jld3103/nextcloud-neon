import 'package:account_repository/testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Account', () {
    group('constructor', () {
      test('works correctly', () {
        expect(
          createAccount,
          returnsNormally,
        );
      });
    });

    test('supports value equality', () {
      expect(
        createAccount(),
        equals(createAccount()),
      );

      expect(
        createAccount().hashCode,
        equals(createAccount().hashCode),
      );

      expect(
        createAccount(),
        isNot(
          equals(
            createAccount(
              credentials: createCredentials(appPassword: null),
            ),
          ),
        ),
      );
    });

    group('rebuild', () {
      test('returns the same object if not attributes are changed', () {
        expect(
          createAccount().rebuild((_) {}),
          equals(createAccount()),
        );
      });

      test('replaces every attribute', () {
        expect(
          createAccount().rebuild((b) {
            b.credentials
              ..serverURL = Uri.https('new-serverURL')
              ..username = 'new-username'
              ..appPassword = 'new-appPassword';
          }),
          equals(
            createAccount(
              credentials: createCredentials(
                serverURL: Uri.https('new-serverURL'),
                username: 'new-username',
                appPassword: 'new-appPassword',
              ),
            ),
          ),
        );
      });
    });

    test('credential getters', () {
      final account = createAccount(
        credentials: createCredentials(serverURL: Uri(host: 'server')),
      );

      expect(account.username, equals('username'));
      expect(account.id, equals('43c2c7ec8332735e75756dcb08c4fcc6c2b07071'));
      expect(account.humanReadableID, equals('username@server'));
    });

    test('to string', () {
      expect(
        createAccount().toString(),
        equals('''
Account {
  credentials=Credentials {
    serverURL=https://serverurl,
    username=username,
    appPassword=appPassword,
  },
  client=Instance of 'NextcloudClient',
}'''),
      );
    });
  });
}
