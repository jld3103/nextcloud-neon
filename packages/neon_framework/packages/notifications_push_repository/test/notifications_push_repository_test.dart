// ignore_for_file: discarded_futures
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:account_repository/account_repository.dart';
import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:crypton/crypton.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:neon_framework/testing.dart';
import 'package:nextcloud/notifications.dart' as notifications;
import 'package:notifications_push_repository/notifications_push_repository.dart';
import 'package:notifications_push_repository/src/models/models.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unifiedpush_platform_interface/unifiedpush_platform_interface.dart';

class _AccountRepositoryMock extends Mock implements AccountRepository {}

class _StorageMock extends Mock implements NotificationsPushStorage {}

class _OnMessageCallbackMock extends Mock {
  void call(Uint8List message, String accountID);
}

class _UnifiedPushPlatformMock extends Mock with MockPlatformInterfaceMixin implements UnifiedPushPlatform {}

class _HttpRequestCallbackMock extends Mock {
  http.StreamedResponse call(String method, Uri url, BuiltMap<String, String> headers, Uint8List body);
}

class _HttpClientMock extends Mock implements http.Client {
  _HttpClientMock(this._callback);

  final _HttpRequestCallbackMock _callback;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final body = await request.finalize().toBytes();
    return _callback(
      request.method.toUpperCase(),
      request.url,
      BuiltMap(request.headers),
      body,
    );
  }
}

void main() {
  group('NotificationsPushRepository', () {
    late BehaviorSubject<BuiltList<Account>> accountsSubject;
    late AccountRepository accountRepository;
    late NotificationsPushStorage storage;
    late OnMessageCallback onMessageCallback;
    late UnifiedPushPlatform unifiedPushPlatform;
    late NotificationsPushRepository repository;
    void Function(String, String)? unifiedPushOnNewEndpoint;
    void Function(String)? unifiedPushOnUnregistered;
    void Function(Uint8List, String)? unifiedPushOnMessage;
    late List<BeforeLogOutCallback> beforeLogOutCallbacks;

    setUpAll(() {
      registerFallbackValue(RSAPrivateKey(BigInt.zero, BigInt.zero, BigInt.zero, BigInt.zero));
      registerFallbackValue(PushSubscription());
      registerFallbackValue(Uri());
      registerFallbackValue(BuiltMap<String, String>());
      registerFallbackValue(Uint8List(0));

      FakeNeonStorage.setup();
    });

    setUp(() {
      beforeLogOutCallbacks = [];
      accountsSubject = BehaviorSubject();
      accountRepository = _AccountRepositoryMock();
      when(() => accountRepository.accounts).thenAnswer((_) => accountsSubject.map((e) => (active: null, accounts: e)));
      when(() => accountRepository.accountByID(any())).thenAnswer(
        (invocation) {
          final accountID = invocation.positionalArguments[0] as String;
          return accountsSubject.value.singleWhereOrNull((account) => account.id == accountID);
        },
      );
      when(() => accountRepository.registerBeforeLogOutCallback(any())).thenAnswer((invocation) {
        beforeLogOutCallbacks.add(invocation.positionalArguments.first as BeforeLogOutCallback);
      });
      when(() => accountRepository.unregisterBeforeLogOutCallback(any())).thenAnswer((invocation) {
        beforeLogOutCallbacks.remove(invocation.positionalArguments.first as BeforeLogOutCallback);
      });

      storage = _StorageMock();

      onMessageCallback = _OnMessageCallbackMock().call;

      unifiedPushPlatform = _UnifiedPushPlatformMock();
      when(
        () => unifiedPushPlatform.initializeCallback(
          onNewEndpoint: any(named: 'onNewEndpoint'),
          onRegistrationFailed: any(named: 'onRegistrationFailed'),
          onUnregistered: any(named: 'onUnregistered'),
          onMessage: any(named: 'onMessage'),
        ),
      ).thenAnswer((invocation) async {
        unifiedPushOnNewEndpoint = invocation.namedArguments[#onNewEndpoint] as void Function(String, String)?;
        unifiedPushOnUnregistered = invocation.namedArguments[#onUnregistered] as void Function(String)?;
        unifiedPushOnMessage = invocation.namedArguments[#onMessage] as void Function(Uint8List, String)?;
      });
      UnifiedPushPlatform.instance = unifiedPushPlatform;
    });

    tearDown(() {
      repository.close();
      expect(beforeLogOutCallbacks, isEmpty);
      unawaited(accountsSubject.close());
    });

    test('Generates new private key', () async {
      when(() => unifiedPushPlatform.getDistributor()).thenAnswer((_) async => null);

      when(() => storage.saveDevicePrivateKey(any())).thenAnswer((_) async {});
      when(() => storage.readSubscriptions()).thenAnswer((_) async => BuiltMap());

      accountsSubject.add(BuiltList([]));

      repository = NotificationsPushRepository(
        accountRepository: accountRepository,
        storage: storage,
        onMessage: onMessageCallback,
      );
      await repository.initialize();

      verify(() => storage.saveDevicePrivateKey(any())).called(1);
    });

    test('Returns the available distributors', () async {
      when(() => unifiedPushPlatform.getDistributor()).thenAnswer((_) async => null);
      when(() => unifiedPushPlatform.getDistributors(any())).thenAnswer((_) async => ['1', '2']);

      when(() => storage.saveDevicePrivateKey(any())).thenAnswer((_) async {});
      when(() => storage.readSubscriptions()).thenAnswer((_) async => BuiltMap());

      accountsSubject.add(BuiltList([]));

      repository = NotificationsPushRepository(
        accountRepository: accountRepository,
        storage: storage,
        onMessage: onMessageCallback,
      );
      await repository.initialize();

      await expectLater(repository.distributors, completion(equals(['1', '2'])));
    });

    test('Changing distributor saves it', () async {
      when(() => unifiedPushPlatform.getDistributor()).thenAnswer((_) async => null);
      when(() => unifiedPushPlatform.saveDistributor(any())).thenAnswer((_) async {});

      when(() => storage.saveDevicePrivateKey(any())).thenAnswer((_) async {});
      when(() => storage.readSubscriptions()).thenAnswer((_) async => BuiltMap());

      accountsSubject.add(BuiltList([]));

      repository = NotificationsPushRepository(
        accountRepository: accountRepository,
        storage: storage,
        onMessage: onMessageCallback,
      );
      await repository.initialize();

      await repository.changeDistributor('test');
      verify(() => unifiedPushPlatform.saveDistributor('test')).called(1);
      verifyNever(() => unifiedPushPlatform.saveDistributor(any()));

      await repository.changeDistributor('test');
      verifyNever(() => unifiedPushPlatform.saveDistributor(any()));
    });

    test('onMessage callback is called', () async {
      when(() => unifiedPushPlatform.getDistributor()).thenAnswer((_) async => null);
      when(() => unifiedPushPlatform.saveDistributor(any())).thenAnswer((_) async {});

      when(() => storage.saveDevicePrivateKey(any())).thenAnswer((_) async {});
      when(() => storage.readSubscriptions()).thenAnswer((_) async => BuiltMap());

      accountsSubject.add(BuiltList([]));

      repository = NotificationsPushRepository(
        accountRepository: accountRepository,
        storage: storage,
        onMessage: onMessageCallback,
      );
      await repository.initialize();

      unifiedPushOnMessage!(Uint8List(0), 'test');
      verify(() => onMessageCallback(Uint8List(0), 'test')).called(1);
      verifyNever(() => onMessageCallback(any(), any()));
    });

    group('onUnregistered callback removes subscription', () {
      late Account account;
      late _HttpRequestCallbackMock httpRequest;

      setUp(() {
        httpRequest = _HttpRequestCallbackMock();

        account = createAccount(
          credentials: createCredentials(
            serverURL: Uri.parse('https://cloud.example.com:8443/nextcloud'),
            username: 'user1',
            appPassword: 'user1',
          ),
          httpClient: _HttpClientMock(httpRequest),
        );

        when(() => unifiedPushPlatform.getDistributor()).thenAnswer((_) async => 'test');
        when(() => unifiedPushPlatform.saveDistributor(any())).thenAnswer((_) async {});
        final endpoint = Uri.parse('https://cloud.example.com:8443/nextcloud/unifiedpush');
        when(() => unifiedPushPlatform.registerApp(any(), any())).thenAnswer((invocation) async {
          unifiedPushOnNewEndpoint!.call(
            endpoint.toString(),
            invocation.positionalArguments[0] as String,
          );
        });
        when(() => unifiedPushPlatform.unregister(any())).thenAnswer((_) async {});

        when(() => storage.saveDevicePrivateKey(any())).thenAnswer((invocation) async {});
        final subscription = PushSubscription(
          (b) => b
            ..endpoint = 'https://cloud.example.com:8443/nextcloud/unifiedpush'
            ..pushDevice.update(
              (b) => b
                ..publicKey = 'publicKey'
                ..deviceIdentifier = 'deviceIdentifier'
                ..signature = 'signature',
            ),
        );
        var subscriptions = BuiltMap<String, PushSubscription>({account.id: subscription});
        when(() => storage.readSubscriptions()).thenAnswer((_) async => subscriptions);
        when(() => storage.updateSubscription(any(), any())).thenAnswer((invocation) async {
          subscriptions = subscriptions.rebuild(
            (b) {
              final key = invocation.positionalArguments[0] as String;
              final subscription = invocation.positionalArguments[1] as PushSubscription;
              if (subscription.endpoint == null && subscription.pushDevice == null) {
                b.remove(key);
              } else {
                b[key] = subscription;
              }
            },
          );
        });

        accountsSubject.add(BuiltList([account]));
      });

      test('Success at Nextcloud', () async {
        when(
          () => httpRequest(
            'DELETE',
            Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
            any(),
            any(),
          ),
        ).thenAnswer(
          (_) => http.StreamedResponse(
            Stream.value(
              utf8.encode(
                json.encode(
                  {
                    'ocs': {
                      'meta': {
                        'status': '',
                        'statuscode': 0,
                      },
                      'data': <dynamic, dynamic>{},
                    },
                  },
                ),
              ),
            ),
            200,
            headers: {
              'content-type': 'application/json; charset=utf-8',
            },
          ),
        );

        repository = NotificationsPushRepository(
          accountRepository: accountRepository,
          storage: storage,
          onMessage: onMessageCallback,
        );
        await repository.initialize();

        verify(() => unifiedPushPlatform.registerApp(account.id, [])).called(1);
        verifyNever(() => unifiedPushPlatform.registerApp(any(), any()));

        unifiedPushOnUnregistered!(account.id);
        await Future<void>.delayed(const Duration(milliseconds: 1));

        verifyNever(() => unifiedPushPlatform.unregister(any()));
        verify(
          () => httpRequest(
            'DELETE',
            Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
            BuiltMap(
              {
                'Accept': 'application/json',
                'Authorization': 'Bearer user1',
                'OCS-APIRequest': 'true',
                'user-agent': 'neon',
              },
            ),
            Uint8List(0),
          ),
        ).called(1);
        verifyNever(() => httpRequest(any(), any(), any(), any()));
        verify(() => storage.updateSubscription(account.id, PushSubscription())).called(1);
        verifyNever(() => storage.updateSubscription(any(), any()));
      });

      test('Failure at Nextcloud', () async {
        when(
          () => httpRequest(
            'DELETE',
            Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
            any(),
            any(),
          ),
        ).thenAnswer((_) => http.StreamedResponse(const Stream.empty(), 500));

        repository = NotificationsPushRepository(
          accountRepository: accountRepository,
          storage: storage,
          onMessage: onMessageCallback,
        );
        await repository.initialize();

        verify(() => unifiedPushPlatform.registerApp(account.id, [])).called(1);
        verifyNever(() => unifiedPushPlatform.registerApp(any(), any()));

        unifiedPushOnUnregistered!(account.id);
        await Future<void>.delayed(const Duration(milliseconds: 1));

        verifyNever(() => unifiedPushPlatform.unregister(any()));
        verify(
          () => httpRequest(
            'DELETE',
            Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
            BuiltMap(
              {
                'Accept': 'application/json',
                'Authorization': 'Bearer user1',
                'OCS-APIRequest': 'true',
                'user-agent': 'neon',
              },
            ),
            Uint8List(0),
          ),
        ).called(1);
        verifyNever(() => httpRequest(any(), any(), any(), any()));
        verify(() => storage.updateSubscription(account.id, PushSubscription())).called(1);
        verifyNever(() => storage.updateSubscription(any(), any()));
      });
    });

    group('Removes subscriptions for missing accounts', () {
      test('Without endpoint and pushDevice', () async {
        when(() => unifiedPushPlatform.getDistributor()).thenAnswer((_) async => null);
        when(() => unifiedPushPlatform.unregister(any())).thenAnswer((_) async {});

        when(() => storage.saveDevicePrivateKey(any())).thenAnswer((_) async {});
        final subscription = PushSubscription();
        when(() => storage.readSubscriptions()).thenAnswer((_) async => BuiltMap({'1': subscription}));
        when(() => storage.updateSubscription(any(), any())).thenAnswer((_) async {});

        accountsSubject.add(BuiltList([]));

        repository = NotificationsPushRepository(
          accountRepository: accountRepository,
          storage: storage,
          onMessage: onMessageCallback,
        );
        await repository.initialize();

        verifyNever(() => unifiedPushPlatform.unregister(any()));
        verify(() => storage.updateSubscription('1', PushSubscription())).called(1);
        verifyNever(() => storage.updateSubscription(any(), any()));
      });

      test('With endpoint', () async {
        when(() => unifiedPushPlatform.getDistributor()).thenAnswer((_) async => null);
        when(() => unifiedPushPlatform.unregister(any())).thenAnswer((_) async {});

        when(() => storage.saveDevicePrivateKey(any())).thenAnswer((_) async {});
        final subscription = PushSubscription(
          (b) => b..endpoint = 'endpoint',
        );
        when(() => storage.readSubscriptions()).thenAnswer((_) async => BuiltMap({'1': subscription}));
        when(() => storage.updateSubscription(any(), any())).thenAnswer((_) async {});

        accountsSubject.add(BuiltList([]));

        repository = NotificationsPushRepository(
          accountRepository: accountRepository,
          storage: storage,
          onMessage: onMessageCallback,
        );
        await repository.initialize();

        verify(() => unifiedPushPlatform.unregister('1')).called(1);
        verifyNever(() => unifiedPushPlatform.unregister(any()));
        verify(() => storage.updateSubscription('1', PushSubscription())).called(1);
        verifyNever(() => storage.updateSubscription(any(), any()));
      });

      test('With pushDevice', () async {
        when(() => unifiedPushPlatform.getDistributor()).thenAnswer((_) async => null);
        when(() => unifiedPushPlatform.unregister(any())).thenAnswer((_) async {});

        when(() => storage.saveDevicePrivateKey(any())).thenAnswer((_) async {});
        final subscription = PushSubscription(
          (b) => b
            ..pushDevice.update(
              (b) => b
                ..publicKey = 'publicKey'
                ..deviceIdentifier = 'deviceIdentifier'
                ..signature = 'signature',
            ),
        );
        when(() => storage.readSubscriptions()).thenAnswer((_) async => BuiltMap({'1': subscription}));
        when(() => storage.updateSubscription(any(), any())).thenAnswer((_) async {});

        accountsSubject.add(BuiltList([]));

        repository = NotificationsPushRepository(
          accountRepository: accountRepository,
          storage: storage,
          onMessage: onMessageCallback,
        );
        await repository.initialize();

        verifyNever(() => unifiedPushPlatform.unregister(any()));
        verify(() => storage.updateSubscription('1', PushSubscription())).called(1);
        verifyNever(() => storage.updateSubscription(any(), any()));
      });

      test('With endpoint and pushDevice', () async {
        when(() => unifiedPushPlatform.getDistributor()).thenAnswer((_) async => null);
        when(() => unifiedPushPlatform.unregister(any())).thenAnswer((_) async {});

        when(() => storage.saveDevicePrivateKey(any())).thenAnswer((_) async {});
        final subscription = PushSubscription(
          (b) => b
            ..endpoint = 'endpoint'
            ..pushDevice.update(
              (b) => b
                ..publicKey = 'publicKey'
                ..deviceIdentifier = 'deviceIdentifier'
                ..signature = 'signature',
            ),
        );
        when(() => storage.readSubscriptions()).thenAnswer((_) async => BuiltMap({'1': subscription}));
        when(() => storage.updateSubscription(any(), any())).thenAnswer((_) async {});

        accountsSubject.add(BuiltList([]));

        repository = NotificationsPushRepository(
          accountRepository: accountRepository,
          storage: storage,
          onMessage: onMessageCallback,
        );
        await repository.initialize();

        verify(() => unifiedPushPlatform.unregister('1')).called(1);
        verifyNever(() => unifiedPushPlatform.unregister(any()));
        verify(() => storage.updateSubscription('1', PushSubscription())).called(1);
        verifyNever(() => storage.updateSubscription(any(), any()));
      });
    });

    group('Creates, updates and removes subscriptions for accounts', () {
      late Account account;
      late _HttpRequestCallbackMock httpRequest;
      late Uri endpoint;
      late RSAPrivateKey privateKey;

      setUp(() {
        httpRequest = _HttpRequestCallbackMock();

        account = createAccount(
          credentials: createCredentials(
            serverURL: Uri.parse('https://cloud.example.com:8443/nextcloud'),
            username: 'user1',
            appPassword: 'user1',
          ),
          httpClient: _HttpClientMock(httpRequest),
        );

        when(() => unifiedPushPlatform.getDistributor()).thenAnswer((_) async => 'test');
        when(() => unifiedPushPlatform.saveDistributor(any())).thenAnswer((_) async {});
        endpoint = Uri.parse('https://cloud.example.com:8443/nextcloud/unifiedpush');
        when(() => unifiedPushPlatform.registerApp(any(), any())).thenAnswer((invocation) async {
          unifiedPushOnNewEndpoint!.call(
            endpoint.toString(),
            invocation.positionalArguments[0] as String,
          );
        });
        when(() => unifiedPushPlatform.unregister(any())).thenAnswer((_) async {});

        when(() => storage.saveDevicePrivateKey(any())).thenAnswer((invocation) async {
          privateKey = invocation.positionalArguments[0] as RSAPrivateKey;
        });

        accountsSubject.add(BuiltList([account]));
      });

      group('Creates subscriptions for accounts', () {
        group('Existing accounts', () {
          setUp(() {
            when(() => storage.readSubscriptions()).thenAnswer((_) async => BuiltMap());
            when(() => storage.updateSubscription(any(), any())).thenAnswer((_) async {});
          });

          test('Success at Nextcloud', () async {
            when(
              () => httpRequest(
                'POST',
                Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                any(),
                any(),
              ),
            ).thenAnswer(
              (_) => http.StreamedResponse(
                Stream.value(
                  utf8.encode(
                    json.encode(
                      {
                        'ocs': {
                          'meta': {
                            'status': '',
                            'statuscode': 0,
                          },
                          'data': {
                            'publicKey': 'publicKey',
                            'deviceIdentifier': 'deviceIdentifier',
                            'signature': 'signature',
                          },
                        },
                      },
                    ),
                  ),
                ),
                201,
                headers: {
                  'content-type': 'application/json; charset=utf-8',
                },
              ),
            );

            repository = NotificationsPushRepository(
              accountRepository: accountRepository,
              storage: storage,
              onMessage: onMessageCallback,
            );
            await repository.initialize();

            await repository.changeDistributor('test');

            await Future<void>.delayed(const Duration(milliseconds: 1));

            verify(() => unifiedPushPlatform.registerApp(account.id, [])).called(1);
            verifyNever(() => unifiedPushPlatform.registerApp(any(), any()));
            verify(
              () => httpRequest(
                'POST',
                Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                BuiltMap(
                  {
                    'Accept': 'application/json',
                    'Authorization': 'Bearer user1',
                    'OCS-APIRequest': 'true',
                    'Content-Type': 'application/json; charset=utf-8',
                    'user-agent': 'neon',
                  },
                ),
                utf8.encode(
                  json.encode(
                    notifications.PushRegisterDeviceRequestApplicationJson(
                      (b) => b
                        ..pushTokenHash = notifications.generatePushTokenHash(endpoint.toString())
                        ..devicePublicKey = privateKey.publicKey.toFormattedPEM()
                        ..proxyServer = '$endpoint#',
                    ),
                  ),
                ),
              ),
            ).called(1);
            verifyNever(() => httpRequest(any(), any(), any(), any()));
            final expectedSubscription = PushSubscription(
              (b) => b
                ..endpoint = 'https://cloud.example.com:8443/nextcloud/unifiedpush'
                ..pushDevice.update(
                  (b) => b
                    ..publicKey = 'publicKey'
                    ..deviceIdentifier = 'deviceIdentifier'
                    ..signature = 'signature',
                ),
            );
            verify(() => storage.updateSubscription(account.id, expectedSubscription)).called(1);
            verifyNever(() => storage.updateSubscription(any(), any()));
          });

          test('Failure at Nextcloud', () async {
            when(
              () => httpRequest(
                'POST',
                Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                any(),
                any(),
              ),
            ).thenAnswer((_) => http.StreamedResponse(const Stream.empty(), 500));

            repository = NotificationsPushRepository(
              accountRepository: accountRepository,
              storage: storage,
              onMessage: onMessageCallback,
            );
            await repository.initialize();

            await repository.changeDistributor('test');

            await Future<void>.delayed(const Duration(milliseconds: 1));

            verify(() => unifiedPushPlatform.registerApp(account.id, [])).called(1);
            verifyNever(() => unifiedPushPlatform.registerApp(any(), any()));
            verify(
              () => httpRequest(
                'POST',
                Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                BuiltMap(
                  {
                    'Accept': 'application/json',
                    'Authorization': 'Bearer user1',
                    'OCS-APIRequest': 'true',
                    'Content-Type': 'application/json; charset=utf-8',
                    'user-agent': 'neon',
                  },
                ),
                utf8.encode(
                  json.encode(
                    notifications.PushRegisterDeviceRequestApplicationJson(
                      (b) => b
                        ..pushTokenHash = notifications.generatePushTokenHash(endpoint.toString())
                        ..devicePublicKey = privateKey.publicKey.toFormattedPEM()
                        ..proxyServer = '$endpoint#',
                    ),
                  ),
                ),
              ),
            ).called(1);
            verifyNever(() => httpRequest(any(), any(), any(), any()));
            final expectedSubscription = PushSubscription(
              (b) => b..endpoint = 'https://cloud.example.com:8443/nextcloud/unifiedpush',
            );
            verify(() => storage.updateSubscription(account.id, expectedSubscription)).called(1);
            verifyNever(() => storage.updateSubscription(any(), any()));
          });
        });

        group('New accounts', () {
          late Account newAccount;
          late PushSubscription subscription;

          setUp(() {
            newAccount = createAccount(
              credentials: createCredentials(
                serverURL: Uri.parse('https://cloud.example.com:8443/nextcloud'),
                username: 'user2',
                appPassword: 'user2',
              ),
              httpClient: _HttpClientMock(httpRequest),
            );

            subscription = PushSubscription(
              (b) => b
                ..endpoint = 'https://cloud.example.com:8443/nextcloud/unifiedpush'
                ..pushDevice.update(
                  (b) => b
                    ..publicKey = 'publicKey'
                    ..deviceIdentifier = 'deviceIdentifier'
                    ..signature = 'signature',
                ),
            );
            var subscriptions = BuiltMap<String, PushSubscription>({account.id: subscription});
            when(() => storage.readSubscriptions()).thenAnswer((_) async => subscriptions);
            when(() => storage.updateSubscription(any(), any())).thenAnswer((invocation) async {
              subscriptions = subscriptions.rebuild(
                (b) {
                  final key = invocation.positionalArguments[0] as String;
                  final subscription = invocation.positionalArguments[1] as PushSubscription;
                  if (subscription.endpoint == null && subscription.pushDevice == null) {
                    b.remove(key);
                  } else {
                    b[key] = subscription;
                  }
                },
              );
            });
          });

          test('Success at Nextcloud', () async {
            when(
              () => httpRequest(
                'POST',
                Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                any(),
                any(),
              ),
            ).thenAnswer(
              (_) => http.StreamedResponse(
                Stream.value(
                  utf8.encode(
                    json.encode(
                      {
                        'ocs': {
                          'meta': {
                            'status': '',
                            'statuscode': 0,
                          },
                          'data': {
                            'publicKey': 'new-publicKey',
                            'deviceIdentifier': 'new-deviceIdentifier',
                            'signature': 'new-signature',
                          },
                        },
                      },
                    ),
                  ),
                ),
                201,
                headers: {
                  'content-type': 'application/json; charset=utf-8',
                },
              ),
            );

            repository = NotificationsPushRepository(
              accountRepository: accountRepository,
              storage: storage,
              onMessage: onMessageCallback,
            );
            await repository.initialize();

            verify(() => unifiedPushPlatform.registerApp(account.id, [])).called(1);

            accountsSubject.add(BuiltList([account, newAccount]));

            await Future<void>.delayed(const Duration(milliseconds: 1));

            verify(() => unifiedPushPlatform.registerApp(account.id, [])).called(1);
            verify(() => unifiedPushPlatform.registerApp(newAccount.id, [])).called(1);
            verifyNever(() => unifiedPushPlatform.registerApp(any(), any()));
            verify(
              () => httpRequest(
                'POST',
                Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                BuiltMap(
                  {
                    'Accept': 'application/json',
                    'Authorization': 'Bearer user2',
                    'OCS-APIRequest': 'true',
                    'Content-Type': 'application/json; charset=utf-8',
                    'user-agent': 'neon',
                  },
                ),
                utf8.encode(
                  json.encode(
                    notifications.PushRegisterDeviceRequestApplicationJson(
                      (b) => b
                        ..pushTokenHash = notifications.generatePushTokenHash(endpoint.toString())
                        ..devicePublicKey = privateKey.publicKey.toFormattedPEM()
                        ..proxyServer = '$endpoint#',
                    ),
                  ),
                ),
              ),
            ).called(1);
            verifyNever(() => httpRequest(any(), any(), any(), any()));
            final expectedSubscription = PushSubscription(
              (b) => b
                ..endpoint = 'https://cloud.example.com:8443/nextcloud/unifiedpush'
                ..pushDevice.update(
                  (b) => b
                    ..publicKey = 'new-publicKey'
                    ..deviceIdentifier = 'new-deviceIdentifier'
                    ..signature = 'new-signature',
                ),
            );
            verify(() => storage.updateSubscription(newAccount.id, expectedSubscription)).called(1);
            verifyNever(() => storage.updateSubscription(any(), any()));
          });

          test('Failure at Nextcloud', () async {
            when(
              () => httpRequest(
                'POST',
                Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                any(),
                any(),
              ),
            ).thenAnswer((_) => http.StreamedResponse(const Stream.empty(), 500));

            repository = NotificationsPushRepository(
              accountRepository: accountRepository,
              storage: storage,
              onMessage: onMessageCallback,
            );
            await repository.initialize();

            verify(() => unifiedPushPlatform.registerApp(account.id, [])).called(1);

            accountsSubject.add(BuiltList([account, newAccount]));

            await Future<void>.delayed(const Duration(milliseconds: 1));

            verify(() => unifiedPushPlatform.registerApp(account.id, [])).called(1);
            verify(() => unifiedPushPlatform.registerApp(newAccount.id, [])).called(1);
            verifyNever(() => unifiedPushPlatform.registerApp(any(), any()));
            verify(
              () => httpRequest(
                'POST',
                Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                BuiltMap(
                  {
                    'Accept': 'application/json',
                    'Authorization': 'Bearer user2',
                    'OCS-APIRequest': 'true',
                    'Content-Type': 'application/json; charset=utf-8',
                    'user-agent': 'neon',
                  },
                ),
                utf8.encode(
                  json.encode(
                    notifications.PushRegisterDeviceRequestApplicationJson(
                      (b) => b
                        ..pushTokenHash = notifications.generatePushTokenHash(endpoint.toString())
                        ..devicePublicKey = privateKey.publicKey.toFormattedPEM()
                        ..proxyServer = '$endpoint#',
                    ),
                  ),
                ),
              ),
            ).called(1);
            verifyNever(() => httpRequest(any(), any(), any(), any()));
            final expectedSubscription = PushSubscription(
              (b) => b..endpoint = 'https://cloud.example.com:8443/nextcloud/unifiedpush',
            );
            verify(() => storage.updateSubscription(newAccount.id, expectedSubscription)).called(1);
            verifyNever(() => storage.updateSubscription(any(), any()));
          });
        });
      });

      group('Updates and removes subscriptions for accounts', () {
        setUp(() {
          final subscription = PushSubscription(
            (b) => b
              ..endpoint = 'https://cloud.example.com:8443/nextcloud/unifiedpush'
              ..pushDevice.update(
                (b) => b
                  ..publicKey = 'publicKey'
                  ..deviceIdentifier = 'deviceIdentifier'
                  ..signature = 'signature',
              ),
          );
          var subscriptions = BuiltMap<String, PushSubscription>({account.id: subscription});
          when(() => storage.readSubscriptions()).thenAnswer((_) async => subscriptions);
          when(() => storage.updateSubscription(any(), any())).thenAnswer((invocation) async {
            subscriptions = subscriptions.rebuild(
              (b) {
                final key = invocation.positionalArguments[0] as String;
                final subscription = invocation.positionalArguments[1] as PushSubscription;
                if (subscription.endpoint == null && subscription.pushDevice == null) {
                  b.remove(key);
                } else {
                  b[key] = subscription;
                }
              },
            );
          });
        });

        group('Removes subscriptions for accounts', () {
          test('Success at Nextcloud', () async {
            when(
              () => httpRequest(
                'DELETE',
                Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                any(),
                any(),
              ),
            ).thenAnswer(
              (_) => http.StreamedResponse(
                Stream.value(
                  utf8.encode(
                    json.encode(
                      {
                        'ocs': {
                          'meta': {
                            'status': '',
                            'statuscode': 0,
                          },
                          'data': <dynamic, dynamic>{},
                        },
                      },
                    ),
                  ),
                ),
                200,
                headers: {
                  'content-type': 'application/json; charset=utf-8',
                },
              ),
            );

            repository = NotificationsPushRepository(
              accountRepository: accountRepository,
              storage: storage,
              onMessage: onMessageCallback,
            );
            await repository.initialize();

            verify(() => unifiedPushPlatform.registerApp(account.id, [])).called(1);
            verifyNever(() => unifiedPushPlatform.registerApp(any(), any()));

            await repository.changeDistributor(null);

            verify(() => unifiedPushPlatform.unregister(account.id)).called(1);
            verifyNever(() => unifiedPushPlatform.unregister(any()));
            verify(
              () => httpRequest(
                'DELETE',
                Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                BuiltMap(
                  {
                    'Accept': 'application/json',
                    'Authorization': 'Bearer user1',
                    'OCS-APIRequest': 'true',
                    'user-agent': 'neon',
                  },
                ),
                Uint8List(0),
              ),
            ).called(1);
            verifyNever(() => httpRequest(any(), any(), any(), any()));
            verify(() => storage.updateSubscription(account.id, PushSubscription())).called(1);
            verifyNever(() => storage.updateSubscription(any(), any()));
          });

          test('Failure at Nextcloud', () async {
            when(
              () => httpRequest(
                'DELETE',
                Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                any(),
                any(),
              ),
            ).thenAnswer((_) => http.StreamedResponse(const Stream.empty(), 500));

            repository = NotificationsPushRepository(
              accountRepository: accountRepository,
              storage: storage,
              onMessage: onMessageCallback,
            );
            await repository.initialize();

            verify(() => unifiedPushPlatform.registerApp(account.id, [])).called(1);
            verifyNever(() => unifiedPushPlatform.registerApp(any(), any()));

            await repository.changeDistributor(null);

            verify(() => unifiedPushPlatform.unregister(account.id)).called(1);
            verifyNever(() => unifiedPushPlatform.unregister(any()));
            verify(
              () => httpRequest(
                'DELETE',
                Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                BuiltMap(
                  {
                    'Accept': 'application/json',
                    'Authorization': 'Bearer user1',
                    'OCS-APIRequest': 'true',
                    'user-agent': 'neon',
                  },
                ),
                Uint8List(0),
              ),
            ).called(1);
            verifyNever(() => httpRequest(any(), any(), any(), any()));
            verify(() => storage.updateSubscription(account.id, PushSubscription())).called(1);
            verifyNever(() => storage.updateSubscription(any(), any()));
          });
        });

        group('Updates subscriptions when changing distributor', () {
          test('Success at Nextcloud', () async {
            when(
              () => httpRequest(
                'DELETE',
                Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                any(),
                any(),
              ),
            ).thenAnswer(
              (_) => http.StreamedResponse(
                Stream.value(
                  utf8.encode(
                    json.encode(
                      {
                        'ocs': {
                          'meta': {
                            'status': '',
                            'statuscode': 0,
                          },
                          'data': <dynamic, dynamic>{},
                        },
                      },
                    ),
                  ),
                ),
                200,
                headers: {
                  'content-type': 'application/json; charset=utf-8',
                },
              ),
            );
            when(
              () => httpRequest(
                'POST',
                Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                any(),
                any(),
              ),
            ).thenAnswer(
              (_) => http.StreamedResponse(
                Stream.value(
                  utf8.encode(
                    json.encode(
                      {
                        'ocs': {
                          'meta': {
                            'status': '',
                            'statuscode': 0,
                          },
                          'data': {
                            'publicKey': 'new-publicKey',
                            'deviceIdentifier': 'new-deviceIdentifier',
                            'signature': 'new-signature',
                          },
                        },
                      },
                    ),
                  ),
                ),
                201,
                headers: {
                  'content-type': 'application/json; charset=utf-8',
                },
              ),
            );

            repository = NotificationsPushRepository(
              accountRepository: accountRepository,
              storage: storage,
              onMessage: onMessageCallback,
            );
            await repository.initialize();

            verify(() => unifiedPushPlatform.registerApp(account.id, [])).called(1);
            verifyNever(() => unifiedPushPlatform.registerApp(any(), any()));

            endpoint = Uri.parse('https://cloud.example.com:8443/nextcloud/new-unifiedpush');

            await repository.changeDistributor('other');

            verify(() => unifiedPushPlatform.unregister(account.id)).called(1);
            verifyNever(() => unifiedPushPlatform.unregister(any()));

            await Future<void>.delayed(const Duration(milliseconds: 1));

            verify(
              () => httpRequest(
                'DELETE',
                Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                BuiltMap(
                  {
                    'Accept': 'application/json',
                    'Authorization': 'Bearer user1',
                    'OCS-APIRequest': 'true',
                    'user-agent': 'neon',
                  },
                ),
                Uint8List(0),
              ),
            ).called(1);
            verify(() => storage.updateSubscription(account.id, PushSubscription())).called(1);

            verify(() => unifiedPushPlatform.registerApp(account.id, [])).called(1);
            verifyNever(() => unifiedPushPlatform.registerApp(any(), any()));

            verify(
              () => httpRequest(
                'POST',
                Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                BuiltMap(
                  {
                    'Accept': 'application/json',
                    'Authorization': 'Bearer user1',
                    'OCS-APIRequest': 'true',
                    'Content-Type': 'application/json; charset=utf-8',
                    'user-agent': 'neon',
                  },
                ),
                utf8.encode(
                  json.encode(
                    notifications.PushRegisterDeviceRequestApplicationJson(
                      (b) => b
                        ..pushTokenHash = notifications.generatePushTokenHash(endpoint.toString())
                        ..devicePublicKey = privateKey.publicKey.toFormattedPEM()
                        ..proxyServer = '$endpoint#',
                    ),
                  ),
                ),
              ),
            ).called(1);
            verifyNever(() => httpRequest(any(), any(), any(), any()));
            final expectedSubscription = PushSubscription(
              (b) => b
                ..endpoint = endpoint.toString()
                ..pushDevice.update(
                  (b) => b
                    ..publicKey = 'new-publicKey'
                    ..deviceIdentifier = 'new-deviceIdentifier'
                    ..signature = 'new-signature',
                ),
            );
            verify(() => storage.updateSubscription(account.id, expectedSubscription)).called(1);
            verifyNever(() => storage.updateSubscription(any(), any()));
          });

          group('Failure at Nextcloud', () {
            test('Unregister', () async {
              when(
                () => httpRequest(
                  'DELETE',
                  Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                  any(),
                  any(),
                ),
              ).thenAnswer((_) => http.StreamedResponse(const Stream.empty(), 500));
              when(
                () => httpRequest(
                  'POST',
                  Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                  any(),
                  any(),
                ),
              ).thenAnswer(
                (_) => http.StreamedResponse(
                  Stream.value(
                    utf8.encode(
                      json.encode(
                        {
                          'ocs': {
                            'meta': {
                              'status': '',
                              'statuscode': 0,
                            },
                            'data': {
                              'publicKey': 'new-publicKey',
                              'deviceIdentifier': 'new-deviceIdentifier',
                              'signature': 'new-signature',
                            },
                          },
                        },
                      ),
                    ),
                  ),
                  201,
                  headers: {
                    'content-type': 'application/json; charset=utf-8',
                  },
                ),
              );

              repository = NotificationsPushRepository(
                accountRepository: accountRepository,
                storage: storage,
                onMessage: onMessageCallback,
              );
              await repository.initialize();

              verify(() => unifiedPushPlatform.registerApp(account.id, [])).called(1);
              verifyNever(() => unifiedPushPlatform.registerApp(any(), any()));

              endpoint = Uri.parse('https://cloud.example.com:8443/nextcloud/new-unifiedpush');

              await repository.changeDistributor('other');

              verify(() => unifiedPushPlatform.unregister(account.id)).called(1);
              verifyNever(() => unifiedPushPlatform.unregister(any()));

              await Future<void>.delayed(const Duration(milliseconds: 1));

              verify(
                () => httpRequest(
                  'DELETE',
                  Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                  BuiltMap(
                    {
                      'Accept': 'application/json',
                      'Authorization': 'Bearer user1',
                      'OCS-APIRequest': 'true',
                      'user-agent': 'neon',
                    },
                  ),
                  Uint8List(0),
                ),
              ).called(1);
              verify(() => storage.updateSubscription(account.id, PushSubscription())).called(1);

              verify(() => unifiedPushPlatform.registerApp(account.id, [])).called(1);
              verifyNever(() => unifiedPushPlatform.registerApp(any(), any()));

              verify(
                () => httpRequest(
                  'POST',
                  Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                  BuiltMap(
                    {
                      'Accept': 'application/json',
                      'Authorization': 'Bearer user1',
                      'OCS-APIRequest': 'true',
                      'Content-Type': 'application/json; charset=utf-8',
                      'user-agent': 'neon',
                    },
                  ),
                  utf8.encode(
                    json.encode(
                      notifications.PushRegisterDeviceRequestApplicationJson(
                        (b) => b
                          ..pushTokenHash = notifications.generatePushTokenHash(endpoint.toString())
                          ..devicePublicKey = privateKey.publicKey.toFormattedPEM()
                          ..proxyServer = '$endpoint#',
                      ),
                    ),
                  ),
                ),
              ).called(1);
              verifyNever(() => httpRequest(any(), any(), any(), any()));
              final expectedSubscription = PushSubscription(
                (b) => b
                  ..endpoint = endpoint.toString()
                  ..pushDevice.update(
                    (b) => b
                      ..publicKey = 'new-publicKey'
                      ..deviceIdentifier = 'new-deviceIdentifier'
                      ..signature = 'new-signature',
                  ),
              );
              verify(() => storage.updateSubscription(account.id, expectedSubscription)).called(1);
              verifyNever(() => storage.updateSubscription(any(), any()));
            });

            test('Register', () async {
              when(
                () => httpRequest(
                  'DELETE',
                  Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                  any(),
                  any(),
                ),
              ).thenAnswer(
                (_) => http.StreamedResponse(
                  Stream.value(
                    utf8.encode(
                      json.encode(
                        {
                          'ocs': {
                            'meta': {
                              'status': '',
                              'statuscode': 0,
                            },
                            'data': <dynamic, dynamic>{},
                          },
                        },
                      ),
                    ),
                  ),
                  200,
                  headers: {
                    'content-type': 'application/json; charset=utf-8',
                  },
                ),
              );
              when(
                () => httpRequest(
                  'POST',
                  Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                  any(),
                  any(),
                ),
              ).thenAnswer((_) => http.StreamedResponse(const Stream.empty(), 500));

              repository = NotificationsPushRepository(
                accountRepository: accountRepository,
                storage: storage,
                onMessage: onMessageCallback,
              );
              await repository.initialize();

              verify(() => unifiedPushPlatform.registerApp(account.id, [])).called(1);
              verifyNever(() => unifiedPushPlatform.registerApp(any(), any()));

              endpoint = Uri.parse('https://cloud.example.com:8443/nextcloud/new-unifiedpush');

              await repository.changeDistributor('other');

              verify(() => unifiedPushPlatform.unregister(account.id)).called(1);
              verifyNever(() => unifiedPushPlatform.unregister(any()));

              await Future<void>.delayed(const Duration(milliseconds: 1));

              verify(
                () => httpRequest(
                  'DELETE',
                  Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                  BuiltMap(
                    {
                      'Accept': 'application/json',
                      'Authorization': 'Bearer user1',
                      'OCS-APIRequest': 'true',
                      'user-agent': 'neon',
                    },
                  ),
                  Uint8List(0),
                ),
              ).called(1);
              verify(() => storage.updateSubscription(account.id, PushSubscription())).called(1);

              verify(() => unifiedPushPlatform.registerApp(account.id, [])).called(1);
              verifyNever(() => unifiedPushPlatform.registerApp(any(), any()));

              verify(
                () => httpRequest(
                  'POST',
                  Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                  BuiltMap(
                    {
                      'Accept': 'application/json',
                      'Authorization': 'Bearer user1',
                      'OCS-APIRequest': 'true',
                      'Content-Type': 'application/json; charset=utf-8',
                      'user-agent': 'neon',
                    },
                  ),
                  utf8.encode(
                    json.encode(
                      notifications.PushRegisterDeviceRequestApplicationJson(
                        (b) => b
                          ..pushTokenHash = notifications.generatePushTokenHash(endpoint.toString())
                          ..devicePublicKey = privateKey.publicKey.toFormattedPEM()
                          ..proxyServer = '$endpoint#',
                      ),
                    ),
                  ),
                ),
              ).called(1);
              verifyNever(() => httpRequest(any(), any(), any(), any()));
              final expectedSubscription = PushSubscription(
                (b) => b.endpoint = endpoint.toString(),
              );
              verify(() => storage.updateSubscription(account.id, expectedSubscription)).called(1);
              verifyNever(() => storage.updateSubscription(any(), any()));
            });
          });
        });

        group('Updates subscriptions when endpoint changes', () {
          test('Success at Nextcloud', () async {
            when(
              () => httpRequest(
                'DELETE',
                Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                any(),
                any(),
              ),
            ).thenAnswer(
              (_) => http.StreamedResponse(
                Stream.value(
                  utf8.encode(
                    json.encode(
                      {
                        'ocs': {
                          'meta': {
                            'status': '',
                            'statuscode': 0,
                          },
                          'data': <dynamic, dynamic>{},
                        },
                      },
                    ),
                  ),
                ),
                200,
                headers: {
                  'content-type': 'application/json; charset=utf-8',
                },
              ),
            );
            when(
              () => httpRequest(
                'POST',
                Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                any(),
                any(),
              ),
            ).thenAnswer(
              (_) => http.StreamedResponse(
                Stream.value(
                  utf8.encode(
                    json.encode(
                      {
                        'ocs': {
                          'meta': {
                            'status': '',
                            'statuscode': 0,
                          },
                          'data': {
                            'publicKey': 'new-publicKey',
                            'deviceIdentifier': 'new-deviceIdentifier',
                            'signature': 'new-signature',
                          },
                        },
                      },
                    ),
                  ),
                ),
                201,
                headers: {
                  'content-type': 'application/json; charset=utf-8',
                },
              ),
            );

            repository = NotificationsPushRepository(
              accountRepository: accountRepository,
              storage: storage,
              onMessage: onMessageCallback,
            );
            await repository.initialize();

            endpoint = Uri.parse('https://cloud.example.com:8443/nextcloud/new-unifiedpush');

            unifiedPushOnNewEndpoint!(endpoint.toString(), account.id);
            await Future<void>.delayed(const Duration(milliseconds: 1));

            verify(
              () => httpRequest(
                'DELETE',
                Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                BuiltMap(
                  {
                    'Accept': 'application/json',
                    'Authorization': 'Bearer user1',
                    'OCS-APIRequest': 'true',
                    'user-agent': 'neon',
                  },
                ),
                Uint8List(0),
              ),
            ).called(1);

            verify(
              () => httpRequest(
                'POST',
                Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                BuiltMap(
                  {
                    'Accept': 'application/json',
                    'Authorization': 'Bearer user1',
                    'OCS-APIRequest': 'true',
                    'Content-Type': 'application/json; charset=utf-8',
                    'user-agent': 'neon',
                  },
                ),
                utf8.encode(
                  json.encode(
                    notifications.PushRegisterDeviceRequestApplicationJson(
                      (b) => b
                        ..pushTokenHash = notifications.generatePushTokenHash(endpoint.toString())
                        ..devicePublicKey = privateKey.publicKey.toFormattedPEM()
                        ..proxyServer = '$endpoint#',
                    ),
                  ),
                ),
              ),
            ).called(1);
            verifyNever(() => httpRequest(any(), any(), any(), any()));
            final expectedSubscription = PushSubscription(
              (b) => b
                ..endpoint = endpoint.toString()
                ..pushDevice.update(
                  (b) => b
                    ..publicKey = 'new-publicKey'
                    ..deviceIdentifier = 'new-deviceIdentifier'
                    ..signature = 'new-signature',
                ),
            );
            verify(() => storage.updateSubscription(account.id, expectedSubscription)).called(1);
            verifyNever(() => storage.updateSubscription(any(), any()));
          });

          group('Failure at Nextcloud', () {
            test('Unregister', () async {
              when(
                () => httpRequest(
                  'DELETE',
                  Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                  any(),
                  any(),
                ),
              ).thenAnswer((_) => http.StreamedResponse(const Stream.empty(), 500));
              when(
                () => httpRequest(
                  'POST',
                  Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                  any(),
                  any(),
                ),
              ).thenAnswer(
                (_) => http.StreamedResponse(
                  Stream.value(
                    utf8.encode(
                      json.encode(
                        {
                          'ocs': {
                            'meta': {
                              'status': '',
                              'statuscode': 0,
                            },
                            'data': {
                              'publicKey': 'new-publicKey',
                              'deviceIdentifier': 'new-deviceIdentifier',
                              'signature': 'new-signature',
                            },
                          },
                        },
                      ),
                    ),
                  ),
                  201,
                  headers: {
                    'content-type': 'application/json; charset=utf-8',
                  },
                ),
              );

              repository = NotificationsPushRepository(
                accountRepository: accountRepository,
                storage: storage,
                onMessage: onMessageCallback,
              );
              await repository.initialize();

              endpoint = Uri.parse('https://cloud.example.com:8443/nextcloud/new-unifiedpush');

              unifiedPushOnNewEndpoint!(endpoint.toString(), account.id);
              await Future<void>.delayed(const Duration(milliseconds: 1));

              verify(
                () => httpRequest(
                  'DELETE',
                  Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                  BuiltMap(
                    {
                      'Accept': 'application/json',
                      'Authorization': 'Bearer user1',
                      'OCS-APIRequest': 'true',
                      'user-agent': 'neon',
                    },
                  ),
                  Uint8List(0),
                ),
              ).called(1);
              verify(
                () => httpRequest(
                  'POST',
                  Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                  BuiltMap(
                    {
                      'Accept': 'application/json',
                      'Authorization': 'Bearer user1',
                      'OCS-APIRequest': 'true',
                      'Content-Type': 'application/json; charset=utf-8',
                      'user-agent': 'neon',
                    },
                  ),
                  utf8.encode(
                    json.encode(
                      notifications.PushRegisterDeviceRequestApplicationJson(
                        (b) => b
                          ..pushTokenHash = notifications.generatePushTokenHash(endpoint.toString())
                          ..devicePublicKey = privateKey.publicKey.toFormattedPEM()
                          ..proxyServer = '$endpoint#',
                      ),
                    ),
                  ),
                ),
              ).called(1);
              verifyNever(() => httpRequest(any(), any(), any(), any()));
              final expectedSubscription = PushSubscription(
                (b) => b
                  ..endpoint = endpoint.toString()
                  ..pushDevice.update(
                    (b) => b
                      ..publicKey = 'new-publicKey'
                      ..deviceIdentifier = 'new-deviceIdentifier'
                      ..signature = 'new-signature',
                  ),
              );
              verify(() => storage.updateSubscription(account.id, expectedSubscription)).called(1);
              verifyNever(() => storage.updateSubscription(any(), any()));
            });

            test('Register', () async {
              when(
                () => httpRequest(
                  'DELETE',
                  Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                  any(),
                  any(),
                ),
              ).thenAnswer(
                (_) => http.StreamedResponse(
                  Stream.value(
                    utf8.encode(
                      json.encode(
                        {
                          'ocs': {
                            'meta': {
                              'status': '',
                              'statuscode': 0,
                            },
                            'data': <dynamic, dynamic>{},
                          },
                        },
                      ),
                    ),
                  ),
                  200,
                  headers: {
                    'content-type': 'application/json; charset=utf-8',
                  },
                ),
              );
              when(
                () => httpRequest(
                  'POST',
                  Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                  any(),
                  any(),
                ),
              ).thenAnswer((_) => http.StreamedResponse(const Stream.empty(), 500));

              repository = NotificationsPushRepository(
                accountRepository: accountRepository,
                storage: storage,
                onMessage: onMessageCallback,
              );
              await repository.initialize();

              endpoint = Uri.parse('https://cloud.example.com:8443/nextcloud/new-unifiedpush');

              unifiedPushOnNewEndpoint!(endpoint.toString(), account.id);
              await Future<void>.delayed(const Duration(milliseconds: 1));

              verify(
                () => httpRequest(
                  'DELETE',
                  Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                  BuiltMap(
                    {
                      'Accept': 'application/json',
                      'Authorization': 'Bearer user1',
                      'OCS-APIRequest': 'true',
                      'user-agent': 'neon',
                    },
                  ),
                  Uint8List(0),
                ),
              ).called(1);
              verify(
                () => httpRequest(
                  'POST',
                  Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                  BuiltMap(
                    {
                      'Accept': 'application/json',
                      'Authorization': 'Bearer user1',
                      'OCS-APIRequest': 'true',
                      'Content-Type': 'application/json; charset=utf-8',
                      'user-agent': 'neon',
                    },
                  ),
                  utf8.encode(
                    json.encode(
                      notifications.PushRegisterDeviceRequestApplicationJson(
                        (b) => b
                          ..pushTokenHash = notifications.generatePushTokenHash(endpoint.toString())
                          ..devicePublicKey = privateKey.publicKey.toFormattedPEM()
                          ..proxyServer = '$endpoint#',
                      ),
                    ),
                  ),
                ),
              ).called(1);
              verifyNever(() => httpRequest(any(), any(), any(), any()));
              final expectedSubscription = PushSubscription(
                (b) => b.endpoint = endpoint.toString(),
              );
              verify(() => storage.updateSubscription(account.id, expectedSubscription)).called(1);
              verifyNever(() => storage.updateSubscription(any(), any()));
            });
          });
        });

        group('Removes subscription when account is deleted', () {
          test('Success at Nextcloud', () async {
            when(
              () => httpRequest(
                'DELETE',
                Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                any(),
                any(),
              ),
            ).thenAnswer(
              (_) => http.StreamedResponse(
                Stream.value(
                  utf8.encode(
                    json.encode(
                      {
                        'ocs': {
                          'meta': {
                            'status': '',
                            'statuscode': 0,
                          },
                          'data': <dynamic, dynamic>{},
                        },
                      },
                    ),
                  ),
                ),
                200,
                headers: {
                  'content-type': 'application/json; charset=utf-8',
                },
              ),
            );

            repository = NotificationsPushRepository(
              accountRepository: accountRepository,
              storage: storage,
              onMessage: onMessageCallback,
            );
            await repository.initialize();

            verify(() => unifiedPushPlatform.registerApp(account.id, [])).called(1);
            verifyNever(() => unifiedPushPlatform.registerApp(any(), any()));

            for (final callback in beforeLogOutCallbacks) {
              await callback(account);
            }

            verify(() => unifiedPushPlatform.unregister(account.id)).called(1);
            verifyNever(() => unifiedPushPlatform.unregister(any()));
            verify(
              () => httpRequest(
                'DELETE',
                Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                BuiltMap(
                  {
                    'Accept': 'application/json',
                    'Authorization': 'Bearer user1',
                    'OCS-APIRequest': 'true',
                    'user-agent': 'neon',
                  },
                ),
                Uint8List(0),
              ),
            ).called(1);
            verifyNever(() => httpRequest(any(), any(), any(), any()));
            verify(() => storage.updateSubscription(account.id, PushSubscription())).called(1);
            verifyNever(() => storage.updateSubscription(any(), any()));
          });

          test('Failure at Nextcloud', () async {
            when(
              () => httpRequest(
                'DELETE',
                Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                any(),
                any(),
              ),
            ).thenAnswer((_) => http.StreamedResponse(const Stream.empty(), 500));

            repository = NotificationsPushRepository(
              accountRepository: accountRepository,
              storage: storage,
              onMessage: onMessageCallback,
            );
            await repository.initialize();

            verify(() => unifiedPushPlatform.registerApp(account.id, [])).called(1);
            verifyNever(() => unifiedPushPlatform.registerApp(any(), any()));

            for (final callback in beforeLogOutCallbacks) {
              await callback(account);
            }

            verify(() => unifiedPushPlatform.unregister(account.id)).called(1);
            verifyNever(() => unifiedPushPlatform.unregister(any()));
            verify(
              () => httpRequest(
                'DELETE',
                Uri.parse('https://cloud.example.com:8443/nextcloud/ocs/v2.php/apps/notifications/api/v2/push'),
                BuiltMap(
                  {
                    'Accept': 'application/json',
                    'Authorization': 'Bearer user1',
                    'OCS-APIRequest': 'true',
                    'user-agent': 'neon',
                  },
                ),
                Uint8List(0),
              ),
            ).called(1);
            verifyNever(() => httpRequest(any(), any(), any(), any()));
            verify(() => storage.updateSubscription(account.id, PushSubscription())).called(1);
            verifyNever(() => storage.updateSubscription(any(), any()));
          });
        });
      });
    });
  });
}
