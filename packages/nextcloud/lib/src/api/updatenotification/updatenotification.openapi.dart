// Use of this source code is governed by a agpl license. It can be obtained at `https://spdx.org/licenses/AGPL-3.0-only.html`.

// OpenAPI client generated by Dynamite. Do not manually edit this file.

// ignore_for_file: camel_case_extensions, camel_case_types, cascade_invocations
// ignore_for_file: discarded_futures
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: non_constant_identifier_names, public_member_api_docs
// ignore_for_file: unreachable_switch_case

/// updatenotification Version: 0.0.1.
///
/// Displays update notifications for Nextcloud, app updates, and provides the SSO for the updater.
///
/// Use of this source code is governed by a agpl license.
/// It can be obtained at `https://spdx.org/licenses/AGPL-3.0-only.html`.
library; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart' as _i8;
import 'package:collection/collection.dart' as _i5;
import 'package:dynamite_runtime/built_value.dart' as _i7;
import 'package:dynamite_runtime/http_client.dart' as _i1;
import 'package:dynamite_runtime/utils.dart' as _i6;
import 'package:http/http.dart' as _i3;
import 'package:meta/meta.dart' as _i2;
import 'package:uri/uri.dart' as _i4;

part 'updatenotification.openapi.g.dart';

class $Client extends _i1.DynamiteClient {
  /// Creates a new `DynamiteClient` for untagged requests.
  $Client(
    super.baseURL, {
    super.httpClient,
    super.authentications,
  });

  /// Creates a new [$Client] from another [client].
  $Client.fromClient(_i1.DynamiteClient client)
      : super(
          client.baseURL,
          httpClient: client.httpClient,
          authentications: client.authentications,
        );

  late final $ApiClient api = $ApiClient(this);
}

class $ApiClient {
  /// Creates a new `DynamiteClient` for api requests.
  $ApiClient(this._rootClient);

  final $Client _rootClient;

  /// Builds a serializer to parse the response of [$getAppList_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<ApiGetAppListResponseApplicationJson, void> $getAppList_Serializer() => _i1.DynamiteSerializer(
        bodyType: const FullType(ApiGetAppListResponseApplicationJson),
        headersType: null,
        serializers: _$jsonSerializers,
        validStatuses: const {200},
      );

  /// List available updates for apps.
  ///
  /// This endpoint requires admin access.
  ///
  /// Returns a `DynamiteRequest` backing the [getAppList] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `"v1"`.
  ///   * [newVersion] Server version to check updates for.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Apps returned
  ///   * 404: New versions not found
  ///
  /// See:
  ///  * [getAppList] for a method executing this request and parsing the response.
  ///  * [$getAppList_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i3.Request $getAppList_Request({
    required String newVersion,
    ApiGetAppListApiVersion? apiVersion,
    bool? oCSAPIRequest,
  }) {
    final _parameters = <String, Object?>{};
    final __newVersion = _$jsonSerializers.serialize(newVersion, specifiedType: const FullType(String));
    _parameters['newVersion'] = __newVersion;

    var __apiVersion = _$jsonSerializers.serialize(apiVersion, specifiedType: const FullType(ApiGetAppListApiVersion));
    __apiVersion ??= 'v1';
    _parameters['apiVersion'] = __apiVersion;

    final _path = _i4.UriTemplate('/ocs/v2.php/apps/updatenotification/api/{apiVersion}/applist/{newVersion}')
        .expand(_parameters);
    final _uri = Uri.parse('${_rootClient.baseURL}$_path');
    final _request = _i3.Request('get', _uri);
    _request.headers['Accept'] = 'application/json';
// coverage:ignore-start
    final authentication = _i5.IterableExtension(_rootClient.authentications)?.firstWhereOrNull(
      (auth) => switch (auth) {
        _i1.DynamiteHttpBearerAuthentication() || _i1.DynamiteHttpBasicAuthentication() => true,
        _ => false,
      },
    );

    if (authentication != null) {
      _request.headers.addAll(
        authentication.headers,
      );
    } else {
      throw Exception('Missing authentication for bearer_auth or basic_auth');
    }

// coverage:ignore-end
    var __oCSAPIRequest = _$jsonSerializers.serialize(oCSAPIRequest, specifiedType: const FullType(bool));
    __oCSAPIRequest ??= true;
    _request.headers['OCS-APIRequest'] = const _i6.HeaderEncoder().convert(__oCSAPIRequest);

    return _request;
  }

  /// List available updates for apps.
  ///
  /// This endpoint requires admin access.
  ///
  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `"v1"`.
  ///   * [newVersion] Server version to check updates for.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Apps returned
  ///   * 404: New versions not found
  ///
  /// See:
  ///  * [$getAppList_Request] for the request send by this method.
  ///  * [$getAppList_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<ApiGetAppListResponseApplicationJson, void>> getAppList({
    required String newVersion,
    ApiGetAppListApiVersion? apiVersion,
    bool? oCSAPIRequest,
  }) async {
    final _request = $getAppList_Request(
      newVersion: newVersion,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );
    final _streamedResponse = await _rootClient.httpClient.send(_request);
    final _response = await _i3.Response.fromStream(_streamedResponse);

    final _serializer = $getAppList_Serializer();
    return _i1.ResponseConverter<ApiGetAppListResponseApplicationJson, void>(_serializer).convert(_response);
  }

  /// Builds a serializer to parse the response of [$getAppChangelogEntry_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<ApiGetAppChangelogEntryResponseApplicationJson, void> $getAppChangelogEntry_Serializer() =>
      _i1.DynamiteSerializer(
        bodyType: const FullType(ApiGetAppChangelogEntryResponseApplicationJson),
        headersType: null,
        serializers: _$jsonSerializers,
        validStatuses: const {200},
      );

  /// Get changelog entry for an app.
  ///
  /// This endpoint requires admin access.
  ///
  /// Returns a `DynamiteRequest` backing the [getAppChangelogEntry] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `"v1"`.
  ///   * [appId] App to search changelog entry for.
  ///   * [version] The version to search the changelog entry for (defaults to the latest installed).
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Changelog entry returned
  ///   * 404: No changelog found
  ///   * 400: The `version` parameter is not a valid version format
  ///
  /// See:
  ///  * [getAppChangelogEntry] for a method executing this request and parsing the response.
  ///  * [$getAppChangelogEntry_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i3.Request $getAppChangelogEntry_Request({
    required String appId,
    ApiGetAppChangelogEntryApiVersion? apiVersion,
    String? version,
    bool? oCSAPIRequest,
  }) {
    final _parameters = <String, Object?>{};
    final __appId = _$jsonSerializers.serialize(appId, specifiedType: const FullType(String));
    _parameters['appId'] = __appId;

    var __apiVersion =
        _$jsonSerializers.serialize(apiVersion, specifiedType: const FullType(ApiGetAppChangelogEntryApiVersion));
    __apiVersion ??= 'v1';
    _parameters['apiVersion'] = __apiVersion;

    final __version = _$jsonSerializers.serialize(version, specifiedType: const FullType(String));
    _parameters['version'] = __version;

    final _path = _i4.UriTemplate('/ocs/v2.php/apps/updatenotification/api/{apiVersion}/changelog/{appId}{?version*}')
        .expand(_parameters);
    final _uri = Uri.parse('${_rootClient.baseURL}$_path');
    final _request = _i3.Request('get', _uri);
    _request.headers['Accept'] = 'application/json';
// coverage:ignore-start
    final authentication = _i5.IterableExtension(_rootClient.authentications)?.firstWhereOrNull(
      (auth) => switch (auth) {
        _i1.DynamiteHttpBearerAuthentication() || _i1.DynamiteHttpBasicAuthentication() => true,
        _ => false,
      },
    );

    if (authentication != null) {
      _request.headers.addAll(
        authentication.headers,
      );
    } else {
      throw Exception('Missing authentication for bearer_auth or basic_auth');
    }

// coverage:ignore-end
    var __oCSAPIRequest = _$jsonSerializers.serialize(oCSAPIRequest, specifiedType: const FullType(bool));
    __oCSAPIRequest ??= true;
    _request.headers['OCS-APIRequest'] = const _i6.HeaderEncoder().convert(__oCSAPIRequest);

    return _request;
  }

  /// Get changelog entry for an app.
  ///
  /// This endpoint requires admin access.
  ///
  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `"v1"`.
  ///   * [appId] App to search changelog entry for.
  ///   * [version] The version to search the changelog entry for (defaults to the latest installed).
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Changelog entry returned
  ///   * 404: No changelog found
  ///   * 400: The `version` parameter is not a valid version format
  ///
  /// See:
  ///  * [$getAppChangelogEntry_Request] for the request send by this method.
  ///  * [$getAppChangelogEntry_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<ApiGetAppChangelogEntryResponseApplicationJson, void>> getAppChangelogEntry({
    required String appId,
    ApiGetAppChangelogEntryApiVersion? apiVersion,
    String? version,
    bool? oCSAPIRequest,
  }) async {
    final _request = $getAppChangelogEntry_Request(
      appId: appId,
      apiVersion: apiVersion,
      version: version,
      oCSAPIRequest: oCSAPIRequest,
    );
    final _streamedResponse = await _rootClient.httpClient.send(_request);
    final _response = await _i3.Response.fromStream(_streamedResponse);

    final _serializer = $getAppChangelogEntry_Serializer();
    return _i1.ResponseConverter<ApiGetAppChangelogEntryResponseApplicationJson, void>(_serializer).convert(_response);
  }
}

class ApiGetAppListApiVersion extends EnumClass {
  const ApiGetAppListApiVersion._(super.name);

  /// `v1`
  static const ApiGetAppListApiVersion v1 = _$apiGetAppListApiVersionV1;

  /// Returns a set with all values this enum contains.
  // coverage:ignore-start
  static BuiltSet<ApiGetAppListApiVersion> get values => _$apiGetAppListApiVersionValues;
  // coverage:ignore-end

  /// Returns the enum value associated to the [name].
  static ApiGetAppListApiVersion valueOf(String name) => _$valueOfApiGetAppListApiVersion(name);

  /// Returns the serialized value of this enum value.
  String get value => _$jsonSerializers.serializeWith(serializer, this)! as String;

  /// Serializer for ApiGetAppListApiVersion.
  @BuiltValueSerializer(custom: true)
  static Serializer<ApiGetAppListApiVersion> get serializer => const _$ApiGetAppListApiVersionSerializer();
}

class _$ApiGetAppListApiVersionSerializer implements PrimitiveSerializer<ApiGetAppListApiVersion> {
  const _$ApiGetAppListApiVersionSerializer();

  static const Map<ApiGetAppListApiVersion, Object> _toWire = <ApiGetAppListApiVersion, Object>{
    ApiGetAppListApiVersion.v1: 'v1',
  };

  static const Map<Object, ApiGetAppListApiVersion> _fromWire = <Object, ApiGetAppListApiVersion>{
    'v1': ApiGetAppListApiVersion.v1,
  };

  @override
  Iterable<Type> get types => const [ApiGetAppListApiVersion];

  @override
  String get wireName => 'ApiGetAppListApiVersion';

  @override
  Object serialize(
    Serializers serializers,
    ApiGetAppListApiVersion object, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      _toWire[object]!;

  @override
  ApiGetAppListApiVersion deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      _fromWire[serialized]!;
}

@BuiltValue(instantiable: false)
sealed class $OCSMetaInterface {
  String get status;
  int get statuscode;
  String? get message;
  String? get totalitems;
  String? get itemsperpage;

  /// Rebuilds the instance.
  ///
  /// The result is the same as this instance but with [updates] applied.
  /// [updates] is a function that takes a builder [$OCSMetaInterfaceBuilder].
  $OCSMetaInterface rebuild(void Function($OCSMetaInterfaceBuilder) updates);

  /// Converts the instance to a builder [$OCSMetaInterfaceBuilder].
  $OCSMetaInterfaceBuilder toBuilder();
  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($OCSMetaInterfaceBuilder b) {}
  @BuiltValueHook(finalizeBuilder: true)
  static void _validate($OCSMetaInterfaceBuilder b) {}
}

abstract class OCSMeta implements $OCSMetaInterface, Built<OCSMeta, OCSMetaBuilder> {
  /// Creates a new OCSMeta object using the builder pattern.
  factory OCSMeta([void Function(OCSMetaBuilder)? b]) = _$OCSMeta;

  // coverage:ignore-start
  const OCSMeta._();
  // coverage:ignore-end

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  // coverage:ignore-start
  factory OCSMeta.fromJson(Map<String, dynamic> json) => _$jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end

  /// Serializer for OCSMeta.
  static Serializer<OCSMeta> get serializer => _$oCSMetaSerializer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OCSMetaBuilder b) {
    $OCSMetaInterface._defaults(b);
  }

  @BuiltValueHook(finalizeBuilder: true)
  static void _validate(OCSMetaBuilder b) {
    $OCSMetaInterface._validate(b);
  }
}

@BuiltValue(instantiable: false)
sealed class $AppInterface {
  String get appId;
  String get appName;

  /// Rebuilds the instance.
  ///
  /// The result is the same as this instance but with [updates] applied.
  /// [updates] is a function that takes a builder [$AppInterfaceBuilder].
  $AppInterface rebuild(void Function($AppInterfaceBuilder) updates);

  /// Converts the instance to a builder [$AppInterfaceBuilder].
  $AppInterfaceBuilder toBuilder();
  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($AppInterfaceBuilder b) {}
  @BuiltValueHook(finalizeBuilder: true)
  static void _validate($AppInterfaceBuilder b) {}
}

abstract class App implements $AppInterface, Built<App, AppBuilder> {
  /// Creates a new App object using the builder pattern.
  factory App([void Function(AppBuilder)? b]) = _$App;

  // coverage:ignore-start
  const App._();
  // coverage:ignore-end

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  // coverage:ignore-start
  factory App.fromJson(Map<String, dynamic> json) => _$jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end

  /// Serializer for App.
  static Serializer<App> get serializer => _$appSerializer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AppBuilder b) {
    $AppInterface._defaults(b);
  }

  @BuiltValueHook(finalizeBuilder: true)
  static void _validate(AppBuilder b) {
    $AppInterface._validate(b);
  }
}

@BuiltValue(instantiable: false)
sealed class $ApiGetAppListResponseApplicationJson_Ocs_DataInterface {
  BuiltList<App> get missing;
  BuiltList<App> get available;

  /// Rebuilds the instance.
  ///
  /// The result is the same as this instance but with [updates] applied.
  /// [updates] is a function that takes a builder [$ApiGetAppListResponseApplicationJson_Ocs_DataInterfaceBuilder].
  $ApiGetAppListResponseApplicationJson_Ocs_DataInterface rebuild(
    void Function($ApiGetAppListResponseApplicationJson_Ocs_DataInterfaceBuilder) updates,
  );

  /// Converts the instance to a builder [$ApiGetAppListResponseApplicationJson_Ocs_DataInterfaceBuilder].
  $ApiGetAppListResponseApplicationJson_Ocs_DataInterfaceBuilder toBuilder();
  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($ApiGetAppListResponseApplicationJson_Ocs_DataInterfaceBuilder b) {}
  @BuiltValueHook(finalizeBuilder: true)
  static void _validate($ApiGetAppListResponseApplicationJson_Ocs_DataInterfaceBuilder b) {}
}

abstract class ApiGetAppListResponseApplicationJson_Ocs_Data
    implements
        $ApiGetAppListResponseApplicationJson_Ocs_DataInterface,
        Built<ApiGetAppListResponseApplicationJson_Ocs_Data, ApiGetAppListResponseApplicationJson_Ocs_DataBuilder> {
  /// Creates a new ApiGetAppListResponseApplicationJson_Ocs_Data object using the builder pattern.
  factory ApiGetAppListResponseApplicationJson_Ocs_Data([
    void Function(ApiGetAppListResponseApplicationJson_Ocs_DataBuilder)? b,
  ]) = _$ApiGetAppListResponseApplicationJson_Ocs_Data;

  // coverage:ignore-start
  const ApiGetAppListResponseApplicationJson_Ocs_Data._();
  // coverage:ignore-end

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  // coverage:ignore-start
  factory ApiGetAppListResponseApplicationJson_Ocs_Data.fromJson(Map<String, dynamic> json) =>
      _$jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end

  /// Serializer for ApiGetAppListResponseApplicationJson_Ocs_Data.
  static Serializer<ApiGetAppListResponseApplicationJson_Ocs_Data> get serializer =>
      _$apiGetAppListResponseApplicationJsonOcsDataSerializer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiGetAppListResponseApplicationJson_Ocs_DataBuilder b) {
    $ApiGetAppListResponseApplicationJson_Ocs_DataInterface._defaults(b);
  }

  @BuiltValueHook(finalizeBuilder: true)
  static void _validate(ApiGetAppListResponseApplicationJson_Ocs_DataBuilder b) {
    $ApiGetAppListResponseApplicationJson_Ocs_DataInterface._validate(b);
  }
}

@BuiltValue(instantiable: false)
sealed class $ApiGetAppListResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  ApiGetAppListResponseApplicationJson_Ocs_Data get data;

  /// Rebuilds the instance.
  ///
  /// The result is the same as this instance but with [updates] applied.
  /// [updates] is a function that takes a builder [$ApiGetAppListResponseApplicationJson_OcsInterfaceBuilder].
  $ApiGetAppListResponseApplicationJson_OcsInterface rebuild(
    void Function($ApiGetAppListResponseApplicationJson_OcsInterfaceBuilder) updates,
  );

  /// Converts the instance to a builder [$ApiGetAppListResponseApplicationJson_OcsInterfaceBuilder].
  $ApiGetAppListResponseApplicationJson_OcsInterfaceBuilder toBuilder();
  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($ApiGetAppListResponseApplicationJson_OcsInterfaceBuilder b) {}
  @BuiltValueHook(finalizeBuilder: true)
  static void _validate($ApiGetAppListResponseApplicationJson_OcsInterfaceBuilder b) {}
}

abstract class ApiGetAppListResponseApplicationJson_Ocs
    implements
        $ApiGetAppListResponseApplicationJson_OcsInterface,
        Built<ApiGetAppListResponseApplicationJson_Ocs, ApiGetAppListResponseApplicationJson_OcsBuilder> {
  /// Creates a new ApiGetAppListResponseApplicationJson_Ocs object using the builder pattern.
  factory ApiGetAppListResponseApplicationJson_Ocs([
    void Function(ApiGetAppListResponseApplicationJson_OcsBuilder)? b,
  ]) = _$ApiGetAppListResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const ApiGetAppListResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  // coverage:ignore-start
  factory ApiGetAppListResponseApplicationJson_Ocs.fromJson(Map<String, dynamic> json) =>
      _$jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end

  /// Serializer for ApiGetAppListResponseApplicationJson_Ocs.
  static Serializer<ApiGetAppListResponseApplicationJson_Ocs> get serializer =>
      _$apiGetAppListResponseApplicationJsonOcsSerializer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiGetAppListResponseApplicationJson_OcsBuilder b) {
    $ApiGetAppListResponseApplicationJson_OcsInterface._defaults(b);
  }

  @BuiltValueHook(finalizeBuilder: true)
  static void _validate(ApiGetAppListResponseApplicationJson_OcsBuilder b) {
    $ApiGetAppListResponseApplicationJson_OcsInterface._validate(b);
  }
}

@BuiltValue(instantiable: false)
sealed class $ApiGetAppListResponseApplicationJsonInterface {
  ApiGetAppListResponseApplicationJson_Ocs get ocs;

  /// Rebuilds the instance.
  ///
  /// The result is the same as this instance but with [updates] applied.
  /// [updates] is a function that takes a builder [$ApiGetAppListResponseApplicationJsonInterfaceBuilder].
  $ApiGetAppListResponseApplicationJsonInterface rebuild(
    void Function($ApiGetAppListResponseApplicationJsonInterfaceBuilder) updates,
  );

  /// Converts the instance to a builder [$ApiGetAppListResponseApplicationJsonInterfaceBuilder].
  $ApiGetAppListResponseApplicationJsonInterfaceBuilder toBuilder();
  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($ApiGetAppListResponseApplicationJsonInterfaceBuilder b) {}
  @BuiltValueHook(finalizeBuilder: true)
  static void _validate($ApiGetAppListResponseApplicationJsonInterfaceBuilder b) {}
}

abstract class ApiGetAppListResponseApplicationJson
    implements
        $ApiGetAppListResponseApplicationJsonInterface,
        Built<ApiGetAppListResponseApplicationJson, ApiGetAppListResponseApplicationJsonBuilder> {
  /// Creates a new ApiGetAppListResponseApplicationJson object using the builder pattern.
  factory ApiGetAppListResponseApplicationJson([void Function(ApiGetAppListResponseApplicationJsonBuilder)? b]) =
      _$ApiGetAppListResponseApplicationJson;

  // coverage:ignore-start
  const ApiGetAppListResponseApplicationJson._();
  // coverage:ignore-end

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  // coverage:ignore-start
  factory ApiGetAppListResponseApplicationJson.fromJson(Map<String, dynamic> json) =>
      _$jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end

  /// Serializer for ApiGetAppListResponseApplicationJson.
  static Serializer<ApiGetAppListResponseApplicationJson> get serializer =>
      _$apiGetAppListResponseApplicationJsonSerializer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiGetAppListResponseApplicationJsonBuilder b) {
    $ApiGetAppListResponseApplicationJsonInterface._defaults(b);
  }

  @BuiltValueHook(finalizeBuilder: true)
  static void _validate(ApiGetAppListResponseApplicationJsonBuilder b) {
    $ApiGetAppListResponseApplicationJsonInterface._validate(b);
  }
}

class ApiGetAppChangelogEntryApiVersion extends EnumClass {
  const ApiGetAppChangelogEntryApiVersion._(super.name);

  /// `v1`
  static const ApiGetAppChangelogEntryApiVersion v1 = _$apiGetAppChangelogEntryApiVersionV1;

  /// Returns a set with all values this enum contains.
  // coverage:ignore-start
  static BuiltSet<ApiGetAppChangelogEntryApiVersion> get values => _$apiGetAppChangelogEntryApiVersionValues;
  // coverage:ignore-end

  /// Returns the enum value associated to the [name].
  static ApiGetAppChangelogEntryApiVersion valueOf(String name) => _$valueOfApiGetAppChangelogEntryApiVersion(name);

  /// Returns the serialized value of this enum value.
  String get value => _$jsonSerializers.serializeWith(serializer, this)! as String;

  /// Serializer for ApiGetAppChangelogEntryApiVersion.
  @BuiltValueSerializer(custom: true)
  static Serializer<ApiGetAppChangelogEntryApiVersion> get serializer =>
      const _$ApiGetAppChangelogEntryApiVersionSerializer();
}

class _$ApiGetAppChangelogEntryApiVersionSerializer implements PrimitiveSerializer<ApiGetAppChangelogEntryApiVersion> {
  const _$ApiGetAppChangelogEntryApiVersionSerializer();

  static const Map<ApiGetAppChangelogEntryApiVersion, Object> _toWire = <ApiGetAppChangelogEntryApiVersion, Object>{
    ApiGetAppChangelogEntryApiVersion.v1: 'v1',
  };

  static const Map<Object, ApiGetAppChangelogEntryApiVersion> _fromWire = <Object, ApiGetAppChangelogEntryApiVersion>{
    'v1': ApiGetAppChangelogEntryApiVersion.v1,
  };

  @override
  Iterable<Type> get types => const [ApiGetAppChangelogEntryApiVersion];

  @override
  String get wireName => 'ApiGetAppChangelogEntryApiVersion';

  @override
  Object serialize(
    Serializers serializers,
    ApiGetAppChangelogEntryApiVersion object, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      _toWire[object]!;

  @override
  ApiGetAppChangelogEntryApiVersion deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      _fromWire[serialized]!;
}

@BuiltValue(instantiable: false)
sealed class $ApiGetAppChangelogEntryResponseApplicationJson_Ocs_DataInterface {
  String get appName;
  String get content;
  String get version;

  /// Rebuilds the instance.
  ///
  /// The result is the same as this instance but with [updates] applied.
  /// [updates] is a function that takes a builder [$ApiGetAppChangelogEntryResponseApplicationJson_Ocs_DataInterfaceBuilder].
  $ApiGetAppChangelogEntryResponseApplicationJson_Ocs_DataInterface rebuild(
    void Function($ApiGetAppChangelogEntryResponseApplicationJson_Ocs_DataInterfaceBuilder) updates,
  );

  /// Converts the instance to a builder [$ApiGetAppChangelogEntryResponseApplicationJson_Ocs_DataInterfaceBuilder].
  $ApiGetAppChangelogEntryResponseApplicationJson_Ocs_DataInterfaceBuilder toBuilder();
  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($ApiGetAppChangelogEntryResponseApplicationJson_Ocs_DataInterfaceBuilder b) {}
  @BuiltValueHook(finalizeBuilder: true)
  static void _validate($ApiGetAppChangelogEntryResponseApplicationJson_Ocs_DataInterfaceBuilder b) {}
}

abstract class ApiGetAppChangelogEntryResponseApplicationJson_Ocs_Data
    implements
        $ApiGetAppChangelogEntryResponseApplicationJson_Ocs_DataInterface,
        Built<ApiGetAppChangelogEntryResponseApplicationJson_Ocs_Data,
            ApiGetAppChangelogEntryResponseApplicationJson_Ocs_DataBuilder> {
  /// Creates a new ApiGetAppChangelogEntryResponseApplicationJson_Ocs_Data object using the builder pattern.
  factory ApiGetAppChangelogEntryResponseApplicationJson_Ocs_Data([
    void Function(ApiGetAppChangelogEntryResponseApplicationJson_Ocs_DataBuilder)? b,
  ]) = _$ApiGetAppChangelogEntryResponseApplicationJson_Ocs_Data;

  // coverage:ignore-start
  const ApiGetAppChangelogEntryResponseApplicationJson_Ocs_Data._();
  // coverage:ignore-end

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  // coverage:ignore-start
  factory ApiGetAppChangelogEntryResponseApplicationJson_Ocs_Data.fromJson(Map<String, dynamic> json) =>
      _$jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end

  /// Serializer for ApiGetAppChangelogEntryResponseApplicationJson_Ocs_Data.
  static Serializer<ApiGetAppChangelogEntryResponseApplicationJson_Ocs_Data> get serializer =>
      _$apiGetAppChangelogEntryResponseApplicationJsonOcsDataSerializer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiGetAppChangelogEntryResponseApplicationJson_Ocs_DataBuilder b) {
    $ApiGetAppChangelogEntryResponseApplicationJson_Ocs_DataInterface._defaults(b);
  }

  @BuiltValueHook(finalizeBuilder: true)
  static void _validate(ApiGetAppChangelogEntryResponseApplicationJson_Ocs_DataBuilder b) {
    $ApiGetAppChangelogEntryResponseApplicationJson_Ocs_DataInterface._validate(b);
  }
}

@BuiltValue(instantiable: false)
sealed class $ApiGetAppChangelogEntryResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  ApiGetAppChangelogEntryResponseApplicationJson_Ocs_Data get data;

  /// Rebuilds the instance.
  ///
  /// The result is the same as this instance but with [updates] applied.
  /// [updates] is a function that takes a builder [$ApiGetAppChangelogEntryResponseApplicationJson_OcsInterfaceBuilder].
  $ApiGetAppChangelogEntryResponseApplicationJson_OcsInterface rebuild(
    void Function($ApiGetAppChangelogEntryResponseApplicationJson_OcsInterfaceBuilder) updates,
  );

  /// Converts the instance to a builder [$ApiGetAppChangelogEntryResponseApplicationJson_OcsInterfaceBuilder].
  $ApiGetAppChangelogEntryResponseApplicationJson_OcsInterfaceBuilder toBuilder();
  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($ApiGetAppChangelogEntryResponseApplicationJson_OcsInterfaceBuilder b) {}
  @BuiltValueHook(finalizeBuilder: true)
  static void _validate($ApiGetAppChangelogEntryResponseApplicationJson_OcsInterfaceBuilder b) {}
}

abstract class ApiGetAppChangelogEntryResponseApplicationJson_Ocs
    implements
        $ApiGetAppChangelogEntryResponseApplicationJson_OcsInterface,
        Built<ApiGetAppChangelogEntryResponseApplicationJson_Ocs,
            ApiGetAppChangelogEntryResponseApplicationJson_OcsBuilder> {
  /// Creates a new ApiGetAppChangelogEntryResponseApplicationJson_Ocs object using the builder pattern.
  factory ApiGetAppChangelogEntryResponseApplicationJson_Ocs([
    void Function(ApiGetAppChangelogEntryResponseApplicationJson_OcsBuilder)? b,
  ]) = _$ApiGetAppChangelogEntryResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const ApiGetAppChangelogEntryResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  // coverage:ignore-start
  factory ApiGetAppChangelogEntryResponseApplicationJson_Ocs.fromJson(Map<String, dynamic> json) =>
      _$jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end

  /// Serializer for ApiGetAppChangelogEntryResponseApplicationJson_Ocs.
  static Serializer<ApiGetAppChangelogEntryResponseApplicationJson_Ocs> get serializer =>
      _$apiGetAppChangelogEntryResponseApplicationJsonOcsSerializer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiGetAppChangelogEntryResponseApplicationJson_OcsBuilder b) {
    $ApiGetAppChangelogEntryResponseApplicationJson_OcsInterface._defaults(b);
  }

  @BuiltValueHook(finalizeBuilder: true)
  static void _validate(ApiGetAppChangelogEntryResponseApplicationJson_OcsBuilder b) {
    $ApiGetAppChangelogEntryResponseApplicationJson_OcsInterface._validate(b);
  }
}

@BuiltValue(instantiable: false)
sealed class $ApiGetAppChangelogEntryResponseApplicationJsonInterface {
  ApiGetAppChangelogEntryResponseApplicationJson_Ocs get ocs;

  /// Rebuilds the instance.
  ///
  /// The result is the same as this instance but with [updates] applied.
  /// [updates] is a function that takes a builder [$ApiGetAppChangelogEntryResponseApplicationJsonInterfaceBuilder].
  $ApiGetAppChangelogEntryResponseApplicationJsonInterface rebuild(
    void Function($ApiGetAppChangelogEntryResponseApplicationJsonInterfaceBuilder) updates,
  );

  /// Converts the instance to a builder [$ApiGetAppChangelogEntryResponseApplicationJsonInterfaceBuilder].
  $ApiGetAppChangelogEntryResponseApplicationJsonInterfaceBuilder toBuilder();
  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($ApiGetAppChangelogEntryResponseApplicationJsonInterfaceBuilder b) {}
  @BuiltValueHook(finalizeBuilder: true)
  static void _validate($ApiGetAppChangelogEntryResponseApplicationJsonInterfaceBuilder b) {}
}

abstract class ApiGetAppChangelogEntryResponseApplicationJson
    implements
        $ApiGetAppChangelogEntryResponseApplicationJsonInterface,
        Built<ApiGetAppChangelogEntryResponseApplicationJson, ApiGetAppChangelogEntryResponseApplicationJsonBuilder> {
  /// Creates a new ApiGetAppChangelogEntryResponseApplicationJson object using the builder pattern.
  factory ApiGetAppChangelogEntryResponseApplicationJson([
    void Function(ApiGetAppChangelogEntryResponseApplicationJsonBuilder)? b,
  ]) = _$ApiGetAppChangelogEntryResponseApplicationJson;

  // coverage:ignore-start
  const ApiGetAppChangelogEntryResponseApplicationJson._();
  // coverage:ignore-end

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  // coverage:ignore-start
  factory ApiGetAppChangelogEntryResponseApplicationJson.fromJson(Map<String, dynamic> json) =>
      _$jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end

  /// Serializer for ApiGetAppChangelogEntryResponseApplicationJson.
  static Serializer<ApiGetAppChangelogEntryResponseApplicationJson> get serializer =>
      _$apiGetAppChangelogEntryResponseApplicationJsonSerializer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiGetAppChangelogEntryResponseApplicationJsonBuilder b) {
    $ApiGetAppChangelogEntryResponseApplicationJsonInterface._defaults(b);
  }

  @BuiltValueHook(finalizeBuilder: true)
  static void _validate(ApiGetAppChangelogEntryResponseApplicationJsonBuilder b) {
    $ApiGetAppChangelogEntryResponseApplicationJsonInterface._validate(b);
  }
}

// coverage:ignore-start
/// Serializer for all values in this library.
///
/// Serializes values into the `built_value` wire format.
/// See: [$jsonSerializers] for serializing into json.
@_i2.visibleForTesting
final Serializers $serializers = _$serializers;
final Serializers _$serializers = (Serializers().toBuilder()
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
      ..addBuilderFactory(const FullType(BuiltList, [FullType(App)]), ListBuilder<App>.new)
      ..add(ApiGetAppChangelogEntryApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(ApiGetAppChangelogEntryResponseApplicationJson),
        ApiGetAppChangelogEntryResponseApplicationJsonBuilder.new,
      )
      ..add(ApiGetAppChangelogEntryResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(ApiGetAppChangelogEntryResponseApplicationJson_Ocs),
        ApiGetAppChangelogEntryResponseApplicationJson_OcsBuilder.new,
      )
      ..add(ApiGetAppChangelogEntryResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(
        const FullType(ApiGetAppChangelogEntryResponseApplicationJson_Ocs_Data),
        ApiGetAppChangelogEntryResponseApplicationJson_Ocs_DataBuilder.new,
      )
      ..add(ApiGetAppChangelogEntryResponseApplicationJson_Ocs_Data.serializer))
    .build();

/// Serializer for all values in this library.
///
/// Serializes values into the json. Json serialization is more expensive than the built_value wire format.
/// See: [$serializers] for serializing into the `built_value` wire format.
@_i2.visibleForTesting
final Serializers $jsonSerializers = _$jsonSerializers;
final Serializers _$jsonSerializers = (_$serializers.toBuilder()
      ..add(_i7.DynamiteDoubleSerializer())
      ..addPlugin(_i8.StandardJsonPlugin())
      ..addPlugin(const _i7.HeaderPlugin())
      ..addPlugin(const _i7.ContentStringPlugin()))
    .build();
// coverage:ignore-end
