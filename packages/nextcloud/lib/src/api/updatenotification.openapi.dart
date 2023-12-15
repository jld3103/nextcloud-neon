// ignore_for_file: camel_case_types
// ignore_for_file: discarded_futures
// ignore_for_file: public_member_api_docs
// ignore_for_file: unreachable_switch_case
// ignore_for_file: camel_case_extensions
import 'dart:typed_data';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:collection/collection.dart';
import 'package:dynamite_runtime/built_value.dart';
import 'package:dynamite_runtime/http_client.dart';
import 'package:meta/meta.dart';
import 'package:universal_io/io.dart';
import 'package:uri/uri.dart';

part 'updatenotification.openapi.g.dart';

class Client extends DynamiteClient {
  Client(
    super.baseURL, {
    super.baseHeaders,
    super.userAgent,
    super.httpClient,
    super.cookieJar,
    super.authentications,
  });

  Client.fromClient(final DynamiteClient client)
      : super(
          client.baseURL,
          baseHeaders: client.baseHeaders,
          httpClient: client.httpClient,
          cookieJar: client.cookieJar,
          authentications: client.authentications,
        );

  ApiClient get api => ApiClient(this);
}

class ApiClient {
  ApiClient(this._rootClient);

  final Client _rootClient;

  /// List available updates for apps.
  ///
  /// This endpoint requires admin access.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [newVersion] Server version to check updates for.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Apps returned
  ///   * 404: New versions not found
  ///
  /// See:
  ///  * [getAppListRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<ApiGetAppListResponseApplicationJson, void>> getAppList({
    required final String newVersion,
    final ApiGetAppListApiVersion? apiVersion,
    final bool? oCSAPIRequest,
  }) async {
    final rawResponse = getAppListRaw(
      newVersion: newVersion,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// List available updates for apps.
  ///
  /// This endpoint requires admin access.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [newVersion] Server version to check updates for.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Apps returned
  ///   * 404: New versions not found
  ///
  /// See:
  ///  * [getAppList] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<ApiGetAppListResponseApplicationJson, void> getAppListRaw({
    required final String newVersion,
    final ApiGetAppListApiVersion? apiVersion,
    final bool? oCSAPIRequest,
  }) {
    final pathParameters = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;

// coverage:ignore-start
    final authentication = _rootClient.authentications.firstWhereOrNull(
      (final auth) => switch (auth) {
        DynamiteHttpBearerAuthentication() || DynamiteHttpBasicAuthentication() => true,
        _ => false,
      },
    );

    if (authentication != null) {
      headers.addAll(
        authentication.headers,
      );
    } else {
      throw Exception('Missing authentication for bearer_auth or basic_auth');
    }

// coverage:ignore-end
    pathParameters['newVersion'] = newVersion;
    pathParameters['apiVersion'] = (apiVersion ?? ApiGetAppListApiVersion.v1).name;
    headers['OCS-APIRequest'] = (oCSAPIRequest ?? true).toString();
    var uri = Uri.parse(
      UriTemplate('/ocs/v2.php/apps/updatenotification/api/{apiVersion}/applist/{newVersion}').expand(pathParameters),
    );
    if (queryParameters.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParameters);
    }

    return DynamiteRawResponse<ApiGetAppListResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(ApiGetAppListResponseApplicationJson),
      headersType: null,
      serializers: jsonSerializers,
    );
  }
}

class ApiGetAppListApiVersion extends EnumClass {
  const ApiGetAppListApiVersion._(super.name);

  static const ApiGetAppListApiVersion v1 = _$apiGetAppListApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<ApiGetAppListApiVersion> get values => _$apiGetAppListApiVersionValues;
  // coverage:ignore-end

  static ApiGetAppListApiVersion valueOf(final String name) => _$valueOfApiGetAppListApiVersion(name);

  static Serializer<ApiGetAppListApiVersion> get serializer => _$apiGetAppListApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class $OCSMetaInterface {
  String get status;
  int get statuscode;
  String? get message;
  String? get totalitems;
  String? get itemsperpage;
}

abstract class OCSMeta implements $OCSMetaInterface, Built<OCSMeta, OCSMetaBuilder> {
  factory OCSMeta([final void Function(OCSMetaBuilder)? b]) = _$OCSMeta;

  // coverage:ignore-start
  const OCSMeta._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory OCSMeta.fromJson(final Map<String, dynamic> json) => jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end

  static Serializer<OCSMeta> get serializer => _$oCSMetaSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class $AppInterface {
  String get appId;
  String get appName;
}

abstract class App implements $AppInterface, Built<App, AppBuilder> {
  factory App([final void Function(AppBuilder)? b]) = _$App;

  // coverage:ignore-start
  const App._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory App.fromJson(final Map<String, dynamic> json) => jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end

  static Serializer<App> get serializer => _$appSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class $ApiGetAppListResponseApplicationJson_Ocs_DataInterface {
  BuiltList<App> get missing;
  BuiltList<App> get available;
}

abstract class ApiGetAppListResponseApplicationJson_Ocs_Data
    implements
        $ApiGetAppListResponseApplicationJson_Ocs_DataInterface,
        Built<ApiGetAppListResponseApplicationJson_Ocs_Data, ApiGetAppListResponseApplicationJson_Ocs_DataBuilder> {
  factory ApiGetAppListResponseApplicationJson_Ocs_Data([
    final void Function(ApiGetAppListResponseApplicationJson_Ocs_DataBuilder)? b,
  ]) = _$ApiGetAppListResponseApplicationJson_Ocs_Data;

  // coverage:ignore-start
  const ApiGetAppListResponseApplicationJson_Ocs_Data._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ApiGetAppListResponseApplicationJson_Ocs_Data.fromJson(final Map<String, dynamic> json) =>
      jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end

  static Serializer<ApiGetAppListResponseApplicationJson_Ocs_Data> get serializer =>
      _$apiGetAppListResponseApplicationJsonOcsDataSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class $ApiGetAppListResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  ApiGetAppListResponseApplicationJson_Ocs_Data get data;
}

abstract class ApiGetAppListResponseApplicationJson_Ocs
    implements
        $ApiGetAppListResponseApplicationJson_OcsInterface,
        Built<ApiGetAppListResponseApplicationJson_Ocs, ApiGetAppListResponseApplicationJson_OcsBuilder> {
  factory ApiGetAppListResponseApplicationJson_Ocs([
    final void Function(ApiGetAppListResponseApplicationJson_OcsBuilder)? b,
  ]) = _$ApiGetAppListResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const ApiGetAppListResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ApiGetAppListResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end

  static Serializer<ApiGetAppListResponseApplicationJson_Ocs> get serializer =>
      _$apiGetAppListResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class $ApiGetAppListResponseApplicationJsonInterface {
  ApiGetAppListResponseApplicationJson_Ocs get ocs;
}

abstract class ApiGetAppListResponseApplicationJson
    implements
        $ApiGetAppListResponseApplicationJsonInterface,
        Built<ApiGetAppListResponseApplicationJson, ApiGetAppListResponseApplicationJsonBuilder> {
  factory ApiGetAppListResponseApplicationJson([final void Function(ApiGetAppListResponseApplicationJsonBuilder)? b]) =
      _$ApiGetAppListResponseApplicationJson;

  // coverage:ignore-start
  const ApiGetAppListResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ApiGetAppListResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end

  static Serializer<ApiGetAppListResponseApplicationJson> get serializer =>
      _$apiGetAppListResponseApplicationJsonSerializer;
}

// coverage:ignore-start
@visibleForTesting
final Serializers serializers = (Serializers().toBuilder()
      ..add(ApiGetAppListApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(ApiGetAppListResponseApplicationJson),
        ApiGetAppListResponseApplicationJsonBuilder.new,
      )
      ..add(ApiGetAppListResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(ApiGetAppListResponseApplicationJson_Ocs),
        ApiGetAppListResponseApplicationJson_OcsBuilder.new,
      )
      ..add(ApiGetAppListResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(const FullType(OCSMeta), OCSMetaBuilder.new)
      ..add(OCSMeta.serializer)
      ..addBuilderFactory(
        const FullType(ApiGetAppListResponseApplicationJson_Ocs_Data),
        ApiGetAppListResponseApplicationJson_Ocs_DataBuilder.new,
      )
      ..add(ApiGetAppListResponseApplicationJson_Ocs_Data.serializer)
      ..addBuilderFactory(const FullType(App), AppBuilder.new)
      ..add(App.serializer)
      ..addBuilderFactory(const FullType(BuiltList, [FullType(App)]), ListBuilder<App>.new))
    .build();

@visibleForTesting
final Serializers jsonSerializers = (serializers.toBuilder()
      ..add(DynamiteDoubleSerializer())
      ..addPlugin(StandardJsonPlugin())
      ..addPlugin(const ContentStringPlugin()))
    .build();
// coverage:ignore-end
