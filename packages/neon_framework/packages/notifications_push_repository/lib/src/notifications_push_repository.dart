import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:account_repository/account_repository.dart';
import 'package:built_collection/built_collection.dart';
import 'package:crypton/crypton.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:neon_framework/storage.dart';
import 'package:nextcloud/notifications.dart' as notifications;
import 'package:notifications_push_repository/src/models/models.dart';
import 'package:notifications_push_repository/src/utils/encryption.dart';
import 'package:unifiedpush/unifiedpush.dart';

part 'notifications_push_storage.dart';

/// Signature of the callback triggered by UnifiedPush when a new push notification is received.
typedef OnMessageCallback = void Function(Uint8List message, String accountID);

final _log = Logger('NotificationsPushRepository');

/// A repository for managing push notifications and subscriptions.
class NotificationsPushRepository {
  /// Creates a new [NotificationsPushRepository].
  NotificationsPushRepository({
    required AccountRepository accountRepository,
    required NotificationsPushStorage storage,
    required OnMessageCallback onMessage,
  })  : _accountRepository = accountRepository,
        _storage = storage,
        _onMessage = onMessage {
    _accountRepository.registerBeforeLogOutCallback(_beforeLogOutCallback);
  }

  final AccountRepository _accountRepository;
  final NotificationsPushStorage _storage;
  final OnMessageCallback _onMessage;
  var _initialized = false;
  StreamSubscription<BuiltList<Account>>? _accountsListener;
  late final RSAPrivateKey _privateKey;
  String? _selectedDistributor;

  /// Returns all available distributors.
  Future<BuiltList<String>> get distributors async {
    final distributors = await UnifiedPush.getDistributors();
    return distributors.toBuiltList();
  }

  /// Closes all open resources of the repository.
  void close() {
    unawaited(_accountsListener?.cancel());
    _accountRepository.unregisterBeforeLogOutCallback(_beforeLogOutCallback);
  }

  Future<void> _beforeLogOutCallback(Account account) async {
    final subscriptions = await _storage.readSubscriptions();
    var subscription = subscriptions[account.id];
    if (subscription == null) {
      return;
    }

    final pushDevice = subscription.pushDevice;
    if (pushDevice != null) {
      await _unregisterNextcloud(account.id, account, pushDevice);
      subscription = subscription.rebuild((b) => b.pushDevice = null);
    }

    if (subscription.endpoint != null) {
      await _unregisterUnifiedPush(account.id);
      subscription = subscription.rebuild((b) => b.endpoint = null);
    }

    await _storage.updateSubscription(account.id, subscription);
  }

  /// Changes the used distributor to the new [distributor].
  Future<void> changeDistributor(String? distributor) async {
    if (!_initialized) {
      throw StateError('Repository not initialized');
    }

    if (distributor == _selectedDistributor) {
      return;
    }

    _selectedDistributor = distributor;
    await _updateSubscriptions(distributorChanged: true);
  }

  /// Initializes the repository.
  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    _accountsListener = _accountRepository.accounts.skip(1).map((e) => e.accounts).listen((accounts) async {
      await _updateSubscriptions();
    });

    _selectedDistributor = await UnifiedPush.getDistributor();

    _privateKey = await getDevicePrivateKey(_storage);

    await UnifiedPush.initialize(
      onNewEndpoint: (endpoint, accountID) async {
        final account = _accountRepository.accountByID(accountID);
        if (account == null) {
          _log.finer('Account $accountID not found'); // coverage:ignore-line
          return;
        }

        final subscriptions = await _storage.readSubscriptions();
        var subscription = subscriptions[account.id] ?? PushSubscription();
        if (subscription.endpoint == endpoint) {
          _log.fine('UnifiedPush endpoint not changed for ${account.id}');
          return;
        }
        subscription = subscription.rebuild((b) => b.endpoint = endpoint);

        var pushDevice = subscription.pushDevice;
        if (pushDevice != null) {
          await _unregisterNextcloud(accountID, account, pushDevice);
          subscription = subscription.rebuild((b) => b.pushDevice = null);
        }

        pushDevice = await _registerNextcloud(account, endpoint);
        subscription = subscription.rebuild((b) {
          if (pushDevice == null) {
            b.pushDevice = null;
          } else {
            b.pushDevice.replace(pushDevice);
          }
        });

        await _storage.updateSubscription(account.id, subscription);
      },
      onUnregistered: (accountID) async {
        final account = _accountRepository.accountByID(accountID);
        if (account == null) {
          _log.finer('Account $accountID not found'); // coverage:ignore-line
          return;
        }

        final subscriptions = await _storage.readSubscriptions();
        var subscription = subscriptions[accountID];
        if (subscription == null) {
          _log.finer('Subscription for $accountID not found'); // coverage:ignore-line
          return;
        }

        subscription = subscription.rebuild((b) => b.endpoint = null);
        final pushDevice = subscription.pushDevice;
        if (pushDevice != null) {
          await _unregisterNextcloud(accountID, account, pushDevice);
          subscription = subscription.rebuild((b) => b.pushDevice = null);
        }

        await _storage.updateSubscription(accountID, subscription);
      },
      onMessage: _onMessage,
    );

    await _updateSubscriptions();

    _initialized = true;
  }

  Future<void> _updateSubscriptions({bool distributorChanged = false}) async {
    if (_selectedDistributor == null) {
      _log.fine('Push notifications disabled, removing all subscriptions');

      await _unregisterAllUnifiedPush();
      return;
    }

    if (distributorChanged) {
      _log.finer('UnifiedPush distributor changed to $_selectedDistributor');

      await _unregisterAllUnifiedPush();
      await UnifiedPush.saveDistributor(_selectedDistributor!);
    }

    await _registerAllUnifiedPush();
  }

  Future<void> _registerAllUnifiedPush() async {
    // Notifications will only work on accounts with app password
    final accounts = (await _accountRepository.accounts.first).accounts;
    for (final account in accounts.where((a) => a.credentials.appPassword != null)) {
      _log.finer('Registering ${account.id} for UnifiedPush');

      await UnifiedPush.registerApp(account.id);
    }
  }

  Future<void> _unregisterAllUnifiedPush() async {
    final subscriptions = await _storage.readSubscriptions();
    for (final entry in subscriptions.entries) {
      final accountID = entry.key;
      final account = _accountRepository.accountByID(accountID);
      var subscription = entry.value;

      final pushDevice = subscription.pushDevice;
      if (pushDevice != null) {
        await _unregisterNextcloud(accountID, account, pushDevice);
        subscription = subscription.rebuild((b) => b.pushDevice = null);
      }

      if (subscription.endpoint != null) {
        await _unregisterUnifiedPush(accountID);
        subscription = subscription.rebuild((b) => b.endpoint = null);
      }

      await _storage.updateSubscription(accountID, subscription);
    }
  }

  Future<notifications.PushDevice?> _registerNextcloud(Account account, String endpoint) async {
    _log.finer('Registering ${account.id} at Nextcloud');

    try {
      final response = await account.client.notifications.push.registerDevice(
        $body: notifications.PushRegisterDeviceRequestApplicationJson(
          (b) => b
            ..pushTokenHash = notifications.generatePushTokenHash(endpoint)
            ..devicePublicKey = _privateKey.publicKey.toFormattedPEM()
            ..proxyServer = '$endpoint#',
        ),
      );

      return response.body.ocs.data;
    } on http.ClientException catch (error) {
      _log.warning('Failed to register ${account.id} at Nextcloud', error);
    }

    return null;
  }

  Future<void> _unregisterNextcloud(
    String accountID,
    Account? account,
    notifications.PushDevice pushDevice,
  ) async {
    _log.finer('Unregistering $accountID from Nextcloud');

    try {
      await account?.client.notifications.push.removeDevice();
    } on http.ClientException catch (error) {
      _log.warning('Failed to unregister $accountID at Nextcloud', error);
    }
  }

  Future<void> _unregisterUnifiedPush(String accountID) async {
    _log.finer('Unregistering $accountID from UnifiedPush');

    await UnifiedPush.unregister(accountID);
  }
}
