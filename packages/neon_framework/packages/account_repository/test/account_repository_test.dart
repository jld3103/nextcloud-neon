// ignore_for_file: inference_failure_on_collection_literal

import 'package:account_repository/account_repository.dart';
import 'package:account_repository/src/testing/testing.dart';
import 'package:account_repository/src/utils/authentication_client.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value_test/matcher.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:neon_framework/testing.dart' show MockNeonStorage;
import 'package:nextcloud/core.dart' as core;
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/provisioning_api.dart' as provisioning_api;
import 'package:test/test.dart';

class _FakeStatus extends Fake implements core.Status {}

class _FakeUri extends Fake implements Uri {}

class _FakeClient extends Fake implements http.Client {}

class _FakePollRequest extends Fake implements core.ClientFlowLoginV2PollRequestApplicationJson {}

class _DynamiteResponseMock<B, H> extends Mock implements DynamiteResponse<B, H> {}

class _CurrentUserResponseMock extends Mock implements provisioning_api.UsersGetCurrentUserResponseApplicationJson {}

class _CurrentUserResponseOcsMock extends Mock
    implements provisioning_api.UsersGetCurrentUserResponseApplicationJson_Ocs {}

class _UserDetailsMock extends Mock implements provisioning_api.UserDetails {}

class _CoreClientMock extends Mock implements core.$Client {}

class _AppPasswordClientMock extends Mock implements core.$AppPasswordClient {}

class _ClientFlowLoginV2ClientMock extends Mock implements core.$ClientFlowLoginV2Client {}

class _UsersClientMock extends Mock implements provisioning_api.$UsersClient {}

class _WipeClientMock extends Mock implements core.$WipeClient {}

class _WipeCheckResponseMock extends Mock implements core.WipeCheckWipeResponseApplicationJson {}

class _FakeWipeCheckRequest extends Fake implements core.WipeCheckWipeRequestApplicationJson {}

class _FakeWipeDoneRequest extends Fake implements core.WipeWipeDoneRequestApplicationJson {}

class _AccountStorageMock extends Mock implements AccountStorage {}

typedef _AccountStream = ({BuiltList<Account> accounts, Account? active});

void main() {
  late AccountStorage storage;
  late AccountRepository repository;

  late core.$Client coreClient;
  late core.$AppPasswordClient appPassword;
  late core.$ClientFlowLoginV2Client clientFlowLoginV2;
  late provisioning_api.$UsersClient users;
  late core.$WipeClient wipe;

  setUpAll(() {
    registerFallbackValue(_FakeUri());
    registerFallbackValue(_FakePollRequest());
    registerFallbackValue(_FakeWipeCheckRequest());
    registerFallbackValue(_FakeWipeDoneRequest());
    MockNeonStorage();
  });

  setUp(() {
    coreClient = _CoreClientMock();
    appPassword = _AppPasswordClientMock();
    clientFlowLoginV2 = _ClientFlowLoginV2ClientMock();
    users = _UsersClientMock();
    wipe = _WipeClientMock();

    mockedClient = AuthenticationClient(
      core: coreClient,
      appPassword: appPassword,
      clientFlowLoginV2: clientFlowLoginV2,
      users: users,
      wipe: wipe,
    );

    storage = _AccountStorageMock();

    repository = AccountRepository(
      userAgent: 'userAgent',
      httpClient: _FakeClient(),
      storage: storage,
    );
  });

  final credentialsList = BuiltList<Credentials>([
    Credentials((b) {
      b
        ..serverURL = Uri.https('serverUrl')
        ..username = 'username'
        ..appPassword = 'appPassword';
    }),
    Credentials((b) {
      b
        ..serverURL = Uri.https('other-serverUrl')
        ..username = 'username'
        ..appPassword = 'appPassword';
    }),
  ]);

  final accountsList = List.generate(credentialsList.length, (i) {
    return createAccount(credentials: credentialsList[i]);
  }).toBuiltList();

  group('AccountRepository', () {
    test('failure equality', () {
      expect(
        FetchStatusFailure(credentialsList),
        equals(FetchStatusFailure(credentialsList)),
      );

      expect(
        InitLoginFailure(credentialsList),
        equals(InitLoginFailure(credentialsList)),
      );

      expect(
        PollLoginFailure(credentialsList),
        equals(PollLoginFailure(credentialsList)),
      );

      expect(
        FetchAccountFailure(credentialsList),
        equals(FetchAccountFailure(credentialsList)),
      );

      expect(
        DeleteCredentialsFailure(credentialsList),
        equals(DeleteCredentialsFailure(credentialsList)),
      );
    });

    group('accounts', () {
      test('emits empty user map before initialized', () {
        expect(
          repository.accounts,
          emits((accounts: BuiltList<Account>(), active: null)),
        );
      });
    });

    test('hasAccounts', () async {
      expect(repository.hasAccounts, isFalse);

      when(() => storage.readCredentials()).thenAnswer((_) async => BuiltList());
      await repository.loadAccounts();

      expect(repository.hasAccounts, isFalse);

      when(() => storage.readCredentials()).thenAnswer((_) async => credentialsList);
      await repository.loadAccounts();

      expect(repository.hasAccounts, isTrue);
    });

    test('accountByID', () async {
      when(() => storage.readCredentials()).thenAnswer((_) async => credentialsList);
      await repository.loadAccounts();

      expect(repository.accountByID('invalid'), isNull);
      expect(repository.accountByID(credentialsList.first.id), isNotNull);
    });

    test('isLogInQRCode', () {
      expect(
        AccountRepository.isLogInQRCode(url: 'nc://login/user:JohnDoe&password:super_secret&server:example.com'),
        isTrue,
      );

      expect(
        AccountRepository.isLogInQRCode(url: '/user:JohnDoe&password:super_secret&server:example.com'),
        isTrue,
      );

      expect(
        AccountRepository.isLogInQRCode(url: 'invalid'),
        isFalse,
      );
    });

    group('loadAccounts', () {
      test('no active account when no credentials are available', () async {
        when(() => storage.readCredentials()).thenAnswer((_) async => BuiltList());
        await repository.loadAccounts();

        await expectLater(
          repository.accounts,
          emits(
            isA<_AccountStream>()
                .having((e) => e.accounts, 'accounts', isEmpty)
                .having((e) => e.active, 'active', isNull),
          ),
        );

        verifyNever(() => storage.readLastAccount());
      });

      test('emits stored credentials in accounts', () async {
        when(() => storage.readCredentials()).thenAnswer((_) async => credentialsList);
        await repository.loadAccounts();

        await expectLater(
          repository.accounts,
          emits(
            isA<_AccountStream>()
                .having((e) => e.accounts, 'accounts', containsAllInOrder(accountsList))
                .having((e) => e.active, 'active', equals(accountsList.first)),
          ),
        );

        verifyNever(() => storage.readLastAccount());
      });

      test('uses initialAccount as active', () async {
        when(() => storage.readCredentials()).thenAnswer((_) async => credentialsList);
        await repository.loadAccounts(initialAccount: credentialsList[1].id);

        await expectLater(
          repository.accounts,
          emits(
            isA<_AccountStream>()
                .having((e) => e.accounts, 'accounts', containsAllInOrder(accountsList))
                .having((e) => e.active, 'active', equals(accountsList[1])),
          ),
        );

        verifyNever(() => storage.readLastAccount());
      });

      test('ignores initialAccount when not it accounts', () async {
        when(() => storage.readCredentials()).thenAnswer((_) async => credentialsList);
        await repository.loadAccounts(initialAccount: 'invalid');

        await expectLater(
          repository.accounts,
          emits(
            isA<_AccountStream>()
                .having((e) => e.accounts, 'accounts', containsAllInOrder(accountsList))
                .having((e) => e.active, 'active', equals(accountsList.first)),
          ),
        );

        verifyNever(() => storage.readLastAccount());
      });

      test('uses last active account when specified', () async {
        when(() => storage.readCredentials()).thenAnswer((_) async => credentialsList);
        when(() => storage.readLastAccount()).thenAnswer((_) async => credentialsList[1].id);
        await repository.loadAccounts(rememberLastUsedAccount: true);

        await expectLater(
          repository.accounts,
          emits(
            isA<_AccountStream>()
                .having((e) => e.accounts, 'accounts', containsAllInOrder(accountsList))
                .having((e) => e.active, 'active', equals(accountsList[1])),
          ),
        );

        verify(() => storage.readLastAccount()).called(1);
      });

      test('ignores last active account when not in accounts', () async {
        when(() => storage.readCredentials()).thenAnswer((_) async => credentialsList);
        when(() => storage.readLastAccount()).thenAnswer((_) async => 'invalid');
        await repository.loadAccounts(rememberLastUsedAccount: true);

        await expectLater(
          repository.accounts,
          emits(
            isA<_AccountStream>()
                .having((e) => e.accounts, 'accounts', containsAllInOrder(accountsList))
                .having((e) => e.active, 'active', equals(accountsList.first)),
          ),
        );

        verify(() => storage.readLastAccount()).called(1);
      });

      test('prefers last active account over initial account', () async {
        when(() => storage.readCredentials()).thenAnswer((_) async => credentialsList);
        when(() => storage.readLastAccount()).thenAnswer((_) async => credentialsList[1].id);
        await repository.loadAccounts(
          rememberLastUsedAccount: true,
          initialAccount: credentialsList.first.id,
        );

        await expectLater(
          repository.accounts,
          emits(
            isA<_AccountStream>()
                .having((e) => e.accounts, 'accounts', containsAllInOrder(accountsList))
                .having((e) => e.active, 'active', equals(accountsList[1])),
          ),
        );

        verify(() => storage.readLastAccount()).called(1);
      });
    });

    group('getServerStatus', () {
      test('fetches the server status', () async {
        final mockResponse = _DynamiteResponseMock<core.Status, void>();
        when(() => coreClient.getStatus()).thenAnswer((_) async => mockResponse);
        when(() => mockResponse.body).thenReturn(_FakeStatus());

        await expectLater(
          repository.getServerStatus(Uri()),
          completion(isA<core.Status>()),
        );

        verify(() => coreClient.getStatus()).called(1);
      });

      test('rethrows http exceptions as `FetchStatusFailure`', () async {
        when(() => coreClient.getStatus()).thenThrow(http.ClientException(''));

        await expectLater(
          repository.getServerStatus(Uri()),
          throwsA(isA<FetchStatusFailure>().having((e) => e.error, 'error', isA<http.ClientException>())),
        );

        verify(() => coreClient.getStatus()).called(1);
      });
    });

    group('loginFlowInit', () {
      test('returns login endpoint and token', () async {
        when(() => clientFlowLoginV2.init()).thenAnswer((_) async {
          return DynamiteResponse(
            200,
            core.LoginFlowV2((b) {
              b.login = 'https://login_url';
              b.poll
                ..token = 'token'
                ..endpoint = 'endpoint';
            }),
            null,
          );
        });

        await expectLater(
          repository.loginFlowInit(Uri()),
          completion(equals((Uri.https('login_url'), 'token'))),
        );

        verify(() => clientFlowLoginV2.init()).called(1);
      });

      test('rethrows http exceptions as `InitLoginFailure`', () async {
        when(() => clientFlowLoginV2.init()).thenThrow(http.ClientException(''));

        await expectLater(
          repository.loginFlowInit(Uri()),
          throwsA(isA<InitLoginFailure>().having((e) => e.error, 'error', isA<http.ClientException>())),
        );

        verify(() => clientFlowLoginV2.init()).called(1);
      });
    });

    group('loginFlowPoll', () {
      test('returns fetched credentials', () async {
        when(() => clientFlowLoginV2.poll($body: any(named: r'$body'))).thenAnswer((_) async {
          return DynamiteResponse(
            200,
            core.LoginFlowV2Credentials((b) {
              b
                ..appPassword = 'appPassword'
                ..loginName = 'loginName'
                ..server = 'https://server';
            }),
            null,
          );
        });

        await expectLater(
          repository.loginFlowPoll(Uri(), 'token'),
          completion(
            equalsBuilt(
              Credentials((b) {
                b
                  ..appPassword = 'appPassword'
                  ..username = 'loginName'
                  ..serverURL = Uri.https('server');
              }),
            ),
          ),
        );

        verify(
          () => clientFlowLoginV2.poll(
            $body: any(
              named: r'$body',
              that: equalsBuilt(core.ClientFlowLoginV2PollRequestApplicationJson((b) => b.token = 'token')),
            ),
          ),
        ).called(1);
      });

      test('returns null when for 404 response credentials', () async {
        when(() => clientFlowLoginV2.poll($body: any(named: r'$body')))
            .thenThrow(DynamiteStatusCodeException(http.Response('', 404)));

        await expectLater(
          repository.loginFlowPoll(Uri(), 'token'),
          completion(isNull),
        );

        verify(
          () => clientFlowLoginV2.poll(
            $body: any(
              named: r'$body',
              that: equalsBuilt(core.ClientFlowLoginV2PollRequestApplicationJson((b) => b.token = 'token')),
            ),
          ),
        ).called(1);
      });

      test('rethrows http exceptions as `PollLoginFailure`', () async {
        when(() => clientFlowLoginV2.poll($body: any(named: r'$body'))).thenThrow(http.ClientException(''));

        await expectLater(
          repository.loginFlowPoll(Uri(), 'token'),
          throwsA(isA<PollLoginFailure>().having((e) => e.error, 'error', isA<http.ClientException>())),
        );

        verify(
          () => clientFlowLoginV2.poll(
            $body: any(
              named: r'$body',
              that: equalsBuilt(core.ClientFlowLoginV2PollRequestApplicationJson((b) => b.token = 'token')),
            ),
          ),
        ).called(1);
      });
    });

    group('getAccount', () {
      test('retrieves account id from server', () async {
        final userDetails = _UserDetailsMock();
        when(() => userDetails.id).thenReturn('admin');
        final ocs = _CurrentUserResponseOcsMock();
        when(() => ocs.data).thenReturn(userDetails);
        final userStatusResponse = _CurrentUserResponseMock();
        when(() => userStatusResponse.ocs).thenReturn(ocs);
        final response = _DynamiteResponseMock<_CurrentUserResponseMock, void>();
        when(() => response.body).thenReturn(userStatusResponse);

        when(() => users.getCurrentUser()).thenAnswer((_) async => response);

        await expectLater(
          repository.getAccount(credentialsList.first),
          completion(isA<Account>().having((e) => e.username, 'username', equals('admin'))),
        );

        verify(() => users.getCurrentUser()).called(1);
      });

      test('rethrows http exceptions as `FetchAccountFailure`', () async {
        when(() => users.getCurrentUser()).thenThrow(http.ClientException(''));

        await expectLater(
          repository.getAccount(credentialsList.first),
          throwsA(isA<FetchAccountFailure>().having((e) => e.error, 'error', isA<http.ClientException>())),
        );

        verify(() => users.getCurrentUser()).called(1);
      });
    });

    group('logIn', () {
      setUp(() async {
        when(() => storage.saveCredentials(any())).thenAnswer((_) async => {});
        when(() => storage.saveLastAccount(any())).thenAnswer((_) async => {});
      });

      final account = createAccount(
        credentials: credentialsList.first,
      );

      test('adds account and sets active', () async {
        await repository.logIn(account);

        await expectLater(
          repository.accounts,
          emits(
            isA<_AccountStream>()
                .having((e) => e.accounts, 'accounts', equals([account]))
                .having((e) => e.active, 'active', equals(account)),
          ),
        );
        verify(() => storage.saveCredentials(any(that: contains(account.credentials)))).called(1);
        verify(() => storage.saveLastAccount(account.id)).called(1);
      });
    });

    group('logOut', () {
      setUp(() async {
        when(() => storage.readCredentials()).thenAnswer((_) async => credentialsList);
        when(() => storage.saveLastAccount(any())).thenAnswer((_) async => {});
        when(() => storage.saveCredentials(any())).thenAnswer((_) async => {});

        await repository.loadAccounts();

        resetMocktailState();
      });

      test('removes active account', () async {
        when(() => appPassword.deleteAppPassword()).thenAnswer(
          (_) async => _DynamiteResponseMock<core.AppPasswordDeleteAppPasswordResponseApplicationJson, void>(),
        );
        final accounts = await repository.accounts.first;
        await repository.logOut(accounts.accounts.first);

        await expectLater(
          repository.accounts,
          emits(
            isA<_AccountStream>()
                .having((e) => e.accounts, 'accounts', equals([accountsList[1]]))
                .having((e) => e.active, 'active', equals(accountsList[1])),
          ),
        );

        verify(() => appPassword.deleteAppPassword()).called(1);
        verify(() => storage.saveLastAccount(credentialsList[1].id)).called(1);
        verify(() => storage.saveCredentials(any(that: equals([credentialsList[1]])))).called(1);
      });

      test('rethrows http exceptions as `DeleteCredentialsFailure`', () async {
        when(() => appPassword.deleteAppPassword()).thenThrow(http.ClientException(''));

        final accounts = await repository.accounts.first;
        await expectLater(
          repository.logOut(accounts.accounts.first),
          throwsA(isA<DeleteCredentialsFailure>().having((e) => e.error, 'error', isA<http.ClientException>())),
        );

        await expectLater(
          repository.accounts,
          emits(
            isA<_AccountStream>()
                .having((e) => e.accounts, 'accounts', equals([accountsList[1]]))
                .having((e) => e.active, 'active', equals(accountsList[1])),
          ),
        );

        verify(() => appPassword.deleteAppPassword()).called(1);
        verify(() => storage.saveLastAccount(credentialsList[1].id)).called(1);
        verify(() => storage.saveCredentials(any(that: equals([credentialsList[1]])))).called(1);
      });
    });

    group('deleteAccount', () {
      test('unimplemented', () async {
        expect(
          repository.deleteAccount(),
          throwsUnimplementedError,
        );
      });
    });

    group('switchAccount', () {
      setUp(() async {
        when(() => storage.readCredentials()).thenAnswer((_) async => credentialsList);
        await repository.loadAccounts();

        resetMocktailState();
      });

      test('throws StateError for unregistered account ids', () async {
        await expectLater(
          repository.switchAccount('invalid'),
          throwsArgumentError,
        );
      });

      test('emits and saves active account ', () async {
        when(() => storage.saveLastAccount(any())).thenAnswer((_) async => {});
        await repository.switchAccount(credentialsList[1].id);

        await expectLater(
          repository.accounts,
          emits(
            isA<_AccountStream>()
                .having((e) => e.accounts, 'accounts', containsAllInOrder(accountsList))
                .having((e) => e.active, 'active', equals(accountsList[1])),
          ),
        );

        verify(() => storage.saveLastAccount(credentialsList[1].id)).called(1);
      });
    });

    group('getRemoteWipeStatus', () {
      group('retrieves remote wipe status from server', () {
        test('should wipe', () async {
          final wipeCheckResponse = _WipeCheckResponseMock();
          when(() => wipeCheckResponse.wipe).thenReturn(true);
          final response = _DynamiteResponseMock<_WipeCheckResponseMock, void>();
          when(() => response.body).thenReturn(wipeCheckResponse);

          when(() => wipe.checkWipe($body: any(named: r'$body'))).thenAnswer((_) async => response);

          await expectLater(
            repository.getRemoteWipeStatus(accountsList.first),
            completion(true),
          );

          verify(
            () => wipe.checkWipe(
              $body: any(
                named: r'$body',
                that: isA<core.WipeCheckWipeRequestApplicationJson>().having(
                  (b) => b.token,
                  'token',
                  'appPassword',
                ),
              ),
            ),
          ).called(1);
        });

        test('should not wipe', () async {
          when(() => wipe.checkWipe($body: any(named: r'$body')))
              .thenThrow(DynamiteStatusCodeException(http.Response('', 404)));

          await expectLater(
            repository.getRemoteWipeStatus(accountsList.first),
            completion(false),
          );

          verify(
            () => wipe.checkWipe(
              $body: any(
                named: r'$body',
                that: isA<core.WipeCheckWipeRequestApplicationJson>().having(
                  (b) => b.token,
                  'token',
                  'appPassword',
                ),
              ),
            ),
          ).called(1);
        });
      });

      test('rethrows http exceptions as `GetRemoteWipeStatusFailure`', () async {
        when(() => wipe.checkWipe($body: any(named: r'$body'))).thenThrow(http.ClientException(''));

        await expectLater(
          repository.getRemoteWipeStatus(accountsList.first),
          throwsA(isA<GetRemoteWipeStatusFailure>().having((e) => e.error, 'error', isA<http.ClientException>())),
        );

        verify(
          () => wipe.checkWipe(
            $body: any(
              named: r'$body',
              that: isA<core.WipeCheckWipeRequestApplicationJson>().having(
                (b) => b.token,
                'token',
                'appPassword',
              ),
            ),
          ),
        ).called(1);
      });
    });

    group('postRemoteWipeSuccess', () {
      test('posts remote wipe success server', () async {
        final response = _DynamiteResponseMock<JsonObject, void>();
        when(() => response.body).thenReturn(JsonObject(''));

        when(() => wipe.wipeDone($body: any(named: r'$body'))).thenAnswer((_) async => response);

        await repository.postRemoteWipeSuccess(accountsList.first);

        verify(
          () => wipe.wipeDone(
            $body: any(
              named: r'$body',
              that: isA<core.WipeWipeDoneRequestApplicationJson>().having(
                (b) => b.token,
                'token',
                'appPassword',
              ),
            ),
          ),
        ).called(1);
      });

      test('rethrows http exceptions as `PostRemoteWipeSuccessFailure`', () async {
        when(() => wipe.wipeDone($body: any(named: r'$body'))).thenThrow(http.ClientException(''));

        await expectLater(
          repository.postRemoteWipeSuccess(accountsList.first),
          throwsA(isA<PostRemoteWipeSuccessFailure>().having((e) => e.error, 'error', isA<http.ClientException>())),
        );

        verify(
          () => wipe.wipeDone(
            $body: any(
              named: r'$body',
              that: isA<core.WipeWipeDoneRequestApplicationJson>().having(
                (b) => b.token,
                'token',
                'appPassword',
              ),
            ),
          ),
        ).called(1);
      });
    });
  });
}
