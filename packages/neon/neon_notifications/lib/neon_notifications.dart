library notifications;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:neon/blocs.dart';
import 'package:neon/models.dart';
import 'package:neon/settings.dart';
import 'package:neon/theme.dart';
import 'package:neon/utils.dart';
import 'package:neon/widgets.dart';
import 'package:neon_notifications/l10n/localizations.dart';
import 'package:neon_notifications/routes.dart';
import 'package:nextcloud/core.dart' as core;
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/notifications.dart' as notifications;
import 'package:rxdart/rxdart.dart';

part 'blocs/notifications.dart';
part 'options.dart';
part 'pages/main.dart';

class NotificationsClient extends ClientImplementation<NotificationsBloc, NotificationsClientSpecificOptions>
    implements
        // ignore: avoid_implementing_value_types
        NotificationsClientInterface<NotificationsBloc, NotificationsClientSpecificOptions> {
  NotificationsClient();

  @override
  final String id = AppIDs.notifications;

  @override
  final LocalizationsDelegate<NotificationsLocalizations> localizationsDelegate = NotificationsLocalizations.delegate;

  @override
  final List<Locale> supportedLocales = NotificationsLocalizations.supportedLocales;

  @override
  late final NotificationsClientSpecificOptions options = NotificationsClientSpecificOptions(storage);

  @override
  NotificationsBloc buildBloc(final Account account) => NotificationsBloc(
        options,
        account,
      );

  @override
  final Widget page = const NotificationsMainPage();

  @override
  final RouteBase route = $notificationsClientRoute;

  @override
  BehaviorSubject<int> getUnreadCounter(final NotificationsBloc bloc) => bloc.unreadCounter;

  @override
  (bool? supported, String? minimumVersion) isSupported(
    final Account account,
    final core.OcsGetCapabilitiesResponseApplicationJson_Ocs_Data capabilities,
  ) =>
      const (null, null);
}
