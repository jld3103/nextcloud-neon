// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:typed_data';

import 'package:dynamite_runtime/http_client.dart';
import 'package:http/http.dart' as http;
import 'package:nextcloud/src/api/webdav/webdav.dart';
import 'package:nextcloud/utils.dart';
import 'package:universal_io/io.dart' show File, FileStat;

/// The algorithms supported for the oc:checksum prop and OC-Checksum header.
const supportedChecksumAlgorithms = ['md5', 'sha1', 'sha256', 'sha3-256', 'adler32'];

/// The pattern of supported checksum algorithms.
///
/// It has to be `<algorithm>:<hash>` with `algorithm` being one of [supportedChecksumAlgorithms].
/// The checksum is case-insensitive.
final checksumPattern = RegExp(
  '^(${supportedChecksumAlgorithms.join('|')}):.+\$',
  caseSensitive: false,
);

/// WebDavClient class.
class WebDavClient extends DynamiteClient {
  /// Creates a new `WebDavClient`.
  ///
  /// The [httpClient] parameter specifies whether requests should attach a
  /// CSRF-Token to sent requests.
  /// Until Nextcloud 30 this is required to work around an authorization bug
  /// triggered, when cookies are also sent.
  WebDavClient(
    super.baseURL, {
    http.Client? httpClient,
    super.authentications,
    bool useCSRFClient = true,
  }) : super(
          httpClient: useCSRFClient
              ? WebDavCSRFClient(
                  baseURL,
                  httpClient: httpClient,
                )
              : httpClient,
        );

  /// Creates a new [WebDavClient] from another [client].
  WebDavClient.fromClient(DynamiteClient client)
      : this(
          client.baseURL,
          httpClient: client.httpClient,
          authentications: client.authentications,
        );

  Uri _constructUri([PathUri? path]) => constructUri(baseURL, path);

  /// Returns a request to query the WebDAV capabilities of the server.
  ///
  /// See:
  ///   * http://www.webdav.org/specs/rfc4918.html#HEADER_DAV for more information.
  ///   * [options] for a complete operation executing this request.
  http.Request options_Request() {
    final request = http.Request('OPTIONS', _constructUri());

    _addBaseHeaders(request);
    return request;
  }

  /// Queries the WebDAV capabilities of the server.
  ///
  /// See:
  ///   * http://www.webdav.org/specs/rfc4918.html#HEADER_DAV for more information.
  ///   * [options_Request] for the request sent by this method.
  Future<WebDavOptions> options() async {
    final request = options_Request();

    final streamedResponse = await httpClient.send(request);
    if (streamedResponse.statusCode != 200) {
      final response = await http.Response.fromStream(streamedResponse);
      throw DynamiteStatusCodeException(response);
    }
    return parseWebDavOptions(streamedResponse.headers);
  }

  /// Returns a request to create a collection at [path].
  ///
  /// The props in [set] will be added.
  ///
  /// See:
  ///   * http://www.webdav.org/specs/rfc2518.html#METHOD_MKCOL and http://www.webdav.org/specs/rfc5689.html for more information.
  ///   * [mkcol] for a complete operation executing this request.
  http.Request mkcol_Request(
    PathUri path, {
    WebDavProp? set,
  }) {
    final request = http.Request('MKCOL', _constructUri(path));
    if (set != null) {
      request.body = WebDavMkcol(
        set: WebDavSet(prop: set),
      ).toXmlElement(namespaces: namespaces).toXmlString();
    }

    _addBaseHeaders(request);
    return request;
  }

  /// Creates a collection at [path].
  ///
  /// The props in [set] will be added.
  ///
  /// See:
  ///  * http://www.webdav.org/specs/rfc2518.html#METHOD_MKCOL and http://www.webdav.org/specs/rfc5689.html for more information.
  ///  * [mkcol_Request] for the request sent by this method.
  Future<http.StreamedResponse> mkcol(
    PathUri path, {
    WebDavProp? set,
  }) async {
    final request = mkcol_Request(
      path,
      set: set,
    );

    final streamedResponse = await httpClient.send(request);
    if (streamedResponse.statusCode != 201) {
      final response = await http.Response.fromStream(streamedResponse);
      throw DynamiteStatusCodeException(response);
    }

    return streamedResponse;
  }

  /// Returns a request to delete the resource at [path].
  ///
  /// See:
  ///   * http://www.webdav.org/specs/rfc2518.html#METHOD_DELETE for more information.
  ///   * [delete] for a complete operation executing this request.
  http.Request delete_Request(PathUri path) {
    final request = http.Request('DELETE', _constructUri(path));

    _addBaseHeaders(request);
    return request;
  }

  /// Deletes the resource at [path].
  ///
  /// See:
  ///   * http://www.webdav.org/specs/rfc2518.html#METHOD_DELETE for more information.
  ///   * [delete_Request] for the request sent by this method.
  Future<http.StreamedResponse> delete(PathUri path) async {
    final request = delete_Request(path);

    final streamedResponse = await httpClient.send(request);
    if (streamedResponse.statusCode != 204) {
      final response = await http.Response.fromStream(streamedResponse);
      throw DynamiteStatusCodeException(response);
    }

    return streamedResponse;
  }

  /// Returns a request to put a new file at [path] with [localData] as content.
  ///
  /// [lastModified] sets the date when the file was last modified on the server.
  /// [created] sets the date when the file was created on the server.
  /// [checksum] has to follow [checksumPattern]. It will not be validated by the server.
  ///
  /// See:
  ///   * http://www.webdav.org/specs/rfc2518.html#METHOD_PUT for more information.
  ///   * [put] for a complete operation executing this request.
  http.Request put_Request(
    Uint8List localData,
    PathUri path, {
    DateTime? lastModified,
    DateTime? created,
    String? checksum,
  }) {
    final request = http.Request('PUT', _constructUri(path))..bodyBytes = localData;

    _addUploadHeaders(
      request,
      lastModified: lastModified,
      created: created,
      contentLength: localData.length,
      checksum: checksum,
    );
    _addBaseHeaders(request);
    return request;
  }

  /// Puts a new file at [path] with [localData] as content.
  ///
  /// [lastModified] sets the date when the file was last modified on the server.
  /// [created] sets the date when the file was created on the server.
  /// [checksum] has to follow [checksumPattern]. It will not be validated by the server.
  ///
  /// See:
  ///   * http://www.webdav.org/specs/rfc2518.html#METHOD_PUT for more information.
  ///   * [put_Request] for the request sent by this method.
  Future<http.StreamedResponse> put(
    Uint8List localData,
    PathUri path, {
    DateTime? lastModified,
    DateTime? created,
    String? checksum,
  }) async {
    final request = put_Request(
      localData,
      path,
      lastModified: lastModified,
      created: created,
      checksum: checksum,
    );

    final streamedResponse = await httpClient.send(request);
    if (streamedResponse.statusCode != 201 && streamedResponse.statusCode != 204) {
      final response = await http.Response.fromStream(streamedResponse);
      throw DynamiteStatusCodeException(response);
    }

    return streamedResponse;
  }

  /// Returns a request to put a new file at [path] with [localData] as content.
  ///
  /// [contentLength] sets the length of the [localData] that is uploaded.
  /// [lastModified] sets the date when the file was last modified on the server.
  /// [created] sets the date when the file was created on the server.
  /// [checksum] has to follow [checksumPattern]. It will not be validated by the server.
  /// [onProgress] can be used to watch the upload progress. Possible values range from `0.0` to `1.0`.
  ///
  /// See:
  ///   * http://www.webdav.org/specs/rfc2518.html#METHOD_PUT for more information.
  ///   * [putStream] for a complete operation executing this request.
  http.StreamedRequest putStream_Request(
    Stream<List<int>> localData,
    PathUri path, {
    required int contentLength,
    DateTime? lastModified,
    DateTime? created,
    String? checksum,
    void Function(double progress)? onProgress,
  }) {
    final request = http.StreamedRequest('PUT', _constructUri(path));

    _addBaseHeaders(request);
    _addUploadHeaders(
      request,
      lastModified: lastModified,
      created: created,
      contentLength: contentLength,
      checksum: checksum,
    );

    if (onProgress != null) {
      var uploaded = 0;

      unawaited(
        localData.map((chunk) {
          uploaded += chunk.length;
          onProgress.call(uploaded / contentLength);
          return chunk;
        }).pipe(request.sink),
      );
    } else {
      unawaited(
        localData.pipe(request.sink),
      );
    }

    return request;
  }

  /// Puts a new file at [path] with [localData] as content.
  ///
  /// [contentLength] sets the length of the [localData] that is uploaded.
  /// [lastModified] sets the date when the file was last modified on the server.
  /// [created] sets the date when the file was created on the server.
  /// [checksum] has to follow [checksumPattern]. It will not be validated by the server.
  /// [onProgress] can be used to watch the upload progress. Possible values range from `0.0` to `1.0`.
  ///
  /// See:
  ///   * http://www.webdav.org/specs/rfc2518.html#METHOD_PUT for more information.
  ///   * [putStream_Request] for the request sent by this method.
  Future<http.StreamedResponse> putStream(
    Stream<List<int>> localData,
    PathUri path, {
    required int contentLength,
    DateTime? lastModified,
    DateTime? created,
    String? checksum,
    void Function(double progress)? onProgress,
  }) async {
    final request = putStream_Request(
      localData,
      path,
      lastModified: lastModified,
      created: created,
      checksum: checksum,
      contentLength: contentLength,
      onProgress: onProgress,
    );

    final streamedResponse = await httpClient.send(request);
    if (streamedResponse.statusCode != 201 && streamedResponse.statusCode != 204) {
      final response = await http.Response.fromStream(streamedResponse);
      throw DynamiteStatusCodeException(response);
    }

    return streamedResponse;
  }

  /// Returns a request to put a new file at [path] with [file] as content.
  ///
  /// [lastModified] sets the date when the file was last modified on the server.
  /// [created] sets the date when the file was created on the server.
  /// [checksum] has to follow [checksumPattern]. It will not be validated by the server.
  /// [onProgress] can be used to watch the upload progress. Possible values range from `0.0` to `1.0`.
  ///
  /// See:
  ///   * http://www.webdav.org/specs/rfc2518.html#METHOD_PUT for more information.
  ///   * [putFile] for a complete operation executing this request.
  http.StreamedRequest putFile_Request(
    File file,
    FileStat fileStat,
    PathUri path, {
    DateTime? lastModified,
    DateTime? created,
    String? checksum,
    void Function(double progress)? onProgress,
  }) {
    // Authentication and content-type headers are already set by the putStream_Request.
    // No need to set them here.
    return putStream_Request(
      file.openRead(),
      path,
      lastModified: lastModified,
      created: created,
      checksum: checksum,
      contentLength: fileStat.size,
      onProgress: onProgress,
    );
  }

  /// Puts a new file at [path] with [file] as content.
  ///
  /// [lastModified] sets the date when the file was last modified on the server.
  /// [created] sets the date when the file was created on the server.
  /// [checksum] has to follow [checksumPattern]. It will not be validated by the server.
  /// [onProgress] can be used to watch the upload progress. Possible values range from `0.0` to `1.0`.
  ///
  /// See:
  ///   * http://www.webdav.org/specs/rfc2518.html#METHOD_PUT for more information.
  ///   * [putFile_Request] for the request sent by this method.
  Future<http.StreamedResponse> putFile(
    File file,
    FileStat fileStat,
    PathUri path, {
    DateTime? lastModified,
    DateTime? created,
    String? checksum,
    void Function(double progress)? onProgress,
  }) async {
    final request = putFile_Request(
      file,
      fileStat,
      path,
      lastModified: lastModified,
      created: created,
      checksum: checksum,
      onProgress: onProgress,
    );

    final streamedResponse = await httpClient.send(request);
    if (streamedResponse.statusCode != 201) {
      final response = await http.Response.fromStream(streamedResponse);
      throw DynamiteStatusCodeException(response);
    }

    return streamedResponse;
  }

  /// Returns a request to get the content of the file at [path].
  ///
  /// See:
  ///   * [get], [getStream] and [getFile] for complete operations executing this request.
  http.Request get_Request(PathUri path) {
    final request = http.Request('GET', _constructUri(path));

    _addBaseHeaders(request);
    return request;
  }

  /// Retrieves the content of the file at [path].
  ///
  /// See:
  ///   * [get_Request] for the request sent by this method.
  Future<Uint8List> get(PathUri path) async {
    final buffer = BytesBuilder(copy: false);

    final stream = await getStream(path);
    await stream.forEach(buffer.add);

    return buffer.toBytes();
  }

  /// Retrieves the content of the file at [path].
  ///
  /// [onProgress] can be used to watch the download progress. Possible values range from `0.0` to `1.0`.
  ///
  /// See:
  ///   * [get_Request] for the request sent by this method.
  Future<Stream<List<int>>> getStream(
    PathUri path, {
    void Function(double progress)? onProgress,
  }) async {
    final request = get_Request(path);
    final streamedResponse = await httpClient.send(request);
    if (streamedResponse.statusCode != 200) {
      final response = await http.Response.fromStream(streamedResponse);
      throw DynamiteStatusCodeException(response);
    }

    final controller = StreamController<List<int>>();
    final contentLength = streamedResponse.contentLength;
    var downloaded = 0;

    streamedResponse.stream.listen(
      (chunk) async {
        controller.add(chunk);
        downloaded += chunk.length;
        if (contentLength != null) {
          onProgress?.call(downloaded / contentLength);
        }
      },
      onDone: () {
        onProgress?.call(1);
        controller.close();
      },
    );

    return controller.stream;
  }

  /// Retrieves the content of the file at [path].
  ///
  /// [onProgress] can be used to watch the download progress. Possible values range from `0.0` to `1.0`.
  ///
  /// If the response is empty the file will be created with no data.
  ///
  /// See:
  ///   * [get_Request] for the request sent by this method.
  Future<void> getFile(
    PathUri path,
    File file, {
    void Function(double progress)? onProgress,
  }) async {
    final sink = file.openWrite();
    final stream = await getStream(
      path,
      onProgress: onProgress,
    );
    await stream.pipe(sink);
    await sink.close();
  }

  /// Returns a request to retrieve the [prop] for the resource at [path].
  ///
  /// [depth] can be used to limit scope of the returned resources.
  ///
  /// See:
  ///   * http://www.webdav.org/specs/rfc2518.html#METHOD_PROPFIND for more information.
  ///   * [propfind] for a complete operation executing this request.
  http.Request propfind_Request(
    PathUri path, {
    WebDavPropWithoutValues? prop,
    WebDavDepth? depth,
  }) {
    final request = http.Request('PROPFIND', _constructUri(path))
      ..body = WebDavPropfind(prop: prop ?? const WebDavPropWithoutValues())
          .toXmlElement(namespaces: namespaces)
          .toXmlString();

    if (depth != null) {
      request.headers['Depth'] = depth.value;
    }

    _addBaseHeaders(request);
    return request;
  }

  /// Retrieves the [prop] for the resource at [path].
  ///
  /// [depth] can be used to limit scope of the returned resources.
  ///
  /// See:
  ///   * http://www.webdav.org/specs/rfc2518.html#METHOD_PROPFIND for more information.
  ///   * [propfind_Request] for the request sent by this method.
  Future<WebDavMultistatus> propfind(
    PathUri path, {
    WebDavPropWithoutValues? prop,
    WebDavDepth? depth,
  }) async {
    final request = propfind_Request(
      path,
      prop: prop,
      depth: depth,
    );

    final streamedResponse = await httpClient.send(request);
    final response = await http.Response.fromStream(streamedResponse);
    if (streamedResponse.statusCode != 207) {
      throw DynamiteStatusCodeException(response);
    }

    return const WebDavResponseConverter().convert(response);
  }

  /// Returns a request to run the filter-files report with the [filterRules] on the resource at [path].
  ///
  /// [prop] specifies which props will be returned in the response.
  ///
  /// See:
  ///   * https://docs.nextcloud.com/server/latest/developer_manual/client_apis/WebDAV/basic.html#listing-favorites for more information.
  ///   * [report] for a complete operation executing this request.
  http.Request report_Request(
    PathUri path,
    WebDavOcFilterRules filterRules, {
    WebDavPropWithoutValues? prop,
  }) {
    final request = http.Request('REPORT', _constructUri(path))
      ..body = WebDavOcFilterFiles(
        filterRules: filterRules,
        prop: prop ?? const WebDavPropWithoutValues(), // coverage:ignore-line
      ).toXmlElement(namespaces: namespaces).toXmlString();

    _addBaseHeaders(request);
    return request;
  }

  /// Runs the filter-files report with the [filterRules] on the resource at [path].
  ///
  /// [prop] specifies which props will be returned in the response.
  ///
  /// See:
  ///   * https://docs.nextcloud.com/server/latest/developer_manual/client_apis/WebDAV/basic.html#listing-favorites for more information.
  ///   * [report_Request] for the request sent by this method.
  Future<WebDavMultistatus> report(
    PathUri path,
    WebDavOcFilterRules filterRules, {
    WebDavPropWithoutValues? prop,
  }) async {
    final request = report_Request(
      path,
      filterRules,
      prop: prop,
    );

    final streamedResponse = await httpClient.send(request);
    final response = await http.Response.fromStream(streamedResponse);
    if (streamedResponse.statusCode != 207) {
      throw DynamiteStatusCodeException(response);
    }

    return const WebDavResponseConverter().convert(response);
  }

  /// Returns a request to update the props of the resource at [path].
  ///
  /// The props in [set] will be added/updated.
  /// The props in [remove] will be removed.
  ///
  /// See:
  ///   * http://www.webdav.org/specs/rfc2518.html#METHOD_PROPPATCH for more information.
  ///   * [proppatch] for a complete operation executing this request.
  http.Request proppatch_Request(
    PathUri path, {
    WebDavProp? set,
    WebDavPropWithoutValues? remove,
  }) {
    final request = http.Request('PROPPATCH', _constructUri(path))
      ..body = WebDavPropertyupdate(
        set: set != null ? WebDavSet(prop: set) : null,
        remove: remove != null ? WebDavRemove(prop: remove) : null,
      ).toXmlElement(namespaces: namespaces).toXmlString();

    _addBaseHeaders(request);
    return request;
  }

  /// Updates the props of the resource at [path].
  ///
  /// The props in [set] will be added/updated.
  /// The props in [remove] will be removed.
  ///
  /// See:
  ///   * http://www.webdav.org/specs/rfc2518.html#METHOD_PROPPATCH for more information.
  ///   * [proppatch_Request] for the request sent by this method.
  Future<WebDavMultistatus> proppatch(
    PathUri path, {
    WebDavProp? set,
    WebDavPropWithoutValues? remove,
  }) async {
    final request = proppatch_Request(
      path,
      set: set,
      remove: remove,
    );

    final streamedResponse = await httpClient.send(request);
    final response = await http.Response.fromStream(streamedResponse);
    if (streamedResponse.statusCode != 207) {
      throw DynamiteStatusCodeException(response);
    }

    return const WebDavResponseConverter().convert(response);
  }

  /// Returns a request to move the resource from [sourcePath] to [destinationPath].
  ///
  /// [overwrite] determines if the request will fail if the [destinationPath] already exists.
  ///
  /// See:
  ///   * http://www.webdav.org/specs/rfc2518.html#METHOD_MOVE for more information.
  ///   * [move] for a complete operation executing this request.
  http.Request move_Request(
    PathUri sourcePath,
    PathUri destinationPath, {
    bool overwrite = false,
  }) {
    final request = http.Request('MOVE', _constructUri(sourcePath));

    _addCopyHeaders(
      request,
      destinationPath: destinationPath,
      overwrite: overwrite,
    );
    _addBaseHeaders(request);
    return request;
  }

  /// Moves the resource from [sourcePath] to [destinationPath].
  ///
  /// [overwrite] determines if the request will fail if the [destinationPath] already exists.
  ///
  /// See:
  ///   * http://www.webdav.org/specs/rfc2518.html#METHOD_MOVE for more information.
  ///   * [move_Request] for the request sent by this method.
  Future<http.StreamedResponse> move(
    PathUri sourcePath,
    PathUri destinationPath, {
    bool overwrite = false,
  }) async {
    final request = move_Request(
      sourcePath,
      destinationPath,
      overwrite: overwrite,
    );

    final streamedResponse = await httpClient.send(request);
    if (streamedResponse.statusCode != 201 && streamedResponse.statusCode != 204) {
      final response = await http.Response.fromStream(streamedResponse);
      throw DynamiteStatusCodeException(response);
    }

    return streamedResponse;
  }

  /// Returns a request to copy the resource from [sourcePath] to [destinationPath].
  ///
  /// [overwrite] determines if the request will fail if the [destinationPath] already exists.
  ///
  /// See:
  ///   * http://www.webdav.org/specs/rfc2518.html#METHOD_COPY for more information.
  ///   * [copy] for a complete operation executing this request.
  http.Request copy_Request(
    PathUri sourcePath,
    PathUri destinationPath, {
    bool overwrite = false,
  }) {
    final request = http.Request('COPY', _constructUri(sourcePath));

    _addCopyHeaders(
      request,
      destinationPath: destinationPath,
      overwrite: overwrite,
    );
    _addBaseHeaders(request);
    return request;
  }

  /// Copies the resource from [sourcePath] to [destinationPath].
  ///
  /// [overwrite] determines if the request will fail if the [destinationPath] already exists.
  ///
  /// See:
  ///   * http://www.webdav.org/specs/rfc2518.html#METHOD_COPY for more information.
  ///   * [copy_Request] for the request sent by this method.
  Future<http.StreamedResponse> copy(
    PathUri sourcePath,
    PathUri destinationPath, {
    bool overwrite = false,
  }) async {
    final request = copy_Request(
      sourcePath,
      destinationPath,
      overwrite: overwrite,
    );

    final streamedResponse = await httpClient.send(request);
    if (streamedResponse.statusCode != 201 && streamedResponse.statusCode != 204) {
      final response = await http.Response.fromStream(streamedResponse);
      throw DynamiteStatusCodeException(response);
    }

    return streamedResponse;
  }

  void _addBaseHeaders(http.BaseRequest request) {
    request.headers['content-type'] = 'application/xml';

    final authentication = authentications?.firstOrNull;
    if (authentication != null) {
      request.headers.addAll(
        authentication.headers,
      );
    }
  }

  static void _addUploadHeaders(
    http.BaseRequest request, {
    required int contentLength,
    DateTime? lastModified,
    DateTime? created,
    String? checksum,
  }) {
    if (lastModified != null) {
      request.headers['X-OC-Mtime'] = lastModified.secondsSinceEpoch.toString();
    }
    if (created != null) {
      request.headers['X-OC-CTime'] = created.secondsSinceEpoch.toString();
    }
    if (checksum != null) {
      if (!checksumPattern.hasMatch(checksum)) {
        throw ArgumentError.value(checksum, 'checksum', 'Invalid checksum');
      }
      request.headers['OC-Checksum'] = checksum;
    }
    request.headers['content-length'] = contentLength.toString();
  }

  void _addCopyHeaders(http.BaseRequest request, {required PathUri destinationPath, required bool overwrite}) {
    request.headers['Destination'] = _constructUri(destinationPath).toString();
    request.headers['Overwrite'] = overwrite ? 'T' : 'F';
  }
}
