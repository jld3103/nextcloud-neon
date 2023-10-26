part of '../neon_notifications.dart';

abstract interface class NotificationsBlocEvents {
  void deleteNotification(final int id);

  void deleteAllNotifications();
}

abstract interface class NotificationsBlocStates {
  BehaviorSubject<Result<List<notifications.Notification>>> get notificationsList;

  BehaviorSubject<int> get unreadCounter;
}

class NotificationsBloc extends InteractiveBloc
    implements NotificationsBlocInterface, NotificationsBlocEvents, NotificationsBlocStates {
  NotificationsBloc(
    this.options,
    this._account,
  ) {
    notificationsList.listen((final result) {
      if (result.hasData) {
        unreadCounter.add(result.requireData.length);
      }
    });

    unawaited(refresh());
    _timer = TimerBloc().registerTimer(const Duration(seconds: 30), refresh);
  }

  @override
  final NotificationsClientSpecificOptions options;
  final Account _account;
  late final NeonTimer _timer;

  @override
  void dispose() {
    _timer.cancel();
    unawaited(notificationsList.close());
    unawaited(unreadCounter.close());
    super.dispose();
  }

  @override
  BehaviorSubject<Result<List<notifications.Notification>>> notificationsList =
      BehaviorSubject<Result<List<notifications.Notification>>>();

  @override
  BehaviorSubject<int> unreadCounter = BehaviorSubject<int>();

  @override
  Future<void> refresh() async {
    await RequestManager.instance.wrapNextcloud<List<notifications.Notification>,
        notifications.EndpointListNotificationsResponseApplicationJson, void>(
      _account.id,
      'notifications-notifications',
      notificationsList,
      _account.client.notifications.endpoint.listNotificationsRaw(),
      (final response) => response.body.ocs.data.toList(),
    );
  }

  @override
  void deleteAllNotifications() {
    wrapAction(() async => _account.client.notifications.endpoint.deleteAllNotifications());
  }

  @override
  void deleteNotification(final int id) {
    wrapAction(() async => _account.client.notifications.endpoint.deleteNotification(id: id));
  }
}
