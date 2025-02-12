import 'package:account_repository/account_repository.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neon_framework/storage.dart';

// ignore: avoid_implementing_value_types
class _FakeBuiltList extends Fake implements BuiltList<String> {}

class _SingleValueStoreMock extends Mock implements SingleValueStore {}

void main() {
  late SingleValueStore accountsStore;
  late SingleValueStore lastAccountStore;
  late AccountStorage storage;

  setUp(() {
    registerFallbackValue(_FakeBuiltList());

    accountsStore = _SingleValueStoreMock();
    lastAccountStore = _SingleValueStoreMock();

    storage = AccountStorage(
      accountsPersistence: accountsStore,
      lastAccountPersistence: lastAccountStore,
    );
  });

  final credentialsList = [
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
  ];

  final serializedCredentials = BuiltList<String>([
    '{"serverURL":"https://serverurl","username":"username","appPassword":"appPassword"}',
    '{"serverURL":"https://other-serverurl","username":"username","appPassword":"appPassword"}',
  ]);

  group('AccountStorage', () {
    group('readCredentials', () {
      test('returns empty list when no value is stored', () async {
        when(() => accountsStore.hasValue()).thenReturn(false);

        await expectLater(
          storage.readCredentials(),
          completion(isEmpty),
        );

        verifyNever(() => accountsStore.getStringList());
      });

      test('returns list with deserialized accounts', () async {
        when(() => accountsStore.hasValue()).thenReturn(true);
        when(() => accountsStore.getStringList()).thenReturn(serializedCredentials);

        await expectLater(
          storage.readCredentials(),
          completion(credentialsList),
        );

        verify(() => accountsStore.getStringList()).called(1);
      });
    });

    group('saveCredentials', () {
      test('persists accounts to storage', () async {
        when(() => accountsStore.setStringList(any())).thenAnswer((_) async => true);

        await storage.saveCredentials(credentialsList);

        verify(() => accountsStore.setStringList(any(that: equals(serializedCredentials)))).called(1);
      });
    });

    group('readLastAccount', () {
      test('returns null when no value is stored', () async {
        when(() => lastAccountStore.getString()).thenReturn(null);

        await expectLater(
          storage.readLastAccount(),
          completion(isNull),
        );

        verify(() => lastAccountStore.getString()).called(1);
      });

      test('returns account id for the stored value', () async {
        when(() => lastAccountStore.getString()).thenReturn('accountID');

        await expectLater(
          storage.readLastAccount(),
          completion('accountID'),
        );

        verify(() => lastAccountStore.getString()).called(1);
      });
    });

    group('saveLastAccount', () {
      test('persists account id to disk', () async {
        when(() => lastAccountStore.setString(any())).thenAnswer((_) async => true);

        await storage.saveLastAccount('accountID');

        verify(() => lastAccountStore.setString('accountID')).called(1);
      });

      test('deletes last account when id is null', () async {
        when(() => lastAccountStore.remove()).thenAnswer((_) async => true);

        await storage.saveLastAccount(null);

        verify(() => lastAccountStore.remove()).called(1);
      });
    });
  });
}
