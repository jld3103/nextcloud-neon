import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value_test/matcher.dart';
import 'package:crypton/crypton.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notifications_push_repository/notifications_push_repository.dart';
import 'package:notifications_push_repository/src/models/models.dart';
import 'package:notifications_push_repository/src/utils/encryption.dart';
import 'package:notifications_push_repository/testing.dart';

class _StorageMock extends Mock implements NotificationsPushStorage {}

void main() {
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
  late NotificationsPushStorage storage;

  setUpAll(() {
    registerFallbackValue(RSAPrivateKey(BigInt.zero, BigInt.zero, BigInt.zero, BigInt.zero));
  });

  setUp(() {
    storage = _StorageMock();
  });

  group('getDevicePrivateKey', () {
    test('New', () async {
      when(() => storage.readDevicePrivateKey()).thenAnswer((_) => null);
      when(() => storage.saveDevicePrivateKey(any())).thenAnswer((_) async {});

      final devicePrivateKey = await getDevicePrivateKey(storage);
      expect(devicePrivateKey.toFormattedPEM(), isNot(devicePrivateKeyPEM));

      verify(() => storage.saveDevicePrivateKey(devicePrivateKey)).called(1);
    });

    test('Existing', () async {
      when(() => storage.readDevicePrivateKey()).thenAnswer((_) => RSAPrivateKey.fromPEM(devicePrivateKeyPEM));

      final devicePrivateKey = await getDevicePrivateKey(storage);
      expect(devicePrivateKey.toFormattedPEM(), equals(devicePrivateKeyPEM));

      verifyNever(() => storage.saveDevicePrivateKey(any()));
    });
  });

  test('parseEncryptedPushNotifications', () async {
    const userPrivateKeyPEM = '''
-----BEGIN RSA PRIVATE KEY-----
MIIB1wIBADANBgkqhkiG9w0BAQEFAASCAcEwggG9AgEAAl4BuCI4NDeaY4S8d2zj
U7znZjsA9WYlmn9HsYx8ITp1hZi83MWfQ3ckDhDlDe8eWi6C1OxXobFzESATcGkg
8IlnEar5PMqFB0DFa0CS4ruPDHJAb57G+WW2hIvEWKc/AgMBAAECXgGYrUWMzthv
cc/iAFxw46XlmgIA2xEtjOPQK8cSv4piO3macXG5nkX/PZbCQnbnUeB4NXBgRxw0
mawTnRW5lIANlDkIGbyXYJ86JHS8Q1PGRtVHb1xDwIkbDHtSS1ECLx8kWzsn2oYA
gwe3yMMpJtxCJTwV7giist9gixv+GFhPH+ZOWu9RsPPqY5VZK7oXAi8OIhO+VbZi
8lB7ZJ9pHUFoJRZZYUBQ8aARwXLP6htbWm/zFknBpUl3tntlG6Q9GQIvHf5WH9Ny
lD1J9dT8d3rbAqhyVDyK1aZdwOarFHrV17fdcWNmEbkMROAqqV0I0GECLwQQQjL4
e+8pEoDX5omXcsXZ2/oo3xAm2MoiH7ut6N20O/ndj6lQt7XmzsW8U9WJAi8Tutz8
e/rwA4zvN4TD8v1bsHu3g6/6k60RTPp5xy0AvYPjYV+ur2H2W/eIDMkXQA==
-----END RSA PRIVATE KEY-----
''';
    final userPrivateKey = RSAPrivateKey.fromPEM(userPrivateKeyPEM);

    when(() => storage.readDevicePrivateKey()).thenAnswer((_) => RSAPrivateKey.fromPEM(devicePrivateKeyPEM));
    when(() => storage.readSubscriptions()).thenAnswer(
      (_) async => BuiltMap<String, PushSubscription>({
        'accountID': PushSubscription(
          (b) => b.pushDevice.update(
            (b) => b
              ..publicKey = userPrivateKey.publicKey.toPEM()
              ..deviceIdentifier = ''
              ..signature = '',
          ),
        ),
      }),
    );

    const subject1 =
        'AOXrekPv+79XU82vEXx5WiA9WREus8uYYkfijtKdl4ggWRvvykaY5hQP7OT5P7iKSCzjmO7yNQTuXDJXYtWo/1Pq0AYSVrA3y37pNYr8d/WZklfvQtxIB6o/HTG6pUd1kER7QxVkP7RSHvw/9PU=';
    const signature1 =
        'AH1A1S9v0uxwcukZXWMX2+3PwTx6ngtGinVX2DHeeQ8j5N6UjN2gl5c9XwhmqO934zSMgQi5lSDlh2NyZb3B44f5IEbehghokXoTd7Bc46auocR1ZIuxDfJGey03qw==';

    const subject2 =
        'AGcV+V73rhvcT2OMu5AAQNd01zd4BWCJqgZc782MOXlj62yKv4AxfbXLZpKjH2tFn8WiZRg6DJmX25v3652mzaJefC4d/urfbIGYN1a30NNSpPJIxjZ1XWUe2MV+aKuaj+liKYukVvzOpK+scCM=';
    const signature2 =
        'AI6nF0DSVgYAGe2UhdgsC9UhGWdvRlTQjBS/2Gj0rMxzYH3GAq5gy/oodJjfjP9iJnhBTltrl8j0Daowcp6DRP8WgKRXzSj3ECAeepHE4whLSGP5gR+nBPe3eCHN8w==';

    final messages = utf8.encode(
      Uri(
        queryParameters: {
          'message1': '{"priority":"priority","type":"type","subject":"$subject1","signature":"$signature1"}',
          'message2': '{"priority":"priority","type":"type","subject":"$subject2","signature":"$signature2"}',
        },
      ).query,
    );

    final notifications = await parseEncryptedPushNotifications(storage, messages, 'accountID');
    expect(notifications, hasLength(2));
    expect(notifications[0], equalsBuilt(createPushNotification()));
    expect(notifications[1], equalsBuilt(createPushNotification(nid: 1)));
  });
}
