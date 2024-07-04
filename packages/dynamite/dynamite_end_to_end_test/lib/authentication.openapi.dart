// OpenAPI client generated by Dynamite. Do not manually edit this file.

// ignore_for_file: camel_case_extensions, camel_case_types, cascade_invocations
// ignore_for_file: discarded_futures
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: non_constant_identifier_names, public_member_api_docs
// ignore_for_file: unreachable_switch_case, unused_element

/// authentication test Version: 0.0.1.
library; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart' as _i6;
import 'package:collection/collection.dart' as _i4;
import 'package:dynamite_runtime/built_value.dart' as _i5;
import 'package:dynamite_runtime/http_client.dart' as _i1;
import 'package:http/http.dart' as _i3;
import 'package:meta/meta.dart' as _i2;

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

  /// Builds a serializer to parse the response of [$noAuthentication_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<JsonObject, void> $noAuthentication_Serializer() => _i1.DynamiteSerializer(
        bodyType: const FullType(JsonObject),
        headersType: null,
        serializers: _$jsonSerializers,
        validStatuses: const {200},
      );

  /// Returns a `DynamiteRequest` backing the [noAuthentication] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200
  ///
  /// See:
  ///  * [noAuthentication] for a method executing this request and parsing the response.
  ///  * [$noAuthentication_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i3.Request $noAuthentication_Request() {
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
  ///   * 200
  ///
  /// See:
  ///  * [$noAuthentication_Request] for the request send by this method.
  ///  * [$noAuthentication_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<JsonObject, void>> noAuthentication() async {
    final _request = $noAuthentication_Request();
    final _streamedResponse = await httpClient.send(_request);
    final _response = await _i3.Response.fromStream(_streamedResponse);

    final _serializer = $noAuthentication_Serializer();
    return _i1.ResponseConverter<JsonObject, void>(_serializer).convert(_response);
  }

  /// Builds a serializer to parse the response of [$basicAuthentication_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<JsonObject, void> $basicAuthentication_Serializer() => _i1.DynamiteSerializer(
        bodyType: const FullType(JsonObject),
        headersType: null,
        serializers: _$jsonSerializers,
        validStatuses: const {200},
      );

  /// Returns a `DynamiteRequest` backing the [basicAuthentication] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200
  ///
  /// See:
  ///  * [basicAuthentication] for a method executing this request and parsing the response.
  ///  * [$basicAuthentication_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i3.Request $basicAuthentication_Request() {
    const _path = '/basic';
    final _uri = Uri.parse('$baseURL$_path');
    final _request = _i3.Request('get', _uri);
    _request.headers['Accept'] = 'application/json';
// coverage:ignore-start
    final authentication = _i4.IterableExtension(authentications)?.firstWhereOrNull(
      (auth) => switch (auth) {
        _i1.DynamiteHttpBasicAuthentication() => true,
        _ => false,
      },
    );

    if (authentication != null) {
      _request.headers.addAll(
        authentication.headers,
      );
    } else {
      throw Exception('Missing authentication for basic_auth');
    }

// coverage:ignore-end
    return _request;
  }

  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200
  ///
  /// See:
  ///  * [$basicAuthentication_Request] for the request send by this method.
  ///  * [$basicAuthentication_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<JsonObject, void>> basicAuthentication() async {
    final _request = $basicAuthentication_Request();
    final _streamedResponse = await httpClient.send(_request);
    final _response = await _i3.Response.fromStream(_streamedResponse);

    final _serializer = $basicAuthentication_Serializer();
    return _i1.ResponseConverter<JsonObject, void>(_serializer).convert(_response);
  }

  /// Builds a serializer to parse the response of [$bearerAuthentication_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<JsonObject, void> $bearerAuthentication_Serializer() => _i1.DynamiteSerializer(
        bodyType: const FullType(JsonObject),
        headersType: null,
        serializers: _$jsonSerializers,
        validStatuses: const {200},
      );

  /// Returns a `DynamiteRequest` backing the [bearerAuthentication] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200
  ///
  /// See:
  ///  * [bearerAuthentication] for a method executing this request and parsing the response.
  ///  * [$bearerAuthentication_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i3.Request $bearerAuthentication_Request() {
    const _path = '/bearer';
    final _uri = Uri.parse('$baseURL$_path');
    final _request = _i3.Request('get', _uri);
    _request.headers['Accept'] = 'application/json';
// coverage:ignore-start
    final authentication = _i4.IterableExtension(authentications)?.firstWhereOrNull(
      (auth) => switch (auth) {
        _i1.DynamiteHttpBearerAuthentication() => true,
        _ => false,
      },
    );

    if (authentication != null) {
      _request.headers.addAll(
        authentication.headers,
      );
    } else {
      throw Exception('Missing authentication for bearer_auth');
    }

// coverage:ignore-end
    return _request;
  }

  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200
  ///
  /// See:
  ///  * [$bearerAuthentication_Request] for the request send by this method.
  ///  * [$bearerAuthentication_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<JsonObject, void>> bearerAuthentication() async {
    final _request = $bearerAuthentication_Request();
    final _streamedResponse = await httpClient.send(_request);
    final _response = await _i3.Response.fromStream(_streamedResponse);

    final _serializer = $bearerAuthentication_Serializer();
    return _i1.ResponseConverter<JsonObject, void>(_serializer).convert(_response);
  }

  /// Builds a serializer to parse the response of [$multipleAuthentications_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<JsonObject, void> $multipleAuthentications_Serializer() => _i1.DynamiteSerializer(
        bodyType: const FullType(JsonObject),
        headersType: null,
        serializers: _$jsonSerializers,
        validStatuses: const {200},
      );

  /// Returns a `DynamiteRequest` backing the [multipleAuthentications] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200
  ///
  /// See:
  ///  * [multipleAuthentications] for a method executing this request and parsing the response.
  ///  * [$multipleAuthentications_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i3.Request $multipleAuthentications_Request() {
    const _path = '/multiple';
    final _uri = Uri.parse('$baseURL$_path');
    final _request = _i3.Request('get', _uri);
    _request.headers['Accept'] = 'application/json';
// coverage:ignore-start
    final authentication = _i4.IterableExtension(authentications)?.firstWhereOrNull(
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
    return _request;
  }

  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200
  ///
  /// See:
  ///  * [$multipleAuthentications_Request] for the request send by this method.
  ///  * [$multipleAuthentications_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<JsonObject, void>> multipleAuthentications() async {
    final _request = $multipleAuthentications_Request();
    final _streamedResponse = await httpClient.send(_request);
    final _response = await _i3.Response.fromStream(_streamedResponse);

    final _serializer = $multipleAuthentications_Serializer();
    return _i1.ResponseConverter<JsonObject, void>(_serializer).convert(_response);
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
      ..add(_i5.DynamiteDoubleSerializer())
      ..addPlugin(_i6.StandardJsonPlugin())
      ..addPlugin(const _i5.HeaderPlugin())
      ..addPlugin(const _i5.ContentStringPlugin()))
    .build();
// coverage:ignore-end
