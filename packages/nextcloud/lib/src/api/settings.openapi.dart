// Use of this source code is governed by a agpl license. It can be obtained at `https://spdx.org/licenses/AGPL-3.0-only.html`.

// OpenAPI client generated by Dynamite. Do not manually edit this file.

// ignore_for_file: camel_case_extensions, camel_case_types, discarded_futures
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: non_constant_identifier_names, public_member_api_docs
// ignore_for_file: unreachable_switch_case

/// settings Version: 0.0.1.
///
/// Nextcloud settings.
///
/// Use of this source code is governed by a agpl license.
/// It can be obtained at `https://spdx.org/licenses/AGPL-3.0-only.html`.
library; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:typed_data';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart' as _i5;
import 'package:collection/collection.dart';
import 'package:dynamite_runtime/built_value.dart' as _i4;
import 'package:dynamite_runtime/http_client.dart' as _i1;
import 'package:http/http.dart' as _i3;
import 'package:meta/meta.dart' as _i2;

part 'settings.openapi.g.dart';

class $Client extends _i1.DynamiteClient {
  /// Creates a new `DynamiteClient` for untagged requests.
  $Client(
    super.baseURL, {
    super.baseHeaders,
    super.httpClient,
    super.cookieJar,
    super.authentications,
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

  late final $LogSettingsClient logSettings = $LogSettingsClient(this);
}

class $LogSettingsClient {
  /// Creates a new `DynamiteClient` for log_settings requests.
  $LogSettingsClient(this._rootClient);

  final $Client _rootClient;

  /// Builds a serializer to parse the response of [$download_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<Uint8List, LogSettingsLogSettingsDownloadHeaders> $download_Serializer() =>
      _i1.DynamiteSerializer(
        bodyType: const FullType(Uint8List),
        headersType: const FullType(LogSettingsLogSettingsDownloadHeaders),
        serializers: _$jsonSerializers,
        validStatuses: const {200},
      );

  /// download logfile.
  ///
  /// This endpoint requires admin access.
  ///
  /// Returns a `DynamiteRequest` backing the [download] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200: Logfile returned
  ///
  /// See:
  ///  * [download] for a method executing this request and parsing the response.
  ///  * [$download_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i3.Request $download_Request() {
    const _path = '/index.php/settings/admin/log/download';
    final _uri = Uri.parse('${_rootClient.baseURL}$_path');
    final _request = _i3.Request('get', _uri);
    _request.headers['Accept'] = 'application/octet-stream';
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
    return _request;
  }

  /// download logfile.
  ///
  /// This endpoint requires admin access.
  ///
  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200: Logfile returned
  ///
  /// See:
  ///  * [$download_Request] for the request send by this method.
  ///  * [$download_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<Uint8List, LogSettingsLogSettingsDownloadHeaders>> download() async {
    final _request = $download_Request();
    final _response = await _rootClient.send(_request);

    final _serializer = $download_Serializer();
    final _rawResponse =
        await _i1.ResponseConverter<Uint8List, LogSettingsLogSettingsDownloadHeaders>(_serializer).convert(_response);
    return _i1.DynamiteResponse.fromRawResponse(_rawResponse);
  }
}

@BuiltValue(instantiable: false)
abstract interface class $LogSettingsLogSettingsDownloadHeadersInterface {
  @BuiltValueField(wireName: 'content-disposition')
  String? get contentDisposition;
}

abstract class LogSettingsLogSettingsDownloadHeaders
    implements
        $LogSettingsLogSettingsDownloadHeadersInterface,
        Built<LogSettingsLogSettingsDownloadHeaders, LogSettingsLogSettingsDownloadHeadersBuilder> {
  /// Creates a new LogSettingsLogSettingsDownloadHeaders object using the builder pattern.
  factory LogSettingsLogSettingsDownloadHeaders([void Function(LogSettingsLogSettingsDownloadHeadersBuilder)? b]) =
      _$LogSettingsLogSettingsDownloadHeaders;

  // coverage:ignore-start
  const LogSettingsLogSettingsDownloadHeaders._();
  // coverage:ignore-end

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  // coverage:ignore-start
  factory LogSettingsLogSettingsDownloadHeaders.fromJson(Map<String, dynamic> json) =>
      _$jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end

  /// Serializer for LogSettingsLogSettingsDownloadHeaders.
  static Serializer<LogSettingsLogSettingsDownloadHeaders> get serializer =>
      _$logSettingsLogSettingsDownloadHeadersSerializer;
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
        const FullType(LogSettingsLogSettingsDownloadHeaders),
        LogSettingsLogSettingsDownloadHeadersBuilder.new,
      )
      ..add(LogSettingsLogSettingsDownloadHeaders.serializer))
    .build();

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
