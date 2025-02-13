import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_framework/testing.dart';
import 'package:neon_framework/widgets.dart';
import 'package:nextcloud/spreed.dart' as spreed;
import 'package:provider/provider.dart';
import 'package:talk_app/src/widgets/actor_avatar.dart';

void main() {
  setUp(() {
    FakeNeonStorage.setup();
  });

  for (final type in spreed.ActorTypes.values) {
    final avatarMatcher = type == spreed.ActorTypes.users ? findsOne : findsNothing;
    final iconMatcher = type == spreed.ActorTypes.users ? findsNothing : findsOne;

    testWidgets('$type', (tester) async {
      final account = MockAccount();

      await tester.pumpWidgetWithAccessibility(
        TestApp(
          providers: [
            Provider<Account>.value(value: account),
          ],
          child: TalkActorAvatar(
            actorId: '',
            actorType: type,
          ),
        ),
      );

      expect(find.byType(NeonUserAvatar), avatarMatcher);
      expect(find.byType(Icon), iconMatcher);
    });
  }
}
