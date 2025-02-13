import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:built_collection/built_collection.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_framework/src/blocs/maintenance_mode.dart';
import 'package:neon_framework/src/blocs/unified_search.dart';
import 'package:neon_framework/src/models/account_cache.dart';
import 'package:neon_framework/src/models/disposable.dart';
import 'package:neon_framework/src/storage/keys.dart';
import 'package:neon_framework/src/utils/account_options.dart';
import 'package:neon_framework/storage.dart';
import 'package:rxdart/rxdart.dart';

/// The Bloc responsible for managing the [Account]s
@sealed
abstract interface class AccountsBloc implements Disposable {
  @internal
  factory AccountsBloc({
    required BuiltSet<AppImplementation> allAppImplementations,
    required AccountRepository accountRepository,
  }) = _AccountsBloc;

  /// Logs out the given [account].
  ///
  /// If [account] is the current [AccountsBloc.activeAccount] it will automatically activate the first one in [AccountsBloc.accounts].
  /// It is not defined whether listeners of [AccountsBloc.accounts] or [AccountsBloc.activeAccount] are informed first.
  void removeAccount(Account account);

  /// Sets the active [account].
  ///
  /// It triggers an event in [AccountsBloc.activeAccount] to inform all listeners.
  void setActiveAccount(Account account);

  /// All registered accounts.
  ///
  /// An empty value represents a state where no account is logged in.
  BehaviorSubject<BuiltList<Account>> get accounts;

  /// Currently active account.
  ///
  /// It should be ensured to only emit an event when it's value changes.
  /// A null value represents a state where no user is logged in.
  BehaviorSubject<Account?> get activeAccount;

  /// Whether accounts are logged in.
  bool get hasAccounts;

  /// Returns the account identified by the given id.
  Account? accountByID(String accountID);

  /// The options for the specified [account].
  AccountOptions getOptionsFor(Account account);

  /// The appsBloc for the specified [account].
  AppsBloc getAppsBlocFor(Account account);

  /// The capabilitiesBloc for the specified [account].
  CapabilitiesBloc getCapabilitiesBlocFor(Account account);

  /// The userDetailsBloc for the specified [account].
  UserDetailsBloc getUserDetailsBlocFor(Account account);

  /// The userStatusBloc for the specified [account].
  UserStatusBloc getUserStatusBlocFor(Account account);

  /// The UnifiedSearchBloc for the specified [account].
  UnifiedSearchBloc getUnifiedSearchBlocFor(Account account);

  /// The WeatherStatusBloc for the specified [account].
  WeatherStatusBloc getWeatherStatusBlocFor(Account account);

  /// The MaintenanceModeBloc for the specified [account].
  MaintenanceModeBloc getMaintenanceModeBlocFor(Account account);

  /// The ReferencesBloc for the specified [account].
  ReferencesBloc getReferencesBlocFor(Account account);
}

/// Implementation of [AccountsBloc].
class _AccountsBloc extends Bloc implements AccountsBloc {
  /// Creates a new account bloc.
  ///
  /// The last state will be loaded from storage and all necessary listeners
  /// will be set up.
  _AccountsBloc({
    required this.allAppImplementations,
    required AccountRepository accountRepository,
  }) : _accountRepository = accountRepository {
    accountRepository.accounts.listen((event) {
      accounts.add(event.accounts);

      final active = event.active;
      if (active != null) {
        activeAccount.add(active);
      }
    });

    accounts.listen((accounts) {
      accountsOptions.pruneAgainst(accounts);
      appsBlocs.pruneAgainst(accounts);
      capabilitiesBlocs.pruneAgainst(accounts);
      userDetailsBlocs.pruneAgainst(accounts);
      userStatusBlocs.pruneAgainst(accounts);
      unifiedSearchBlocs.pruneAgainst(accounts);
      weatherStatusBlocs.pruneAgainst(accounts);
      maintenanceModeBlocs.pruneAgainst(accounts);
      for (final app in allAppImplementations) {
        app.blocsCache.pruneAgainst(accounts);
      }
      unawaited(checkRemoteWipe(accounts));
    });
  }

  @override
  final log = Logger('AccountsBloc');

  final BuiltSet<AppImplementation> allAppImplementations;
  final AccountRepository _accountRepository;

  final accountsOptions = AccountCache<AccountOptions>();
  final appsBlocs = AccountCache<AppsBloc>();
  final capabilitiesBlocs = AccountCache<CapabilitiesBloc>();
  final userDetailsBlocs = AccountCache<UserDetailsBloc>();
  final userStatusBlocs = AccountCache<UserStatusBloc>();
  final unifiedSearchBlocs = AccountCache<UnifiedSearchBloc>();
  final weatherStatusBlocs = AccountCache<WeatherStatusBloc>();
  final maintenanceModeBlocs = AccountCache<MaintenanceModeBloc>();
  final referencesBlocs = AccountCache<ReferencesBloc>();
  final remoteWipeChecks = <Account>{};

  @override
  void dispose() {
    unawaited(activeAccount.close());
    unawaited(accounts.close());
    appsBlocs.dispose();
    capabilitiesBlocs.dispose();
    userDetailsBlocs.dispose();
    userStatusBlocs.dispose();
    unifiedSearchBlocs.dispose();
    weatherStatusBlocs.dispose();
    maintenanceModeBlocs.dispose();
    referencesBlocs.dispose();
    accountsOptions.dispose();
  }

  @override
  final accounts = BehaviorSubject.seeded(BuiltList());

  @override
  final activeAccount = BehaviorSubject();

  @override
  Future<void> removeAccount(Account account) async {
    try {
      await _accountRepository.logOut(account);
    } on DeleteCredentialsFailure catch (error, stackTrace) {
      log.info(
        'Error deleting the app password.',
        error,
        stackTrace,
      );
    }
  }

  @override
  Future<void> setActiveAccount(Account account) async {
    await _accountRepository.switchAccount(account.id);
  }

  @override
  bool get hasAccounts => activeAccount.valueOrNull != null;

  @override
  Account? accountByID(String accountID) {
    return _accountRepository.accountByID(accountID);
  }

  @override
  AccountOptions getOptionsFor(Account account) => accountsOptions[account] ??= AccountOptions(
        NeonStorage().settingsStore(StorageKeys.accountOptions, account.id),
      );

  @override
  AppsBloc getAppsBlocFor(Account account) => appsBlocs[account] ??= AppsBloc(
        capabilitiesSubject: getCapabilitiesBlocFor(account).capabilities,
        account: account,
        accountOptions: getOptionsFor(account),
        allAppImplementations: allAppImplementations,
      );

  @override
  CapabilitiesBloc getCapabilitiesBlocFor(Account account) => capabilitiesBlocs[account] ??= CapabilitiesBloc(
        account: account,
      );

  @override
  UserDetailsBloc getUserDetailsBlocFor(Account account) => userDetailsBlocs[account] ??= UserDetailsBloc(
        account: account,
      );

  @override
  UserStatusBloc getUserStatusBlocFor(Account account) => userStatusBlocs[account] ??= UserStatusBloc(
        account: account,
      );

  @override
  UnifiedSearchBloc getUnifiedSearchBlocFor(Account account) => unifiedSearchBlocs[account] ??= UnifiedSearchBloc(
        activeAppSubject: getAppsBlocFor(account).activeApp,
        account: account,
      );

  @override
  WeatherStatusBloc getWeatherStatusBlocFor(Account account) => weatherStatusBlocs[account] ??= WeatherStatusBloc(
        capabilities: getCapabilitiesBlocFor(account).capabilities,
        account: account,
      );

  @override
  MaintenanceModeBloc getMaintenanceModeBlocFor(Account account) =>
      maintenanceModeBlocs[account] ??= MaintenanceModeBloc(
        account: account,
      );

  @override
  ReferencesBloc getReferencesBlocFor(Account account) => referencesBlocs[account] ??= ReferencesBloc(
        account: account,
        capabilities: getCapabilitiesBlocFor(account).capabilities,
      );

  Future<void> checkRemoteWipe(BuiltList<Account> accounts) async {
    for (final account in accounts) {
      // Only check each account once per app start
      if (remoteWipeChecks.contains(account)) {
        return;
      }
      remoteWipeChecks.add(account);

      log.finer('Checking remote wipe status for account ${account.id}.');

      try {
        final wipe = await _accountRepository.getRemoteWipeStatus(account);
        if (!wipe) {
          return;
        }

        log.finer('Wiping account ${account.id}.');

        await removeAccount(account);

        try {
          await _accountRepository.postRemoteWipeSuccess(account);
        } on PostRemoteWipeSuccessFailure catch (error, stackTrace) {
          log.finer(
            'Failed to post remote wipe success for account ${account.id}.',
            error,
            stackTrace,
          );
        }

        log.finer('Wiped account ${account.id}.');
      } on GetRemoteWipeStatusFailure catch (error, stackTrace) {
        log.finer(
          'Failed to get remote wipe status for account ${account.id}.',
          error,
          stackTrace,
        );
      }
    }
  }
}
