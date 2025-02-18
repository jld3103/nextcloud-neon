import 'dart:async';
import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:cookie_store/cookie_store.dart';
import 'package:http/http.dart' as http;
import 'package:interceptor_http_client/interceptor_http_client.dart';
import 'package:meta/meta.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud_test/src/fixture_interceptor.dart';
import 'package:nextcloud_test/src/fixtures.dart';
import 'package:nextcloud_test/src/models/models.dart';
import 'package:nextcloud_test/src/test_target/docker_container.dart';
import 'package:nextcloud_test/src/test_target/local.dart';
import 'package:version/version.dart';

/// Factory for creating [TestTargetInstance]s.
@internal
abstract class TestTargetFactory<T extends TestTargetInstance> {
  /// The instance of the [TestTargetFactory].
  static final TestTargetFactory instance = TestTargetFactory._create();

  /// Creates a new [TestTargetFactory].
  static TestTargetFactory _create() {
    final dir = Platform.environment['DIR'];
    final url = Platform.environment['URL'];

    if (url != null || dir != null) {
      // Fail hard if the variables are not properly set to avoid a fallback to docker.
      return LocalFactory(
        dir: dir!,
        url: Uri.parse(url!),
      );
    }

    return DockerContainerFactory();
  }

  /// Spawns a new [T].
  FutureOr<T> spawn(Preset preset);

  /// Returns the available presets for the factory.
  late BuiltListMultimap<String, Version> presets = getPresets();

  /// Generates the presets.
  ///
  /// Use the cached version [presets] instead.
  @protected
  BuiltListMultimap<String, Version> getPresets();
}

/// Instance of a test target.
@internal
abstract class TestTargetInstance {
  /// Destroys the instance.
  FutureOr<void> destroy();

  /// URL where the target is available.
  Uri get url;

  /// Creates an app password for [username] on the instance.
  Future<String> createAppPassword(String username);

  /// Creates a new [NextcloudClient] for a given [username].
  ///
  /// It is expected that the password of the user matches the its [username].
  Future<NextcloudClient> createClient({
    String? username = 'user1',
  }) async {
    String? appPassword;
    if (username != null) {
      appPassword = await createAppPassword(username);
    }

    final httpClient = InterceptorHttpClient(
      baseClient: http.Client(),
      interceptors: BuiltList([
        CookieStoreInterceptor(
          cookieStore: CookieStore(),
        ),
        const FixtureInterceptor(appendFixture: appendFixture),
      ]),
    );

    return NextcloudClient(
      url,
      loginName: username,
      password: username,
      appPassword: appPassword,
      httpClient: httpClient,
    );
  }
}
