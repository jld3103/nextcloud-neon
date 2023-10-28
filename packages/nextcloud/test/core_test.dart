import 'package:nextcloud/core.dart' as core;
import 'package:nextcloud/nextcloud.dart';
import 'package:test/test.dart';

import 'helper.dart';

void main() {
  group(
    'core',
    () {
      late DockerImage image;
      setUpAll(() async => image = await getDockerImage());

      late DockerContainer container;
      late TestNextcloudClient client;
      setUp(() async {
        container = await getDockerContainer(image);
        client = await getTestClient(container);
      });
      tearDown(() => container.destroy());

      test('Is supported from capabilities', () async {
        final response = await client.core.ocs.getCapabilities();

        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        final (supported, _) = client.core.isSupported(response.body.ocs.data);
        expect(supported, isTrue);
      });

      test('Is supported from status', () async {
        final response = await client.core.getStatus();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.isSupported, isTrue);
      });

      test('Get status', () async {
        final response = await client.core.getStatus();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.installed, isTrue);
        expect(response.body.maintenance, isFalse);
        expect(response.body.needsDbUpgrade, isFalse);
        expect(response.body.version, startsWith('${core.supportedVersion}.'));
        expect(response.body.versionstring, startsWith('${core.supportedVersion}.'));
        expect(response.body.edition, '');
        expect(response.body.productname, 'Nextcloud');
        expect(response.body.extendedSupport, isFalse);
      });

      test('Get capabilities', () async {
        final response = await client.core.ocs.getCapabilities();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.ocs.data.version.major, core.supportedVersion);
        expect(response.body.ocs.data.version.string, startsWith('${core.supportedVersion}.'));
        expect(response.body.ocs.data.capabilities.commentsCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.davCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.filesCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.filesSharingCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.filesTrashbinCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.filesVersionsCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.notesCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.notificationsCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.provisioningApiCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.sharebymailCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.themingPublicCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.userStatusCapabilities, isNotNull);
        expect(response.body.ocs.data.capabilities.weatherStatusCapabilities, isNotNull);
      });

      test('Get navigation apps', () async {
        final response = await client.core.navigation.getAppsNavigation();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());
        expect(response.body.ocs.data, hasLength(6));

        expect(response.body.ocs.data[0].id, 'dashboard');
        expect(response.body.ocs.data[1].id, 'files');
        expect(response.body.ocs.data[2].id, 'photos');
        expect(response.body.ocs.data[3].id, 'activity');
        expect(response.body.ocs.data[4].id, 'notes');
        expect(response.body.ocs.data[5].id, 'news');
      });

      test('Autocomplete', () async {
        final response = await client.core.autoComplete.$get(
          search: '',
          itemType: 'call',
          itemId: 'new',
          shareTypes: [core.ShareType.group.index],
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

      test('Get preview', () async {
        final response = await client.core.preview.getPreview(file: 'Nextcloud.png');
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body, isNotEmpty);
      });

      test('Get avatar', () async {
        final response = await client.core.avatar.getAvatar(userId: 'admin', size: 32);
        expect(response.body, isNotEmpty);
      });

      test('Get dark avatar', () async {
        final response = await client.core.avatar.getAvatarDark(userId: 'admin', size: 32);
        expect(response.body, isNotEmpty);
      });

      test('Delete app password', () async {
        await client.core.appPassword.deleteAppPassword();
        expect(
          () => client.core.appPassword.deleteAppPassword(),
          throwsA(predicate((final e) => (e! as DynamiteApiException).statusCode == 401)),
        );
      });

      test('Unified search providers', () async {
        final response = await client.core.unifiedSearch.getProviders();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.ocs.data, hasLength(13));
      });

      test('Unified search', () async {
        final response = await client.core.unifiedSearch.search(
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

      test('Client login flow V2', () async {
        final response = await client.core.clientFlowLoginV2.init();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.login, startsWith('http://localhost'));
        expect(response.body.poll.endpoint, startsWith('http://localhost'));
        expect(response.body.poll.token, isNotEmpty);

        expect(
          () => client.core.clientFlowLoginV2.poll(token: response.body.poll.token),
          throwsA(predicate<DynamiteApiException>((final e) => e.statusCode == 404)),
        );
      });
    },
    tags: 'integration',
  );
}
