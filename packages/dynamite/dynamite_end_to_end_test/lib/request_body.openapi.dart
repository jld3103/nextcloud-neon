// OpenAPI client generated by Dynamite. Do not manually edit this file.

// ignore_for_file: camel_case_extensions, camel_case_types, discarded_futures
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: non_constant_identifier_names, public_member_api_docs
// ignore_for_file: unreachable_switch_case, unused_element

/// request body test Version: 0.0.1.
library; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert';
import 'dart:typed_data';

import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart' as _i4;
import 'package:dynamite_runtime/built_value.dart' as _i3;
import 'package:dynamite_runtime/http_client.dart' as _i1;
import 'package:meta/meta.dart' as _i2;

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
  _i1.DynamiteSerializer<void, void> $$get_Serializer() => _i1.DynamiteSerializer<void, void>(
        bodyType: null,
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
  _i1.DynamiteRequest $$get_Request({Uint8List? uint8List}) {
    const _path = '/';
    final _uri = Uri.parse('$baseURL$_path');
    final _request = _i1.DynamiteRequest('get', _uri);
    _request.headers['Content-Type'] = 'application/octet-stream';
    if (uint8List != null) {
      _request.bodyBytes = uint8List;
    }
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
  Future<_i1.DynamiteResponse<void, void>> $get({Uint8List? uint8List}) async {
    final _request = $$get_Request(
      uint8List: uint8List,
    );
    final _response = await send(_request);

    final serializer = $$get_Serializer();
    final _rawResponse = await _i1.ResponseConverter<void, void>(serializer).convert(_response);
    return _i1.DynamiteResponse.fromRawResponse(_rawResponse);
  }

  /// Builds a serializer to parse the response of [$$post_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<void, void> $$post_Serializer() => _i1.DynamiteSerializer<void, void>(
        bodyType: null,
        headersType: null,
        serializers: _$jsonSerializers,
      );

  /// Returns a `DynamiteRequest` backing the [$post] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * default
  ///
  /// See:
  ///  * [$post] for a method executing this request and parsing the response.
  ///  * [$$post_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i1.DynamiteRequest $$post_Request({String? string}) {
    const _path = '/';
    final _uri = Uri.parse('$baseURL$_path');
    final _request = _i1.DynamiteRequest('post', _uri);
    _request.headers['Content-Type'] = 'application/octet-stream';
    if (string != null) {
      _request.bodyBytes = utf8.encode(string);
    }
    return _request;
  }

  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * default
  ///
  /// See:
  ///  * [$$post_Request] for the request send by this method.
  ///  * [$$post_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<void, void>> $post({String? string}) async {
    final _request = $$post_Request(
      string: string,
    );
    final _response = await send(_request);

    final serializer = $$post_Serializer();
    final _rawResponse = await _i1.ResponseConverter<void, void>(serializer).convert(_response);
    return _i1.DynamiteResponse.fromRawResponse(_rawResponse);
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
      ..add(_i3.DynamiteDoubleSerializer())
      ..addPlugin(_i4.StandardJsonPlugin())
      ..addPlugin(const _i3.HeaderPlugin())
      ..addPlugin(const _i3.ContentStringPlugin()))
    .build();
// coverage:ignore-end
