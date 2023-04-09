import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:cookie_jar/cookie_jar.dart';

export 'package:cookie_jar/cookie_jar.dart';

part 'nextcloud.openapi.g.dart';

extension NextcloudHttpClientResponseBody on HttpClientResponse {
  Future<Uint8List> get bodyBytes async {
    final chunks = await toList();
    if (chunks.isEmpty) {
      return Uint8List(0);
    }
    return Uint8List.fromList(chunks.reduce((final value, final element) => [...value, ...element]));
  }

  Future<String> get body async => utf8.decode(await bodyBytes);
}

class NextcloudResponse<T, U> {
  NextcloudResponse(
    this.data,
    this.headers,
  );

  final T data;

  final U headers;

  @override
  String toString() => 'NextcloudResponse(data: $data, headers: $headers)';
}

class _Response {
  _Response(
    this.statusCode,
    this.headers,
    this.body,
  );

  final int statusCode;

  final Map<String, String> headers;

  final Uint8List body;

  @override
  String toString() => '_Response(statusCode: $statusCode, headers: $headers, body: ${utf8.decode(body)})';
}

class NextcloudApiException extends _Response implements Exception {
  NextcloudApiException(
    super.statusCode,
    super.headers,
    super.body,
  );

  factory NextcloudApiException.fromResponse(_Response response) => NextcloudApiException(
        response.statusCode,
        response.headers,
        response.body,
      );

  @override
  String toString() =>
      'NextcloudApiException(statusCode: ${super.statusCode}, headers: ${super.headers}, body: ${utf8.decode(super.body)})';
}

abstract class NextcloudAuthentication {
  String get id;
  Map<String, String> get headers;
}

class NextcloudHttpBasicAuthentication extends NextcloudAuthentication {
  NextcloudHttpBasicAuthentication({
    required this.username,
    required this.password,
  });

  final String username;

  final String password;

  @override
  String get id => 'basic_auth';
  @override
  Map<String, String> get headers => {
        'Authorization': 'Basic ${base64.encode(utf8.encode('$username:$password'))}',
      };
}

class NextcloudClient {
  NextcloudClient(
    this.baseURL, {
    Map<String, String>? baseHeaders,
    String? userAgent,
    HttpClient? httpClient,
    this.cookieJar,
    this.authentications = const [],
  }) {
    this.baseHeaders = {
      if (baseHeaders != null) ...{
        ...baseHeaders,
      },
    };
    this.httpClient = (httpClient ?? HttpClient())..userAgent = userAgent;
  }

  final String baseURL;

  late final Map<String, String> baseHeaders;

  late final HttpClient httpClient;

  final CookieJar? cookieJar;

  final List<NextcloudAuthentication> authentications;

  Future<_Response> doRequest(
    String method,
    String path,
    Map<String, String> headers,
    Uint8List? body,
  ) async {
    final uri = Uri.parse('$baseURL$path');
    final request = await httpClient.openUrl(method, uri);
    for (final header in {...baseHeaders, ...headers}.entries) {
      request.headers.add(header.key, header.value);
    }
    if (body != null) {
      request.add(body.toList());
    }
    if (cookieJar != null) {
      request.cookies.addAll(await cookieJar!.loadForRequest(uri));
    }

    final response = await request.close();
    if (cookieJar != null) {
      await cookieJar!.saveFromResponse(uri, response.cookies);
    }
    final responseHeaders = <String, String>{};
    response.headers.forEach((final name, final values) {
      responseHeaders[name] = values.last;
    });
    return _Response(
      response.statusCode,
      responseHeaders,
      await response.bodyBytes,
    );
  }

  NextcloudCoreClient get core => NextcloudCoreClient(this);
  NextcloudNewsClient get news => NextcloudNewsClient(this);
  NextcloudNotesClient get notes => NextcloudNotesClient(this);
  NextcloudNotificationsClient get notifications => NextcloudNotificationsClient(this);
  NextcloudProvisioningApiClient get provisioningApi => NextcloudProvisioningApiClient(this);
  NextcloudUnifiedPushProviderClient get unifiedPushProvider => NextcloudUnifiedPushProviderClient(this);
  NextcloudUserStatusClient get userStatus => NextcloudUserStatusClient(this);
}

class NextcloudCoreClient {
  NextcloudCoreClient(this.rootClient);

  final NextcloudClient rootClient;

  Future<NextcloudCoreServerStatus> getStatus() async {
    var path = '/status.php';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudCoreServerStatus.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<NextcloudCoreServerCapabilities> getCapabilities() async {
    var path = '/ocs/v2.php/cloud/capabilities';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudCoreServerCapabilities.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<NextcloudCoreNavigationApps> getNavigationApps() async {
    var path = '/ocs/v2.php/core/navigation/apps';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudCoreNavigationApps.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<NextcloudCoreLoginFlowInit> initLoginFlow() async {
    var path = '/index.php/login/v2';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    final response = await rootClient.doRequest(
      'post',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudCoreLoginFlowInit.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<NextcloudCoreLoginFlowResult> getLoginFlowResult({required String token}) async {
    var path = '/index.php/login/v2/poll';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    queryParameters['token'] = token;
    final response = await rootClient.doRequest(
      'post',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudCoreLoginFlowResult.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<Uint8List> getPreview({
    String file = '',
    int x = 32,
    int y = 32,
    int a = 0,
    int forceIcon = 1,
    String mode = 'fill',
  }) async {
    var path = '/index.php/core/preview.png';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'image/png',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    if (file != '') {
      queryParameters['file'] = file;
    }
    if (x != 32) {
      queryParameters['x'] = x.toString();
    }
    if (y != 32) {
      queryParameters['y'] = y.toString();
    }
    if (a != 0) {
      queryParameters['a'] = a.toString();
    }
    if (forceIcon != 1) {
      queryParameters['forceIcon'] = forceIcon.toString();
    }
    if (mode != 'fill') {
      queryParameters['mode'] = mode;
    }
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return response.body;
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<Uint8List> getDarkAvatar({
    required String userId,
    required int size,
  }) async {
    var path = '/index.php/avatar/{userId}/{size}/dark';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'image/png',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    path = path.replaceAll('{userId}', Uri.encodeQueryComponent(userId));
    path = path.replaceAll('{size}', Uri.encodeQueryComponent(size.toString()));
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return response.body;
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<Uint8List> getAvatar({
    required String userId,
    required int size,
  }) async {
    var path = '/index.php/avatar/{userId}/{size}';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'image/png',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    path = path.replaceAll('{userId}', Uri.encodeQueryComponent(userId));
    path = path.replaceAll('{size}', Uri.encodeQueryComponent(size.toString()));
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return response.body;
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<NextcloudCoreAutocompleteResult> autocomplete({
    required String search,
    required String itemType,
    required String itemId,
    String? sorter,
    required BuiltList<int> shareTypes,
    int limit = 10,
  }) async {
    var path = '/ocs/v2.php/core/autocomplete/get';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    queryParameters['search'] = search;
    queryParameters['itemType'] = itemType;
    queryParameters['itemId'] = itemId;
    if (sorter != null) {
      queryParameters['sorter'] = sorter;
    }
    queryParameters['shareTypes[]'] = shareTypes.map((final e) => e).map((final e) => e.toString());
    if (limit != 10) {
      queryParameters['limit'] = limit.toString();
    }
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudCoreAutocompleteResult.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }
}

class NextcloudNewsClient {
  NextcloudNewsClient(this.rootClient);

  final NextcloudClient rootClient;

  Future<NextcloudNewsSupportedAPIVersions> getSupportedApiVersions() async {
    var path = '/index.php/apps/news/api';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudNewsSupportedAPIVersions.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<NextcloudNewsListFolders> listFolders() async {
    var path = '/index.php/apps/news/api/v1-3/folders';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudNewsListFolders.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<NextcloudNewsListFolders> createFolder({required String name}) async {
    var path = '/index.php/apps/news/api/v1-3/folders';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    queryParameters['name'] = name;
    final response = await rootClient.doRequest(
      'post',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudNewsListFolders.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future renameFolder({
    required int folderId,
    required String name,
  }) async {
    var path = '/index.php/apps/news/api/v1-3/folders/{folderId}';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{};
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    path = path.replaceAll('{folderId}', Uri.encodeQueryComponent(folderId.toString()));
    queryParameters['name'] = name;
    final response = await rootClient.doRequest(
      'put',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return;
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future deleteFolder({required int folderId}) async {
    var path = '/index.php/apps/news/api/v1-3/folders/{folderId}';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{};
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    path = path.replaceAll('{folderId}', Uri.encodeQueryComponent(folderId.toString()));
    final response = await rootClient.doRequest(
      'delete',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return;
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future markFolderAsRead({
    required int folderId,
    required int newestItemId,
  }) async {
    var path = '/index.php/apps/news/api/v1-3/folders/{folderId}/read';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{};
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    path = path.replaceAll('{folderId}', Uri.encodeQueryComponent(folderId.toString()));
    queryParameters['newestItemId'] = newestItemId.toString();
    final response = await rootClient.doRequest(
      'post',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return;
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<NextcloudNewsListFeeds> listFeeds() async {
    var path = '/index.php/apps/news/api/v1-3/feeds';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudNewsListFeeds.fromJson(json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<NextcloudNewsListFeeds> addFeed({
    required String url,
    int? folderId,
  }) async {
    var path = '/index.php/apps/news/api/v1-3/feeds';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    queryParameters['url'] = url;
    if (folderId != null) {
      queryParameters['folderId'] = folderId.toString();
    }
    final response = await rootClient.doRequest(
      'post',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudNewsListFeeds.fromJson(json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future deleteFeed({required int feedId}) async {
    var path = '/index.php/apps/news/api/v1-3/feeds/{feedId}';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{};
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    path = path.replaceAll('{feedId}', Uri.encodeQueryComponent(feedId.toString()));
    final response = await rootClient.doRequest(
      'delete',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return;
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future moveFeed({
    required int feedId,
    int? folderId,
  }) async {
    var path = '/index.php/apps/news/api/v1-3/feeds/{feedId}/move';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{};
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    path = path.replaceAll('{feedId}', Uri.encodeQueryComponent(feedId.toString()));
    if (folderId != null) {
      queryParameters['folderId'] = folderId.toString();
    }
    final response = await rootClient.doRequest(
      'post',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return;
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future renameFeed({
    required int feedId,
    required String feedTitle,
  }) async {
    var path = '/index.php/apps/news/api/v1-3/feeds/{feedId}/rename';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{};
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    path = path.replaceAll('{feedId}', Uri.encodeQueryComponent(feedId.toString()));
    queryParameters['feedTitle'] = feedTitle;
    final response = await rootClient.doRequest(
      'post',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return;
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future markFeedAsRead({
    required int feedId,
    required int newestItemId,
  }) async {
    var path = '/index.php/apps/news/api/v1-3/feeds/{feedId}/read';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{};
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    path = path.replaceAll('{feedId}', Uri.encodeQueryComponent(feedId.toString()));
    queryParameters['newestItemId'] = newestItemId.toString();
    final response = await rootClient.doRequest(
      'post',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return;
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<NextcloudNewsListArticles> listArticles({
    int type = 3,
    int id = 0,
    int getRead = 1,
    int batchSize = -1,
    int offset = 0,
    int oldestFirst = 0,
  }) async {
    var path = '/index.php/apps/news/api/v1-3/items';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    if (type != 3) {
      queryParameters['type'] = type.toString();
    }
    if (id != 0) {
      queryParameters['id'] = id.toString();
    }
    if (getRead != 1) {
      queryParameters['getRead'] = getRead.toString();
    }
    if (batchSize != -1) {
      queryParameters['batchSize'] = batchSize.toString();
    }
    if (offset != 0) {
      queryParameters['offset'] = offset.toString();
    }
    if (oldestFirst != 0) {
      queryParameters['oldestFirst'] = oldestFirst.toString();
    }
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudNewsListArticles.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<NextcloudNewsListArticles> listUpdatedArticles({
    int type = 3,
    int id = 0,
    int lastModified = 0,
  }) async {
    var path = '/index.php/apps/news/api/v1-3/items/updated';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    if (type != 3) {
      queryParameters['type'] = type.toString();
    }
    if (id != 0) {
      queryParameters['id'] = id.toString();
    }
    if (lastModified != 0) {
      queryParameters['lastModified'] = lastModified.toString();
    }
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudNewsListArticles.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future markArticleAsRead({required int itemId}) async {
    var path = '/index.php/apps/news/api/v1-3/items/{itemId}/read';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{};
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    path = path.replaceAll('{itemId}', Uri.encodeQueryComponent(itemId.toString()));
    final response = await rootClient.doRequest(
      'post',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return;
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future markArticleAsUnread({required int itemId}) async {
    var path = '/index.php/apps/news/api/v1-3/items/{itemId}/unread';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{};
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    path = path.replaceAll('{itemId}', Uri.encodeQueryComponent(itemId.toString()));
    final response = await rootClient.doRequest(
      'post',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return;
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future starArticle({required int itemId}) async {
    var path = '/index.php/apps/news/api/v1-3/items/{itemId}/star';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{};
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    path = path.replaceAll('{itemId}', Uri.encodeQueryComponent(itemId.toString()));
    final response = await rootClient.doRequest(
      'post',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return;
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future unstarArticle({required int itemId}) async {
    var path = '/index.php/apps/news/api/v1-3/items/{itemId}/unstar';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{};
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    path = path.replaceAll('{itemId}', Uri.encodeQueryComponent(itemId.toString()));
    final response = await rootClient.doRequest(
      'post',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return;
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }
}

class NextcloudNotesClient {
  NextcloudNotesClient(this.rootClient);

  final NextcloudClient rootClient;

  Future<BuiltList<NextcloudNotesNote>> getNotes({
    String? category,
    String exclude = '',
    int pruneBefore = 0,
    int chunkSize = 0,
    String? chunkCursor,
    String? ifNoneMatch,
  }) async {
    var path = '/index.php/apps/notes/api/v1/notes';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    if (category != null) {
      queryParameters['category'] = category;
    }
    if (exclude != '') {
      queryParameters['exclude'] = exclude;
    }
    if (pruneBefore != 0) {
      queryParameters['pruneBefore'] = pruneBefore.toString();
    }
    if (chunkSize != 0) {
      queryParameters['chunkSize'] = chunkSize.toString();
    }
    if (chunkCursor != null) {
      queryParameters['chunkCursor'] = chunkCursor;
    }
    if (ifNoneMatch != null) {
      headers['If-None-Match'] = ifNoneMatch;
    }
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return BuiltList<NextcloudNotesNote>((json.decode(utf8.decode(response.body) as String) as List)
          .map((final e) => NextcloudNotesNote.fromJson(e as Map<String, dynamic>)));
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<NextcloudNotesNote> createNote({
    String category = '',
    String title = '',
    String content = '',
    int modified = 0,
    int favorite = 0,
  }) async {
    var path = '/index.php/apps/notes/api/v1/notes';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    if (category != '') {
      queryParameters['category'] = category;
    }
    if (title != '') {
      queryParameters['title'] = title;
    }
    if (content != '') {
      queryParameters['content'] = content;
    }
    if (modified != 0) {
      queryParameters['modified'] = modified.toString();
    }
    if (favorite != 0) {
      queryParameters['favorite'] = favorite.toString();
    }
    final response = await rootClient.doRequest(
      'post',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudNotesNote.fromJson(json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<NextcloudNotesNote> getNote({
    required int id,
    String exclude = '',
    String? ifNoneMatch,
  }) async {
    var path = '/index.php/apps/notes/api/v1/notes/{id}';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    path = path.replaceAll('{id}', Uri.encodeQueryComponent(id.toString()));
    if (exclude != '') {
      queryParameters['exclude'] = exclude;
    }
    if (ifNoneMatch != null) {
      headers['If-None-Match'] = ifNoneMatch;
    }
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudNotesNote.fromJson(json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<NextcloudNotesNote> updateNote({
    required int id,
    String? content,
    int? modified,
    String? title,
    String? category,
    int favorite = 0,
    String? ifMatch,
  }) async {
    var path = '/index.php/apps/notes/api/v1/notes/{id}';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    path = path.replaceAll('{id}', Uri.encodeQueryComponent(id.toString()));
    if (content != null) {
      queryParameters['content'] = content;
    }
    if (modified != null) {
      queryParameters['modified'] = modified.toString();
    }
    if (title != null) {
      queryParameters['title'] = title;
    }
    if (category != null) {
      queryParameters['category'] = category;
    }
    if (favorite != 0) {
      queryParameters['favorite'] = favorite.toString();
    }
    if (ifMatch != null) {
      headers['If-Match'] = ifMatch;
    }
    final response = await rootClient.doRequest(
      'put',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudNotesNote.fromJson(json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<String> deleteNote({required int id}) async {
    var path = '/index.php/apps/notes/api/v1/notes/{id}';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    path = path.replaceAll('{id}', Uri.encodeQueryComponent(id.toString()));
    final response = await rootClient.doRequest(
      'delete',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return ((utf8.decode(response.body) as String) as String);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<NextcloudNotesSettings> getSettings() async {
    var path = '/index.php/apps/notes/api/v1/settings';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudNotesSettings.fromJson(json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<NextcloudNotesSettings> updateSettings({required NextcloudNotesSettings notesSettings}) async {
    var path = '/index.php/apps/notes/api/v1/settings';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    headers['Content-Type'] = 'application/json';
    body = Uint8List.fromList(utf8.encode(json.encode(notesSettings.toJson())));
    final response = await rootClient.doRequest(
      'put',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudNotesSettings.fromJson(json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }
}

class NextcloudNotificationsClient {
  NextcloudNotificationsClient(this.rootClient);

  final NextcloudClient rootClient;

  Future<NextcloudNotificationsListNotifications> listNotifications() async {
    var path = '/ocs/v2.php/apps/notifications/api/v2/notifications';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudNotificationsListNotifications.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<String> deleteAllNotifications() async {
    var path = '/ocs/v2.php/apps/notifications/api/v2/notifications';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    final response = await rootClient.doRequest(
      'delete',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return ((utf8.decode(response.body) as String) as String);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<NextcloudNotificationsGetNotification> getNotification({required int id}) async {
    var path = '/ocs/v2.php/apps/notifications/api/v2/notifications/{id}';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    path = path.replaceAll('{id}', Uri.encodeQueryComponent(id.toString()));
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudNotificationsGetNotification.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<NextcloudEmptyOCS> deleteNotification({required int id}) async {
    var path = '/ocs/v2.php/apps/notifications/api/v2/notifications/{id}';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    path = path.replaceAll('{id}', Uri.encodeQueryComponent(id.toString()));
    final response = await rootClient.doRequest(
      'delete',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudEmptyOCS.fromJson(json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<NextcloudNotificationsPushServerRegistration> registerDevice({
    required String pushTokenHash,
    required String devicePublicKey,
    required String proxyServer,
  }) async {
    var path = '/ocs/v2.php/apps/notifications/api/v2/push';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    queryParameters['pushTokenHash'] = pushTokenHash;
    queryParameters['devicePublicKey'] = devicePublicKey;
    queryParameters['proxyServer'] = proxyServer;
    final response = await rootClient.doRequest(
      'post',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 201) {
      return NextcloudNotificationsPushServerRegistration.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<String> removeDevice() async {
    var path = '/ocs/v2.php/apps/notifications/api/v2/push';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    final response = await rootClient.doRequest(
      'delete',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 202) {
      return ((utf8.decode(response.body) as String) as String);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<NextcloudEmptyOCS> sendAdminNotification({
    required String userId,
    required String shortMessage,
    String longMessage = '',
  }) async {
    var path = '/ocs/v2.php/apps/notifications/api/v2/admin_notifications/{userId}';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    path = path.replaceAll('{userId}', Uri.encodeQueryComponent(userId));
    queryParameters['shortMessage'] = shortMessage;
    if (longMessage != '') {
      queryParameters['longMessage'] = longMessage;
    }
    final response = await rootClient.doRequest(
      'post',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudEmptyOCS.fromJson(json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }
}

class NextcloudProvisioningApiClient {
  NextcloudProvisioningApiClient(this.rootClient);

  final NextcloudClient rootClient;

  Future<NextcloudProvisioningApiUser> getCurrentUser() async {
    var path = '/ocs/v2.php/cloud/user';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudProvisioningApiUser.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<NextcloudProvisioningApiUser> getUser({required String userId}) async {
    var path = '/ocs/v2.php/cloud/users/{userId}';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    path = path.replaceAll('{userId}', Uri.encodeQueryComponent(userId));
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudProvisioningApiUser.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }
}

class NextcloudUnifiedPushProviderClient {
  NextcloudUnifiedPushProviderClient(this.rootClient);

  final NextcloudClient rootClient;

  /// Check if the UnifiedPush provider is present
  Future<NextcloudUnifiedPushProviderCheckResponse200ApplicationJson> check() async {
    var path = '/index.php/apps/uppush';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudUnifiedPushProviderCheckResponse200ApplicationJson.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  /// Set keepalive interval
  ///
  /// This endpoint requires admin access
  Future<NextcloudUnifiedPushProviderSetKeepaliveResponse200ApplicationJson> setKeepalive(
      {required int keepalive}) async {
    var path = '/index.php/apps/uppush/keepalive';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    queryParameters['keepalive'] = keepalive.toString();
    final response = await rootClient.doRequest(
      'put',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudUnifiedPushProviderSetKeepaliveResponse200ApplicationJson.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  /// Request to create a new deviceId
  Future<NextcloudUnifiedPushProviderCreateDeviceResponse200ApplicationJson> createDevice(
      {required String deviceName}) async {
    var path = '/index.php/apps/uppush/device';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    queryParameters['deviceName'] = deviceName;
    final response = await rootClient.doRequest(
      'put',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudUnifiedPushProviderCreateDeviceResponse200ApplicationJson.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  /// Request to get push messages
  ///
  /// This is a public page since it has to be handle by the non-connected app (NextPush app and not Nextcloud-app)
  Future<NextcloudUnifiedPushProviderSyncDeviceResponse401ApplicationJson> syncDevice(
      {required String deviceId}) async {
    var path = '/index.php/apps/uppush/device/{deviceId}';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    path = path.replaceAll('{deviceId}', Uri.encodeQueryComponent(deviceId));
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 401) {
      return NextcloudUnifiedPushProviderSyncDeviceResponse401ApplicationJson.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  /// Delete a device
  Future<NextcloudUnifiedPushProviderDeleteDeviceResponse200ApplicationJson> deleteDevice(
      {required String deviceId}) async {
    var path = '/index.php/apps/uppush/device/{deviceId}';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    path = path.replaceAll('{deviceId}', Uri.encodeQueryComponent(deviceId));
    final response = await rootClient.doRequest(
      'delete',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudUnifiedPushProviderDeleteDeviceResponse200ApplicationJson.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  /// Create an authorization token for a new 3rd party service
  Future<NextcloudUnifiedPushProviderCreateAppResponse200ApplicationJson> createApp({
    required String deviceId,
    required String appName,
  }) async {
    var path = '/index.php/apps/uppush/app';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    queryParameters['deviceId'] = deviceId;
    queryParameters['appName'] = appName;
    final response = await rootClient.doRequest(
      'put',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudUnifiedPushProviderCreateAppResponse200ApplicationJson.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  /// Delete an authorization token
  Future<NextcloudUnifiedPushProviderDeleteAppResponse200ApplicationJson> deleteApp({required String token}) async {
    var path = '/index.php/apps/uppush/app/{token}';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    path = path.replaceAll('{token}', Uri.encodeQueryComponent(token));
    final response = await rootClient.doRequest(
      'delete',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudUnifiedPushProviderDeleteAppResponse200ApplicationJson.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  /// Unifiedpush discovery Following specifications
  Future<NextcloudUnifiedPushProviderUnifiedpushDiscoveryResponse200ApplicationJson> unifiedpushDiscovery(
      {required String token}) async {
    var path = '/index.php/apps/uppush/push/{token}';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    path = path.replaceAll('{token}', Uri.encodeQueryComponent(token));
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudUnifiedPushProviderUnifiedpushDiscoveryResponse200ApplicationJson.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  /// Receive notifications from 3rd parties
  Future<NextcloudUnifiedPushProviderPushResponse201ApplicationJson> push({required String token}) async {
    var path = '/index.php/apps/uppush/push/{token}';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    path = path.replaceAll('{token}', Uri.encodeQueryComponent(token));
    final response = await rootClient.doRequest(
      'post',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 201) {
      return NextcloudUnifiedPushProviderPushResponse201ApplicationJson.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  /// Matrix Gateway discovery
  Future<NextcloudUnifiedPushProviderGatewayMatrixDiscoveryResponse200ApplicationJson> gatewayMatrixDiscovery() async {
    var path = '/index.php/apps/uppush/gateway/matrix';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudUnifiedPushProviderGatewayMatrixDiscoveryResponse200ApplicationJson.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  /// Matrix Gateway
  Future<NextcloudUnifiedPushProviderGatewayMatrixResponse200ApplicationJson> gatewayMatrix() async {
    var path = '/index.php/apps/uppush/gateway/matrix';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    final response = await rootClient.doRequest(
      'post',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudUnifiedPushProviderGatewayMatrixResponse200ApplicationJson.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }
}

class NextcloudUserStatusClient {
  NextcloudUserStatusClient(this.rootClient);

  final NextcloudClient rootClient;

  Future<NextcloudUserStatusGetPublicStatuses> getPublicStatuses() async {
    var path = '/ocs/v2.php/apps/user_status/api/v1/statuses';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudUserStatusGetPublicStatuses.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<NextcloudUserStatusGetPublicStatus> getPublicStatus({required String userId}) async {
    var path = '/ocs/v2.php/apps/user_status/api/v1/statuses/{userId}';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    path = path.replaceAll('{userId}', Uri.encodeQueryComponent(userId));
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudUserStatusGetPublicStatus.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<NextcloudUserStatusGetStatus> getStatus() async {
    var path = '/ocs/v2.php/apps/user_status/api/v1/user_status';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudUserStatusGetStatus.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<NextcloudUserStatusGetStatus> setStatus({required NextcloudUserStatusType statusType}) async {
    var path = '/ocs/v2.php/apps/user_status/api/v1/user_status/status';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    queryParameters['statusType'] = statusType.name;
    final response = await rootClient.doRequest(
      'put',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudUserStatusGetStatus.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<NextcloudUserStatusGetStatus> setPredefinedMessage({
    required String messageId,
    int? clearAt,
  }) async {
    var path = '/ocs/v2.php/apps/user_status/api/v1/user_status/message/predefined';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    queryParameters['messageId'] = messageId;
    if (clearAt != null) {
      queryParameters['clearAt'] = clearAt.toString();
    }
    final response = await rootClient.doRequest(
      'put',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudUserStatusGetStatus.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<NextcloudUserStatusGetStatus> setCustomMessage({
    String? statusIcon,
    String? message,
    int? clearAt,
  }) async {
    var path = '/ocs/v2.php/apps/user_status/api/v1/user_status/message/custom';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    if (statusIcon != null) {
      queryParameters['statusIcon'] = statusIcon;
    }
    if (message != null) {
      queryParameters['message'] = message;
    }
    if (clearAt != null) {
      queryParameters['clearAt'] = clearAt.toString();
    }
    final response = await rootClient.doRequest(
      'put',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudUserStatusGetStatus.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future clearMessage() async {
    var path = '/ocs/v2.php/apps/user_status/api/v1/user_status/message';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{};
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    final response = await rootClient.doRequest(
      'delete',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return;
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<NextcloudUserStatusPredefinedStatuses> getPredefinedStatuses() async {
    var path = '/ocs/v2.php/apps/user_status/api/v1/predefined_statuses';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudUserStatusPredefinedStatuses.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }

  Future<NextcloudUserStatusHeartbeat> heartbeat({required NextcloudUserStatusType status}) async {
    var path = '/ocs/v2.php/apps/user_status/api/v1/heartbeat';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.map((final a) => a.id).contains('basic_auth')) {
      headers.addAll(rootClient.authentications.singleWhere((final a) => a.id == 'basic_auth').headers);
    } else {
      throw Exception('Missing authentication for basic_auth');
    }
    queryParameters['status'] = status.name;
    final response = await rootClient.doRequest(
      'put',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return NextcloudUserStatusHeartbeat.fromJson(
          json.decode(utf8.decode(response.body) as String) as Map<String, dynamic>);
    }
    throw NextcloudApiException.fromResponse(response); // coverage:ignore-line
  }
}

@JsonSerializable()
class NextcloudCoreServerStatus {
  NextcloudCoreServerStatus({
    required this.installed,
    required this.maintenance,
    required this.needsDbUpgrade,
    required this.version,
    required this.versionstring,
    required this.edition,
    required this.productname,
    required this.extendedSupport,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerStatus.fromJson(Map<String, dynamic> json) => _$NextcloudCoreServerStatusFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerStatus.fromJsonString(String data) =>
      NextcloudCoreServerStatus.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool installed;

  final bool maintenance;

  final bool needsDbUpgrade;

  final String version;

  final String versionstring;

  final String edition;

  final String productname;

  final bool extendedSupport;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreServerStatusToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerStatus? data) => data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudOCSMeta {
  NextcloudOCSMeta({
    required this.status,
    required this.statuscode,
    this.message,
    this.totalitems,
    this.itemsperpage,
  });

  // coverage:ignore-start
  factory NextcloudOCSMeta.fromJson(Map<String, dynamic> json) => _$NextcloudOCSMetaFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudOCSMeta.fromJsonString(String data) =>
      NextcloudOCSMeta.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final String status;

  final int statuscode;

  final String? message;

  final String? totalitems;

  final String? itemsperpage;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudOCSMetaToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudOCSMeta? data) => data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudCoreServerCapabilities_Ocs_Data_Version {
  NextcloudCoreServerCapabilities_Ocs_Data_Version({
    this.major,
    this.minor,
    this.micro,
    this.string,
    this.edition,
    this.extendedSupport,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Version.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_VersionFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Version.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Version.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final int? major;

  final int? minor;

  final int? micro;

  final String? string;

  final String? edition;

  final bool? extendedSupport;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreServerCapabilities_Ocs_Data_VersionToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Version? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Core {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Core({
    this.pollinterval,
    this.webdavRoot,
    this.referenceApi,
    this.referenceRegex,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Core.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_CoreFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Core.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Core.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final int? pollinterval;

  @JsonKey(name: 'webdav-root')
  final String? webdavRoot;

  @JsonKey(name: 'reference-api')
  final bool? referenceApi;

  @JsonKey(name: 'reference-regex')
  final String? referenceRegex;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_CoreToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Core? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Bruteforce {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Bruteforce({this.delay});

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Bruteforce.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_BruteforceFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Bruteforce.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Bruteforce.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final int? delay;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_BruteforceToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Bruteforce? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_MetadataAvailable {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_MetadataAvailable({
    this.size,
    this.gps,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_MetadataAvailable.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_MetadataAvailableFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_MetadataAvailable.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_MetadataAvailable.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final BuiltList<String>? size;

  final BuiltList<String>? gps;

  // coverage:ignore-start
  Map<String, dynamic> toJson() =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_MetadataAvailableToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_MetadataAvailable? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Files_DirectEditing {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Files_DirectEditing({
    this.url,
    this.etag,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Files_DirectEditing.fromJson(
          Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Files_DirectEditingFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Files_DirectEditing.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Files_DirectEditing.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final String? url;

  final String? etag;

  // coverage:ignore-start
  Map<String, dynamic> toJson() =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Files_DirectEditingToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Files_DirectEditing? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Files {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Files({
    this.bigfilechunking,
    this.blacklistedFiles,
    this.directEditing,
    this.comments,
    this.undelete,
    this.versioning,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Files.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Files.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Files.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool? bigfilechunking;

  @JsonKey(name: 'blacklisted_files')
  final BuiltList<String>? blacklistedFiles;

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Files_DirectEditing? directEditing;

  final bool? comments;

  final bool? undelete;

  final bool? versioning;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Files? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Activity {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Activity({this.apiv2});

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Activity.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_ActivityFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Activity.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Activity.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final BuiltList<String>? apiv2;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_ActivityToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Activity? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Status {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Status({this.globalScale});

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Status.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_StatusFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Status.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Status.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool? globalScale;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_StatusToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Status? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Settings {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Settings({
    this.frontendEnabled,
    this.allowedCircles,
    this.allowedUserTypes,
    this.membersLimit,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Settings.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_SettingsFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Settings.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Settings.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool? frontendEnabled;

  final int? allowedCircles;

  final int? allowedUserTypes;

  final int? membersLimit;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_SettingsToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Settings? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle_Constants_Source {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle_Constants_Source({
    this.core,
    this.extra,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle_Constants_Source.fromJson(
          Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle_Constants_SourceFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle_Constants_Source.fromJsonString(
          String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle_Constants_Source.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final JsonObject? core;

  final JsonObject? extra;

  // coverage:ignore-start
  Map<String, dynamic> toJson() =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle_Constants_SourceToJson(this);
  // coverage:ignore-end
  static String? toJsonString(
          NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle_Constants_Source? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle_Constants {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle_Constants({
    this.flags,
    this.source,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle_Constants.fromJson(
          Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle_ConstantsFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle_Constants.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle_Constants.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final JsonObject? flags;

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle_Constants_Source? source;

  // coverage:ignore-start
  Map<String, dynamic> toJson() =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle_ConstantsToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle_Constants? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle_Config {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle_Config({
    this.coreFlags,
    this.systemFlags,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle_Config.fromJson(
          Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle_ConfigFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle_Config.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle_Config.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final BuiltList<int>? coreFlags;

  final BuiltList<int>? systemFlags;

  // coverage:ignore-start
  Map<String, dynamic> toJson() =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle_ConfigToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle_Config? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle({
    this.constants,
    this.config,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_CircleFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle_Constants? constants;

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle_Config? config;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_CircleToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Member_Constants {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Member_Constants({this.level});

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Member_Constants.fromJson(
          Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Member_ConstantsFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Member_Constants.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Member_Constants.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final JsonObject? level;

  // coverage:ignore-start
  Map<String, dynamic> toJson() =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Member_ConstantsToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Member_Constants? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Member {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Member({
    this.constants,
    this.type,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Member.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_MemberFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Member.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Member.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Member_Constants? constants;

  final JsonObject? type;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_MemberToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Member? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles({
    this.version,
    this.status,
    this.settings,
    this.circle,
    this.member,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_CirclesFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final String? version;

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Status? status;

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Settings? settings;

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle? circle;

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Member? member;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_CirclesToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Ocm_ResourceTypes_Protocols {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Ocm_ResourceTypes_Protocols({this.webdav});

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Ocm_ResourceTypes_Protocols.fromJson(
          Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Ocm_ResourceTypes_ProtocolsFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Ocm_ResourceTypes_Protocols.fromJsonString(
          String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Ocm_ResourceTypes_Protocols.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final String? webdav;

  // coverage:ignore-start
  Map<String, dynamic> toJson() =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Ocm_ResourceTypes_ProtocolsToJson(this);
  // coverage:ignore-end
  static String? toJsonString(
          NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Ocm_ResourceTypes_Protocols? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Ocm_ResourceTypes {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Ocm_ResourceTypes({
    this.name,
    this.shareTypes,
    this.protocols,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Ocm_ResourceTypes.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Ocm_ResourceTypesFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Ocm_ResourceTypes.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Ocm_ResourceTypes.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final String? name;

  final BuiltList<String>? shareTypes;

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Ocm_ResourceTypes_Protocols? protocols;

  // coverage:ignore-start
  Map<String, dynamic> toJson() =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Ocm_ResourceTypesToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Ocm_ResourceTypes? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Ocm {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Ocm({
    this.enabled,
    this.apiVersion,
    this.endPoint,
    this.resourceTypes,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Ocm.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_OcmFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Ocm.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Ocm.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool? enabled;

  final String? apiVersion;

  final String? endPoint;

  final BuiltList<NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Ocm_ResourceTypes>? resourceTypes;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_OcmToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Ocm? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Dav {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Dav({
    this.bulkupload,
    this.chunking,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Dav.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_DavFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Dav.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Dav.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final String? bulkupload;

  final String? chunking;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_DavToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Dav? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_Password {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_Password({
    this.enforced,
    this.askForOptionalPassword,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_Password.fromJson(
          Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_PasswordFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_Password.fromJsonString(
          String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_Password.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool? enforced;

  final bool? askForOptionalPassword;

  // coverage:ignore-start
  Map<String, dynamic> toJson() =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_PasswordToJson(this);
  // coverage:ignore-end
  static String? toJsonString(
          NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_Password? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_ExpireDate {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_ExpireDate({this.enabled});

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_ExpireDate.fromJson(
          Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_ExpireDateFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_ExpireDate.fromJsonString(
          String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_ExpireDate.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool? enabled;

  // coverage:ignore-start
  Map<String, dynamic> toJson() =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_ExpireDateToJson(this);
  // coverage:ignore-end
  static String? toJsonString(
          NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_ExpireDate? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_ExpireDateInternal {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_ExpireDateInternal({this.enabled});

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_ExpireDateInternal.fromJson(
          Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_ExpireDateInternalFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_ExpireDateInternal.fromJsonString(
          String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_ExpireDateInternal.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool? enabled;

  // coverage:ignore-start
  Map<String, dynamic> toJson() =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_ExpireDateInternalToJson(this);
  // coverage:ignore-end
  static String? toJsonString(
          NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_ExpireDateInternal? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_ExpireDateRemote {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_ExpireDateRemote({this.enabled});

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_ExpireDateRemote.fromJson(
          Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_ExpireDateRemoteFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_ExpireDateRemote.fromJsonString(
          String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_ExpireDateRemote.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool? enabled;

  // coverage:ignore-start
  Map<String, dynamic> toJson() =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_ExpireDateRemoteToJson(this);
  // coverage:ignore-end
  static String? toJsonString(
          NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_ExpireDateRemote? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public({
    this.enabled,
    this.password,
    this.expireDate,
    this.multipleLinks,
    this.expireDateInternal,
    this.expireDateRemote,
    this.sendMail,
    this.upload,
    this.uploadFilesDrop,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public.fromJson(
          Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_PublicFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool? enabled;

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_Password? password;

  @JsonKey(name: 'expire_date')
  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_ExpireDate? expireDate;

  @JsonKey(name: 'multiple_links')
  final bool? multipleLinks;

  @JsonKey(name: 'expire_date_internal')
  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_ExpireDateInternal?
      expireDateInternal;

  @JsonKey(name: 'expire_date_remote')
  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_ExpireDateRemote? expireDateRemote;

  @JsonKey(name: 'send_mail')
  final bool? sendMail;

  final bool? upload;

  @JsonKey(name: 'upload_files_drop')
  final bool? uploadFilesDrop;

  // coverage:ignore-start
  Map<String, dynamic> toJson() =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_PublicToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_User_ExpireDate {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_User_ExpireDate({this.enabled});

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_User_ExpireDate.fromJson(
          Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_User_ExpireDateFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_User_ExpireDate.fromJsonString(
          String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_User_ExpireDate.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool? enabled;

  // coverage:ignore-start
  Map<String, dynamic> toJson() =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_User_ExpireDateToJson(this);
  // coverage:ignore-end
  static String? toJsonString(
          NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_User_ExpireDate? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_User {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_User({
    this.sendMail,
    this.expireDate,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_User.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_UserFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_User.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_User.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  @JsonKey(name: 'send_mail')
  final bool? sendMail;

  @JsonKey(name: 'expire_date')
  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_User_ExpireDate? expireDate;

  // coverage:ignore-start
  Map<String, dynamic> toJson() =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_UserToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_User? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Group_ExpireDate {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Group_ExpireDate({this.enabled});

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Group_ExpireDate.fromJson(
          Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Group_ExpireDateFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Group_ExpireDate.fromJsonString(
          String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Group_ExpireDate.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool? enabled;

  // coverage:ignore-start
  Map<String, dynamic> toJson() =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Group_ExpireDateToJson(this);
  // coverage:ignore-end
  static String? toJsonString(
          NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Group_ExpireDate? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Group {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Group({
    this.enabled,
    this.expireDate,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Group.fromJson(
          Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_GroupFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Group.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Group.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool? enabled;

  @JsonKey(name: 'expire_date')
  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Group_ExpireDate? expireDate;

  // coverage:ignore-start
  Map<String, dynamic> toJson() =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_GroupToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Group? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Federation_ExpireDate {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Federation_ExpireDate({this.enabled});

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Federation_ExpireDate.fromJson(
          Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Federation_ExpireDateFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Federation_ExpireDate.fromJsonString(
          String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Federation_ExpireDate.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool? enabled;

  // coverage:ignore-start
  Map<String, dynamic> toJson() =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Federation_ExpireDateToJson(this);
  // coverage:ignore-end
  static String? toJsonString(
          NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Federation_ExpireDate? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Federation_ExpireDateSupported {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Federation_ExpireDateSupported({this.enabled});

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Federation_ExpireDateSupported.fromJson(
          Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Federation_ExpireDateSupportedFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Federation_ExpireDateSupported.fromJsonString(
          String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Federation_ExpireDateSupported.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool? enabled;

  // coverage:ignore-start
  Map<String, dynamic> toJson() =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Federation_ExpireDateSupportedToJson(this);
  // coverage:ignore-end
  static String? toJsonString(
          NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Federation_ExpireDateSupported? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Federation {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Federation({
    this.outgoing,
    this.incoming,
    this.expireDate,
    this.expireDateSupported,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Federation.fromJson(
          Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_FederationFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Federation.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Federation.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool? outgoing;

  final bool? incoming;

  @JsonKey(name: 'expire_date')
  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Federation_ExpireDate? expireDate;

  @JsonKey(name: 'expire_date_supported')
  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Federation_ExpireDateSupported?
      expireDateSupported;

  // coverage:ignore-start
  Map<String, dynamic> toJson() =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_FederationToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Federation? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharee {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharee({
    this.queryLookupDefault,
    this.alwaysShowUnique,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharee.fromJson(
          Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_ShareeFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharee.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharee.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  @JsonKey(name: 'query_lookup_default')
  final bool? queryLookupDefault;

  @JsonKey(name: 'always_show_unique')
  final bool? alwaysShowUnique;

  // coverage:ignore-start
  Map<String, dynamic> toJson() =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_ShareeToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharee? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail_UploadFilesDrop {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail_UploadFilesDrop({this.enabled});

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail_UploadFilesDrop.fromJson(
          Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail_UploadFilesDropFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail_UploadFilesDrop.fromJsonString(
          String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail_UploadFilesDrop.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool? enabled;

  // coverage:ignore-start
  Map<String, dynamic> toJson() =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail_UploadFilesDropToJson(this);
  // coverage:ignore-end
  static String? toJsonString(
          NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail_UploadFilesDrop? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail_Password {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail_Password({
    this.enabled,
    this.enforced,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail_Password.fromJson(
          Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail_PasswordFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail_Password.fromJsonString(
          String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail_Password.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool? enabled;

  final bool? enforced;

  // coverage:ignore-start
  Map<String, dynamic> toJson() =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail_PasswordToJson(this);
  // coverage:ignore-end
  static String? toJsonString(
          NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail_Password? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail_ExpireDate {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail_ExpireDate({
    this.enabled,
    this.enforced,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail_ExpireDate.fromJson(
          Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail_ExpireDateFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail_ExpireDate.fromJsonString(
          String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail_ExpireDate.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool? enabled;

  final bool? enforced;

  // coverage:ignore-start
  Map<String, dynamic> toJson() =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail_ExpireDateToJson(this);
  // coverage:ignore-end
  static String? toJsonString(
          NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail_ExpireDate? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail({
    this.enabled,
    this.sendPasswordByMail,
    this.uploadFilesDrop,
    this.password,
    this.expireDate,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail.fromJson(
          Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_SharebymailFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool? enabled;

  @JsonKey(name: 'send_password_by_mail')
  final bool? sendPasswordByMail;

  @JsonKey(name: 'upload_files_drop')
  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail_UploadFilesDrop? uploadFilesDrop;

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail_Password? password;

  @JsonKey(name: 'expire_date')
  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail_ExpireDate? expireDate;

  // coverage:ignore-start
  Map<String, dynamic> toJson() =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_SharebymailToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing({
    this.apiEnabled,
    this.public,
    this.resharing,
    this.user,
    this.groupSharing,
    this.group,
    this.defaultPermissions,
    this.federation,
    this.sharee,
    this.sharebymail,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharingFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  @JsonKey(name: 'api_enabled')
  final bool? apiEnabled;

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public? public;

  final bool? resharing;

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_User? user;

  @JsonKey(name: 'group_sharing')
  final bool? groupSharing;

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Group? group;

  @JsonKey(name: 'default_permissions')
  final int? defaultPermissions;

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Federation? federation;

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharee? sharee;

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail? sharebymail;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharingToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Notes {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Notes({
    this.apiVersion,
    this.version,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Notes.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_NotesFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Notes.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Notes.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  @JsonKey(name: 'api_version')
  final BuiltList<String>? apiVersion;

  final String? version;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_NotesToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Notes? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Notifications {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Notifications({
    this.ocsEndpoints,
    this.push,
    this.adminNotifications,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Notifications.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_NotificationsFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Notifications.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Notifications.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  @JsonKey(name: 'ocs-endpoints')
  final BuiltList<String>? ocsEndpoints;

  final BuiltList<String>? push;

  @JsonKey(name: 'admin-notifications')
  final BuiltList<String>? adminNotifications;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_NotificationsToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Notifications? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_PasswordPolicy_Api {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_PasswordPolicy_Api({
    this.generate,
    this.validate,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_PasswordPolicy_Api.fromJson(
          Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_PasswordPolicy_ApiFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_PasswordPolicy_Api.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_PasswordPolicy_Api.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final String? generate;

  final String? validate;

  // coverage:ignore-start
  Map<String, dynamic> toJson() =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_PasswordPolicy_ApiToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_PasswordPolicy_Api? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_PasswordPolicy {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_PasswordPolicy({
    this.minLength,
    this.enforceNonCommonPassword,
    this.enforceNumericCharacters,
    this.enforceSpecialCharacters,
    this.enforceUpperLowerCase,
    this.api,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_PasswordPolicy.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_PasswordPolicyFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_PasswordPolicy.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_PasswordPolicy.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final int? minLength;

  final bool? enforceNonCommonPassword;

  final bool? enforceNumericCharacters;

  final bool? enforceSpecialCharacters;

  final bool? enforceUpperLowerCase;

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_PasswordPolicy_Api? api;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_PasswordPolicyToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_PasswordPolicy? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_ProvisioningApi {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_ProvisioningApi({
    this.version,
    this.accountPropertyScopesVersion,
    this.accountPropertyScopesFederatedEnabled,
    this.accountPropertyScopesPublishedEnabled,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_ProvisioningApi.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_ProvisioningApiFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_ProvisioningApi.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_ProvisioningApi.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final String? version;

  @JsonKey(name: 'AccountPropertyScopesVersion')
  final int? accountPropertyScopesVersion;

  @JsonKey(name: 'AccountPropertyScopesFederatedEnabled')
  final bool? accountPropertyScopesFederatedEnabled;

  @JsonKey(name: 'AccountPropertyScopesPublishedEnabled')
  final bool? accountPropertyScopesPublishedEnabled;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_ProvisioningApiToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_ProvisioningApi? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Theming {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Theming({
    this.name,
    this.url,
    this.slogan,
    this.color,
    this.colorText,
    this.colorElement,
    this.colorElementBright,
    this.colorElementDark,
    this.logo,
    this.background,
    this.backgroundPlain,
    this.backgroundDefault,
    this.logoheader,
    this.favicon,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Theming.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_ThemingFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Theming.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Theming.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final String? name;

  final String? url;

  final String? slogan;

  final String? color;

  @JsonKey(name: 'color-text')
  final String? colorText;

  @JsonKey(name: 'color-element')
  final String? colorElement;

  @JsonKey(name: 'color-element-bright')
  final String? colorElementBright;

  @JsonKey(name: 'color-element-dark')
  final String? colorElementDark;

  final String? logo;

  final String? background;

  @JsonKey(name: 'background-plain')
  final bool? backgroundPlain;

  @JsonKey(name: 'background-default')
  final bool? backgroundDefault;

  final String? logoheader;

  final String? favicon;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_ThemingToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Theming? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_UserStatus {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_UserStatus({
    this.enabled,
    this.supportsEmoji,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_UserStatus.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_UserStatusFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_UserStatus.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_UserStatus.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool? enabled;

  @JsonKey(name: 'supports_emoji')
  final bool? supportsEmoji;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_UserStatusToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_UserStatus? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_WeatherStatus {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_WeatherStatus({this.enabled});

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_WeatherStatus.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_WeatherStatusFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_WeatherStatus.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_WeatherStatus.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool? enabled;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_WeatherStatusToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_WeatherStatus? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable(disallowUnrecognizedKeys: false)
class NextcloudCoreServerCapabilities_Ocs_Data_Capabilities {
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities({
    this.core,
    this.bruteforce,
    this.metadataAvailable,
    this.files,
    this.activity,
    this.circles,
    this.ocm,
    this.dav,
    this.filesSharing,
    this.notes,
    this.notifications,
    this.passwordPolicy,
    this.provisioningApi,
    this.theming,
    this.userStatus,
    this.weatherStatus,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_Data_CapabilitiesFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data_Capabilities.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data_Capabilities.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Core? core;

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Bruteforce? bruteforce;

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_MetadataAvailable? metadataAvailable;

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Files? files;

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Activity? activity;

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles? circles;

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Ocm? ocm;

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Dav? dav;

  @JsonKey(name: 'files_sharing')
  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing? filesSharing;

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Notes? notes;

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Notifications? notifications;

  @JsonKey(name: 'password_policy')
  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_PasswordPolicy? passwordPolicy;

  @JsonKey(name: 'provisioning_api')
  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_ProvisioningApi? provisioningApi;

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Theming? theming;

  @JsonKey(name: 'user_status')
  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_UserStatus? userStatus;

  @JsonKey(name: 'weather_status')
  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_WeatherStatus? weatherStatus;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreServerCapabilities_Ocs_Data_CapabilitiesToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data_Capabilities? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudCoreServerCapabilities_Ocs_Data {
  NextcloudCoreServerCapabilities_Ocs_Data({
    required this.version,
    required this.capabilities,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_Ocs_DataFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs_Data.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs_Data.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudCoreServerCapabilities_Ocs_Data_Version version;

  final NextcloudCoreServerCapabilities_Ocs_Data_Capabilities capabilities;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreServerCapabilities_Ocs_DataToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs_Data? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudCoreServerCapabilities_Ocs {
  NextcloudCoreServerCapabilities_Ocs({
    required this.meta,
    required this.data,
  });

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilities_OcsFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities_Ocs.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities_Ocs.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudOCSMeta meta;

  final NextcloudCoreServerCapabilities_Ocs_Data data;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreServerCapabilities_OcsToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities_Ocs? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudCoreServerCapabilities {
  NextcloudCoreServerCapabilities({required this.ocs});

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreServerCapabilitiesFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreServerCapabilities.fromJsonString(String data) =>
      NextcloudCoreServerCapabilities.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudCoreServerCapabilities_Ocs ocs;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreServerCapabilitiesToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreServerCapabilities? data) =>
      data == null ? null : json.encode(data.toJson());
}

class NextcloudCoreNavigationApps_Ocs_Data_Order {
  NextcloudCoreNavigationApps_Ocs_Data_Order(
    this._data, {
    this.$int,
    this.string,
  });

  factory NextcloudCoreNavigationApps_Ocs_Data_Order.fromJson(dynamic data) {
    int? $int;
    String? string;
    try {
      $int = (data as int);
    } catch (_) {}
    try {
      string = (data as String);
    } catch (_) {}
    assert([$int, string].where((final x) => x != null).length >= 1, 'Need oneOf for $data');
    return NextcloudCoreNavigationApps_Ocs_Data_Order(
      data,
      $int: $int,
      string: string,
    );
  }

  // coverage:ignore-start
  factory NextcloudCoreNavigationApps_Ocs_Data_Order.fromJsonString(String data) =>
      NextcloudCoreNavigationApps_Ocs_Data_Order.fromJson(json.decode(data));
  // coverage:ignore-end

  final dynamic _data;

  final int? $int;

  final String? string;

  // coverage:ignore-start
  dynamic toJson() => _data;
  // coverage:ignore-end
  // coverage:ignore-start
  static String toJsonString(dynamic data) => json.encode(data);
  // coverage:ignore-end
}

@JsonSerializable()
class NextcloudCoreNavigationApps_Ocs_Data {
  NextcloudCoreNavigationApps_Ocs_Data({
    required this.id,
    required this.order,
    required this.href,
    required this.icon,
    required this.type,
    required this.name,
    required this.active,
    required this.classes,
    required this.unread,
  });

  // coverage:ignore-start
  factory NextcloudCoreNavigationApps_Ocs_Data.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreNavigationApps_Ocs_DataFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreNavigationApps_Ocs_Data.fromJsonString(String data) =>
      NextcloudCoreNavigationApps_Ocs_Data.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final String id;

  /// Should always be an integer, but there is a bug. See https://github.com/nextcloud/server/issues/32828
  final NextcloudCoreNavigationApps_Ocs_Data_Order order;

  final String href;

  final String icon;

  final String type;

  final String name;

  final bool active;

  final String classes;

  final int unread;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreNavigationApps_Ocs_DataToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreNavigationApps_Ocs_Data? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudCoreNavigationApps_Ocs {
  NextcloudCoreNavigationApps_Ocs({
    required this.meta,
    required this.data,
  });

  // coverage:ignore-start
  factory NextcloudCoreNavigationApps_Ocs.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreNavigationApps_OcsFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreNavigationApps_Ocs.fromJsonString(String data) =>
      NextcloudCoreNavigationApps_Ocs.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudOCSMeta meta;

  final BuiltList<NextcloudCoreNavigationApps_Ocs_Data> data;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreNavigationApps_OcsToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreNavigationApps_Ocs? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudCoreNavigationApps {
  NextcloudCoreNavigationApps({required this.ocs});

  // coverage:ignore-start
  factory NextcloudCoreNavigationApps.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreNavigationAppsFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreNavigationApps.fromJsonString(String data) =>
      NextcloudCoreNavigationApps.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudCoreNavigationApps_Ocs ocs;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreNavigationAppsToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreNavigationApps? data) => data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudCoreLoginFlowInit_Poll {
  NextcloudCoreLoginFlowInit_Poll({
    required this.token,
    required this.endpoint,
  });

  // coverage:ignore-start
  factory NextcloudCoreLoginFlowInit_Poll.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreLoginFlowInit_PollFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreLoginFlowInit_Poll.fromJsonString(String data) =>
      NextcloudCoreLoginFlowInit_Poll.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final String token;

  final String endpoint;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreLoginFlowInit_PollToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreLoginFlowInit_Poll? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudCoreLoginFlowInit {
  NextcloudCoreLoginFlowInit({
    required this.poll,
    required this.login,
  });

  // coverage:ignore-start
  factory NextcloudCoreLoginFlowInit.fromJson(Map<String, dynamic> json) => _$NextcloudCoreLoginFlowInitFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreLoginFlowInit.fromJsonString(String data) =>
      NextcloudCoreLoginFlowInit.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudCoreLoginFlowInit_Poll poll;

  final String login;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreLoginFlowInitToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreLoginFlowInit? data) => data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudCoreLoginFlowResult {
  NextcloudCoreLoginFlowResult({
    required this.server,
    required this.loginName,
    required this.appPassword,
  });

  // coverage:ignore-start
  factory NextcloudCoreLoginFlowResult.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreLoginFlowResultFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreLoginFlowResult.fromJsonString(String data) =>
      NextcloudCoreLoginFlowResult.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final String server;

  final String loginName;

  final String appPassword;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreLoginFlowResultToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreLoginFlowResult? data) => data == null ? null : json.encode(data.toJson());
}

class NextcloudCoreAutocompleteResult_Ocs_Data_Status {
  NextcloudCoreAutocompleteResult_Ocs_Data_Status(
    this._data, {
    this.builtListJsonObject,
    this.string,
  });

  factory NextcloudCoreAutocompleteResult_Ocs_Data_Status.fromJson(dynamic data) {
    BuiltList<JsonObject>? builtListJsonObject;
    String? string;
    try {
      builtListJsonObject = BuiltList<JsonObject>((data as List).map((final e) => JsonObject(e)));
    } catch (_) {}
    try {
      string = (data as String);
    } catch (_) {}
    assert([builtListJsonObject, string].where((final x) => x != null).length >= 1, 'Need oneOf for $data');
    return NextcloudCoreAutocompleteResult_Ocs_Data_Status(
      data,
      builtListJsonObject: builtListJsonObject,
      string: string,
    );
  }

  // coverage:ignore-start
  factory NextcloudCoreAutocompleteResult_Ocs_Data_Status.fromJsonString(String data) =>
      NextcloudCoreAutocompleteResult_Ocs_Data_Status.fromJson(json.decode(data));
  // coverage:ignore-end

  final dynamic _data;

  final BuiltList<JsonObject>? builtListJsonObject;

  final String? string;

  // coverage:ignore-start
  dynamic toJson() => _data;
  // coverage:ignore-end
  // coverage:ignore-start
  static String toJsonString(dynamic data) => json.encode(data);
  // coverage:ignore-end
}

@JsonSerializable()
class NextcloudCoreAutocompleteResult_Ocs_Data {
  NextcloudCoreAutocompleteResult_Ocs_Data({
    required this.id,
    required this.label,
    required this.icon,
    required this.source,
    required this.status,
    required this.subline,
    required this.shareWithDisplayNameUnique,
  });

  // coverage:ignore-start
  factory NextcloudCoreAutocompleteResult_Ocs_Data.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreAutocompleteResult_Ocs_DataFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreAutocompleteResult_Ocs_Data.fromJsonString(String data) =>
      NextcloudCoreAutocompleteResult_Ocs_Data.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final String id;

  final String label;

  final String icon;

  final String source;

  final NextcloudCoreAutocompleteResult_Ocs_Data_Status status;

  final String subline;

  final String shareWithDisplayNameUnique;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreAutocompleteResult_Ocs_DataToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreAutocompleteResult_Ocs_Data? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudCoreAutocompleteResult_Ocs {
  NextcloudCoreAutocompleteResult_Ocs({
    required this.meta,
    required this.data,
  });

  // coverage:ignore-start
  factory NextcloudCoreAutocompleteResult_Ocs.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreAutocompleteResult_OcsFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreAutocompleteResult_Ocs.fromJsonString(String data) =>
      NextcloudCoreAutocompleteResult_Ocs.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudOCSMeta meta;

  final BuiltList<NextcloudCoreAutocompleteResult_Ocs_Data> data;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreAutocompleteResult_OcsToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreAutocompleteResult_Ocs? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudCoreAutocompleteResult {
  NextcloudCoreAutocompleteResult({required this.ocs});

  // coverage:ignore-start
  factory NextcloudCoreAutocompleteResult.fromJson(Map<String, dynamic> json) =>
      _$NextcloudCoreAutocompleteResultFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudCoreAutocompleteResult.fromJsonString(String data) =>
      NextcloudCoreAutocompleteResult.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudCoreAutocompleteResult_Ocs ocs;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudCoreAutocompleteResultToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudCoreAutocompleteResult? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudNewsSupportedAPIVersions {
  NextcloudNewsSupportedAPIVersions({this.apiLevels});

  // coverage:ignore-start
  factory NextcloudNewsSupportedAPIVersions.fromJson(Map<String, dynamic> json) =>
      _$NextcloudNewsSupportedAPIVersionsFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudNewsSupportedAPIVersions.fromJsonString(String data) =>
      NextcloudNewsSupportedAPIVersions.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final BuiltList<String>? apiLevels;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudNewsSupportedAPIVersionsToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudNewsSupportedAPIVersions? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudNewsArticle {
  NextcloudNewsArticle({
    required this.id,
    required this.guid,
    required this.guidHash,
    this.url,
    required this.title,
    this.author,
    required this.pubDate,
    this.updatedDate,
    required this.body,
    this.enclosureMime,
    this.enclosureLink,
    this.mediaThumbnail,
    this.mediaDescription,
    required this.feedId,
    required this.unread,
    required this.starred,
    required this.lastModified,
    required this.rtl,
    required this.fingerprint,
    required this.contentHash,
  });

  // coverage:ignore-start
  factory NextcloudNewsArticle.fromJson(Map<String, dynamic> json) => _$NextcloudNewsArticleFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudNewsArticle.fromJsonString(String data) =>
      NextcloudNewsArticle.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final int id;

  final String guid;

  final String guidHash;

  final String? url;

  final String title;

  final String? author;

  final int pubDate;

  final int? updatedDate;

  final String body;

  final String? enclosureMime;

  final String? enclosureLink;

  final String? mediaThumbnail;

  final String? mediaDescription;

  final int feedId;

  final bool unread;

  final bool starred;

  final int lastModified;

  final bool rtl;

  final String fingerprint;

  final String contentHash;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudNewsArticleToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudNewsArticle? data) => data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudNewsFeed {
  NextcloudNewsFeed({
    required this.id,
    required this.url,
    required this.title,
    this.faviconLink,
    required this.added,
    this.folderId,
    this.unreadCount,
    required this.ordering,
    this.link,
    required this.pinned,
    required this.updateErrorCount,
    this.lastUpdateError,
    required this.items,
  });

  // coverage:ignore-start
  factory NextcloudNewsFeed.fromJson(Map<String, dynamic> json) => _$NextcloudNewsFeedFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudNewsFeed.fromJsonString(String data) =>
      NextcloudNewsFeed.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final int id;

  final String url;

  final String title;

  final String? faviconLink;

  final int added;

  final int? folderId;

  final int? unreadCount;

  final int ordering;

  final String? link;

  final bool pinned;

  final int updateErrorCount;

  final String? lastUpdateError;

  final BuiltList<NextcloudNewsArticle> items;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudNewsFeedToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudNewsFeed? data) => data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudNewsFolder {
  NextcloudNewsFolder({
    required this.id,
    required this.name,
    required this.opened,
    required this.feeds,
  });

  // coverage:ignore-start
  factory NextcloudNewsFolder.fromJson(Map<String, dynamic> json) => _$NextcloudNewsFolderFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudNewsFolder.fromJsonString(String data) =>
      NextcloudNewsFolder.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final int id;

  final String name;

  final bool opened;

  /// This seems to be broken. In testing it is always empty
  final BuiltList<NextcloudNewsFeed> feeds;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudNewsFolderToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudNewsFolder? data) => data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudNewsListFolders {
  NextcloudNewsListFolders({required this.folders});

  // coverage:ignore-start
  factory NextcloudNewsListFolders.fromJson(Map<String, dynamic> json) => _$NextcloudNewsListFoldersFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudNewsListFolders.fromJsonString(String data) =>
      NextcloudNewsListFolders.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final BuiltList<NextcloudNewsFolder> folders;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudNewsListFoldersToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudNewsListFolders? data) => data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudNewsListFeeds {
  NextcloudNewsListFeeds({
    this.starredCount,
    this.newestItemId,
    required this.feeds,
  });

  // coverage:ignore-start
  factory NextcloudNewsListFeeds.fromJson(Map<String, dynamic> json) => _$NextcloudNewsListFeedsFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudNewsListFeeds.fromJsonString(String data) =>
      NextcloudNewsListFeeds.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final int? starredCount;

  final int? newestItemId;

  final BuiltList<NextcloudNewsFeed> feeds;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudNewsListFeedsToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudNewsListFeeds? data) => data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudNewsListArticles {
  NextcloudNewsListArticles({required this.items});

  // coverage:ignore-start
  factory NextcloudNewsListArticles.fromJson(Map<String, dynamic> json) => _$NextcloudNewsListArticlesFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudNewsListArticles.fromJsonString(String data) =>
      NextcloudNewsListArticles.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final BuiltList<NextcloudNewsArticle> items;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudNewsListArticlesToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudNewsListArticles? data) => data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudNotesNote {
  NextcloudNotesNote({
    required this.id,
    required this.etag,
    required this.readonly,
    required this.content,
    required this.title,
    required this.category,
    required this.favorite,
    required this.modified,
    required this.error,
    required this.errorType,
  });

  // coverage:ignore-start
  factory NextcloudNotesNote.fromJson(Map<String, dynamic> json) => _$NextcloudNotesNoteFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudNotesNote.fromJsonString(String data) =>
      NextcloudNotesNote.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final int id;

  final String etag;

  final bool readonly;

  final String content;

  final String title;

  final String category;

  final bool favorite;

  final int modified;

  final bool error;

  final String errorType;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudNotesNoteToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudNotesNote? data) => data == null ? null : json.encode(data.toJson());
}

class NextcloudNotesSettings_NoteMode extends EnumClass {
  const NextcloudNotesSettings_NoteMode._(super.name);

  static const NextcloudNotesSettings_NoteMode edit = _$nextcloudNotesSettingsNoteModeEdit;

  static const NextcloudNotesSettings_NoteMode preview = _$nextcloudNotesSettingsNoteModePreview;

  static const NextcloudNotesSettings_NoteMode rich = _$nextcloudNotesSettingsNoteModeRich;

  static BuiltSet<NextcloudNotesSettings_NoteMode> get values => _$nextcloudNotesSettingsNoteModeValues;
  static NextcloudNotesSettings_NoteMode valueOf(String name) => _$valueOfNextcloudNotesSettings_NoteMode(name);
  static Serializer<NextcloudNotesSettings_NoteMode> get serializer => _$nextcloudNotesSettingsNoteModeSerializer;
}

@JsonSerializable()
class NextcloudNotesSettings {
  NextcloudNotesSettings({
    required this.notesPath,
    required this.fileSuffix,
    required this.noteMode,
  });

  // coverage:ignore-start
  factory NextcloudNotesSettings.fromJson(Map<String, dynamic> json) => _$NextcloudNotesSettingsFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudNotesSettings.fromJsonString(String data) =>
      NextcloudNotesSettings.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final String notesPath;

  final String fileSuffix;

  final NextcloudNotesSettings_NoteMode noteMode;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudNotesSettingsToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudNotesSettings? data) => data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudNotificationsNotificationAction {
  NextcloudNotificationsNotificationAction({
    required this.label,
    required this.link,
    required this.type,
    this.primary,
  });

  // coverage:ignore-start
  factory NextcloudNotificationsNotificationAction.fromJson(Map<String, dynamic> json) =>
      _$NextcloudNotificationsNotificationActionFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudNotificationsNotificationAction.fromJsonString(String data) =>
      NextcloudNotificationsNotificationAction.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final String label;

  final String link;

  final String type;

  final bool? primary;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudNotificationsNotificationActionToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudNotificationsNotificationAction? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudNotificationsNotification {
  NextcloudNotificationsNotification({
    required this.notificationId,
    required this.app,
    required this.user,
    required this.datetime,
    required this.objectType,
    required this.objectId,
    required this.subject,
    required this.message,
    required this.link,
    required this.subjectRich,
    required this.subjectRichParameters,
    required this.messageRich,
    required this.messageRichParameters,
    required this.icon,
    required this.actions,
  });

  // coverage:ignore-start
  factory NextcloudNotificationsNotification.fromJson(Map<String, dynamic> json) =>
      _$NextcloudNotificationsNotificationFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudNotificationsNotification.fromJsonString(String data) =>
      NextcloudNotificationsNotification.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  @JsonKey(name: 'notification_id')
  final int notificationId;

  final String app;

  final String user;

  final String datetime;

  @JsonKey(name: 'object_type')
  final String objectType;

  @JsonKey(name: 'object_id')
  final String objectId;

  final String subject;

  final String message;

  final String link;

  final String subjectRich;

  final JsonObject subjectRichParameters;

  final String messageRich;

  final JsonObject messageRichParameters;

  final String icon;

  final BuiltList<NextcloudNotificationsNotificationAction> actions;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudNotificationsNotificationToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudNotificationsNotification? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudNotificationsListNotifications_Ocs {
  NextcloudNotificationsListNotifications_Ocs({
    required this.meta,
    required this.data,
  });

  // coverage:ignore-start
  factory NextcloudNotificationsListNotifications_Ocs.fromJson(Map<String, dynamic> json) =>
      _$NextcloudNotificationsListNotifications_OcsFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudNotificationsListNotifications_Ocs.fromJsonString(String data) =>
      NextcloudNotificationsListNotifications_Ocs.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudOCSMeta meta;

  final BuiltList<NextcloudNotificationsNotification> data;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudNotificationsListNotifications_OcsToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudNotificationsListNotifications_Ocs? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudNotificationsListNotifications {
  NextcloudNotificationsListNotifications({required this.ocs});

  // coverage:ignore-start
  factory NextcloudNotificationsListNotifications.fromJson(Map<String, dynamic> json) =>
      _$NextcloudNotificationsListNotificationsFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudNotificationsListNotifications.fromJsonString(String data) =>
      NextcloudNotificationsListNotifications.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudNotificationsListNotifications_Ocs ocs;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudNotificationsListNotificationsToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudNotificationsListNotifications? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudNotificationsGetNotification_Ocs {
  NextcloudNotificationsGetNotification_Ocs({
    required this.meta,
    required this.data,
  });

  // coverage:ignore-start
  factory NextcloudNotificationsGetNotification_Ocs.fromJson(Map<String, dynamic> json) =>
      _$NextcloudNotificationsGetNotification_OcsFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudNotificationsGetNotification_Ocs.fromJsonString(String data) =>
      NextcloudNotificationsGetNotification_Ocs.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudOCSMeta meta;

  final NextcloudNotificationsNotification data;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudNotificationsGetNotification_OcsToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudNotificationsGetNotification_Ocs? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudNotificationsGetNotification {
  NextcloudNotificationsGetNotification({required this.ocs});

  // coverage:ignore-start
  factory NextcloudNotificationsGetNotification.fromJson(Map<String, dynamic> json) =>
      _$NextcloudNotificationsGetNotificationFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudNotificationsGetNotification.fromJsonString(String data) =>
      NextcloudNotificationsGetNotification.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudNotificationsGetNotification_Ocs ocs;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudNotificationsGetNotificationToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudNotificationsGetNotification? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudEmptyOCS_Ocs {
  NextcloudEmptyOCS_Ocs({
    required this.meta,
    required this.data,
  });

  // coverage:ignore-start
  factory NextcloudEmptyOCS_Ocs.fromJson(Map<String, dynamic> json) => _$NextcloudEmptyOCS_OcsFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudEmptyOCS_Ocs.fromJsonString(String data) =>
      NextcloudEmptyOCS_Ocs.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudOCSMeta meta;

  final BuiltList<JsonObject> data;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudEmptyOCS_OcsToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudEmptyOCS_Ocs? data) => data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudEmptyOCS {
  NextcloudEmptyOCS({required this.ocs});

  // coverage:ignore-start
  factory NextcloudEmptyOCS.fromJson(Map<String, dynamic> json) => _$NextcloudEmptyOCSFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudEmptyOCS.fromJsonString(String data) =>
      NextcloudEmptyOCS.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudEmptyOCS_Ocs ocs;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudEmptyOCSToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudEmptyOCS? data) => data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudNotificationsPushServerSubscription {
  NextcloudNotificationsPushServerSubscription({
    required this.publicKey,
    required this.deviceIdentifier,
    required this.signature,
    this.message,
  });

  // coverage:ignore-start
  factory NextcloudNotificationsPushServerSubscription.fromJson(Map<String, dynamic> json) =>
      _$NextcloudNotificationsPushServerSubscriptionFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudNotificationsPushServerSubscription.fromJsonString(String data) =>
      NextcloudNotificationsPushServerSubscription.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final String publicKey;

  final String deviceIdentifier;

  final String signature;

  final String? message;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudNotificationsPushServerSubscriptionToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudNotificationsPushServerSubscription? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudNotificationsPushServerRegistration_Ocs {
  NextcloudNotificationsPushServerRegistration_Ocs({
    required this.meta,
    required this.data,
  });

  // coverage:ignore-start
  factory NextcloudNotificationsPushServerRegistration_Ocs.fromJson(Map<String, dynamic> json) =>
      _$NextcloudNotificationsPushServerRegistration_OcsFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudNotificationsPushServerRegistration_Ocs.fromJsonString(String data) =>
      NextcloudNotificationsPushServerRegistration_Ocs.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudOCSMeta meta;

  final NextcloudNotificationsPushServerSubscription data;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudNotificationsPushServerRegistration_OcsToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudNotificationsPushServerRegistration_Ocs? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudNotificationsPushServerRegistration {
  NextcloudNotificationsPushServerRegistration({required this.ocs});

  // coverage:ignore-start
  factory NextcloudNotificationsPushServerRegistration.fromJson(Map<String, dynamic> json) =>
      _$NextcloudNotificationsPushServerRegistrationFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudNotificationsPushServerRegistration.fromJsonString(String data) =>
      NextcloudNotificationsPushServerRegistration.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudNotificationsPushServerRegistration_Ocs ocs;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudNotificationsPushServerRegistrationToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudNotificationsPushServerRegistration? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudProvisioningApiUserDetails_Quota {
  NextcloudProvisioningApiUserDetails_Quota({
    required this.free,
    required this.used,
    required this.total,
    required this.relative,
    required this.quota,
  });

  // coverage:ignore-start
  factory NextcloudProvisioningApiUserDetails_Quota.fromJson(Map<String, dynamic> json) =>
      _$NextcloudProvisioningApiUserDetails_QuotaFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudProvisioningApiUserDetails_Quota.fromJsonString(String data) =>
      NextcloudProvisioningApiUserDetails_Quota.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final int free;

  final int used;

  final int total;

  final num relative;

  final int quota;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudProvisioningApiUserDetails_QuotaToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudProvisioningApiUserDetails_Quota? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudProvisioningApiUserDetails_BackendCapabilities {
  NextcloudProvisioningApiUserDetails_BackendCapabilities({
    required this.setDisplayName,
    required this.setPassword,
  });

  // coverage:ignore-start
  factory NextcloudProvisioningApiUserDetails_BackendCapabilities.fromJson(Map<String, dynamic> json) =>
      _$NextcloudProvisioningApiUserDetails_BackendCapabilitiesFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudProvisioningApiUserDetails_BackendCapabilities.fromJsonString(String data) =>
      NextcloudProvisioningApiUserDetails_BackendCapabilities.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool setDisplayName;

  final bool setPassword;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudProvisioningApiUserDetails_BackendCapabilitiesToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudProvisioningApiUserDetails_BackendCapabilities? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudProvisioningApiUserDetails {
  NextcloudProvisioningApiUserDetails({
    this.enabled,
    this.storageLocation,
    required this.id,
    required this.lastLogin,
    required this.backend,
    required this.subadmin,
    required this.quota,
    required this.avatarScope,
    this.email,
    required this.emailScope,
    required this.additionalMail,
    required this.additionalMailScope,
    this.displayname,
    required this.displaynameScope,
    required this.phone,
    required this.phoneScope,
    required this.address,
    required this.addressScope,
    required this.website,
    required this.websiteScope,
    required this.twitter,
    required this.twitterScope,
    required this.organisation,
    required this.organisationScope,
    required this.role,
    required this.roleScope,
    required this.headline,
    required this.headlineScope,
    required this.biography,
    required this.biographyScope,
    required this.profileEnabled,
    required this.profileEnabledScope,
    required this.fediverse,
    required this.fediverseScope,
    required this.groups,
    required this.language,
    required this.locale,
    this.notifyEmail,
    required this.backendCapabilities,
    this.displayName,
  });

  // coverage:ignore-start
  factory NextcloudProvisioningApiUserDetails.fromJson(Map<String, dynamic> json) =>
      _$NextcloudProvisioningApiUserDetailsFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudProvisioningApiUserDetails.fromJsonString(String data) =>
      NextcloudProvisioningApiUserDetails.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool? enabled;

  final String? storageLocation;

  final String id;

  final int lastLogin;

  final String backend;

  final BuiltList<String> subadmin;

  final NextcloudProvisioningApiUserDetails_Quota quota;

  final String avatarScope;

  final String? email;

  final String emailScope;

  @JsonKey(name: 'additional_mail')
  final BuiltList<String> additionalMail;

  @JsonKey(name: 'additional_mailScope')
  final BuiltList<String> additionalMailScope;

  final String? displayname;

  final String displaynameScope;

  final String phone;

  final String phoneScope;

  final String address;

  final String addressScope;

  final String website;

  final String websiteScope;

  final String twitter;

  final String twitterScope;

  final String organisation;

  final String organisationScope;

  final String role;

  final String roleScope;

  final String headline;

  final String headlineScope;

  final String biography;

  final String biographyScope;

  @JsonKey(name: 'profile_enabled')
  final String profileEnabled;

  @JsonKey(name: 'profile_enabledScope')
  final String profileEnabledScope;

  final String fediverse;

  final String fediverseScope;

  final BuiltList<String> groups;

  final String language;

  final String locale;

  @JsonKey(name: 'notify_email')
  final String? notifyEmail;

  final NextcloudProvisioningApiUserDetails_BackendCapabilities backendCapabilities;

  @JsonKey(name: 'display-name')
  final String? displayName;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudProvisioningApiUserDetailsToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudProvisioningApiUserDetails? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudProvisioningApiUser_Ocs {
  NextcloudProvisioningApiUser_Ocs({
    required this.meta,
    required this.data,
  });

  // coverage:ignore-start
  factory NextcloudProvisioningApiUser_Ocs.fromJson(Map<String, dynamic> json) =>
      _$NextcloudProvisioningApiUser_OcsFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudProvisioningApiUser_Ocs.fromJsonString(String data) =>
      NextcloudProvisioningApiUser_Ocs.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudOCSMeta meta;

  final NextcloudProvisioningApiUserDetails data;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudProvisioningApiUser_OcsToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudProvisioningApiUser_Ocs? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudProvisioningApiUser {
  NextcloudProvisioningApiUser({required this.ocs});

  // coverage:ignore-start
  factory NextcloudProvisioningApiUser.fromJson(Map<String, dynamic> json) =>
      _$NextcloudProvisioningApiUserFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudProvisioningApiUser.fromJsonString(String data) =>
      NextcloudProvisioningApiUser.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudProvisioningApiUser_Ocs ocs;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudProvisioningApiUserToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudProvisioningApiUser? data) => data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudUnifiedPushProviderCheckResponse200ApplicationJson {
  NextcloudUnifiedPushProviderCheckResponse200ApplicationJson({required this.success});

  // coverage:ignore-start
  factory NextcloudUnifiedPushProviderCheckResponse200ApplicationJson.fromJson(Map<String, dynamic> json) =>
      _$NextcloudUnifiedPushProviderCheckResponse200ApplicationJsonFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudUnifiedPushProviderCheckResponse200ApplicationJson.fromJsonString(String data) =>
      NextcloudUnifiedPushProviderCheckResponse200ApplicationJson.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool success;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudUnifiedPushProviderCheckResponse200ApplicationJsonToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudUnifiedPushProviderCheckResponse200ApplicationJson? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudUnifiedPushProviderSetKeepaliveResponse200ApplicationJson {
  NextcloudUnifiedPushProviderSetKeepaliveResponse200ApplicationJson({required this.success});

  // coverage:ignore-start
  factory NextcloudUnifiedPushProviderSetKeepaliveResponse200ApplicationJson.fromJson(Map<String, dynamic> json) =>
      _$NextcloudUnifiedPushProviderSetKeepaliveResponse200ApplicationJsonFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudUnifiedPushProviderSetKeepaliveResponse200ApplicationJson.fromJsonString(String data) =>
      NextcloudUnifiedPushProviderSetKeepaliveResponse200ApplicationJson.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool success;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudUnifiedPushProviderSetKeepaliveResponse200ApplicationJsonToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudUnifiedPushProviderSetKeepaliveResponse200ApplicationJson? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudUnifiedPushProviderCreateDeviceResponse200ApplicationJson {
  NextcloudUnifiedPushProviderCreateDeviceResponse200ApplicationJson({
    required this.success,
    required this.deviceId,
  });

  // coverage:ignore-start
  factory NextcloudUnifiedPushProviderCreateDeviceResponse200ApplicationJson.fromJson(Map<String, dynamic> json) =>
      _$NextcloudUnifiedPushProviderCreateDeviceResponse200ApplicationJsonFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudUnifiedPushProviderCreateDeviceResponse200ApplicationJson.fromJsonString(String data) =>
      NextcloudUnifiedPushProviderCreateDeviceResponse200ApplicationJson.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool success;

  final String deviceId;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudUnifiedPushProviderCreateDeviceResponse200ApplicationJsonToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudUnifiedPushProviderCreateDeviceResponse200ApplicationJson? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudUnifiedPushProviderSyncDeviceResponse401ApplicationJson {
  NextcloudUnifiedPushProviderSyncDeviceResponse401ApplicationJson({required this.success});

  // coverage:ignore-start
  factory NextcloudUnifiedPushProviderSyncDeviceResponse401ApplicationJson.fromJson(Map<String, dynamic> json) =>
      _$NextcloudUnifiedPushProviderSyncDeviceResponse401ApplicationJsonFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudUnifiedPushProviderSyncDeviceResponse401ApplicationJson.fromJsonString(String data) =>
      NextcloudUnifiedPushProviderSyncDeviceResponse401ApplicationJson.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool success;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudUnifiedPushProviderSyncDeviceResponse401ApplicationJsonToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudUnifiedPushProviderSyncDeviceResponse401ApplicationJson? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudUnifiedPushProviderDeleteDeviceResponse200ApplicationJson {
  NextcloudUnifiedPushProviderDeleteDeviceResponse200ApplicationJson({required this.success});

  // coverage:ignore-start
  factory NextcloudUnifiedPushProviderDeleteDeviceResponse200ApplicationJson.fromJson(Map<String, dynamic> json) =>
      _$NextcloudUnifiedPushProviderDeleteDeviceResponse200ApplicationJsonFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudUnifiedPushProviderDeleteDeviceResponse200ApplicationJson.fromJsonString(String data) =>
      NextcloudUnifiedPushProviderDeleteDeviceResponse200ApplicationJson.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool success;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudUnifiedPushProviderDeleteDeviceResponse200ApplicationJsonToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudUnifiedPushProviderDeleteDeviceResponse200ApplicationJson? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudUnifiedPushProviderCreateAppResponse200ApplicationJson {
  NextcloudUnifiedPushProviderCreateAppResponse200ApplicationJson({
    required this.success,
    required this.token,
  });

  // coverage:ignore-start
  factory NextcloudUnifiedPushProviderCreateAppResponse200ApplicationJson.fromJson(Map<String, dynamic> json) =>
      _$NextcloudUnifiedPushProviderCreateAppResponse200ApplicationJsonFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudUnifiedPushProviderCreateAppResponse200ApplicationJson.fromJsonString(String data) =>
      NextcloudUnifiedPushProviderCreateAppResponse200ApplicationJson.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool success;

  final String token;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudUnifiedPushProviderCreateAppResponse200ApplicationJsonToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudUnifiedPushProviderCreateAppResponse200ApplicationJson? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudUnifiedPushProviderDeleteAppResponse200ApplicationJson {
  NextcloudUnifiedPushProviderDeleteAppResponse200ApplicationJson({required this.success});

  // coverage:ignore-start
  factory NextcloudUnifiedPushProviderDeleteAppResponse200ApplicationJson.fromJson(Map<String, dynamic> json) =>
      _$NextcloudUnifiedPushProviderDeleteAppResponse200ApplicationJsonFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudUnifiedPushProviderDeleteAppResponse200ApplicationJson.fromJsonString(String data) =>
      NextcloudUnifiedPushProviderDeleteAppResponse200ApplicationJson.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool success;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudUnifiedPushProviderDeleteAppResponse200ApplicationJsonToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudUnifiedPushProviderDeleteAppResponse200ApplicationJson? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudUnifiedPushProviderUnifiedpushDiscoveryResponse200ApplicationJson_Unifiedpush {
  NextcloudUnifiedPushProviderUnifiedpushDiscoveryResponse200ApplicationJson_Unifiedpush({required this.version});

  // coverage:ignore-start
  factory NextcloudUnifiedPushProviderUnifiedpushDiscoveryResponse200ApplicationJson_Unifiedpush.fromJson(
          Map<String, dynamic> json) =>
      _$NextcloudUnifiedPushProviderUnifiedpushDiscoveryResponse200ApplicationJson_UnifiedpushFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudUnifiedPushProviderUnifiedpushDiscoveryResponse200ApplicationJson_Unifiedpush.fromJsonString(
          String data) =>
      NextcloudUnifiedPushProviderUnifiedpushDiscoveryResponse200ApplicationJson_Unifiedpush.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final int version;

  // coverage:ignore-start
  Map<String, dynamic> toJson() =>
      _$NextcloudUnifiedPushProviderUnifiedpushDiscoveryResponse200ApplicationJson_UnifiedpushToJson(this);
  // coverage:ignore-end
  static String? toJsonString(
          NextcloudUnifiedPushProviderUnifiedpushDiscoveryResponse200ApplicationJson_Unifiedpush? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudUnifiedPushProviderUnifiedpushDiscoveryResponse200ApplicationJson {
  NextcloudUnifiedPushProviderUnifiedpushDiscoveryResponse200ApplicationJson({required this.unifiedpush});

  // coverage:ignore-start
  factory NextcloudUnifiedPushProviderUnifiedpushDiscoveryResponse200ApplicationJson.fromJson(
          Map<String, dynamic> json) =>
      _$NextcloudUnifiedPushProviderUnifiedpushDiscoveryResponse200ApplicationJsonFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudUnifiedPushProviderUnifiedpushDiscoveryResponse200ApplicationJson.fromJsonString(String data) =>
      NextcloudUnifiedPushProviderUnifiedpushDiscoveryResponse200ApplicationJson.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudUnifiedPushProviderUnifiedpushDiscoveryResponse200ApplicationJson_Unifiedpush unifiedpush;

  // coverage:ignore-start
  Map<String, dynamic> toJson() =>
      _$NextcloudUnifiedPushProviderUnifiedpushDiscoveryResponse200ApplicationJsonToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudUnifiedPushProviderUnifiedpushDiscoveryResponse200ApplicationJson? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudUnifiedPushProviderPushResponse201ApplicationJson {
  NextcloudUnifiedPushProviderPushResponse201ApplicationJson({required this.success});

  // coverage:ignore-start
  factory NextcloudUnifiedPushProviderPushResponse201ApplicationJson.fromJson(Map<String, dynamic> json) =>
      _$NextcloudUnifiedPushProviderPushResponse201ApplicationJsonFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudUnifiedPushProviderPushResponse201ApplicationJson.fromJsonString(String data) =>
      NextcloudUnifiedPushProviderPushResponse201ApplicationJson.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final bool success;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudUnifiedPushProviderPushResponse201ApplicationJsonToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudUnifiedPushProviderPushResponse201ApplicationJson? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudUnifiedPushProviderGatewayMatrixDiscoveryResponse200ApplicationJson_Unifiedpush {
  NextcloudUnifiedPushProviderGatewayMatrixDiscoveryResponse200ApplicationJson_Unifiedpush({required this.gateway});

  // coverage:ignore-start
  factory NextcloudUnifiedPushProviderGatewayMatrixDiscoveryResponse200ApplicationJson_Unifiedpush.fromJson(
          Map<String, dynamic> json) =>
      _$NextcloudUnifiedPushProviderGatewayMatrixDiscoveryResponse200ApplicationJson_UnifiedpushFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudUnifiedPushProviderGatewayMatrixDiscoveryResponse200ApplicationJson_Unifiedpush.fromJsonString(
          String data) =>
      NextcloudUnifiedPushProviderGatewayMatrixDiscoveryResponse200ApplicationJson_Unifiedpush.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final String gateway;

  // coverage:ignore-start
  Map<String, dynamic> toJson() =>
      _$NextcloudUnifiedPushProviderGatewayMatrixDiscoveryResponse200ApplicationJson_UnifiedpushToJson(this);
  // coverage:ignore-end
  static String? toJsonString(
          NextcloudUnifiedPushProviderGatewayMatrixDiscoveryResponse200ApplicationJson_Unifiedpush? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudUnifiedPushProviderGatewayMatrixDiscoveryResponse200ApplicationJson {
  NextcloudUnifiedPushProviderGatewayMatrixDiscoveryResponse200ApplicationJson({required this.unifiedpush});

  // coverage:ignore-start
  factory NextcloudUnifiedPushProviderGatewayMatrixDiscoveryResponse200ApplicationJson.fromJson(
          Map<String, dynamic> json) =>
      _$NextcloudUnifiedPushProviderGatewayMatrixDiscoveryResponse200ApplicationJsonFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudUnifiedPushProviderGatewayMatrixDiscoveryResponse200ApplicationJson.fromJsonString(String data) =>
      NextcloudUnifiedPushProviderGatewayMatrixDiscoveryResponse200ApplicationJson.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudUnifiedPushProviderGatewayMatrixDiscoveryResponse200ApplicationJson_Unifiedpush unifiedpush;

  // coverage:ignore-start
  Map<String, dynamic> toJson() =>
      _$NextcloudUnifiedPushProviderGatewayMatrixDiscoveryResponse200ApplicationJsonToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudUnifiedPushProviderGatewayMatrixDiscoveryResponse200ApplicationJson? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudUnifiedPushProviderGatewayMatrixResponse200ApplicationJson {
  NextcloudUnifiedPushProviderGatewayMatrixResponse200ApplicationJson({required this.rejected});

  // coverage:ignore-start
  factory NextcloudUnifiedPushProviderGatewayMatrixResponse200ApplicationJson.fromJson(Map<String, dynamic> json) =>
      _$NextcloudUnifiedPushProviderGatewayMatrixResponse200ApplicationJsonFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudUnifiedPushProviderGatewayMatrixResponse200ApplicationJson.fromJsonString(String data) =>
      NextcloudUnifiedPushProviderGatewayMatrixResponse200ApplicationJson.fromJson(
          json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final BuiltList<String> rejected;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudUnifiedPushProviderGatewayMatrixResponse200ApplicationJsonToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudUnifiedPushProviderGatewayMatrixResponse200ApplicationJson? data) =>
      data == null ? null : json.encode(data.toJson());
}

class NextcloudUserStatusClearAt_Type extends EnumClass {
  const NextcloudUserStatusClearAt_Type._(super.name);

  static const NextcloudUserStatusClearAt_Type period = _$nextcloudUserStatusClearAtTypePeriod;

  @BuiltValueEnumConst(wireName: 'end-of')
  static const NextcloudUserStatusClearAt_Type endOf = _$nextcloudUserStatusClearAtTypeEndOf;

  static BuiltSet<NextcloudUserStatusClearAt_Type> get values => _$nextcloudUserStatusClearAtTypeValues;
  static NextcloudUserStatusClearAt_Type valueOf(String name) => _$valueOfNextcloudUserStatusClearAt_Type(name);
  static Serializer<NextcloudUserStatusClearAt_Type> get serializer => _$nextcloudUserStatusClearAtTypeSerializer;
}

class NextcloudUserStatusClearAt_Time0 extends EnumClass {
  const NextcloudUserStatusClearAt_Time0._(super.name);

  static const NextcloudUserStatusClearAt_Time0 day = _$nextcloudUserStatusClearAtTime0Day;

  static const NextcloudUserStatusClearAt_Time0 week = _$nextcloudUserStatusClearAtTime0Week;

  static BuiltSet<NextcloudUserStatusClearAt_Time0> get values => _$nextcloudUserStatusClearAtTime0Values;
  static NextcloudUserStatusClearAt_Time0 valueOf(String name) => _$valueOfNextcloudUserStatusClearAt_Time0(name);
  static Serializer<NextcloudUserStatusClearAt_Time0> get serializer => _$nextcloudUserStatusClearAtTime0Serializer;
}

class NextcloudUserStatusClearAt_Time {
  NextcloudUserStatusClearAt_Time(
    this._data, {
    this.userStatusClearAtTime0,
    this.$int,
  });

  factory NextcloudUserStatusClearAt_Time.fromJson(dynamic data) {
    NextcloudUserStatusClearAt_Time0? userStatusClearAtTime0;
    int? $int;
    try {
      userStatusClearAtTime0 = NextcloudUserStatusClearAt_Time0.valueOf(data as String);
    } catch (_) {}
    try {
      $int = (data as int);
    } catch (_) {}
    assert([userStatusClearAtTime0, $int].where((final x) => x != null).length >= 1, 'Need oneOf for $data');
    return NextcloudUserStatusClearAt_Time(
      data,
      userStatusClearAtTime0: userStatusClearAtTime0,
      $int: $int,
    );
  }

  // coverage:ignore-start
  factory NextcloudUserStatusClearAt_Time.fromJsonString(String data) =>
      NextcloudUserStatusClearAt_Time.fromJson(json.decode(data));
  // coverage:ignore-end

  final dynamic _data;

  final NextcloudUserStatusClearAt_Time0? userStatusClearAtTime0;

  /// Time offset in seconds
  final int? $int;

  // coverage:ignore-start
  dynamic toJson() => _data;
  // coverage:ignore-end
  // coverage:ignore-start
  static String toJsonString(dynamic data) => json.encode(data);
  // coverage:ignore-end
}

@JsonSerializable()
class NextcloudUserStatusClearAt {
  NextcloudUserStatusClearAt({
    required this.type,
    required this.time,
  });

  // coverage:ignore-start
  factory NextcloudUserStatusClearAt.fromJson(Map<String, dynamic> json) => _$NextcloudUserStatusClearAtFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudUserStatusClearAt.fromJsonString(String data) =>
      NextcloudUserStatusClearAt.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudUserStatusClearAt_Type type;

  final NextcloudUserStatusClearAt_Time time;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudUserStatusClearAtToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudUserStatusClearAt? data) => data == null ? null : json.encode(data.toJson());
}

class NextcloudUserStatusPublicStatus_ClearAt {
  NextcloudUserStatusPublicStatus_ClearAt(
    this._data, {
    this.userStatusClearAt,
    this.$int,
  });

  factory NextcloudUserStatusPublicStatus_ClearAt.fromJson(dynamic data) {
    NextcloudUserStatusClearAt? userStatusClearAt;
    int? $int;
    try {
      userStatusClearAt = NextcloudUserStatusClearAt.fromJson(data as Map<String, dynamic>);
    } catch (_) {}
    try {
      $int = (data as int);
    } catch (_) {}
    assert([userStatusClearAt, $int].where((final x) => x != null).length >= 1, 'Need oneOf for $data');
    return NextcloudUserStatusPublicStatus_ClearAt(
      data,
      userStatusClearAt: userStatusClearAt,
      $int: $int,
    );
  }

  // coverage:ignore-start
  factory NextcloudUserStatusPublicStatus_ClearAt.fromJsonString(String data) =>
      NextcloudUserStatusPublicStatus_ClearAt.fromJson(json.decode(data));
  // coverage:ignore-end

  final dynamic _data;

  final NextcloudUserStatusClearAt? userStatusClearAt;

  /// Time as unix timestamp
  final int? $int;

  // coverage:ignore-start
  dynamic toJson() => _data;
  // coverage:ignore-end
  // coverage:ignore-start
  static String toJsonString(dynamic data) => json.encode(data);
  // coverage:ignore-end
}

class NextcloudUserStatusType extends EnumClass {
  const NextcloudUserStatusType._(super.name);

  static const NextcloudUserStatusType online = _$nextcloudUserStatusTypeOnline;

  static const NextcloudUserStatusType offline = _$nextcloudUserStatusTypeOffline;

  static const NextcloudUserStatusType dnd = _$nextcloudUserStatusTypeDnd;

  static const NextcloudUserStatusType away = _$nextcloudUserStatusTypeAway;

  static const NextcloudUserStatusType invisible = _$nextcloudUserStatusTypeInvisible;

  static BuiltSet<NextcloudUserStatusType> get values => _$nextcloudUserStatusTypeValues;
  static NextcloudUserStatusType valueOf(String name) => _$valueOfNextcloudUserStatusType(name);
  static Serializer<NextcloudUserStatusType> get serializer => _$nextcloudUserStatusTypeSerializer;
}

@JsonSerializable()
class NextcloudUserStatusPublicStatus {
  NextcloudUserStatusPublicStatus({
    required this.userId,
    this.message,
    this.icon,
    this.clearAt,
    required this.status,
  });

  // coverage:ignore-start
  factory NextcloudUserStatusPublicStatus.fromJson(Map<String, dynamic> json) =>
      _$NextcloudUserStatusPublicStatusFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudUserStatusPublicStatus.fromJsonString(String data) =>
      NextcloudUserStatusPublicStatus.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final String userId;

  final String? message;

  final String? icon;

  final NextcloudUserStatusPublicStatus_ClearAt? clearAt;

  final NextcloudUserStatusType status;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudUserStatusPublicStatusToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudUserStatusPublicStatus? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudUserStatusGetPublicStatuses_Ocs {
  NextcloudUserStatusGetPublicStatuses_Ocs({
    required this.meta,
    required this.data,
  });

  // coverage:ignore-start
  factory NextcloudUserStatusGetPublicStatuses_Ocs.fromJson(Map<String, dynamic> json) =>
      _$NextcloudUserStatusGetPublicStatuses_OcsFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudUserStatusGetPublicStatuses_Ocs.fromJsonString(String data) =>
      NextcloudUserStatusGetPublicStatuses_Ocs.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudOCSMeta meta;

  final BuiltList<NextcloudUserStatusPublicStatus> data;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudUserStatusGetPublicStatuses_OcsToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudUserStatusGetPublicStatuses_Ocs? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudUserStatusGetPublicStatuses {
  NextcloudUserStatusGetPublicStatuses({required this.ocs});

  // coverage:ignore-start
  factory NextcloudUserStatusGetPublicStatuses.fromJson(Map<String, dynamic> json) =>
      _$NextcloudUserStatusGetPublicStatusesFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudUserStatusGetPublicStatuses.fromJsonString(String data) =>
      NextcloudUserStatusGetPublicStatuses.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudUserStatusGetPublicStatuses_Ocs ocs;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudUserStatusGetPublicStatusesToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudUserStatusGetPublicStatuses? data) =>
      data == null ? null : json.encode(data.toJson());
}

class NextcloudUserStatusGetPublicStatus_Ocs_Data {
  NextcloudUserStatusGetPublicStatus_Ocs_Data(
    this._data, {
    this.builtListJsonObject,
    this.userStatusPublicStatus,
  });

  factory NextcloudUserStatusGetPublicStatus_Ocs_Data.fromJson(dynamic data) {
    BuiltList<JsonObject>? builtListJsonObject;
    NextcloudUserStatusPublicStatus? userStatusPublicStatus;
    try {
      builtListJsonObject = BuiltList<JsonObject>((data as List).map((final e) => JsonObject(e)));
    } catch (_) {}
    try {
      userStatusPublicStatus = NextcloudUserStatusPublicStatus.fromJson(data as Map<String, dynamic>);
    } catch (_) {}
    assert([builtListJsonObject, userStatusPublicStatus].where((final x) => x != null).length >= 1,
        'Need oneOf for $data');
    return NextcloudUserStatusGetPublicStatus_Ocs_Data(
      data,
      builtListJsonObject: builtListJsonObject,
      userStatusPublicStatus: userStatusPublicStatus,
    );
  }

  // coverage:ignore-start
  factory NextcloudUserStatusGetPublicStatus_Ocs_Data.fromJsonString(String data) =>
      NextcloudUserStatusGetPublicStatus_Ocs_Data.fromJson(json.decode(data));
  // coverage:ignore-end

  final dynamic _data;

  final BuiltList<JsonObject>? builtListJsonObject;

  final NextcloudUserStatusPublicStatus? userStatusPublicStatus;

  // coverage:ignore-start
  dynamic toJson() => _data;
  // coverage:ignore-end
  // coverage:ignore-start
  static String toJsonString(dynamic data) => json.encode(data);
  // coverage:ignore-end
}

@JsonSerializable()
class NextcloudUserStatusGetPublicStatus_Ocs {
  NextcloudUserStatusGetPublicStatus_Ocs({
    required this.meta,
    required this.data,
  });

  // coverage:ignore-start
  factory NextcloudUserStatusGetPublicStatus_Ocs.fromJson(Map<String, dynamic> json) =>
      _$NextcloudUserStatusGetPublicStatus_OcsFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudUserStatusGetPublicStatus_Ocs.fromJsonString(String data) =>
      NextcloudUserStatusGetPublicStatus_Ocs.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudOCSMeta meta;

  final NextcloudUserStatusGetPublicStatus_Ocs_Data data;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudUserStatusGetPublicStatus_OcsToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudUserStatusGetPublicStatus_Ocs? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudUserStatusGetPublicStatus {
  NextcloudUserStatusGetPublicStatus({required this.ocs});

  // coverage:ignore-start
  factory NextcloudUserStatusGetPublicStatus.fromJson(Map<String, dynamic> json) =>
      _$NextcloudUserStatusGetPublicStatusFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudUserStatusGetPublicStatus.fromJsonString(String data) =>
      NextcloudUserStatusGetPublicStatus.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudUserStatusGetPublicStatus_Ocs ocs;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudUserStatusGetPublicStatusToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudUserStatusGetPublicStatus? data) =>
      data == null ? null : json.encode(data.toJson());
}

class NextcloudUserStatusStatus_ClearAt {
  NextcloudUserStatusStatus_ClearAt(
    this._data, {
    this.userStatusClearAt,
    this.$int,
  });

  factory NextcloudUserStatusStatus_ClearAt.fromJson(dynamic data) {
    NextcloudUserStatusClearAt? userStatusClearAt;
    int? $int;
    try {
      userStatusClearAt = NextcloudUserStatusClearAt.fromJson(data as Map<String, dynamic>);
    } catch (_) {}
    try {
      $int = (data as int);
    } catch (_) {}
    assert([userStatusClearAt, $int].where((final x) => x != null).length >= 1, 'Need oneOf for $data');
    return NextcloudUserStatusStatus_ClearAt(
      data,
      userStatusClearAt: userStatusClearAt,
      $int: $int,
    );
  }

  // coverage:ignore-start
  factory NextcloudUserStatusStatus_ClearAt.fromJsonString(String data) =>
      NextcloudUserStatusStatus_ClearAt.fromJson(json.decode(data));
  // coverage:ignore-end

  final dynamic _data;

  final NextcloudUserStatusClearAt? userStatusClearAt;

  /// Time as unix timestamp
  final int? $int;

  // coverage:ignore-start
  dynamic toJson() => _data;
  // coverage:ignore-end
  // coverage:ignore-start
  static String toJsonString(dynamic data) => json.encode(data);
  // coverage:ignore-end
}

@JsonSerializable()
class NextcloudUserStatusStatus {
  NextcloudUserStatusStatus({
    required this.userId,
    this.message,
    this.messageId,
    required this.messageIsPredefined,
    this.icon,
    this.clearAt,
    required this.status,
    required this.statusIsUserDefined,
  });

  // coverage:ignore-start
  factory NextcloudUserStatusStatus.fromJson(Map<String, dynamic> json) => _$NextcloudUserStatusStatusFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudUserStatusStatus.fromJsonString(String data) =>
      NextcloudUserStatusStatus.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final String userId;

  final String? message;

  final String? messageId;

  final bool messageIsPredefined;

  final String? icon;

  final NextcloudUserStatusStatus_ClearAt? clearAt;

  final NextcloudUserStatusType status;

  final bool statusIsUserDefined;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudUserStatusStatusToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudUserStatusStatus? data) => data == null ? null : json.encode(data.toJson());
}

class NextcloudUserStatusGetStatus_Ocs_Data {
  NextcloudUserStatusGetStatus_Ocs_Data(
    this._data, {
    this.builtListJsonObject,
    this.userStatusStatus,
  });

  factory NextcloudUserStatusGetStatus_Ocs_Data.fromJson(dynamic data) {
    BuiltList<JsonObject>? builtListJsonObject;
    NextcloudUserStatusStatus? userStatusStatus;
    try {
      builtListJsonObject = BuiltList<JsonObject>((data as List).map((final e) => JsonObject(e)));
    } catch (_) {}
    try {
      userStatusStatus = NextcloudUserStatusStatus.fromJson(data as Map<String, dynamic>);
    } catch (_) {}
    assert([builtListJsonObject, userStatusStatus].where((final x) => x != null).length >= 1, 'Need oneOf for $data');
    return NextcloudUserStatusGetStatus_Ocs_Data(
      data,
      builtListJsonObject: builtListJsonObject,
      userStatusStatus: userStatusStatus,
    );
  }

  // coverage:ignore-start
  factory NextcloudUserStatusGetStatus_Ocs_Data.fromJsonString(String data) =>
      NextcloudUserStatusGetStatus_Ocs_Data.fromJson(json.decode(data));
  // coverage:ignore-end

  final dynamic _data;

  final BuiltList<JsonObject>? builtListJsonObject;

  final NextcloudUserStatusStatus? userStatusStatus;

  // coverage:ignore-start
  dynamic toJson() => _data;
  // coverage:ignore-end
  // coverage:ignore-start
  static String toJsonString(dynamic data) => json.encode(data);
  // coverage:ignore-end
}

@JsonSerializable()
class NextcloudUserStatusGetStatus_Ocs {
  NextcloudUserStatusGetStatus_Ocs({
    required this.meta,
    required this.data,
  });

  // coverage:ignore-start
  factory NextcloudUserStatusGetStatus_Ocs.fromJson(Map<String, dynamic> json) =>
      _$NextcloudUserStatusGetStatus_OcsFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudUserStatusGetStatus_Ocs.fromJsonString(String data) =>
      NextcloudUserStatusGetStatus_Ocs.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudOCSMeta meta;

  final NextcloudUserStatusGetStatus_Ocs_Data data;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudUserStatusGetStatus_OcsToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudUserStatusGetStatus_Ocs? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudUserStatusGetStatus {
  NextcloudUserStatusGetStatus({required this.ocs});

  // coverage:ignore-start
  factory NextcloudUserStatusGetStatus.fromJson(Map<String, dynamic> json) =>
      _$NextcloudUserStatusGetStatusFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudUserStatusGetStatus.fromJsonString(String data) =>
      NextcloudUserStatusGetStatus.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudUserStatusGetStatus_Ocs ocs;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudUserStatusGetStatusToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudUserStatusGetStatus? data) => data == null ? null : json.encode(data.toJson());
}

class NextcloudUserStatusPredefinedStatus_ClearAt {
  NextcloudUserStatusPredefinedStatus_ClearAt(
    this._data, {
    this.userStatusClearAt,
    this.$int,
  });

  factory NextcloudUserStatusPredefinedStatus_ClearAt.fromJson(dynamic data) {
    NextcloudUserStatusClearAt? userStatusClearAt;
    int? $int;
    try {
      userStatusClearAt = NextcloudUserStatusClearAt.fromJson(data as Map<String, dynamic>);
    } catch (_) {}
    try {
      $int = (data as int);
    } catch (_) {}
    assert([userStatusClearAt, $int].where((final x) => x != null).length >= 1, 'Need oneOf for $data');
    return NextcloudUserStatusPredefinedStatus_ClearAt(
      data,
      userStatusClearAt: userStatusClearAt,
      $int: $int,
    );
  }

  // coverage:ignore-start
  factory NextcloudUserStatusPredefinedStatus_ClearAt.fromJsonString(String data) =>
      NextcloudUserStatusPredefinedStatus_ClearAt.fromJson(json.decode(data));
  // coverage:ignore-end

  final dynamic _data;

  final NextcloudUserStatusClearAt? userStatusClearAt;

  /// Time as unix timestamp
  final int? $int;

  // coverage:ignore-start
  dynamic toJson() => _data;
  // coverage:ignore-end
  // coverage:ignore-start
  static String toJsonString(dynamic data) => json.encode(data);
  // coverage:ignore-end
}

@JsonSerializable()
class NextcloudUserStatusPredefinedStatus {
  NextcloudUserStatusPredefinedStatus({
    required this.id,
    required this.icon,
    required this.message,
    this.clearAt,
  });

  // coverage:ignore-start
  factory NextcloudUserStatusPredefinedStatus.fromJson(Map<String, dynamic> json) =>
      _$NextcloudUserStatusPredefinedStatusFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudUserStatusPredefinedStatus.fromJsonString(String data) =>
      NextcloudUserStatusPredefinedStatus.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final String id;

  final String icon;

  final String message;

  final NextcloudUserStatusPredefinedStatus_ClearAt? clearAt;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudUserStatusPredefinedStatusToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudUserStatusPredefinedStatus? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudUserStatusPredefinedStatuses_Ocs {
  NextcloudUserStatusPredefinedStatuses_Ocs({
    required this.meta,
    required this.data,
  });

  // coverage:ignore-start
  factory NextcloudUserStatusPredefinedStatuses_Ocs.fromJson(Map<String, dynamic> json) =>
      _$NextcloudUserStatusPredefinedStatuses_OcsFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudUserStatusPredefinedStatuses_Ocs.fromJsonString(String data) =>
      NextcloudUserStatusPredefinedStatuses_Ocs.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudOCSMeta meta;

  final BuiltList<NextcloudUserStatusPredefinedStatus> data;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudUserStatusPredefinedStatuses_OcsToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudUserStatusPredefinedStatuses_Ocs? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudUserStatusPredefinedStatuses {
  NextcloudUserStatusPredefinedStatuses({required this.ocs});

  // coverage:ignore-start
  factory NextcloudUserStatusPredefinedStatuses.fromJson(Map<String, dynamic> json) =>
      _$NextcloudUserStatusPredefinedStatusesFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudUserStatusPredefinedStatuses.fromJsonString(String data) =>
      NextcloudUserStatusPredefinedStatuses.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudUserStatusPredefinedStatuses_Ocs ocs;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudUserStatusPredefinedStatusesToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudUserStatusPredefinedStatuses? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudUserStatusHeartbeat_Ocs {
  NextcloudUserStatusHeartbeat_Ocs({
    required this.meta,
    required this.data,
  });

  // coverage:ignore-start
  factory NextcloudUserStatusHeartbeat_Ocs.fromJson(Map<String, dynamic> json) =>
      _$NextcloudUserStatusHeartbeat_OcsFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudUserStatusHeartbeat_Ocs.fromJsonString(String data) =>
      NextcloudUserStatusHeartbeat_Ocs.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudOCSMeta meta;

  final NextcloudUserStatusStatus data;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudUserStatusHeartbeat_OcsToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudUserStatusHeartbeat_Ocs? data) =>
      data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudUserStatusHeartbeat {
  NextcloudUserStatusHeartbeat({required this.ocs});

  // coverage:ignore-start
  factory NextcloudUserStatusHeartbeat.fromJson(Map<String, dynamic> json) =>
      _$NextcloudUserStatusHeartbeatFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudUserStatusHeartbeat.fromJsonString(String data) =>
      NextcloudUserStatusHeartbeat.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final NextcloudUserStatusHeartbeat_Ocs ocs;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudUserStatusHeartbeatToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudUserStatusHeartbeat? data) => data == null ? null : json.encode(data.toJson());
}

@JsonSerializable()
class NextcloudNotificationsNotificationDecryptedSubject {
  NextcloudNotificationsNotificationDecryptedSubject({
    this.nid,
    this.app,
    this.subject,
    this.type,
    this.id,
    this.delete,
    this.deleteAll,
  });

  // coverage:ignore-start
  factory NextcloudNotificationsNotificationDecryptedSubject.fromJson(Map<String, dynamic> json) =>
      _$NextcloudNotificationsNotificationDecryptedSubjectFromJson(json);
  // coverage:ignore-end

  // coverage:ignore-start
  factory NextcloudNotificationsNotificationDecryptedSubject.fromJsonString(String data) =>
      NextcloudNotificationsNotificationDecryptedSubject.fromJson(json.decode(data) as Map<String, dynamic>);
  // coverage:ignore-end

  final int? nid;

  final String? app;

  final String? subject;

  final String? type;

  final String? id;

  final bool? delete;

  @JsonKey(name: 'delete-all')
  final bool? deleteAll;

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$NextcloudNotificationsNotificationDecryptedSubjectToJson(this);
  // coverage:ignore-end
  static String? toJsonString(NextcloudNotificationsNotificationDecryptedSubject? data) =>
      data == null ? null : json.encode(data.toJson());
}

@SerializersFor([
  NextcloudCoreServerStatus,
  NextcloudCoreServerCapabilities,
  NextcloudCoreServerCapabilities_Ocs,
  NextcloudOCSMeta,
  NextcloudCoreServerCapabilities_Ocs_Data,
  NextcloudCoreServerCapabilities_Ocs_Data_Version,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Core,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Bruteforce,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_MetadataAvailable,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Files,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Files_DirectEditing,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Activity,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Status,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Settings,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle_Constants,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle_Constants_Source,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Circle_Config,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Member,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Circles_Member_Constants,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Ocm,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Ocm_ResourceTypes,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Ocm_ResourceTypes_Protocols,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Dav,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_Password,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_ExpireDate,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_ExpireDateInternal,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Public_ExpireDateRemote,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_User,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_User_ExpireDate,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Group,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Group_ExpireDate,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Federation,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Federation_ExpireDate,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Federation_ExpireDateSupported,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharee,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail_UploadFilesDrop,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail_Password,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_FilesSharing_Sharebymail_ExpireDate,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Notes,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Notifications,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_PasswordPolicy,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_PasswordPolicy_Api,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_ProvisioningApi,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_Theming,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_UserStatus,
  NextcloudCoreServerCapabilities_Ocs_Data_Capabilities_WeatherStatus,
  NextcloudCoreNavigationApps,
  NextcloudCoreNavigationApps_Ocs,
  NextcloudCoreNavigationApps_Ocs_Data,
  NextcloudCoreLoginFlowInit,
  NextcloudCoreLoginFlowInit_Poll,
  NextcloudCoreLoginFlowResult,
  NextcloudCoreAutocompleteResult,
  NextcloudCoreAutocompleteResult_Ocs,
  NextcloudCoreAutocompleteResult_Ocs_Data,
  NextcloudNewsSupportedAPIVersions,
  NextcloudNewsListFolders,
  NextcloudNewsFolder,
  NextcloudNewsFeed,
  NextcloudNewsArticle,
  NextcloudNewsListFeeds,
  NextcloudNewsListArticles,
  NextcloudNotesNote,
  NextcloudNotesSettings,
  NextcloudNotificationsListNotifications,
  NextcloudNotificationsListNotifications_Ocs,
  NextcloudNotificationsNotification,
  NextcloudNotificationsNotificationAction,
  NextcloudNotificationsGetNotification,
  NextcloudNotificationsGetNotification_Ocs,
  NextcloudEmptyOCS,
  NextcloudEmptyOCS_Ocs,
  NextcloudNotificationsPushServerRegistration,
  NextcloudNotificationsPushServerRegistration_Ocs,
  NextcloudNotificationsPushServerSubscription,
  NextcloudProvisioningApiUser,
  NextcloudProvisioningApiUser_Ocs,
  NextcloudProvisioningApiUserDetails,
  NextcloudProvisioningApiUserDetails_Quota,
  NextcloudProvisioningApiUserDetails_BackendCapabilities,
  NextcloudUnifiedPushProviderCheckResponse200ApplicationJson,
  NextcloudUnifiedPushProviderSetKeepaliveResponse200ApplicationJson,
  NextcloudUnifiedPushProviderCreateDeviceResponse200ApplicationJson,
  NextcloudUnifiedPushProviderSyncDeviceResponse401ApplicationJson,
  NextcloudUnifiedPushProviderDeleteDeviceResponse200ApplicationJson,
  NextcloudUnifiedPushProviderCreateAppResponse200ApplicationJson,
  NextcloudUnifiedPushProviderDeleteAppResponse200ApplicationJson,
  NextcloudUnifiedPushProviderUnifiedpushDiscoveryResponse200ApplicationJson,
  NextcloudUnifiedPushProviderUnifiedpushDiscoveryResponse200ApplicationJson_Unifiedpush,
  NextcloudUnifiedPushProviderPushResponse201ApplicationJson,
  NextcloudUnifiedPushProviderGatewayMatrixDiscoveryResponse200ApplicationJson,
  NextcloudUnifiedPushProviderGatewayMatrixDiscoveryResponse200ApplicationJson_Unifiedpush,
  NextcloudUnifiedPushProviderGatewayMatrixResponse200ApplicationJson,
  NextcloudUserStatusGetPublicStatuses,
  NextcloudUserStatusGetPublicStatuses_Ocs,
  NextcloudUserStatusPublicStatus,
  NextcloudUserStatusClearAt,
  NextcloudUserStatusGetPublicStatus,
  NextcloudUserStatusGetPublicStatus_Ocs,
  NextcloudUserStatusGetStatus,
  NextcloudUserStatusGetStatus_Ocs,
  NextcloudUserStatusStatus,
  NextcloudUserStatusPredefinedStatuses,
  NextcloudUserStatusPredefinedStatuses_Ocs,
  NextcloudUserStatusPredefinedStatus,
  NextcloudUserStatusHeartbeat,
  NextcloudUserStatusHeartbeat_Ocs,
  NextcloudNotificationsNotificationDecryptedSubject,
])
final Serializers serializers = (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();

// coverage:ignore-start
T deserializeNextcloud<T>(final Object data) => serializers.deserialize(data, specifiedType: FullType(T))! as T;

Object? serializeNextcloud<T>(final T data) => serializers.serialize(data, specifiedType: FullType(T));
// coverage:ignore-end
