import 'package:nextcloud/src/api/password_policy/password_policy.openapi.dart';
import 'package:nextcloud/src/nextcloud_client.dart';

export 'package:nextcloud/src/api/password_policy/password_policy.openapi.dart';

/// ID for the password_policy app.
const String appID = 'password_policy';

/// Client for the password_policy APIs.
extension PasswordPolicyExtension on NextcloudClient {
  static final _passwordPolicy = Expando<$Client>();

  /// Client for the password_policy APIs.
  $Client get passwordPolicy => _passwordPolicy[this] ??= $Client.fromClient(this);
}
