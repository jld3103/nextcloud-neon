// Use of this source code is governed by a agpl license. It can be obtained at `https://spdx.org/licenses/AGPL-3.0.html`.

// OpenAPI client generated by Dynamite. Do not manually edit this file.

// ignore_for_file: camel_case_extensions, camel_case_types, discarded_futures
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: non_constant_identifier_names, public_member_api_docs
// ignore_for_file: unreachable_switch_case

/// notes Version: 4.8.0.
///
/// Distraction-free notes and writing.
///
/// Use of this source code is governed by a agpl license.
/// It can be obtained at `https://spdx.org/licenses/AGPL-3.0.html`.
@_i2.experimental
library; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart' as _i6;
import 'package:collection/collection.dart';
import 'package:dynamite_runtime/built_value.dart' as _i5;
import 'package:dynamite_runtime/http_client.dart' as _i1;
import 'package:dynamite_runtime/utils.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:uri/uri.dart' as _i3;

part 'notes.openapi.g.dart';

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

  /// Builds a serializer to parse the response of [$getNotes_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<BuiltList<Note>, void> $getNotes_Serializer() => _i1.DynamiteSerializer<BuiltList<Note>, void>(
        bodyType: const FullType(BuiltList, [FullType(Note)]),
        headersType: null,
        serializers: _$jsonSerializers,
      );

  /// Returns a `DynamiteRequest` backing the [getNotes] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [category]
  ///   * [exclude] Defaults to `''`.
  ///   * [pruneBefore] Defaults to `0`.
  ///   * [chunkSize] Defaults to `0`.
  ///   * [chunkCursor]
  ///   * [ifNoneMatch]
  ///
  /// Status codes:
  ///   * 200
  ///
  /// See:
  ///  * [getNotes] for a method executing this request and parsing the response.
  ///  * [$getNotes_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i1.DynamiteRequest $getNotes_Request({
    String? category,
    String? exclude,
    int? pruneBefore,
    int? chunkSize,
    String? chunkCursor,
    String? ifNoneMatch,
  }) {
    final _parameters = <String, Object?>{};
    final $category = _$jsonSerializers.serialize(category, specifiedType: const FullType(String));
    _parameters['category'] = $category;

    var $exclude = _$jsonSerializers.serialize(exclude, specifiedType: const FullType(String));
    $exclude ??= '';
    _parameters['exclude'] = $exclude;

    var $pruneBefore = _$jsonSerializers.serialize(pruneBefore, specifiedType: const FullType(int));
    $pruneBefore ??= 0;
    _parameters['pruneBefore'] = $pruneBefore;

    var $chunkSize = _$jsonSerializers.serialize(chunkSize, specifiedType: const FullType(int));
    $chunkSize ??= 0;
    _parameters['chunkSize'] = $chunkSize;

    final $chunkCursor = _$jsonSerializers.serialize(chunkCursor, specifiedType: const FullType(String));
    _parameters['chunkCursor'] = $chunkCursor;

    final _path =
        _i3.UriTemplate('/index.php/apps/notes/api/v1/notes{?category*,exclude*,pruneBefore*,chunkSize*,chunkCursor*}')
            .expand(_parameters);
    final _uri = Uri.parse('$baseURL$_path');
    final _request = _i1.DynamiteRequest('get', _uri)..validStatuses = const {200};
    _request.headers['Accept'] = 'application/json';
// coverage:ignore-start
    final authentication = authentications?.firstWhereOrNull(
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
    final $ifNoneMatch = _$jsonSerializers.serialize(ifNoneMatch, specifiedType: const FullType(String));
    if ($ifNoneMatch != null) {
      _request.headers['If-None-Match'] = const _i4.HeaderEncoder().convert($ifNoneMatch);
    }

    return _request;
  }

  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [category]
  ///   * [exclude] Defaults to `''`.
  ///   * [pruneBefore] Defaults to `0`.
  ///   * [chunkSize] Defaults to `0`.
  ///   * [chunkCursor]
  ///   * [ifNoneMatch]
  ///
  /// Status codes:
  ///   * 200
  ///
  /// See:
  ///  * [$getNotes_Request] for the request send by this method.
  ///  * [$getNotes_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<BuiltList<Note>, void>> getNotes({
    String? category,
    String? exclude,
    int? pruneBefore,
    int? chunkSize,
    String? chunkCursor,
    String? ifNoneMatch,
  }) async {
    final _request = $getNotes_Request(
      category: category,
      exclude: exclude,
      pruneBefore: pruneBefore,
      chunkSize: chunkSize,
      chunkCursor: chunkCursor,
      ifNoneMatch: ifNoneMatch,
    );
    final _response = await send(_request);

    final serializer = $getNotes_Serializer();
    final _rawResponse = await _i1.ResponseConverter<BuiltList<Note>, void>(serializer).convert(_response);
    return _i1.DynamiteResponse.fromRawResponse(_rawResponse);
  }

  /// Builds a serializer to parse the response of [$createNote_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<Note, void> $createNote_Serializer() => _i1.DynamiteSerializer<Note, void>(
        bodyType: const FullType(Note),
        headersType: null,
        serializers: _$jsonSerializers,
      );

  /// Returns a `DynamiteRequest` backing the [createNote] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [category] Defaults to `''`.
  ///   * [title] Defaults to `''`.
  ///   * [content] Defaults to `''`.
  ///   * [modified] Defaults to `0`.
  ///   * [favorite] Defaults to `0`.
  ///
  /// Status codes:
  ///   * 200
  ///
  /// See:
  ///  * [createNote] for a method executing this request and parsing the response.
  ///  * [$createNote_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i1.DynamiteRequest $createNote_Request({
    String? category,
    String? title,
    String? content,
    int? modified,
    int? favorite,
  }) {
    final _parameters = <String, Object?>{};
    var $category = _$jsonSerializers.serialize(category, specifiedType: const FullType(String));
    $category ??= '';
    _parameters['category'] = $category;

    var $title = _$jsonSerializers.serialize(title, specifiedType: const FullType(String));
    $title ??= '';
    _parameters['title'] = $title;

    var $content = _$jsonSerializers.serialize(content, specifiedType: const FullType(String));
    $content ??= '';
    _parameters['content'] = $content;

    var $modified = _$jsonSerializers.serialize(modified, specifiedType: const FullType(int));
    $modified ??= 0;
    _parameters['modified'] = $modified;

    var $favorite = _$jsonSerializers.serialize(favorite, specifiedType: const FullType(int));
    $favorite ??= 0;
    _parameters['favorite'] = $favorite;

    final _path = _i3.UriTemplate('/index.php/apps/notes/api/v1/notes{?category*,title*,content*,modified*,favorite*}')
        .expand(_parameters);
    final _uri = Uri.parse('$baseURL$_path');
    final _request = _i1.DynamiteRequest('post', _uri)..validStatuses = const {200};
    _request.headers['Accept'] = 'application/json';
// coverage:ignore-start
    final authentication = authentications?.firstWhereOrNull(
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
  /// Parameters:
  ///   * [category] Defaults to `''`.
  ///   * [title] Defaults to `''`.
  ///   * [content] Defaults to `''`.
  ///   * [modified] Defaults to `0`.
  ///   * [favorite] Defaults to `0`.
  ///
  /// Status codes:
  ///   * 200
  ///
  /// See:
  ///  * [$createNote_Request] for the request send by this method.
  ///  * [$createNote_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<Note, void>> createNote({
    String? category,
    String? title,
    String? content,
    int? modified,
    int? favorite,
  }) async {
    final _request = $createNote_Request(
      category: category,
      title: title,
      content: content,
      modified: modified,
      favorite: favorite,
    );
    final _response = await send(_request);

    final serializer = $createNote_Serializer();
    final _rawResponse = await _i1.ResponseConverter<Note, void>(serializer).convert(_response);
    return _i1.DynamiteResponse.fromRawResponse(_rawResponse);
  }

  /// Builds a serializer to parse the response of [$getNote_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<Note, void> $getNote_Serializer() => _i1.DynamiteSerializer<Note, void>(
        bodyType: const FullType(Note),
        headersType: null,
        serializers: _$jsonSerializers,
      );

  /// Returns a `DynamiteRequest` backing the [getNote] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [exclude] Defaults to `''`.
  ///   * [ifNoneMatch]
  ///
  /// Status codes:
  ///   * 200
  ///
  /// See:
  ///  * [getNote] for a method executing this request and parsing the response.
  ///  * [$getNote_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i1.DynamiteRequest $getNote_Request({
    required int id,
    String? exclude,
    String? ifNoneMatch,
  }) {
    final _parameters = <String, Object?>{};
    final $id = _$jsonSerializers.serialize(id, specifiedType: const FullType(int));
    _parameters['id'] = $id;

    var $exclude = _$jsonSerializers.serialize(exclude, specifiedType: const FullType(String));
    $exclude ??= '';
    _parameters['exclude'] = $exclude;

    final _path = _i3.UriTemplate('/index.php/apps/notes/api/v1/notes/{id}{?exclude*}').expand(_parameters);
    final _uri = Uri.parse('$baseURL$_path');
    final _request = _i1.DynamiteRequest('get', _uri)..validStatuses = const {200};
    _request.headers['Accept'] = 'application/json';
// coverage:ignore-start
    final authentication = authentications?.firstWhereOrNull(
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
    final $ifNoneMatch = _$jsonSerializers.serialize(ifNoneMatch, specifiedType: const FullType(String));
    if ($ifNoneMatch != null) {
      _request.headers['If-None-Match'] = const _i4.HeaderEncoder().convert($ifNoneMatch);
    }

    return _request;
  }

  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [exclude] Defaults to `''`.
  ///   * [ifNoneMatch]
  ///
  /// Status codes:
  ///   * 200
  ///
  /// See:
  ///  * [$getNote_Request] for the request send by this method.
  ///  * [$getNote_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<Note, void>> getNote({
    required int id,
    String? exclude,
    String? ifNoneMatch,
  }) async {
    final _request = $getNote_Request(
      id: id,
      exclude: exclude,
      ifNoneMatch: ifNoneMatch,
    );
    final _response = await send(_request);

    final serializer = $getNote_Serializer();
    final _rawResponse = await _i1.ResponseConverter<Note, void>(serializer).convert(_response);
    return _i1.DynamiteResponse.fromRawResponse(_rawResponse);
  }

  /// Builds a serializer to parse the response of [$updateNote_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<Note, void> $updateNote_Serializer() => _i1.DynamiteSerializer<Note, void>(
        bodyType: const FullType(Note),
        headersType: null,
        serializers: _$jsonSerializers,
      );

  /// Returns a `DynamiteRequest` backing the [updateNote] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [content]
  ///   * [modified]
  ///   * [title]
  ///   * [category]
  ///   * [favorite]
  ///   * [ifMatch]
  ///
  /// Status codes:
  ///   * 200
  ///
  /// See:
  ///  * [updateNote] for a method executing this request and parsing the response.
  ///  * [$updateNote_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i1.DynamiteRequest $updateNote_Request({
    required int id,
    String? content,
    int? modified,
    String? title,
    String? category,
    int? favorite,
    String? ifMatch,
  }) {
    final _parameters = <String, Object?>{};
    final $id = _$jsonSerializers.serialize(id, specifiedType: const FullType(int));
    _parameters['id'] = $id;

    final $content = _$jsonSerializers.serialize(content, specifiedType: const FullType(String));
    _parameters['content'] = $content;

    final $modified = _$jsonSerializers.serialize(modified, specifiedType: const FullType(int));
    _parameters['modified'] = $modified;

    final $title = _$jsonSerializers.serialize(title, specifiedType: const FullType(String));
    _parameters['title'] = $title;

    final $category = _$jsonSerializers.serialize(category, specifiedType: const FullType(String));
    _parameters['category'] = $category;

    final $favorite = _$jsonSerializers.serialize(favorite, specifiedType: const FullType(int));
    _parameters['favorite'] = $favorite;

    final _path =
        _i3.UriTemplate('/index.php/apps/notes/api/v1/notes/{id}{?content*,modified*,title*,category*,favorite*}')
            .expand(_parameters);
    final _uri = Uri.parse('$baseURL$_path');
    final _request = _i1.DynamiteRequest('put', _uri)..validStatuses = const {200};
    _request.headers['Accept'] = 'application/json';
// coverage:ignore-start
    final authentication = authentications?.firstWhereOrNull(
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
    final $ifMatch = _$jsonSerializers.serialize(ifMatch, specifiedType: const FullType(String));
    if ($ifMatch != null) {
      _request.headers['If-Match'] = const _i4.HeaderEncoder().convert($ifMatch);
    }

    return _request;
  }

  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [content]
  ///   * [modified]
  ///   * [title]
  ///   * [category]
  ///   * [favorite]
  ///   * [ifMatch]
  ///
  /// Status codes:
  ///   * 200
  ///
  /// See:
  ///  * [$updateNote_Request] for the request send by this method.
  ///  * [$updateNote_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<Note, void>> updateNote({
    required int id,
    String? content,
    int? modified,
    String? title,
    String? category,
    int? favorite,
    String? ifMatch,
  }) async {
    final _request = $updateNote_Request(
      id: id,
      content: content,
      modified: modified,
      title: title,
      category: category,
      favorite: favorite,
      ifMatch: ifMatch,
    );
    final _response = await send(_request);

    final serializer = $updateNote_Serializer();
    final _rawResponse = await _i1.ResponseConverter<Note, void>(serializer).convert(_response);
    return _i1.DynamiteResponse.fromRawResponse(_rawResponse);
  }

  /// Builds a serializer to parse the response of [$deleteNote_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<String, void> $deleteNote_Serializer() => _i1.DynamiteSerializer<String, void>(
        bodyType: const FullType(String),
        headersType: null,
        serializers: _$jsonSerializers,
      );

  /// Returns a `DynamiteRequest` backing the [deleteNote] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200
  ///
  /// See:
  ///  * [deleteNote] for a method executing this request and parsing the response.
  ///  * [$deleteNote_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i1.DynamiteRequest $deleteNote_Request({required int id}) {
    final _parameters = <String, Object?>{};
    final $id = _$jsonSerializers.serialize(id, specifiedType: const FullType(int));
    _parameters['id'] = $id;

    final _path = _i3.UriTemplate('/index.php/apps/notes/api/v1/notes/{id}').expand(_parameters);
    final _uri = Uri.parse('$baseURL$_path');
    final _request = _i1.DynamiteRequest('delete', _uri)..validStatuses = const {200};
    _request.headers['Accept'] = 'application/json';
// coverage:ignore-start
    final authentication = authentications?.firstWhereOrNull(
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
  ///  * [$deleteNote_Request] for the request send by this method.
  ///  * [$deleteNote_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<String, void>> deleteNote({required int id}) async {
    final _request = $deleteNote_Request(
      id: id,
    );
    final _response = await send(_request);

    final serializer = $deleteNote_Serializer();
    final _rawResponse = await _i1.ResponseConverter<String, void>(serializer).convert(_response);
    return _i1.DynamiteResponse.fromRawResponse(_rawResponse);
  }

  /// Builds a serializer to parse the response of [$getSettings_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<Settings, void> $getSettings_Serializer() => _i1.DynamiteSerializer<Settings, void>(
        bodyType: const FullType(Settings),
        headersType: null,
        serializers: _$jsonSerializers,
      );

  /// Returns a `DynamiteRequest` backing the [getSettings] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200
  ///
  /// See:
  ///  * [getSettings] for a method executing this request and parsing the response.
  ///  * [$getSettings_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i1.DynamiteRequest $getSettings_Request() {
    const _path = '/index.php/apps/notes/api/v1/settings';
    final _uri = Uri.parse('$baseURL$_path');
    final _request = _i1.DynamiteRequest('get', _uri)..validStatuses = const {200};
    _request.headers['Accept'] = 'application/json';
// coverage:ignore-start
    final authentication = authentications?.firstWhereOrNull(
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
  ///  * [$getSettings_Request] for the request send by this method.
  ///  * [$getSettings_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<Settings, void>> getSettings() async {
    final _request = $getSettings_Request();
    final _response = await send(_request);

    final serializer = $getSettings_Serializer();
    final _rawResponse = await _i1.ResponseConverter<Settings, void>(serializer).convert(_response);
    return _i1.DynamiteResponse.fromRawResponse(_rawResponse);
  }

  /// Builds a serializer to parse the response of [$updateSettings_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<Settings, void> $updateSettings_Serializer() => _i1.DynamiteSerializer<Settings, void>(
        bodyType: const FullType(Settings),
        headersType: null,
        serializers: _$jsonSerializers,
      );

  /// Returns a `DynamiteRequest` backing the [updateSettings] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200
  ///
  /// See:
  ///  * [updateSettings] for a method executing this request and parsing the response.
  ///  * [$updateSettings_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i1.DynamiteRequest $updateSettings_Request({required Settings settings}) {
    const _path = '/index.php/apps/notes/api/v1/settings';
    final _uri = Uri.parse('$baseURL$_path');
    final _request = _i1.DynamiteRequest('put', _uri)..validStatuses = const {200};
    _request.headers['Accept'] = 'application/json';
// coverage:ignore-start
    final authentication = authentications?.firstWhereOrNull(
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
    _request.headers['Content-Type'] = 'application/json';
    _request.body = json.encode(_$jsonSerializers.serialize(settings, specifiedType: const FullType(Settings)));
    return _request;
  }

  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200
  ///
  /// See:
  ///  * [$updateSettings_Request] for the request send by this method.
  ///  * [$updateSettings_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<Settings, void>> updateSettings({required Settings settings}) async {
    final _request = $updateSettings_Request(
      settings: settings,
    );
    final _response = await send(_request);

    final serializer = $updateSettings_Serializer();
    final _rawResponse = await _i1.ResponseConverter<Settings, void>(serializer).convert(_response);
    return _i1.DynamiteResponse.fromRawResponse(_rawResponse);
  }
}

@BuiltValue(instantiable: false)
abstract interface class $NoteInterface {
  int get id;
  String get etag;
  bool get readonly;
  String get content;
  String get title;
  String get category;
  bool get favorite;
  int get modified;
  bool get error;
  String get errorType;
}

abstract class Note implements $NoteInterface, Built<Note, NoteBuilder> {
  /// Creates a new Note object using the builder pattern.
  factory Note([void Function(NoteBuilder)? b]) = _$Note;

  // coverage:ignore-start
  const Note._();
  // coverage:ignore-end

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  // coverage:ignore-start
  factory Note.fromJson(Map<String, dynamic> json) => _$jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end

  /// Serializer for Note.
  static Serializer<Note> get serializer => _$noteSerializer;
}

class Settings_NoteMode extends EnumClass {
  const Settings_NoteMode._(super.name);

  /// `edit`
  static const Settings_NoteMode edit = _$settingsNoteModeEdit;

  /// `preview`
  static const Settings_NoteMode preview = _$settingsNoteModePreview;

  /// `rich`
  static const Settings_NoteMode rich = _$settingsNoteModeRich;

  /// Returns a set with all values this enum contains.
  // coverage:ignore-start
  static BuiltSet<Settings_NoteMode> get values => _$settingsNoteModeValues;
  // coverage:ignore-end

  /// Returns the enum value associated to the [name].
  static Settings_NoteMode valueOf(String name) => _$valueOfSettings_NoteMode(name);

  /// Returns the serialized value of this enum value.
  String get value => _$jsonSerializers.serializeWith(serializer, this)! as String;

  /// Serializer for Settings_NoteMode.
  @BuiltValueSerializer(custom: true)
  static Serializer<Settings_NoteMode> get serializer => const _$Settings_NoteModeSerializer();
}

class _$Settings_NoteModeSerializer implements PrimitiveSerializer<Settings_NoteMode> {
  const _$Settings_NoteModeSerializer();

  static const Map<Settings_NoteMode, Object> _toWire = <Settings_NoteMode, Object>{
    Settings_NoteMode.edit: 'edit',
    Settings_NoteMode.preview: 'preview',
    Settings_NoteMode.rich: 'rich',
  };

  static const Map<Object, Settings_NoteMode> _fromWire = <Object, Settings_NoteMode>{
    'edit': Settings_NoteMode.edit,
    'preview': Settings_NoteMode.preview,
    'rich': Settings_NoteMode.rich,
  };

  @override
  Iterable<Type> get types => const [Settings_NoteMode];

  @override
  String get wireName => 'Settings_NoteMode';

  @override
  Object serialize(
    Serializers serializers,
    Settings_NoteMode object, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      _toWire[object]!;

  @override
  Settings_NoteMode deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      _fromWire[serialized]!;
}

@BuiltValue(instantiable: false)
abstract interface class $SettingsInterface {
  String get notesPath;
  String get fileSuffix;
  Settings_NoteMode get noteMode;
}

abstract class Settings implements $SettingsInterface, Built<Settings, SettingsBuilder> {
  /// Creates a new Settings object using the builder pattern.
  factory Settings([void Function(SettingsBuilder)? b]) = _$Settings;

  // coverage:ignore-start
  const Settings._();
  // coverage:ignore-end

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  // coverage:ignore-start
  factory Settings.fromJson(Map<String, dynamic> json) => _$jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end

  /// Serializer for Settings.
  static Serializer<Settings> get serializer => _$settingsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class $Capabilities_NotesInterface {
  @BuiltValueField(wireName: 'api_version')
  BuiltList<String>? get apiVersion;
  String? get version;
}

abstract class Capabilities_Notes
    implements $Capabilities_NotesInterface, Built<Capabilities_Notes, Capabilities_NotesBuilder> {
  /// Creates a new Capabilities_Notes object using the builder pattern.
  factory Capabilities_Notes([void Function(Capabilities_NotesBuilder)? b]) = _$Capabilities_Notes;

  // coverage:ignore-start
  const Capabilities_Notes._();
  // coverage:ignore-end

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  // coverage:ignore-start
  factory Capabilities_Notes.fromJson(Map<String, dynamic> json) =>
      _$jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end

  /// Serializer for Capabilities_Notes.
  static Serializer<Capabilities_Notes> get serializer => _$capabilitiesNotesSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class $CapabilitiesInterface {
  Capabilities_Notes get notes;
}

abstract class Capabilities implements $CapabilitiesInterface, Built<Capabilities, CapabilitiesBuilder> {
  /// Creates a new Capabilities object using the builder pattern.
  factory Capabilities([void Function(CapabilitiesBuilder)? b]) = _$Capabilities;

  // coverage:ignore-start
  const Capabilities._();
  // coverage:ignore-end

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  // coverage:ignore-start
  factory Capabilities.fromJson(Map<String, dynamic> json) => _$jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end

  /// Serializer for Capabilities.
  static Serializer<Capabilities> get serializer => _$capabilitiesSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class $OCSMetaInterface {
  String get status;
  int get statuscode;
  String? get message;
  String? get totalitems;
  String? get itemsperpage;
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
}

@BuiltValue(instantiable: false)
abstract interface class $EmptyOCS_OcsInterface {
  OCSMeta get meta;
  BuiltList<JsonObject> get data;
}

abstract class EmptyOCS_Ocs implements $EmptyOCS_OcsInterface, Built<EmptyOCS_Ocs, EmptyOCS_OcsBuilder> {
  /// Creates a new EmptyOCS_Ocs object using the builder pattern.
  factory EmptyOCS_Ocs([void Function(EmptyOCS_OcsBuilder)? b]) = _$EmptyOCS_Ocs;

  // coverage:ignore-start
  const EmptyOCS_Ocs._();
  // coverage:ignore-end

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  // coverage:ignore-start
  factory EmptyOCS_Ocs.fromJson(Map<String, dynamic> json) => _$jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end

  /// Serializer for EmptyOCS_Ocs.
  static Serializer<EmptyOCS_Ocs> get serializer => _$emptyOCSOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class $EmptyOCSInterface {
  EmptyOCS_Ocs get ocs;
}

abstract class EmptyOCS implements $EmptyOCSInterface, Built<EmptyOCS, EmptyOCSBuilder> {
  /// Creates a new EmptyOCS object using the builder pattern.
  factory EmptyOCS([void Function(EmptyOCSBuilder)? b]) = _$EmptyOCS;

  // coverage:ignore-start
  const EmptyOCS._();
  // coverage:ignore-end

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  // coverage:ignore-start
  factory EmptyOCS.fromJson(Map<String, dynamic> json) => _$jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end

  /// Serializer for EmptyOCS.
  static Serializer<EmptyOCS> get serializer => _$emptyOCSSerializer;
}

// coverage:ignore-start
/// Serializer for all values in this library.
///
/// Serializes values into the `built_value` wire format.
/// See: [$jsonSerializers] for serializing into json.
@_i2.visibleForTesting
final Serializers $serializers = _$serializers;
final Serializers _$serializers = (Serializers().toBuilder()
      ..addBuilderFactory(const FullType(Note), NoteBuilder.new)
      ..add(Note.serializer)
      ..addBuilderFactory(const FullType(BuiltList, [FullType(Note)]), ListBuilder<Note>.new)
      ..addBuilderFactory(const FullType(Settings), SettingsBuilder.new)
      ..add(Settings.serializer)
      ..add(Settings_NoteMode.serializer)
      ..addBuilderFactory(const FullType(Capabilities), CapabilitiesBuilder.new)
      ..add(Capabilities.serializer)
      ..addBuilderFactory(const FullType(Capabilities_Notes), Capabilities_NotesBuilder.new)
      ..add(Capabilities_Notes.serializer)
      ..addBuilderFactory(const FullType(BuiltList, [FullType(String)]), ListBuilder<String>.new)
      ..addBuilderFactory(const FullType(OCSMeta), OCSMetaBuilder.new)
      ..add(OCSMeta.serializer)
      ..addBuilderFactory(const FullType(EmptyOCS), EmptyOCSBuilder.new)
      ..add(EmptyOCS.serializer)
      ..addBuilderFactory(const FullType(EmptyOCS_Ocs), EmptyOCS_OcsBuilder.new)
      ..add(EmptyOCS_Ocs.serializer)
      ..addBuilderFactory(const FullType(BuiltList, [FullType(JsonObject)]), ListBuilder<JsonObject>.new))
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
