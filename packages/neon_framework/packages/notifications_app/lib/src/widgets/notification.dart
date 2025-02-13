import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_framework/theme.dart';
import 'package:neon_framework/utils.dart';
import 'package:neon_framework/widgets.dart';
import 'package:neon_rich_text/neon_rich_text.dart';
import 'package:nextcloud/notifications.dart' as notifications;
import 'package:notifications_app/src/widgets/action.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationsNotification extends StatelessWidget {
  const NotificationsNotification({
    required this.notification,
    required this.onDelete,
    super.key,
  });

  final notifications.Notification notification;

  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final subject = notification.subjectRichParameters!.isNotEmpty
        ? Text.rich(
            buildRichTextSpan(
              account: NeonProvider.of<Account>(context),
              text: notification.subjectRich!,
              isMarkdown: false,
              parameters: notification.subjectRichParameters!,
              references: BuiltList(),
              textStyle: Theme.of(context).textTheme.bodyLarge!,
              onReferenceClicked: (_) {},
            ),
          )
        : Text(notification.subject);

    final message = notification.messageRichParameters!.isNotEmpty
        ? Text.rich(
            buildRichTextSpan(
              account: NeonProvider.of<Account>(context),
              text: notification.messageRich!,
              isMarkdown: false,
              parameters: notification.messageRichParameters!,
              references: BuiltList(),
              textStyle: Theme.of(context).textTheme.bodyMedium!,
              onReferenceClicked: (_) {},
            ),
            overflow: TextOverflow.ellipsis,
          )
        : Text(
            notification.message,
            overflow: TextOverflow.ellipsis,
          );

    return Dismissible(
      key: Key(notification.notificationId.toString()),
      direction: DismissDirection.startToEnd,
      behavior: HitTestBehavior.translucent,
      background: Container(color: Colors.red),
      onDismissed: (_) {
        onDelete();
      },
      child: ListTile(
        title: subject,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            if (notification.message.isNotEmpty) message,
            RelativeTime(
              date: tz.TZDateTime.parse(tz.UTC, notification.datetime),
            ),
            if (notification.actions.isNotEmpty)
              Row(
                children: notification.actions
                    .map(
                      (action) => NotificationsAction(
                        action: action,
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
        leading: notification.icon!.isNotEmpty
            ? NeonUriImage(
                account: NeonProvider.of<Account>(context),
                uri: Uri.parse(notification.icon!),
                size: const Size.square(largeIconSize),
                svgColorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
              )
            : const SizedBox.square(
                dimension: largeIconSize,
              ),
        onTap: notification.link.isNotEmpty
            ? () async => launchUrl(NeonProvider.of<Account>(context), notification.link)
            : null,
      ),
    );
  }
}
