import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart' show SvgFileLoader, vg;
import 'package:image/image.dart' as img;
import 'package:meta/meta.dart';
import 'package:neon/src/blocs/accounts.dart';
import 'package:neon/src/models/account.dart';
import 'package:neon/src/models/push_notification.dart';
import 'package:neon/src/settings/models/storage.dart';
import 'package:neon/src/theme/colors.dart';
import 'package:neon/src/utils/global.dart';
import 'package:neon/src/utils/localizations.dart';
import 'package:nextcloud/notifications.dart' as notifications;

@internal
@immutable
class PushUtils {
  const PushUtils._();

  static notifications.RSAKeypair loadRSAKeypair() {
    const storage = ClientStorage(StorageKeys.notifications);
    const keyDevicePrivateKey = 'device-private-key';

    final notifications.RSAKeypair keypair;
    if (!storage.containsKey(keyDevicePrivateKey) || (storage.getString(keyDevicePrivateKey)!.isEmpty)) {
      debugPrint('Generating RSA keys for push notifications');
      // The key size has to be 2048, other sizes are not accepted by Nextcloud (at the moment at least)
      // ignore: avoid_redundant_argument_values
      keypair = notifications.RSAKeypair.fromRandom(keySize: 2048);
      unawaited(storage.setString(keyDevicePrivateKey, keypair.privateKey.toPEM()));
    } else {
      keypair = notifications.RSAKeypair(notifications.RSAPrivateKey.fromPEM(storage.getString(keyDevicePrivateKey)!));
    }

    return keypair;
  }

  static Future<FlutterLocalNotificationsPlugin> initLocalNotifications({
    final DidReceiveNotificationResponseCallback? onDidReceiveNotificationResponse,
  }) async {
    final localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await localNotificationsPlugin.initialize(
      InitializationSettings(
        android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
        linux: LinuxInitializationSettings(
          defaultActionName: 'Open',
          defaultIcon: AssetsLinuxIcon('assets/logo.svg'),
        ),
      ),
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
    return localNotificationsPlugin;
  }

  static Future<void> onMessage(final Uint8List messages, final String instance) async {
    WidgetsFlutterBinding.ensureInitialized();

    final localNotificationsPlugin = await initLocalNotifications(
      onDidReceiveNotificationResponse: (final notification) async {
        if (Global.onPushNotificationClicked != null && notification.payload != null) {
          await Global.onPushNotificationClicked!(
            PushNotification.fromJson(
              json.decode(notification.payload!) as Map<String, dynamic>,
            ),
          );
        }
      },
    );
    await NeonStorage.init();

    final keypair = loadRSAKeypair();
    for (final message in Uri(query: utf8.decode(messages)).queryParameters.values) {
      final data = json.decode(message) as Map<String, dynamic>;
      final pushNotification = PushNotification.fromEncrypted(data, keypair.privateKey);

      if (pushNotification.subject.delete ?? false) {
        await localNotificationsPlugin.cancel(_getNotificationID(instance, pushNotification));
      } else if (pushNotification.subject.deleteAll ?? false) {
        await localNotificationsPlugin.cancelAll();
        await Global.onPushNotificationReceived?.call(instance);
      } else if (pushNotification.type == 'background') {
        debugPrint('Got unknown background notification ${json.encode(pushNotification.toJson())}');
      } else {
        final localizations = await appLocalizationsFromSystem();

        final accounts = loadAccounts();
        Account? account;
        notifications.Notification? notification;
        AndroidBitmap<Object>? largeIconBitmap;
        try {
          account = accounts.tryFind(instance);
          if (account != null) {
            final response =
                await account.client.notifications.endpoint.getNotification(id: pushNotification.subject.nid!);
            notification = response.body.ocs.data;
            if (notification.icon?.endsWith('.svg') ?? false) {
              // Only SVG icons are supported right now (should be most of them)

              final cacheManager = DefaultCacheManager();
              final file = await cacheManager.getSingleFile(notification.icon!);

              final pictureInfo = await vg.loadPicture(SvgFileLoader(file), null);

              const largeIconSize = 256;
              final scale = largeIconSize / pictureInfo.size.longestSide;
              final scaledSize = pictureInfo.size * scale;

              final recorder = PictureRecorder();
              Canvas(recorder)
                ..scale(scale)
                ..drawPicture(pictureInfo.picture)
                ..drawColor(NcColors.primary, BlendMode.srcIn);

              pictureInfo.picture.dispose();

              final image = recorder.endRecording().toImageSync(scaledSize.width.toInt(), scaledSize.height.toInt());
              final bytes = await image.toByteData(format: ImageByteFormat.png);

              largeIconBitmap = ByteArrayAndroidBitmap(img.encodeBmp(img.decodePng(bytes!.buffer.asUint8List())!));
            }
          }
        } catch (e, s) {
          debugPrint(e.toString());
          debugPrint(s.toString());
        }

        if (notification?.shouldNotify ?? true) {
          final clientID = notification?.app ?? pushNotification.subject.app ?? 'nextcloud';
          String? clientName = localizations.clientImplementationName(clientID);
          if (clientName.isEmpty) {
            debugPrint('Missing client name for $clientID');
            clientName = null;
          }
          final title = (notification?.subject ?? pushNotification.subject.subject)!;
          final message = (notification?.message.isNotEmpty ?? false) ? notification!.message : null;
          final when = notification != null ? DateTime.parse(notification.datetime) : null;

          await localNotificationsPlugin.show(
            _getNotificationID(instance, pushNotification),
            message != null && clientName != null ? '$clientName: $title' : title,
            message,
            NotificationDetails(
              android: AndroidNotificationDetails(
                clientID,
                clientName ?? clientID,
                subText: accounts.length > 1 && account != null ? account.humanReadableID : null,
                groupKey: 'app_$clientID',
                icon: '@mipmap/ic_launcher',
                largeIcon: largeIconBitmap,
                when: when?.millisecondsSinceEpoch,
                color: NcColors.primary,
                category: pushNotification.type == 'voip' ? AndroidNotificationCategory.call : null,
                importance: Importance.max,
                priority: pushNotification.priority == 'high'
                    ? (pushNotification.type == 'voip' ? Priority.max : Priority.high)
                    : Priority.defaultPriority,
              ),
            ),
            payload: json.encode(pushNotification.toJson()),
          );
        }
      }

      await Global.onPushNotificationReceived?.call(instance);
    }
  }

  static int _getNotificationID(
    final String instance,
    final PushNotification notification,
  ) =>
      sha256.convert(utf8.encode('$instance${notification.subject.nid}')).bytes.reduce((final a, final b) => a + b);
}
