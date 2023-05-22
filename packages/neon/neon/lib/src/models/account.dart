part of '../../neon.dart';

Future<Account> getAccount(
  final PackageInfo packageInfo,
  final String serverURL,
  final String loginName,
  final String password,
) async {
  final username = (await NextcloudClient(
    serverURL,
    loginName: loginName,
    password: password,
  ).provisioningApi.getCurrentUser())
      .ocs
      .data
      .id;
  return Account(
    serverURL: serverURL,
    loginName: loginName,
    username: username,
    password: password,
    userAgent: userAgent(packageInfo),
  );
}

String userAgent(final PackageInfo packageInfo) {
  var buildNumber = packageInfo.buildNumber;
  if (buildNumber == '') {
    buildNumber = '1';
  }
  return 'Neon ${packageInfo.version}+$buildNumber';
}

@JsonSerializable()
class Account {
  Account({
    required this.serverURL,
    required this.loginName,
    required this.username,
    this.password,
    this.userAgent,
  });

  factory Account.fromJson(final Map<String, dynamic> json) => _$AccountFromJson(json);
  Map<String, dynamic> toJson() => _$AccountToJson(this);

  final String serverURL;
  final String loginName;
  final String username;
  final String? password;
  final String? userAgent;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(final Object other) =>
      other is Account &&
      other.serverURL == serverURL &&
      other.loginName == loginName &&
      other.username == username &&
      other.password == password &&
      other.userAgent == userAgent;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => serverURL.hashCode + username.hashCode;

  String get id => client.id;

  NextcloudClient? _client;

  NextcloudClient get client => _client ??= NextcloudClient(
        serverURL,
        loginName: loginName,
        username: username,
        password: password,
        userAgentOverride: userAgent,
      );
}

Map<String, String> _idCache = {};

extension NextcloudClientHelpers on NextcloudClient {
  String get id {
    final key = '$username@$baseURL';
    if (_idCache[key] != null) {
      return _idCache[key]!;
    }
    return _idCache[key] = sha1.convert(utf8.encode(key)).toString();
  }

  String get humanReadableID {
    final uri = Uri.parse(baseURL);
    // Maybe also show path if it is not '/' ?
    return '${username!}@${uri.port != 443 ? '${uri.host}:${uri.port}' : uri.host}';
  }
}

extension AccountFind on List<Account> {
  Account? find(final String accountID) {
    for (final account in this) {
      if (account.id == accountID) {
        return account;
      }
    }

    return null;
  }
}
