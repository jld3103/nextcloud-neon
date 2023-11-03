import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:meta/meta.dart';
import 'package:neon/l10n/localizations.dart';
import 'package:neon/src/blocs/accounts.dart';
import 'package:neon/src/models/app_implementation.dart';
import 'package:neon/src/platform/platform.dart';
import 'package:neon/src/router.dart';
import 'package:neon/src/settings/utils/settings_export_helper.dart';
import 'package:neon/src/settings/widgets/account_settings_tile.dart';
import 'package:neon/src/settings/widgets/custom_settings_tile.dart';
import 'package:neon/src/settings/widgets/option_settings_tile.dart';
import 'package:neon/src/settings/widgets/settings_category.dart';
import 'package:neon/src/settings/widgets/settings_list.dart';
import 'package:neon/src/settings/widgets/text_settings_tile.dart';
import 'package:neon/src/theme/branding.dart';
import 'package:neon/src/theme/dialog.dart';
import 'package:neon/src/utils/adaptive.dart';
import 'package:neon/src/utils/confirmation_dialog.dart';
import 'package:neon/src/utils/global_options.dart';
import 'package:neon/src/utils/provider.dart';
import 'package:neon/src/utils/save_file.dart';
import 'package:neon/src/widgets/error.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// Categories of the [SettingsPage].
///
/// Used with [SettingsPage.initialCategory] to scroll to a specific section.
/// Values are in order of appearance but are not guaranteed to be included on
/// the settings page.
@internal
enum SettingsCategories {
  /// `NextcloudAppOptions` category.
  ///
  /// Each activated `AppImplementation` has an entry if it has any options specified.
  apps,

  /// Theming category.
  theme,

  /// Device navigation category.
  navigation,

  /// Push notifications category.
  pushNotifications,

  /// Startup category.
  startup,

  /// System tray category.
  systemTray,

  /// Account management category.
  ///
  /// Also includes the `AccountSpecificOptions`.
  accounts,

  /// Other category.
  ///
  /// Contains legal information and various links.
  other,
}

/// Settings page.
///
/// Settings are specified as `Option`s.
@internal
class SettingsPage extends StatefulWidget {
  /// Creates a new settings page.
  const SettingsPage({
    this.initialCategory,
    super.key,
  });

  /// The optional initial category to show.
  final SettingsCategories? initialCategory;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(final BuildContext context) {
    final globalOptions = NeonProvider.of<GlobalOptions>(context);
    final accountsBloc = NeonProvider.of<AccountsBloc>(context);
    final appImplementations = NeonProvider.of<Iterable<AppImplementation>>(context);

    final appBar = AppBar(
      title: Text(NeonLocalizations.of(context).settings),
      actions: [
        IconButton(
          onPressed: () async {
            if (await showConfirmationDialog(context, NeonLocalizations.of(context).settingsResetAllConfirmation)) {
              globalOptions.reset();

              for (final appImplementation in appImplementations) {
                appImplementation.options.reset();
              }

              for (final account in accountsBloc.accounts.value) {
                accountsBloc.getOptionsFor(account).reset();
              }
            }
          },
          tooltip: NeonLocalizations.of(context).settingsResetAll,
          icon: const Icon(MdiIcons.cogRefresh),
        ),
      ],
    );
    final body = SettingsList(
      initialCategory: widget.initialCategory?.name,
      categories: [
        buildAppCategory(),
        SettingsCategory(
          title: Text(NeonLocalizations.of(context).optionsCategoryTheme),
          key: ValueKey(SettingsCategories.theme.name),
          tiles: [
            SelectSettingsTile(
              option: globalOptions.themeMode,
            ),
            ToggleSettingsTile(
              option: globalOptions.themeOLEDAsDark,
            ),
            ToggleSettingsTile(
              option: globalOptions.themeUseNextcloudTheme,
            ),
          ],
        ),
        SettingsCategory(
          title: Text(NeonLocalizations.of(context).optionsCategoryNavigation),
          key: ValueKey(SettingsCategories.navigation.name),
          tiles: [
            SelectSettingsTile(
              option: globalOptions.navigationMode,
            ),
          ],
        ),
        if (NeonPlatform.instance.canUsePushNotifications) buildNotificationsCategory(),
        if (NeonPlatform.instance.canUseWindowManager)
          SettingsCategory(
            title: Text(NeonLocalizations.of(context).optionsCategoryStartup),
            key: ValueKey(SettingsCategories.startup.name),
            tiles: [
              ToggleSettingsTile(
                option: globalOptions.startupMinimized,
              ),
              ToggleSettingsTile(
                option: globalOptions.startupMinimizeInsteadOfExit,
              ),
            ],
          ),
        if (NeonPlatform.instance.canUseWindowManager && NeonPlatform.instance.canUseSystemTray)
          SettingsCategory(
            title: Text(NeonLocalizations.of(context).optionsCategorySystemTray),
            key: ValueKey(SettingsCategories.systemTray.name),
            tiles: [
              ToggleSettingsTile(
                option: globalOptions.systemTrayEnabled,
              ),
              ToggleSettingsTile(
                option: globalOptions.systemTrayHideToTrayWhenMinimized,
              ),
            ],
          ),
        ...buildAccountCategory(),
        buildOtherCategory(),
      ],
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: NeonDialogTheme.of(context).constraints,
            child: body,
          ),
        ),
      ),
    );
  }

  Widget buildAppCategory() {
    final appImplementations = NeonProvider.of<Iterable<AppImplementation>>(context);
    final appsWithOptions = appImplementations.where(
      (final app) => app.options.options.isNotEmpty,
    );

    final tiles = appsWithOptions.map(
      (final appImplementation) => CustomSettingsTile(
        leading: appImplementation.buildIcon(),
        title: Text(appImplementation.name(context)),
        onTap: () {
          NextcloudAppSettingsRoute(appid: appImplementation.id).go(context);
        },
      ),
    );

    return SettingsCategory(
      hasLeading: true,
      title: Text(NeonLocalizations.of(context).settingsApps),
      key: ValueKey(SettingsCategories.apps.name),
      tiles: tiles.toList(),
    );
  }

  Widget buildNotificationsCategory() {
    final globalOptions = NeonProvider.of<GlobalOptions>(context);

    return ValueListenableBuilder(
      valueListenable: globalOptions.pushNotificationsEnabled,
      builder: (final context, final _, final __) => SettingsCategory(
        title: Text(NeonLocalizations.of(context).optionsCategoryPushNotifications),
        key: ValueKey(SettingsCategories.pushNotifications.name),
        tiles: [
          if (!globalOptions.pushNotificationsEnabled.enabled)
            TextSettingsTile(
              text: NeonLocalizations.of(context).globalOptionsPushNotificationsEnabledDisabledNotice,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ToggleSettingsTile(
            option: globalOptions.pushNotificationsEnabled,
          ),
          SelectSettingsTile(
            option: globalOptions.pushNotificationsDistributor,
          ),
        ],
      ),
    );
  }

  Iterable<Widget> buildAccountCategory() sync* {
    final globalOptions = NeonProvider.of<GlobalOptions>(context);
    final accountsBloc = NeonProvider.of<AccountsBloc>(context);
    final accounts = accountsBloc.accounts.value;
    final hasMultipleAccounts = accounts.length > 1;

    final title = Text(NeonLocalizations.of(context).optionsCategoryAccounts);
    final key = ValueKey(SettingsCategories.accounts.name);
    final accountTiles = accounts.map(
      (final account) => AccountSettingsTile(
        account: account,
        onTap: () => AccountSettingsRoute(accountID: account.id).go(context),
      ),
    );
    final rememberLastUsedAccountTile = ToggleSettingsTile(
      option: globalOptions.rememberLastUsedAccount,
    );
    final initialAccountTile = SelectSettingsTile(
      option: globalOptions.initialAccount,
    );

    if (isCupertino(context)) {
      if (hasMultipleAccounts) {
        yield SettingsCategory(
          title: title,
          key: key,
          tiles: [
            rememberLastUsedAccountTile,
            initialAccountTile,
          ],
        );
      }
      final addAccountTile = CustomSettingsTile(
        leading: const Icon(
          CupertinoIcons.add,
        ),
        title: Text(NeonLocalizations.of(context).globalOptionsAccountsAdd),
        onTap: () async => const LoginRoute().push(context),
      );

      yield CupertinoListSection.insetGrouped(
        header: !hasMultipleAccounts ? title : null,
        key: !hasMultipleAccounts ? key : null,
        children: [
          ...accountTiles,
          addAccountTile,
        ],
      );
    } else {
      final addAccountTile = CustomSettingsTile(
        title: ElevatedButton.icon(
          onPressed: () async => const LoginRoute().push(context),
          icon: const Icon(MdiIcons.accountPlus),
          label: Text(NeonLocalizations.of(context).globalOptionsAccountsAdd),
        ),
      );

      yield SettingsCategory(
        title: title,
        key: key,
        tiles: [
          if (hasMultipleAccounts) rememberLastUsedAccountTile,
          if (hasMultipleAccounts) initialAccountTile,
          ...accountTiles,
          addAccountTile,
        ],
      );
    }
  }

  Widget buildOtherCategory() {
    final branding = Branding.of(context);

    return SettingsCategory(
      hasLeading: true,
      title: Text(NeonLocalizations.of(context).optionsCategoryOther),
      key: ValueKey(SettingsCategories.other.name),
      tiles: [
        if (branding.sourceCodeURL != null)
          CustomSettingsTile(
            leading: Icon(
              Icons.code,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(NeonLocalizations.of(context).sourceCode),
            onTap: () async {
              await launchUrlString(
                branding.sourceCodeURL!,
                mode: LaunchMode.externalApplication,
              );
            },
          ),
        if (branding.issueTrackerURL != null)
          CustomSettingsTile(
            leading: Icon(
              MdiIcons.textBoxEditOutline,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(NeonLocalizations.of(context).issueTracker),
            onTap: () async {
              await launchUrlString(
                branding.issueTrackerURL!,
                mode: LaunchMode.externalApplication,
              );
            },
          ),
        CustomSettingsTile(
          leading: Icon(
            MdiIcons.scriptText,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: Text(NeonLocalizations.of(context).licenses),
          onTap: () async {
            showLicensePage(
              context: context,
              applicationName: branding.name,
              applicationIcon: branding.logo,
              applicationLegalese: branding.legalese,
              applicationVersion: NeonProvider.of<PackageInfo>(context).version,
            );
          },
        ),
        CustomSettingsTile(
          leading: Icon(
            MdiIcons.export,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: Text(NeonLocalizations.of(context).settingsExport),
          onTap: () async {
            final settingsExportHelper = _buildSettingsExportHelper(context);

            try {
              final fileName = 'nextcloud-neon-settings-${DateTime.now().millisecondsSinceEpoch ~/ 1000}.json';

              final data = settingsExportHelper.exportToFile();
              await saveFileWithPickDialog(fileName, data);
            } catch (e, s) {
              debugPrint(e.toString());
              debugPrint(s.toString());
              if (mounted) {
                NeonError.showSnackbar(context, e);
              }
            }
          },
        ),
        CustomSettingsTile(
          leading: Icon(
            MdiIcons.import,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: Text(NeonLocalizations.of(context).settingsImport),
          onTap: () async {
            final settingsExportHelper = _buildSettingsExportHelper(context);

            try {
              final result = await FilePicker.platform.pickFiles(
                withReadStream: true,
              );

              if (result == null) {
                return;
              }

              if (!result.files.single.path!.endsWith('.json')) {
                if (mounted) {
                  NeonError.showSnackbar(
                    context,
                    NeonLocalizations.of(context).settingsImportWrongFileExtension,
                  );
                }
                return;
              }

              await settingsExportHelper.applyFromFile(result.files.single.readStream);
            } catch (e, s) {
              debugPrint(e.toString());
              debugPrint(s.toString());
              if (mounted) {
                NeonError.showSnackbar(context, e);
              }
            }
          },
        ),
      ],
    );
  }

  SettingsExportHelper _buildSettingsExportHelper(final BuildContext context) {
    final globalOptions = NeonProvider.of<GlobalOptions>(context);
    final accountsBloc = NeonProvider.of<AccountsBloc>(context);
    final appImplementations = NeonProvider.of<Iterable<AppImplementation>>(context);

    return SettingsExportHelper(
      exportables: {
        globalOptions,
        AccountsBlocExporter(accountsBloc),
        AppImplementationsExporter(appImplementations),
      },
    );
  }
}
