import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:neon/l10n/localizations.dart';
import 'package:neon/src/bloc/result_builder.dart';
import 'package:neon/src/blocs/accounts.dart';
import 'package:neon/src/blocs/apps.dart';
import 'package:neon/src/models/app_implementation.dart';
import 'package:neon/src/router.dart';
import 'package:neon/src/utils/provider.dart';
import 'package:neon/src/widgets/drawer_destination.dart';
import 'package:neon/src/widgets/error.dart';
import 'package:neon/src/widgets/image.dart';
import 'package:neon/src/widgets/linear_progress_indicator.dart';
import 'package:nextcloud/core.dart' as core;

/// A custom pre populated [Drawer] side panel.
///
/// Displays an entry for every registered and supported client and one for
/// the settings page.
@internal
class NeonDrawer extends StatelessWidget {
  /// Created a new Neon drawer.
  const NeonDrawer({
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    final accountsBloc = NeonProvider.of<AccountsBloc>(context);
    final appsBloc = accountsBloc.activeAppsBloc;

    return ResultBuilder.behaviorSubject(
      stream: appsBloc.appImplementations,
      builder: (final context, final snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        return _NeonDrawer(
          apps: snapshot.requireData,
        );
      },
    );
  }
}

class _NeonDrawer extends StatefulWidget {
  const _NeonDrawer({
    required this.apps,
  });

  final Iterable<AppImplementation> apps;

  @override
  State<_NeonDrawer> createState() => __NeonDrawerState();
}

class __NeonDrawerState extends State<_NeonDrawer> {
  late AccountsBloc _accountsBloc;
  late AppsBloc _appsBloc;
  late List<AppImplementation> _apps;

  late int _activeApp;

  @override
  void initState() {
    super.initState();

    _accountsBloc = NeonProvider.of<AccountsBloc>(context);
    _appsBloc = _accountsBloc.activeAppsBloc;

    _apps = widget.apps.toList();
    _activeApp = _apps.indexWhere((final app) => app.id == _appsBloc.activeApp.valueOrNull?.id);
  }

  void onAppChange(final int index) {
    Scaffold.maybeOf(context)?.closeDrawer();

    // selected item is not a registered app like the SettingsPage
    if (index >= _apps.length) {
      const SettingsRoute().go(context);
      return;
    }

    setState(() {
      _activeApp = index;
    });

    unawaited(_appsBloc.setActiveApp(_apps[index].id));
    //context.goNamed(apps[index].routeName);
  }

  @override
  Widget build(final BuildContext context) {
    final appDestinations = _apps.map(
      (final app) => NavigationDrawerDestinationExtension.fromNeonDestination(
        app.destination(context),
      ),
    );

    final drawer = NavigationDrawer(
      selectedIndex: _activeApp,
      onDestinationSelected: onAppChange,
      children: [
        const NeonDrawerHeader(),
        ...appDestinations,
        NavigationDrawerDestination(
          icon: const Icon(Icons.settings),
          label: Text(NeonLocalizations.of(context).settings),
        ),
      ],
    );

    return drawer;
  }
}

/// Custom styled [DrawerHeader] used inside a [Drawer] or [NeonDrawer].
///
/// The neon drawer will display the [core.ThemingPublicCapabilities_Theming.name]
/// and [core.ThemingPublicCapabilities_Theming.logo] and automatically rebuild
/// when the current theme changes.
@internal
class NeonDrawerHeader extends StatelessWidget {
  /// Creates a new Neon drawer header.
  const NeonDrawerHeader({super.key});

  @override
  Widget build(final BuildContext context) {
    final accountsBloc = NeonProvider.of<AccountsBloc>(context);
    final capabilitiesBloc = accountsBloc.activeCapabilitiesBloc;

    final branding = ResultBuilder<core.OcsGetCapabilitiesResponseApplicationJson_Ocs_Data>.behaviorSubject(
      stream: capabilitiesBloc.capabilities,
      builder: (final context, final capabilities) {
        if (!capabilities.hasData) {
          return NeonLinearProgressIndicator(
            visible: capabilities.isLoading,
          );
        }

        if (capabilities.hasError) {
          return NeonError(
            capabilities.error,
            onRetry: capabilitiesBloc.refresh,
          );
        }

        final theme = capabilities.requireData.capabilities.themingPublicCapabilities?.theming;

        if (theme == null) {
          return const SizedBox();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              theme.name,
              style: DefaultTextStyle.of(context).style.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
            Flexible(
              child: NeonUrlImage(
                url: theme.logo,
              ),
            ),
          ],
        );
      },
    );

    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
      child: branding,
    );
  }
}
