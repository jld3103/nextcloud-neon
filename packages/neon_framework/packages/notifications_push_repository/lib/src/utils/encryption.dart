import 'dart:convert';
import 'dart:typed_data';

import 'package:built_collection/built_collection.dart';
import 'package:crypton/crypton.dart';
import 'package:meta/meta.dart';
import 'package:notifications_push_repository/notifications_push_repository.dart';

/// Reads the device private key from storage or generates a new one if none has been stored.
@internal
Future<RSAPrivateKey> getDevicePrivateKey(NotificationsPushStorage storage) async {
  var privateKey = storage.readDevicePrivateKey();

  if (privateKey == null) {
    // The key size has to be 2048, other sizes are not accepted by Nextcloud (at the moment at least)
    // ignore: avoid_redundant_argument_values
    privateKey = RSAKeypair.fromRandom(keySize: 2048).privateKey;
    await storage.saveDevicePrivateKey(privateKey);
  }

  return privateKey;
}

/// Parses and decrypts the push notifications as sent by the push proxy.
Future<BuiltList<PushNotification>> parseEncryptedPushNotifications(
  NotificationsPushStorage storage,
  Uint8List notifications,
  String accountID,
) async {
  final subscriptions = await storage.readSubscriptions();

  final subscription = subscriptions[accountID];
  if (subscription == null) {
    throw Exception('Subscription for account $accountID not found.');
  }

  final pushDevice = subscription.pushDevice;
  if (pushDevice == null) {
    throw Exception('Push device for account $accountID not found.');
  }

  final userPublicKey = RSAPublicKey.fromPEM(pushDevice.publicKey);
  final devicePrivateKey = await getDevicePrivateKey(storage);

  final builder = ListBuilder<PushNotification>();

  for (final notification in Uri(query: utf8.decode(notifications)).queryParameters.values) {
    final data = json.decode(notification) as Map<String, dynamic>;
    builder.add(
      PushNotification.fromEncrypted(
        data,
        accountID,
        devicePrivateKey,
        userPublicKey,
      ),
    );
  }

  return builder.build();
}
