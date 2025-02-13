import 'package:meta/meta.dart';
import 'package:nextcloud/core.dart' as $core;
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/provisioning_api.dart' as $provisioning_api;

/// An AuthenticationClient client mock for testing.
@internal
@visibleForTesting
AuthenticationClient? mockedClient;

/// A client handling authentication APIs for easier unit testing.
@internal
class AuthenticationClient {
  const AuthenticationClient({
    required this.core,
    required this.appPassword,
    required this.clientFlowLoginV2,
    required this.users,
    required this.wipe,
  });

  final $core.$Client core;

  final $core.$AppPasswordClient appPassword;

  final $core.$ClientFlowLoginV2Client clientFlowLoginV2;

  final $provisioning_api.$UsersClient users;

  final $core.$WipeClient wipe;
}

/// Extension for getting the [AuthenticationClient].
@internal
extension AuthenticationClientExtension on NextcloudClient {
  /// Returns the [mockedClient] or build a [AuthenticationClient].
  AuthenticationClient get authentication =>
      mockedClient ??
      AuthenticationClient(
        core: core,
        appPassword: core.appPassword,
        clientFlowLoginV2: core.clientFlowLoginV2,
        users: provisioningApi.users,
        wipe: core.wipe,
      );
}
