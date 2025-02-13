import 'dart:async';
import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_framework/src/utils/account_options.dart';
import 'package:neon_framework/testing.dart';
import 'package:nextcloud/core.dart' as core;
import 'package:nextcloud/dashboard.dart' as dashboard;
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/notifications.dart' as notifications;
import 'package:rxdart/rxdart.dart';
import 'package:version/version.dart';

Account mockAppsAccount() {
  return mockServer({
    RegExp(r'/ocs/v2\.php/core/navigation/apps'): {
      'get': (match, request) {
        return Response(
          json.encode(
            {
              'ocs': {
                'meta': {'status': '', 'statuscode': 0},
                'data': <dynamic>[
                  {
                    'id': 'test',
                    'order': 0,
                    'href': '',
                    'icon': '',
                    'type': '',
                    'name': '',
                    'active': false,
                    'classes': '',
                    'unread': 0,
                  },
                  {
                    'id': 'initial',
                    'order': 1,
                    'href': '',
                    'icon': '',
                    'type': '',
                    'name': '',
                    'active': false,
                    'classes': '',
                    'unread': 0,
                  },
                  {
                    'id': dashboard.appID,
                    'order': 2,
                    'href': '',
                    'icon': '',
                    'type': '',
                    'name': '',
                    'active': false,
                    'classes': '',
                    'unread': 0,
                  },
                ],
              },
            },
          ),
          200,
          headers: {'content-type': 'application/json'},
        );
      },
    },
  });
}

core.OcsGetCapabilitiesResponseApplicationJson_Ocs_Data buildCapabilities(
  core.NotificationsCapabilities? capabilities,
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
          dropAccountCapabilities: null,
          filesCapabilities: null,
          filesSharingCapabilities: null,
          filesTrashbinCapabilities: null,
          filesVersionsCapabilities: null,
          notesCapabilities: null,
          notificationsCapabilities: capabilities,
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

void main() {
  late Account account;
  late AccountOptions accountOptions;
  late AppsBloc appsBloc;
  late BehaviorSubject<Result<core.OcsGetCapabilitiesResponseApplicationJson_Ocs_Data>> capabilitiesSubject;

  setUpAll(() {
    registerFallbackValue(MockAccount());
    registerFallbackValue(buildCapabilities(null));
  });

  setUp(() {
    FakeNeonStorage.setup();

    capabilitiesSubject = BehaviorSubject.seeded(
      Result.success(
        buildCapabilities(
          core.NotificationsCapabilities(
            (b) => b
              ..notifications.update(
                (b) => b
                  ..ocsEndpoints.replace([])
                  ..push.replace([])
                  ..adminNotifications.replace([]),
              ),
          ),
        ),
      ),
    );

    account = mockAppsAccount();

    final initialAppOption = MockSelectOption<String?>();
    when(() => initialAppOption.value).thenReturn('initial');

    accountOptions = MockAccountOptions();
    when(() => accountOptions.initialApp).thenReturn(initialAppOption);
  });

  tearDown(() {
    unawaited(capabilitiesSubject.close());
    appsBloc.dispose();
  });

  test('No supported apps', () {
    final appImplementation = MockAppImplementation();
    when(() => appImplementation.id).thenReturn('unsupported');
    when(() => appImplementation.blocsCache).thenReturn(MockAccountCache<Bloc>());

    final allAppImplementation = BuiltSet<AppImplementation>([appImplementation]);

    appsBloc = AppsBloc(
      capabilitiesSubject: capabilitiesSubject,
      account: account,
      accountOptions: accountOptions,
      allAppImplementations: allAppImplementation,
    );

    expect(
      appsBloc.appImplementations,
      emitsInOrder([
        Result.success(BuiltSet<AppImplementation>()).asLoading(),
        Result.success(BuiltSet<AppImplementation>()).asLoading(),
        Result.success(BuiltSet<AppImplementation>()),
      ]),
    );
  });

  group('Supported apps', () {
    test('Single', () {
      final appImplementation1 = MockAppImplementation();
      when(() => appImplementation1.id).thenReturn('test');
      when(() => appImplementation1.blocsCache).thenReturn(MockAccountCache<Bloc>());

      final allAppImplementation = BuiltSet<AppImplementation>([
        appImplementation1,
      ]);

      appsBloc = AppsBloc(
        capabilitiesSubject: capabilitiesSubject,
        account: account,
        accountOptions: accountOptions,
        allAppImplementations: allAppImplementation,
      );

      expect(
        appsBloc.appImplementations,
        emitsInOrder([
          Result.success(BuiltSet<AppImplementation>()).asLoading(),
          Result.success(BuiltSet<AppImplementation>()).asLoading(),
          Result.success(BuiltSet<AppImplementation>({appImplementation1})),
        ]),
      );

      expect(
        appsBloc.activeApp,
        emitsInOrder([
          appImplementation1,
        ]),
      );
    });

    test('Initial', () {
      final appImplementation1 = MockAppImplementation();
      when(() => appImplementation1.id).thenReturn('test');
      when(() => appImplementation1.blocsCache).thenReturn(MockAccountCache<Bloc>());

      final appImplementation2 = MockAppImplementation();
      when(() => appImplementation2.id).thenReturn('initial');
      when(() => appImplementation2.blocsCache).thenReturn(MockAccountCache<Bloc>());

      final allAppImplementation = BuiltSet<AppImplementation>([
        appImplementation1,
        appImplementation2,
      ]);

      appsBloc = AppsBloc(
        capabilitiesSubject: capabilitiesSubject,
        account: account,
        accountOptions: accountOptions,
        allAppImplementations: allAppImplementation,
      );

      expect(
        appsBloc.appImplementations,
        emitsInOrder([
          Result.success(BuiltSet<AppImplementation>()).asLoading(),
          Result.success(BuiltSet<AppImplementation>()).asLoading(),
          Result.success(BuiltSet<AppImplementation>({appImplementation1, appImplementation2})),
        ]),
      );

      expect(
        appsBloc.activeApp,
        emitsInOrder([
          appImplementation2,
        ]),
      );
    });

    test('Fallback', () {
      final appImplementation1 = MockAppImplementation();
      when(() => appImplementation1.id).thenReturn('test');
      when(() => appImplementation1.blocsCache).thenReturn(MockAccountCache<Bloc>());

      final appImplementation2 = MockAppImplementation();
      when(() => appImplementation2.id).thenReturn(dashboard.appID);
      when(() => appImplementation2.blocsCache).thenReturn(MockAccountCache<Bloc>());

      final allAppImplementation = BuiltSet<AppImplementation>([
        appImplementation1,
        appImplementation2,
      ]);

      appsBloc = AppsBloc(
        capabilitiesSubject: capabilitiesSubject,
        account: account,
        accountOptions: accountOptions,
        allAppImplementations: allAppImplementation,
      );

      expect(
        appsBloc.appImplementations,
        emitsInOrder([
          Result.success(BuiltSet<AppImplementation>()).asLoading(),
          Result.success(BuiltSet<AppImplementation>()).asLoading(),
          Result.success(BuiltSet<AppImplementation>({appImplementation1, appImplementation2})),
        ]),
      );

      expect(
        appsBloc.activeApp,
        emitsInOrder([
          appImplementation2,
        ]),
      );
    });
  });

  test('With notifications', () {
    final appImplementation1 = MockAppImplementation();
    when(() => appImplementation1.id).thenReturn('test');
    when(() => appImplementation1.blocsCache).thenReturn(MockAccountCache<Bloc>());

    final appImplementation2 = MockAppImplementation();
    when(() => appImplementation2.id).thenReturn(notifications.appID);
    when(() => appImplementation2.blocsCache).thenReturn(MockAccountCache<Bloc>());

    final allAppImplementation = BuiltSet<AppImplementation>([
      appImplementation1,
      appImplementation2,
    ]);

    appsBloc = AppsBloc(
      capabilitiesSubject: capabilitiesSubject,
      account: account,
      accountOptions: accountOptions,
      allAppImplementations: allAppImplementation,
    );

    expect(
      appsBloc.appImplementations,
      emitsInOrder([
        Result.success(BuiltSet<AppImplementation>({appImplementation2})).asLoading(),
        Result.success(BuiltSet<AppImplementation>({appImplementation2})).asLoading(),
        Result.success(BuiltSet<AppImplementation>({appImplementation1, appImplementation2})),
      ]),
    );

    expect(
      appsBloc.activeApp,
      emitsInOrder([
        appImplementation1,
      ]),
    );
  });

  test('Version checks', () {
    final versionCheckCore = VersionCheck(
      versions: BuiltList([Version(0, 0, 0)]),
      minimumVersion: core.minVersion,
    );

    final versionCheck1 = VersionCheck(
      versions: BuiltList([Version(2, 0, 0)]),
      minimumVersion: Version(2, 0, 0),
    );

    final appImplementation1 = MockAppImplementation();
    when(() => appImplementation1.id).thenReturn('test');
    when(() => appImplementation1.blocsCache).thenReturn(MockAccountCache<Bloc>());
    when(() async => appImplementation1.getVersionCheck(any(), any())).thenAnswer((_) async => versionCheck1);

    final versionCheck2 = VersionCheck(
      versions: BuiltList([Version(1, 0, 0)]),
      minimumVersion: Version(2, 0, 0),
    );

    final appImplementation2 = MockAppImplementation();
    when(() => appImplementation2.id).thenReturn('initial');
    when(() => appImplementation2.blocsCache).thenReturn(MockAccountCache<Bloc>());
    when(() async => appImplementation2.getVersionCheck(any(), any())).thenAnswer((_) async => versionCheck2);

    final allAppImplementation = BuiltSet<AppImplementation>([
      appImplementation1,
      appImplementation2,
    ]);

    appsBloc = AppsBloc(
      capabilitiesSubject: capabilitiesSubject,
      account: account,
      accountOptions: accountOptions,
      allAppImplementations: allAppImplementation,
    );

    expect(
      appsBloc.appImplementations,
      emitsInOrder([
        Result.success(BuiltSet<AppImplementation>()).asLoading(),
        Result.success(BuiltSet<AppImplementation>()).asLoading(),
        Result.success(BuiltSet<AppImplementation>({appImplementation1, appImplementation2})),
      ]),
    );
    expect(
      appsBloc.activeApp,
      emitsInOrder([
        appImplementation2,
      ]),
    );
    expect(
      appsBloc.appVersionChecks,
      emitsInOrder([
        BuiltMap<String, VersionCheck>({
          'core': versionCheckCore,
          'test': versionCheck1,
          'initial': versionCheck2,
        }),
      ]),
    );
    expect(
      appsBloc.unsupportedApps,
      emitsInOrder([
        BuiltMap<String, VersionCheck>({
          'core': versionCheckCore,
          'initial': versionCheck2,
        }),
      ]),
    );
  });
}
