# nextcloud

A Nextcloud API client written in Dart.

If you want to implement a Flutter app based on Nextcloud, checkout the [Neon project](https://github.com/nextcloud/neon) which provides a framework for this use-case and also develops this package.

## Usage

### Authentication

There are multiple ways to authenticate.  
First there is HTTP Basic auth which works with the normal user credentials (e-mail and other identifiers also work):
```dart
final client = NextcloudClient(
    Uri.parse('http://localhost'),
    loginName: 'admin',
    password: 'admin',
);
```

Secondly there is Http Bearer auth which works with app passwords:
```dart
final client = NextcloudClient(
    Uri.parse('http://localhost'),
    loginName: 'admin',
    appPassword: 'xxxxx-xxxxx-xxxxx-xxxx-xxxxx',
);
```

Not all endpoints work with just HTTP Basic auth, so it is advised to use app passwords obtained either directly in the Web UI by the user or using the [login flow](https://docs.nextcloud.com/server/latest/developer_manual/client_apis/LoginFlow/index.html#login-flow-v2).  
Some endpoints do not need any authentication at all or provide extended information when the request is optionally authenticated.

**Note**
Flutter applications may require [additional configuration](https://docs.flutter.dev/data-and-backend/networking#platform-notes) to make HTTP requests.


### Endpoints

It is not guaranteed that an API request will work unless the app is installed and enabled on the server (and has a supported version).  

To get an easier overview of the available endpoints you can browse the [server OpenAPI documentation](https://docs.nextcloud.com/server/latest/developer_manual/_static/openapi.html), but be aware that the package might not be in sync with it.  
Alternatively you can also go to https://pub.dev/documentation/nextcloud/latest.

The endpoints are grouped by app and most apps also group their endpoints again.
They can be accessed using getters on the `NextcloudClient`.

For an example checkout the [example](https://github.com/nextcloud/neon/blob/main/packages/nextcloud/example/example.dart).  

## Compatibility/Support policy

[Do not edit manually below]: #

| Component                                                                          | Supported versions (1) |
|------------------------------------------------------------------------------------|------------------------|
| [Server](https://github.com/nextcloud/server) (2)                                  | 28 - 30                |
| [Cookbook app](https://github.com/nextcloud/cookbook)                              | 0.11                   |
| [User account deletion app](https://framagit.org/framasoft/nextcloud/drop_account) | 2.4 - 2.7              |
| [News app](https://github.com/nextcloud/news)                                      | 25 - 25.3              |
| [Notes app](https://github.com/nextcloud/notes)                                    | 4.8 - 4.11             |
| [Notifications app](https://github.com/nextcloud/notifications)                    | 28 - 30                |
| [Talk app](https://github.com/nextcloud/spreed)                                    | 18 - 20.1              |
| [Tables app](https://github.com/nextcloud/tables)                                  | 0.6 - 0.9              |
| [NextPush app](https://codeberg.org/NextPush/uppush)                               | 1.4 - 2.2              |

[Do not edit manually above]: #

1: Other versions might be supported too or at least mostly working, but we do not test against those.  
2: Server includes the following apps: comments, core, dashboard, dav, files, files_external, files_reminders, files_sharing, files_trashbin, files_versions, provisioning_api, settings, sharebymail, systemtags, theming, updatenotification, user_ldap, user_status, weather_status, webhook_listeners and WebDAV.  

We aim to support all currently maintained server versions and all app versions that support those server versions.
The currently maintained server versions can be found here: https://github.com/nextcloud/server/wiki/Maintenance-and-Release-Schedule.
Older versions might still be supported and tested, but we do not guarantee anything beyond the EOL date of these versions.

To ensure this package is compatible with the supported server versions we run API unit tests.
Since we do not cover all endpoints we can not claim compatibility for endpoints we do not test against.
Even if there are unit tests for an endpoint we can not guarantee that it will work fine in every scenario.

Please report any compatibility problems (if you are using a compatible server version) and feel free to add unit tests for endpoints you depend on.
This will increase our test coverage and enables everyone to work more confidently with the endpoints.
