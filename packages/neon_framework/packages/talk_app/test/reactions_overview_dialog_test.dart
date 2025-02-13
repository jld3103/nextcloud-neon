import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
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
import 'package:talk_app/src/widgets/actor_avatar.dart';
import 'package:talk_app/src/widgets/reactions_overview_dialog.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'testing.dart';

void main() {
  late spreed.ChatMessage chatMessage;
  late TalkRoomBloc bloc;

  setUpAll(() {
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Berlin'));

    FakeNeonStorage.setup();
  });

  setUp(() {
    chatMessage = MockChatMessage();
    when(() => chatMessage.id).thenReturn(0);
    when(() => chatMessage.reactions).thenReturn(BuiltMap({'😀': 1, '😊': 2}));
    when(() => chatMessage.systemMessage).thenReturn('');

    final reaction1 = MockReaction();
    when(() => reaction1.actorType).thenReturn(spreed.ActorTypes.users);
    when(() => reaction1.actorId).thenReturn('user1');
    when(() => reaction1.actorDisplayName).thenReturn('User One');
    when(() => reaction1.timestamp).thenReturn(60);

    final reaction2 = MockReaction();
    when(() => reaction2.actorType).thenReturn(spreed.ActorTypes.users);
    when(() => reaction2.actorId).thenReturn('user2');
    when(() => reaction2.actorDisplayName).thenReturn('User Two');
    when(() => reaction2.timestamp).thenReturn(120);

    final reaction3 = MockReaction();
    when(() => reaction3.actorType).thenReturn(spreed.ActorTypes.users);
    when(() => reaction3.actorId).thenReturn('user3');
    when(() => reaction3.actorDisplayName).thenReturn('User Three');
    when(() => reaction3.timestamp).thenReturn(180);

    bloc = MockRoomBloc();
    when(() => bloc.reactions).thenAnswer(
      (_) => BehaviorSubject.seeded(
        BuiltMap({
          0: BuiltMap<String, BuiltList<spreed.Reaction>>({
            '😀': BuiltList<spreed.Reaction>([reaction1]),
            '😊': BuiltList<spreed.Reaction>([reaction2, reaction3]),
          }),
        }),
      ),
    );
  });

  testWidgets('Displays reactions', (tester) async {
    final account = MockAccount();

    await tester.pumpWidgetWithAccessibility(
      TestApp(
        localizationsDelegates: TalkLocalizations.localizationsDelegates,
        supportedLocales: TalkLocalizations.supportedLocales,
        providers: [
          NeonProvider<TalkRoomBloc>.value(value: bloc),
          Provider<Account>.value(value: account),
        ],
        child: TalkReactionsOverviewDialog(
          chatMessage: chatMessage,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('All 3'), findsOne);

    expect(find.byType(ListTile), findsExactly(3));
    expect(find.byType(TalkActorAvatar), findsExactly(3));
    expect(find.text('User One'), findsOne);
    expect(find.text('1/1/1970 1:01 AM'), findsOne);
    expect(find.text('User Two'), findsOne);
    expect(find.text('1/1/1970 1:02 AM'), findsOne);
    expect(find.text('User Three'), findsOne);
    expect(find.text('1/1/1970 1:03 AM'), findsOne);
    expect(find.text('😀'), findsOne);
    expect(find.text('😊'), findsExactly(2));
    await expectLater(
      find.byType(TalkReactionsOverviewDialog),
      matchesGoldenFile('goldens/reactions_overview_dialog_all.png'),
    );

    await tester.tap(find.text('😀 1'));
    await tester.pumpAndSettle();

    expect(find.byType(ListTile), findsOne);
    expect(find.byType(TalkActorAvatar), findsOne);
    expect(find.text('User One'), findsOne);
    expect(find.text('1/1/1970 1:01 AM'), findsOne);
    expect(find.text('User Two'), findsNothing);
    expect(find.text('1/1/1970 1:02 AM'), findsNothing);
    expect(find.text('User Three'), findsNothing);
    expect(find.text('1/1/1970 1:03 AM'), findsNothing);
    expect(find.text('😀'), findsOne);
    expect(find.text('😊'), findsNothing);
    await expectLater(
      find.byType(TalkReactionsOverviewDialog),
      matchesGoldenFile('goldens/reactions_overview_dialog_single.png'),
    );

    await tester.tap(find.text('😊 2'));
    await tester.pumpAndSettle();

    expect(find.byType(ListTile), findsExactly(2));
    expect(find.byType(TalkActorAvatar), findsExactly(2));
    expect(find.text('User One'), findsNothing);
    expect(find.text('1/1/1970 1:01 AM'), findsNothing);
    expect(find.text('User Two'), findsOne);
    expect(find.text('1/1/1970 1:02 AM'), findsOne);
    expect(find.text('User Three'), findsOne);
    expect(find.text('1/1/1970 1:03 AM'), findsOne);
    expect(find.text('😀'), findsNothing);
    expect(find.text('😊'), findsExactly(2));
    await expectLater(
      find.byType(TalkReactionsOverviewDialog),
      matchesGoldenFile('goldens/reactions_overview_dialog_multiple.png'),
    );
  });
}
