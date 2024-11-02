import 'dart:async';
import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_framework/testing.dart';
import 'package:neon_framework/theme.dart';
import 'package:neon_framework/utils.dart';
import 'package:neon_framework/widgets.dart';
import 'package:nextcloud/spreed.dart' as spreed;
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:talk_app/l10n/localizations.dart';
import 'package:talk_app/src/blocs/room.dart';
import 'package:talk_app/src/widgets/message.dart';
import 'package:talk_app/src/widgets/message_input.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'testing.dart';

Account mockTalkAccount() {
  return mockServer({
    RegExp(r'/ocs/v2\.php/apps/spreed/api/v1/chat/.*/mentions'): {
      'get': (match, request) async {
        await Future<void>.delayed(const Duration(seconds: 1));

        return Response(
          json.encode({
            'ocs': {
              'meta': {'status': '', 'statuscode': 0},
              'data': [
                {
                  'id': 'id1',
                  'label': 'label1',
                  'source': 'groups',
                },
                {
                  'id': 'id2',
                  'label': 'label2',
                  'source': 'users',
                  'status': 'online',
                },
              ],
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      },
    },
    RegExp(r'/index\.php/avatar/.*'): {
      'get': (match, request) => Response('', 404),
    },
  });
}

void main() {
  late Account account;
  late TalkRoomBloc bloc;
  late spreed.Room room;
  late BehaviorSubject<spreed.$ChatMessageInterface?> replyTo;
  late BehaviorSubject<spreed.$ChatMessageInterface?> editing;
  late ReferencesBloc referencesBloc;

  setUpAll(() {
    KeyboardVisibilityTesting.setVisibilityForTesting(true);

    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Berlin'));
  });

  setUp(() {
    FakeNeonStorage.setup();

    account = mockTalkAccount();

    replyTo = BehaviorSubject.seeded(null);
    editing = BehaviorSubject.seeded(null);

    bloc = MockRoomBloc();
    when(() => bloc.room).thenAnswer((_) => BehaviorSubject.seeded(Result.success(room)));
    when(() => bloc.replyTo).thenAnswer((_) => replyTo);
    when(() => bloc.editing).thenAnswer((_) => editing);

    room = MockRoom();
    when(() => room.token).thenReturn('token');

    referencesBloc = MockReferencesBloc();
    when(() => referencesBloc.referenceRegex).thenAnswer((_) => BehaviorSubject.seeded(Result.success(null)));
    when(() => referencesBloc.references).thenAnswer((_) => BehaviorSubject.seeded(BuiltMap()));
  });

  tearDown(() {
    unawaited(replyTo.close());
    unawaited(editing.close());
  });

  testWidgets('Cupertino no emoji button', (tester) async {
    await tester.pumpWidgetWithAccessibility(
      TestApp(
        localizationsDelegates: TalkLocalizations.localizationsDelegates,
        supportedLocales: TalkLocalizations.supportedLocales,
        providers: [
          NeonProvider<TalkRoomBloc>.value(value: bloc),
        ],
        platform: TargetPlatform.iOS,
        child: Material(
          child: TalkMessageInput(
            room: room,
          ),
        ),
      ),
    );

    expect(find.byType(TextFormField), findsOne);
    expect(find.byIcon(Icons.emoji_emotions_outlined), findsNothing);
    await expectLater(find.byType(TestApp), matchesGoldenFile('goldens/message_input_no_emoji_button.png'));
  });

  testWidgets('Emoji button', (tester) async {
    await tester.pumpWidgetWithAccessibility(
      TestApp(
        localizationsDelegates: TalkLocalizations.localizationsDelegates,
        supportedLocales: TalkLocalizations.supportedLocales,
        providers: [
          NeonProvider<TalkRoomBloc>.value(value: bloc),
        ],
        child: TalkMessageInput(
          room: room,
        ),
      ),
    );

    expect(find.byType(TextFormField), findsOne);
    expect(find.byIcon(Icons.emoji_emotions_outlined), findsOne);

    await tester.enterText(find.byType(TextField), '123456');
    for (var i = 0; i < 3; i++) {
      await simulateKeyDownEvent(LogicalKeyboardKey.arrowLeft);
      await simulateKeyUpEvent(LogicalKeyboardKey.arrowLeft);
    }

    await tester.runAsync(() async {
      await tester.tap(find.byIcon(Icons.emoji_emotions_outlined));
    });
    await tester.pumpAndSettle();
    await tester.tap(find.text('😀'));
    await tester.pumpAndSettle();

    await expectLater(find.byType(TextField), matchesGoldenFile('goldens/message_input_emoji.png'));

    await tester.testTextInput.receiveAction(TextInputAction.send);
    verify(() => bloc.sendMessage('123😀456')).called(1);
  });

  testWidgets('Mention suggestions', (tester) async {
    await tester.pumpWidgetWithAccessibility(
      TestApp(
        localizationsDelegates: TalkLocalizations.localizationsDelegates,
        supportedLocales: TalkLocalizations.supportedLocales,
        providers: [
          NeonProvider<TalkRoomBloc>.value(value: bloc),
          Provider<Account>.value(value: account),
        ],
        child: Align(
          alignment: Alignment.bottomCenter,
          child: TalkMessageInput(
            room: room,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '123 @gr');
    await tester.pumpAndSettle();

    expect(find.byType(ListTile), findsExactly(2));
    expect(find.byIcon(AdaptiveIcons.group), findsOne);
    expect(find.text('label1'), findsOne);
    expect(find.text('id1'), findsOne);
    expect(find.byType(NeonUserAvatar), findsOne);
    expect(find.text('label2'), findsOne);
    expect(find.text('id2'), findsOne);

    await expectLater(find.byType(TestApp), matchesGoldenFile('goldens/message_input_mention_suggestions.png'));

    await tester.tap(find.byType(ListTile).first);
    await tester.testTextInput.receiveAction(TextInputAction.send);
    verify(() => bloc.sendMessage('123 @"id1" ')).called(1);
  });

  testWidgets('Multiline', (tester) async {
    await tester.pumpWidgetWithAccessibility(
      TestApp(
        localizationsDelegates: TalkLocalizations.localizationsDelegates,
        supportedLocales: TalkLocalizations.supportedLocales,
        providers: [
          NeonProvider<TalkRoomBloc>.value(value: bloc),
          Provider<Account>.value(value: account),
        ],
        child: Align(
          alignment: Alignment.bottomCenter,
          child: TalkMessageInput(
            room: room,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '123456');

    for (var i = 0; i < 3; i++) {
      await simulateKeyDownEvent(LogicalKeyboardKey.arrowLeft);
      await simulateKeyUpEvent(LogicalKeyboardKey.arrowLeft);
    }

    await simulateKeyDownEvent(LogicalKeyboardKey.shift);
    await simulateKeyDownEvent(LogicalKeyboardKey.enter);
    await simulateKeyUpEvent(LogicalKeyboardKey.shift);
    await simulateKeyUpEvent(LogicalKeyboardKey.enter);

    await tester.pumpAndSettle();

    await expectLater(find.byType(TestApp), matchesGoldenFile('goldens/message_input_multiline.png'));

    await simulateKeyDownEvent(LogicalKeyboardKey.enter);
    await simulateKeyUpEvent(LogicalKeyboardKey.enter);

    verify(() => bloc.sendMessage('123\n456')).called(1);
  });

  testWidgets('Reply', (tester) async {
    await tester.pumpWidgetWithAccessibility(
      TestApp(
        localizationsDelegates: TalkLocalizations.localizationsDelegates,
        supportedLocales: TalkLocalizations.supportedLocales,
        providers: [
          NeonProvider<TalkRoomBloc>.value(value: bloc),
          NeonProvider<ReferencesBloc>.value(value: referencesBloc),
          Provider<Account>.value(value: account),
        ],
        child: TalkMessageInput(
          room: room,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TalkParentMessage), findsNothing);

    final chatMessage = MockChatMessage();
    when(() => chatMessage.messageType).thenReturn(spreed.MessageType.comment);
    when(() => chatMessage.timestamp).thenReturn(0);
    when(() => chatMessage.actorId).thenReturn('test');
    when(() => chatMessage.actorDisplayName).thenReturn('test');
    when(() => chatMessage.message).thenReturn('message');
    when(() => chatMessage.messageParameters).thenReturn(BuiltMap());
    when(() => chatMessage.markdown).thenReturn(false);

    replyTo.add(chatMessage);
    await tester.pumpAndSettle();
    expect(find.byType(TalkParentMessage), findsOne);
    await expectLater(find.byType(TestApp), matchesGoldenFile('goldens/message_input_reply.png'));

    await tester.tap(find.byIcon(Icons.close));
    verify(() => bloc.removeReplyChatMessage()).called(1);
  });

  testWidgets('Edit', (tester) async {
    await tester.pumpWidgetWithAccessibility(
      TestApp(
        localizationsDelegates: TalkLocalizations.localizationsDelegates,
        supportedLocales: TalkLocalizations.supportedLocales,
        providers: [
          NeonProvider<TalkRoomBloc>.value(value: bloc),
          NeonProvider<ReferencesBloc>.value(value: referencesBloc),
          Provider<Account>.value(value: account),
        ],
        child: TalkMessageInput(
          room: room,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TalkParentMessage), findsNothing);

    final chatMessage = MockChatMessage();
    when(() => chatMessage.messageType).thenReturn(spreed.MessageType.comment);
    when(() => chatMessage.timestamp).thenReturn(0);
    when(() => chatMessage.actorId).thenReturn('test');
    when(() => chatMessage.actorDisplayName).thenReturn('test');
    when(() => chatMessage.message).thenReturn('message');
    when(() => chatMessage.messageParameters).thenReturn(BuiltMap());
    when(() => chatMessage.markdown).thenReturn(false);

    editing.add(chatMessage);
    await tester.pumpAndSettle();
    expect(find.byType(TalkParentMessage), findsOne);
    expect(find.text('message'), findsExactly(2));
    await expectLater(find.byType(TestApp), matchesGoldenFile('goldens/message_input_edit.png'));

    await tester.tap(find.byIcon(Icons.close));
    verify(() => bloc.removeEditChatMessage()).called(1);
    expect(find.text('message'), findsOne);
  });
}
