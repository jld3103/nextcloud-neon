import 'dart:convert';

import 'package:nextcloud/settings.dart';
import 'package:test/test.dart';

import 'helper.dart';

Future<void> main() async {
  group('settings', () {
    late DockerImage image;
    setUpAll(() async => image = await getDockerImage());

    late DockerContainer container;
    late TestNextcloudClient client;
    setUp(() async {
      container = await getDockerContainer(image);
      client = await getTestClient(
        container,
        username: 'admin',
      );
    });
    tearDown(() => container.destroy());

    test('Download log file', () async {
      final response = await client.settings.logSettings.download();
      final logs = utf8.decode(response.body);
      expect(logs, await container.nextcloudLogs());
    });
  });
}
