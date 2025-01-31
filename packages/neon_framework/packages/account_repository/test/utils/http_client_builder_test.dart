import 'package:account_repository/src/models/models.dart';
import 'package:account_repository/src/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:neon_framework/storage.dart';
import 'package:neon_http_client/neon_http_client.dart';
import 'package:nextcloud/nextcloud.dart';

class _FakeClient extends Fake implements http.Client {}

class _FakeUri extends Fake implements Uri {}

// ignore: subtype_of_sealed_class
class _NeonStorageMock extends Mock implements NeonStorage {}

void main() {
  final httpClient = _FakeClient();
  const userAgent = 'neon';
  late NeonStorage storageMock;

  setUpAll(() {
    registerFallbackValue(_FakeUri());

    storageMock = _NeonStorageMock();
    NeonStorage.mocked(storageMock);
    when(
      () => storageMock.cookieStore(
        accountID: any(named: 'accountID'),
        serverURL: any(named: 'serverURL'),
      ),
    ).thenReturn(null);
  });

  test('buildClient', () {
    final credentials = Credentials((b) {
      b
        ..username = 'username'
        ..appPassword = 'appPassword'
        ..serverURL = Uri.https('serverURL');
    });

    final client = buildClient(
      httpClient: httpClient,
      userAgent: userAgent,
      credentials: credentials,
    );

    expect(
      client,
      isA<NextcloudClient>()
          .having((c) => c.authentications, 'not empty authentications', isNotEmpty)
          .having((c) => c.baseURL, 'baseURL', equals(Uri.https('serverURL')))
          .having(
            (c) => c.httpClient,
            'httpClient',
            isA<NeonHttpClient>().having((c) => c.interceptors, 'interceptors', hasLength(3)),
          ),
    );

    verify(
      () => storageMock.cookieStore(
        accountID: any(named: 'accountID', that: equals(credentials.id)),
        serverURL: any(named: 'serverURL', that: equals(Uri.https('serverURL'))),
      ),
    ).called(1);
  });

  test('buildUnauthenticatedClient', () {
    final client = buildUnauthenticatedClient(
      httpClient: httpClient,
      userAgent: userAgent,
      serverURL: Uri.https('serverURL'),
    );

    expect(
      client,
      isA<NextcloudClient>()
          .having((c) => c.authentications, 'empty authentications', isEmpty)
          .having((c) => c.baseURL, 'baseURL', equals(Uri.https('serverURL')))
          .having(
            (c) => c.httpClient,
            'httpClient',
            isA<NeonHttpClient>().having((c) => c.interceptors, 'interceptors', hasLength(3)),
          ),
    );

    verifyNever(
      () => storageMock.cookieStore(
        accountID: any(named: 'accountID'),
        serverURL: any(named: 'serverURL'),
      ),
    );
  });
}
