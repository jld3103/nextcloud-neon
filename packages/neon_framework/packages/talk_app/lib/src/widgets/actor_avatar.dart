import 'package:flutter/material.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_framework/theme.dart';
import 'package:neon_framework/utils.dart';
import 'package:neon_framework/widgets.dart';
import 'package:nextcloud/spreed.dart' as spreed;

/// Displays an avatar for the actor.
///
/// In case the [actorType] is [spreed.ActorTypes.users] the user avatar will be shown, otherwise an appropriate icon is displayed.
class TalkActorAvatar extends StatelessWidget {
  /// Creates a new Talk actor avatar.
  const TalkActorAvatar({
    required this.actorId,
    required this.actorType,
    super.key,
  });

  /// The ID of the actor.
  final String actorId;

  /// The type of the actor.
  final spreed.ActorTypes actorType;

  @override
  Widget build(BuildContext context) {
    return switch (actorType) {
      spreed.ActorTypes.users => NeonUserAvatar(
          username: actorId,
          account: NeonProvider.of<Account>(context),
        ),
      spreed.ActorTypes.groups || spreed.ActorTypes.circles => CircleAvatar(
          child: Icon(AdaptiveIcons.group),
        ),
      spreed.ActorTypes.emails => CircleAvatar(
          child: Icon(AdaptiveIcons.email),
        ),
      spreed.ActorTypes.bots => CircleAvatar(
          child: Icon(AdaptiveIcons.automation),
        ),
      _ => CircleAvatar(
          child: Icon(AdaptiveIcons.person),
        ),
    };
  }
}
