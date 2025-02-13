// ignore_for_file: discarded_futures

import 'package:account_repository/account_repository.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neon_framework/src/blocs/accounts.dart';
import 'package:rxdart/rxdart.dart';

class _MockAccountRepository extends Mock implements AccountRepository {}

class _MockAccount extends Mock implements Account {}

class _FakeAccount extends Fake implements Account {}

void main() {
  late BehaviorSubject<({BuiltList<Account> accounts, Account? active})> accounts;
  late AccountRepository accountRepository;
  late AccountsBloc bloc;

  setUpAll(() {
    registerFallbackValue(_FakeAccount());
  });

  setUp(() {
    accounts = BehaviorSubject();

    accountRepository = _MockAccountRepository();
    when(() => accountRepository.accounts).thenAnswer((_) => accounts);

    bloc = AccountsBloc(
      allAppImplementations: BuiltSet(),
      accountRepository: accountRepository,
    );

    verify(() => accountRepository.accounts).called(1);
  });

  tearDown(() {
    bloc.dispose();

    accounts.close();

    verifyNoMoreInteractions(accountRepository);
  });

  group('removeAccount', () {
    test('Success', () {
      when(() => accountRepository.logOut(any())).thenAnswer((_) async {});

      final account = _MockAccount();

      bloc.removeAccount(account);
      verify(() => accountRepository.logOut(account)).called(1);
    });
    test('DeleteCredentialsFailure', () {
      when(() => accountRepository.logOut(any())).thenThrow(const DeleteCredentialsFailure(''));

      final account = _MockAccount();

      bloc.removeAccount(account);
      verify(() => accountRepository.logOut(account)).called(1);
    });
  });

  test('setActiveAccount', () {
    when(() => accountRepository.switchAccount(any())).thenAnswer((_) async {});

    final account = _MockAccount();
    when(() => account.id).thenReturn('id');

    bloc.setActiveAccount(account);
    verify(() => accountRepository.switchAccount('id')).called(1);
  });

  test('accounts', () async {
    when(() => accountRepository.getRemoteWipeStatus(any())).thenAnswer((_) async => false);

    final account = _MockAccount();
    when(() => account.id).thenReturn('id');

    accounts.add((accounts: BuiltList([account]), active: null));

    await Future<void>.delayed(const Duration(milliseconds: 1));

    expect(bloc.accounts, emits(BuiltList<Account>([account])));
    verify(() => accountRepository.getRemoteWipeStatus(account)).called(1);
  });

  test('activeAccount', () async {
    when(() => accountRepository.getRemoteWipeStatus(any())).thenAnswer((_) async => false);

    final account = _MockAccount();
    when(() => account.id).thenReturn('id');

    accounts.add((accounts: BuiltList([account]), active: account));

    await Future<void>.delayed(const Duration(milliseconds: 1));

    expect(bloc.activeAccount, emits(account));
    verify(() => accountRepository.getRemoteWipeStatus(account)).called(1);
  });

  test('hasAccounts', () async {
    when(() => accountRepository.getRemoteWipeStatus(any())).thenAnswer((_) async => false);

    final account = _MockAccount();
    when(() => account.id).thenReturn('id');

    accounts.add((accounts: BuiltList([account]), active: account));

    await Future<void>.delayed(const Duration(milliseconds: 1));

    expect(bloc.hasAccounts, true);
    verify(() => accountRepository.getRemoteWipeStatus(account)).called(1);
  });

  test('accountByID', () {
    final account = _MockAccount();
    when(() => account.id).thenReturn('id');

    when(() => accountRepository.accountByID(any())).thenReturn(account);

    expect(bloc.accountByID('id'), account);
    verify(() => accountRepository.accountByID('id')).called(1);
  });

  group('Remote wipe', () {
    group('Should not wipe', () {
      test('Status false', () async {
        when(() => accountRepository.getRemoteWipeStatus(any())).thenAnswer((_) async => false);

        final account = _MockAccount();
        when(() => account.id).thenReturn('id');

        accounts.add((accounts: BuiltList([account]), active: account));

        await Future<void>.delayed(const Duration(milliseconds: 1));

        verify(() => accountRepository.getRemoteWipeStatus(account)).called(1);
      });

      test('GetRemoteWipeStatusFailure', () async {
        when(() => accountRepository.getRemoteWipeStatus(any())).thenThrow(const GetRemoteWipeStatusFailure(''));

        final account = _MockAccount();
        when(() => account.id).thenReturn('id');

        accounts.add((accounts: BuiltList([account]), active: account));

        await Future<void>.delayed(const Duration(milliseconds: 1));

        verify(() => accountRepository.getRemoteWipeStatus(account)).called(1);
      });
    });

    group('Should wipe', () {
      setUp(() {
        when(() => accountRepository.getRemoteWipeStatus(any())).thenAnswer((_) async => true);
        when(() => accountRepository.logOut(any())).thenAnswer((_) async {});
      });

      test('Post success', () async {
        when(() => accountRepository.postRemoteWipeSuccess(any())).thenAnswer((_) async {});

        final account = _MockAccount();
        when(() => account.id).thenReturn('id');

        accounts.add((accounts: BuiltList([account]), active: account));

        await Future<void>.delayed(const Duration(milliseconds: 1));

        verify(() => accountRepository.getRemoteWipeStatus(account)).called(1);
        verify(() => accountRepository.logOut(account)).called(1);
        verify(() => accountRepository.postRemoteWipeSuccess(account)).called(1);
      });

      test('PostRemoteWipeSuccessFailure', () async {
        when(() => accountRepository.postRemoteWipeSuccess(any())).thenThrow(const PostRemoteWipeSuccessFailure(''));

        final account = _MockAccount();
        when(() => account.id).thenReturn('id');

        accounts.add((accounts: BuiltList([account]), active: account));

        await Future<void>.delayed(const Duration(milliseconds: 1));

        verify(() => accountRepository.getRemoteWipeStatus(account)).called(1);
        verify(() => accountRepository.logOut(account)).called(1);
        verify(() => accountRepository.postRemoteWipeSuccess(account)).called(1);
      });
    });
  });
}
