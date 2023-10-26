import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:meta/meta.dart';
import 'package:neon/l10n/localizations.dart';
import 'package:neon/src/bloc/result.dart';
import 'package:neon/src/blocs/accounts.dart';
import 'package:neon/src/models/account.dart';
import 'package:neon/src/models/client_implementation.dart';
import 'package:neon/src/models/notifications_interface.dart';
import 'package:neon/src/models/push_notification.dart';
import 'package:neon/src/platform/platform.dart';
import 'package:neon/src/router.dart';
import 'package:neon/src/theme/neon.dart';
import 'package:neon/src/theme/theme.dart';
import 'package:neon/src/utils/global.dart';
import 'package:neon/src/utils/global_options.dart';
import 'package:neon/src/utils/localizations.dart';
import 'package:neon/src/utils/provider.dart';
import 'package:neon/src/utils/push_utils.dart';
import 'package:neon/src/widgets/options_collection_builder.dart';
import 'package:nextcloud/core.dart' as core;
import 'package:nextcloud/nextcloud.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:tray_manager/tray_manager.dart' as tray;
import 'package:window_manager/window_manager.dart';

@internal
class NeonApp extends StatefulWidget {
  const NeonApp({
    required this.neonTheme,
    super.key,
  });

  final NeonTheme neonTheme;

  @override
  State<NeonApp> createState() => _NeonAppState();
}

// ignore: prefer_mixin
class _NeonAppState extends State<NeonApp> with WidgetsBindingObserver, tray.TrayListener, WindowListener {
  final _appRegex = RegExp(r'^app_([a-z]+)$', multiLine: true);
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final Iterable<ClientImplementation> _clientImplementations;
  late final GlobalOptions _globalOptions;
  late final AccountsBloc _accountsBloc;
  late final _routerDelegate = buildAppRouter(
    navigatorKey: _navigatorKey,
    accountsBloc: _accountsBloc,
  );

  Rect? _lastBounds;

  @override
  void initState() {
    super.initState();

    _clientImplementations = NeonProvider.of<Iterable<ClientImplementation>>(context);
    _globalOptions = NeonProvider.of<GlobalOptions>(context);
    _accountsBloc = NeonProvider.of<AccountsBloc>(context);

    WidgetsBinding.instance.addObserver(this);
    if (NeonPlatform.instance.canUseSystemTray) {
      tray.trayManager.addListener(this);
    }
    if (NeonPlatform.instance.canUseWindowManager) {
      windowManager.addListener(this);
    }

    WidgetsBinding.instance.addPostFrameCallback((final _) async {
      final localizations = await appLocalizationsFromSystem();

      if (!mounted) {
        return;
      }
      if (NeonPlatform.instance.canUseQuickActions) {
        const quickActions = QuickActions();
        await quickActions.setShortcutItems(
          _clientImplementations
              .map(
                (final client) => ShortcutItem(
                  type: 'app_${client.id}',
                  localizedTitle: client.nameFromLocalization(localizations),
                  icon: 'app_${client.id}',
                ),
              )
              .toList(),
        );
        await quickActions.initialize(_handleShortcut);
      }

      if (NeonPlatform.instance.canUseWindowManager) {
        await windowManager.setPreventClose(true);

        if (_globalOptions.startupMinimized.value) {
          await _saveAndMinimizeWindow();
        }
      }

      if (NeonPlatform.instance.canUseSystemTray) {
        _globalOptions.systemTrayEnabled.addListener(() async {
          if (_globalOptions.systemTrayEnabled.value) {
            // TODO: This works on Linux, but maybe not on macOS or Windows
            await tray.trayManager.setIcon('assets/logo.svg');
            if (mounted) {
              await tray.trayManager.setContextMenu(
                tray.Menu(
                  items: [
                    for (final client in _clientImplementations) ...[
                      tray.MenuItem(
                        key: 'app_${client.id}',
                        label: client.nameFromLocalization(localizations),
                        // TODO: Add icons which should work on macOS and Windows
                      ),
                    ],
                    tray.MenuItem.separator(),
                    tray.MenuItem(
                      key: 'show_hide',
                      label: localizations.actionShowSlashHide,
                    ),
                    tray.MenuItem(
                      key: 'exit',
                      label: localizations.actionExit,
                    ),
                  ],
                ),
              );
            }
          } else {
            await tray.trayManager.destroy();
          }
        });
      }

      if (NeonPlatform.instance.canUsePushNotifications) {
        final localNotificationsPlugin = await PushUtils.initLocalNotifications();
        Global.onPushNotificationReceived = (final accountID) async {
          final account = _accountsBloc.accounts.value.tryFind(accountID);
          if (account == null) {
            return;
          }

          final allClientImplementations = NeonProvider.of<Iterable<ClientImplementation>>(context);
          final client = allClientImplementations.tryFind(AppIDs.notifications) as NotificationsClientInterface?;

          if (client == null) {
            return;
          }

          await _accountsBloc.getClientsBlocFor(account).getClientBloc<NotificationsBlocInterface>(client).refresh();
        };
        Global.onPushNotificationClicked = (final pushNotificationWithAccountID) async {
          final account = _accountsBloc.accounts.value.tryFind(pushNotificationWithAccountID.accountID);
          if (account == null) {
            return;
          }
          _accountsBloc.setActiveAccount(account);

          final allClientImplementations = NeonProvider.of<Iterable<ClientImplementation>>(context);

          final notificationsClient =
              allClientImplementations.tryFind(AppIDs.notifications) as NotificationsClientInterface?;
          if (notificationsClient != null) {
            _accountsBloc
                .getClientsBlocFor(account)
                .getClientBloc<NotificationsBlocInterface>(notificationsClient)
                .deleteNotification(pushNotificationWithAccountID.subject.nid!);
          }

          final client =
              allClientImplementations.tryFind(pushNotificationWithAccountID.subject.app) ?? notificationsClient;
          if (client == null) {
            return;
          }

          await _openAppFromExternal(account, client.id);
        };

        final details = await localNotificationsPlugin.getNotificationAppLaunchDetails();
        if (details != null && details.didNotificationLaunchApp && details.notificationResponse?.payload != null) {
          await Global.onPushNotificationClicked!(
            PushNotification.fromJson(
              json.decode(details.notificationResponse!.payload!) as Map<String, dynamic>,
            ),
          );
        }
      }
    });
  }

  @override
  void onTrayMenuItemClick(final tray.MenuItem menuItem) {
    if (menuItem.key != null) {
      unawaited(_handleShortcut(menuItem.key!));
    }
  }

  @override
  Future<void> onWindowClose() async {
    if (_globalOptions.startupMinimizeInsteadOfExit.value) {
      await _saveAndMinimizeWindow();
    } else {
      await windowManager.destroy();
    }
  }

  @override
  Future<void> onWindowMinimize() async {
    await _saveAndMinimizeWindow();
  }

  Future<void> _handleShortcut(final String shortcutType) async {
    if (shortcutType == 'show_hide') {
      if (NeonPlatform.instance.canUseWindowManager) {
        if (await windowManager.isVisible()) {
          await _saveAndMinimizeWindow();
        } else {
          await _showAndRestoreWindow();
        }
      }
      return;
    }
    if (shortcutType == 'exit') {
      exit(0);
    }

    final matches = _appRegex.allMatches(shortcutType);
    final activeAccount = await _accountsBloc.activeAccount.first;
    if (matches.isNotEmpty && activeAccount != null) {
      await _openAppFromExternal(activeAccount, matches.first.group(1)!);
    }
  }

  Future<void> _openAppFromExternal(final Account account, final String id) async {
    await _accountsBloc.getClientsBlocFor(account).setActiveClient(id);
    _navigatorKey.currentState!.popUntil((final route) => route.settings.name == 'home');
    await _showAndRestoreWindow();
  }

  Future<void> _saveAndMinimizeWindow() async {
    _lastBounds = await windowManager.getBounds();
    if (_globalOptions.systemTrayEnabled.value && _globalOptions.systemTrayHideToTrayWhenMinimized.value) {
      await windowManager.hide();
    } else {
      await windowManager.minimize();
    }
  }

  Future<void> _showAndRestoreWindow() async {
    if (!NeonPlatform.instance.canUseWindowManager) {
      return;
    }

    final wasVisible = await windowManager.isVisible();
    await windowManager.show();
    await windowManager.focus();
    if (_lastBounds != null && !wasVisible) {
      await windowManager.setBounds(_lastBounds);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (NeonPlatform.instance.canUseSystemTray) {
      tray.trayManager.removeListener(this);
    }
    if (NeonPlatform.instance.canUseWindowManager) {
      windowManager.removeListener(this);
    }

    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => OptionsCollectionBuilder(
        valueListenable: _globalOptions,
        builder: (final context, final options, final _) => StreamBuilder<Account?>(
          stream: _accountsBloc.activeAccount,
          builder: (final context, final activeAccountSnapshot) {
            FlutterNativeSplash.remove();
            return ResultBuilder<core.OcsGetCapabilitiesResponseApplicationJson_Ocs_Data?>.behaviorSubject(
              subject: activeAccountSnapshot.hasData
                  ? _accountsBloc.getCapabilitiesBlocFor(activeAccountSnapshot.data!).capabilities
                  : null,
              builder: (final context, final capabilitiesSnapshot) {
                final appTheme = AppTheme(
                  capabilitiesSnapshot.data?.capabilities.themingPublicCapabilities?.theming,
                  keepOriginalAccentColor: options.themeKeepOriginalAccentColor.value,
                  oledAsDark: options.themeOLEDAsDark.value,
                  clientThemes: _clientImplementations.map((final c) => c.theme).whereNotNull(),
                  neonTheme: widget.neonTheme,
                );

                return MaterialApp.router(
                  localizationsDelegates: [
                    ..._clientImplementations.map((final client) => client.localizationsDelegate),
                    ...NeonLocalizations.localizationsDelegates,
                  ],
                  supportedLocales: {
                    ..._clientImplementations
                        .map((final client) => client.supportedLocales)
                        .expand((final element) => element),
                    ...NeonLocalizations.supportedLocales,
                  },
                  themeMode: options.themeMode.value,
                  theme: appTheme.lightTheme,
                  darkTheme: appTheme.darkTheme,
                  routerConfig: _routerDelegate,
                );
              },
            );
          },
        ),
      );
}
