// OpenAPI client generated by Dynamite. Do not manually edit this file.

// ignore_for_file: camel_case_extensions, camel_case_types, discarded_futures
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: non_constant_identifier_names, public_member_api_docs
// ignore_for_file: unreachable_switch_case, unused_element

/// parameters test Version: 0.0.1.
library; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:typed_data';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart' as _i6;
import 'package:dynamite_runtime/built_value.dart' as _i5;
import 'package:dynamite_runtime/http_client.dart' as _i1;
import 'package:dynamite_runtime/models.dart';
import 'package:dynamite_runtime/utils.dart' as _i3;
import 'package:meta/meta.dart' as _i2;
import 'package:uri/uri.dart' as _i4;

part 'parameters.openapi.g.dart';

class $Client extends _i1.DynamiteClient {
  /// Creates a new `DynamiteClient` for untagged requests.
  $Client(
    super.baseURL, {
    super.baseHeaders,
    super.httpClient,
    super.cookieJar,
  });

  /// Creates a new [$Client] from another [client].
  $Client.fromClient(_i1.DynamiteClient client)
      : super(
          client.baseURL,
          baseHeaders: client.baseHeaders,
          httpClient: client.httpClient,
          cookieJar: client.cookieJar,
          authentications: client.authentications,
        );

  /// Builds a serializer to parse the response of [$$get_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<JsonObject, void> $$get_Serializer() => _i1.DynamiteSerializer<JsonObject, void>(
        bodyType: const FullType(JsonObject),
        headersType: null,
        serializers: _$jsonSerializers,
      );

  /// Returns a `DynamiteRequest` backing the [$get] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [contentString]
  ///   * [contentParameter]
  ///   * [array]
  ///   * [arrayString]
  ///   * [$bool]
  ///   * [string]
  ///   * [stringBinary]
  ///   * [$int]
  ///   * [$double]
  ///   * [$num]
  ///   * [object]
  ///   * [oneOf]
  ///   * [anyOf]
  ///   * [enumPattern]
  ///
  /// Status codes:
  ///   * 200
  ///
  /// See:
  ///  * [$get] for a method executing this request and parsing the response.
  ///  * [$$get_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i1.DynamiteRequest $$get_Request({
    ContentString<BuiltMap<String, JsonObject>>? contentString,
    ContentString<BuiltMap<String, JsonObject>>? contentParameter,
    BuiltList<JsonObject>? array,
    BuiltList<String>? arrayString,
    bool? $bool,
    String? string,
    Uint8List? stringBinary,
    int? $int,
    double? $double,
    num? $num,
    JsonObject? object,
    GetOneOf? oneOf,
    GetAnyOf? anyOf,
    GetEnumPattern? enumPattern,
  }) {
    final _parameters = <String, Object?>{};
    final $contentString = _$jsonSerializers.serialize(
      contentString,
      specifiedType: const FullType(ContentString, [
        FullType(BuiltMap, [FullType(String), FullType(JsonObject)]),
      ]),
    );
    _parameters['content_string'] = $contentString;

    final $contentParameter = _$jsonSerializers.serialize(
      contentParameter,
      specifiedType: const FullType(ContentString, [
        FullType(BuiltMap, [FullType(String), FullType(JsonObject)]),
      ]),
    );
    _parameters['content_parameter'] = $contentParameter;

    final $array = _$jsonSerializers.serialize(array, specifiedType: const FullType(BuiltList, [FullType(JsonObject)]));
    _parameters['array'] = $array;

    final $arrayString =
        _$jsonSerializers.serialize(arrayString, specifiedType: const FullType(BuiltList, [FullType(String)]));
    _parameters['array_string'] = $arrayString;

    final $$bool = _$jsonSerializers.serialize($bool, specifiedType: const FullType(bool));
    _parameters['bool'] = $$bool;

    final $string = _$jsonSerializers.serialize(string, specifiedType: const FullType(String));
    _parameters['string'] = $string;

    final $stringBinary = _$jsonSerializers.serialize(stringBinary, specifiedType: const FullType(Uint8List));
    _parameters['string_binary'] = $stringBinary;

    final $$int = _$jsonSerializers.serialize($int, specifiedType: const FullType(int));
    _parameters['int'] = $$int;

    final $$double = _$jsonSerializers.serialize($double, specifiedType: const FullType(double));
    _parameters['double'] = $$double;

    final $$num = _$jsonSerializers.serialize($num, specifiedType: const FullType(num));
    _parameters['num'] = $$num;

    final $object = _$jsonSerializers.serialize(object, specifiedType: const FullType(JsonObject));
    _parameters['object'] = $object;

    final $oneOf = _$jsonSerializers.serialize(oneOf, specifiedType: const FullType(GetOneOf));
    _parameters['oneOf'] = $oneOf;

    final $anyOf = _$jsonSerializers.serialize(anyOf, specifiedType: const FullType(GetAnyOf));
    _parameters['anyOf'] = $anyOf;

    final $enumPattern = _$jsonSerializers.serialize(enumPattern, specifiedType: const FullType(GetEnumPattern));
    _i3.checkPattern(
      $enumPattern as String?,
      RegExp('[a-z]'),
      'enumPattern',
    );
    _parameters['enum_pattern'] = $enumPattern;

    final _path = _i4.UriTemplate(
      '/{?content_string*,content_parameter*,array*,array_string*,bool*,string*,string_binary*,int*,double*,num*,object*,oneOf*,anyOf*,enum_pattern*}',
    ).expand(_parameters);
    final _uri = Uri.parse('$baseURL$_path');
    final _request = _i1.DynamiteRequest('get', _uri)..validStatuses = const {200};
    _request.headers['Accept'] = 'application/json';
    return _request;
  }

  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [contentString]
  ///   * [contentParameter]
  ///   * [array]
  ///   * [arrayString]
  ///   * [$bool]
  ///   * [string]
  ///   * [stringBinary]
  ///   * [$int]
  ///   * [$double]
  ///   * [$num]
  ///   * [object]
  ///   * [oneOf]
  ///   * [anyOf]
  ///   * [enumPattern]
  ///
  /// Status codes:
  ///   * 200
  ///
  /// See:
  ///  * [$$get_Request] for the request send by this method.
  ///  * [$$get_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<JsonObject, void>> $get({
    ContentString<BuiltMap<String, JsonObject>>? contentString,
    ContentString<BuiltMap<String, JsonObject>>? contentParameter,
    BuiltList<JsonObject>? array,
    BuiltList<String>? arrayString,
    bool? $bool,
    String? string,
    Uint8List? stringBinary,
    int? $int,
    double? $double,
    num? $num,
    JsonObject? object,
    GetOneOf? oneOf,
    GetAnyOf? anyOf,
    GetEnumPattern? enumPattern,
  }) async {
    final _request = $$get_Request(
      contentString: contentString,
      contentParameter: contentParameter,
      array: array,
      arrayString: arrayString,
      $bool: $bool,
      string: string,
      stringBinary: stringBinary,
      $int: $int,
      $double: $double,
      $num: $num,
      object: object,
      oneOf: oneOf,
      anyOf: anyOf,
      enumPattern: enumPattern,
    );
    final _response = await send(_request);

    final serializer = $$get_Serializer();
    final _rawResponse = await _i1.ResponseConverter<JsonObject, void>(serializer).convert(_response);
    return _i1.DynamiteResponse.fromRawResponse(_rawResponse);
  }

  /// Builds a serializer to parse the response of [$getHeaders_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<JsonObject, void> $getHeaders_Serializer() => _i1.DynamiteSerializer<JsonObject, void>(
        bodyType: const FullType(JsonObject),
        headersType: null,
        serializers: _$jsonSerializers,
      );

  /// Returns a `DynamiteRequest` backing the [getHeaders] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [contentString]
  ///   * [contentParameter]
  ///   * [array]
  ///   * [arrayString]
  ///   * [$bool]
  ///   * [string]
  ///   * [stringBinary]
  ///   * [$int]
  ///   * [$double]
  ///   * [$num]
  ///   * [object]
  ///   * [oneOf]
  ///   * [anyOf]
  ///   * [enumPattern]
  ///
  /// Status codes:
  ///   * 200
  ///
  /// See:
  ///  * [getHeaders] for a method executing this request and parsing the response.
  ///  * [$getHeaders_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i1.DynamiteRequest $getHeaders_Request({
    ContentString<BuiltMap<String, JsonObject>>? contentString,
    ContentString<BuiltMap<String, JsonObject>>? contentParameter,
    BuiltList<JsonObject>? array,
    BuiltList<String>? arrayString,
    bool? $bool,
    String? string,
    Uint8List? stringBinary,
    int? $int,
    double? $double,
    num? $num,
    JsonObject? object,
    GetHeadersOneOf? oneOf,
    GetHeadersAnyOf? anyOf,
    GetHeadersEnumPattern? enumPattern,
  }) {
    const _path = '/headers';
    final _uri = Uri.parse('$baseURL$_path');
    final _request = _i1.DynamiteRequest('get', _uri)..validStatuses = const {200};
    _request.headers['Accept'] = 'application/json';
    final $contentString = _$jsonSerializers.serialize(
      contentString,
      specifiedType: const FullType(ContentString, [
        FullType(BuiltMap, [FullType(String), FullType(JsonObject)]),
      ]),
    );
    if ($contentString != null) {
      _request.headers['content_string'] = const _i3.HeaderEncoder().convert($contentString);
    }

    final $contentParameter = _$jsonSerializers.serialize(
      contentParameter,
      specifiedType: const FullType(ContentString, [
        FullType(BuiltMap, [FullType(String), FullType(JsonObject)]),
      ]),
    );
    if ($contentParameter != null) {
      _request.headers['content_parameter'] = const _i3.HeaderEncoder().convert($contentParameter);
    }

    final $array = _$jsonSerializers.serialize(array, specifiedType: const FullType(BuiltList, [FullType(JsonObject)]));
    if ($array != null) {
      _request.headers['array'] = const _i3.HeaderEncoder().convert($array);
    }

    final $arrayString =
        _$jsonSerializers.serialize(arrayString, specifiedType: const FullType(BuiltList, [FullType(String)]));
    if ($arrayString != null) {
      _request.headers['array_string'] = const _i3.HeaderEncoder().convert($arrayString);
    }

    final $$bool = _$jsonSerializers.serialize($bool, specifiedType: const FullType(bool));
    if ($$bool != null) {
      _request.headers['bool'] = const _i3.HeaderEncoder().convert($$bool);
    }

    final $string = _$jsonSerializers.serialize(string, specifiedType: const FullType(String));
    if ($string != null) {
      _request.headers['string'] = const _i3.HeaderEncoder().convert($string);
    }

    final $stringBinary = _$jsonSerializers.serialize(stringBinary, specifiedType: const FullType(Uint8List));
    if ($stringBinary != null) {
      _request.headers['string_binary'] = const _i3.HeaderEncoder().convert($stringBinary);
    }

    final $$int = _$jsonSerializers.serialize($int, specifiedType: const FullType(int));
    if ($$int != null) {
      _request.headers['int'] = const _i3.HeaderEncoder().convert($$int);
    }

    final $$double = _$jsonSerializers.serialize($double, specifiedType: const FullType(double));
    if ($$double != null) {
      _request.headers['double'] = const _i3.HeaderEncoder().convert($$double);
    }

    final $$num = _$jsonSerializers.serialize($num, specifiedType: const FullType(num));
    if ($$num != null) {
      _request.headers['num'] = const _i3.HeaderEncoder().convert($$num);
    }

    final $object = _$jsonSerializers.serialize(object, specifiedType: const FullType(JsonObject));
    if ($object != null) {
      _request.headers['object'] = const _i3.HeaderEncoder().convert($object);
    }

    final $oneOf = _$jsonSerializers.serialize(oneOf, specifiedType: const FullType(GetHeadersOneOf));
    if ($oneOf != null) {
      _request.headers['oneOf'] = const _i3.HeaderEncoder().convert($oneOf);
    }

    final $anyOf = _$jsonSerializers.serialize(anyOf, specifiedType: const FullType(GetHeadersAnyOf));
    if ($anyOf != null) {
      _request.headers['anyOf'] = const _i3.HeaderEncoder().convert($anyOf);
    }

    final $enumPattern = _$jsonSerializers.serialize(enumPattern, specifiedType: const FullType(GetHeadersEnumPattern));
    _i3.checkPattern(
      $enumPattern as String?,
      RegExp('[a-z]'),
      'enumPattern',
    );
    if ($enumPattern != null) {
      _request.headers['enum_pattern'] = const _i3.HeaderEncoder().convert($enumPattern);
    }

    return _request;
  }

  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [contentString]
  ///   * [contentParameter]
  ///   * [array]
  ///   * [arrayString]
  ///   * [$bool]
  ///   * [string]
  ///   * [stringBinary]
  ///   * [$int]
  ///   * [$double]
  ///   * [$num]
  ///   * [object]
  ///   * [oneOf]
  ///   * [anyOf]
  ///   * [enumPattern]
  ///
  /// Status codes:
  ///   * 200
  ///
  /// See:
  ///  * [$getHeaders_Request] for the request send by this method.
  ///  * [$getHeaders_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<JsonObject, void>> getHeaders({
    ContentString<BuiltMap<String, JsonObject>>? contentString,
    ContentString<BuiltMap<String, JsonObject>>? contentParameter,
    BuiltList<JsonObject>? array,
    BuiltList<String>? arrayString,
    bool? $bool,
    String? string,
    Uint8List? stringBinary,
    int? $int,
    double? $double,
    num? $num,
    JsonObject? object,
    GetHeadersOneOf? oneOf,
    GetHeadersAnyOf? anyOf,
    GetHeadersEnumPattern? enumPattern,
  }) async {
    final _request = $getHeaders_Request(
      contentString: contentString,
      contentParameter: contentParameter,
      array: array,
      arrayString: arrayString,
      $bool: $bool,
      string: string,
      stringBinary: stringBinary,
      $int: $int,
      $double: $double,
      $num: $num,
      object: object,
      oneOf: oneOf,
      anyOf: anyOf,
      enumPattern: enumPattern,
    );
    final _response = await send(_request);

    final serializer = $getHeaders_Serializer();
    final _rawResponse = await _i1.ResponseConverter<JsonObject, void>(serializer).convert(_response);
    return _i1.DynamiteResponse.fromRawResponse(_rawResponse);
  }

  /// Builds a serializer to parse the response of [$getPathParameter_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<JsonObject, void> $getPathParameter_Serializer() => _i1.DynamiteSerializer<JsonObject, void>(
        bodyType: const FullType(JsonObject),
        headersType: null,
        serializers: _$jsonSerializers,
      );

  /// Returns a `DynamiteRequest` backing the [getPathParameter] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200
  ///
  /// See:
  ///  * [getPathParameter] for a method executing this request and parsing the response.
  ///  * [$getPathParameter_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i1.DynamiteRequest $getPathParameter_Request({required String pathParameter}) {
    final _parameters = <String, Object?>{};
    final $pathParameter = _$jsonSerializers.serialize(pathParameter, specifiedType: const FullType(String));
    _parameters['path_parameter'] = $pathParameter;

    final _path = _i4.UriTemplate('/{path_parameter}').expand(_parameters);
    final _uri = Uri.parse('$baseURL$_path');
    final _request = _i1.DynamiteRequest('get', _uri)..validStatuses = const {200};
    _request.headers['Accept'] = 'application/json';
    return _request;
  }

  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200
  ///
  /// See:
  ///  * [$getPathParameter_Request] for the request send by this method.
  ///  * [$getPathParameter_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<JsonObject, void>> getPathParameter({required String pathParameter}) async {
    final _request = $getPathParameter_Request(
      pathParameter: pathParameter,
    );
    final _response = await send(_request);

    final serializer = $getPathParameter_Serializer();
    final _rawResponse = await _i1.ResponseConverter<JsonObject, void>(serializer).convert(_response);
    return _i1.DynamiteResponse.fromRawResponse(_rawResponse);
  }

  /// Builds a serializer to parse the response of [$getNamingCollisions_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<JsonObject, void> $getNamingCollisions_Serializer() =>
      _i1.DynamiteSerializer<JsonObject, void>(
        bodyType: const FullType(JsonObject),
        headersType: null,
        serializers: _$jsonSerializers,
      );

  /// Returns a `DynamiteRequest` backing the [getNamingCollisions] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200
  ///
  /// See:
  ///  * [getNamingCollisions] for a method executing this request and parsing the response.
  ///  * [$getNamingCollisions_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i1.DynamiteRequest $getNamingCollisions_Request({
    required String jsonSerializers,
    required String serializers,
    required String body,
    required String parameters,
    required String headers,
  }) {
    final _parameters = <String, Object?>{};
    final $jsonSerializers = _$jsonSerializers.serialize(jsonSerializers, specifiedType: const FullType(String));
    _parameters['%24jsonSerializers'] = $jsonSerializers;

    final _path = _i4.UriTemplate('/naming_collisions{?%24jsonSerializers*}').expand(_parameters);
    final _uri = Uri.parse('$baseURL$_path');
    final _request = _i1.DynamiteRequest('get', _uri)..validStatuses = const {200};
    _request.headers['Accept'] = 'application/json';
    final $serializers = _$jsonSerializers.serialize(serializers, specifiedType: const FullType(String));
    if ($serializers != null) {
      _request.headers['%24serializers'] = const _i3.HeaderEncoder().convert($serializers);
    }

    final $body = _$jsonSerializers.serialize(body, specifiedType: const FullType(String));
    if ($body != null) {
      _request.headers['_body'] = const _i3.HeaderEncoder().convert($body);
    }

    final $parameters = _$jsonSerializers.serialize(parameters, specifiedType: const FullType(String));
    if ($parameters != null) {
      _request.headers['_parameters'] = const _i3.HeaderEncoder().convert($parameters);
    }

    final $headers = _$jsonSerializers.serialize(headers, specifiedType: const FullType(String));
    if ($headers != null) {
      _request.headers['_headers'] = const _i3.HeaderEncoder().convert($headers);
    }

    return _request;
  }

  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200
  ///
  /// See:
  ///  * [$getNamingCollisions_Request] for the request send by this method.
  ///  * [$getNamingCollisions_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<JsonObject, void>> getNamingCollisions({
    required String jsonSerializers,
    required String serializers,
    required String body,
    required String parameters,
    required String headers,
  }) async {
    final _request = $getNamingCollisions_Request(
      jsonSerializers: jsonSerializers,
      serializers: serializers,
      body: body,
      parameters: parameters,
      headers: headers,
    );
    final _response = await send(_request);

    final serializer = $getNamingCollisions_Serializer();
    final _rawResponse = await _i1.ResponseConverter<JsonObject, void>(serializer).convert(_response);
    return _i1.DynamiteResponse.fromRawResponse(_rawResponse);
  }
}

typedef GetOneOf = ({bool? $bool, String? string});
typedef GetAnyOf = ({bool? $bool, String? string});

class GetEnumPattern extends EnumClass {
  const GetEnumPattern._(super.name);

  /// `a`
  static const GetEnumPattern a = _$getEnumPatternA;

  /// `0`
  @BuiltValueEnumConst(wireName: '0')
  static const GetEnumPattern $0 = _$getEnumPattern$0;

  /// Returns a set with all values this enum contains.
  static BuiltSet<GetEnumPattern> get values => _$getEnumPatternValues;

  /// Returns the enum value associated to the [name].
  static GetEnumPattern valueOf(String name) => _$valueOfGetEnumPattern(name);

  /// Returns the serialized value of this enum value.
  String get value => _$jsonSerializers.serializeWith(serializer, this)! as String;

  /// Serializer for GetEnumPattern.
  @BuiltValueSerializer(custom: true)
  static Serializer<GetEnumPattern> get serializer => const _$GetEnumPatternSerializer();
}

class _$GetEnumPatternSerializer implements PrimitiveSerializer<GetEnumPattern> {
  const _$GetEnumPatternSerializer();

  static const Map<GetEnumPattern, Object> _toWire = <GetEnumPattern, Object>{
    GetEnumPattern.a: 'a',
    GetEnumPattern.$0: '0',
  };

  static const Map<Object, GetEnumPattern> _fromWire = <Object, GetEnumPattern>{
    'a': GetEnumPattern.a,
    '0': GetEnumPattern.$0,
  };

  @override
  Iterable<Type> get types => const [GetEnumPattern];

  @override
  String get wireName => 'GetEnumPattern';

  @override
  Object serialize(
    Serializers serializers,
    GetEnumPattern object, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      _toWire[object]!;

  @override
  GetEnumPattern deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      _fromWire[serialized]!;
}

typedef GetHeadersOneOf = ({bool? $bool, String? string});
typedef GetHeadersAnyOf = ({bool? $bool, String? string});

class GetHeadersEnumPattern extends EnumClass {
  const GetHeadersEnumPattern._(super.name);

  /// `a`
  static const GetHeadersEnumPattern a = _$getHeadersEnumPatternA;

  /// `0`
  @BuiltValueEnumConst(wireName: '0')
  static const GetHeadersEnumPattern $0 = _$getHeadersEnumPattern$0;

  /// Returns a set with all values this enum contains.
  static BuiltSet<GetHeadersEnumPattern> get values => _$getHeadersEnumPatternValues;

  /// Returns the enum value associated to the [name].
  static GetHeadersEnumPattern valueOf(String name) => _$valueOfGetHeadersEnumPattern(name);

  /// Returns the serialized value of this enum value.
  String get value => _$jsonSerializers.serializeWith(serializer, this)! as String;

  /// Serializer for GetHeadersEnumPattern.
  @BuiltValueSerializer(custom: true)
  static Serializer<GetHeadersEnumPattern> get serializer => const _$GetHeadersEnumPatternSerializer();
}

class _$GetHeadersEnumPatternSerializer implements PrimitiveSerializer<GetHeadersEnumPattern> {
  const _$GetHeadersEnumPatternSerializer();

  static const Map<GetHeadersEnumPattern, Object> _toWire = <GetHeadersEnumPattern, Object>{
    GetHeadersEnumPattern.a: 'a',
    GetHeadersEnumPattern.$0: '0',
  };

  static const Map<Object, GetHeadersEnumPattern> _fromWire = <Object, GetHeadersEnumPattern>{
    'a': GetHeadersEnumPattern.a,
    '0': GetHeadersEnumPattern.$0,
  };

  @override
  Iterable<Type> get types => const [GetHeadersEnumPattern];

  @override
  String get wireName => 'GetHeadersEnumPattern';

  @override
  Object serialize(
    Serializers serializers,
    GetHeadersEnumPattern object, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      _toWire[object]!;

  @override
  GetHeadersEnumPattern deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      _fromWire[serialized]!;
}

/// Serialization extension for `GetOneOf`.
extension $GetOneOfExtension on GetOneOf {
  /// Serializer for GetOneOf.
  @BuiltValueSerializer(custom: true)
  static Serializer<GetOneOf> get serializer => $93403da1a64cb6a7b1597c7a05e9b2beExtension._serializer;

  /// Creates a new object from the given [json] data.
  ///
  /// Use `toJson` to serialize it back into json.
  static GetOneOf fromJson(Object? json) => $93403da1a64cb6a7b1597c7a05e9b2beExtension._fromJson(json);
}

/// Serialization extension for `GetAnyOf`.
extension $GetAnyOfExtension on GetAnyOf {
  /// Serializer for GetAnyOf.
  @BuiltValueSerializer(custom: true)
  static Serializer<GetAnyOf> get serializer => $93403da1a64cb6a7b1597c7a05e9b2beExtension._serializer;

  /// Creates a new object from the given [json] data.
  ///
  /// Use `toJson` to serialize it back into json.
  static GetAnyOf fromJson(Object? json) => $93403da1a64cb6a7b1597c7a05e9b2beExtension._fromJson(json);
}

/// Serialization extension for `GetHeadersOneOf`.
extension $GetHeadersOneOfExtension on GetHeadersOneOf {
  /// Serializer for GetHeadersOneOf.
  @BuiltValueSerializer(custom: true)
  static Serializer<GetHeadersOneOf> get serializer => $93403da1a64cb6a7b1597c7a05e9b2beExtension._serializer;

  /// Creates a new object from the given [json] data.
  ///
  /// Use `toJson` to serialize it back into json.
  static GetHeadersOneOf fromJson(Object? json) => $93403da1a64cb6a7b1597c7a05e9b2beExtension._fromJson(json);
}

/// Serialization extension for `GetHeadersAnyOf`.
extension $GetHeadersAnyOfExtension on GetHeadersAnyOf {
  /// Serializer for GetHeadersAnyOf.
  @BuiltValueSerializer(custom: true)
  static Serializer<GetHeadersAnyOf> get serializer => $93403da1a64cb6a7b1597c7a05e9b2beExtension._serializer;

  /// Creates a new object from the given [json] data.
  ///
  /// Use `toJson` to serialize it back into json.
  static GetHeadersAnyOf fromJson(Object? json) => $93403da1a64cb6a7b1597c7a05e9b2beExtension._fromJson(json);
}

typedef _$93403da1a64cb6a7b1597c7a05e9b2be = ({bool? $bool, String? string});

/// @nodoc
// ignore: library_private_types_in_public_api
extension $93403da1a64cb6a7b1597c7a05e9b2beExtension on _$93403da1a64cb6a7b1597c7a05e9b2be {
  List<dynamic> get _values => [$bool, string];

  /// {@macro Dynamite.validateOneOf}
  void validateOneOf() => _i3.validateOneOf(_values);

  /// {@macro Dynamite.validateAnyOf}
  void validateAnyOf() => _i3.validateAnyOf(_values);
  static Serializer<_$93403da1a64cb6a7b1597c7a05e9b2be> get _serializer =>
      const _$93403da1a64cb6a7b1597c7a05e9b2beSerializer();
  static _$93403da1a64cb6a7b1597c7a05e9b2be _fromJson(Object? json) =>
      _$jsonSerializers.deserializeWith(_serializer, json)!;

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  Object? toJson() => _$jsonSerializers.serializeWith(_serializer, this);
}

class _$93403da1a64cb6a7b1597c7a05e9b2beSerializer implements PrimitiveSerializer<_$93403da1a64cb6a7b1597c7a05e9b2be> {
  const _$93403da1a64cb6a7b1597c7a05e9b2beSerializer();

  @override
  Iterable<Type> get types => const [_$93403da1a64cb6a7b1597c7a05e9b2be];

  @override
  String get wireName => r'_$93403da1a64cb6a7b1597c7a05e9b2be';

  @override
  Object serialize(
    Serializers serializers,
    _$93403da1a64cb6a7b1597c7a05e9b2be object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    dynamic value;
    value = object.$bool;
    if (value != null) {
      return serializers.serialize(value, specifiedType: const FullType(bool))!;
    }
    value = object.string;
    if (value != null) {
      return serializers.serialize(value, specifiedType: const FullType(String))!;
    }
// Should not be possible after validation.
    throw StateError('Tried to serialize without any value.');
  }

  @override
  _$93403da1a64cb6a7b1597c7a05e9b2be deserialize(
    Serializers serializers,
    Object data, {
    FullType specifiedType = FullType.unspecified,
  }) {
    bool? $bool;
    try {
      $bool = serializers.deserialize(data, specifiedType: const FullType(bool))! as bool;
    } catch (_) {}
    String? string;
    try {
      string = serializers.deserialize(data, specifiedType: const FullType(String))! as String;
    } catch (_) {}
    return ($bool: $bool, string: string);
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
        const FullType(BuiltMap, [FullType(String), FullType(JsonObject)]),
        MapBuilder<String, JsonObject>.new,
      )
      ..addBuilderFactory(
        const FullType(ContentString, [
          FullType(BuiltMap, [FullType(String), FullType(JsonObject)]),
        ]),
        ContentStringBuilder<BuiltMap<String, JsonObject>>.new,
      )
      ..add(ContentString.serializer)
      ..addBuilderFactory(const FullType(BuiltList, [FullType(JsonObject)]), ListBuilder<JsonObject>.new)
      ..addBuilderFactory(const FullType(BuiltList, [FullType(String)]), ListBuilder<String>.new)
      ..add($93403da1a64cb6a7b1597c7a05e9b2beExtension._serializer)
      ..add(GetEnumPattern.serializer)
      ..add(GetHeadersEnumPattern.serializer))
    .build();

/// Serializer for all values in this library.
///
/// Serializes values into the json. Json serialization is more expensive than the built_value wire format.
/// See: [$serializers] for serializing into the `built_value` wire format.
@_i2.visibleForTesting
final Serializers $jsonSerializers = _$jsonSerializers;
final Serializers _$jsonSerializers = (_$serializers.toBuilder()
      ..add(_i5.DynamiteDoubleSerializer())
      ..addPlugin(_i6.StandardJsonPlugin(typesToLeaveAsList: const {_$93403da1a64cb6a7b1597c7a05e9b2be}))
      ..addPlugin(const _i5.HeaderPlugin())
      ..addPlugin(const _i5.ContentStringPlugin()))
    .build();
// coverage:ignore-end
