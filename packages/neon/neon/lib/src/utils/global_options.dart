import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:neon/l10n/localizations.dart';
import 'package:neon/src/models/account.dart';
import 'package:neon/src/models/label_builder.dart';
import 'package:neon/src/settings/models/option.dart';
import 'package:neon/src/settings/models/options_collection.dart';
import 'package:neon/src/settings/models/storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

/// The id of the NextPush unified push distributor.
const unifiedPushNextPushID = 'org.unifiedpush.distributor.nextpush';

/// Global options for the Neon framework.
@internal
@immutable
class GlobalOptions extends OptionsCollection {
  /// Creates a new global options collection.
  GlobalOptions(
    this._packageInfo,
  ) : super(const AppStorage(StorageKeys.global)) {
    pushNotificationsEnabled.addListener(_pushNotificationsEnabledListener);
    rememberLastUsedAccount.addListener(_rememberLastUsedAccountListener);
  }

  void _rememberLastUsedAccountListener() {
    initialAccount.enabled = !rememberLastUsedAccount.value;
    if (rememberLastUsedAccount.value) {
      initialAccount.reset();
    } else {
      // Only override the initial account if there already has been a value,
      // which means it's not the initial emit from rememberLastUsedAccount
      initialAccount.value = initialAccount.values.keys.first;
    }
  }

  Future<void> _pushNotificationsEnabledListener() async {
    if (pushNotificationsEnabled.value) {
      final response = await Permission.notification.request();
      if (response.isPermanentlyDenied) {
        pushNotificationsEnabled.enabled = false;
      }
      if (!response.isGranted) {
        pushNotificationsEnabled.value = false;
      }
    } else {
      pushNotificationsDistributor.reset();
    }
  }

  final PackageInfo _packageInfo;

  late final _distributorsMap = <String, LabelBuilder>{
    _packageInfo.packageName: (final context) =>
        NeonLocalizations.of(context).globalOptionsPushNotificationsDistributorFirebaseEmbedded,
    'com.github.gotify.up': (final context) =>
        NeonLocalizations.of(context).globalOptionsPushNotificationsDistributorGotifyUP,
    'eu.siacs.conversations': (final context) =>
        NeonLocalizations.of(context).globalOptionsPushNotificationsDistributorConversations,
    'io.heckel.ntfy': (final context) => NeonLocalizations.of(context).globalOptionsPushNotificationsDistributorNtfy,
    'org.unifiedpush.distributor.fcm': (final context) =>
        NeonLocalizations.of(context).globalOptionsPushNotificationsDistributorFCMUP,
    unifiedPushNextPushID: (final context) =>
        NeonLocalizations.of(context).globalOptionsPushNotificationsDistributorNextPush,
    'org.unifiedpush.distributor.noprovider2push': (final context) =>
        NeonLocalizations.of(context).globalOptionsPushNotificationsDistributorNoProvider2Push,
  };

  @override
  late final List<Option<dynamic>> options = [
    themeMode,
    themeOLEDAsDark,
    themeKeepOriginalAccentColor,
    pushNotificationsEnabled,
    pushNotificationsDistributor,
    startupMinimized,
    startupMinimizeInsteadOfExit,
    systemTrayEnabled,
    systemTrayHideToTrayWhenMinimized,
    rememberLastUsedAccount,
    initialAccount,
    navigationMode,
  ];

  @override
  void dispose() {
    super.dispose();

    pushNotificationsEnabled.removeListener(_pushNotificationsEnabledListener);
    rememberLastUsedAccount.removeListener(_rememberLastUsedAccountListener);
  }

  /// Updates the available values of [initialAccount].
  ///
  /// If the current `initialAccount` is not supported anymore the option will be reset.
  void updateAccounts(final List<Account> accounts) {
    initialAccount.values = Map.fromEntries(
      accounts.map(
        (final account) => MapEntry(account.id, (final context) => account.humanReadableID),
      ),
    );

    if (!initialAccount.values.containsKey(initialAccount.value)) {
      initialAccount.reset();
    }
  }

  /// Updates the values of [pushNotificationsDistributor].
  ///
  /// If the new `distributors` does not contain the currently active one
  /// both [pushNotificationsDistributor] and [pushNotificationsEnabled] will be reset.
  void updateDistributors(final List<String> distributors) {
    pushNotificationsDistributor.values = Map.fromEntries(
      distributors.map(
        (final distributor) => MapEntry(distributor, _distributorsMap[distributor] ?? (final _) => distributor),
      ),
    );

    final allowed = pushNotificationsDistributor.values.containsKey(pushNotificationsDistributor.value);
    pushNotificationsEnabled.enabled = allowed;
    if (!allowed) {
      pushNotificationsDistributor.reset();
      pushNotificationsEnabled.reset();
    }
  }

  /// The theme mode of the app implementing the Neon framework.
  late final themeMode = SelectOption(
    storage: storage,
    key: GlobalOptionKeys.themeMode,
    label: (final context) => NeonLocalizations.of(context).globalOptionsThemeMode,
    defaultValue: ThemeMode.system,
    values: {
      ThemeMode.light: (final context) => NeonLocalizations.of(context).globalOptionsThemeModeLight,
      ThemeMode.dark: (final context) => NeonLocalizations.of(context).globalOptionsThemeModeDark,
      ThemeMode.system: (final context) => NeonLocalizations.of(context).globalOptionsThemeModeAutomatic,
    },
  );

  /// Whether the [ThemeMode.dark] should use a plain black background.
  ///
  /// This is commonly used on oled devices.
  /// Defaults to `false`.
  late final themeOLEDAsDark = ToggleOption(
    storage: storage,
    key: GlobalOptionKeys.themeOLEDAsDark,
    label: (final context) => NeonLocalizations.of(context).globalOptionsThemeOLEDAsDark,
    defaultValue: false,
  );

  /// Whether the `ColorScheme` should keep the Nextcloud you provided color.
  ///
  /// Defaults to `false` generating a material3 style color.
  late final themeKeepOriginalAccentColor = ToggleOption(
    storage: storage,
    key: GlobalOptionKeys.themeKeepOriginalAccentColor,
    label: (final context) => NeonLocalizations.of(context).globalOptionsThemeKeepOriginalAccentColor,
    defaultValue: false,
  );

  /// Whether to enable the push notifications plugin.
  ///
  /// Setting this option to true will request notification access.
  /// Disabling this option will reset [pushNotificationsDistributor].
  ///
  /// Defaults to `false`.
  late final pushNotificationsEnabled = ToggleOption(
    storage: storage,
    key: GlobalOptionKeys.pushNotificationsEnabled,
    label: (final context) => NeonLocalizations.of(context).globalOptionsPushNotificationsEnabled,
    defaultValue: false,
  );

  /// The registered distributor for push notifications.
  late final pushNotificationsDistributor = SelectOption<String?>.depend(
    storage: storage,
    key: GlobalOptionKeys.pushNotificationsDistributor,
    label: (final context) => NeonLocalizations.of(context).globalOptionsPushNotificationsDistributor,
    defaultValue: null,
    values: {},
    enabled: pushNotificationsEnabled,
  );

  /// Whether to start the app implementing Neon minimized.
  ///
  /// Defaults to `false`.
  ///
  /// See:
  ///   * [minimizeInsteadOfExit]: for an option to minimize instead of closing the app.
  ///   *[systemTrayHideToTrayWhenMinimized]: to minimize the app to system tray.
  late final startupMinimized = ToggleOption(
    storage: storage,
    key: GlobalOptionKeys.startupMinimized,
    label: (final context) => NeonLocalizations.of(context).globalOptionsStartupMinimized,
    defaultValue: false,
  );

  /// Whether to minimize app implementing Neon instead of closing.
  ///
  /// Defaults to `false`.
  ///
  /// See:
  ///   * [startupMinimized]: for an option to startup in the minimized state.
  ///   *[systemTrayHideToTrayWhenMinimized]: to minimize the app to system tray.
  late final startupMinimizeInsteadOfExit = ToggleOption(
    storage: storage,
    key: GlobalOptionKeys.startupMinimizeInsteadOfExit,
    label: (final context) => NeonLocalizations.of(context).globalOptionsStartupMinimizeInsteadOfExit,
    defaultValue: false,
  );

  // TODO: Autostart option

  /// Whether to enable the system tray.
  ///
  /// Defaults to `false`.
  ///
  /// See:
  ///   *[systemTrayHideToTrayWhenMinimized]: to minimize the app to system tray.
  late final systemTrayEnabled = ToggleOption(
    storage: storage,
    key: GlobalOptionKeys.systemTrayEnabled,
    label: (final context) => NeonLocalizations.of(context).globalOptionsSystemTrayEnabled,
    defaultValue: false,
  );

  /// Whether to minimize to the system tray or not.
  ///
  /// Requires [systemTrayEnabled] to be true.
  /// Defaults to `true`.
  ///
  /// See:
  ///   * [systemTrayEnabled]: to enable the system tray.
  ///   * [startupMinimized]: for an option to startup in the minimized state.
  ///   * [minimizeInsteadOfExit]: for an option to minimize instead of closing the app.
  late final systemTrayHideToTrayWhenMinimized = ToggleOption.depend(
    storage: storage,
    key: GlobalOptionKeys.systemTrayHideToTrayWhenMinimized,
    label: (final context) => NeonLocalizations.of(context).globalOptionsSystemTrayHideToTrayWhenMinimized,
    defaultValue: true,
    enabled: systemTrayEnabled,
  );

  /// Whether to remember the last active account.
  ///
  /// Enabling this option will reset the [initialAccount].
  /// Defaults to `true`.
  late final rememberLastUsedAccount = ToggleOption(
    storage: storage,
    key: GlobalOptionKeys.rememberLastUsedAccount,
    label: (final context) => NeonLocalizations.of(context).globalOptionsAccountsRememberLastUsedAccount,
    defaultValue: true,
  );

  /// The initial account to use when opening the app.
  late final initialAccount = SelectOption<String?>(
    storage: storage,
    key: GlobalOptionKeys.initialAccount,
    label: (final context) => NeonLocalizations.of(context).globalOptionsAccountsInitialAccount,
    defaultValue: null,
    values: {},
  );

  late final navigationMode = SelectOption(
    storage: storage,
    key: GlobalOptionKeys.navigationMode,
    label: (final context) => NeonLocalizations.of(context).globalOptionsNavigationMode,
    defaultValue: Platform.isAndroid || Platform.isIOS ? NavigationMode.drawer : NavigationMode.drawerAlwaysVisible,
    values: {
      NavigationMode.drawer: (final context) => NeonLocalizations.of(context).globalOptionsNavigationModeDrawer,
      if (!Platform.isAndroid && !Platform.isIOS)
        NavigationMode.drawerAlwaysVisible: (final context) =>
            NeonLocalizations.of(context).globalOptionsNavigationModeDrawerAlwaysVisible,
    },
  );
}

/// The storage keys for the [GlobalOptions].
@internal
enum GlobalOptionKeys implements Storable {
  /// The storage key for [GlobalOptions.themeMode]
  themeMode._('theme-mode'),

  /// The storage key for [GlobalOptions.themeOLEDAsDark]
  themeOLEDAsDark._('theme-oled-as-dark'),

  /// The storage key for [GlobalOptions.themeKeepOriginalAccentColor]
  themeKeepOriginalAccentColor._('theme-keep-original-accent-color'),

  /// The storage key for [GlobalOptions.pushNotificationsEnabled]
  pushNotificationsEnabled._('push-notifications-enabled'),

  /// The storage key for [GlobalOptions.pushNotificationsDistributor]
  pushNotificationsDistributor._('push-notifications-distributor'),

  /// The storage key for [GlobalOptions.startupMinimized]
  startupMinimized._('startup-minimized'),

  /// The storage key for [GlobalOptions.startupMinimizeInsteadOfExit]
  startupMinimizeInsteadOfExit._('startup-minimize-instead-of-exit'),

  /// The storage key for [GlobalOptions.systemTrayEnabled]
  systemTrayEnabled._('system-tray-enabled'),

  /// The storage key for [GlobalOptions.systemTrayHideToTrayWhenMinimized]
  systemTrayHideToTrayWhenMinimized._('system-tray-hide-to-tray-when-minimized'),

  /// The storage key for [GlobalOptions.rememberLastUsedAccount]
  rememberLastUsedAccount._('remember-last-used-account'),

  /// The storage key for [GlobalOptions.initialAccount]
  initialAccount._('initial-account'),

  /// The storage key for [GlobalOptions.navigationMode]
  navigationMode._('navigation-mode');

  const GlobalOptionKeys._(this.value);

  @override
  final String value;
}

/// App navigation modes.
@internal
enum NavigationMode {
  /// Drawer behind a hamburger menu.
  ///
  /// The default for small screen sizes.
  drawer,

  /// Persistent drawer on the leading edge.
  ///
  /// The default on large screen sizes.
  drawerAlwaysVisible,
}
