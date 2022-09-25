import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:neon/src/blocs/accounts.dart';
import 'package:neon/src/models/account.dart';
import 'package:neon/src/neon.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unifiedpush/unifiedpush.dart';

part 'push_notifications.rxb.g.dart';

abstract class PushNotificationsBlocEvents {}

abstract class PushNotificationsBlocStates {
  Stream<NextcloudPushNotification> get notifications;
}

@RxBloc()
class PushNotificationsBloc extends $PushNotificationsBloc {
  PushNotificationsBloc(
    this._accountsBloc,
    this._sharedPreferences,
    this._globalOptions,
    this._env,
    this._platform,
  ) {
    if (_platform.canUsePushNotifications) {
      unawaited(UnifiedPush.getDistributors().then(_globalOptions.updateDistributors));

      _globalOptions.pushNotificationsEnabled.stream.listen((final enabled) async {
        if (enabled != _pushNotificationsEnabled) {
          _pushNotificationsEnabled = enabled;
          if (enabled) {
            // We just use a single RSA keypair for all accounts
            _keypair = await PushUtils.loadRSAKeypair(_storage);
            await _setupUnifiedPush();
          }
        }
      });
    }
  }

  Future _setupUnifiedPush() async {
    await UnifiedPush.initialize(
      onNewEndpoint: (final endpoint, final instance) async {
        final account = _accountsBloc.accounts.value.find(instance);
        if (account == null) {
          debugPrint('Account for $instance not found, can not process endpoint');
          return;
        }

        if (_storage.getString(_keyLastEndpoint(account)) == endpoint) {
          debugPrint('Endpoint not changed');
          return;
        }

        debugPrint('Registering account $instance for push notifications on $endpoint');

        var proxyServerForNextcloud = 'https://nc.proxy.neon.provokateurin.de/';
        var proxyServerForClient = proxyServerForNextcloud;
        if (_env != null) {
          proxyServerForNextcloud = 'http://host.docker.internal:8080/';
          proxyServerForClient = 'http://${_env!.testHost}:8080/';
        }

        final subscription = await account.client.notifications.registerDevice(
          pushTokenHash: account.client.notifications.generatePushTokenHash(endpoint),
          devicePublicKey: _keypair!.publicKey.toFormattedPEM(),
          proxyServer: proxyServerForNextcloud,
        );

        await account.client.notifications.registerDeviceAtPushProxy(
          endpoint,
          subscription.ocs!.data!,
          proxyServerForClient,
        );

        await _storage.setString(_keyLastEndpoint(account), endpoint);

        debugPrint('Account $instance registered for push notifications');
      },
      onMessage: PushUtils.onMessage,
    );

    _globalOptions.pushNotificationsDistributor.stream.listen((final distributor) async {
      final disabled = distributor == null;
      final sameDistributor = distributor == await UnifiedPush.getDistributor();
      final accounts = _accountsBloc.accounts.value;
      if (disabled || !sameDistributor) {
        await _unregisterUnifiedPushInstances(accounts);
      }
      if (!disabled && !sameDistributor) {
        debugPrint('UnifiedPush distributor changed to $distributor');
        await UnifiedPush.saveDistributor(distributor);
      }
      if (!disabled) {
        await _registerUnifiedPushInstances(accounts);
      }
    });

    _accountsBloc.accounts.listen(_registerUnifiedPushInstances);
  }

  Future _unregisterUnifiedPushInstances(final List<Account> accounts) async {
    for (final account in accounts) {
      await UnifiedPush.unregister(account.client.id);
    }
  }

  Future _registerUnifiedPushInstances(final List<Account> accounts) async {
    // Notifications will only work on accounts with app password
    for (final account in accounts.where((final a) => a.appPassword != null)) {
      await UnifiedPush.registerApp(account.client.id);
    }
  }

  final AccountsBloc _accountsBloc;
  final NeonPlatform _platform;
  final SharedPreferences _sharedPreferences;
  late final _storage = Storage('notifications', _sharedPreferences);
  final GlobalOptions _globalOptions;
  final Env? _env;
  RSAKeypair? _keypair;
  bool? _pushNotificationsEnabled;

  String _keyLastEndpoint(final Account account) => 'last-endpoint-${account.id}';

  final _notificationsController = StreamController<NextcloudPushNotification>();

  @override
  void dispose() {
    unawaited(_notificationsController.close());
    super.dispose();
  }

  @override
  Stream<NextcloudPushNotification> _mapToNotificationsState() => _notificationsController.stream.asBroadcastStream();
}

class NextcloudPushNotification {
  NextcloudPushNotification({
    required this.instance,
    required this.priority,
    required this.type,
    required this.subject,
  });

  final String instance;
  final String priority;
  final String type;
  final NotificationsPushNotificationDecryptedSubject subject;
}
