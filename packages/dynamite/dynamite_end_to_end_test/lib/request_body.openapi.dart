// ignore_for_file: camel_case_types, discarded_futures
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: public_member_api_docs, unreachable_switch_case
// ignore_for_file: unused_element

import 'dart:convert';
import 'dart:typed_data';

import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:dynamite_runtime/built_value.dart';
import 'package:dynamite_runtime/http_client.dart';
import 'package:meta/meta.dart';
import 'package:universal_io/io.dart';

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
  /// Status codes:
  ///   * default
  ///
  /// See:
  ///  * [$getRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<void, void>> $get({Uint8List? uint8List}) async {
    final rawResponse = $getRaw(
      uint8List: uint8List,
    );

    return rawResponse.future;
  }

  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * default
  ///
  /// See:
  ///  * [$get] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<void, void> $getRaw({Uint8List? uint8List}) {
    final _headers = <String, String>{};
    Uint8List? _body;

    _headers['Content-Type'] = 'application/octet-stream';
    if (uint8List != null) {
      _body = uint8List;
    }
    const _path = '/';
    return DynamiteRawResponse<void, void>(
      response: executeRequest(
        'get',
        _path,
        _headers,
        _body,
        null,
      ),
      bodyType: null,
      headersType: null,
      serializers: jsonSerializers,
    );
  }

  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * default
  ///
  /// See:
  ///  * [postRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<void, void>> post({String? string}) async {
    final rawResponse = postRaw(
      string: string,
    );

    return rawResponse.future;
  }

  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * default
  ///
  /// See:
  ///  * [post] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<void, void> postRaw({String? string}) {
    final _headers = <String, String>{};
    Uint8List? _body;

    _headers['Content-Type'] = 'application/octet-stream';
    if (string != null) {
      _body = utf8.encode(string);
    }
    const _path = '/';
    return DynamiteRawResponse<void, void>(
      response: executeRequest(
        'post',
        _path,
        _headers,
        _body,
        null,
      ),
      bodyType: null,
      headersType: null,
      serializers: jsonSerializers,
    );
  }
}

// coverage:ignore-start
@visibleForTesting
final Serializers serializers = Serializers().toBuilder().build();
@visibleForTesting
final Serializers jsonSerializers = (serializers.toBuilder()
      ..add(DynamiteDoubleSerializer())
      ..addPlugin(StandardJsonPlugin())
      ..addPlugin(const HeaderPlugin())
      ..addPlugin(const ContentStringPlugin()))
    .build();
// coverage:ignore-end
