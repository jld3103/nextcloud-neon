import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:neon/src/bloc/bloc.dart';
import 'package:neon/src/bloc/result.dart';
import 'package:neon/src/blocs/accounts.dart';
import 'package:neon/src/blocs/capabilities.dart';
import 'package:neon/src/models/account.dart';
import 'package:neon/src/models/app_implementation.dart';
import 'package:neon/src/models/notifications_interface.dart';
import 'package:neon/src/settings/models/options_collection.dart';
import 'package:neon/src/utils/request_manager.dart';
import 'package:nextcloud/core.dart' as core;
import 'package:nextcloud/nextcloud.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

/// Events for the [AppsBloc].
@internal
abstract interface class AppsBlocEvents {
  /// Sets the active app using the [appID].
  ///
  /// If the app is already the active app nothing will happen.
  /// When using [skipAlreadySet] nothing will be done if there already is an active app.
  void setActiveApp(final String appID, {final bool skipAlreadySet = false});
}

/// States for the [AppsBloc].
@internal
abstract interface class AppsBlocStates {
  /// A collection of clients used in the app drawer.
  ///
  /// It does not contain clients for that are specially handled like for the notifications.
  BehaviorSubject<Result<Iterable<AppImplementation>>> get appImplementations;

  /// The interface of the notifications app.
  BehaviorSubject<Result<NotificationsAppInterface?>> get notificationsAppImplementation;

  /// The currently active app.
  BehaviorSubject<AppImplementation> get activeApp;

  /// A subject emitting an event when the notifications page should be opened.
  BehaviorSubject<void> get openNotifications;

  /// A collection of unsupported apps and their minimum required version.
  BehaviorSubject<Map<String, String?>> get appVersions;
}

/// The Bloc responsible for managing the [AppImplementation]s.
@internal
class AppsBloc extends InteractiveBloc implements AppsBlocEvents, AppsBlocStates {
  /// Creates a new apps bloc.
  AppsBloc(
    this._capabilitiesBloc,
    this._accountsBloc,
    this._account,
    this._allAppImplementations,
  ) {
    _apps.listen((final result) {
      appImplementations
          .add(result.transform((final data) => _filteredAppImplementations(data.map((final a) => a.id))));
    });

    appImplementations.listen((final result) async {
      if (!result.hasData) {
        return;
      }

      // dispose unsupported apps
      for (final app in _allAppImplementations) {
        if (result.requireData.tryFind(app.id) == null) {
          app.blocsCache.remove(_account);
        }
      }

      final options = _accountsBloc.getOptionsFor(_account);
      final initialApp = options.initialApp.value ?? _getInitialAppFallback();
      if (initialApp != null) {
        await setActiveApp(initialApp, skipAlreadySet: true);
      }

      unawaited(_checkCompatibility());
    });

    _capabilitiesBloc.capabilities.listen((final result) {
      notificationsAppImplementation.add(
        result.transform(
          (final data) => data.capabilities.notificationsCapabilities?.notifications != null
              ? _findAppImplementation(AppIDs.notifications)
              : null,
        ),
      );

      unawaited(_checkCompatibility());
    });

    unawaited(refresh());
  }

  /// Determines the appid of initial app.
  ///
  /// It requires [appImplementations] to have both a value and data.
  ///
  /// The files app is always installed and can not be removed so it will be used, but in the
  /// case this changes at a later point the first supported app will be returned.
  ///
  /// Returns null when no app is supported by the server.
  String? _getInitialAppFallback() {
    final supportedApps = appImplementations.value.requireData;

    for (final fallback in {AppIDs.dashboard, AppIDs.files}) {
      if (supportedApps.tryFind(fallback) != null) {
        return fallback;
      }
    }

    if (supportedApps.isNotEmpty) {
      return supportedApps.first.id;
    }

    return null;
  }

  Future<void> _checkCompatibility() async {
    final apps = appImplementations.valueOrNull;
    final capabilities = _capabilitiesBloc.capabilities.valueOrNull;

    // ignore cached data
    if (capabilities == null || apps == null || !capabilities.hasUncachedData || !apps.hasUncachedData) {
      return;
    }

    final notSupported = <String, String?>{};

    try {
      final (coreSupported, coreMinimumVersion) = _account.client.core.isSupported(capabilities.requireData);
      if (!coreSupported) {
        notSupported['core'] = coreMinimumVersion.toString();
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }

    for (final app in apps.requireData) {
      try {
        final (supported, minimumVersion) = await app.isSupported(_account, capabilities.requireData);
        if (!(supported ?? true)) {
          notSupported[app.id] = minimumVersion;
        }
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
      }
    }

    if (notSupported.isNotEmpty) {
      appVersions.add(notSupported);
    }
  }

  T? _findAppImplementation<T extends AppImplementation>(final String id) {
    final matches = _filteredAppImplementations([id]);
    if (matches.isNotEmpty) {
      return matches.single as T;
    }

    return null;
  }

  Iterable<AppImplementation> _filteredAppImplementations(final Iterable<String> appIds) =>
      _allAppImplementations.where((final a) => appIds.contains(a.id));

  final CapabilitiesBloc _capabilitiesBloc;
  final AccountsBloc _accountsBloc;
  final Account _account;
  final Iterable<AppImplementation> _allAppImplementations;
  final _apps = BehaviorSubject<Result<List<core.NavigationEntry>>>();

  @override
  void dispose() {
    unawaited(_apps.close());
    unawaited(appImplementations.close());
    unawaited(notificationsAppImplementation.close());
    unawaited(activeApp.close());
    unawaited(openNotifications.close());
    unawaited(appVersions.close());

    super.dispose();
  }

  @override
  BehaviorSubject<AppImplementation> activeApp = BehaviorSubject();

  @override
  BehaviorSubject<Result<Iterable<AppImplementation<Bloc, NextcloudAppOptions>>>> appImplementations =
      BehaviorSubject();

  @override
  BehaviorSubject<Result<NotificationsAppInterface?>> notificationsAppImplementation = BehaviorSubject();

  @override
  BehaviorSubject<void> openNotifications = BehaviorSubject();

  @override
  BehaviorSubject<Map<String, String?>> appVersions = BehaviorSubject();

  @override
  Future<void> refresh() async {
    await RequestManager.instance.wrapNextcloud(
      _account.id,
      'apps-apps',
      _apps,
      _account.client.core.navigation.getAppsNavigationRaw(),
      (final response) => response.body.ocs.data.toList(),
    );
  }

  @override
  Future<void> setActiveApp(final String appID, {final bool skipAlreadySet = false}) async {
    if (appID == AppIDs.notifications) {
      openNotifications.add(null);
      return;
    }

    final apps = await appImplementations.firstWhere((final a) => a.hasData);
    final app = apps.requireData.tryFind(appID);
    if (app != null) {
      if ((!activeApp.hasValue || !skipAlreadySet) && activeApp.valueOrNull?.id != appID) {
        activeApp.add(app);
      }
    } else {
      throw Exception('App $appID not found');
    }
  }

  /// Returns the active [Bloc] for the given [appImplementation].
  ///
  /// If no bloc exists yet a new one will be instantiated and cached in [AppImplementation.blocsCache].
  T getAppBloc<T extends Bloc>(final AppImplementation<T, dynamic> appImplementation) =>
      appImplementation.getBloc(_account);

  /// Returns the active [Bloc] for every registered [AppImplementation] wrapped in a Provider.
  List<Provider<Bloc>> get appBlocProviders =>
      _allAppImplementations.map((final appImplementation) => appImplementation.blocProvider).toList();
}
