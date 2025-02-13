import 'dart:async';
import 'dart:convert';

import 'package:account_repository/src/models/models.dart';
import 'package:account_repository/src/utils/utils.dart';
import 'package:built_collection/built_collection.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:neon_framework/storage.dart';
import 'package:nextcloud/core.dart' as core;
import 'package:nextcloud/nextcloud.dart';
import 'package:rxdart/rxdart.dart';

part 'account_storage.dart';

/// Signature of a callback that executed right before the [account] is logged out.
typedef BeforeLogOutCallback = Future<void> Function(Account account);

/// {@template account_failure}
/// A base failure for the account repository failures.
/// {@endtemplate}
sealed class AccountFailure with EquatableMixin implements Exception {
  /// {@macro account_failure}
  const AccountFailure(this.error);

  /// The error which was thrown.
  final Object error;

  @override
  List<Object> get props => [error];
}

/// {@template fetch_status_failure}
/// Thrown when fetching the server status fails.
/// {@endtemplate}
final class FetchStatusFailure extends AccountFailure {
  /// {@macro fetch_status_failure}
  const FetchStatusFailure(super.error);
}

/// {@template init_login_failure}
/// Thrown when initializing the login flow fails.
/// {@endtemplate}
final class InitLoginFailure extends AccountFailure {
  /// {@macro init_login_failure}
  const InitLoginFailure(super.error);
}

/// {@template poll_login_failure}
/// Thrown when polling the login flow fails.
/// {@endtemplate}
final class PollLoginFailure extends AccountFailure {
  /// {@macro poll_login_failure}
  const PollLoginFailure(super.error);
}

/// {@template fetch_account_failure}
/// Thrown when fetching the account information fails.
/// {@endtemplate}
final class FetchAccountFailure extends AccountFailure {
  /// {@macro fetch_account_failure}
  const FetchAccountFailure(super.error);
}

/// {@template delete_credentials_failure}
/// Thrown when deleting the account credentials fails.
///
/// This can happen when the user logs out but removing the app password on the server fails.
/// {@endtemplate}
final class DeleteCredentialsFailure extends AccountFailure {
  /// {@macro delete_credentials_failure}
  const DeleteCredentialsFailure(super.error);
}

/// {@template account_repository}
/// A repository that manages the account data.
/// {@endtemplate}
class AccountRepository {
  /// {@macro account_repository}
  AccountRepository({
    required String userAgent,
    required http.Client httpClient,
    required AccountStorage storage,
  })  : _userAgent = userAgent,
        _httpClient = httpClient,
        _storage = storage;

  final String _userAgent;
  final http.Client _httpClient;
  final AccountStorage _storage;
  final List<BeforeLogOutCallback> _beforeLogOutCallbacks = [];

  final BehaviorSubject<({String? active, BuiltMap<String, Account> accounts})> _accounts =
      BehaviorSubject.seeded((active: null, accounts: BuiltMap()));

  /// A stream of account information.
  ///
  /// The initial state of the stream will be `(active: null, accounts: BuiltMap())`.
  Stream<({Account? active, BuiltList<Account> accounts})> get accounts => _accounts.stream.map((e) {
        final active = e.accounts[e.active];
        final accounts = e.accounts.values.toBuiltList();

        return (active: active, accounts: accounts);
      }).asBroadcastStream();

  /// Whether accounts are logged in.
  bool get hasAccounts {
    return _accounts.hasValue && _accounts.value.accounts.isNotEmpty;
  }

  /// Retrieves the account associated with the given [accountID].
  Account? accountByID(String accountID) {
    return _accounts.value.accounts[accountID];
  }

  /// Checks whether the provided [url] is a valid login qr code.
  static bool isLogInQRCode({required String url}) {
    return LoginQRcode.tryParse(url) != null;
  }

  /// Loads the stored account information.
  ///
  /// If specified [rememberLastUsedAccount] takes precedence over [initialAccount].
  /// If the stored or provided initial account are not in the list of stored credentials
  /// they are silently ignored and the default of `first account in the list` is used.
  Future<void> loadAccounts({
    String? initialAccount,
    bool rememberLastUsedAccount = false,
  }) async {
    final stored = await _storage.readCredentials();
    final accounts = BuiltMap<String, Account>.build((b) {
      for (final credentials in stored) {
        b[credentials.id] = Account((b) {
          b
            ..credentials.replace(credentials)
            ..client = buildClient(
              httpClient: _httpClient,
              userAgent: _userAgent,
              credentials: credentials,
            );
        });
      }
    });

    var active = initialAccount;
    if (rememberLastUsedAccount) {
      active = await _storage.readLastAccount();
    }

    if (active == null || !accounts.containsKey(active)) {
      active = accounts.keys.firstOrNull;
    }

    _accounts.add(
      (
        active: active,
        accounts: accounts,
      ),
    );
  }

  /// Fetches the status of the server.
  ///
  /// May throw a [FetchStatusFailure].
  Future<core.Status> getServerStatus(Uri serverURL) async {
    final client = buildUnauthenticatedClient(
      httpClient: _httpClient,
      userAgent: _userAgent,
      serverURL: serverURL,
    );

    try {
      final response = await client.authentication.core.getStatus();
      return response.body;
    } on http.ClientException catch (error, stackTrace) {
      Error.throwWithStackTrace(FetchStatusFailure(error), stackTrace);
    }
  }

  /// Initializes the Nextcloud login flow.
  ///
  /// May throw a [InitLoginFailure].
  Future<(Uri loginUrl, String token)> loginFlowInit(Uri serverURL) async {
    final client = buildUnauthenticatedClient(
      httpClient: _httpClient,
      userAgent: _userAgent,
      serverURL: serverURL,
    );

    try {
      final initResponse = await client.authentication.clientFlowLoginV2.init();

      final loginUrl = Uri.parse(initResponse.body.login);
      final token = initResponse.body.poll.token;

      return (loginUrl, token);
    } on http.ClientException catch (error, stackTrace) {
      Error.throwWithStackTrace(InitLoginFailure(error), stackTrace);
    }
  }

  /// Polls the login flow endpoint and returns the retrieved credentials.
  ///
  /// Throws a [PollLoginFailure] when polling the endpoint fails. The flow must be initialized
  /// again if a failure occurs.
  Future<Credentials?> loginFlowPoll(Uri serverURL, String token) async {
    final client = buildUnauthenticatedClient(
      httpClient: _httpClient,
      userAgent: _userAgent,
      serverURL: serverURL,
    );

    final body = core.ClientFlowLoginV2PollRequestApplicationJson((b) {
      b.token = token;
    });

    try {
      final resultResponse = await client.authentication.clientFlowLoginV2.poll($body: body);

      final response = resultResponse.body;
      return Credentials((b) {
        b
          ..serverURL = Uri.parse(response.server)
          ..username = response.loginName
          ..appPassword = response.appPassword;
      });
    } on http.ClientException catch (error, stackTrace) {
      if (error case DynamiteStatusCodeException(statusCode: 404)) {
        return null;
      }

      Error.throwWithStackTrace(PollLoginFailure(error), stackTrace);
    }
  }

  /// Fetches the information for the account with the given [credentials].
  ///
  /// May throw a [FetchAccountFailure].
  Future<Account> getAccount(Credentials credentials) async {
    final client = buildClient(
      credentials: credentials,
      userAgent: _userAgent,
      httpClient: _httpClient,
    );

    try {
      final response = await client.authentication.users.getCurrentUser();

      return Account((b) {
        b
          ..client = client
          ..credentials.replace(credentials)
          ..credentials.username = response.body.ocs.data.id;
      });
    } on http.ClientException catch (error, stackTrace) {
      Error.throwWithStackTrace(FetchAccountFailure(error), stackTrace);
    }
  }

  /// Logs in the given [account].
  ///
  /// It will also set the active account if none is active yet.
  Future<void> logIn(Account account) async {
    final value = _accounts.value;

    final active = account.credentials.id;
    final accounts = value.accounts.rebuild((b) {
      b[account.credentials.id] = account;
    });

    _accounts.add((active: active, accounts: accounts));
    await Future.wait([
      _storage.saveCredentials(accounts.values.map((e) => e.credentials)),
      _storage.saveLastAccount(active),
    ]);
  }

  /// Registers a new [callback] that is executed right before an account is logged out.
  ///
  /// The callback must not throw any exceptions and handle them gracefully itself.
  void registerBeforeLogOutCallback(BeforeLogOutCallback callback) {
    _beforeLogOutCallbacks.add(callback);
  }

  /// Unregisters a [callback] that was previously registered with [registerBeforeLogOutCallback].
  void unregisterBeforeLogOutCallback(BeforeLogOutCallback callback) {
    _beforeLogOutCallbacks.remove(callback);
  }

  /// Logs out the user from the server.
  ///
  /// May throw a [DeleteCredentialsFailure].
  Future<void> logOut(String accountID) async {
    final value = _accounts.value;

    Account? account;
    final accounts = value.accounts.rebuild((b) {
      account = b.remove(accountID);
    });

    if (account == null) {
      return;
    }

    var active = value.active;
    if (active == accountID) {
      active = accounts.keys.firstOrNull;
    }

    await Future.wait([
      _storage.saveCredentials(accounts.values.map((e) => e.credentials)),
      _storage.saveLastAccount(active),
    ]);

    _accounts.add((active: active, accounts: accounts));

    for (final callback in _beforeLogOutCallbacks) {
      await callback(account!);
    }

    try {
      await account!.client.authentication.appPassword.deleteAppPassword();
    } on http.ClientException catch (error, stackTrace) {
      Error.throwWithStackTrace(DeleteCredentialsFailure(error), stackTrace);
    }
  }

  /// Deletes the current user account.
  ///
  /// Not yet implemented see: https://github.com/nextcloud/neon/issues/2177
  Future<void> deleteAccount() async {
    throw UnimplementedError();
  }

  /// Sets the active `account` to [accountID].
  ///
  /// Throws an [ArgumentError] when the id is not in the accounts map.
  Future<void> switchAccount(String accountID) async {
    final value = _accounts.value;

    if (!value.accounts.containsKey(accountID)) {
      throw ArgumentError.value(accountID, 'accountID', 'is not a logged in account');
    }

    _accounts.add((active: accountID, accounts: value.accounts));
    await _storage.saveLastAccount(accountID);
  }
}
