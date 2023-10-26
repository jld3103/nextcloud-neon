// ignore_for_file: unnecessary_overrides

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meta/meta.dart';
import 'package:neon/src/blocs/accounts.dart';
import 'package:neon/src/models/account.dart';
import 'package:neon/src/models/client_implementation.dart';
import 'package:neon/src/pages/account_settings.dart';
import 'package:neon/src/pages/client_settings.dart';
import 'package:neon/src/pages/home.dart';
import 'package:neon/src/pages/login.dart';
import 'package:neon/src/pages/login_check_account.dart';
import 'package:neon/src/pages/login_check_server_status.dart';
import 'package:neon/src/pages/login_flow.dart';
import 'package:neon/src/pages/login_qr_code.dart';
import 'package:neon/src/pages/route_not_found.dart';
import 'package:neon/src/pages/settings.dart';
import 'package:neon/src/utils/provider.dart';
import 'package:neon/src/utils/stream_listenable.dart';

part 'router.g.dart';

@internal
GoRouter buildAppRouter({
  required final GlobalKey<NavigatorState> navigatorKey,
  required final AccountsBloc accountsBloc,
}) =>
    GoRouter(
      debugLogDiagnostics: kDebugMode,
      refreshListenable: StreamListenable(accountsBloc.activeAccount),
      navigatorKey: navigatorKey,
      initialLocation: const HomeRoute().location,
      errorPageBuilder: _buildErrorPage,
      redirect: (final context, final state) {
        final loginQRcode = LoginQRcode.tryParse(state.uri.toString());
        if (loginQRcode != null) {
          return LoginCheckServerStatusRoute.withCredentials(
            serverUrl: loginQRcode.serverURL,
            loginName: loginQRcode.username,
            password: loginQRcode.password,
          ).location;
        }

        if (accountsBloc.hasAccounts && state.uri.hasScheme) {
          final strippedUri = accountsBloc.activeAccount.value!.stripUri(state.uri);
          if (strippedUri != state.uri) {
            return strippedUri.toString();
          }
        }

        // redirect to login screen when no account is logged in
        if (!accountsBloc.hasAccounts && !state.uri.toString().startsWith(const LoginRoute().location)) {
          return const LoginRoute().location;
        }

        return null;
      },
      routes: $appRoutes,
    );

Page<void> _buildErrorPage(final BuildContext context, final GoRouterState state) => MaterialPage(
      child: RouteNotFoundPage(
        uri: state.uri,
      ),
    );

@immutable
class AccountSettingsRoute extends GoRouteData {
  const AccountSettingsRoute({
    required this.accountID,
  });

  final String accountID;

  @override
  Widget build(final BuildContext context, final GoRouterState state) {
    final bloc = NeonProvider.of<AccountsBloc>(context);
    final account = bloc.accounts.value.find(accountID);

    return AccountSettingsPage(
      bloc: bloc,
      account: account,
    );
  }
}

@TypedGoRoute<HomeRoute>(
  path: '/',
  name: 'home',
  routes: [
    TypedGoRoute<SettingsRoute>(
      path: 'settings',
      name: 'Settings',
      routes: [
        TypedGoRoute<NextcloudClientSettingsRoute>(
          path: 'apps/:clientid',
          name: 'NextcloudClientSettings',
        ),
        TypedGoRoute<_AddAccountRoute>(
          path: 'account/add',
          name: 'addAccount',
          routes: [
            TypedGoRoute<_AddAccountFlowRoute>(
              path: 'flow',
            ),
            TypedGoRoute<_AddAccountQRcodeRoute>(
              path: 'qr-code',
            ),
            TypedGoRoute<_AddAccountCheckServerStatusRoute>(
              path: 'check/server',
            ),
            TypedGoRoute<_AddAccountCheckAccountRoute>(
              path: 'check/account',
            ),
          ],
        ),
        TypedGoRoute<AccountSettingsRoute>(
          path: 'account/:accountID',
          name: 'AccountSettings',
        ),
      ],
    ),
  ],
)
@immutable
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(final BuildContext context, final GoRouterState state) {
    final accountsBloc = NeonProvider.of<AccountsBloc>(context);
    final account = accountsBloc.activeAccount.valueOrNull!;

    return HomePage(key: Key(account.id));
  }
}

@TypedGoRoute<LoginRoute>(
  path: '/login',
  name: 'login',
  routes: [
    TypedGoRoute<LoginFlowRoute>(
      path: 'flow',
    ),
    TypedGoRoute<LoginQRcodeRoute>(
      path: 'qr-code',
    ),
    TypedGoRoute<LoginCheckServerStatusRoute>(
      path: 'check/server',
    ),
    TypedGoRoute<LoginCheckAccountRoute>(
      path: 'check/account',
    ),
  ],
)
@immutable
class LoginRoute extends GoRouteData {
  const LoginRoute();

  @override
  Widget build(final BuildContext context, final GoRouterState state) => const LoginPage();

  @override
  FutureOr<String?> redirect(final BuildContext context, final GoRouterState state) {
    final hasAccounts = NeonProvider.of<AccountsBloc>(context).hasAccounts;

    if (state.fullPath == location && hasAccounts) {
      return const _AddAccountRoute().location;
    }

    return null;
  }
}

@immutable
class LoginFlowRoute extends GoRouteData {
  const LoginFlowRoute({
    required this.serverUrl,
  });

  final Uri serverUrl;

  @override
  Widget build(final BuildContext context, final GoRouterState state) => LoginFlowPage(serverURL: serverUrl);

  @override
  FutureOr<String?> redirect(final BuildContext context, final GoRouterState state) {
    final hasAccounts = NeonProvider.of<AccountsBloc>(context).hasAccounts;

    if (state.fullPath == location && hasAccounts) {
      return _AddAccountFlowRoute(serverUrl: serverUrl).location;
    }

    return null;
  }
}

@immutable
class LoginQRcodeRoute extends GoRouteData {
  const LoginQRcodeRoute();

  @override
  Widget build(final BuildContext context, final GoRouterState state) => const LoginQRcodePage();

  @override
  FutureOr<String?> redirect(final BuildContext context, final GoRouterState state) {
    final hasAccounts = NeonProvider.of<AccountsBloc>(context).hasAccounts;

    if (state.fullPath == location && hasAccounts) {
      return const _AddAccountQRcodeRoute().location;
    }

    return null;
  }
}

@immutable
class LoginCheckServerStatusRoute extends GoRouteData {
  const LoginCheckServerStatusRoute({
    required this.serverUrl,
    this.loginName,
    this.password,
  });

  const LoginCheckServerStatusRoute.withCredentials({
    required this.serverUrl,
    required String this.loginName,
    required String this.password,
  }) : assert(!kIsWeb, 'Might leak the password to the browser history');

  final Uri serverUrl;
  final String? loginName;
  final String? password;

  @override
  Widget build(final BuildContext context, final GoRouterState state) {
    if (loginName != null && password != null) {
      return LoginCheckServerStatusPage.withCredentials(
        serverURL: serverUrl,
        loginName: loginName!,
        password: password!,
      );
    }

    return LoginCheckServerStatusPage(
      serverURL: serverUrl,
    );
  }

  @override
  FutureOr<String?> redirect(final BuildContext context, final GoRouterState state) {
    final hasAccounts = NeonProvider.of<AccountsBloc>(context).hasAccounts;

    if (state.fullPath == location && hasAccounts) {
      if (loginName != null && password != null) {
        return _AddAccountCheckServerStatusRoute.withCredentials(
          serverUrl: serverUrl,
          loginName: loginName!,
          password: password!,
        ).location;
      }

      return _AddAccountCheckServerStatusRoute(
        serverUrl: serverUrl,
      ).location;
    }

    return null;
  }
}

@immutable
class LoginCheckAccountRoute extends GoRouteData {
  const LoginCheckAccountRoute({
    required this.serverUrl,
    required this.loginName,
    required this.password,
  }) : assert(!kIsWeb, 'Might leak the password to the browser history');

  final Uri serverUrl;
  final String loginName;
  final String password;

  @override
  Widget build(final BuildContext context, final GoRouterState state) => LoginCheckAccountPage(
        serverURL: serverUrl,
        loginName: loginName,
        password: password,
      );

  @override
  FutureOr<String?> redirect(final BuildContext context, final GoRouterState state) {
    final hasAccounts = NeonProvider.of<AccountsBloc>(context).hasAccounts;

    if (state.fullPath == location && hasAccounts) {
      return _AddAccountCheckAccountRoute(
        serverUrl: serverUrl,
        loginName: loginName,
        password: password,
      ).location;
    }

    return null;
  }
}

@immutable
class _AddAccountRoute extends LoginRoute {
  const _AddAccountRoute();
}

@immutable
class _AddAccountFlowRoute extends LoginFlowRoute {
  const _AddAccountFlowRoute({
    required super.serverUrl,
  });

  @override
  Uri get serverUrl => super.serverUrl;
}

@immutable
class _AddAccountQRcodeRoute extends LoginQRcodeRoute {
  const _AddAccountQRcodeRoute();
}

@immutable
class _AddAccountCheckServerStatusRoute extends LoginCheckServerStatusRoute {
  const _AddAccountCheckServerStatusRoute({
    required super.serverUrl,
  });

  const _AddAccountCheckServerStatusRoute.withCredentials({
    required super.serverUrl,
    required super.loginName,
    required super.password,
  }) : super.withCredentials();

  @override
  Uri get serverUrl => super.serverUrl;
  @override
  String? get loginName => super.loginName;
  @override
  String? get password => super.password;
}

@immutable
class _AddAccountCheckAccountRoute extends LoginCheckAccountRoute {
  const _AddAccountCheckAccountRoute({
    required super.serverUrl,
    required super.loginName,
    required super.password,
  });

  @override
  Uri get serverUrl => super.serverUrl;
  @override
  String get loginName => super.loginName;
  @override
  String get password => super.password;
}

@immutable
class NextcloudClientSettingsRoute extends GoRouteData {
  const NextcloudClientSettingsRoute({
    required this.clientid,
  });

  final String clientid;

  @override
  Widget build(final BuildContext context, final GoRouterState state) {
    final clientImplementations = NeonProvider.of<Iterable<ClientImplementation>>(context);
    final clientImplementation = clientImplementations.tryFind(clientid)!;

    return NextcloudClientSettingsPage(clientImplementation: clientImplementation);
  }
}

@immutable
class SettingsRoute extends GoRouteData {
  const SettingsRoute({this.initialCategory});

  /// The initial category to show.
  final SettingsCategories? initialCategory;

  @override
  Widget build(final BuildContext context, final GoRouterState state) => SettingsPage(initialCategory: initialCategory);
}
