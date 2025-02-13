import 'dart:convert';

import 'package:built_value_test/matcher.dart';
import 'package:crypton/crypton.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notifications_push_repository/notifications_push_repository.dart';
import 'package:notifications_push_repository/testing.dart';

void main() {
  group('PushNotification', () {
    group('constructor', () {
      test('works correctly', () {
        expect(
          createPushNotification,
          returnsNormally,
        );
      });
    });

    test('supports value equality', () {
      expect(
        createPushNotification(),
        equals(createPushNotification()),
      );

      expect(
        createPushNotification().hashCode,
        equals(createPushNotification().hashCode),
      );

      expect(
        createPushNotification(),
        isNot(
          equals(
            createPushNotification(
              accountID: '',
            ),
          ),
        ),
      );
    });

    group('rebuild', () {
      test('returns the same object if not attributes are changed', () {
        expect(
          createPushNotification().rebuild((_) {}),
          equals(createPushNotification()),
        );
      });

      test('replaces every attribute', () {
        expect(
          createPushNotification().rebuild(
            (b) => b
              ..accountID = 'new-accountID'
              ..priority = 'new-priority'
              ..type = 'new-type'
              ..subject.update(
                (b) => b
                  ..nid = 1
                  ..app = 'new-app'
                  ..subject = 'new-subject'
                  ..type = 'new-type'
                  ..id = 'new-id'
                  ..delete = true
                  ..deleteAll = true,
              ),
          ),
          equals(
            createPushNotification(
              accountID: 'new-accountID',
              priority: 'new-priority',
              type: 'new-type',
              nid: 1,
              app: 'new-app',
              subject: 'new-subject',
              id: 'new-id',
              delete: true,
              deleteAll: true,
            ),
          ),
        );
      });
    });

    test('toString', () {
      expect(
        createPushNotification().toString(),
        equals('''
PushNotification {
  accountID=accountID,
  priority=priority,
  type=type,
  subject=DecryptedSubject {
    nid=0,
    app=app,
    subject=subject,
    type=type,
    id=id,
    delete=false,
    deleteAll=false,
  },
}'''),
      );
    });

    test('toJson', () {
      expect(
        json.encode(createPushNotification().toJson()),
        equals(
          '{"accountID":"accountID","priority":"priority","type":"type","subject":{"nid":0,"app":"app","subject":"subject","type":"type","id":"id","delete":false,"delete-all":false}}',
        ),
      );
    });

    test('fromJson', () {
      expect(
        PushNotification.fromJson(
          json.decode(
            '{"accountID":"accountID","priority":"priority","type":"type","subject":{"nid":0,"app":"app","subject":"subject","type":"type","id":"id","delete":false,"delete-all":false}}',
          ) as Map<String, dynamic>,
        ),
        equalsBuilt(createPushNotification()),
      );
    });

    group('fromEncrypted', () {
      const devicePrivateKeyPEM = '''
-----BEGIN RSA PRIVATE KEY-----
MIICHwIBADANBgkqhkiG9w0BAQEFAASCAgkwggIFAgEAAm4BELTz808T8iAkvBkg
tnWs4a1aNcCFAAX54ePLK40YAL/tQjUGoIe0+zO7yzMT0bydk6BFOdyrIP2iwALN
eOLwDvSi7bfpMZ72TqNz8JlBnEFKDS66XBwFMfbfmWTcXpGyaalFrHfsumcYniM2
xwIDAQABAm4Agbw0WkoCiSu1ji6+G098QZjA09WU8F/ncwl1vHBRPPoRm2+yiWhG
N0NzUcYo5Zy/sl2K0W4jgRrrgimOQLekZiTX2hpZjMXmuwdxHLcXf9BQlkUWaegg
gqySWUaaSTjRS0twq+S95ETULNPoQQI3HVercaYdMW+1+QCZnyOBkOxdLGUcnHwK
Fhn1DE+uzkTPcwQ/3pTcp3K/QHusFAzgYGuvI9FBtwI3CUs/LPOJQjIrvB2ZnUFL
9tF5raWmVS4MKbd2lM1FZmhLHtva2X9Bnhn0EClhPbmlGV9mo8BzcQI3Gn1xfDK5
nE37/Qa7qd4GNO4O1+uYvvWErZtVjX3KlNGub2ngt3OxGUMQwohkO928G5BcF3vt
VQI3BH+FwRTRntc3caGF4qVixb+Wu6OLwHg77MjdvKEo8KqTiQjxgAjmUkXPaS8N
4FkEfiY9QA36EQI3AKxizo9goAHnTmY1OVi+4GLp0HroWP64RjW8R/cUemggMqEa
UJYvEQEss8/UoYhOACOm5PEqNg==
-----END RSA PRIVATE KEY-----''';
      final devicePrivateKey = RSAPrivateKey.fromPEM(devicePrivateKeyPEM);

      const userPrivateKeyPEM = '''
-----BEGIN RSA PRIVATE KEY-----
MIIB1wIBADANBgkqhkiG9w0BAQEFAASCAcEwggG9AgEAAl4BimSPD4wH/LwlJk3H
dj6FCPqwZDBgLQQGVZsC6iZuCRMOH9paXuCOSBMw6l9IDrHy23jEasfu6tOnA/vy
QP01oPa0Kkp7qUFdN/eVHOdfBp0KKEPhr6bGGr1Lh+BJAgMBAAECXgFFGmWPVEgV
PuaEr6LXRuwVHckfnXz6PpIWKQR7DZiw5ENFYJIUGZlPsnolCMv2JzvKc66MYlnK
G+I+Lpm9mc2bPbj3aq8vh25mjiyn2mgB9AdlGoDNcW4QN8pisQ0CLxnR3uq23oPB
1hpR/eU+vU5iQ1/ZwKZUf24CihDFGpS9je1X43TYCRDMH3sMFttXAi8PRlpU/AdO
xpqZYcoilhhu/numcU1qEBgiDiTuTHizVGw/OwmDeq3SHjJLhMV9XwIvAVwonbxc
JByFpoVDFlwjpIlQezABEcHJpIXFt/Rp3gPOAf5rILBwac4WqmiMm6kCLwSYBgbV
HWWFuW0zydUJCyQmiQ2PudaSLI/hbR32Bb75PuztVnkiZjBxQHMR5UtFAi8TXKJV
4gkQHdyTMlUgtwTItoS5AWmZU5FUJbDva9S3JerKrTkbeslJiHEhSYrbZw==
-----END RSA PRIVATE KEY-----
''';
      final userPrivateKey = RSAPrivateKey.fromPEM(userPrivateKeyPEM);

      const subject =
          'AOXrekPv+79XU82vEXx5WiA9WREus8uYYkfijtKdl4ggWRvvykaY5hQP7OT5P7iKSCzjmO7yNQTuXDJXYtWo/1Pq0AYSVrA3y37pNYr8d/WZklfvQtxIB6o/HTG6pUd1kER7QxVkP7RSHvw/9PU=';

      test('Valid signature', () {
        const signature =
            'AFhc8Bp2PFwbrsqr9Ygk9T4JRwaqnsojvJ0MnkMIKpX8TYe0/SWj1bVQhWamMQ1uQ3xeFIOFHP3AkoqJ+id7f9CpqETOSqTrUHDFDedCbb8Lwoa95q4lnchDvI6Hbw==';

        expect(
          PushNotification.fromEncrypted(
            json.decode(
              '{"priority":"priority","type":"type","subject":"$subject","signature":"$signature"}',
            ) as Map<String, dynamic>,
            'accountID',
            devicePrivateKey,
            userPrivateKey.publicKey,
          ),
          equalsBuilt(createPushNotification()),
        );
      });

      test('Invalid signature', () {
        const signature = 'abcd';

        expect(
          () => PushNotification.fromEncrypted(
            json.decode(
              '{"priority":"priority","type":"type","subject":"$subject","signature":"$signature"}',
            ) as Map<String, dynamic>,
            'accountID',
            devicePrivateKey,
            userPrivateKey.publicKey,
          ),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'toString',
              'Exception: Failed to verify push notification signature!',
            ),
          ),
        );
      });
    });
  });
}
