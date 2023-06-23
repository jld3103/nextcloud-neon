part of '../../neon.dart';

const kQuickBarWidth = kAvatarSize + 20;

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late Account _account;
  late GlobalOptions _globalOptions;
  late AccountsBloc _accountsBloc;
  late AppsBloc _appsBloc;
  late StreamSubscription _versionCheckSubscription;

  @override
  void initState() {
    super.initState();
    _globalOptions = Provider.of<GlobalOptions>(context, listen: false);
    _accountsBloc = Provider.of<AccountsBloc>(context, listen: false);
    _account = _accountsBloc.activeAccount.value!;
    _appsBloc = _accountsBloc.activeAppsBloc;

    _versionCheckSubscription = _appsBloc.appVersions.listen((final values) {
      if (values == null || !mounted) {
        return;
      }

      final l10n = AppLocalizations.of(context);

      final buffer = StringBuffer()..writeln();

      for (final error in values) {
        final (appId, minVersion) = error;
        final appName = l10n.appImplementationName(appId);

        if (appName.isNotEmpty && minVersion != null) {
          buffer.writeln('- $appName $minVersion');
        }
      }

      final message = l10n.errorUnsupportedVersion(buffer.toString());
      unawaited(_showProblem(message));
    });

    GlobalPopups().register(context);

    unawaited(_checkMaintenanceMode());
  }

  @override
  void dispose() {
    unawaited(_versionCheckSubscription.cancel());
    super.dispose();
  }

  Future _checkMaintenanceMode() async {
    try {
      final status = await _account.client.core.getStatus();
      if (status.maintenance && mounted) {
        await _showProblem(
          AppLocalizations.of(context).errorServerInMaintenanceMode,
        );
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      NeonException.showSnackbar(context, e);
    }
  }

  Future _showProblem(final String title) async {
    await showDialog(
      context: context,
      builder: (final context) => AlertDialog(
        title: Text(title),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context).actionClose),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    const drawer = NeonDrawer();
    const appBar = NeonAppBar();

    final appView = ResultBuilder<Iterable<AppImplementation>>.behaviorSubject(
      stream: _appsBloc.appImplementations,
      builder: (final context, final appImplementations) {
        if (!appImplementations.hasData) {
          return const SizedBox();
        }

        if (appImplementations.requireData.isEmpty) {
          return Center(
            child: Text(
              AppLocalizations.of(context).errorNoCompatibleNextcloudAppsFound,
              textAlign: TextAlign.center,
            ),
          );
        }

        return StreamBuilder<AppImplementation>(
          stream: _appsBloc.activeApp,
          builder: (final context, final activeAppIDSnapshot) {
            if (!activeAppIDSnapshot.hasData) {
              return const SizedBox();
            }

            return activeAppIDSnapshot.requireData.page;
          },
        );
      },
    );

    final body = OptionBuilder<NavigationMode>(
      option: _globalOptions.navigationMode,
      builder: (final context, final navigationMode) {
        final drawerAlwaysVisible = navigationMode == NavigationMode.drawerAlwaysVisible;

        final body = Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          drawer: !drawerAlwaysVisible ? drawer : null,
          appBar: appBar,
          body: appView,
        );

        if (drawerAlwaysVisible) {
          return Row(
            children: [
              drawer,
              Expanded(
                child: body,
              ),
            ],
          );
        }

        return body;
      },
    );

    return WillPopScope(
      onWillPop: () async {
        if (_scaffoldKey.currentState!.isDrawerOpen) {
          Navigator.pop(context);
          return true;
        }

        _scaffoldKey.currentState!.openDrawer();
        return false;
      },
      child: MultiProvider(
        providers: _appsBloc.appBlocProviders,
        child: body,
      ),
    );
  }
}
