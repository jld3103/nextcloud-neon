import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_framework/testing.dart';
import 'package:neon_framework/utils.dart';
import 'package:nextcloud/spreed.dart' as spreed;
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:talk_app/l10n/localizations.dart';
import 'package:talk_app/src/blocs/room.dart';
import 'package:talk_app/src/pages/room.dart';
import 'package:talk_app/src/theme.dart';
import 'package:talk_app/src/widgets/message.dart';
import 'package:talk_app/src/widgets/message_input.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'testing.dart';

void main() {
  late spreed.Room room;
  late TalkRoomBloc bloc;
  late ReferencesBloc referencesBloc;

  setUpAll(() {
    KeyboardVisibilityTesting.setVisibilityForTesting(true);

    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Berlin'));

    FakeNeonStorage.setup();
  });

  setUp(() {
    room = MockRoom();
    when(() => room.token).thenReturn('abcd');
    when(() => room.displayName).thenReturn('test');
    when(() => room.readOnly).thenReturn(0);
    when(() => room.isCustomAvatar).thenReturn(false);
    when(() => room.type).thenReturn(spreed.RoomType.group.value);
    when(() => room.actorId).thenReturn('');
    when(() => room.permissions).thenReturn(spreed.ParticipantPermission.canSendMessageAndShareAndReact.binary);

    bloc = MockRoomBloc();
    when(() => bloc.errors).thenAnswer((_) => StreamController<Object>().stream);
    when(() => bloc.room).thenAnswer((_) => BehaviorSubject.seeded(Result.success(room)));
    when(() => bloc.messages)
        .thenAnswer((_) => BehaviorSubject.seeded(Result.success(BuiltList<spreed.ChatMessageWithParent>())));
    when(() => bloc.lastCommonRead).thenAnswer((_) => BehaviorSubject.seeded(0));
    when(() => bloc.replyTo).thenAnswer((_) => BehaviorSubject.seeded(null));
    when(() => bloc.editing).thenAnswer((_) => BehaviorSubject.seeded(null));

    referencesBloc = MockReferencesBloc();
    when(() => referencesBloc.referenceRegex).thenAnswer((_) => BehaviorSubject.seeded(Result.success(null)));
    when(() => referencesBloc.references).thenAnswer((_) => BehaviorSubject.seeded(BuiltMap()));
  });

  testWidgets('Status message', (tester) async {
    when(() => room.statusMessage).thenReturn('status');

    await tester.pumpWidgetWithAccessibility(
      TestApp(
        localizationsDelegates: TalkLocalizations.localizationsDelegates,
        supportedLocales: TalkLocalizations.supportedLocales,
        appThemes: const [
          TalkTheme(),
        ],
        providers: [
          NeonProvider<TalkRoomBloc>.value(value: bloc),
        ],
        child: const TalkRoomPage(),
      ),
    );

    expect(find.text('status'), findsOne);
  });

  testWidgets('Errors', (tester) async {
    final controller = StreamController<Object>();
    when(() => bloc.errors).thenAnswer((_) => controller.stream);

    await tester.pumpWidgetWithAccessibility(
      TestApp(
        localizationsDelegates: TalkLocalizations.localizationsDelegates,
        supportedLocales: TalkLocalizations.supportedLocales,
        appThemes: const [
          TalkTheme(),
        ],
        providers: [
          NeonProvider<TalkRoomBloc>.value(value: bloc),
        ],
        child: const TalkRoomPage(),
      ),
    );

    controller.add(Exception());
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOne);
    await expectLater(find.byType(TestApp), matchesGoldenFile('goldens/room_page_error.png'));

    await controller.close();
  });

  testWidgets('Messages', (tester) async {
    final chatMessage1 = MockChatMessageWithParent();
    when(() => chatMessage1.id).thenReturn(1);
    when(() => chatMessage1.timestamp).thenReturn((1 * 24 - 1) * 60 * 60);
    when(() => chatMessage1.actorId).thenReturn('test');
    when(() => chatMessage1.actorType).thenReturn(spreed.ActorTypes.users);
    when(() => chatMessage1.actorDisplayName).thenReturn('test');
    when(() => chatMessage1.messageType).thenReturn(spreed.MessageType.comment);
    when(() => chatMessage1.message).thenReturn('abc');
    when(() => chatMessage1.reactions).thenReturn(BuiltMap());
    when(() => chatMessage1.messageParameters).thenReturn(BuiltMap());
    when(() => chatMessage1.systemMessage).thenReturn('');
    when(() => chatMessage1.isReplyable).thenReturn(true);

    final chatMessage2 = MockChatMessageWithParent();
    when(() => chatMessage2.id).thenReturn(2);
    when(() => chatMessage2.timestamp).thenReturn((2 * 24 - 1) * 60 * 60);
    when(() => chatMessage2.actorId).thenReturn('test');
    when(() => chatMessage2.actorType).thenReturn(spreed.ActorTypes.users);
    when(() => chatMessage2.actorDisplayName).thenReturn('test');
    when(() => chatMessage2.messageType).thenReturn(spreed.MessageType.comment);
    when(() => chatMessage2.message).thenReturn('abc');
    when(() => chatMessage2.reactions).thenReturn(BuiltMap());
    when(() => chatMessage2.messageParameters).thenReturn(BuiltMap());
    when(() => chatMessage2.systemMessage).thenReturn('');
    when(() => chatMessage2.isReplyable).thenReturn(true);

    final chatMessage3 = MockChatMessageWithParent();
    when(() => chatMessage3.id).thenReturn(3);
    when(() => chatMessage3.timestamp).thenReturn((3 * 24 - 1) * 60 * 60 - 1);
    when(() => chatMessage3.actorId).thenReturn('test');
    when(() => chatMessage3.actorType).thenReturn(spreed.ActorTypes.users);
    when(() => chatMessage3.actorDisplayName).thenReturn('test');
    when(() => chatMessage3.messageType).thenReturn(spreed.MessageType.comment);
    when(() => chatMessage3.message).thenReturn('abc');
    when(() => chatMessage3.reactions).thenReturn(BuiltMap());
    when(() => chatMessage3.messageParameters).thenReturn(BuiltMap());
    when(() => chatMessage3.systemMessage).thenReturn('');
    when(() => chatMessage3.isReplyable).thenReturn(true);

    when(() => bloc.messages).thenAnswer(
      (_) => BehaviorSubject.seeded(
        Result.success(
          BuiltList<spreed.ChatMessageWithParent>([
            chatMessage3,
            chatMessage2,
            chatMessage1,
          ]),
        ),
      ),
    );

    when(() => bloc.reactions).thenAnswer((_) => BehaviorSubject.seeded(BuiltMap()));

    final account = MockAccount();

    await tester.pumpWidgetWithAccessibility(
      TestApp(
        localizationsDelegates: TalkLocalizations.localizationsDelegates,
        supportedLocales: TalkLocalizations.supportedLocales,
        appThemes: const [
          TalkTheme(),
        ],
        providers: [
          Provider<Account>.value(value: account),
          NeonProvider<TalkRoomBloc>.value(value: bloc),
          NeonProvider<ReferencesBloc>.value(value: referencesBloc),
        ],
        child: const TalkRoomPage(),
      ),
    );

    expect(find.byType(TalkMessage), findsExactly(3));
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is TalkMessage && widget.chatMessage == chatMessage2 && widget.previousChatMessage == chatMessage1,
      ),
      findsOne,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is TalkMessage && widget.chatMessage == chatMessage3 && widget.previousChatMessage == chatMessage2,
      ),
      findsOne,
    );
    expect(find.byType(Divider), findsExactly(2));
    expect(find.text('1/2/1970'), findsOne);
    expect(find.text('1/3/1970'), findsOne);
    await expectLater(find.byType(TestApp), matchesGoldenFile('goldens/room_page_messages.png'));
  });

  testWidgets('Read-only', (tester) async {
    when(() => room.readOnly).thenReturn(1);

    await tester.pumpWidgetWithAccessibility(
      TestApp(
        localizationsDelegates: TalkLocalizations.localizationsDelegates,
        supportedLocales: TalkLocalizations.supportedLocales,
        providers: [
          NeonProvider<TalkRoomBloc>.value(value: bloc),
        ],
        child: const TalkRoomPage(),
      ),
    );

    expect(find.byType(TalkMessageInput), findsNothing);
    await expectLater(find.byType(TestApp), matchesGoldenFile('goldens/room_page_read_only.png'));
  });

  testWidgets('No chat permission', (tester) async {
    when(() => room.permissions).thenReturn(0);

    await tester.pumpWidgetWithAccessibility(
      TestApp(
        localizationsDelegates: TalkLocalizations.localizationsDelegates,
        supportedLocales: TalkLocalizations.supportedLocales,
        providers: [
          NeonProvider<TalkRoomBloc>.value(value: bloc),
        ],
        child: const TalkRoomPage(),
      ),
    );

    expect(find.byType(TalkMessageInput), findsNothing);
    await expectLater(find.byType(TestApp), matchesGoldenFile('goldens/room_page_no_chat_permission.png'));
  });

  group('Swipe-to-reply', () {
    late spreed.ChatMessageWithParent chatMessage;

    setUp(() {
      chatMessage = MockChatMessageWithParent();
      when(() => chatMessage.timestamp).thenReturn(0);
      when(() => chatMessage.actorId).thenReturn('test');
      when(() => chatMessage.actorType).thenReturn(spreed.ActorTypes.users);
      when(() => chatMessage.actorDisplayName).thenReturn('test');
      when(() => chatMessage.messageType).thenReturn(spreed.MessageType.comment);
      when(() => chatMessage.message).thenReturn('abc');
      when(() => chatMessage.reactions).thenReturn(BuiltMap());
      when(() => chatMessage.messageParameters).thenReturn(BuiltMap());
      when(() => chatMessage.id).thenReturn(0);
      when(() => chatMessage.isReplyable).thenReturn(true);

      when(() => bloc.messages).thenAnswer(
        (_) => BehaviorSubject.seeded(
          Result.success(
            BuiltList<spreed.ChatMessageWithParent>([
              chatMessage,
            ]),
          ),
        ),
      );

      when(() => bloc.reactions).thenAnswer((_) => BehaviorSubject.seeded(BuiltMap()));
    });

    testWidgets('Allowed', (tester) async {
      final account = MockAccount();

      await tester.pumpWidgetWithAccessibility(
        TestApp(
          localizationsDelegates: TalkLocalizations.localizationsDelegates,
          supportedLocales: TalkLocalizations.supportedLocales,
          appThemes: const [
            TalkTheme(),
          ],
          providers: [
            Provider<Account>.value(value: account),
            NeonProvider<TalkRoomBloc>.value(value: bloc),
            NeonProvider<ReferencesBloc>.value(value: referencesBloc),
          ],
          child: const TalkRoomPage(),
        ),
      );

      expect(find.byType(Dismissible), findsOne);

      await tester.drag(find.byType(TalkCommentMessage), const Offset(1000, 0));
      await tester.pumpAndSettle();
      verify(() => bloc.setReplyChatMessage(chatMessage)).called(1);
    });

    testWidgets('Read-only', (tester) async {
      when(() => room.readOnly).thenReturn(1);

      final account = MockAccount();

      await tester.pumpWidgetWithAccessibility(
        TestApp(
          localizationsDelegates: TalkLocalizations.localizationsDelegates,
          supportedLocales: TalkLocalizations.supportedLocales,
          appThemes: const [
            TalkTheme(),
          ],
          providers: [
            Provider<Account>.value(value: account),
            NeonProvider<TalkRoomBloc>.value(value: bloc),
            NeonProvider<ReferencesBloc>.value(value: referencesBloc),
          ],
          child: const TalkRoomPage(),
        ),
      );

      expect(find.byType(Dismissible), findsNothing);
    });

    testWidgets('No permission', (tester) async {
      when(() => room.permissions).thenReturn(0);

      final account = MockAccount();

      await tester.pumpWidgetWithAccessibility(
        TestApp(
          localizationsDelegates: TalkLocalizations.localizationsDelegates,
          supportedLocales: TalkLocalizations.supportedLocales,
          appThemes: const [
            TalkTheme(),
          ],
          providers: [
            Provider<Account>.value(value: account),
            NeonProvider<TalkRoomBloc>.value(value: bloc),
            NeonProvider<ReferencesBloc>.value(value: referencesBloc),
          ],
          child: const TalkRoomPage(),
        ),
      );

      expect(find.byType(Dismissible), findsNothing);
    });
  });
}
