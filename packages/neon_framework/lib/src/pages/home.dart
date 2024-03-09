import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/l10n/localizations.dart';
import 'package:neon_framework/src/bloc/result.dart';
import 'package:neon_framework/src/blocs/accounts.dart';
import 'package:neon_framework/src/blocs/apps.dart';
import 'package:neon_framework/src/models/account.dart';
import 'package:neon_framework/src/utils/dialog.dart';
import 'package:neon_framework/src/utils/global_options.dart' as global_options;
import 'package:neon_framework/src/utils/global_popups.dart';
import 'package:neon_framework/src/utils/provider.dart';
import 'package:neon_framework/src/widgets/app_bar.dart';
import 'package:neon_framework/src/widgets/drawer.dart';
import 'package:neon_framework/src/widgets/error.dart';
import 'package:nextcloud/core.dart' as core;
import 'package:nextcloud/nextcloud.dart';
import 'package:provider/provider.dart';

final _log = Logger('HomePage');

/// The home page of Neon.
@internal
class HomePage extends StatefulWidget {
  /// Creates a new home page.
  const HomePage({
    required this.account,
    super.key,
  });

  final Account account;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late global_options.GlobalOptions _globalOptions;
  late AccountsBloc _accountsBloc;
  late AppsBloc _appsBloc;
  late StreamSubscription<BuiltMap<String, VersionCheck>>
      _versionCheckSubscription;

  @override
  void initState() {
    super.initState();
    _globalOptions = NeonProvider.of<global_options.GlobalOptions>(context);
    _accountsBloc = NeonProvider.of<AccountsBloc>(context);
    _appsBloc = _accountsBloc.getAppsBlocFor(widget.account);

    _versionCheckSubscription = _appsBloc.appVersionChecks.listen((values) {
      if (!mounted) {
        return;
      }

      final l10n = NeonLocalizations.of(context);
      final buffer = StringBuffer()..writeln();

      for (final entry in values.entries) {
        final versionCheck = entry.value;
        final appName = l10n.appImplementationName(entry.key);

        buffer.writeln(
          // ignore: lines_longer_than_80_chars
          '- $appName >=${versionCheck.minimumVersion} <${versionCheck.maximumMajor + 1}.0.0',
        );
      }

      final message = l10n.errorUnsupportedAppVersions(buffer.toString());
      unawaited(showErrorDialog(context: context, message: message));
    });

    GlobalPopups().register(context);

    unawaited(_checkMaintenanceMode());
  }

  @override
  void dispose() {
    unawaited(_versionCheckSubscription.cancel());
    GlobalPopups().dispose();
    super.dispose();
  }

  Future<void> _checkMaintenanceMode() async {
    try {
      final status = await widget.account.client.core.getStatus();

      if (status.body.maintenance && mounted) {
        final message =
            NeonLocalizations.of(context).errorServerInMaintenanceMode;
        await showErrorDialog(context: context, message: message);
      }
    } on http.ClientException catch (error, stackTrace) {
      _log.warning(
        'Error getting the server status.',
        error,
        stackTrace,
      );

      if (mounted) {
        NeonError.showSnackbar(context, error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const drawer = NeonDrawer();
    const appBar = NeonAppBar();

    final appView = ResultBuilder.behaviorSubject(
      subject: _appsBloc.appImplementations,
      builder: (context, appImplementations) {
        if (!appImplementations.hasData) {
          return const SizedBox();
        }

        if (appImplementations.requireData.isEmpty) {
          return Center(
            child: Text(
              NeonLocalizations.of(context).errorNoCompatibleNextcloudAppsFound,
              textAlign: TextAlign.center,
            ),
          );
        }

        return StreamBuilder(
          stream: _appsBloc.activeApp,
          builder: (context, activeAppSnapshot) {
            if (!activeAppSnapshot.hasData) {
              return const SizedBox();
            }

            return SafeArea(
              child: activeAppSnapshot.requireData.page,
            );
          },
        );
      },
    );

    final body = ValueListenableBuilder(
      valueListenable: _globalOptions.navigationMode,
      builder: (context, navigationMode, _) {
        final drawerAlwaysVisible =
            navigationMode == global_options.NavigationMode.drawerAlwaysVisible;

        final body = Scaffold(
          resizeToAvoidBottomInset: false,
          drawer: !drawerAlwaysVisible ? drawer : null,
          appBar: appBar,
          body: appView,
        );

        if (drawerAlwaysVisible) {
          return Row(
            children: [
              ColoredBox(
                color: Theme.of(context).colorScheme.background,
                child: drawer,
              ),
              Expanded(
                child: body,
              ),
            ],
          );
        }

        return body;
      },
    );

    return MultiProvider(
      providers: _appsBloc.appBlocProviders,
      child: body,
    );
  }
}
