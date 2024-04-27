// Use of this source code is governed by a agpl license. It can be obtained at `https://spdx.org/licenses/AGPL-3.0-only.html`.

// OpenAPI client generated by Dynamite. Do not manually edit this file.

// ignore_for_file: camel_case_extensions, camel_case_types, cascade_invocations
// ignore_for_file: discarded_futures
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: non_constant_identifier_names, public_member_api_docs
// ignore_for_file: unreachable_switch_case

/// files_external Version: 0.0.1.
///
/// Adds basic external storage support.
///
/// Use of this source code is governed by a agpl license.
/// It can be obtained at `https://spdx.org/licenses/AGPL-3.0-only.html`.
library; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart' as _i6;
import 'package:collection/collection.dart';
import 'package:dynamite_runtime/built_value.dart' as _i5;
import 'package:dynamite_runtime/http_client.dart' as _i1;
import 'package:dynamite_runtime/utils.dart' as _i4;
import 'package:http/http.dart' as _i3;
import 'package:meta/meta.dart' as _i2;

part 'files_external.openapi.g.dart';

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

  /// Builds a serializer to parse the response of [$getUserMounts_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<ApiGetUserMountsResponseApplicationJson, void> $getUserMounts_Serializer() =>
      _i1.DynamiteSerializer(
        bodyType: const FullType(ApiGetUserMountsResponseApplicationJson),
        headersType: null,
        serializers: _$jsonSerializers,
        validStatuses: const {200},
      );

  /// Get the mount points visible for this user.
  ///
  /// Returns a `DynamiteRequest` backing the [getUserMounts] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: User mounts returned
  ///
  /// See:
  ///  * [getUserMounts] for a method executing this request and parsing the response.
  ///  * [$getUserMounts_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i3.Request $getUserMounts_Request({bool? oCSAPIRequest}) {
    const _path = '/ocs/v2.php/apps/files_external/api/v1/mounts';
    final _uri = Uri.parse('${_rootClient.baseURL}$_path');
    final _request = _i3.Request('get', _uri);
    _request.headers['Accept'] = 'application/json';
// coverage:ignore-start
    final authentication = _rootClient.authentications?.firstWhereOrNull(
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
    var $oCSAPIRequest = _$jsonSerializers.serialize(oCSAPIRequest, specifiedType: const FullType(bool));
    $oCSAPIRequest ??= true;
    _request.headers['OCS-APIRequest'] = const _i4.HeaderEncoder().convert($oCSAPIRequest);

    return _request;
  }

  /// Get the mount points visible for this user.
  ///
  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: User mounts returned
  ///
  /// See:
  ///  * [$getUserMounts_Request] for the request send by this method.
  ///  * [$getUserMounts_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<ApiGetUserMountsResponseApplicationJson, void>> getUserMounts({
    bool? oCSAPIRequest,
  }) async {
    final _request = $getUserMounts_Request(
      oCSAPIRequest: oCSAPIRequest,
    );
    final _response = await _rootClient.httpClient.send(_request);

    final _serializer = $getUserMounts_Serializer();
    final _rawResponse =
        await _i1.ResponseConverter<ApiGetUserMountsResponseApplicationJson, void>(_serializer).convert(_response);
    return _i1.DynamiteResponse.fromRawResponse(_rawResponse);
  }
}

@BuiltValue(instantiable: false)
abstract interface class $OCSMetaInterface {
  String get status;
  int get statuscode;
  String? get message;
  String? get totalitems;
  String? get itemsperpage;
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

class Mount_Type extends EnumClass {
  const Mount_Type._(super.name);

  /// `dir`
  static const Mount_Type dir = _$mountTypeDir;

  /// Returns a set with all values this enum contains.
  // coverage:ignore-start
  static BuiltSet<Mount_Type> get values => _$mountTypeValues;
  // coverage:ignore-end

  /// Returns the enum value associated to the [name].
  static Mount_Type valueOf(String name) => _$valueOfMount_Type(name);

  /// Returns the serialized value of this enum value.
  String get value => _$jsonSerializers.serializeWith(serializer, this)! as String;

  /// Serializer for Mount_Type.
  @BuiltValueSerializer(custom: true)
  static Serializer<Mount_Type> get serializer => const _$Mount_TypeSerializer();
}

class _$Mount_TypeSerializer implements PrimitiveSerializer<Mount_Type> {
  const _$Mount_TypeSerializer();

  static const Map<Mount_Type, Object> _toWire = <Mount_Type, Object>{
    Mount_Type.dir: 'dir',
  };

  static const Map<Object, Mount_Type> _fromWire = <Object, Mount_Type>{
    'dir': Mount_Type.dir,
  };

  @override
  Iterable<Type> get types => const [Mount_Type];

  @override
  String get wireName => 'Mount_Type';

  @override
  Object serialize(
    Serializers serializers,
    Mount_Type object, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      _toWire[object]!;

  @override
  Mount_Type deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      _fromWire[serialized]!;
}

class Mount_Scope extends EnumClass {
  const Mount_Scope._(super.name);

  /// `system`
  static const Mount_Scope system = _$mountScopeSystem;

  /// `personal`
  static const Mount_Scope personal = _$mountScopePersonal;

  /// Returns a set with all values this enum contains.
  // coverage:ignore-start
  static BuiltSet<Mount_Scope> get values => _$mountScopeValues;
  // coverage:ignore-end

  /// Returns the enum value associated to the [name].
  static Mount_Scope valueOf(String name) => _$valueOfMount_Scope(name);

  /// Returns the serialized value of this enum value.
  String get value => _$jsonSerializers.serializeWith(serializer, this)! as String;

  /// Serializer for Mount_Scope.
  @BuiltValueSerializer(custom: true)
  static Serializer<Mount_Scope> get serializer => const _$Mount_ScopeSerializer();
}

class _$Mount_ScopeSerializer implements PrimitiveSerializer<Mount_Scope> {
  const _$Mount_ScopeSerializer();

  static const Map<Mount_Scope, Object> _toWire = <Mount_Scope, Object>{
    Mount_Scope.system: 'system',
    Mount_Scope.personal: 'personal',
  };

  static const Map<Object, Mount_Scope> _fromWire = <Object, Mount_Scope>{
    'system': Mount_Scope.system,
    'personal': Mount_Scope.personal,
  };

  @override
  Iterable<Type> get types => const [Mount_Scope];

  @override
  String get wireName => 'Mount_Scope';

  @override
  Object serialize(
    Serializers serializers,
    Mount_Scope object, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      _toWire[object]!;

  @override
  Mount_Scope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      _fromWire[serialized]!;
}

class StorageConfig_Type extends EnumClass {
  const StorageConfig_Type._(super.name);

  /// `personal`
  static const StorageConfig_Type personal = _$storageConfigTypePersonal;

  /// `system`
  static const StorageConfig_Type system = _$storageConfigTypeSystem;

  /// Returns a set with all values this enum contains.
  // coverage:ignore-start
  static BuiltSet<StorageConfig_Type> get values => _$storageConfigTypeValues;
  // coverage:ignore-end

  /// Returns the enum value associated to the [name].
  static StorageConfig_Type valueOf(String name) => _$valueOfStorageConfig_Type(name);

  /// Returns the serialized value of this enum value.
  String get value => _$jsonSerializers.serializeWith(serializer, this)! as String;

  /// Serializer for StorageConfig_Type.
  @BuiltValueSerializer(custom: true)
  static Serializer<StorageConfig_Type> get serializer => const _$StorageConfig_TypeSerializer();
}

class _$StorageConfig_TypeSerializer implements PrimitiveSerializer<StorageConfig_Type> {
  const _$StorageConfig_TypeSerializer();

  static const Map<StorageConfig_Type, Object> _toWire = <StorageConfig_Type, Object>{
    StorageConfig_Type.personal: 'personal',
    StorageConfig_Type.system: 'system',
  };

  static const Map<Object, StorageConfig_Type> _fromWire = <Object, StorageConfig_Type>{
    'personal': StorageConfig_Type.personal,
    'system': StorageConfig_Type.system,
  };

  @override
  Iterable<Type> get types => const [StorageConfig_Type];

  @override
  String get wireName => 'StorageConfig_Type';

  @override
  Object serialize(
    Serializers serializers,
    StorageConfig_Type object, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      _toWire[object]!;

  @override
  StorageConfig_Type deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      _fromWire[serialized]!;
}

@BuiltValue(instantiable: false)
abstract interface class $StorageConfigInterface {
  BuiltList<String>? get applicableGroups;
  BuiltList<String>? get applicableUsers;
  String get authMechanism;
  String get backend;
  BuiltMap<String, JsonObject> get backendOptions;
  int? get id;
  BuiltMap<String, JsonObject>? get mountOptions;
  String get mountPoint;
  int? get priority;
  int? get status;
  String? get statusMessage;
  StorageConfig_Type get type;
  bool get userProvided;
  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($StorageConfigInterfaceBuilder b) {}
  @BuiltValueHook(finalizeBuilder: true)
  static void _validate($StorageConfigInterfaceBuilder b) {}
}

abstract class StorageConfig implements $StorageConfigInterface, Built<StorageConfig, StorageConfigBuilder> {
  /// Creates a new StorageConfig object using the builder pattern.
  factory StorageConfig([void Function(StorageConfigBuilder)? b]) = _$StorageConfig;

  // coverage:ignore-start
  const StorageConfig._();
  // coverage:ignore-end

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  // coverage:ignore-start
  factory StorageConfig.fromJson(Map<String, dynamic> json) => _$jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end

  /// Serializer for StorageConfig.
  static Serializer<StorageConfig> get serializer => _$storageConfigSerializer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StorageConfigBuilder b) {
    $StorageConfigInterface._defaults(b);
  }

  @BuiltValueHook(finalizeBuilder: true)
  static void _validate(StorageConfigBuilder b) {
    $StorageConfigInterface._validate(b);
  }
}

@BuiltValue(instantiable: false)
abstract interface class $MountInterface {
  String get name;
  String get path;
  Mount_Type get type;
  String get backend;
  Mount_Scope get scope;
  int get permissions;
  int get id;
  @BuiltValueField(wireName: 'class')
  String get $class;
  StorageConfig get config;
  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($MountInterfaceBuilder b) {}
  @BuiltValueHook(finalizeBuilder: true)
  static void _validate($MountInterfaceBuilder b) {}
}

abstract class Mount implements $MountInterface, Built<Mount, MountBuilder> {
  /// Creates a new Mount object using the builder pattern.
  factory Mount([void Function(MountBuilder)? b]) = _$Mount;

  // coverage:ignore-start
  const Mount._();
  // coverage:ignore-end

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  // coverage:ignore-start
  factory Mount.fromJson(Map<String, dynamic> json) => _$jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end

  /// Serializer for Mount.
  static Serializer<Mount> get serializer => _$mountSerializer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MountBuilder b) {
    $MountInterface._defaults(b);
  }

  @BuiltValueHook(finalizeBuilder: true)
  static void _validate(MountBuilder b) {
    $MountInterface._validate(b);
  }
}

@BuiltValue(instantiable: false)
abstract interface class $ApiGetUserMountsResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  BuiltList<Mount> get data;
  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($ApiGetUserMountsResponseApplicationJson_OcsInterfaceBuilder b) {}
  @BuiltValueHook(finalizeBuilder: true)
  static void _validate($ApiGetUserMountsResponseApplicationJson_OcsInterfaceBuilder b) {}
}

abstract class ApiGetUserMountsResponseApplicationJson_Ocs
    implements
        $ApiGetUserMountsResponseApplicationJson_OcsInterface,
        Built<ApiGetUserMountsResponseApplicationJson_Ocs, ApiGetUserMountsResponseApplicationJson_OcsBuilder> {
  /// Creates a new ApiGetUserMountsResponseApplicationJson_Ocs object using the builder pattern.
  factory ApiGetUserMountsResponseApplicationJson_Ocs([
    void Function(ApiGetUserMountsResponseApplicationJson_OcsBuilder)? b,
  ]) = _$ApiGetUserMountsResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const ApiGetUserMountsResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  // coverage:ignore-start
  factory ApiGetUserMountsResponseApplicationJson_Ocs.fromJson(Map<String, dynamic> json) =>
      _$jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end

  /// Serializer for ApiGetUserMountsResponseApplicationJson_Ocs.
  static Serializer<ApiGetUserMountsResponseApplicationJson_Ocs> get serializer =>
      _$apiGetUserMountsResponseApplicationJsonOcsSerializer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiGetUserMountsResponseApplicationJson_OcsBuilder b) {
    $ApiGetUserMountsResponseApplicationJson_OcsInterface._defaults(b);
  }

  @BuiltValueHook(finalizeBuilder: true)
  static void _validate(ApiGetUserMountsResponseApplicationJson_OcsBuilder b) {
    $ApiGetUserMountsResponseApplicationJson_OcsInterface._validate(b);
  }
}

@BuiltValue(instantiable: false)
abstract interface class $ApiGetUserMountsResponseApplicationJsonInterface {
  ApiGetUserMountsResponseApplicationJson_Ocs get ocs;
  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($ApiGetUserMountsResponseApplicationJsonInterfaceBuilder b) {}
  @BuiltValueHook(finalizeBuilder: true)
  static void _validate($ApiGetUserMountsResponseApplicationJsonInterfaceBuilder b) {}
}

abstract class ApiGetUserMountsResponseApplicationJson
    implements
        $ApiGetUserMountsResponseApplicationJsonInterface,
        Built<ApiGetUserMountsResponseApplicationJson, ApiGetUserMountsResponseApplicationJsonBuilder> {
  /// Creates a new ApiGetUserMountsResponseApplicationJson object using the builder pattern.
  factory ApiGetUserMountsResponseApplicationJson([void Function(ApiGetUserMountsResponseApplicationJsonBuilder)? b]) =
      _$ApiGetUserMountsResponseApplicationJson;

  // coverage:ignore-start
  const ApiGetUserMountsResponseApplicationJson._();
  // coverage:ignore-end

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  // coverage:ignore-start
  factory ApiGetUserMountsResponseApplicationJson.fromJson(Map<String, dynamic> json) =>
      _$jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end

  /// Serializer for ApiGetUserMountsResponseApplicationJson.
  static Serializer<ApiGetUserMountsResponseApplicationJson> get serializer =>
      _$apiGetUserMountsResponseApplicationJsonSerializer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiGetUserMountsResponseApplicationJsonBuilder b) {
    $ApiGetUserMountsResponseApplicationJsonInterface._defaults(b);
  }

  @BuiltValueHook(finalizeBuilder: true)
  static void _validate(ApiGetUserMountsResponseApplicationJsonBuilder b) {
    $ApiGetUserMountsResponseApplicationJsonInterface._validate(b);
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
      ..addBuilderFactory(
        const FullType(ApiGetUserMountsResponseApplicationJson),
        ApiGetUserMountsResponseApplicationJsonBuilder.new,
      )
      ..add(ApiGetUserMountsResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(ApiGetUserMountsResponseApplicationJson_Ocs),
        ApiGetUserMountsResponseApplicationJson_OcsBuilder.new,
      )
      ..add(ApiGetUserMountsResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(const FullType(OCSMeta), OCSMetaBuilder.new)
      ..add(OCSMeta.serializer)
      ..addBuilderFactory(const FullType(Mount), MountBuilder.new)
      ..add(Mount.serializer)
      ..add(Mount_Type.serializer)
      ..add(Mount_Scope.serializer)
      ..addBuilderFactory(const FullType(StorageConfig), StorageConfigBuilder.new)
      ..add(StorageConfig.serializer)
      ..addBuilderFactory(const FullType(BuiltList, [FullType(String)]), ListBuilder<String>.new)
      ..addBuilderFactory(
        const FullType(BuiltMap, [FullType(String), FullType(JsonObject)]),
        MapBuilder<String, JsonObject>.new,
      )
      ..add(StorageConfig_Type.serializer)
      ..addBuilderFactory(const FullType(BuiltList, [FullType(Mount)]), ListBuilder<Mount>.new))
    .build();

/// Serializer for all values in this library.
///
/// Serializes values into the json. Json serialization is more expensive than the built_value wire format.
/// See: [$serializers] for serializing into the `built_value` wire format.
@_i2.visibleForTesting
final Serializers $jsonSerializers = _$jsonSerializers;
final Serializers _$jsonSerializers = (_$serializers.toBuilder()
      ..add(_i5.DynamiteDoubleSerializer())
      ..addPlugin(_i6.StandardJsonPlugin())
      ..addPlugin(const _i5.HeaderPlugin())
      ..addPlugin(const _i5.ContentStringPlugin()))
    .build();
// coverage:ignore-end
