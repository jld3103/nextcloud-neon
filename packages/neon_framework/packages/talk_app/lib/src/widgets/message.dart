import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_framework/theme.dart';
import 'package:neon_framework/utils.dart';
import 'package:neon_framework/widgets.dart';
import 'package:neon_rich_text/neon_rich_text.dart';
import 'package:nextcloud/spreed.dart' as spreed;
import 'package:talk_app/l10n/localizations.dart';
import 'package:talk_app/src/blocs/message_bloc.dart';
import 'package:talk_app/src/blocs/room.dart';
import 'package:talk_app/src/utils/helpers.dart';
import 'package:talk_app/src/widgets/actor_avatar.dart';
import 'package:talk_app/src/widgets/reactions.dart';
import 'package:talk_app/src/widgets/read_indicator.dart';
import 'package:talk_app/src/widgets/reference_preview.dart';
import 'package:timezone/timezone.dart' as tz;

final _timeFormat = DateFormat.jm();
final _dateTimeFormat = DateFormat.yMd().add_jm();

/// Action that can be performed on a [TalkCommentMessage].
typedef TalkMessageAction = ({Widget icon, Widget child, VoidCallback onPressed});

/// Returns the display name of the actor of the [chatMessage].
///
/// In case the actor is a guest and has no display name set a default display name will be returned.
String getActorDisplayName(TalkLocalizations localizations, spreed.$ChatMessageInterface chatMessage) {
  final actorDisplayName = chatMessage.actorDisplayName;

  if (actorDisplayName.isEmpty && chatMessage.actorType == spreed.ActorTypes.guests) {
    return localizations.actorGuest;
  }

  return actorDisplayName;
}

/// Displays a preview of the [chatMessage] including the display name of the sender.
class TalkMessagePreview extends StatelessWidget {
  /// Creates a new Talk message preview.
  const TalkMessagePreview({
    required this.actorId,
    required this.roomType,
    required this.chatMessage,
    super.key,
  });

  /// ID of the current actor.
  final String actorId;

  /// Type of the room
  final spreed.RoomType roomType;

  /// {@macro TalkMessage.chatMessage}
  final spreed.$ChatMessageInterface chatMessage;

  @override
  Widget build(BuildContext context) {
    String? actorName;
    if (chatMessage.messageType != spreed.MessageType.system) {
      if (chatMessage.actorId == actorId) {
        actorName = TalkLocalizations.of(context).actorSelf;
      } else if (!roomType.isSingleUser) {
        actorName = getActorDisplayName(TalkLocalizations.of(context), chatMessage);
      }
    }

    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        children: [
          if (actorName != null)
            TextSpan(
              text: '$actorName: ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          buildRichTextSpan(
            text: chatMessage.message,
            parameters: chatMessage.messageParameters,
            references: BuiltList(),
            isPreview: true,
            style: Theme.of(context).textTheme.bodyMedium!,
            onReferenceClicked: (url) async => launchUrl(NeonProvider.of<Account>(context), url),
          ),
        ],
      ),
    );
  }
}

/// Displays a Talk chat message in the right way based on the message type.
class TalkMessage extends StatelessWidget {
  /// Creates a new Talk message.
  const TalkMessage({
    required this.room,
    required this.chatMessage,
    required this.lastCommonRead,
    this.previousChatMessage,
    this.isParent = false,
    super.key,
  });

  /// {@template TalkMessage.room}
  /// The room where the [chatMessage] is in.
  /// {@endtemplate}
  final spreed.Room room;

  /// {@template TalkMessage.chatMessage}
  /// The chat message to display.
  /// {@endtemplate}
  final spreed.$ChatMessageInterface chatMessage;

  /// {@macro TalkRoomBloc.lastCommonRead}
  final int? lastCommonRead;

  /// {@template TalkMessage.previousChatMessage}
  /// The previous chat message.
  /// {@endtemplate}
  final spreed.$ChatMessageInterface? previousChatMessage;

  /// {@template TalkMessage.isParent}
  /// Whether the displayed chat message is a parent chat message that was replied to.
  /// {@endtemplate}
  final bool isParent;

  @override
  Widget build(BuildContext context) {
    if (chatMessage.messageType == spreed.MessageType.system) {
      return TalkSystemMessage(
        chatMessage: chatMessage,
        previousChatMessage: previousChatMessage,
      );
    }

    return TalkCommentMessage(
      room: room,
      chatMessage: chatMessage,
      lastCommonRead: lastCommonRead,
      previousChatMessage: previousChatMessage,
      isParent: isParent,
    );
  }
}

/// Displays a system chat message.
class TalkSystemMessage extends StatelessWidget {
  /// Creates a new Talk system message.
  const TalkSystemMessage({
    required this.chatMessage,
    required this.previousChatMessage,
    super.key,
  });

  /// {@macro TalkMessage.chatMessage}
  final spreed.$ChatMessageInterface chatMessage;

  /// {@macro TalkMessage.previousChatMessage}
  final spreed.$ChatMessageInterface? previousChatMessage;

  @override
  Widget build(BuildContext context) {
    final groupMessages = previousChatMessage?.messageType == spreed.MessageType.system;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: groupMessages ? 2.5 : 10),
      child: Center(
        child: RichText(
          text: buildRichTextSpan(
            text: chatMessage.message,
            parameters: chatMessage.messageParameters,
            references: BuiltList(),
            style: Theme.of(context).textTheme.labelSmall!,
            onReferenceClicked: (url) async => launchUrl(NeonProvider.of<Account>(context), url),
          ),
        ),
      ),
    );
  }
}

/// Displays a parent chat message that was replied to.
class TalkParentMessage extends StatelessWidget {
  /// Creates a new Talk parent message.
  const TalkParentMessage({
    required this.room,
    required this.parentChatMessage,
    required this.lastCommonRead,
    super.key,
  });

  /// {@macro TalkMessage.room}
  final spreed.Room room;

  /// The parent chat message.
  ///
  /// Do not pass the child chat message.
  final spreed.$ChatMessageInterface parentChatMessage;

  /// {@macro TalkRoomBloc.lastCommonRead}
  final int? lastCommonRead;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondaryContainer,
          width: 2,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TalkMessage(
        room: room,
        chatMessage: parentChatMessage,
        lastCommonRead: lastCommonRead,
        isParent: true,
      ),
    );
  }
}

/// Displays a comment chat message including voice messages, recorded audio and video and reactions.
class TalkCommentMessage extends StatefulWidget {
  /// Creates a new Talk comment message.
  const TalkCommentMessage({
    required this.room,
    required this.chatMessage,
    required this.lastCommonRead,
    this.previousChatMessage,
    this.isParent = false,
    super.key,
  });

  /// {@macro TalkMessage.room}
  final spreed.Room room;

  /// {@macro TalkMessage.chatMessage}
  final spreed.$ChatMessageInterface chatMessage;

  /// {@macro TalkRoomBloc.lastCommonRead}
  final int? lastCommonRead;

  /// {@macro TalkMessage.previousChatMessage}
  final spreed.$ChatMessageInterface? previousChatMessage;

  /// {@macro TalkMessage.isParent}
  final bool isParent;

  @override
  State<TalkCommentMessage> createState() => _TalkCommentMessageState();
}

class _TalkCommentMessageState extends State<TalkCommentMessage> {
  bool hoverState = false;
  bool menuOpen = false;
  late final TalkMessageBloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = TalkMessageBloc(
      chatMessage: widget.chatMessage,
      referencesBloc: NeonProvider.of<ReferencesBloc>(context),
      isParent: widget.isParent,
    );
  }

  @override
  void dispose() {
    bloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.references,
      builder: (context, referencesResult) {
        final references = referencesResult.data ?? BuiltMap();

        final textTheme = Theme.of(context).textTheme;
        final labelColor = Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.7);

        final date = widget.chatMessage.parsedTimestamp;
        tz.TZDateTime? previousDate;
        if (widget.previousChatMessage != null) {
          previousDate = widget.previousChatMessage!.parsedTimestamp;
        }

        final separateMessages = widget.chatMessage.actorId != widget.previousChatMessage?.actorId ||
            widget.previousChatMessage?.messageType == spreed.MessageType.system ||
            previousDate == null ||
            date.difference(previousDate) > const Duration(minutes: 3) ||
            widget.chatMessage.lastEditTimestamp != null;

        Widget? label;
        Widget? avatar;
        Widget? time;
        if (separateMessages) {
          label = Text(
            getActorDisplayName(TalkLocalizations.of(context), widget.chatMessage),
            style: textTheme.labelLarge!.copyWith(
              color: labelColor,
            ),
          );

          if (widget.chatMessage.lastEditTimestamp != null && widget.chatMessage.lastEditActorDisplayName != null) {
            label = Row(
              children: [
                label,
                Tooltip(
                  message: TalkLocalizations.of(context).roomMessageLastEdited(
                    widget.chatMessage.lastEditActorDisplayName!,
                    DateFormat.yMd().add_jm().format(widget.chatMessage.parsedLastEditTimestamp!),
                  ),
                  child: Text(
                    ' (${TalkLocalizations.of(context).roomMessageEdited})',
                    style: textTheme.labelLarge!.copyWith(
                      color: labelColor,
                    ),
                  ),
                ),
              ],
            );
          }

          if (!widget.isParent) {
            avatar = TalkActorAvatar(
              actorId: widget.chatMessage.actorId,
              actorType: widget.chatMessage.actorType,
            );

            time = Tooltip(
              message: _dateTimeFormat.format(date),
              child: Text(
                _timeFormat.format(date),
                style: textTheme.labelSmall,
              ),
            );
          }
        }

        Widget? parent;
        if (widget.chatMessage
            case spreed.ChatMessageWithParent(
              parent: final p,
              messageType: != spreed.MessageType.commentDeleted,
            ) when p?.chatMessage != null && !widget.isParent) {
          parent = TalkParentMessage(
            room: widget.room,
            parentChatMessage: p!.chatMessage!,
            lastCommonRead: widget.lastCommonRead,
          );
        }

        double topMargin;
        if (widget.isParent) {
          topMargin = 5;
        } else if (separateMessages) {
          topMargin = 20;
        } else {
          topMargin = 0;
        }

        Widget text = Text.rich(
          buildRichTextSpan(
            text: widget.chatMessage.message,
            parameters: widget.chatMessage.messageParameters,
            isPreview: widget.isParent,
            references: references.keys.toBuiltList(),
            style: textTheme.bodyLarge!.copyWith(
              color: widget.isParent || widget.chatMessage.messageType == spreed.MessageType.commentDeleted
                  ? labelColor
                  : null,
            ),
            onReferenceClicked: (url) async => launchUrl(NeonProvider.of<Account>(context), url),
          ),
          maxLines: widget.isParent ? 1 : null,
          overflow: widget.isParent ? TextOverflow.ellipsis : TextOverflow.visible,
        );
        if (widget.chatMessage.messageType == spreed.MessageType.commentDeleted) {
          text = Row(
            children: [
              Icon(
                AdaptiveIcons.cancel,
                size: textTheme.bodySmall!.fontSize,
                color: labelColor,
              ),
              const SizedBox(
                width: 2.5,
              ),
              text,
            ],
          );
        }

        final account = NeonProvider.of<Account>(context);

        Widget? readIndicator;
        if (widget.lastCommonRead != null && account.username == widget.chatMessage.actorId) {
          readIndicator = TalkReadIndicator(
            chatMessage: widget.chatMessage,
            lastCommonRead: widget.lastCommonRead!,
          );
        }

        Widget message = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (label != null) label,
                if (time != null) time,
              ],
            ),
            if (parent != null) parent,
            text,
            for (final entry in references.entries.take(3))
              TalkReferencePreview(
                url: entry.key,
                openGraphObject: entry.value.data?.openGraphObject,
              ),
            if (!widget.isParent && widget.chatMessage.reactions.isNotEmpty)
              TalkReactions(
                room: widget.room,
                chatMessage: widget.chatMessage,
              ),
          ],
        );

        if (!widget.isParent) {
          final actions = _buildMessageActions(widget.room, widget.chatMessage);

          message = Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SizedBox(
                    width: 40,
                    child: avatar,
                  ),
                ),
                Expanded(
                  child: message,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: SizedBox(
                    width: 14,
                    child: readIndicator,
                  ),
                ),
                SizedBox.square(
                  dimension: 32,
                  child: actions.isNotEmpty && (hoverState || menuOpen) ? _buildPopupMenuButton(actions) : null,
                ),
              ],
            ),
          );

          if (actions.isNotEmpty) {
            message = MouseRegion(
              onEnter: (_) {
                setState(() {
                  hoverState = true;
                });
              },
              onExit: (_) {
                setState(() {
                  hoverState = false;
                });
              },
              child: InkWell(
                onLongPress: () async => _showActionsModal(actions),
                child: message,
              ),
            );
          }
        }

        return Container(
          margin: EdgeInsets.only(
            top: topMargin,
            bottom: 5,
          ),
          child: message,
        );
      },
    );
  }

  List<TalkMessageAction> _buildMessageActions(
    spreed.Room room,
    spreed.$ChatMessageInterface chatMessage,
  ) {
    return [
      if (canReplyToMessage(room, chatMessage))
        (
          icon: const Icon(Icons.add_reaction_outlined),
          child: Text(TalkLocalizations.of(context).roomMessageReaction),
          onPressed: () async {
            final reaction = await showDialog<String>(
              context: context,
              builder: (context) => const NeonEmojiPickerDialog(),
            );
            if (reaction == null) {
              return;
            }

            if (!context.mounted) {
              return;
            }

            // ignore: use_build_context_synchronously
            NeonProvider.of<TalkRoomBloc>(context).addReaction(chatMessage, reaction);
          },
        ),
      if (canReplyToMessage(room, chatMessage))
        (
          icon: const Icon(Icons.reply),
          child: Text(TalkLocalizations.of(context).roomMessageReply),
          onPressed: () => NeonProvider.of<TalkRoomBloc>(context).setReplyChatMessage(chatMessage),
        ),
      if (canEditMessage(context, room, chatMessage))
        (
          icon: const Icon(Icons.edit),
          child: Text(TalkLocalizations.of(context).roomMessageEdit),
          onPressed: () => NeonProvider.of<TalkRoomBloc>(context).setEditChatMessage(chatMessage),
        ),
      if (chatMessage.messageType != spreed.MessageType.commentDeleted && chatMessage.actorId == room.actorId)
        (
          icon: const Icon(Icons.delete_forever),
          child: Text(TalkLocalizations.of(context).roomMessageDelete),
          onPressed: () => NeonProvider.of<TalkRoomBloc>(context).deleteMessage(chatMessage),
        ),
    ];
  }

  Widget? _buildPopupMenuButton(List<TalkMessageAction> actions) {
    final children = actions
        .map(
          (action) => MenuItemButton(
            leadingIcon: action.icon,
            onPressed: () {
              setState(() {
                menuOpen = false;
              });

              action.onPressed();
            },
            child: action.child,
          ),
        )
        .toList();

    return MenuAnchor(
      menuChildren: children,
      onOpen: () {
        setState(() {
          menuOpen = true;
        });
      },
      onClose: () {
        setState(() {
          menuOpen = false;
        });
      },
      builder: (context, controller, child) => IconButton(
        onPressed: () {
          if (controller.isOpen) {
            controller.close();
          } else {
            controller.open();
          }
        },
        padding: const EdgeInsets.all(4),
        icon: const Icon(Icons.more_vert),
      ),
    );
  }

  Future<void> _showActionsModal(List<TalkMessageAction> actions) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TalkParentMessage(
                    room: widget.room,
                    parentChatMessage: widget.chatMessage,
                    lastCommonRead: widget.lastCommonRead,
                  ),
                ),
              ),
              for (final action in actions)
                ListTile(
                  leading: action.icon,
                  title: action.child,
                  onTap: () {
                    Navigator.of(context).pop();
                    action.onPressed();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
