import 'package:flutter/material.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/utils.dart';
import 'package:nextcloud/spreed.dart' as spreed;
import 'package:nextcloud/utils.dart';
import 'package:timezone/timezone.dart' as tz;

/// `systemMessage` of chat messages that are hidden and only need to be processed internally.
/// They modify the state of other messages, but should not be displayed to the user.
// Keep this in sync with https://github.com/nextcloud/spreed/blob/ada70487a306751accb280a475b1f123a56d4e74/src/store/conversationsStore.js#L689
const _hiddenMessages = <String>{
  'reaction',
  'reaction_revoked',
  'reaction_deleted',
  'message_deleted',
  'message_edited',
  'poll_voted',
};

/// Extension for querying if a chat message is hidden.
extension ChatMessageHidden on spreed.$ChatMessageInterface {
  /// Chat message is hidden for the user and only needs to be processed internally.
  bool get isHidden => _hiddenMessages.contains(systemMessage);
}

/// Helper extension for [spreed.$ChatMessageInterface]
extension $ChatMessageInterfaceHelpers on spreed.$ChatMessageInterface {
  /// Parsed equivalent of [timestamp].
  tz.TZDateTime get parsedTimestamp => DateTimeUtils.fromSecondsSinceEpoch(tz.local, timestamp);

  /// Parsed equivalent of [lastEditTimestamp].
  tz.TZDateTime? get parsedLastEditTimestamp =>
      lastEditTimestamp != null ? DateTimeUtils.fromSecondsSinceEpoch(tz.local, lastEditTimestamp!) : null;
}

/// Helper extension for [spreed.$ReactionInterface]
extension $ReactionInterfaceHelpers on spreed.$ReactionInterface {
  /// Parsed equivalent of [timestamp].
  tz.TZDateTime get parsedTimestamp => DateTimeUtils.fromSecondsSinceEpoch(tz.local, timestamp);
}

/// Returns if the Talk [feature] is supported on the instance.
bool hasFeature(BuildContext context, String feature) {
  final capabilitiesBloc = NeonProvider.of<CapabilitiesBloc>(context);
  final capabilities = capabilitiesBloc.capabilities.valueOrNull?.data?.capabilities.spreedPublicCapabilities?.spreed;

  if (capabilities == null) {
    return false;
  }

  return capabilities.features.contains(feature);
}

/// Checks whether the user is allowed to send chat messages in a [room].
bool canSendMessageAndShareAndReact(spreed.Room room) {
  return room.readOnly == 0 &&
      spreed.ParticipantPermission.values
          .byBinary(room.permissions)
          .contains(spreed.ParticipantPermission.canSendMessageAndShareAndReact);
}

/// Checks whether the user is allowed to reply to a [chatMessage] in a [room].
bool canReplyToMessage(spreed.Room room, spreed.$ChatMessageInterface chatMessage) {
  return canSendMessageAndShareAndReact(room) &&
      chatMessage.messageType != spreed.MessageType.commentDeleted &&
      chatMessage.isReplyable;
}

/// Checks whether the user is allowed to edit a [chatMessage] in a [room].
bool canEditMessage(BuildContext context, spreed.Room room, spreed.$ChatMessageInterface chatMessage) {
  return chatMessage.messageType != spreed.MessageType.commentDeleted &&
      chatMessage.actorId == room.actorId &&
      hasFeature(context, 'edit-messages');
}

/// Checks whether the user is allowed to delete a [chatMessage] in a [room].
bool canDeleteMessage(spreed.Room room, spreed.$ChatMessageInterface chatMessage) {
  return chatMessage.messageType != spreed.MessageType.commentDeleted && chatMessage.actorId == room.actorId;
}
