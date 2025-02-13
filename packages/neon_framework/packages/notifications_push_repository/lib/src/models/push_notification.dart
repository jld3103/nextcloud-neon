import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:crypton/crypton.dart';
import 'package:nextcloud/notifications.dart' as notifications;

part 'push_notification.g.dart';

/// Data for a push notification.
abstract class PushNotification implements Built<PushNotification, PushNotificationBuilder> {
  /// Creates a new [PushNotification].
  factory PushNotification([void Function(PushNotificationBuilder)? updates]) = _$PushNotification;

  const PushNotification._();

  /// Creates a new PushNotification object from the given [json] data containing an encrypted [subject].
  ///
  /// Use [PushNotification.fromJson] when the [subject] is not encrypted.
  factory PushNotification.fromEncrypted(
    Map<String, dynamic> json,
    String accountID,
    RSAPrivateKey devicePrivateKey,
    RSAPublicKey userPublicKey,
  ) {
    final subject = json['subject'] as String;
    final signature = json['signature'] as String;

    final valid = userPublicKey.verifySHA512Signature(
      base64.decode(subject),
      base64.decode(signature),
    );
    if (!valid) {
      throw Exception('Failed to verify push notification signature!');
    }

    final decryptedSubject = notifications.DecryptedSubject.fromEncrypted(devicePrivateKey, subject);

    return PushNotification(
      (b) => b
        ..accountID = accountID
        ..priority = json['priority'] as String
        ..type = json['type'] as String
        ..subject.replace(decryptedSubject),
    );
  }

  /// Creates a new PushNotification object from the given [json] data.
  ///
  /// Use [PushNotification.fromEncrypted] when you the [subject] is still encrypted.
  factory PushNotification.fromJson(Map<String, dynamic> json) => _serializers.deserializeWith(serializer, json)!;

  /// Parses this object into a json like map.
  Map<String, dynamic> toJson() => _serializers.serializeWith(serializer, this)! as Map<String, dynamic>;

  /// The serializer for [PushNotification].
  static Serializer<PushNotification> get serializer => _$pushNotificationSerializer;

  /// The account associated with this notification.
  String get accountID;

  /// The priority of the notification.
  String get priority;

  /// The type of the notification.
  String get type;

  /// The subject of this notification.
  notifications.DecryptedSubject get subject;
}

final Serializers _serializers = (Serializers().toBuilder()
      ..add(PushNotification.serializer)
      ..add(notifications.DecryptedSubject.serializer)
      ..addPlugin(StandardJsonPlugin()))
    .build();
