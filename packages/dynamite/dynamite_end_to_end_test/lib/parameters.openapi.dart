// ignore_for_file: camel_case_types, discarded_futures
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: public_member_api_docs, unreachable_switch_case
// ignore_for_file: unused_element

library parameters_openapi;

import 'dart:typed_data';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:dynamite_runtime/built_value.dart';
import 'package:dynamite_runtime/http_client.dart';
import 'package:dynamite_runtime/models.dart';
import 'package:dynamite_runtime/utils.dart' as dynamite_utils;
import 'package:meta/meta.dart';
import 'package:universal_io/io.dart';
import 'package:uri/uri.dart';

part 'parameters.openapi.g.dart';

class $Client extends DynamiteClient {
  $Client(
    super.baseURL, {
    super.baseHeaders,
    super.userAgent,
    super.httpClient,
    super.cookieJar,
  });

  $Client.fromClient(DynamiteClient client)
      : super(
          client.baseURL,
          baseHeaders: client.baseHeaders,
          httpClient: client.httpClient,
          cookieJar: client.cookieJar,
          authentications: client.authentications,
        );

  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
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
  ///  * [$getRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<JsonObject, void>> $get({
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
    final rawResponse = $getRaw(
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

    return rawResponse.future;
  }

  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
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
  ///  * [$get] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<JsonObject, void> $getRaw({
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
    final _parameters = <String, dynamic>{};
    const _headers = <String, String>{
      'Accept': 'application/json',
    };

    final $contentString = jsonSerializers.serialize(
      contentString,
      specifiedType: const FullType(ContentString, [
        FullType(BuiltMap, [FullType(String), FullType(JsonObject)]),
      ]),
    );
    _parameters['content_string'] = $contentString;

    final $contentParameter = jsonSerializers.serialize(
      contentParameter,
      specifiedType: const FullType(ContentString, [
        FullType(BuiltMap, [FullType(String), FullType(JsonObject)]),
      ]),
    );
    _parameters['content_parameter'] = $contentParameter;

    final $array = jsonSerializers.serialize(array, specifiedType: const FullType(BuiltList, [FullType(JsonObject)]));
    _parameters['array'] = $array;

    final $arrayString =
        jsonSerializers.serialize(arrayString, specifiedType: const FullType(BuiltList, [FullType(String)]));
    _parameters['array_string'] = $arrayString;

    final $$bool = jsonSerializers.serialize($bool, specifiedType: const FullType(bool));
    _parameters['bool'] = $$bool;

    final $string = jsonSerializers.serialize(string, specifiedType: const FullType(String));
    _parameters['string'] = $string;

    final $stringBinary = jsonSerializers.serialize(stringBinary, specifiedType: const FullType(Uint8List));
    _parameters['string_binary'] = $stringBinary;

    final $$int = jsonSerializers.serialize($int, specifiedType: const FullType(int));
    _parameters['int'] = $$int;

    final $$double = jsonSerializers.serialize($double, specifiedType: const FullType(double));
    _parameters['double'] = $$double;

    final $$num = jsonSerializers.serialize($num, specifiedType: const FullType(num));
    _parameters['num'] = $$num;

    final $object = jsonSerializers.serialize(object, specifiedType: const FullType(JsonObject));
    _parameters['object'] = $object;

    final $oneOf = jsonSerializers.serialize(oneOf, specifiedType: const FullType(GetOneOf));
    _parameters['oneOf'] = $oneOf;

    final $anyOf = jsonSerializers.serialize(anyOf, specifiedType: const FullType(GetAnyOf));
    _parameters['anyOf'] = $anyOf;

    final $enumPattern = jsonSerializers.serialize(enumPattern, specifiedType: const FullType(GetEnumPattern));
    dynamite_utils.checkPattern($enumPattern as String?, RegExp('[a-z]'), 'enumPattern');
    _parameters['enum_pattern'] = $enumPattern;

    final _path = UriTemplate(
      '/{?content_string*,content_parameter*,array*,array_string*,bool*,string*,string_binary*,int*,double*,num*,object*,oneOf*,anyOf*,enum_pattern*}',
    ).expand(_parameters);
    return DynamiteRawResponse<JsonObject, void>(
      response: executeRequest(
        'get',
        _path,
        _headers,
        null,
        const {200},
      ),
      bodyType: const FullType(JsonObject),
      headersType: null,
      serializers: jsonSerializers,
    );
  }

  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
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
  ///  * [getHeadersRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<JsonObject, void>> getHeaders({
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
    final rawResponse = getHeadersRaw(
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

    return rawResponse.future;
  }

  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
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
  ///  * [getHeaders] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<JsonObject, void> getHeadersRaw({
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
    final _headers = <String, String>{
      'Accept': 'application/json',
    };

    final $contentString = jsonSerializers.serialize(
      contentString,
      specifiedType: const FullType(ContentString, [
        FullType(BuiltMap, [FullType(String), FullType(JsonObject)]),
      ]),
    );
    if ($contentString != null) {
      _headers['content_string'] = const dynamite_utils.HeaderEncoder().convert($contentString);
    }

    final $contentParameter = jsonSerializers.serialize(
      contentParameter,
      specifiedType: const FullType(ContentString, [
        FullType(BuiltMap, [FullType(String), FullType(JsonObject)]),
      ]),
    );
    if ($contentParameter != null) {
      _headers['content_parameter'] = const dynamite_utils.HeaderEncoder().convert($contentParameter);
    }

    final $array = jsonSerializers.serialize(array, specifiedType: const FullType(BuiltList, [FullType(JsonObject)]));
    if ($array != null) {
      _headers['array'] = const dynamite_utils.HeaderEncoder().convert($array);
    }

    final $arrayString =
        jsonSerializers.serialize(arrayString, specifiedType: const FullType(BuiltList, [FullType(String)]));
    if ($arrayString != null) {
      _headers['array_string'] = const dynamite_utils.HeaderEncoder().convert($arrayString);
    }

    final $$bool = jsonSerializers.serialize($bool, specifiedType: const FullType(bool));
    if ($$bool != null) {
      _headers['bool'] = const dynamite_utils.HeaderEncoder().convert($$bool);
    }

    final $string = jsonSerializers.serialize(string, specifiedType: const FullType(String));
    if ($string != null) {
      _headers['string'] = const dynamite_utils.HeaderEncoder().convert($string);
    }

    final $stringBinary = jsonSerializers.serialize(stringBinary, specifiedType: const FullType(Uint8List));
    if ($stringBinary != null) {
      _headers['string_binary'] = const dynamite_utils.HeaderEncoder().convert($stringBinary);
    }

    final $$int = jsonSerializers.serialize($int, specifiedType: const FullType(int));
    if ($$int != null) {
      _headers['int'] = const dynamite_utils.HeaderEncoder().convert($$int);
    }

    final $$double = jsonSerializers.serialize($double, specifiedType: const FullType(double));
    if ($$double != null) {
      _headers['double'] = const dynamite_utils.HeaderEncoder().convert($$double);
    }

    final $$num = jsonSerializers.serialize($num, specifiedType: const FullType(num));
    if ($$num != null) {
      _headers['num'] = const dynamite_utils.HeaderEncoder().convert($$num);
    }

    final $object = jsonSerializers.serialize(object, specifiedType: const FullType(JsonObject));
    if ($object != null) {
      _headers['object'] = const dynamite_utils.HeaderEncoder().convert($object);
    }

    final $oneOf = jsonSerializers.serialize(oneOf, specifiedType: const FullType(GetHeadersOneOf));
    if ($oneOf != null) {
      _headers['oneOf'] = const dynamite_utils.HeaderEncoder().convert($oneOf);
    }

    final $anyOf = jsonSerializers.serialize(anyOf, specifiedType: const FullType(GetHeadersAnyOf));
    if ($anyOf != null) {
      _headers['anyOf'] = const dynamite_utils.HeaderEncoder().convert($anyOf);
    }

    final $enumPattern = jsonSerializers.serialize(enumPattern, specifiedType: const FullType(GetHeadersEnumPattern));
    dynamite_utils.checkPattern($enumPattern as String?, RegExp('[a-z]'), 'enumPattern');
    if ($enumPattern != null) {
      _headers['enum_pattern'] = const dynamite_utils.HeaderEncoder().convert($enumPattern);
    }

    const _path = '/headers';
    return DynamiteRawResponse<JsonObject, void>(
      response: executeRequest(
        'get',
        _path,
        _headers,
        null,
        const {200},
      ),
      bodyType: const FullType(JsonObject),
      headersType: null,
      serializers: jsonSerializers,
    );
  }

  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200
  ///
  /// See:
  ///  * [getPathParameterRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<JsonObject, void>> getPathParameter({required String pathParameter}) async {
    final rawResponse = getPathParameterRaw(
      pathParameter: pathParameter,
    );

    return rawResponse.future;
  }

  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200
  ///
  /// See:
  ///  * [getPathParameter] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<JsonObject, void> getPathParameterRaw({required String pathParameter}) {
    final _parameters = <String, dynamic>{};
    const _headers = <String, String>{
      'Accept': 'application/json',
    };

    final $pathParameter = jsonSerializers.serialize(pathParameter, specifiedType: const FullType(String));
    _parameters['path_parameter'] = $pathParameter;

    final _path = UriTemplate('/{path_parameter}').expand(_parameters);
    return DynamiteRawResponse<JsonObject, void>(
      response: executeRequest(
        'get',
        _path,
        _headers,
        null,
        const {200},
      ),
      bodyType: const FullType(JsonObject),
      headersType: null,
      serializers: jsonSerializers,
    );
  }
}

class GetEnumPattern extends EnumClass {
  const GetEnumPattern._(super.name);

  static const GetEnumPattern a = _$getEnumPatternA;

  @BuiltValueEnumConst(wireName: '0')
  static const GetEnumPattern $0 = _$getEnumPattern$0;

  static BuiltSet<GetEnumPattern> get values => _$getEnumPatternValues;

  static GetEnumPattern valueOf(String name) => _$valueOfGetEnumPattern(name);

  String get value => jsonSerializers.serializeWith(serializer, this)! as String;

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

class GetHeadersEnumPattern extends EnumClass {
  const GetHeadersEnumPattern._(super.name);

  static const GetHeadersEnumPattern a = _$getHeadersEnumPatternA;

  @BuiltValueEnumConst(wireName: '0')
  static const GetHeadersEnumPattern $0 = _$getHeadersEnumPattern$0;

  static BuiltSet<GetHeadersEnumPattern> get values => _$getHeadersEnumPatternValues;

  static GetHeadersEnumPattern valueOf(String name) => _$valueOfGetHeadersEnumPattern(name);

  String get value => jsonSerializers.serializeWith(serializer, this)! as String;

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

typedef GetOneOf = ({bool? $bool, String? string});
typedef GetAnyOf = ({bool? $bool, String? string});
typedef GetHeadersOneOf = ({bool? $bool, String? string});
typedef GetHeadersAnyOf = ({bool? $bool, String? string});
typedef $BoolString = ({bool? $bool, String? string});

extension $BoolStringExtension on $BoolString {
  List<dynamic> get _values => [$bool, string];
  void validateOneOf() => dynamite_utils.validateOneOf(_values);
  void validateAnyOf() => dynamite_utils.validateAnyOf(_values);
  static Serializer<$BoolString> get serializer => const _$BoolStringSerializer();
  static $BoolString fromJson(Object? json) => jsonSerializers.deserializeWith(serializer, json)!;
  Object? toJson() => jsonSerializers.serializeWith(serializer, this);
}

class _$BoolStringSerializer implements PrimitiveSerializer<$BoolString> {
  const _$BoolStringSerializer();

  @override
  Iterable<Type> get types => const [$BoolString];

  @override
  String get wireName => r'$BoolString';

  @override
  Object serialize(
    Serializers serializers,
    $BoolString object, {
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
  $BoolString deserialize(
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
@visibleForTesting
final Serializers serializers = (Serializers().toBuilder()
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
      ..add($BoolStringExtension.serializer)
      ..add(GetEnumPattern.serializer)
      ..add(GetHeadersEnumPattern.serializer))
    .build();
@visibleForTesting
final Serializers jsonSerializers = (serializers.toBuilder()
      ..add(DynamiteDoubleSerializer())
      ..addPlugin(StandardJsonPlugin())
      ..addPlugin(const HeaderPlugin())
      ..addPlugin(const ContentStringPlugin()))
    .build();
// coverage:ignore-end
