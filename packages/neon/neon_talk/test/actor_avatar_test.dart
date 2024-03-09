import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/testing.dart';
import 'package:neon_framework/utils.dart';
import 'package:neon_framework/widgets.dart';
import 'package:neon_talk/src/widgets/actor_avatar.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/spreed.dart' as spreed;
import 'package:rxdart/rxdart.dart';

void main() {
  setUpAll(() {
    final storage = MockNeonStorage();
    when(() => storage.requestCache).thenReturn(null);
  });

  for (final type in spreed.ActorType.values) {
    final avatarMatcher =
        type == spreed.ActorType.users ? findsOne : findsNothing;
    final iconMatcher =
        type == spreed.ActorType.users ? findsNothing : findsOne;

    testWidgets('$type', (tester) async {
      final account = MockAccount();
      when(() => account.id).thenReturn('');
      when(() => account.client).thenReturn(NextcloudClient(Uri.parse('')));

      final accountsBloc = MockAccountsBloc();
      when(() => accountsBloc.activeAccount)
          .thenAnswer((_) => BehaviorSubject.seeded(account));

      await tester.pumpWidget(
        TestApp(
          child: NeonProvider<AccountsBloc>.value(
            value: accountsBloc,
            child: TalkActorAvatar(
              actorId: '',
              actorType: type,
            ),
          ),
        ),
      );

      expect(find.byType(NeonUserAvatar), avatarMatcher);
      expect(find.byType(Icon), iconMatcher);
    });
  }
}
