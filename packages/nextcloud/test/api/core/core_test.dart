import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:nextcloud/core.dart' as core;
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/webdav.dart' as webdav;
import 'package:nextcloud_test/nextcloud_test.dart';
import 'package:test/test.dart';

void main() {
  presets('server', 'core', (tester) {
    test('Is supported from capabilities', () async {
      final response = await tester.client.core.ocs.getCapabilities();

      expect(response.statusCode, 200);
      expect(() => response.headers, isA<void>());

      final result = tester.client.core.getVersionCheck(response.body.ocs.data);
      expect(result.versions, isNotNull);
      expect(result.versions, isNotEmpty);
      expect(result.isSupported, isTrue);
    });

    test('Is supported from status', () async {
      final response = await tester.client.core.getStatus();
      expect(response.statusCode, 200);
      expect(() => response.headers, isA<void>());

      expect(response.body.versionCheck.isSupported, isTrue);
    });

    test('Get status', () async {
      final response = await tester.client.core.getStatus();
      expect(response.statusCode, 200);
      expect(() => response.headers, isA<void>());

      expect(response.body.installed, isTrue);
      expect(response.body.maintenance, isFalse);
      expect(response.body.needsDbUpgrade, isFalse);
      expect(response.body.version, isNotEmpty);
      expect(response.body.versionstring, isNotEmpty);
      expect(response.body.edition, '');
      expect(response.body.productname, 'Nextcloud');
      expect(response.body.extendedSupport, isFalse);
    });

    group('csrfToken', () {
      test('index returns csrf token', () async {
        final response = await tester.client.core.csrfToken.index();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.token, isNotEmpty);
      });
    });

    group('OCS', () {
      test('Get capabilities', () async {
        final response = await tester.client.core.ocs.getCapabilities();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.ocs.data.capabilities.commentsCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.coreCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.corePublicCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.davCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.dropAccountCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.filesCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.filesSharingCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.filesTrashbinCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.filesVersionsCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.notesCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.notificationsCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.passwordPolicyCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.provisioningApiCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.sharebymailCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.spreedPublicCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.systemtagsCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.tablesCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.themingPublicCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.userStatusCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.weatherStatusCapabilities, isNotNull);
      });
    });

    group('Navigation', () {
      test('Get apps navigation', () async {
        final response = await tester.client.core.navigation.getAppsNavigation();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());
        expect(
          response.body.ocs.data.map((e) => e.id),
          containsAll([
            'dashboard',
            'files',
            'spreed',
            'notes',
            'tables',
            'news',
            'cookbook',
          ]),
        );
      });
    });

    group('Autocomplete', () {
      test('Get', () async {
        final response = await tester.client.core.autoComplete.$get(
          search: '',
          itemType: 'call',
          itemId: 'new',
          shareTypes: BuiltList([core.ShareType.group.index]),
        );
        expect(response.body.ocs.data, hasLength(1));

        expect(response.body.ocs.data[0].id, 'admin');
        expect(response.body.ocs.data[0].label, 'admin');
        expect(response.body.ocs.data[0].icon, '');
        expect(response.body.ocs.data[0].source, 'groups');
        expect(response.body.ocs.data[0].status.autocompleteResultStatus0, isNull);
        expect(response.body.ocs.data[0].status.string, isEmpty);
        expect(response.body.ocs.data[0].subline, '');
        expect(response.body.ocs.data[0].shareWithDisplayNameUnique, '');
      });
    });

    group('Preview', () {
      setUp(() async {
        final file = File('test/files/test.png');
        await tester.client.webdav.putFile(file, file.statSync(), webdav.PathUri.parse('preview.png'));
        resetFixture();
      });

      tearDown(() async {
        closeFixture();
        await tester.client.webdav.delete(webdav.PathUri.parse('preview.png'));
      });

      test('Get', () async {
        final response = await tester.client.core.preview.getPreview(
          file: 'preview.png',
        );
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body, isNotEmpty);
      });
    });

    group('Avatar', () {
      test('Get', () async {
        final response = await tester.client.core.avatar.getAvatar(
          userId: 'admin',
          size: core.AvatarGetAvatarSize.$64,
        );
        expect(response.body, isNotEmpty);
        expect(response.headers.xNcIscustomavatar?.content, 0);
      });

      test('Get dark', () async {
        final response = await tester.client.core.avatar.getAvatarDark(
          userId: 'admin',
          size: core.AvatarGetAvatarDarkSize.$64,
        );
        expect(response.body, isNotEmpty);
        expect(response.headers.xNcIscustomavatar?.content, 0);
      });
    });

    group('App password', () {
      test('Delete', () async {
        // Separate client to not break other tests
        final client = await tester.createClient();

        await client.core.appPassword.deleteAppPassword();
        await expectLater(
          () => client.core.appPassword.deleteAppPassword(),
          throwsA(predicate((e) => (e! as DynamiteStatusCodeException).statusCode == 401)),
        );
      });
    });

    group('Unified search', () {
      test('Get providers', () async {
        final response = await tester.client.core.unifiedSearch.getProviders();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.ocs.data, isNotEmpty);
      });

      test('Search', () async {
        final response = await tester.client.core.unifiedSearch.search(
          providerId: 'settings',
          term: 'Personal info',
        );

        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.ocs.data.name, 'Settings');
        expect(response.body.ocs.data.isPaginated, isFalse);
        expect(response.body.ocs.data.entries, hasLength(1));
        expect(response.body.ocs.data.entries.single.thumbnailUrl, isEmpty);
        expect(response.body.ocs.data.entries.single.title, 'Personal info');
        expect(response.body.ocs.data.entries.single.subline, isEmpty);
        expect(response.body.ocs.data.entries.single.resourceUrl, isNotEmpty);
        expect(response.body.ocs.data.entries.single.icon, 'icon-settings-dark');
        expect(response.body.ocs.data.entries.single.rounded, isFalse);
        expect(response.body.ocs.data.entries.single.attributes, isEmpty);
      });
    });

    group('Client login flow V2', () {
      test('Init and poll', () async {
        final response = await tester.client.core.clientFlowLoginV2.init();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.login, startsWith('http://localhost'));
        expect(response.body.poll.endpoint, startsWith('http://localhost'));
        expect(response.body.poll.token, isNotEmpty);

        await expectLater(
          () => tester.client.core.clientFlowLoginV2.poll(
            $body: core.ClientFlowLoginV2PollRequestApplicationJson(
              (b) => b..token = response.body.poll.token,
            ),
          ),
          throwsA(predicate<DynamiteStatusCodeException>((e) => e.statusCode == 404)),
        );
      });
    });

    group('References', () {
      test('resolveOne', () async {
        final response = await tester.client.core.referenceApi.resolveOne(
          reference: 'https://example.com',
        );
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.ocs.data.references, hasLength(1));
        final reference = response.body.ocs.data.references['https://example.com']!;
        expect(reference.richObjectType, 'open-graph');
        expect(reference.richObject['id']!.asString, 'https://example.com');
        expect(reference.richObject['name']!.asString, 'Example Domain');
        expect(reference.richObject['description'], null);
        expect(reference.richObject['thumb'], null);
        expect(reference.richObject['link']!.asString, 'https://example.com');
        expect(reference.openGraphObject.id, 'https://example.com');
        expect(reference.openGraphObject.name, 'Example Domain');
        expect(reference.openGraphObject.link, 'https://example.com');
        expect(reference.accessible, true);
      });

      test('resolve', () async {
        final response = await tester.client.core.referenceApi.resolve(
          $body: core.ReferenceApiResolveRequestApplicationJson(
            (b) => b
              ..references.replace([
                'https://example.com',
                'https://example.org',
              ])
              ..limit = 2,
          ),
        );
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.ocs.data.references, hasLength(2));
        for (final domain in ['https://example.com', 'https://example.org']) {
          final reference = response.body.ocs.data.references[domain]!;
          expect(reference.richObjectType, 'open-graph');
          expect(reference.richObject['id']!.asString, domain);
          expect(reference.richObject['name']!.asString, 'Example Domain');
          expect(reference.richObject['description'], null);
          expect(reference.richObject['thumb'], null);
          expect(reference.richObject['link']!.asString, domain);
          expect(reference.openGraphObject.id, domain);
          expect(reference.openGraphObject.name, 'Example Domain');
          expect(reference.openGraphObject.link, domain);
          expect(reference.accessible, true);
        }
      });

      test('extract', () async {
        final response = await tester.client.core.referenceApi.extract(
          $body: core.ReferenceApiExtractRequestApplicationJson(
            (b) => b
              ..text = '''
abc https://example.com def
https://example.org
ghi
'''
              ..resolve = true
              ..limit = 2,
          ),
        );
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.ocs.data.references, hasLength(2));
        for (final domain in ['https://example.com', 'https://example.org']) {
          final reference = response.body.ocs.data.references[domain]!;
          expect(reference.richObjectType, 'open-graph');
          expect(reference.richObject['id']!.asString, domain);
          expect(reference.richObject['name']!.asString, 'Example Domain');
          expect(reference.richObject['description'], null);
          expect(reference.richObject['thumb'], null);
          expect(reference.richObject['link']!.asString, domain);
          expect(reference.openGraphObject.id, domain);
          expect(reference.openGraphObject.name, 'Example Domain');
          expect(reference.openGraphObject.link, domain);
          expect(reference.accessible, true);
        }
      });
    });
  });
}
