// OpenAPI client generated by Dynamite. Do not manually edit this file.

// ignore_for_file: camel_case_extensions, camel_case_types, cascade_invocations
// ignore_for_file: discarded_futures
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: non_constant_identifier_names, public_member_api_docs
// ignore_for_file: unreachable_switch_case, unused_element

/// responses test Version: 0.0.1.
library; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart' as _i5;
import 'package:dynamite_runtime/built_value.dart' as _i4;
import 'package:dynamite_runtime/http_client.dart' as _i1;
import 'package:http/http.dart' as _i3;
import 'package:meta/meta.dart' as _i2;

class $Client extends _i1.DynamiteClient {
  /// Creates a new `DynamiteClient` for untagged requests.
  $Client(
    super.baseURL, {
    super.httpClient,
  });

  /// Creates a new [$Client] from another [client].
  $Client.fromClient(_i1.DynamiteClient client)
      : super(
          client.baseURL,
          httpClient: client.httpClient,
          authentications: client.authentications,
        );

  /// Builds a serializer to parse the response of [$$get_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<String, void> $$get_Serializer() => _i1.DynamiteSerializer(
        bodyType: const FullType(String),
        headersType: null,
        serializers: _$jsonSerializers,
      );

  /// Returns a `DynamiteRequest` backing the [$get] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * default
  ///
  /// See:
  ///  * [$get] for a method executing this request and parsing the response.
  ///  * [$$get_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i3.Request $$get_Request() {
    const _path = '/';
    final _uri = Uri.parse('$baseURL$_path');
    final _request = _i3.Request('get', _uri);
    _request.headers['Accept'] = 'application/json';
    return _request;
  }

  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * default
  ///
  /// See:
  ///  * [$$get_Request] for the request send by this method.
  ///  * [$$get_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<String, void>> $get() async {
    final _request = $$get_Request();
    final _streamedResponse = await httpClient.send(_request);
    final _response = await _i3.Response.fromStream(_streamedResponse);

    final _serializer = $$get_Serializer();
    return _i1.ResponseConverter<String, void>(_serializer).convert(_response);
  }

  /// Builds a serializer to parse the response of [$put_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<String, void> $put_Serializer() => _i1.DynamiteSerializer(
        bodyType: const FullType(String),
        headersType: null,
        serializers: _$jsonSerializers,
        validStatuses: const {200},
      );

  /// Returns a `DynamiteRequest` backing the [put] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200
  ///   * 201
  ///
  /// See:
  ///  * [put] for a method executing this request and parsing the response.
  ///  * [$put_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i3.Request $put_Request() {
    const _path = '/';
    final _uri = Uri.parse('$baseURL$_path');
    final _request = _i3.Request('put', _uri);
    _request.headers['Accept'] = 'application/json';
    return _request;
  }

  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200
  ///   * 201
  ///
  /// See:
  ///  * [$put_Request] for the request send by this method.
  ///  * [$put_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<String, void>> put() async {
    final _request = $put_Request();
    final _streamedResponse = await httpClient.send(_request);
    final _response = await _i3.Response.fromStream(_streamedResponse);

    final _serializer = $put_Serializer();
    return _i1.ResponseConverter<String, void>(_serializer).convert(_response);
  }

  /// Builds a serializer to parse the response of [$post_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<String, void> $post_Serializer() => _i1.DynamiteSerializer(
        bodyType: const FullType(String),
        headersType: null,
        serializers: _$jsonSerializers,
      );

  /// Returns a `DynamiteRequest` backing the [post] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * default
  ///   * 200
  ///   * 201
  ///
  /// See:
  ///  * [post] for a method executing this request and parsing the response.
  ///  * [$post_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i3.Request $post_Request() {
    const _path = '/';
    final _uri = Uri.parse('$baseURL$_path');
    final _request = _i3.Request('post', _uri);
    _request.headers['Accept'] = 'application/json';
    return _request;
  }

  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * default
  ///   * 200
  ///   * 201
  ///
  /// See:
  ///  * [$post_Request] for the request send by this method.
  ///  * [$post_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<String, void>> post() async {
    final _request = $post_Request();
    final _streamedResponse = await httpClient.send(_request);
    final _response = await _i3.Response.fromStream(_streamedResponse);

    final _serializer = $post_Serializer();
    return _i1.ResponseConverter<String, void>(_serializer).convert(_response);
  }

  /// Builds a serializer to parse the response of [$patch_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<String, void> $patch_Serializer() => _i1.DynamiteSerializer(
        bodyType: const FullType(String),
        headersType: null,
        serializers: _$jsonSerializers,
        validStatuses: const {200, 201},
      );

  /// Returns a `DynamiteRequest` backing the [patch] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200
  ///   * 201
  ///
  /// See:
  ///  * [patch] for a method executing this request and parsing the response.
  ///  * [$patch_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i3.Request $patch_Request() {
    const _path = '/';
    final _uri = Uri.parse('$baseURL$_path');
    final _request = _i3.Request('patch', _uri);
    _request.headers['Accept'] = 'application/json';
    return _request;
  }

  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200
  ///   * 201
  ///
  /// See:
  ///  * [$patch_Request] for the request send by this method.
  ///  * [$patch_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<String, void>> patch() async {
    final _request = $patch_Request();
    final _streamedResponse = await httpClient.send(_request);
    final _response = await _i3.Response.fromStream(_streamedResponse);

    final _serializer = $patch_Serializer();
    return _i1.ResponseConverter<String, void>(_serializer).convert(_response);
  }
}

// coverage:ignore-start
/// Serializer for all values in this library.
///
/// Serializes values into the `built_value` wire format.
/// See: [$jsonSerializers] for serializing into json.
@_i2.visibleForTesting
final Serializers $serializers = _$serializers;
final Serializers _$serializers = Serializers();

/// Serializer for all values in this library.
///
/// Serializes values into the json. Json serialization is more expensive than the built_value wire format.
/// See: [$serializers] for serializing into the `built_value` wire format.
@_i2.visibleForTesting
final Serializers $jsonSerializers = _$jsonSerializers;
final Serializers _$jsonSerializers = (_$serializers.toBuilder()
      ..add(_i4.DynamiteDoubleSerializer())
      ..addPlugin(_i5.StandardJsonPlugin())
      ..addPlugin(const _i4.HeaderPlugin())
      ..addPlugin(const _i4.ContentStringPlugin()))
    .build();
// coverage:ignore-end
