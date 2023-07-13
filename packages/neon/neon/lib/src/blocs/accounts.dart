import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:neon/src/bloc/bloc.dart';
import 'package:neon/src/blocs/apps.dart';
import 'package:neon/src/blocs/capabilities.dart';
import 'package:neon/src/blocs/user_details.dart';
import 'package:neon/src/blocs/user_statuses.dart';
import 'package:neon/src/models/account.dart';
import 'package:neon/src/models/app_implementation.dart';
import 'package:neon/src/platform/platform.dart';
import 'package:neon/src/settings/models/storage.dart';
import 'package:neon/src/utils/account_options.dart';
import 'package:neon/src/utils/global_options.dart';
import 'package:neon/src/utils/request_manager.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _keyAccounts = 'accounts';

abstract interface class AccountsBlocEvents {
  /// Logs in the given [account].
  ///
  /// It will also call [setActiveAccount] when no other accounts are registered in [AccountsBlocStates.accounts].
  void addAccount(final Account account);

  /// Logs out the given [account].
  ///
  /// If [account] is the current [AccountsBlocStates.activeAccount] it will automatically activate the first one in [AccountsBlocStates.accounts].
  /// It is not defined whether listeners of [AccountsBlocStates.accounts] or [AccountsBlocStates.activeAccount] are informed first.
  void removeAccount(final Account account);

  /// Updates the given [account].
  ///
  /// It triggers an event in both [AccountsBlocStates.accounts] and [AccountsBlocStates.activeAccount] to inform all listeners.
  void updateAccount(final Account account);

  /// Sets the active [account].
  ///
  /// It triggers an event in [AccountsBlocStates.activeAccount] to inform all listeners.
  void setActiveAccount(final Account account);
}

abstract interface class AccountsBlocStates {
  /// All registered accounts.
  ///
  /// An empty value represents a state where no account is logged in.
  BehaviorSubject<List<Account>> get accounts;

  /// Currently active account.
  ///
  /// It should be ensured to only emit an event when it's value changes.
  /// A null value represents a state where no user is logged in.
  BehaviorSubject<Account?> get activeAccount;
}

class AccountsBloc extends Bloc implements AccountsBlocEvents, AccountsBlocStates {
  AccountsBloc(
    this._requestManager,
    this._platform,
    this._sharedPreferences,
    this._globalOptions,
    this._allAppImplementations,
  ) {
    accounts
      ..add(loadAccounts(_storage))
      ..listen((final as) async {
        _globalOptions.updateAccounts(as);
        await _storage.setStringList(_keyAccounts, as.map((final a) => json.encode(a.toJson())).toList());
      });
    activeAccount.listen((final aa) async {
      if (aa != null) {
        await _storage.setString(_keyLastUsedAccount, aa.id);
      } else {
        await _storage.remove(_keyLastUsedAccount);
      }
    });

    final as = accounts.value;

    if (_globalOptions.rememberLastUsedAccount.value && _storage.containsKey(_keyLastUsedAccount)) {
      final lastUsedAccountID = _storage.getString(_keyLastUsedAccount);
      if (lastUsedAccountID != null) {
        final aa = as.tryFind(lastUsedAccountID);
        if (aa != null) {
          setActiveAccount(aa);
        }
      }
    }

    final account = as.tryFind(_globalOptions.initialAccount.value);
    if (activeAccount.valueOrNull == null) {
      if (account != null) {
        setActiveAccount(account);
      } else if (as.isNotEmpty) {
        setActiveAccount(as.first);
      }
    }
  }

  final RequestManager _requestManager;
  final NeonPlatform _platform;
  late final AppStorage _storage = AppStorage('accounts', _sharedPreferences);
  final SharedPreferences _sharedPreferences;
  final GlobalOptions _globalOptions;
  final Iterable<AppImplementation> _allAppImplementations;
  final _keyLastUsedAccount = 'last-used-account';

  final _accountsOptions = <String, AccountSpecificOptions>{};
  final _appsBlocs = <String, AppsBloc>{};
  final _capabilitiesBlocs = <String, CapabilitiesBloc>{};
  final _userDetailsBlocs = <String, UserDetailsBloc>{};
  final _userStatusesBlocs = <String, UserStatusesBloc>{};

  @override
  void dispose() {
    unawaited(activeAccount.close());
    unawaited(accounts.close());
    _appsBlocs.disposeAll();
    _capabilitiesBlocs.disposeAll();
    _userDetailsBlocs.disposeAll();
    _userStatusesBlocs.disposeAll();
    for (final options in _accountsOptions.values) {
      options.dispose();
    }
  }

  @override
  BehaviorSubject<List<Account>> accounts = BehaviorSubject<List<Account>>.seeded([]);

  @override
  BehaviorSubject<Account?> activeAccount = BehaviorSubject<Account?>.seeded(null)
    ..distinct((final current, final next) => current?.id != next?.id);

  @override
  void addAccount(final Account account) {
    if (activeAccount.valueOrNull == null) {
      setActiveAccount(account);
    }
    accounts.add(accounts.value..add(account));
  }

  @override
  void removeAccount(final Account account) {
    accounts.add(accounts.value..removeWhere((final a) => a.id == account.id));

    final as = accounts.value;
    final aa = activeAccount.valueOrNull;
    if (aa?.id == account.id) {
      if (as.firstOrNull != null) {
        setActiveAccount(as.first);
      } else {
        activeAccount.add(null);
      }
    }

    unawaited(() async {
      try {
        await account.client.core.deleteAppPassword();
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
      }
    }());
  }

  @override
  void setActiveAccount(final Account account) {
    activeAccount.add(account);
  }

  @override
  void updateAccount(final Account account) {
    final as = accounts.value;
    final index = as.indexWhere((final a) => a.id == account.id);
    if (index == -1) {
      // TODO: Figure out how we can remove the old account without potentially race conditioning
      as.add(account);
    } else {
      as.replaceRange(
        index,
        index + 1,
        [account],
      );
    }

    accounts.add(as);
    setActiveAccount(account);
  }

  /// The currently active account.
  ///
  /// Equivalent to activeAccount.value but throws a [StateError] when no user is logged in.
  @visibleForTesting
  Account get aa {
    final aa = activeAccount.value;

    if (aa == null) {
      throw StateError('No user is logged in.');
    }

    return aa;
  }

  /// The options for the [activeAccount].
  ///
  /// Convenience method for [getOptionsFor] with the currently active account.
  AccountSpecificOptions get activeOptions => getOptionsFor(aa);

  /// The options for the specified [account].
  ///
  /// Use [activeOptions] to get them for the [activeAccount].
  AccountSpecificOptions getOptionsFor(final Account account) =>
      _accountsOptions[account.id] ??= AccountSpecificOptions(
        AppStorage('accounts-${account.id}', _sharedPreferences),
        getAppsBlocFor(account),
      );

  /// The appsBloc for the [activeAccount].
  ///
  /// Convenience method for [getAppsBlocFor] with the currently active account.
  AppsBloc get activeAppsBloc => getAppsBlocFor(aa);

  /// The appsBloc for the specified [account].
  ///
  /// Use [activeAppsBloc] to get them for the [activeAccount].
  AppsBloc getAppsBlocFor(final Account account) {
    if (_appsBlocs[account.id] != null) {
      return _appsBlocs[account.id]!;
    }

    return _appsBlocs[account.id] = AppsBloc(
      _requestManager,
      getCapabilitiesBlocFor(account),
      this,
      account,
      _allAppImplementations,
    );
  }

  /// The capabilitiesBloc for the [activeAccount].
  ///
  /// Convenience method for [getCapabilitiesBlocFor] with the currently active account.
  CapabilitiesBloc get activeCapabilitiesBloc => getCapabilitiesBlocFor(aa);

  /// The capabilitiesBloc for the specified [account].
  ///
  /// Use [activeCapabilitiesBloc] to get them for the [activeAccount].
  CapabilitiesBloc getCapabilitiesBlocFor(final Account account) {
    if (_capabilitiesBlocs[account.id] != null) {
      return _capabilitiesBlocs[account.id]!;
    }

    return _capabilitiesBlocs[account.id] = CapabilitiesBloc(
      _requestManager,
      account.client,
    );
  }

  /// The userDetailsBloc for the [activeAccount].
  ///
  /// Convenience method for [getUserDetailsBlocFor] with the currently active account.
  UserDetailsBloc get activeUerDetailsBloc => getUserDetailsBlocFor(aa);

  /// The userDetailsBloc for the specified [account].
  ///
  /// Use [activeUerDetailsBloc] to get them for the [activeAccount].
  UserDetailsBloc getUserDetailsBlocFor(final Account account) {
    if (_userDetailsBlocs[account.id] != null) {
      return _userDetailsBlocs[account.id]!;
    }

    return _userDetailsBlocs[account.id] = UserDetailsBloc(
      _requestManager,
      account.client,
    );
  }

  /// The userStatusBloc for the [activeAccount].
  ///
  /// Convenience method for [getUserStatusesBlocFor] with the currently active account.
  UserStatusesBloc get activeUserStatusesBloc => getUserStatusesBlocFor(aa);

  /// The userStatusBloc for the specified [account].
  ///
  /// Use [activeUserStatusesBloc] to get them for the [activeAccount].
  UserStatusesBloc getUserStatusesBlocFor(final Account account) {
    if (_userStatusesBlocs[account.id] != null) {
      return _userStatusesBlocs[account.id]!;
    }

    return _userStatusesBlocs[account.id] = UserStatusesBloc(
      _platform,
      account,
    );
  }
}

/// Get a list of logged in accounts from [storage].
///
/// It is not checked whether the stored information is still valid.
List<Account> loadAccounts(final AppStorage storage) {
  if (storage.containsKey(_keyAccounts)) {
    return storage
        .getStringList(_keyAccounts)!
        .map((final a) => Account.fromJson(json.decode(a) as Map<String, dynamic>))
        .toList();
  }
  return [];
}
