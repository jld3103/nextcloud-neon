// ignore_for_file: camel_case_types
// ignore_for_file: discarded_futures
// ignore_for_file: public_member_api_docs
// ignore_for_file: unreachable_switch_case
import 'dart:typed_data';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:collection/collection.dart';
import 'package:dynamite_runtime/built_value.dart';
import 'package:dynamite_runtime/http_client.dart';
import 'package:meta/meta.dart';
import 'package:universal_io/io.dart';

part 'settings.openapi.g.dart';

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

  LogSettingsClient get logSettings => LogSettingsClient(this);
}

class LogSettingsClient {
  LogSettingsClient(this._rootClient);

  final Client _rootClient;

  /// download logfile.
  ///
  /// This endpoint requires admin access.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200: Logfile returned
  ///
  /// See:
  ///  * [downloadRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<Uint8List, LogSettingsLogSettingsDownloadHeaders>> download() async {
    final rawResponse = downloadRaw();

    return rawResponse.future;
  }

  /// download logfile.
  ///
  /// This endpoint requires admin access.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200: Logfile returned
  ///
  /// See:
  ///  * [download] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<Uint8List, LogSettingsLogSettingsDownloadHeaders> downloadRaw() {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/octet-stream',
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
    const path = '/index.php/settings/admin/log/download';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<Uint8List, LogSettingsLogSettingsDownloadHeaders>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(Uint8List),
      headersType: const FullType(LogSettingsLogSettingsDownloadHeaders),
      serializers: _jsonSerializers,
    );
  }
}

@BuiltValue(instantiable: false)
abstract interface class LogSettingsLogSettingsDownloadHeadersInterface {
  @BuiltValueField(wireName: 'content-disposition')
  String? get contentDisposition;
}

abstract class LogSettingsLogSettingsDownloadHeaders
    implements
        LogSettingsLogSettingsDownloadHeadersInterface,
        Built<LogSettingsLogSettingsDownloadHeaders, LogSettingsLogSettingsDownloadHeadersBuilder> {
  factory LogSettingsLogSettingsDownloadHeaders([
    final void Function(LogSettingsLogSettingsDownloadHeadersBuilder)? b,
  ]) = _$LogSettingsLogSettingsDownloadHeaders;

  // coverage:ignore-start
  const LogSettingsLogSettingsDownloadHeaders._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory LogSettingsLogSettingsDownloadHeaders.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  @BuiltValueSerializer(custom: true)
  static Serializer<LogSettingsLogSettingsDownloadHeaders> get serializer =>
      _$LogSettingsLogSettingsDownloadHeadersSerializer();
}

class _$LogSettingsLogSettingsDownloadHeadersSerializer
    implements StructuredSerializer<LogSettingsLogSettingsDownloadHeaders> {
  @override
  final Iterable<Type> types = const [LogSettingsLogSettingsDownloadHeaders, _$LogSettingsLogSettingsDownloadHeaders];

  @override
  final String wireName = 'LogSettingsLogSettingsDownloadHeaders';

  @override
  Iterable<Object?> serialize(
    final Serializers serializers,
    final LogSettingsLogSettingsDownloadHeaders object, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    throw UnimplementedError();
  }

  @override
  LogSettingsLogSettingsDownloadHeaders deserialize(
    final Serializers serializers,
    final Iterable<Object?> serialized, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    final result = LogSettingsLogSettingsDownloadHeadersBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final value = iterator.current! as String;
      switch (key) {
        case 'content-disposition':
          result.contentDisposition = value;
      }
    }

    return result.build();
  }
}

// coverage:ignore-start
final Serializers _serializers = (Serializers().toBuilder()
      ..addBuilderFactory(
        const FullType(LogSettingsLogSettingsDownloadHeaders),
        LogSettingsLogSettingsDownloadHeaders.new,
      )
      ..add(LogSettingsLogSettingsDownloadHeaders.serializer))
    .build();

final Serializers _jsonSerializers = (_serializers.toBuilder()
      ..add(DynamiteDoubleSerializer())
      ..addPlugin(StandardJsonPlugin())
      ..addPlugin(const ContentStringPlugin()))
    .build();
// coverage:ignore-end
