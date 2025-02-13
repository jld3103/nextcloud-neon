import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_framework/testing.dart';
import 'package:nextcloud/spreed.dart' as spreed;
import 'package:talk_app/src/blocs/room.dart';
import 'package:talk_app/src/blocs/talk.dart';

import 'testing.dart';

Account mockTalkAccount() {
  var messageCount = 3;

  return mockServer({
    RegExp(r'/ocs/v2\.php/apps/spreed/api/v4/room/abcd/participants/active'): {
      'post': (match, request) => Response(
            json.encode({
              'ocs': {
                'meta': {'status': '', 'statuscode': 0},
                'data': getRoom(
                  token: 'abcd',
                ),
              },
            }),
            200,
            headers: {'content-type': 'application/json'},
          ),
      'delete': (match, request) => Response(
            json.encode({
              'ocs': {
                'meta': {'status': '', 'statuscode': 0},
                'data': <dynamic>[],
              },
            }),
            200,
            headers: {'content-type': 'application/json'},
          ),
    },
    RegExp(r'/ocs/v2\.php/apps/spreed/api/v1/chat/abcd/([0-9]+)'): {
      'delete': (match, request) {
        final id = int.parse(match.group(1)!);

        return Response(
          json.encode({
            'ocs': {
              'meta': {'status': '', 'statuscode': 0},
              'data': getChatMessage(
                id: messageCount++,
                systemMessage: 'message_deleted',
                messageType: spreed.MessageType.system,
                parent: getChatMessage(
                  id: id,
                  messageType: spreed.MessageType.commentDeleted,
                ),
              ),
            },
          }),
          200,
          headers: {
            'content-type': 'application/json',
          },
        );
      },
      'put': (match, request) {
        final id = int.parse(match.group(1)!);
        final data = json.decode(request.body) as Map<String, dynamic>;
        final message = data['message'] as String;

        return Response(
          json.encode({
            'ocs': {
              'meta': {'status': '', 'statuscode': 0},
              'data': getChatMessage(
                id: messageCount++,
                systemMessage: 'message_edited',
                messageType: spreed.MessageType.system,
                parent: getChatMessage(
                  id: id,
                  message: message,
                ),
              ),
            },
          }),
          200,
          headers: {
            'content-type': 'application/json',
          },
        );
      },
    },
    RegExp(r'/ocs/v2\.php/apps/spreed/api/v1/chat/abcd'): {
      'get': (match, request) async {
        final lookIntoFuture = request.url.queryParameters['lookIntoFuture'] == '1';
        if (lookIntoFuture) {
          // Simulate a new message received after some time
          await Future<void>.delayed(const Duration(milliseconds: 1));
          return Response(
            json.encode({
              'ocs': {
                'meta': {'status': '', 'statuscode': 0},
                'data': [
                  getChatMessage(
                    id: messageCount++,
                    systemMessage: 'reaction',
                    parent: getChatMessage(
                      id: 2,
                      reactions: {
                        '😊': 1,
                      },
                    ),
                  ),
                  getChatMessage(
                    id: messageCount++,
                  ),
                  getChatMessage(
                    id: messageCount++,
                    systemMessage: 'message_edited',
                    parent: getChatMessage(
                      id: 2,
                      reactions: {
                        '😊': 1,
                      },
                      message: 'edit',
                    ),
                  ),
                ],
              },
            }),
            200,
            headers: {
              'content-type': 'application/json; charset=utf-8',
              'x-chat-last-common-read': '0',
            },
          );
        } else {
          return Response(
            json.encode({
              'ocs': {
                'meta': {'status': '', 'statuscode': 0},
                'data': List.generate(
                  messageCount,
                  (i) => getChatMessage(
                    id: messageCount - i - 1,
                    parent: messageCount - i - 2 >= 0
                        ? getChatMessage(
                            id: messageCount - i - 2,
                          )
                        : null,
                  ),
                ),
              },
            }),
            200,
            headers: {
              'content-type': 'application/json',
              'x-chat-last-common-read': '0',
            },
          );
        }
      },
      'post': (match, request) {
        final data = json.decode(request.body) as Map<String, dynamic>;
        final replyTo = data['replyTo'] as int?;

        return Response(
          json.encode({
            'ocs': {
              'meta': {'status': '', 'statuscode': 0},
              'data': getChatMessage(
                id: messageCount++,
                parent: replyTo != null
                    ? getChatMessage(
                        id: replyTo,
                      )
                    : null,
              ),
            },
          }),
          201,
          headers: {
            'content-type': 'application/json',
            'x-chat-last-common-read': '1',
          },
        );
      },
    },
    RegExp(r'/ocs/v2\.php/apps/spreed/api/v1/reaction/abcd/[0-9]+'): {
      'post': (match, request) {
        final data = json.decode(request.body) as Map<String, dynamic>;

        final reaction = data['reaction'] as String;

        return Response(
          json.encode({
            'ocs': {
              'meta': {'status': '', 'statuscode': 0},
              'data': {
                reaction: [
                  {
                    'actorDisplayName': '',
                    'actorId': 'test',
                    'actorType': 'users',
                    'timestamp': 0,
                  },
                  {
                    'actorDisplayName': '',
                    'actorId': 'other',
                    'actorType': 'users',
                    'timestamp': 0,
                  },
                ],
              },
            },
          }),
          200,
          headers: {
            'content-type': 'application/json; charset=utf-8',
          },
        );
      },
      'delete': (match, request) {
        final reaction = request.url.queryParameters['reaction']!;

        return Response(
          json.encode({
            'ocs': {
              'meta': {'status': '', 'statuscode': 0},
              'data': {
                reaction: [
                  {
                    'actorDisplayName': '',
                    'actorId': 'test',
                    'actorType': 'users',
                    'timestamp': 0,
                  },
                  {
                    'actorDisplayName': '',
                    'actorId': 'other',
                    'actorType': 'users',
                    'timestamp': 0,
                  },
                ],
              },
            },
          }),
          200,
          headers: {
            'content-type': 'application/json; charset=utf-8',
          },
        );
      },
      'get': (match, request) => Response(
            json.encode({
              'ocs': {
                'meta': {'status': '', 'statuscode': 0},
                'data': {
                  '😀': [
                    {
                      'actorDisplayName': '',
                      'actorId': 'test',
                      'actorType': 'users',
                      'timestamp': 0,
                    },
                    {
                      'actorDisplayName': '',
                      'actorId': 'other',
                      'actorType': 'users',
                      'timestamp': 0,
                    },
                  ],
                },
              },
            }),
            200,
            headers: {
              'content-type': 'application/json; charset=utf-8',
            },
          ),
    },
  });
}

void main() {
  late Account account;
  late TalkBloc talkBloc;
  late TalkRoomBloc roomBloc;

  setUpAll(() {
    registerFallbackValue(MockRoom());
  });

  setUp(() {
    FakeNeonStorage.setup();
  });

  setUp(() {
    final room = MockRoom();
    when(() => room.token).thenReturn('abcd');
    when(() => room.lastMessage).thenReturn((baseMessage: null, builtListNever: null, chatMessage: null));

    account = mockTalkAccount();
    talkBloc = MockTalkBloc();
    roomBloc = TalkRoomBloc(
      talkBloc: talkBloc,
      account: account,
      room: room,
    );
  });

  tearDown(() async {
    // Wait for all events to be processed
    await Future<void>.delayed(const Duration(milliseconds: 1));
    roomBloc.dispose();
  });

  test('refresh', () async {
    expect(
      roomBloc.room.transformResult((e) => e.token),
      emitsInOrder([
        Result.success('abcd').asLoading(),
        Result.success('abcd'),
        Result.success('abcd'),
        Result.success('abcd').asLoading(),
        Result.success('abcd'),
        Result.success('abcd'),
      ]),
    );

    expect(
      roomBloc.messages.transformResult((e) => BuiltList<int>(e.map((m) => m.id))),
      emitsInOrder([
        Result<BuiltList<int>>.loading(),
        Result.success(BuiltList<int>([2, 1, 0])),
        Result.success(BuiltList<int>([2, 1, 0])).asLoading(),
        Result.success(BuiltList<int>([2, 1, 0])),
      ]),
    );

    expect(
      roomBloc.lastCommonRead,
      emitsInOrder([0, 0]),
    );

    // The delay is necessary to avoid a race condition with loading twice at the same time
    await Future<void>.delayed(const Duration(milliseconds: 1));
    await roomBloc.refresh();

    verify(() => talkBloc.updateRoom(any())).called(4);
  });

  test('sendMessage', () async {
    expect(
      roomBloc.messages.transformResult((e) => BuiltList<int>(e.map((m) => m.id))),
      emitsInOrder([
        Result<BuiltList<int>>.loading(),
        Result.success(BuiltList<int>([2, 1, 0])),
        Result.success(BuiltList<int>([3, 2, 1, 0])),
      ]),
    );
    expect(
      roomBloc.room.transformResult((e) => e.lastMessage?.chatMessage?.id),
      emitsInOrder([
        Result<int>.loading(),
        Result.success(null),
        Result.success(2),
        Result.success(3),
      ]),
    );

    expect(
      roomBloc.lastCommonRead,
      emitsInOrder([0, 1]),
    );

    // The delay is necessary to avoid a race condition with loading twice at the same time
    await Future<void>.delayed(const Duration(milliseconds: 1));
    roomBloc.sendMessage('');

    verify(() => talkBloc.updateRoom(any())).called(3);
  });

  test('Reply', () async {
    final message = MockChatMessage();
    when(() => message.id).thenReturn(1);

    expect(
      roomBloc.messages.transformResult((e) => BuiltList<int?>(e.map((m) => m.parent?.chatMessage?.id))),
      emitsInOrder([
        Result<BuiltList<int?>>.loading(),
        Result.success(BuiltList<int?>([1, 0, null])),
        Result.success(BuiltList<int?>([1, 1, 0, null])),
      ]),
    );

    expect(
      roomBloc.replyTo,
      emitsInOrder([
        null,
        message,
        null,
        message,
        null,
      ]),
    );
    expect(
      roomBloc.editing,
      emitsInOrder([
        null,
        null,
        null,
      ]),
    );

    // The delay is necessary to avoid a race condition with loading twice at the same time
    await Future<void>.delayed(const Duration(milliseconds: 1));

    roomBloc
      ..setReplyChatMessage(message)
      ..removeReplyChatMessage()
      ..setReplyChatMessage(message)
      ..sendMessage('');
  });

  test('Edit', () async {
    final message = MockChatMessage();
    when(() => message.id).thenReturn(1);

    expect(
      roomBloc.messages.transformResult((e) => BuiltList<String>(e.map((m) => m.message))),
      emitsInOrder([
        Result<BuiltList<String>>.loading(),
        Result.success(BuiltList<String>(['', '', ''])),
        Result.success(BuiltList<String>(['', 'test', ''])),
      ]),
    );

    expect(
      roomBloc.editing,
      emitsInOrder([
        null,
        message,
        null,
        message,
        null,
      ]),
    );
    expect(
      roomBloc.replyTo,
      emitsInOrder([
        null,
        null,
        null,
      ]),
    );

    // The delay is necessary to avoid a race condition with loading twice at the same time
    await Future<void>.delayed(const Duration(milliseconds: 1));

    roomBloc
      ..setEditChatMessage(message)
      ..removeEditChatMessage()
      ..setEditChatMessage(message)
      ..sendMessage('test');
  });

  test('addReaction', () async {
    expect(
      roomBloc.messages.transformResult((e) => BuiltList<BuiltMap<String, int>>(e.map((m) => m.reactions))),
      emitsInOrder([
        Result<BuiltList<BuiltMap<String, int>>>.loading(),
        Result.success(
          BuiltList<BuiltMap<String, int>>([
            BuiltMap<String, int>(),
            BuiltMap<String, int>(),
            BuiltMap<String, int>(),
          ]),
        ),
        Result.success(
          BuiltList<BuiltMap<String, int>>([
            BuiltMap<String, int>(),
            BuiltMap<String, int>(),
            BuiltMap<String, int>({'😀': 2}),
          ]),
        ),
      ]),
    );
    expect(
      roomBloc.messages.transformResult((e) => BuiltList<BuiltList<String>?>(e.map((m) => m.reactionsSelf))),
      emitsInOrder([
        Result<BuiltList<BuiltList<String>?>>.loading(),
        Result.success(
          BuiltList<BuiltList<String>?>([
            null,
            null,
            null,
          ]),
        ),
        Result.success(
          BuiltList<BuiltList<String>?>([
            null,
            null,
            BuiltList<String>(['😀']),
          ]),
        ),
      ]),
    );
    expect(
      roomBloc.reactions.map((a) => a.map((k, v) => MapEntry(k, v.map((k, v) => MapEntry(k, v.length))))),
      emitsInOrder(<BuiltMap<int, BuiltMap<String, int>>>[
        BuiltMap(),
        BuiltMap({
          0: BuiltMap<String, int>({
            '😀': 2,
          }),
        }),
      ]),
    );

    // Wait for all events to be processed
    await Future<void>.delayed(const Duration(milliseconds: 1));

    final message = MockChatMessage();
    when(() => message.id).thenReturn(0);

    roomBloc.addReaction(message, '😀');
  });

  test('removeReaction', () async {
    expect(
      roomBloc.messages.transformResult((e) => BuiltList<BuiltMap<String, int>>(e.map((m) => m.reactions))),
      emitsInOrder([
        Result<BuiltList<BuiltMap<String, int>>>.loading(),
        Result.success(
          BuiltList<BuiltMap<String, int>>([
            BuiltMap<String, int>(),
            BuiltMap<String, int>(),
            BuiltMap<String, int>(),
          ]),
        ),
        Result.success(
          BuiltList<BuiltMap<String, int>>([
            BuiltMap<String, int>({'😀': 2}),
            BuiltMap<String, int>(),
            BuiltMap<String, int>(),
          ]),
        ),
      ]),
    );
    expect(
      roomBloc.messages.transformResult((e) => BuiltList<BuiltList<String>?>(e.map((m) => m.reactionsSelf))),
      emitsInOrder([
        Result<BuiltList<BuiltList<String>?>>.loading(),
        Result.success(
          BuiltList<BuiltList<String>?>([
            null,
            null,
            null,
          ]),
        ),
        Result.success(
          BuiltList<BuiltList<String>?>([
            BuiltList<String>(['😀']),
            null,
            null,
          ]),
        ),
      ]),
    );
    expect(
      roomBloc.reactions.map((a) => a.map((k, v) => MapEntry(k, v.map((k, v) => MapEntry(k, v.length))))),
      emitsInOrder(<BuiltMap<int, BuiltMap<String, int>>>[
        BuiltMap(),
        BuiltMap({
          2: BuiltMap<String, int>({
            '😀': 2,
          }),
        }),
      ]),
    );

    // Wait for all events to be processed
    await Future<void>.delayed(const Duration(milliseconds: 1));

    final message = MockChatMessage();
    when(() => message.id).thenReturn(2);

    roomBloc.removeReaction(message, '😀');
  });

  test('loadReactions', () async {
    expect(
      roomBloc.messages.transformResult((e) => BuiltList<BuiltMap<String, int>>(e.map((m) => m.reactions))),
      emitsInOrder([
        Result<BuiltList<BuiltMap<String, int>>>.loading(),
        Result.success(
          BuiltList<BuiltMap<String, int>>([
            BuiltMap<String, int>(),
            BuiltMap<String, int>(),
            BuiltMap<String, int>(),
          ]),
        ),
        Result.success(
          BuiltList<BuiltMap<String, int>>([
            BuiltMap<String, int>(),
            BuiltMap<String, int>({'😀': 2}),
            BuiltMap<String, int>(),
          ]),
        ),
      ]),
    );
    expect(
      roomBloc.messages.transformResult((e) => BuiltList<BuiltList<String>?>(e.map((m) => m.reactionsSelf))),
      emitsInOrder([
        Result<BuiltList<BuiltList<String>?>>.loading(),
        Result.success(
          BuiltList<BuiltList<String>?>([
            null,
            null,
            null,
          ]),
        ),
        Result.success(
          BuiltList<BuiltList<String>?>([
            null,
            BuiltList<String>(['😀']),
            null,
          ]),
        ),
      ]),
    );
    expect(
      roomBloc.reactions.map((a) => a.map((k, v) => MapEntry(k, v.map((k, v) => MapEntry(k, v.length))))),
      emitsInOrder(<BuiltMap<int, BuiltMap<String, int>>>[
        BuiltMap(),
        BuiltMap({
          1: BuiltMap<String, int>({
            '😀': 2,
          }),
        }),
      ]),
    );

    // Wait for all events to be processed
    await Future<void>.delayed(const Duration(milliseconds: 1));

    final message = MockChatMessage();
    when(() => message.id).thenReturn(1);

    roomBloc.loadReactions(message);
  });

  test('deleteMessage', () async {
    expect(
      roomBloc.messages.transformResult((e) => BuiltList<spreed.MessageType>(e.map((m) => m.messageType))),
      emitsInOrder([
        Result<BuiltList<spreed.MessageType>>.loading(),
        Result.success(
          BuiltList<spreed.MessageType>([
            spreed.MessageType.comment,
            spreed.MessageType.comment,
            spreed.MessageType.comment,
          ]),
        ),
        Result.success(
          BuiltList<spreed.MessageType>([
            spreed.MessageType.comment,
            spreed.MessageType.commentDeleted,
            spreed.MessageType.comment,
          ]),
        ),
      ]),
    );
    expect(
      roomBloc.messages
          .transformResult((e) => BuiltList<spreed.MessageType?>(e.map((m) => m.parent?.chatMessage!.messageType))),
      emitsInOrder([
        Result<BuiltList<spreed.MessageType?>>.loading(),
        Result.success(
          BuiltList<spreed.MessageType?>([
            spreed.MessageType.comment,
            spreed.MessageType.comment,
            null,
          ]),
        ),
        Result.success(
          BuiltList<spreed.MessageType?>([
            spreed.MessageType.commentDeleted,
            null,
            null,
          ]),
        ),
      ]),
    );

    final message = MockChatMessage();
    when(() => message.id).thenReturn(1);
    roomBloc.deleteMessage(message);
  });

  test('polling', () async {
    expect(
      roomBloc.messages.transformResult(
        (e) => BuiltList<(int, String, BuiltMap<String, int>)>(e.map((m) => (m.id, m.message, m.reactions))),
      ),
      emitsInOrder([
        Result<BuiltList<(int, String, BuiltMap<String, int>)>>.loading(),
        Result.success(
          BuiltList<(int, String, BuiltMap<String, int>)>([
            (2, '', BuiltMap<String, int>()),
            (1, '', BuiltMap<String, int>()),
            (0, '', BuiltMap<String, int>()),
          ]),
        ),
        Result.success(
          BuiltList<(int, String, BuiltMap<String, int>)>([
            (4, '', BuiltMap<String, int>()),
            (2, 'edit', BuiltMap<String, int>({'😊': 1})),
            (1, '', BuiltMap<String, int>()),
            (0, '', BuiltMap<String, int>()),
          ]),
        ),
      ]),
    );
    expect(
      roomBloc.room.transformResult((e) => e.lastMessage?.chatMessage?.id),
      emitsInOrder([
        Result<int>.loading(),
        Result.success(null),
        Result.success(2),
        Result.success(4),
      ]),
    );

    expect(
      roomBloc.lastCommonRead,
      emitsInOrder([0, 0]),
    );

    verify(() => talkBloc.updateRoom(any())).called(1);
  });
}
