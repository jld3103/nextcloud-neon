import 'dart:async';
import 'dart:convert';

import 'package:built_value/json_object.dart';
import 'package:nextcloud/core.dart' as core;
import 'package:nextcloud/spreed.dart' as spreed;
import 'package:nextcloud/src/utils/date_time.dart';
import 'package:nextcloud_test/nextcloud_test.dart';
import 'package:test/test.dart';
import 'package:version/version.dart';

void main() {
  presets('spreed', 'spreed', (tester) {
    Future<spreed.Room> createTestRoom() async => (await tester.client.spreed.room.createRoom(
          $body: spreed.RoomCreateRoomRequestApplicationJson(
            (b) => b
              ..roomType = spreed.RoomType.public.value
              ..roomName = 'Test',
          ),
        ))
            .body
            .ocs
            .data;

    group('Helpers', () {
      test('Is supported', () async {
        final response = await tester.client.core.ocs.getCapabilities();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        final result = tester.client.spreed.getVersionCheck(response.body.ocs.data);
        expect(result.versions, isNotNull);
        expect(result.versions, isNotEmpty);
        expect(result.isSupported, isTrue);
      });

      test('Participant permissions', () async {
        expect(spreed.ParticipantPermission.$default.binary, 0);
        expect(spreed.ParticipantPermission.values.byBinary(0), {spreed.ParticipantPermission.$default});
        expect({spreed.ParticipantPermission.$default}.binary, 0);

        expect(spreed.ParticipantPermission.custom.binary, 1);
        expect(spreed.ParticipantPermission.canSendMessageAndShareAndReact.binary, 128);
        expect(spreed.ParticipantPermission.values.byBinary(129), {
          spreed.ParticipantPermission.custom,
          spreed.ParticipantPermission.canSendMessageAndShareAndReact,
        });
        expect(
          {
            spreed.ParticipantPermission.custom,
            spreed.ParticipantPermission.canSendMessageAndShareAndReact,
          }.binary,
          129,
        );
      });
    });

    group('Room', () {
      test('Get rooms', () async {
        final response = await tester.client.spreed.room.getRooms();
        expect(response.body.ocs.data, isNotEmpty);
        final room = response.body.ocs.data.singleWhere((room) => room.type == spreed.RoomType.changelog.value);
        expect(room.id, isPositive);
        expect(room.token, isNotEmpty);
        expect(room.type, spreed.RoomType.changelog.value);
        expect(room.name, 'user1');
        expect(room.displayName, 'Talk updates ✅');
        expect(room.participantType, spreed.ParticipantType.user.value);
        expect(spreed.ParticipantPermission.values.byBinary(room.permissions), {
          spreed.ParticipantPermission.startCall,
          spreed.ParticipantPermission.joinCall,
          spreed.ParticipantPermission.canPublishAudio,
          spreed.ParticipantPermission.canPublishVideo,
          spreed.ParticipantPermission.canScreenShare,
          spreed.ParticipantPermission.canSendMessageAndShareAndReact,
        });
      });

      test('Session', () async {
        var room = await createTestRoom();
        expect(room.sessionId, '0');

        final response = await tester.client.spreed.room.joinRoom(token: room.token);
        expect(response.body.ocs.data.id, room.id);
        expect(response.body.ocs.data.sessionId, isNot(room.sessionId));

        room = (await tester.client.spreed.room.getSingleRoom(token: room.token)).body.ocs.data;
        expect(room.sessionId, response.body.ocs.data.sessionId);

        await tester.client.spreed.room.leaveRoom(token: room.token);
        room = (await tester.client.spreed.room.getSingleRoom(token: room.token)).body.ocs.data;
        expect(room.sessionId, '0');
      });

      group('Create room', () {
        test('One-to-One', () async {
          final response = await tester.client.spreed.room.createRoom(
            $body: spreed.RoomCreateRoomRequestApplicationJson(
              (b) => b
                ..roomType = spreed.RoomType.oneToOne.value
                ..invite = 'user2',
            ),
          );
          expect(response.body.ocs.data.id, isPositive);
          expect(response.body.ocs.data.token, isNotEmpty);
          expect(response.body.ocs.data.type, spreed.RoomType.oneToOne.value);
          expect(response.body.ocs.data.name, 'user2');
          expect(response.body.ocs.data.displayName, 'User Two');
          expect(response.body.ocs.data.participantType, spreed.ParticipantType.owner.value);
          expect(spreed.ParticipantPermission.values.byBinary(response.body.ocs.data.permissions), {
            spreed.ParticipantPermission.startCall,
            spreed.ParticipantPermission.joinCall,
            spreed.ParticipantPermission.canIgnoreLobby,
            spreed.ParticipantPermission.canPublishAudio,
            spreed.ParticipantPermission.canPublishVideo,
            spreed.ParticipantPermission.canScreenShare,
            spreed.ParticipantPermission.canSendMessageAndShareAndReact,
          });
        });

        test('Group', () async {
          final response = await tester.client.spreed.room.createRoom(
            $body: spreed.RoomCreateRoomRequestApplicationJson(
              (b) => b
                ..roomType = spreed.RoomType.group.value
                ..invite = 'admin',
            ),
          );
          expect(response.body.ocs.data.id, isPositive);
          expect(response.body.ocs.data.token, isNotEmpty);
          expect(response.body.ocs.data.type, spreed.RoomType.group.value);
          expect(response.body.ocs.data.name, 'admin');
          expect(response.body.ocs.data.displayName, 'admin');
          expect(response.body.ocs.data.participantType, spreed.ParticipantType.owner.value);
          expect(spreed.ParticipantPermission.values.byBinary(response.body.ocs.data.permissions), {
            spreed.ParticipantPermission.startCall,
            spreed.ParticipantPermission.joinCall,
            spreed.ParticipantPermission.canIgnoreLobby,
            spreed.ParticipantPermission.canPublishAudio,
            spreed.ParticipantPermission.canPublishVideo,
            spreed.ParticipantPermission.canScreenShare,
            spreed.ParticipantPermission.canSendMessageAndShareAndReact,
          });
        });

        test('Public', () async {
          final response = await tester.client.spreed.room.createRoom(
            $body: spreed.RoomCreateRoomRequestApplicationJson(
              (b) => b
                ..roomType = spreed.RoomType.public.value
                ..roomName = 'abc',
            ),
          );
          expect(response.body.ocs.data.id, isPositive);
          expect(response.body.ocs.data.token, isNotEmpty);
          expect(response.body.ocs.data.type, spreed.RoomType.public.value);
          expect(response.body.ocs.data.name, 'abc');
          expect(response.body.ocs.data.displayName, 'abc');
          expect(response.body.ocs.data.participantType, spreed.ParticipantType.owner.value);
          expect(spreed.ParticipantPermission.values.byBinary(response.body.ocs.data.permissions), {
            spreed.ParticipantPermission.startCall,
            spreed.ParticipantPermission.joinCall,
            spreed.ParticipantPermission.canIgnoreLobby,
            spreed.ParticipantPermission.canPublishAudio,
            spreed.ParticipantPermission.canPublishVideo,
            spreed.ParticipantPermission.canScreenShare,
            spreed.ParticipantPermission.canSendMessageAndShareAndReact,
          });
        });
      });

      test('Message expiration', () async {
        const expiration = 1;

        final room = await createTestRoom();
        expect(room.lastMessage!.baseMessage, isNotNull);
        expect(room.lastMessage!.builtListNever, isNull);
        expect(room.lastMessage!.chatMessage, isNotNull);

        await tester.client.spreed.room.setMessageExpiration(
          token: room.token,
          $body: spreed.RoomSetMessageExpirationRequestApplicationJson(
            (b) => b.seconds = expiration,
          ),
        );

        final clearHistoryResponse = await tester.client.spreed.chat.clearHistory(
          token: room.token,
        );
        expect(clearHistoryResponse.body.ocs.data.expirationTimestamp, isPositive);

        await Future<void>.delayed(const Duration(seconds: expiration));

        final getRoomResponse = await tester.client.spreed.room.getSingleRoom(
          token: room.token,
        );
        if (tester.version < Version(21, 0, 0)) {
          expect(getRoomResponse.body.ocs.data.lastMessage!.baseMessage, isNull);
          expect(getRoomResponse.body.ocs.data.lastMessage!.builtListNever, isNotNull);
          expect(getRoomResponse.body.ocs.data.lastMessage!.chatMessage, isNull);
        } else {
          expect(getRoomResponse.body.ocs.data.lastMessage, isNull);
        }
      });
    });

    group('Avatar', () {
      test('Set emoji avatar', () async {
        final room = await createTestRoom();

        final response = await tester.client.spreed.avatar.emojiAvatar(
          token: room.token,
          $body: spreed.AvatarEmojiAvatarRequestApplicationJson(
            (b) => b..emoji = '😀',
          ),
        );
        expect(response.statusCode, 200);
        expect(response.body.ocs.data.isCustomAvatar, true);
      });

      test('Get avatar', () async {
        final room = await createTestRoom();
        await tester.client.spreed.avatar.emojiAvatar(
          token: room.token,
          $body: spreed.AvatarEmojiAvatarRequestApplicationJson(
            (b) => b..emoji = '😀',
          ),
        );

        final response = await tester.client.spreed.avatar.getAvatar(
          token: room.token,
        );
        expect(response.statusCode, 200);
        expect(response.body, isNotEmpty);
      });

      test('Get avatar dark', () async {
        final room = await createTestRoom();
        await tester.client.spreed.avatar.emojiAvatar(
          token: room.token,
          $body: spreed.AvatarEmojiAvatarRequestApplicationJson(
            (b) => b..emoji = '😀',
          ),
        );

        final response = await tester.client.spreed.avatar.getAvatarDark(
          token: room.token,
        );
        expect(response.statusCode, 200);
        expect(response.body, isNotEmpty);
      });

      test('Delete avatar', () async {
        final room = await createTestRoom();
        await tester.client.spreed.avatar.emojiAvatar(
          token: room.token,
          $body: spreed.AvatarEmojiAvatarRequestApplicationJson(
            (b) => b..emoji = '😀',
          ),
        );

        final response = await tester.client.spreed.avatar.deleteAvatar(
          token: room.token,
        );
        expect(response.statusCode, 200);
        expect(response.body.ocs.data.isCustomAvatar, false);
      });
    });

    group('Chat', () {
      test('Send message', () async {
        final startTime = DateTime.timestamp();
        final room = await createTestRoom();

        final response = await tester.client.spreed.chat.sendMessage(
          token: room.token,
          $body: spreed.ChatSendMessageRequestApplicationJson(
            (b) => b..message = 'bla',
          ),
        );
        expect(response.body.ocs.data!.id, isPositive);
        expect(response.body.ocs.data!.actorType, spreed.ActorTypes.users);
        expect(response.body.ocs.data!.actorId, 'user1');
        expect(response.body.ocs.data!.actorDisplayName, 'User One');
        expect(response.body.ocs.data!.timestamp, closeTo(startTime.secondsSinceEpoch, 10));
        expect(response.body.ocs.data!.message, 'bla');
        expect(response.body.ocs.data!.messageType, spreed.MessageType.comment);
      });

      test(
        'Edit message',
        () async {
          final startTime = DateTime.timestamp();
          final room = await createTestRoom();

          final messageResponse = await tester.client.spreed.chat.sendMessage(
            token: room.token,
            $body: spreed.ChatSendMessageRequestApplicationJson(
              (b) => b..message = 'bla',
            ),
          );

          final response = await tester.client.spreed.chat.editMessage(
            token: room.token,
            messageId: messageResponse.body.ocs.data!.id,
            $body: spreed.ChatEditMessageRequestApplicationJson(
              (b) => b..message = '123',
            ),
          );
          expect(response.body.ocs.data.id, isPositive);
          expect(response.body.ocs.data.actorType, spreed.ActorTypes.users);
          expect(response.body.ocs.data.actorId, 'user1');
          expect(response.body.ocs.data.actorDisplayName, 'User One');
          expect(response.body.ocs.data.message, 'You edited a message');
          expect(response.body.ocs.data.messageType, spreed.MessageType.system);
          expect(response.body.ocs.data.systemMessage, 'message_edited');
          expect(response.body.ocs.data.parent!.chatMessage!.id, messageResponse.body.ocs.data!.id);
          expect(response.body.ocs.data.parent!.chatMessage!.actorType, spreed.ActorTypes.users);
          expect(response.body.ocs.data.parent!.chatMessage!.actorId, 'user1');
          expect(response.body.ocs.data.parent!.chatMessage!.actorDisplayName, 'User One');
          expect(response.body.ocs.data.parent!.chatMessage!.message, '123');
          expect(response.body.ocs.data.parent!.chatMessage!.messageType, spreed.MessageType.comment);
          expect(response.body.ocs.data.parent!.chatMessage!.systemMessage, '');
          expect(
            response.body.ocs.data.parent!.chatMessage!.lastEditTimestamp,
            closeTo(startTime.secondsSinceEpoch, 10),
          );
          expect(response.body.ocs.data.parent!.chatMessage!.lastEditActorId, 'user1');
          expect(response.body.ocs.data.parent!.chatMessage!.lastEditActorDisplayName, 'User One');
          expect(response.body.ocs.data.parent!.chatMessage!.lastEditActorType, spreed.ActorTypes.users);
        },
        skip: tester.version < Version(19, 0, 0),
      );

      group('Get messages', () {
        test('Directly', () async {
          final startTime = DateTime.timestamp();
          final room = await createTestRoom();

          final message = (await tester.client.spreed.chat.sendMessage(
            token: room.token,
            $body: spreed.ChatSendMessageRequestApplicationJson(
              (b) => b..message = 'bla',
            ),
          ))
              .body
              .ocs
              .data!;

          await tester.client.spreed.chat.sendMessage(
            token: room.token,
            $body: spreed.ChatSendMessageRequestApplicationJson(
              (b) => b
                ..message = '123'
                ..replyTo = message.id,
            ),
          );

          final response = await tester.client.spreed.chat.receiveMessages(
            token: room.token,
            lookIntoFuture: spreed.ChatReceiveMessagesLookIntoFuture.$0,
          );
          expect(response.headers.xChatLastGiven, isNotEmpty);
          expect(response.headers.xChatLastCommonRead, isNotEmpty);

          expect(response.body.ocs.data, hasLength(3));

          expect(response.body.ocs.data[0].id, isPositive);
          expect(response.body.ocs.data[0].actorType, spreed.ActorTypes.users);
          expect(response.body.ocs.data[0].actorId, 'user1');
          expect(response.body.ocs.data[0].actorDisplayName, 'User One');
          expect(response.body.ocs.data[0].timestamp, closeTo(startTime.secondsSinceEpoch, 10));
          expect(response.body.ocs.data[0].message, '123');
          expect(response.body.ocs.data[0].messageType, spreed.MessageType.comment);

          expect(response.body.ocs.data[0].parent!.chatMessage!.id, isPositive);
          expect(response.body.ocs.data[0].parent!.chatMessage!.actorType, spreed.ActorTypes.users);
          expect(response.body.ocs.data[0].parent!.chatMessage!.actorId, 'user1');
          expect(response.body.ocs.data[0].parent!.chatMessage!.actorDisplayName, 'User One');
          expect(
            response.body.ocs.data[0].parent!.chatMessage!.timestamp,
            closeTo(startTime.secondsSinceEpoch, 10),
          );
          expect(response.body.ocs.data[0].parent!.chatMessage!.message, 'bla');
          expect(response.body.ocs.data[0].parent!.chatMessage!.messageType, spreed.MessageType.comment);

          expect(response.body.ocs.data[1].id, isPositive);
          expect(response.body.ocs.data[1].actorType, spreed.ActorTypes.users);
          expect(response.body.ocs.data[1].actorId, 'user1');
          expect(response.body.ocs.data[1].actorDisplayName, 'User One');
          expect(response.body.ocs.data[1].timestamp, closeTo(startTime.secondsSinceEpoch, 10));
          expect(response.body.ocs.data[1].message, 'bla');
          expect(response.body.ocs.data[1].messageType, spreed.MessageType.comment);

          expect(response.body.ocs.data[2].id, isPositive);
          expect(response.body.ocs.data[2].actorType, spreed.ActorTypes.users);
          expect(response.body.ocs.data[2].actorId, 'user1');
          expect(response.body.ocs.data[2].actorDisplayName, 'User One');
          expect(response.body.ocs.data[2].timestamp, closeTo(startTime.secondsSinceEpoch, 10));
          expect(response.body.ocs.data[2].message, 'You created the conversation');
          expect(response.body.ocs.data[2].systemMessage, 'conversation_created');
          expect(response.body.ocs.data[2].messageType, spreed.MessageType.system);
        });

        test('Polling', () async {
          final startTime = DateTime.timestamp();

          final room = await createTestRoom();
          final message = (await tester.client.spreed.chat.sendMessage(
            token: room.token,
            $body: spreed.ChatSendMessageRequestApplicationJson(
              (b) => b..message = 'bla',
            ),
          ))
              .body
              .ocs
              .data!;
          unawaited(
            Future<void>.delayed(const Duration(seconds: 1)).then((_) async {
              await tester.client.spreed.chat.sendMessage(
                token: room.token,
                $body: spreed.ChatSendMessageRequestApplicationJson(
                  (b) => b..message = '123',
                ),
              );
            }),
          );

          final response = await tester.client.spreed.chat.receiveMessages(
            token: room.token,
            lookIntoFuture: spreed.ChatReceiveMessagesLookIntoFuture.$1,
            timeout: 3,
            lastKnownMessageId: message.id,
          );
          expect(response.body.ocs.data, hasLength(1));
          expect(response.body.ocs.data[0].id, isPositive);
          expect(response.body.ocs.data[0].actorType, spreed.ActorTypes.users);
          expect(response.body.ocs.data[0].actorId, 'user1');
          expect(response.body.ocs.data[0].actorDisplayName, 'User One');
          expect(response.body.ocs.data[0].timestamp, closeTo(startTime.secondsSinceEpoch, 10));
          expect(response.body.ocs.data[0].message, '123');
          expect(response.body.ocs.data[0].messageType, spreed.MessageType.comment);
        });
      });

      test('Mention suggestions', () async {
        final room = await createTestRoom();

        await tester.client.spreed.room.addParticipantToRoom(
          token: room.token,
          $body: spreed.RoomAddParticipantToRoomRequestApplicationJson(
            (b) => b..newParticipant = 'user2',
          ),
        );

        final response = await tester.client.spreed.chat.mentions(
          token: room.token,
          search: 'user',
        );
        expect(response.body.ocs.data, hasLength(1));
        expect(response.body.ocs.data[0].id, 'user2');
        expect(response.body.ocs.data[0].label, 'User Two');
        expect(response.body.ocs.data[0].source, 'users');
        expect(response.body.ocs.data[0].mentionId, tester.version < Version(19, 0, 0) ? null : 'user2');
        expect(response.body.ocs.data[0].status, null);
        expect(response.body.ocs.data[0].statusClearAt, null);
        expect(response.body.ocs.data[0].statusIcon, null);
        expect(response.body.ocs.data[0].statusMessage, null);
      });

      test('Delete message', () async {
        final room = await createTestRoom();

        final messageResponse = await tester.client.spreed.chat.sendMessage(
          token: room.token,
          $body: spreed.ChatSendMessageRequestApplicationJson(
            (b) => b..message = 'bla',
          ),
        );

        final response = await tester.client.spreed.chat.deleteMessage(
          token: room.token,
          messageId: messageResponse.body.ocs.data!.id,
        );
        expect(response.body.ocs.data.id, isPositive);
        expect(response.body.ocs.data.actorType, spreed.ActorTypes.users);
        expect(response.body.ocs.data.actorId, 'user1');
        expect(response.body.ocs.data.actorDisplayName, 'User One');
        expect(response.body.ocs.data.message, 'You deleted a message');
        expect(response.body.ocs.data.messageType, spreed.MessageType.system);
        expect(response.body.ocs.data.systemMessage, 'message_deleted');
        expect(response.body.ocs.data.parent!.chatMessage!.id, isPositive);
        expect(response.body.ocs.data.parent!.chatMessage!.actorType, spreed.ActorTypes.users);
        expect(response.body.ocs.data.parent!.chatMessage!.actorId, 'user1');
        expect(response.body.ocs.data.parent!.chatMessage!.actorDisplayName, 'User One');
        expect(response.body.ocs.data.parent!.chatMessage!.message, 'Message deleted by you');
        expect(response.body.ocs.data.parent!.chatMessage!.messageType, spreed.MessageType.commentDeleted);
        expect(response.body.ocs.data.parent!.chatMessage!.systemMessage, '');
      });

      test('Clear history', () async {
        final room = await createTestRoom();

        final clearHistoryResponse = await tester.client.spreed.chat.clearHistory(
          token: room.token,
        );
        expect(clearHistoryResponse.body.ocs.data.id, isPositive);
        expect(clearHistoryResponse.body.ocs.data.actorType, spreed.ActorTypes.users);
        expect(clearHistoryResponse.body.ocs.data.actorId, 'user1');
        expect(clearHistoryResponse.body.ocs.data.actorDisplayName, 'User One');
        expect(clearHistoryResponse.body.ocs.data.message, 'You cleared the history of the conversation');
        expect(clearHistoryResponse.body.ocs.data.messageType, spreed.MessageType.system);
        expect(clearHistoryResponse.body.ocs.data.systemMessage, 'history_cleared');

        final receiveMessagesResponse = await tester.client.spreed.chat.receiveMessages(
          token: room.token,
          lookIntoFuture: spreed.ChatReceiveMessagesLookIntoFuture.$0,
        );
        expect(receiveMessagesResponse.body.ocs.data, hasLength(1));
        expect(receiveMessagesResponse.body.ocs.data[0].id, isPositive);
        expect(receiveMessagesResponse.body.ocs.data[0].actorType, spreed.ActorTypes.users);
        expect(receiveMessagesResponse.body.ocs.data[0].actorId, 'user1');
        expect(receiveMessagesResponse.body.ocs.data[0].actorDisplayName, 'User One');
        expect(receiveMessagesResponse.body.ocs.data[0].message, 'You cleared the history of the conversation');
        expect(receiveMessagesResponse.body.ocs.data[0].messageType, spreed.MessageType.system);
        expect(receiveMessagesResponse.body.ocs.data[0].systemMessage, 'history_cleared');
      });
    });

    group('Call', () {
      test('Start and end call', () async {
        var room = await createTestRoom();
        expect(room.hasCall, isFalse);
        room = (await tester.client.spreed.room.joinRoom(token: room.token)).body.ocs.data;

        await tester.client.spreed.call.joinCall(token: room.token);
        room = (await tester.client.spreed.room.getSingleRoom(token: room.token)).body.ocs.data;
        expect(room.hasCall, isTrue);

        await tester.client.spreed.call.leaveCall(token: room.token);
        room = (await tester.client.spreed.room.getSingleRoom(token: room.token)).body.ocs.data;
        expect(room.hasCall, isFalse);
      });
    });

    group('Signaling', () {
      test('Get settings', () async {
        final room = await createTestRoom();

        final response = await tester.client.spreed.internalSignaling.signalingGetSettings(
          token: room.token,
        );
        expect(response.body.ocs.data.signalingMode, 'internal');
        expect(response.body.ocs.data.userId, 'user1');
        expect(response.body.ocs.data.hideWarning, false);
        expect(response.body.ocs.data.server, '');
        expect(response.body.ocs.data.ticket, contains(':user1:'));
        expect(response.body.ocs.data.helloAuthParams.$10.userid, 'user1');
        expect(response.body.ocs.data.helloAuthParams.$10.ticket, contains(':user1:'));
        expect(
          response.body.ocs.data.helloAuthParams.$20.token.split('').where((x) => x == '.'),
          hasLength(2),
        );
        expect(response.body.ocs.data.stunservers, hasLength(1));
        expect(response.body.ocs.data.stunservers[0].urls, hasLength(1));
        expect(response.body.ocs.data.stunservers[0].urls[0], 'stun:stun.nextcloud.com:443');
        expect(response.body.ocs.data.turnservers, hasLength(1));
        expect(response.body.ocs.data.turnservers[0].urls, hasLength(4));
        expect(
          response.body.ocs.data.turnservers[0].urls[0],
          'turn:staticauth.openrelay.metered.ca:443?transport=udp',
        );
        expect(
          response.body.ocs.data.turnservers[0].urls[1],
          'turn:staticauth.openrelay.metered.ca:443?transport=tcp',
        );
        expect(
          response.body.ocs.data.turnservers[0].urls[2],
          'turns:staticauth.openrelay.metered.ca:443?transport=udp',
        );
        expect(
          response.body.ocs.data.turnservers[0].urls[3],
          'turns:staticauth.openrelay.metered.ca:443?transport=tcp',
        );
        expect(response.body.ocs.data.turnservers[0].username, isNotEmpty);
        expect((response.body.ocs.data.turnservers[0].credential as StringJsonObject).asString, isNotEmpty);
        expect(response.body.ocs.data.sipDialinInfo, '');
      });

      test('Send and receive messages', () async {
        final room = await createTestRoom();

        final room1 = (await tester.client.spreed.room.joinRoom(token: room.token)).body.ocs.data;
        await tester.client.spreed.call.joinCall(token: room.token);

        final client2 = await tester.createClient(
          username: 'user2',
        );

        final room2 = (await client2.spreed.room.joinRoom(token: room.token)).body.ocs.data;
        await client2.spreed.call.joinCall(token: room.token);

        await tester.client.spreed.internalSignaling.signalingSendMessages(
          token: room.token,
          $body: spreed.SignalingSendMessagesRequestApplicationJson(
            (b) => b
              ..messages = json.encode([
                {
                  'ev': 'message',
                  'sessionId': room1.sessionId,
                  'fn': json.encode({
                    'to': room2.sessionId,
                  }),
                },
              ]),
          ),
        );

        await Future<void>.delayed(const Duration(seconds: 1));

        final messages =
            (await client2.spreed.internalSignaling.signalingPullMessages(token: room.token)).body.ocs.data;
        expect(messages, hasLength(2));
        expect(messages[0].type, 'message');
        expect(json.decode(messages[0].data.string!), {'to': room2.sessionId, 'from': room1.sessionId});
        expect(messages[1].type, 'usersInRoom');
        expect(messages[1].data.builtListSignalingSession, hasLength(2));
        expect(messages[1].data.builtListSignalingSession![0].userId, 'user1');
        expect(messages[1].data.builtListSignalingSession![1].userId, 'user2');
      });
    });

    group('Reaction', () {
      test('Add and remove', () async {
        final room = await createTestRoom();

        final sendMessageResponse = await tester.client.spreed.chat.sendMessage(
          token: room.token,
          $body: spreed.ChatSendMessageRequestApplicationJson(
            (b) => b..message = 'bla',
          ),
        );
        expect(sendMessageResponse.body.ocs.data!.reactions, isEmpty);
        expect(sendMessageResponse.body.ocs.data!.reactionsSelf, isNull);

        var receiveMessagesResponse = await tester.client.spreed.chat.receiveMessages(
          token: room.token,
          lookIntoFuture: spreed.ChatReceiveMessagesLookIntoFuture.$0,
        );
        var message = receiveMessagesResponse.body.ocs.data[0];
        expect(message.message, 'bla');
        expect(message.reactions, isEmpty);
        expect(message.reactionsSelf, isNull);

        final addResponse = await tester.client.spreed.reaction.react(
          token: room.token,
          messageId: message.id,
          $body: spreed.ReactionReactRequestApplicationJson(
            (b) => b..reaction = '😀',
          ),
        );
        expect(addResponse.body.ocs.data, hasLength(1));
        expect(addResponse.body.ocs.data['😀'], isNotNull);

        receiveMessagesResponse = await tester.client.spreed.chat.receiveMessages(
          token: room.token,
          lookIntoFuture: spreed.ChatReceiveMessagesLookIntoFuture.$0,
        );
        message = receiveMessagesResponse.body.ocs.data[1];
        expect(message.message, 'bla');
        expect(message.reactions, hasLength(1));
        expect(message.reactions['😀'], isNotNull);
        expect(message.reactionsSelf, hasLength(1));
        expect(message.reactionsSelf, contains('😀'));

        final removeResponse = await tester.client.spreed.reaction.delete(
          token: room.token,
          messageId: message.id,
          reaction: '😀',
        );
        expect(removeResponse.body.ocs.data, isEmpty);

        receiveMessagesResponse = await tester.client.spreed.chat.receiveMessages(
          token: room.token,
          lookIntoFuture: spreed.ChatReceiveMessagesLookIntoFuture.$0,
        );
        message = receiveMessagesResponse.body.ocs.data[2];
        expect(message.message, 'bla');
        expect(message.reactions, isEmpty);
        expect(message.reactionsSelf, isNull);
      });

      test('Get', () async {
        final room = await createTestRoom();

        final sendMessageResponse = await tester.client.spreed.chat.sendMessage(
          token: room.token,
          $body: spreed.ChatSendMessageRequestApplicationJson(
            (b) => b..message = 'bla',
          ),
        );

        final addResponse = await tester.client.spreed.reaction.react(
          token: room.token,
          messageId: sendMessageResponse.body.ocs.data!.id,
          $body: spreed.ReactionReactRequestApplicationJson(
            (b) => b..reaction = '😀',
          ),
        );
        expect(addResponse.body.ocs.data, hasLength(1));
        expect(addResponse.body.ocs.data['😀'], isNotNull);

        final getResponse = await tester.client.spreed.reaction.getReactions(
          token: room.token,
          messageId: sendMessageResponse.body.ocs.data!.id,
        );
        expect(getResponse.body.ocs.data, hasLength(1));
        expect(getResponse.body.ocs.data['😀'], isNotNull);
      });
    });
  });
}
