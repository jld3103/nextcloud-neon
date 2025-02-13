import 'package:built_collection/built_collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_framework/testing.dart';
import 'package:neon_framework/utils.dart';
import 'package:nextcloud/spreed.dart' as spreed;
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:talk_app/l10n/localizations.dart';
import 'package:talk_app/src/blocs/room.dart';
import 'package:talk_app/src/widgets/reactions.dart';
import 'package:talk_app/src/widgets/reactions_overview_dialog.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'testing.dart';

spreed.Reaction getReaction() {
  final reaction = MockReaction();
  when(() => reaction.actorType).thenReturn(spreed.ActorTypes.users);
  when(() => reaction.actorId).thenReturn('actorId');
  when(() => reaction.actorDisplayName).thenReturn('actorDisplayName');
  when(() => reaction.timestamp).thenReturn(0);

  return reaction;
}

void main() {
  late spreed.Room room;
  late spreed.ChatMessage chatMessage;
  late TalkRoomBloc bloc;

  setUpAll(() {
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Berlin'));

    FakeNeonStorage.setup();
  });

  setUp(() {
    room = MockRoom();
    when(() => room.readOnly).thenReturn(0);
    when(() => room.permissions).thenReturn(spreed.ParticipantPermission.canSendMessageAndShareAndReact.binary);

    chatMessage = MockChatMessage();
    when(() => chatMessage.id).thenReturn(0);
    when(() => chatMessage.reactions).thenReturn(BuiltMap({'😀': 1, '😊': 2}));
    when(() => chatMessage.reactionsSelf).thenReturn(BuiltList(['😊']));
    when(() => chatMessage.systemMessage).thenReturn('');

    bloc = MockRoomBloc();
    when(() => bloc.reactions).thenAnswer(
      (_) => BehaviorSubject.seeded(
        BuiltMap({
          0: BuiltMap<String, BuiltList<spreed.Reaction>>({
            '😀': BuiltList<spreed.Reaction>([getReaction()]),
            '😊': BuiltList<spreed.Reaction>([getReaction(), getReaction()]),
          }),
        }),
      ),
    );
  });

  testWidgets('Reactions', (tester) async {
    await tester.pumpWidgetWithAccessibility(
      TestApp(
        localizationsDelegates: TalkLocalizations.localizationsDelegates,
        supportedLocales: TalkLocalizations.supportedLocales,
        providers: [
          NeonProvider<TalkRoomBloc>.value(value: bloc),
        ],
        child: TalkReactions(
          room: room,
          chatMessage: chatMessage,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byTooltip('actorDisplayName'), findsOne);
    expect(find.byTooltip('actorDisplayName, actorDisplayName'), findsOne);
    await expectLater(find.byType(TalkReactions), matchesGoldenFile('goldens/reactions.png'));
  });

  testWidgets('Add reaction', (tester) async {
    await tester.pumpWidgetWithAccessibility(
      TestApp(
        localizationsDelegates: TalkLocalizations.localizationsDelegates,
        supportedLocales: TalkLocalizations.supportedLocales,
        providers: [
          NeonProvider<TalkRoomBloc>.value(value: bloc),
        ],
        child: TalkReactions(
          room: room,
          chatMessage: chatMessage,
        ),
      ),
    );

    await tester.tap(find.text('😀'), warnIfMissed: false);

    verify(() => bloc.addReaction(chatMessage, '😀')).called(1);
  });

  testWidgets('Remove reaction', (tester) async {
    await tester.pumpWidgetWithAccessibility(
      TestApp(
        localizationsDelegates: TalkLocalizations.localizationsDelegates,
        supportedLocales: TalkLocalizations.supportedLocales,
        providers: [
          NeonProvider<TalkRoomBloc>.value(value: bloc),
        ],
        child: TalkReactions(
          room: room,
          chatMessage: chatMessage,
        ),
      ),
    );

    await tester.tap(find.text('😊'), warnIfMissed: false);

    verify(() => bloc.removeReaction(chatMessage, '😊')).called(1);
  });

  testWidgets('Add new reaction', (tester) async {
    await tester.pumpWidgetWithAccessibility(
      TestApp(
        localizationsDelegates: TalkLocalizations.localizationsDelegates,
        supportedLocales: TalkLocalizations.supportedLocales,
        providers: [
          NeonProvider<TalkRoomBloc>.value(value: bloc),
        ],
        child: TalkReactions(
          room: room,
          chatMessage: chatMessage,
        ),
      ),
    );

    await tester.runAsync(() async {
      await tester.tap(find.byIcon(Icons.add_reaction_outlined), warnIfMissed: false);
      await tester.pumpAndSettle();
      await tester.tap(find.text('😂'));
      await tester.pumpAndSettle();

      verify(() => bloc.addReaction(chatMessage, '😂')).called(1);
    });
  });

  testWidgets('Load reactions on hover', (tester) async {
    await tester.pumpWidgetWithAccessibility(
      TestApp(
        localizationsDelegates: TalkLocalizations.localizationsDelegates,
        supportedLocales: TalkLocalizations.supportedLocales,
        providers: [
          NeonProvider<TalkRoomBloc>.value(value: bloc),
        ],
        child: TalkReactions(
          room: room,
          chatMessage: chatMessage,
        ),
      ),
    );

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await tester.pump();
    await gesture.moveTo(tester.getCenter(find.byType(TalkReactions)));
    await tester.pumpAndSettle();

    verify(() => bloc.loadReactions(chatMessage)).called(1);
  });

  testWidgets('Shows reactions overview dialog', (tester) async {
    final account = MockAccount();

    await tester.pumpWidgetWithAccessibility(
      TestApp(
        localizationsDelegates: TalkLocalizations.localizationsDelegates,
        supportedLocales: TalkLocalizations.supportedLocales,
        providers: [
          NeonProvider<TalkRoomBloc>.value(value: bloc),
          Provider<Account>.value(value: account),
        ],
        child: TalkReactions(
          room: room,
          chatMessage: chatMessage,
        ),
      ),
    );

    await tester.runAsync(() async {
      await tester.tap(find.byIcon(MdiIcons.heartOutline), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.byType(TalkReactionsOverviewDialog), findsOne);
    });
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
        child: TalkReactions(
          room: room,
          chatMessage: chatMessage,
        ),
      ),
    );

    expect(find.byIcon(Icons.add_reaction_outlined), findsNothing);

    await tester.tap(find.text('😀'), warnIfMissed: false);
    verifyNever(() => bloc.addReaction(chatMessage, '😀'));
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
        child: TalkReactions(
          room: room,
          chatMessage: chatMessage,
        ),
      ),
    );

    expect(find.byIcon(Icons.add_reaction_outlined), findsNothing);

    await tester.tap(find.text('😀'), warnIfMissed: false);
    verifyNever(() => bloc.addReaction(chatMessage, '😀'));
  });
}
