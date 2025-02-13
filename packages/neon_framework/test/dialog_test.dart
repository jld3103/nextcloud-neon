import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/l10n/localizations_en.dart';
import 'package:neon_framework/src/widgets/dialog.dart';
import 'package:neon_framework/testing.dart';
import 'package:neon_framework/utils.dart';
import 'package:nextcloud/core.dart' as core;
import 'package:nextcloud/user_status.dart' as user_status;
import 'package:nextcloud/utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;

void main() {
  group('dialog', () {
    group('NeonConfirmationDialog', () {
      testWidgets('NeonConfirmationDialog widget', (tester) async {
        const title = 'My Title';
        var dialog = const NeonConfirmationDialog(title: title);
        await tester.pumpWidgetWithAccessibility(TestApp(child: dialog));

        expect(find.text(title), findsOneWidget);
        expect(find.byType(NeonDialogAction), findsExactly(2));

        // Not true on cupertino platforms
        expect(find.byType(OutlinedButton), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);

        dialog = const NeonConfirmationDialog(
          title: title,
          isDestructive: false,
        );

        await tester.pumpWidgetWithAccessibility(TestApp(child: dialog));

        expect(find.byType(NeonDialogAction), findsExactly(2));
        expect(find.byType(OutlinedButton), findsExactly(2));

        const icon = Icon(Icons.error);
        const content = SizedBox(key: Key('content'));
        const confirmAction = SizedBox(key: Key('confirmAction'));
        const declineAction = SizedBox(key: Key('declineAction'));
        dialog = const NeonConfirmationDialog(
          title: title,
          icon: icon,
          content: content,
          confirmAction: confirmAction,
          declineAction: declineAction,
        );
        await tester.pumpWidgetWithAccessibility(TestApp(child: dialog));

        expect(find.byIcon(Icons.error), findsOneWidget);
        expect(find.byKey(const Key('content')), findsOneWidget);
        expect(find.byKey(const Key('confirmAction')), findsOneWidget);
        expect(find.byKey(const Key('declineAction')), findsOneWidget);
      });

      testWidgets('NeonConfirmationDialog actions', (tester) async {
        const title = 'My Title';
        await tester.pumpWidgetWithAccessibility(const TestApp(child: Placeholder()));
        final context = tester.element(find.byType(Placeholder));

        // confirm
        var result = showConfirmationDialog(context: context, title: title);
        await tester.pumpAndSettle();
        await tester.tap(find.text(NeonLocalizationsEn().actionContinue));
        expect(await result, isTrue);

        // decline
        result = showConfirmationDialog(context: context, title: title);
        await tester.pumpAndSettle();
        await tester.tap(find.text(NeonLocalizationsEn().actionCancel));
        expect(await result, isFalse);

        // cancel by tapping outside
        result = showConfirmationDialog(context: context, title: title);
        await tester.pumpAndSettle();
        await tester.tapAt(Offset.zero);
        expect(await result, isFalse);
      });
    });

    group('NeonRenameDialog', () {
      testWidgets('NeonRenameDialog widget', (tester) async {
        const title = 'My Title';
        const value = 'My value';
        const dialog = NeonRenameDialog(title: title, value: value);
        await tester.pumpWidgetWithAccessibility(const TestApp(child: dialog));

        expect(find.text(title), findsExactly(2), reason: 'The title is also used for the confirmation button');
        expect(find.text(value), findsOneWidget);
        expect(find.byType(TextFormField), findsOneWidget);
      });

      testWidgets('NeonRenameDialog actions', (tester) async {
        const title = 'My Title';
        const value = 'My value';
        await tester.pumpWidgetWithAccessibility(const TestApp(child: Placeholder()));
        final context = tester.element(find.byType(Placeholder));

        // Equal value should not submit
        var result = showRenameDialog(context: context, title: title, initialValue: value);
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextFormField), value);
        await tester.tap(find.byType(NeonDialogAction));
        expect(await result, isNull);

        // Empty value should not submit
        result = showRenameDialog(context: context, title: title, initialValue: value);
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextFormField), '');
        await tester.tap(find.byType(NeonDialogAction));

        // Different value should submit
        await tester.enterText(find.byType(TextFormField), 'My new value');
        await tester.tap(find.byType(NeonDialogAction));
        expect(await result, equals('My new value'));

        // Submit via keyboard
        result = showRenameDialog(context: context, title: title, initialValue: value);
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextFormField), 'My new value');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        expect(await result, equals('My new value'));
      });
    });

    group('NeonErrorDialog', () {
      testWidgets('NeonErrorDialog widget', (tester) async {
        const title = 'My Title';
        const content = 'My content';
        var dialog = const NeonErrorDialog(content: content, title: title);
        await tester.pumpWidgetWithAccessibility(TestApp(child: dialog));

        expect(find.byIcon(Icons.error), findsOneWidget);
        expect(find.text(title), findsOneWidget);
        expect(find.text(content), findsOneWidget);
        expect(find.byType(NeonDialogAction), findsOneWidget);

        dialog = const NeonErrorDialog(content: content);
        await tester.pumpWidgetWithAccessibility(TestApp(child: dialog));

        expect(find.text(NeonLocalizationsEn().errorDialog), findsOneWidget);
      });

      testWidgets('NeonErrorDialog actions', (tester) async {
        const content = 'My content';
        await tester.pumpWidgetWithAccessibility(const TestApp(child: Placeholder()));
        final context = tester.element(find.byType(Placeholder));

        final result = showErrorDialog(context: context, message: content);
        await tester.pumpAndSettle();
        await tester.tap(find.text(NeonLocalizationsEn().actionClose));
        await result;
      });
    });

    testWidgets('UnimplementedDialog', (tester) async {
      const title = 'My Title';
      await tester.pumpWidgetWithAccessibility(const TestApp(child: Placeholder()));
      final context = tester.element(find.byType(Placeholder));

      final result = showUnimplementedDialog(context: context, title: title);
      await tester.pumpAndSettle();
      await tester.tap(find.text(NeonLocalizationsEn().actionClose));
      await result;
    });

    testWidgets('NeonDialog', (tester) async {
      var dialog = const NeonDialog(
        actions: [],
      );
      await tester.pumpWidgetWithAccessibility(TestApp(platform: TargetPlatform.macOS, child: dialog));
      expect(
        find.byType(NeonDialogAction),
        findsOneWidget,
        reason: 'Dialogs can not be dismissed on cupertino platforms. Expecting a fallback action.',
      );

      dialog = const NeonDialog(
        automaticallyShowCancel: false,
        actions: [],
      );
      await tester.pumpWidgetWithAccessibility(TestApp(platform: TargetPlatform.macOS, child: dialog));
      expect(find.byType(NeonDialogAction), findsNothing);
    });

    testWidgets('NeonEmojiPickerDialog', (tester) async {
      await tester.pumpWidgetWithAccessibility(const TestApp(child: Placeholder()));
      final BuildContext context = tester.element(find.byType(Placeholder));

      final future = showDialog<String>(
        context: context,
        builder: (context) => const NeonEmojiPickerDialog(),
      );
      await tester.pumpAndSettle();

      // Switch a different category
      await tester.tap(find.text('🐕'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('🌳'));
      expect(await future, '🌳');
    });

    testWidgets('NeonUserStatusDialog', (tester) async {
      final now = tz.TZDateTime.utc(2024, 1, 20);

      final status = BehaviorSubject.seeded(
        Result.success(
          user_status.Private(
            (b) => b
              ..userId = 'test'
              ..message = 'predefined message'
              ..icon = '😅'
              ..clearAt = now.add(const Duration(hours: 3)).secondsSinceEpoch
              ..status = user_status.$Type.online
              ..messageId = 'id1'
              ..messageIsPredefined = true
              ..statusIsUserDefined = true,
          ),
        ),
      );
      final predefinedStatuses = BehaviorSubject<Result<BuiltList<user_status.Predefined>>>.seeded(
        Result.success(
          BuiltList.from([
            user_status.Predefined(
              (b) => b
                ..id = 'id1'
                ..icon = '😁'
                ..message = 'message1'
                ..clearAt.update(
                  (b) => b
                    ..type = user_status.ClearAt_Type.period
                    ..time = (
                      $int: 60 * 60 * 7,
                      clearAtTimeType: null,
                    ),
                ),
            ),
            user_status.Predefined(
              (b) => b
                ..id = 'id2'
                ..icon = '😆'
                ..message = 'message2'
                ..clearAt.update(
                  (b) => b
                    ..type = user_status.ClearAt_Type.endOf
                    ..time = (
                      $int: null,
                      clearAtTimeType: user_status.ClearAtTimeType.week,
                    ),
                ),
            ),
          ]),
        ),
      );

      final userStatusBloc = MockUserStatusBloc();
      when(() => userStatusBloc.status).thenAnswer((_) => status);
      when(() => userStatusBloc.predefinedStatuses).thenAnswer((_) => predefinedStatuses);

      await tester.pumpWidgetWithAccessibility(
        TestApp(
          wrapMaterial: false,
          providers: [
            NeonProvider<UserStatusBloc>.value(value: userStatusBloc),
          ],
          child: NeonUserStatusDialog(
            now: now,
          ),
        ),
      );

      expect(find.text('predefined message'), findsOne);
      expect(find.text('😅'), findsOne);
      expect(find.text('7 hours'), findsOne);

      await expectLater(find.byType(NeonUserStatusDialog), matchesGoldenFile('goldens/user_status_dialog.png'));

      // Other status type
      await tester.tap(find.text('Away'));
      verify(() => userStatusBloc.setStatusType('away')).called(1);

      // Predefined with period clearAt
      await tester.tap(find.text('message1'));
      verify(
        () => userStatusBloc.setPredefinedMessage(
          id: 'id1',
          clearAt: now.add(const Duration(hours: 7)),
        ),
      ).called(1);

      // Predefined with end-of clearAt
      await tester.tap(find.text('message2'));
      verify(
        () => userStatusBloc.setPredefinedMessage(
          id: 'id2',
          clearAt: now.add(const Duration(days: 2)),
        ),
      ).called(1);

      // Set emoji
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('😀'));
      verify(
        () => userStatusBloc.setCustomMessage(
          message: 'predefined message',
          icon: '😀',
          clearAt: now.add(const Duration(hours: 3)),
        ),
      ).called(1);

      // Set message
      await tester.enterText(find.byType(TextField), 'custom message');
      verify(
        () => userStatusBloc.setCustomMessage(
          message: 'custom message',
          icon: '😅',
          clearAt: now.add(const Duration(hours: 3)),
        ),
      ).called(1);

      // Set clearAt
      await tester.dragUntilVisible(
        find.byType(DropdownButton<user_status.ClearAt?>),
        find.byType(SingleChildScrollView),
        const Offset(0, 50),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DropdownButton<user_status.ClearAt?>));
      await tester.pumpAndSettle();
      expect(find.text('7 hours'), findsOne);
      expect(find.text('Do not clear'), findsOne);
      expect(find.text('30 minutes'), findsOne);
      expect(find.text('1 hour'), findsOne);
      expect(find.text('4 hours'), findsOne);
      expect(find.text('Today'), findsOne);
      expect(find.text('This week'), findsExactly(2)); // From predefined end-of
      await tester.tap(find.text('4 hours'));
      await tester.pumpAndSettle();
      verify(
        () => userStatusBloc.setCustomMessage(
          message: 'predefined message',
          icon: '😅',
          clearAt: now.add(const Duration(hours: 4)),
        ),
      ).called(1);

      await tester.tap(find.text('Clear status'));
      verify(userStatusBloc.clearMessage).called(1);

      await status.close();
      await predefinedStatuses.close();
    });
  });

  group('NeonAccountDeletionDialog', () {
    core.OcsGetCapabilitiesResponseApplicationJson_Ocs_Data buildCapabilities(
      core.DropAccountCapabilities? capabilities,
    ) =>
        core.OcsGetCapabilitiesResponseApplicationJson_Ocs_Data(
          (b) => b
            ..version.update(
              (b) => b
                ..major = 0
                ..minor = 0
                ..micro = 0
                ..string = ''
                ..edition = ''
                ..extendedSupport = false,
            )
            ..capabilities = (
              // We need to provide at least one capability because anyOf expects at least one schema to match
              commentsCapabilities: core.CommentsCapabilities((b) => b..files.update((b) => b..comments = true)),
              coreCapabilities: null,
              corePublicCapabilities: null,
              davCapabilities: null,
              dropAccountCapabilities: capabilities,
              filesCapabilities: null,
              filesSharingCapabilities: null,
              filesTrashbinCapabilities: null,
              filesVersionsCapabilities: null,
              notesCapabilities: null,
              notificationsCapabilities: null,
              passwordPolicyCapabilities: null,
              provisioningApiCapabilities: null,
              sharebymailCapabilities: null,
              spreedCapabilities: null,
              spreedPublicCapabilities: null,
              systemtagsCapabilities: null,
              tablesCapabilities: null,
              themingPublicCapabilities: null,
              userStatusCapabilities: null,
              weatherStatusCapabilities: null,
            ),
        );

    testWidgets('Without drop_account', (tester) async {
      final account = MockAccount();

      final capabilitiesBloc = MockCapabilitiesBloc();
      when(() => capabilitiesBloc.capabilities).thenAnswer(
        (_) => BehaviorSubject.seeded(Result.success(buildCapabilities(null))),
      );

      await tester.pumpWidgetWithAccessibility(const TestApp(child: Placeholder()));
      final BuildContext context = tester.element(find.byType(Placeholder));

      final future = showDialog<AccountDeletion>(
        context: context,
        builder: (context) => NeonAccountDeletionDialog(
          account: account,
          capabilitiesBloc: capabilitiesBloc,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(NeonConfirmationDialog), findsOne);

      await tester.tap(find.text(NeonLocalizations.of(context).actionContinue));
      expect(await future, AccountDeletion.local);
    });

    group('With drop_account', () {
      testWidgets('Disabled', (tester) async {
        final account = MockAccount();

        final capabilitiesBloc = MockCapabilitiesBloc();
        when(() => capabilitiesBloc.capabilities).thenAnswer(
          (_) => BehaviorSubject.seeded(
            Result.success(
              buildCapabilities(
                core.DropAccountCapabilities(
                  (b) => b
                    ..dropAccount.update(
                      (b) => b
                        ..apiVersion = ''
                        ..enabled = false
                        ..details = 'disabled'
                        ..delay.update(
                          (b) => b
                            ..enabled = false
                            ..hours = 0,
                        ),
                    ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpWidgetWithAccessibility(const TestApp(child: Placeholder()));
        final BuildContext context = tester.element(find.byType(Placeholder));

        final future = showDialog<AccountDeletion>(
          context: context,
          builder: (context) => NeonAccountDeletionDialog(
            account: account,
            capabilitiesBloc: capabilitiesBloc,
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(NeonConfirmationDialog), findsNothing);
        expect(find.byType(RadioListTile<AccountDeletion>), findsExactly(2));

        expect(find.text('disabled'), findsOne);
        await tester.tap(find.text('disabled'));

        await tester.tap(find.text(NeonLocalizations.of(context).actionContinue));
        expect(await future, AccountDeletion.local);
      });

      testWidgets('Delay', (tester) async {
        final account = MockAccount();

        final capabilitiesBloc = MockCapabilitiesBloc();
        when(() => capabilitiesBloc.capabilities).thenAnswer(
          (_) => BehaviorSubject.seeded(
            Result.success(
              buildCapabilities(
                core.DropAccountCapabilities(
                  (b) => b
                    ..dropAccount.update(
                      (b) => b
                        ..apiVersion = ''
                        ..enabled = true
                        ..delay.update(
                          (b) => b
                            ..enabled = true
                            ..hours = 12,
                        ),
                    ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpWidgetWithAccessibility(const TestApp(child: Placeholder()));
        final BuildContext context = tester.element(find.byType(Placeholder));

        final future = showDialog<AccountDeletion>(
          context: context,
          builder: (context) => NeonAccountDeletionDialog(
            account: account,
            capabilitiesBloc: capabilitiesBloc,
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(NeonConfirmationDialog), findsNothing);
        expect(find.byType(RadioListTile<AccountDeletion>), findsExactly(2));

        expect(find.text(NeonLocalizations.of(context).accountOptionsRemoveRemoteDelay('12 hours')), findsOne);
        await tester.tap(find.text(NeonLocalizations.of(context).accountOptionsRemoveRemoteDelay('12 hours')));

        await tester.tap(find.text(NeonLocalizations.of(context).actionContinue));
        expect(await future, AccountDeletion.remote);
      });
    });
  });
}
