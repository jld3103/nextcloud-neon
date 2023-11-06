// ignore_for_file: camel_case_types
// ignore_for_file: discarded_futures
// ignore_for_file: public_member_api_docs
// ignore_for_file: unreachable_switch_case
import 'dart:convert';
import 'dart:typed_data';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:collection/collection.dart';
import 'package:dynamite_runtime/built_value.dart';
import 'package:dynamite_runtime/http_client.dart';
import 'package:dynamite_runtime/models.dart';
import 'package:dynamite_runtime/utils.dart';
import 'package:meta/meta.dart';
import 'package:universal_io/io.dart';

part 'spreed.openapi.g.dart';

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

  AvatarClient get avatar => AvatarClient(this);
  BotClient get bot => BotClient(this);
  BreakoutRoomClient get breakoutRoom => BreakoutRoomClient(this);
  CallClient get call => CallClient(this);
  CertificateClient get certificate => CertificateClient(this);
  ChatClient get chat => ChatClient(this);
  FederationClient get federation => FederationClient(this);
  FilesIntegrationClient get filesIntegration => FilesIntegrationClient(this);
  GuestClient get guest => GuestClient(this);
  HostedSignalingServerClient get hostedSignalingServer => HostedSignalingServerClient(this);
  MatterbridgeClient get matterbridge => MatterbridgeClient(this);
  MatterbridgeSettingsClient get matterbridgeSettings => MatterbridgeSettingsClient(this);
  PollClient get poll => PollClient(this);
  PublicShareAuthClient get publicShareAuth => PublicShareAuthClient(this);
  ReactionClient get reaction => ReactionClient(this);
  RecordingClient get recording => RecordingClient(this);
  RoomClient get room => RoomClient(this);
  SettingsClient get settings => SettingsClient(this);
  SignalingClient get signaling => SignalingClient(this);
  TempAvatarClient get tempAvatar => TempAvatarClient(this);
}

class AvatarClient {
  AvatarClient(this._rootClient);

  final Client _rootClient;

  /// Get the avatar of a room.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [darkTheme] Theme used for background. Defaults to `0`.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Room avatar returned
  ///
  /// See:
  ///  * [getAvatarRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<Uint8List, void>> getAvatar({
    required final String token,
    final int darkTheme = 0,
    final AvatarGetAvatarApiVersion apiVersion = AvatarGetAvatarApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = getAvatarRaw(
      token: token,
      darkTheme: darkTheme,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Get the avatar of a room.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [darkTheme] Theme used for background. Defaults to `0`.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Room avatar returned
  ///
  /// See:
  ///  * [getAvatar] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<Uint8List, void> getAvatarRaw({
    required final String token,
    final int darkTheme = 0,
    final AvatarGetAvatarApiVersion apiVersion = AvatarGetAvatarApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': '*/*',
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
    }

// coverage:ignore-end
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    if (darkTheme != 0) {
      queryParameters['darkTheme'] = darkTheme.toString();
    }
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/avatar';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<Uint8List, void>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(Uint8List),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Upload an avatar for a room.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Avatar uploaded successfully
  ///   * 400: Avatar invalid
  ///
  /// See:
  ///  * [uploadAvatarRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<AvatarUploadAvatarResponseApplicationJson, void>> uploadAvatar({
    required final String token,
    final AvatarUploadAvatarApiVersion apiVersion = AvatarUploadAvatarApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = uploadAvatarRaw(
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Upload an avatar for a room.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Avatar uploaded successfully
  ///   * 400: Avatar invalid
  ///
  /// See:
  ///  * [uploadAvatar] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<AvatarUploadAvatarResponseApplicationJson, void> uploadAvatarRaw({
    required final String token,
    final AvatarUploadAvatarApiVersion apiVersion = AvatarUploadAvatarApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/avatar';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<AvatarUploadAvatarResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(AvatarUploadAvatarResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Delete the avatar of a room.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Avatar removed successfully
  ///
  /// See:
  ///  * [deleteAvatarRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<AvatarDeleteAvatarResponseApplicationJson, void>> deleteAvatar({
    required final String token,
    final AvatarDeleteAvatarApiVersion apiVersion = AvatarDeleteAvatarApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = deleteAvatarRaw(
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Delete the avatar of a room.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Avatar removed successfully
  ///
  /// See:
  ///  * [deleteAvatar] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<AvatarDeleteAvatarResponseApplicationJson, void> deleteAvatarRaw({
    required final String token,
    final AvatarDeleteAvatarApiVersion apiVersion = AvatarDeleteAvatarApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/avatar';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<AvatarDeleteAvatarResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'delete',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(AvatarDeleteAvatarResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Set an emoji as avatar.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [emoji] Emoji.
  ///   * [color] Color of the emoji.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Avatar set successfully
  ///   * 400: Setting emoji avatar is not possible
  ///
  /// See:
  ///  * [emojiAvatarRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<AvatarEmojiAvatarResponseApplicationJson, void>> emojiAvatar({
    required final String emoji,
    required final String token,
    final String? color,
    final AvatarEmojiAvatarApiVersion apiVersion = AvatarEmojiAvatarApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = emojiAvatarRaw(
      emoji: emoji,
      token: token,
      color: color,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Set an emoji as avatar.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [emoji] Emoji.
  ///   * [color] Color of the emoji.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Avatar set successfully
  ///   * 400: Setting emoji avatar is not possible
  ///
  /// See:
  ///  * [emojiAvatar] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<AvatarEmojiAvatarResponseApplicationJson, void> emojiAvatarRaw({
    required final String emoji,
    required final String token,
    final String? color,
    final AvatarEmojiAvatarApiVersion apiVersion = AvatarEmojiAvatarApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    queryParameters['emoji'] = emoji;
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    if (color != null) {
      queryParameters['color'] = color;
    }
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/avatar/emoji';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<AvatarEmojiAvatarResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(AvatarEmojiAvatarResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Get the dark mode avatar of a room.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Room avatar returned
  ///
  /// See:
  ///  * [getAvatarDarkRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<Uint8List, void>> getAvatarDark({
    required final String token,
    final AvatarGetAvatarDarkApiVersion apiVersion = AvatarGetAvatarDarkApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = getAvatarDarkRaw(
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Get the dark mode avatar of a room.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Room avatar returned
  ///
  /// See:
  ///  * [getAvatarDark] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<Uint8List, void> getAvatarDarkRaw({
    required final String token,
    final AvatarGetAvatarDarkApiVersion apiVersion = AvatarGetAvatarDarkApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': '*/*',
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
    }

// coverage:ignore-end
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/avatar/dark';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<Uint8List, void>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(Uint8List),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }
}

class BotClient {
  BotClient(this._rootClient);

  final Client _rootClient;

  /// Sends a new chat message to the given room.
  ///
  /// The author and timestamp are automatically set to the current user/guest and time.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [message] The message to send.
  ///   * [referenceId] For the message to be able to later identify it again. Defaults to `''`.
  ///   * [replyTo] Parent id which this message is a reply to. Defaults to `0`.
  ///   * [silent] If sent silent the chat message will not create any notifications. Defaults to `0`.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token] Conversation token.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 201: Message sent successfully
  ///   * 400: Sending message is not possible
  ///   * 401: Sending message is not allowed
  ///   * 413: Message too long
  ///
  /// See:
  ///  * [sendMessageRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<BotSendMessageResponseApplicationJson, void>> sendMessage({
    required final String message,
    required final String token,
    final String referenceId = '',
    final int replyTo = 0,
    final int silent = 0,
    final BotSendMessageApiVersion apiVersion = BotSendMessageApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = sendMessageRaw(
      message: message,
      token: token,
      referenceId: referenceId,
      replyTo: replyTo,
      silent: silent,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Sends a new chat message to the given room.
  ///
  /// The author and timestamp are automatically set to the current user/guest and time.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [message] The message to send.
  ///   * [referenceId] For the message to be able to later identify it again. Defaults to `''`.
  ///   * [replyTo] Parent id which this message is a reply to. Defaults to `0`.
  ///   * [silent] If sent silent the chat message will not create any notifications. Defaults to `0`.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token] Conversation token.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 201: Message sent successfully
  ///   * 400: Sending message is not possible
  ///   * 401: Sending message is not allowed
  ///   * 413: Message too long
  ///
  /// See:
  ///  * [sendMessage] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<BotSendMessageResponseApplicationJson, void> sendMessageRaw({
    required final String message,
    required final String token,
    final String referenceId = '',
    final int replyTo = 0,
    final int silent = 0,
    final BotSendMessageApiVersion apiVersion = BotSendMessageApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    queryParameters['message'] = message;
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    if (referenceId != '') {
      queryParameters['referenceId'] = referenceId;
    }
    if (replyTo != 0) {
      queryParameters['replyTo'] = replyTo.toString();
    }
    if (silent != 0) {
      queryParameters['silent'] = silent.toString();
    }
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/bot/$token0/message';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<BotSendMessageResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {201, 400, 401, 413},
      ),
      bodyType: const FullType(BotSendMessageResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Adds a reaction to a chat message.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [reaction] Reaction to add.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token] Conversation token.
  ///   * [messageId] ID of the message.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Reaction already exists
  ///   * 201: Reacted successfully
  ///   * 400: Reacting is not possible
  ///   * 401: Reacting is not allowed
  ///   * 404: Reaction not found
  ///
  /// See:
  ///  * [reactRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<BotReactResponseApplicationJson, void>> react({
    required final String reaction,
    required final String token,
    required final int messageId,
    final BotReactApiVersion apiVersion = BotReactApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = reactRaw(
      reaction: reaction,
      token: token,
      messageId: messageId,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Adds a reaction to a chat message.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [reaction] Reaction to add.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token] Conversation token.
  ///   * [messageId] ID of the message.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Reaction already exists
  ///   * 201: Reacted successfully
  ///   * 400: Reacting is not possible
  ///   * 401: Reacting is not allowed
  ///   * 404: Reaction not found
  ///
  /// See:
  ///  * [react] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<BotReactResponseApplicationJson, void> reactRaw({
    required final String reaction,
    required final String token,
    required final int messageId,
    final BotReactApiVersion apiVersion = BotReactApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    queryParameters['reaction'] = reaction;
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final messageId0 = Uri.encodeQueryComponent(messageId.toString());
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/bot/$token0/reaction/$messageId0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<BotReactResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200, 201, 400, 401, 404},
      ),
      bodyType: const FullType(BotReactResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Deletes a reaction from a chat message.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [reaction] Reaction to delete.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token] Conversation token.
  ///   * [messageId] ID of the message.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Reaction deleted successfully
  ///   * 400: Reacting is not possible
  ///   * 404: Reaction not found
  ///   * 401: Reacting is not allowed
  ///
  /// See:
  ///  * [deleteReactionRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<BotDeleteReactionResponseApplicationJson, void>> deleteReaction({
    required final String reaction,
    required final String token,
    required final int messageId,
    final BotDeleteReactionApiVersion apiVersion = BotDeleteReactionApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = deleteReactionRaw(
      reaction: reaction,
      token: token,
      messageId: messageId,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Deletes a reaction from a chat message.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [reaction] Reaction to delete.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token] Conversation token.
  ///   * [messageId] ID of the message.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Reaction deleted successfully
  ///   * 400: Reacting is not possible
  ///   * 404: Reaction not found
  ///   * 401: Reacting is not allowed
  ///
  /// See:
  ///  * [deleteReaction] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<BotDeleteReactionResponseApplicationJson, void> deleteReactionRaw({
    required final String reaction,
    required final String token,
    required final int messageId,
    final BotDeleteReactionApiVersion apiVersion = BotDeleteReactionApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    queryParameters['reaction'] = reaction;
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final messageId0 = Uri.encodeQueryComponent(messageId.toString());
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/bot/$token0/reaction/$messageId0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<BotDeleteReactionResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'delete',
        uri,
        headers,
        body,
        const {200, 400, 404, 401},
      ),
      bodyType: const FullType(BotDeleteReactionResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// List admin bots.
  ///
  /// This endpoint requires admin access.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Bot list returned
  ///
  /// See:
  ///  * [adminListBotsRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<BotAdminListBotsResponseApplicationJson, void>> adminListBots({
    final BotAdminListBotsApiVersion apiVersion = BotAdminListBotsApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = adminListBotsRaw(
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// List admin bots.
  ///
  /// This endpoint requires admin access.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Bot list returned
  ///
  /// See:
  ///  * [adminListBots] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<BotAdminListBotsResponseApplicationJson, void> adminListBotsRaw({
    final BotAdminListBotsApiVersion apiVersion = BotAdminListBotsApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/bot/admin';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<BotAdminListBotsResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(BotAdminListBotsResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// List bots.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Bot list returned
  ///
  /// See:
  ///  * [listBotsRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<BotListBotsResponseApplicationJson, void>> listBots({
    required final String token,
    final BotListBotsApiVersion apiVersion = BotListBotsApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = listBotsRaw(
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// List bots.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Bot list returned
  ///
  /// See:
  ///  * [listBots] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<BotListBotsResponseApplicationJson, void> listBotsRaw({
    required final String token,
    final BotListBotsApiVersion apiVersion = BotListBotsApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/bot/$token0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<BotListBotsResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(BotListBotsResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Enables a bot.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [botId] ID of the bot.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Bot already enabled
  ///   * 201: Bot enabled successfully
  ///   * 400: Enabling bot errored
  ///
  /// See:
  ///  * [enableBotRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<BotEnableBotResponseApplicationJson, void>> enableBot({
    required final String token,
    required final int botId,
    final BotEnableBotApiVersion apiVersion = BotEnableBotApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = enableBotRaw(
      token: token,
      botId: botId,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Enables a bot.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [botId] ID of the bot.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Bot already enabled
  ///   * 201: Bot enabled successfully
  ///   * 400: Enabling bot errored
  ///
  /// See:
  ///  * [enableBot] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<BotEnableBotResponseApplicationJson, void> enableBotRaw({
    required final String token,
    required final int botId,
    final BotEnableBotApiVersion apiVersion = BotEnableBotApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final botId0 = Uri.encodeQueryComponent(botId.toString());
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/bot/$token0/$botId0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<BotEnableBotResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200, 201},
      ),
      bodyType: const FullType(BotEnableBotResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Disables a bot.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [botId] ID of the bot.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Bot disabled successfully
  ///   * 400: Disabling bot errored
  ///
  /// See:
  ///  * [disableBotRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<BotDisableBotResponseApplicationJson, void>> disableBot({
    required final String token,
    required final int botId,
    final BotDisableBotApiVersion apiVersion = BotDisableBotApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = disableBotRaw(
      token: token,
      botId: botId,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Disables a bot.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [botId] ID of the bot.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Bot disabled successfully
  ///   * 400: Disabling bot errored
  ///
  /// See:
  ///  * [disableBot] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<BotDisableBotResponseApplicationJson, void> disableBotRaw({
    required final String token,
    required final int botId,
    final BotDisableBotApiVersion apiVersion = BotDisableBotApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final botId0 = Uri.encodeQueryComponent(botId.toString());
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/bot/$token0/$botId0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<BotDisableBotResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'delete',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(BotDisableBotResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }
}

class BreakoutRoomClient {
  BreakoutRoomClient(this._rootClient);

  final Client _rootClient;

  /// Configure the breakout rooms.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [mode] Mode of the breakout rooms.
  ///   * [amount] Number of breakout rooms.
  ///   * [attendeeMap] Mapping of the attendees to breakout rooms. Defaults to `[]`.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Breakout rooms configured successfully
  ///   * 400: Configuring breakout rooms errored
  ///
  /// See:
  ///  * [configureBreakoutRoomsRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<BreakoutRoomConfigureBreakoutRoomsResponseApplicationJson, void>> configureBreakoutRooms({
    required final int mode,
    required final int amount,
    required final String token,
    final String attendeeMap = '[]',
    final BreakoutRoomConfigureBreakoutRoomsApiVersion apiVersion = BreakoutRoomConfigureBreakoutRoomsApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = configureBreakoutRoomsRaw(
      mode: mode,
      amount: amount,
      token: token,
      attendeeMap: attendeeMap,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Configure the breakout rooms.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [mode] Mode of the breakout rooms.
  ///   * [amount] Number of breakout rooms.
  ///   * [attendeeMap] Mapping of the attendees to breakout rooms. Defaults to `[]`.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Breakout rooms configured successfully
  ///   * 400: Configuring breakout rooms errored
  ///
  /// See:
  ///  * [configureBreakoutRooms] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<BreakoutRoomConfigureBreakoutRoomsResponseApplicationJson, void> configureBreakoutRoomsRaw({
    required final int mode,
    required final int amount,
    required final String token,
    final String attendeeMap = '[]',
    final BreakoutRoomConfigureBreakoutRoomsApiVersion apiVersion = BreakoutRoomConfigureBreakoutRoomsApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    queryParameters['mode'] = mode.toString();
    queryParameters['amount'] = amount.toString();
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    if (attendeeMap != '[]') {
      queryParameters['attendeeMap'] = attendeeMap;
    }
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/breakout-rooms/$token0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<BreakoutRoomConfigureBreakoutRoomsResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(BreakoutRoomConfigureBreakoutRoomsResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Remove the breakout rooms.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Breakout rooms removed successfully
  ///
  /// See:
  ///  * [removeBreakoutRoomsRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<BreakoutRoomRemoveBreakoutRoomsResponseApplicationJson, void>> removeBreakoutRooms({
    required final String token,
    final BreakoutRoomRemoveBreakoutRoomsApiVersion apiVersion = BreakoutRoomRemoveBreakoutRoomsApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = removeBreakoutRoomsRaw(
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Remove the breakout rooms.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Breakout rooms removed successfully
  ///
  /// See:
  ///  * [removeBreakoutRooms] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<BreakoutRoomRemoveBreakoutRoomsResponseApplicationJson, void> removeBreakoutRoomsRaw({
    required final String token,
    final BreakoutRoomRemoveBreakoutRoomsApiVersion apiVersion = BreakoutRoomRemoveBreakoutRoomsApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/breakout-rooms/$token0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<BreakoutRoomRemoveBreakoutRoomsResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'delete',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(BreakoutRoomRemoveBreakoutRoomsResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Broadcast a chat message to all breakout rooms.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [message] Message to broadcast.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 201: Chat message broadcasted successfully
  ///   * 400: Broadcasting chat message is not possible
  ///   * 413: Chat message too long
  ///
  /// See:
  ///  * [broadcastChatMessageRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<BreakoutRoomBroadcastChatMessageResponseApplicationJson, void>> broadcastChatMessage({
    required final String message,
    required final String token,
    final BreakoutRoomBroadcastChatMessageApiVersion apiVersion = BreakoutRoomBroadcastChatMessageApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = broadcastChatMessageRaw(
      message: message,
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Broadcast a chat message to all breakout rooms.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [message] Message to broadcast.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 201: Chat message broadcasted successfully
  ///   * 400: Broadcasting chat message is not possible
  ///   * 413: Chat message too long
  ///
  /// See:
  ///  * [broadcastChatMessage] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<BreakoutRoomBroadcastChatMessageResponseApplicationJson, void> broadcastChatMessageRaw({
    required final String message,
    required final String token,
    final BreakoutRoomBroadcastChatMessageApiVersion apiVersion = BreakoutRoomBroadcastChatMessageApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    queryParameters['message'] = message;
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/breakout-rooms/$token0/broadcast';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<BreakoutRoomBroadcastChatMessageResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {201},
      ),
      bodyType: const FullType(BreakoutRoomBroadcastChatMessageResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Apply an attendee map to the breakout rooms.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [attendeeMap] JSON encoded mapping of the attendees to breakout rooms `array<int, int>`.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Attendee map applied successfully
  ///   * 400: Applying attendee map is not possible
  ///
  /// See:
  ///  * [applyAttendeeMapRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<BreakoutRoomApplyAttendeeMapResponseApplicationJson, void>> applyAttendeeMap({
    required final String attendeeMap,
    required final String token,
    final BreakoutRoomApplyAttendeeMapApiVersion apiVersion = BreakoutRoomApplyAttendeeMapApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = applyAttendeeMapRaw(
      attendeeMap: attendeeMap,
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Apply an attendee map to the breakout rooms.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [attendeeMap] JSON encoded mapping of the attendees to breakout rooms `array<int, int>`.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Attendee map applied successfully
  ///   * 400: Applying attendee map is not possible
  ///
  /// See:
  ///  * [applyAttendeeMap] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<BreakoutRoomApplyAttendeeMapResponseApplicationJson, void> applyAttendeeMapRaw({
    required final String attendeeMap,
    required final String token,
    final BreakoutRoomApplyAttendeeMapApiVersion apiVersion = BreakoutRoomApplyAttendeeMapApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    queryParameters['attendeeMap'] = attendeeMap;
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/breakout-rooms/$token0/attendees';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<BreakoutRoomApplyAttendeeMapResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(BreakoutRoomApplyAttendeeMapResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Request assistance.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Assistance requested successfully
  ///   * 400: Requesting assistance is not possible
  ///
  /// See:
  ///  * [requestAssistanceRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<BreakoutRoomRequestAssistanceResponseApplicationJson, void>> requestAssistance({
    required final String token,
    final BreakoutRoomRequestAssistanceApiVersion apiVersion = BreakoutRoomRequestAssistanceApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = requestAssistanceRaw(
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Request assistance.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Assistance requested successfully
  ///   * 400: Requesting assistance is not possible
  ///
  /// See:
  ///  * [requestAssistance] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<BreakoutRoomRequestAssistanceResponseApplicationJson, void> requestAssistanceRaw({
    required final String token,
    final BreakoutRoomRequestAssistanceApiVersion apiVersion = BreakoutRoomRequestAssistanceApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/breakout-rooms/$token0/request-assistance';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<BreakoutRoomRequestAssistanceResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(BreakoutRoomRequestAssistanceResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Reset the request for assistance.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Request for assistance reset successfully
  ///   * 400: Resetting the request for assistance is not possible
  ///
  /// See:
  ///  * [resetRequestForAssistanceRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<BreakoutRoomResetRequestForAssistanceResponseApplicationJson, void>>
      resetRequestForAssistance({
    required final String token,
    final BreakoutRoomResetRequestForAssistanceApiVersion apiVersion =
        BreakoutRoomResetRequestForAssistanceApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = resetRequestForAssistanceRaw(
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Reset the request for assistance.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Request for assistance reset successfully
  ///   * 400: Resetting the request for assistance is not possible
  ///
  /// See:
  ///  * [resetRequestForAssistance] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<BreakoutRoomResetRequestForAssistanceResponseApplicationJson, void> resetRequestForAssistanceRaw({
    required final String token,
    final BreakoutRoomResetRequestForAssistanceApiVersion apiVersion =
        BreakoutRoomResetRequestForAssistanceApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/breakout-rooms/$token0/request-assistance';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<BreakoutRoomResetRequestForAssistanceResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'delete',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(BreakoutRoomResetRequestForAssistanceResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Start the breakout rooms.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Breakout rooms started successfully
  ///   * 400: Starting breakout rooms is not possible
  ///
  /// See:
  ///  * [startBreakoutRoomsRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<BreakoutRoomStartBreakoutRoomsResponseApplicationJson, void>> startBreakoutRooms({
    required final String token,
    final BreakoutRoomStartBreakoutRoomsApiVersion apiVersion = BreakoutRoomStartBreakoutRoomsApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = startBreakoutRoomsRaw(
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Start the breakout rooms.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Breakout rooms started successfully
  ///   * 400: Starting breakout rooms is not possible
  ///
  /// See:
  ///  * [startBreakoutRooms] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<BreakoutRoomStartBreakoutRoomsResponseApplicationJson, void> startBreakoutRoomsRaw({
    required final String token,
    final BreakoutRoomStartBreakoutRoomsApiVersion apiVersion = BreakoutRoomStartBreakoutRoomsApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/breakout-rooms/$token0/rooms';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<BreakoutRoomStartBreakoutRoomsResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(BreakoutRoomStartBreakoutRoomsResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Stop the breakout rooms.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Breakout rooms stopped successfully
  ///   * 400: Stopping breakout rooms is not possible
  ///
  /// See:
  ///  * [stopBreakoutRoomsRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<BreakoutRoomStopBreakoutRoomsResponseApplicationJson, void>> stopBreakoutRooms({
    required final String token,
    final BreakoutRoomStopBreakoutRoomsApiVersion apiVersion = BreakoutRoomStopBreakoutRoomsApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = stopBreakoutRoomsRaw(
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Stop the breakout rooms.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Breakout rooms stopped successfully
  ///   * 400: Stopping breakout rooms is not possible
  ///
  /// See:
  ///  * [stopBreakoutRooms] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<BreakoutRoomStopBreakoutRoomsResponseApplicationJson, void> stopBreakoutRoomsRaw({
    required final String token,
    final BreakoutRoomStopBreakoutRoomsApiVersion apiVersion = BreakoutRoomStopBreakoutRoomsApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/breakout-rooms/$token0/rooms';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<BreakoutRoomStopBreakoutRoomsResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'delete',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(BreakoutRoomStopBreakoutRoomsResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Switch to another breakout room.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [target] Target breakout room.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Switched to breakout room successfully
  ///   * 400: Switching to breakout room is not possible
  ///
  /// See:
  ///  * [switchBreakoutRoomRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<BreakoutRoomSwitchBreakoutRoomResponseApplicationJson, void>> switchBreakoutRoom({
    required final String target,
    required final String token,
    final BreakoutRoomSwitchBreakoutRoomApiVersion apiVersion = BreakoutRoomSwitchBreakoutRoomApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = switchBreakoutRoomRaw(
      target: target,
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Switch to another breakout room.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [target] Target breakout room.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Switched to breakout room successfully
  ///   * 400: Switching to breakout room is not possible
  ///
  /// See:
  ///  * [switchBreakoutRoom] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<BreakoutRoomSwitchBreakoutRoomResponseApplicationJson, void> switchBreakoutRoomRaw({
    required final String target,
    required final String token,
    final BreakoutRoomSwitchBreakoutRoomApiVersion apiVersion = BreakoutRoomSwitchBreakoutRoomApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    queryParameters['target'] = target;
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/breakout-rooms/$token0/switch';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<BreakoutRoomSwitchBreakoutRoomResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(BreakoutRoomSwitchBreakoutRoomResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }
}

class CallClient {
  CallClient(this._rootClient);

  final Client _rootClient;

  /// Get the peers for a call.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: List of peers in the call returned
  ///
  /// See:
  ///  * [getPeersForCallRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<CallGetPeersForCallResponseApplicationJson, void>> getPeersForCall({
    required final String token,
    final CallGetPeersForCallApiVersion apiVersion = CallGetPeersForCallApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = getPeersForCallRaw(
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Get the peers for a call.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: List of peers in the call returned
  ///
  /// See:
  ///  * [getPeersForCall] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<CallGetPeersForCallResponseApplicationJson, void> getPeersForCallRaw({
    required final String token,
    final CallGetPeersForCallApiVersion apiVersion = CallGetPeersForCallApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/call/$token0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<CallGetPeersForCallResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(CallGetPeersForCallResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Update the in-call flags.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [flags] New flags.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: In-call flags updated successfully
  ///   * 400: Updating in-call flags is not possible
  ///   * 404: Call session not found
  ///
  /// See:
  ///  * [updateCallFlagsRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<CallUpdateCallFlagsResponseApplicationJson, void>> updateCallFlags({
    required final int flags,
    required final String token,
    final CallUpdateCallFlagsApiVersion apiVersion = CallUpdateCallFlagsApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = updateCallFlagsRaw(
      flags: flags,
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Update the in-call flags.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [flags] New flags.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: In-call flags updated successfully
  ///   * 400: Updating in-call flags is not possible
  ///   * 404: Call session not found
  ///
  /// See:
  ///  * [updateCallFlags] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<CallUpdateCallFlagsResponseApplicationJson, void> updateCallFlagsRaw({
    required final int flags,
    required final String token,
    final CallUpdateCallFlagsApiVersion apiVersion = CallUpdateCallFlagsApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    queryParameters['flags'] = flags.toString();
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/call/$token0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<CallUpdateCallFlagsResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'put',
        uri,
        headers,
        body,
        const {200, 400, 404},
      ),
      bodyType: const FullType(CallUpdateCallFlagsResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Join a call.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [flags] In-Call flags.
  ///   * [forcePermissions] In-call permissions.
  ///   * [silent] Join the call silently. Defaults to `0`.
  ///   * [recordingConsent] When the user ticked a checkbox and agreed with being recorded (Only needed when the `config => call => recording-consent` capability is set to {@see RecordingService::CONSENT_REQUIRED_YES} or the capability is {@see RecordingService::CONSENT_REQUIRED_OPTIONAL} and the conversation `recordingConsent` value is {@see RecordingService::CONSENT_REQUIRED_YES} ). Defaults to `0`.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Call joined successfully
  ///   * 404: Call not found
  ///   * 400: No recording consent was given
  ///
  /// See:
  ///  * [joinCallRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<CallJoinCallResponseApplicationJson, void>> joinCall({
    required final String token,
    final int? flags,
    final int? forcePermissions,
    final int silent = 0,
    final int recordingConsent = 0,
    final CallJoinCallApiVersion apiVersion = CallJoinCallApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = joinCallRaw(
      token: token,
      flags: flags,
      forcePermissions: forcePermissions,
      silent: silent,
      recordingConsent: recordingConsent,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Join a call.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [flags] In-Call flags.
  ///   * [forcePermissions] In-call permissions.
  ///   * [silent] Join the call silently. Defaults to `0`.
  ///   * [recordingConsent] When the user ticked a checkbox and agreed with being recorded (Only needed when the `config => call => recording-consent` capability is set to {@see RecordingService::CONSENT_REQUIRED_YES} or the capability is {@see RecordingService::CONSENT_REQUIRED_OPTIONAL} and the conversation `recordingConsent` value is {@see RecordingService::CONSENT_REQUIRED_YES} ). Defaults to `0`.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Call joined successfully
  ///   * 404: Call not found
  ///   * 400: No recording consent was given
  ///
  /// See:
  ///  * [joinCall] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<CallJoinCallResponseApplicationJson, void> joinCallRaw({
    required final String token,
    final int? flags,
    final int? forcePermissions,
    final int silent = 0,
    final int recordingConsent = 0,
    final CallJoinCallApiVersion apiVersion = CallJoinCallApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    if (flags != null) {
      queryParameters['flags'] = flags.toString();
    }
    if (forcePermissions != null) {
      queryParameters['forcePermissions'] = forcePermissions.toString();
    }
    if (silent != 0) {
      queryParameters['silent'] = silent.toString();
    }
    if (recordingConsent != 0) {
      queryParameters['recordingConsent'] = recordingConsent.toString();
    }
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/call/$token0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<CallJoinCallResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200, 404},
      ),
      bodyType: const FullType(CallJoinCallResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Leave a call.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [all] whether to also terminate the call for all participants. Defaults to `0`.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Call left successfully
  ///   * 404: Call session not found
  ///
  /// See:
  ///  * [leaveCallRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<CallLeaveCallResponseApplicationJson, void>> leaveCall({
    required final String token,
    final int all = 0,
    final CallLeaveCallApiVersion apiVersion = CallLeaveCallApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = leaveCallRaw(
      token: token,
      all: all,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Leave a call.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [all] whether to also terminate the call for all participants. Defaults to `0`.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Call left successfully
  ///   * 404: Call session not found
  ///
  /// See:
  ///  * [leaveCall] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<CallLeaveCallResponseApplicationJson, void> leaveCallRaw({
    required final String token,
    final int all = 0,
    final CallLeaveCallApiVersion apiVersion = CallLeaveCallApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    if (all != 0) {
      queryParameters['all'] = all.toString();
    }
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/call/$token0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<CallLeaveCallResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'delete',
        uri,
        headers,
        body,
        const {200, 404},
      ),
      bodyType: const FullType(CallLeaveCallResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Ring an attendee.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [attendeeId] ID of the attendee to ring.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Attendee rang successfully
  ///   * 400: Ringing attendee is not possible
  ///
  /// See:
  ///  * [ringAttendeeRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<CallRingAttendeeResponseApplicationJson, void>> ringAttendee({
    required final String token,
    required final int attendeeId,
    final CallRingAttendeeApiVersion apiVersion = CallRingAttendeeApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = ringAttendeeRaw(
      token: token,
      attendeeId: attendeeId,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Ring an attendee.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [attendeeId] ID of the attendee to ring.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Attendee rang successfully
  ///   * 400: Ringing attendee is not possible
  ///
  /// See:
  ///  * [ringAttendee] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<CallRingAttendeeResponseApplicationJson, void> ringAttendeeRaw({
    required final String token,
    required final int attendeeId,
    final CallRingAttendeeApiVersion apiVersion = CallRingAttendeeApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final attendeeId0 = Uri.encodeQueryComponent(attendeeId.toString());
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/call/$token0/ring/$attendeeId0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<CallRingAttendeeResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200, 400},
      ),
      bodyType: const FullType(CallRingAttendeeResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Call a SIP dial-out attendee.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [attendeeId] ID of the attendee to call.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 201: Dial-out initiated successfully
  ///   * 400: SIP dial-out not possible
  ///   * 404: Participant could not be found or is a wrong type
  ///   * 501: SIP dial-out is not configured on the server
  ///
  /// See:
  ///  * [sipDialOutRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<CallSipDialOutResponseApplicationJson, void>> sipDialOut({
    required final String token,
    required final int attendeeId,
    final CallSipDialOutApiVersion apiVersion = CallSipDialOutApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = sipDialOutRaw(
      token: token,
      attendeeId: attendeeId,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Call a SIP dial-out attendee.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [attendeeId] ID of the attendee to call.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 201: Dial-out initiated successfully
  ///   * 400: SIP dial-out not possible
  ///   * 404: Participant could not be found or is a wrong type
  ///   * 501: SIP dial-out is not configured on the server
  ///
  /// See:
  ///  * [sipDialOut] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<CallSipDialOutResponseApplicationJson, void> sipDialOutRaw({
    required final String token,
    required final int attendeeId,
    final CallSipDialOutApiVersion apiVersion = CallSipDialOutApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final attendeeId0 = Uri.encodeQueryComponent(attendeeId.toString());
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/call/$token0/dialout/$attendeeId0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<CallSipDialOutResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {201, 400, 404, 501},
      ),
      bodyType: const FullType(CallSipDialOutResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }
}

class CertificateClient {
  CertificateClient(this._rootClient);

  final Client _rootClient;

  /// Get the certificate expiration for a host.
  ///
  /// This endpoint requires admin access.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [host] Host to check.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Certificate expiration returned
  ///   * 400: Getting certificate expiration is not possible
  ///
  /// See:
  ///  * [getCertificateExpirationRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<CertificateGetCertificateExpirationResponseApplicationJson, void>> getCertificateExpiration({
    required final String host,
    final CertificateGetCertificateExpirationApiVersion apiVersion = CertificateGetCertificateExpirationApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = getCertificateExpirationRaw(
      host: host,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Get the certificate expiration for a host.
  ///
  /// This endpoint requires admin access.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [host] Host to check.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Certificate expiration returned
  ///   * 400: Getting certificate expiration is not possible
  ///
  /// See:
  ///  * [getCertificateExpiration] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<CertificateGetCertificateExpirationResponseApplicationJson, void> getCertificateExpirationRaw({
    required final String host,
    final CertificateGetCertificateExpirationApiVersion apiVersion = CertificateGetCertificateExpirationApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    queryParameters['host'] = host;
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/certificate/expiration';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<CertificateGetCertificateExpirationResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(CertificateGetCertificateExpirationResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }
}

class ChatClient {
  ChatClient(this._rootClient);

  final Client _rootClient;

  /// Receives chat messages from the given room.
  ///
  /// - Receiving the history ($lookIntoFuture=0): The next $limit messages after $lastKnownMessageId will be returned. The new $lastKnownMessageId for the follow up query is available as `X-Chat-Last-Given` header.
  /// - Looking into the future ($lookIntoFuture=1): If there are currently no messages the response will not be sent immediately. Instead, HTTP connection will be kept open waiting for new messages to arrive and, when they do, then the response will be sent. The connection will not be kept open indefinitely, though; the number of seconds to wait for new messages to arrive can be set using the timeout parameter; the default timeout is 30 seconds, maximum timeout is 60 seconds. If the timeout ends a successful but empty response will be sent. If messages have been returned (status=200) the new $lastKnownMessageId for the follow up query is available as `X-Chat-Last-Given` header.
  /// The limit specifies the maximum number of messages that will be returned, although the actual number of returned messages could be lower if some messages are not visible to the participant. Note that if none of the messages are visible to the participant the returned number of messages will be 0, yet the status will still be 200. Also note that `X-Chat-Last-Given` may reference a message not visible and thus not returned, but it should be used nevertheless as the $lastKnownMessageId for the follow-up query.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [lookIntoFuture] Polling for new messages (1) or getting the history of the chat (0).
  ///   * [limit] Number of chat messages to receive (100 by default, 200 at most). Defaults to `100`.
  ///   * [lastKnownMessageId] The last known message (serves as offset). Defaults to `0`.
  ///   * [lastCommonReadId] The last known common read message (so the response is 200 instead of 304 when it changes even when there are no messages). Defaults to `0`.
  ///   * [timeout] Number of seconds to wait for new messages (30 by default, 30 at most). Defaults to `30`.
  ///   * [setReadMarker] Automatically set the last read marker when 1, if your client does this itself via chat/{token}/read set to 0. Defaults to `1`.
  ///   * [includeLastKnown] Include the $lastKnownMessageId in the messages when 1 (default 0). Defaults to `0`.
  ///   * [noStatusUpdate] When the user status should not be automatically set to online set to 1 (default 0). Defaults to `0`.
  ///   * [markNotificationsAsRead] Set to 0 when notifications should not be marked as read (default 1). Defaults to `1`.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Messages returned
  ///   * 304: No messages
  ///
  /// See:
  ///  * [receiveMessagesRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<ChatReceiveMessagesResponseApplicationJson, ChatChatReceiveMessagesHeaders>> receiveMessages({
    required final int lookIntoFuture,
    required final String token,
    final int limit = 100,
    final int lastKnownMessageId = 0,
    final int lastCommonReadId = 0,
    final int timeout = 30,
    final int setReadMarker = 1,
    final int includeLastKnown = 0,
    final int noStatusUpdate = 0,
    final int markNotificationsAsRead = 1,
    final ChatReceiveMessagesApiVersion apiVersion = ChatReceiveMessagesApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = receiveMessagesRaw(
      lookIntoFuture: lookIntoFuture,
      token: token,
      limit: limit,
      lastKnownMessageId: lastKnownMessageId,
      lastCommonReadId: lastCommonReadId,
      timeout: timeout,
      setReadMarker: setReadMarker,
      includeLastKnown: includeLastKnown,
      noStatusUpdate: noStatusUpdate,
      markNotificationsAsRead: markNotificationsAsRead,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Receives chat messages from the given room.
  ///
  /// - Receiving the history ($lookIntoFuture=0): The next $limit messages after $lastKnownMessageId will be returned. The new $lastKnownMessageId for the follow up query is available as `X-Chat-Last-Given` header.
  /// - Looking into the future ($lookIntoFuture=1): If there are currently no messages the response will not be sent immediately. Instead, HTTP connection will be kept open waiting for new messages to arrive and, when they do, then the response will be sent. The connection will not be kept open indefinitely, though; the number of seconds to wait for new messages to arrive can be set using the timeout parameter; the default timeout is 30 seconds, maximum timeout is 60 seconds. If the timeout ends a successful but empty response will be sent. If messages have been returned (status=200) the new $lastKnownMessageId for the follow up query is available as `X-Chat-Last-Given` header.
  /// The limit specifies the maximum number of messages that will be returned, although the actual number of returned messages could be lower if some messages are not visible to the participant. Note that if none of the messages are visible to the participant the returned number of messages will be 0, yet the status will still be 200. Also note that `X-Chat-Last-Given` may reference a message not visible and thus not returned, but it should be used nevertheless as the $lastKnownMessageId for the follow-up query.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [lookIntoFuture] Polling for new messages (1) or getting the history of the chat (0).
  ///   * [limit] Number of chat messages to receive (100 by default, 200 at most). Defaults to `100`.
  ///   * [lastKnownMessageId] The last known message (serves as offset). Defaults to `0`.
  ///   * [lastCommonReadId] The last known common read message (so the response is 200 instead of 304 when it changes even when there are no messages). Defaults to `0`.
  ///   * [timeout] Number of seconds to wait for new messages (30 by default, 30 at most). Defaults to `30`.
  ///   * [setReadMarker] Automatically set the last read marker when 1, if your client does this itself via chat/{token}/read set to 0. Defaults to `1`.
  ///   * [includeLastKnown] Include the $lastKnownMessageId in the messages when 1 (default 0). Defaults to `0`.
  ///   * [noStatusUpdate] When the user status should not be automatically set to online set to 1 (default 0). Defaults to `0`.
  ///   * [markNotificationsAsRead] Set to 0 when notifications should not be marked as read (default 1). Defaults to `1`.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Messages returned
  ///   * 304: No messages
  ///
  /// See:
  ///  * [receiveMessages] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<ChatReceiveMessagesResponseApplicationJson, ChatChatReceiveMessagesHeaders> receiveMessagesRaw({
    required final int lookIntoFuture,
    required final String token,
    final int limit = 100,
    final int lastKnownMessageId = 0,
    final int lastCommonReadId = 0,
    final int timeout = 30,
    final int setReadMarker = 1,
    final int includeLastKnown = 0,
    final int noStatusUpdate = 0,
    final int markNotificationsAsRead = 1,
    final ChatReceiveMessagesApiVersion apiVersion = ChatReceiveMessagesApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    queryParameters['lookIntoFuture'] = lookIntoFuture.toString();
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    if (limit != 100) {
      queryParameters['limit'] = limit.toString();
    }
    if (lastKnownMessageId != 0) {
      queryParameters['lastKnownMessageId'] = lastKnownMessageId.toString();
    }
    if (lastCommonReadId != 0) {
      queryParameters['lastCommonReadId'] = lastCommonReadId.toString();
    }
    if (timeout != 30) {
      queryParameters['timeout'] = timeout.toString();
    }
    if (setReadMarker != 1) {
      queryParameters['setReadMarker'] = setReadMarker.toString();
    }
    if (includeLastKnown != 0) {
      queryParameters['includeLastKnown'] = includeLastKnown.toString();
    }
    if (noStatusUpdate != 0) {
      queryParameters['noStatusUpdate'] = noStatusUpdate.toString();
    }
    if (markNotificationsAsRead != 1) {
      queryParameters['markNotificationsAsRead'] = markNotificationsAsRead.toString();
    }
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/chat/$token0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<ChatReceiveMessagesResponseApplicationJson, ChatChatReceiveMessagesHeaders>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200, 304},
      ),
      bodyType: const FullType(ChatReceiveMessagesResponseApplicationJson),
      headersType: const FullType(ChatChatReceiveMessagesHeaders),
      serializers: _jsonSerializers,
    );
  }

  /// Sends a new chat message to the given room.
  ///
  /// The author and timestamp are automatically set to the current user/guest and time.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [message] the message to send.
  ///   * [actorDisplayName] for guests. Defaults to `''`.
  ///   * [referenceId] for the message to be able to later identify it again. Defaults to `''`.
  ///   * [replyTo] Parent id which this message is a reply to. Defaults to `0`.
  ///   * [silent] If sent silent the chat message will not create any notifications. Defaults to `0`.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 201: Message sent successfully
  ///   * 400: Sending message is not possible
  ///   * 404: Actor not found
  ///   * 413: Message too long
  ///
  /// See:
  ///  * [sendMessageRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<ChatSendMessageResponseApplicationJson, ChatChatSendMessageHeaders>> sendMessage({
    required final String message,
    required final String token,
    final String actorDisplayName = '',
    final String referenceId = '',
    final int replyTo = 0,
    final int silent = 0,
    final ChatSendMessageApiVersion apiVersion = ChatSendMessageApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = sendMessageRaw(
      message: message,
      token: token,
      actorDisplayName: actorDisplayName,
      referenceId: referenceId,
      replyTo: replyTo,
      silent: silent,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Sends a new chat message to the given room.
  ///
  /// The author and timestamp are automatically set to the current user/guest and time.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [message] the message to send.
  ///   * [actorDisplayName] for guests. Defaults to `''`.
  ///   * [referenceId] for the message to be able to later identify it again. Defaults to `''`.
  ///   * [replyTo] Parent id which this message is a reply to. Defaults to `0`.
  ///   * [silent] If sent silent the chat message will not create any notifications. Defaults to `0`.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 201: Message sent successfully
  ///   * 400: Sending message is not possible
  ///   * 404: Actor not found
  ///   * 413: Message too long
  ///
  /// See:
  ///  * [sendMessage] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<ChatSendMessageResponseApplicationJson, ChatChatSendMessageHeaders> sendMessageRaw({
    required final String message,
    required final String token,
    final String actorDisplayName = '',
    final String referenceId = '',
    final int replyTo = 0,
    final int silent = 0,
    final ChatSendMessageApiVersion apiVersion = ChatSendMessageApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    queryParameters['message'] = message;
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    if (actorDisplayName != '') {
      queryParameters['actorDisplayName'] = actorDisplayName;
    }
    if (referenceId != '') {
      queryParameters['referenceId'] = referenceId;
    }
    if (replyTo != 0) {
      queryParameters['replyTo'] = replyTo.toString();
    }
    if (silent != 0) {
      queryParameters['silent'] = silent.toString();
    }
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/chat/$token0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<ChatSendMessageResponseApplicationJson, ChatChatSendMessageHeaders>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {201},
      ),
      bodyType: const FullType(ChatSendMessageResponseApplicationJson),
      headersType: const FullType(ChatChatSendMessageHeaders),
      serializers: _jsonSerializers,
    );
  }

  /// Clear the chat history.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: History cleared successfully
  ///   * 202: History cleared successfully, but Matterbridge is configured, so the information can be replicated elsewhere
  ///   * 403: Missing permissions to clear history
  ///
  /// See:
  ///  * [clearHistoryRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<ChatClearHistoryResponseApplicationJson, ChatChatClearHistoryHeaders>> clearHistory({
    required final String token,
    final ChatClearHistoryApiVersion apiVersion = ChatClearHistoryApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = clearHistoryRaw(
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Clear the chat history.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: History cleared successfully
  ///   * 202: History cleared successfully, but Matterbridge is configured, so the information can be replicated elsewhere
  ///   * 403: Missing permissions to clear history
  ///
  /// See:
  ///  * [clearHistory] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<ChatClearHistoryResponseApplicationJson, ChatChatClearHistoryHeaders> clearHistoryRaw({
    required final String token,
    final ChatClearHistoryApiVersion apiVersion = ChatClearHistoryApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/chat/$token0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<ChatClearHistoryResponseApplicationJson, ChatChatClearHistoryHeaders>(
      response: _rootClient.executeRequest(
        'delete',
        uri,
        headers,
        body,
        const {200, 202},
      ),
      bodyType: const FullType(ChatClearHistoryResponseApplicationJson),
      headersType: const FullType(ChatChatClearHistoryHeaders),
      serializers: _jsonSerializers,
    );
  }

  /// Delete a chat message.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [messageId] ID of the message.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Message deleted successfully
  ///   * 202: Message deleted successfully, but Matterbridge is configured, so the information can be replicated elsewhere
  ///   * 400: Deleting message is not possible
  ///   * 403: Missing permissions to delete message
  ///   * 404: Message not found
  ///   * 405: Deleting message is not allowed
  ///
  /// See:
  ///  * [deleteMessageRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<ChatDeleteMessageResponseApplicationJson, ChatChatDeleteMessageHeaders>> deleteMessage({
    required final String token,
    required final int messageId,
    final ChatDeleteMessageApiVersion apiVersion = ChatDeleteMessageApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = deleteMessageRaw(
      token: token,
      messageId: messageId,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Delete a chat message.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [messageId] ID of the message.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Message deleted successfully
  ///   * 202: Message deleted successfully, but Matterbridge is configured, so the information can be replicated elsewhere
  ///   * 400: Deleting message is not possible
  ///   * 403: Missing permissions to delete message
  ///   * 404: Message not found
  ///   * 405: Deleting message is not allowed
  ///
  /// See:
  ///  * [deleteMessage] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<ChatDeleteMessageResponseApplicationJson, ChatChatDeleteMessageHeaders> deleteMessageRaw({
    required final String token,
    required final int messageId,
    final ChatDeleteMessageApiVersion apiVersion = ChatDeleteMessageApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final messageId0 = Uri.encodeQueryComponent(messageId.toString());
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/chat/$token0/$messageId0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<ChatDeleteMessageResponseApplicationJson, ChatChatDeleteMessageHeaders>(
      response: _rootClient.executeRequest(
        'delete',
        uri,
        headers,
        body,
        const {200, 202},
      ),
      bodyType: const FullType(ChatDeleteMessageResponseApplicationJson),
      headersType: const FullType(ChatChatDeleteMessageHeaders),
      serializers: _jsonSerializers,
    );
  }

  /// Get the context of a message.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [limit] Number of chat messages to receive in both directions (50 by default, 100 at most, might return 201 messages). Defaults to `50`.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [messageId] The focused message which should be in the "middle" of the returned context.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Message context returned
  ///   * 304: No messages
  ///
  /// See:
  ///  * [getMessageContextRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<ChatGetMessageContextResponseApplicationJson, ChatChatGetMessageContextHeaders>>
      getMessageContext({
    required final String token,
    required final int messageId,
    final int limit = 50,
    final ChatGetMessageContextApiVersion apiVersion = ChatGetMessageContextApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = getMessageContextRaw(
      token: token,
      messageId: messageId,
      limit: limit,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Get the context of a message.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [limit] Number of chat messages to receive in both directions (50 by default, 100 at most, might return 201 messages). Defaults to `50`.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [messageId] The focused message which should be in the "middle" of the returned context.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Message context returned
  ///   * 304: No messages
  ///
  /// See:
  ///  * [getMessageContext] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<ChatGetMessageContextResponseApplicationJson, ChatChatGetMessageContextHeaders>
      getMessageContextRaw({
    required final String token,
    required final int messageId,
    final int limit = 50,
    final ChatGetMessageContextApiVersion apiVersion = ChatGetMessageContextApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final messageId0 = Uri.encodeQueryComponent(messageId.toString());
    if (limit != 50) {
      queryParameters['limit'] = limit.toString();
    }
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/chat/$token0/$messageId0/context';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<ChatGetMessageContextResponseApplicationJson, ChatChatGetMessageContextHeaders>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200, 304},
      ),
      bodyType: const FullType(ChatGetMessageContextResponseApplicationJson),
      headersType: const FullType(ChatChatGetMessageContextHeaders),
      serializers: _jsonSerializers,
    );
  }

  /// Get the reminder for a chat message.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [messageId] ID of the message.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Reminder returned
  ///   * 404: Message not found
  ///
  /// See:
  ///  * [getReminderRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<ChatGetReminderResponseApplicationJson, void>> getReminder({
    required final String token,
    required final int messageId,
    final ChatGetReminderApiVersion apiVersion = ChatGetReminderApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = getReminderRaw(
      token: token,
      messageId: messageId,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Get the reminder for a chat message.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [messageId] ID of the message.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Reminder returned
  ///   * 404: Message not found
  ///
  /// See:
  ///  * [getReminder] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<ChatGetReminderResponseApplicationJson, void> getReminderRaw({
    required final String token,
    required final int messageId,
    final ChatGetReminderApiVersion apiVersion = ChatGetReminderApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final messageId0 = Uri.encodeQueryComponent(messageId.toString());
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/chat/$token0/$messageId0/reminder';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<ChatGetReminderResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(ChatGetReminderResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Set a reminder for a chat message.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [timestamp] Timestamp of the reminder.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [messageId] ID of the message.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 201: Reminder created successfully
  ///   * 404: Message not found
  ///
  /// See:
  ///  * [setReminderRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<ChatSetReminderResponseApplicationJson, void>> setReminder({
    required final int timestamp,
    required final String token,
    required final int messageId,
    final ChatSetReminderApiVersion apiVersion = ChatSetReminderApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = setReminderRaw(
      timestamp: timestamp,
      token: token,
      messageId: messageId,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Set a reminder for a chat message.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [timestamp] Timestamp of the reminder.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [messageId] ID of the message.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 201: Reminder created successfully
  ///   * 404: Message not found
  ///
  /// See:
  ///  * [setReminder] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<ChatSetReminderResponseApplicationJson, void> setReminderRaw({
    required final int timestamp,
    required final String token,
    required final int messageId,
    final ChatSetReminderApiVersion apiVersion = ChatSetReminderApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    queryParameters['timestamp'] = timestamp.toString();
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final messageId0 = Uri.encodeQueryComponent(messageId.toString());
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/chat/$token0/$messageId0/reminder';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<ChatSetReminderResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {201},
      ),
      bodyType: const FullType(ChatSetReminderResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Delete a chat reminder.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [messageId] ID of the message.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Reminder deleted successfully
  ///   * 404: Message not found
  ///
  /// See:
  ///  * [deleteReminderRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<ChatDeleteReminderResponseApplicationJson, void>> deleteReminder({
    required final String token,
    required final int messageId,
    final ChatDeleteReminderApiVersion apiVersion = ChatDeleteReminderApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = deleteReminderRaw(
      token: token,
      messageId: messageId,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Delete a chat reminder.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [messageId] ID of the message.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Reminder deleted successfully
  ///   * 404: Message not found
  ///
  /// See:
  ///  * [deleteReminder] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<ChatDeleteReminderResponseApplicationJson, void> deleteReminderRaw({
    required final String token,
    required final int messageId,
    final ChatDeleteReminderApiVersion apiVersion = ChatDeleteReminderApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final messageId0 = Uri.encodeQueryComponent(messageId.toString());
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/chat/$token0/$messageId0/reminder';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<ChatDeleteReminderResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'delete',
        uri,
        headers,
        body,
        const {200, 404},
      ),
      bodyType: const FullType(ChatDeleteReminderResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Set the read marker to a specific message.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [lastReadMessage] ID if the last read message.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Read marker set successfully
  ///
  /// See:
  ///  * [setReadMarkerRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<ChatSetReadMarkerResponseApplicationJson, ChatChatSetReadMarkerHeaders>> setReadMarker({
    required final int lastReadMessage,
    required final String token,
    final ChatSetReadMarkerApiVersion apiVersion = ChatSetReadMarkerApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = setReadMarkerRaw(
      lastReadMessage: lastReadMessage,
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Set the read marker to a specific message.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [lastReadMessage] ID if the last read message.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Read marker set successfully
  ///
  /// See:
  ///  * [setReadMarker] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<ChatSetReadMarkerResponseApplicationJson, ChatChatSetReadMarkerHeaders> setReadMarkerRaw({
    required final int lastReadMessage,
    required final String token,
    final ChatSetReadMarkerApiVersion apiVersion = ChatSetReadMarkerApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    queryParameters['lastReadMessage'] = lastReadMessage.toString();
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/chat/$token0/read';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<ChatSetReadMarkerResponseApplicationJson, ChatChatSetReadMarkerHeaders>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(ChatSetReadMarkerResponseApplicationJson),
      headersType: const FullType(ChatChatSetReadMarkerHeaders),
      serializers: _jsonSerializers,
    );
  }

  /// Mark a chat as unread.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Read marker set successfully
  ///
  /// See:
  ///  * [markUnreadRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<ChatMarkUnreadResponseApplicationJson, ChatChatMarkUnreadHeaders>> markUnread({
    required final String token,
    final ChatMarkUnreadApiVersion apiVersion = ChatMarkUnreadApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = markUnreadRaw(
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Mark a chat as unread.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Read marker set successfully
  ///
  /// See:
  ///  * [markUnread] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<ChatMarkUnreadResponseApplicationJson, ChatChatMarkUnreadHeaders> markUnreadRaw({
    required final String token,
    final ChatMarkUnreadApiVersion apiVersion = ChatMarkUnreadApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/chat/$token0/read';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<ChatMarkUnreadResponseApplicationJson, ChatChatMarkUnreadHeaders>(
      response: _rootClient.executeRequest(
        'delete',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(ChatMarkUnreadResponseApplicationJson),
      headersType: const FullType(ChatChatMarkUnreadHeaders),
      serializers: _jsonSerializers,
    );
  }

  /// Search for mentions.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [search] Text to search for.
  ///   * [limit] Maximum number of results. Defaults to `20`.
  ///   * [includeStatus] Include the user statuses. Defaults to `0`.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: List of mention suggestions returned
  ///
  /// See:
  ///  * [mentionsRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<ChatMentionsResponseApplicationJson, void>> mentions({
    required final String search,
    required final String token,
    final int limit = 20,
    final int includeStatus = 0,
    final ChatMentionsApiVersion apiVersion = ChatMentionsApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = mentionsRaw(
      search: search,
      token: token,
      limit: limit,
      includeStatus: includeStatus,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Search for mentions.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [search] Text to search for.
  ///   * [limit] Maximum number of results. Defaults to `20`.
  ///   * [includeStatus] Include the user statuses. Defaults to `0`.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: List of mention suggestions returned
  ///
  /// See:
  ///  * [mentions] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<ChatMentionsResponseApplicationJson, void> mentionsRaw({
    required final String search,
    required final String token,
    final int limit = 20,
    final int includeStatus = 0,
    final ChatMentionsApiVersion apiVersion = ChatMentionsApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    queryParameters['search'] = search;
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    if (limit != 20) {
      queryParameters['limit'] = limit.toString();
    }
    if (includeStatus != 0) {
      queryParameters['includeStatus'] = includeStatus.toString();
    }
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/chat/$token0/mentions';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<ChatMentionsResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(ChatMentionsResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Get objects that are shared in the room.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [objectType] Type of the objects.
  ///   * [lastKnownMessageId] ID of the last known message. Defaults to `0`.
  ///   * [limit] Maximum number of objects. Defaults to `100`.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: List of shared objects messages returned
  ///
  /// See:
  ///  * [getObjectsSharedInRoomRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<ChatGetObjectsSharedInRoomResponseApplicationJson, ChatChatGetObjectsSharedInRoomHeaders>>
      getObjectsSharedInRoom({
    required final String objectType,
    required final String token,
    final int lastKnownMessageId = 0,
    final int limit = 100,
    final ChatGetObjectsSharedInRoomApiVersion apiVersion = ChatGetObjectsSharedInRoomApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = getObjectsSharedInRoomRaw(
      objectType: objectType,
      token: token,
      lastKnownMessageId: lastKnownMessageId,
      limit: limit,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Get objects that are shared in the room.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [objectType] Type of the objects.
  ///   * [lastKnownMessageId] ID of the last known message. Defaults to `0`.
  ///   * [limit] Maximum number of objects. Defaults to `100`.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: List of shared objects messages returned
  ///
  /// See:
  ///  * [getObjectsSharedInRoom] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<ChatGetObjectsSharedInRoomResponseApplicationJson, ChatChatGetObjectsSharedInRoomHeaders>
      getObjectsSharedInRoomRaw({
    required final String objectType,
    required final String token,
    final int lastKnownMessageId = 0,
    final int limit = 100,
    final ChatGetObjectsSharedInRoomApiVersion apiVersion = ChatGetObjectsSharedInRoomApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    queryParameters['objectType'] = objectType;
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    if (lastKnownMessageId != 0) {
      queryParameters['lastKnownMessageId'] = lastKnownMessageId.toString();
    }
    if (limit != 100) {
      queryParameters['limit'] = limit.toString();
    }
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/chat/$token0/share';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<ChatGetObjectsSharedInRoomResponseApplicationJson,
        ChatChatGetObjectsSharedInRoomHeaders>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(ChatGetObjectsSharedInRoomResponseApplicationJson),
      headersType: const FullType(ChatChatGetObjectsSharedInRoomHeaders),
      serializers: _jsonSerializers,
    );
  }

  /// Sends a rich-object to the given room.
  ///
  /// The author and timestamp are automatically set to the current user/guest and time.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [objectType] Type of the object.
  ///   * [objectId] ID of the object.
  ///   * [metaData] Additional metadata. Defaults to `''`.
  ///   * [actorDisplayName] Guest name. Defaults to `''`.
  ///   * [referenceId] Reference ID. Defaults to `''`.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 201: Object shared successfully
  ///   * 400: Sharing object is not possible
  ///   * 404: Actor not found
  ///   * 413: Message too long
  ///
  /// See:
  ///  * [shareObjectToChatRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<ChatShareObjectToChatResponseApplicationJson, ChatChatShareObjectToChatHeaders>>
      shareObjectToChat({
    required final String objectType,
    required final String objectId,
    required final String token,
    final String metaData = '',
    final String actorDisplayName = '',
    final String referenceId = '',
    final ChatShareObjectToChatApiVersion apiVersion = ChatShareObjectToChatApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = shareObjectToChatRaw(
      objectType: objectType,
      objectId: objectId,
      token: token,
      metaData: metaData,
      actorDisplayName: actorDisplayName,
      referenceId: referenceId,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Sends a rich-object to the given room.
  ///
  /// The author and timestamp are automatically set to the current user/guest and time.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [objectType] Type of the object.
  ///   * [objectId] ID of the object.
  ///   * [metaData] Additional metadata. Defaults to `''`.
  ///   * [actorDisplayName] Guest name. Defaults to `''`.
  ///   * [referenceId] Reference ID. Defaults to `''`.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 201: Object shared successfully
  ///   * 400: Sharing object is not possible
  ///   * 404: Actor not found
  ///   * 413: Message too long
  ///
  /// See:
  ///  * [shareObjectToChat] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<ChatShareObjectToChatResponseApplicationJson, ChatChatShareObjectToChatHeaders>
      shareObjectToChatRaw({
    required final String objectType,
    required final String objectId,
    required final String token,
    final String metaData = '',
    final String actorDisplayName = '',
    final String referenceId = '',
    final ChatShareObjectToChatApiVersion apiVersion = ChatShareObjectToChatApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    queryParameters['objectType'] = objectType;
    queryParameters['objectId'] = objectId;
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    if (metaData != '') {
      queryParameters['metaData'] = metaData;
    }
    if (actorDisplayName != '') {
      queryParameters['actorDisplayName'] = actorDisplayName;
    }
    if (referenceId != '') {
      queryParameters['referenceId'] = referenceId;
    }
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/chat/$token0/share';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<ChatShareObjectToChatResponseApplicationJson, ChatChatShareObjectToChatHeaders>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {201},
      ),
      bodyType: const FullType(ChatShareObjectToChatResponseApplicationJson),
      headersType: const FullType(ChatChatShareObjectToChatHeaders),
      serializers: _jsonSerializers,
    );
  }

  /// Get objects that are shared in the room overview.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [limit] Maximum number of objects. Defaults to `7`.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: List of shared objects messages of each type returned
  ///
  /// See:
  ///  * [getObjectsSharedInRoomOverviewRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<ChatGetObjectsSharedInRoomOverviewResponseApplicationJson, void>>
      getObjectsSharedInRoomOverview({
    required final String token,
    final int limit = 7,
    final ChatGetObjectsSharedInRoomOverviewApiVersion apiVersion = ChatGetObjectsSharedInRoomOverviewApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = getObjectsSharedInRoomOverviewRaw(
      token: token,
      limit: limit,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Get objects that are shared in the room overview.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [limit] Maximum number of objects. Defaults to `7`.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: List of shared objects messages of each type returned
  ///
  /// See:
  ///  * [getObjectsSharedInRoomOverview] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<ChatGetObjectsSharedInRoomOverviewResponseApplicationJson, void>
      getObjectsSharedInRoomOverviewRaw({
    required final String token,
    final int limit = 7,
    final ChatGetObjectsSharedInRoomOverviewApiVersion apiVersion = ChatGetObjectsSharedInRoomOverviewApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    if (limit != 7) {
      queryParameters['limit'] = limit.toString();
    }
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/chat/$token0/share/overview';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<ChatGetObjectsSharedInRoomOverviewResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(ChatGetObjectsSharedInRoomOverviewResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }
}

class FederationClient {
  FederationClient(this._rootClient);

  final Client _rootClient;

  /// Accept a federation invites.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [id] ID of the share.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Invite accepted successfully
  ///   * 500
  ///
  /// See:
  ///  * [acceptShareRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<FederationAcceptShareResponseApplicationJson, void>> acceptShare({
    required final int id,
    final FederationAcceptShareApiVersion apiVersion = FederationAcceptShareApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = acceptShareRaw(
      id: id,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Accept a federation invites.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [id] ID of the share.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Invite accepted successfully
  ///   * 500
  ///
  /// See:
  ///  * [acceptShare] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<FederationAcceptShareResponseApplicationJson, void> acceptShareRaw({
    required final int id,
    final FederationAcceptShareApiVersion apiVersion = FederationAcceptShareApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    final id0 = Uri.encodeQueryComponent(id.toString());
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/federation/invitation/$id0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<FederationAcceptShareResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(FederationAcceptShareResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Decline a federation invites.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [id] ID of the share.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Invite declined successfully
  ///   * 500
  ///
  /// See:
  ///  * [rejectShareRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<FederationRejectShareResponseApplicationJson, void>> rejectShare({
    required final int id,
    final FederationRejectShareApiVersion apiVersion = FederationRejectShareApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = rejectShareRaw(
      id: id,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Decline a federation invites.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [id] ID of the share.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Invite declined successfully
  ///   * 500
  ///
  /// See:
  ///  * [rejectShare] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<FederationRejectShareResponseApplicationJson, void> rejectShareRaw({
    required final int id,
    final FederationRejectShareApiVersion apiVersion = FederationRejectShareApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    final id0 = Uri.encodeQueryComponent(id.toString());
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/federation/invitation/$id0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<FederationRejectShareResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'delete',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(FederationRejectShareResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Get a list of federation invites.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Get list of received federation invites successfully
  ///
  /// See:
  ///  * [getSharesRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<FederationGetSharesResponseApplicationJson, void>> getShares({
    final FederationGetSharesApiVersion apiVersion = FederationGetSharesApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = getSharesRaw(
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Get a list of federation invites.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Get list of received federation invites successfully
  ///
  /// See:
  ///  * [getShares] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<FederationGetSharesResponseApplicationJson, void> getSharesRaw({
    final FederationGetSharesApiVersion apiVersion = FederationGetSharesApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/federation/invitation';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<FederationGetSharesResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(FederationGetSharesResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }
}

class FilesIntegrationClient {
  FilesIntegrationClient(this._rootClient);

  final Client _rootClient;

  /// Get the token of the room associated to the given file id.
  ///
  /// This is the counterpart of self::getRoomByShareToken() for file ids instead of share tokens, although both return the same room token if the given file id and share token refer to the same file.
  /// If there is no room associated to the given file id a new room is created; the new room is a public room associated with a "file" object with the given file id. Unlike normal rooms in which the owner is the user that created the room these are special rooms without owner (although self joined users with direct access to the file become persistent participants automatically when they join until they explicitly leave or no longer have access to the file).
  /// In any case, to create or even get the token of the room, the file must be shared and the user must be the owner of a public share of the file (like a link share, for example) or have direct access to that file; an error is returned otherwise. A user has direct access to a file if she has access to it (or to an ancestor) through a user, group, circle or room share (but not through a link share, for example), or if she is the owner of such a file.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [fileId] ID of the file.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Room token returned
  ///   * 400: Rooms not allowed for shares
  ///   * 404: Share not found
  ///
  /// See:
  ///  * [getRoomByFileIdRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<FilesIntegrationGetRoomByFileIdResponseApplicationJson, void>> getRoomByFileId({
    required final String fileId,
    final FilesIntegrationGetRoomByFileIdApiVersion apiVersion = FilesIntegrationGetRoomByFileIdApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = getRoomByFileIdRaw(
      fileId: fileId,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Get the token of the room associated to the given file id.
  ///
  /// This is the counterpart of self::getRoomByShareToken() for file ids instead of share tokens, although both return the same room token if the given file id and share token refer to the same file.
  /// If there is no room associated to the given file id a new room is created; the new room is a public room associated with a "file" object with the given file id. Unlike normal rooms in which the owner is the user that created the room these are special rooms without owner (although self joined users with direct access to the file become persistent participants automatically when they join until they explicitly leave or no longer have access to the file).
  /// In any case, to create or even get the token of the room, the file must be shared and the user must be the owner of a public share of the file (like a link share, for example) or have direct access to that file; an error is returned otherwise. A user has direct access to a file if she has access to it (or to an ancestor) through a user, group, circle or room share (but not through a link share, for example), or if she is the owner of such a file.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [fileId] ID of the file.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Room token returned
  ///   * 400: Rooms not allowed for shares
  ///   * 404: Share not found
  ///
  /// See:
  ///  * [getRoomByFileId] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<FilesIntegrationGetRoomByFileIdResponseApplicationJson, void> getRoomByFileIdRaw({
    required final String fileId,
    final FilesIntegrationGetRoomByFileIdApiVersion apiVersion = FilesIntegrationGetRoomByFileIdApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    checkPattern(fileId, RegExp(r'^.+$'), 'fileId'); // coverage:ignore-line
    final fileId0 = Uri.encodeQueryComponent(fileId);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/file/$fileId0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<FilesIntegrationGetRoomByFileIdResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(FilesIntegrationGetRoomByFileIdResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Returns the token of the room associated to the file id of the given share token.
  ///
  /// This is the counterpart of self::getRoomByFileId() for share tokens instead of file ids, although both return the same room token if the given file id and share token refer to the same file.
  /// If there is no room associated to the file id of the given share token a new room is created; the new room is a public room associated with a "file" object with the file id of the given share token. Unlike normal rooms in which the owner is the user that created the room these are special rooms without owner (although self joined users with direct access to the file become persistent participants automatically when they join until they explicitly leave or no longer have access to the file).
  /// In any case, to create or even get the token of the room, the file must be publicly shared (like a link share, for example); an error is returned otherwise.
  /// Besides the token of the room this also returns the current user ID and display name, if any; this is needed by the Talk sidebar to know the actual current user, as the public share page uses the incognito mode and thus logged-in users as seen as guests.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [shareToken] Token of the file share.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Room token and user info returned
  ///   * 400: Rooms not allowed for shares
  ///   * 404: Share not found
  ///
  /// See:
  ///  * [getRoomByShareTokenRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<FilesIntegrationGetRoomByShareTokenResponseApplicationJson, void>> getRoomByShareToken({
    required final String shareToken,
    final FilesIntegrationGetRoomByShareTokenApiVersion apiVersion = FilesIntegrationGetRoomByShareTokenApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = getRoomByShareTokenRaw(
      shareToken: shareToken,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Returns the token of the room associated to the file id of the given share token.
  ///
  /// This is the counterpart of self::getRoomByFileId() for share tokens instead of file ids, although both return the same room token if the given file id and share token refer to the same file.
  /// If there is no room associated to the file id of the given share token a new room is created; the new room is a public room associated with a "file" object with the file id of the given share token. Unlike normal rooms in which the owner is the user that created the room these are special rooms without owner (although self joined users with direct access to the file become persistent participants automatically when they join until they explicitly leave or no longer have access to the file).
  /// In any case, to create or even get the token of the room, the file must be publicly shared (like a link share, for example); an error is returned otherwise.
  /// Besides the token of the room this also returns the current user ID and display name, if any; this is needed by the Talk sidebar to know the actual current user, as the public share page uses the incognito mode and thus logged-in users as seen as guests.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [shareToken] Token of the file share.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Room token and user info returned
  ///   * 400: Rooms not allowed for shares
  ///   * 404: Share not found
  ///
  /// See:
  ///  * [getRoomByShareToken] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<FilesIntegrationGetRoomByShareTokenResponseApplicationJson, void> getRoomByShareTokenRaw({
    required final String shareToken,
    final FilesIntegrationGetRoomByShareTokenApiVersion apiVersion = FilesIntegrationGetRoomByShareTokenApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    checkPattern(shareToken, RegExp(r'^.+$'), 'shareToken'); // coverage:ignore-line
    final shareToken0 = Uri.encodeQueryComponent(shareToken);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/publicshare/$shareToken0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<FilesIntegrationGetRoomByShareTokenResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(FilesIntegrationGetRoomByShareTokenResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }
}

class GuestClient {
  GuestClient(this._rootClient);

  final Client _rootClient;

  /// Set the display name as a guest.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [displayName] New display name.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Display name updated successfully
  ///   * 403: Not a guest
  ///   * 404: Not a participant
  ///
  /// See:
  ///  * [setDisplayNameRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<GuestSetDisplayNameResponseApplicationJson, void>> setDisplayName({
    required final String displayName,
    required final String token,
    final GuestSetDisplayNameApiVersion apiVersion = GuestSetDisplayNameApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = setDisplayNameRaw(
      displayName: displayName,
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Set the display name as a guest.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [displayName] New display name.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Display name updated successfully
  ///   * 403: Not a guest
  ///   * 404: Not a participant
  ///
  /// See:
  ///  * [setDisplayName] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<GuestSetDisplayNameResponseApplicationJson, void> setDisplayNameRaw({
    required final String displayName,
    required final String token,
    final GuestSetDisplayNameApiVersion apiVersion = GuestSetDisplayNameApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    queryParameters['displayName'] = displayName;
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/guest/$token0/name';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<GuestSetDisplayNameResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200, 403, 404},
      ),
      bodyType: const FullType(GuestSetDisplayNameResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }
}

class HostedSignalingServerClient {
  HostedSignalingServerClient(this._rootClient);

  final Client _rootClient;

  /// Request a trial account.
  ///
  /// This endpoint requires admin access.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [url] Server URL.
  ///   * [name] Display name of the user.
  ///   * [email] Email of the user.
  ///   * [language] Language of the user.
  ///   * [country] Country of the user.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Trial requested successfully
  ///   * 400: Requesting trial is not possible
  ///   * 500
  ///
  /// See:
  ///  * [requestTrialRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<HostedSignalingServerRequestTrialResponseApplicationJson, void>> requestTrial({
    required final String url,
    required final String name,
    required final String email,
    required final String language,
    required final String country,
    final HostedSignalingServerRequestTrialApiVersion apiVersion = HostedSignalingServerRequestTrialApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = requestTrialRaw(
      url: url,
      name: name,
      email: email,
      language: language,
      country: country,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Request a trial account.
  ///
  /// This endpoint requires admin access.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [url] Server URL.
  ///   * [name] Display name of the user.
  ///   * [email] Email of the user.
  ///   * [language] Language of the user.
  ///   * [country] Country of the user.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Trial requested successfully
  ///   * 400: Requesting trial is not possible
  ///   * 500
  ///
  /// See:
  ///  * [requestTrial] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<HostedSignalingServerRequestTrialResponseApplicationJson, void> requestTrialRaw({
    required final String url,
    required final String name,
    required final String email,
    required final String language,
    required final String country,
    final HostedSignalingServerRequestTrialApiVersion apiVersion = HostedSignalingServerRequestTrialApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    queryParameters['url'] = url;
    queryParameters['name'] = name;
    queryParameters['email'] = email;
    queryParameters['language'] = language;
    queryParameters['country'] = country;
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/hostedsignalingserver/requesttrial';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<HostedSignalingServerRequestTrialResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(HostedSignalingServerRequestTrialResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Delete the account.
  ///
  /// This endpoint requires admin access.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 204: Account deleted successfully
  ///   * 400: Deleting account is not possible
  ///   * 500
  ///
  /// See:
  ///  * [deleteAccountRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<HostedSignalingServerDeleteAccountResponseApplicationJson, void>> deleteAccount({
    final HostedSignalingServerDeleteAccountApiVersion apiVersion = HostedSignalingServerDeleteAccountApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = deleteAccountRaw(
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Delete the account.
  ///
  /// This endpoint requires admin access.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 204: Account deleted successfully
  ///   * 400: Deleting account is not possible
  ///   * 500
  ///
  /// See:
  ///  * [deleteAccount] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<HostedSignalingServerDeleteAccountResponseApplicationJson, void> deleteAccountRaw({
    final HostedSignalingServerDeleteAccountApiVersion apiVersion = HostedSignalingServerDeleteAccountApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/hostedsignalingserver/delete';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<HostedSignalingServerDeleteAccountResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'delete',
        uri,
        headers,
        body,
        const {204},
      ),
      bodyType: const FullType(HostedSignalingServerDeleteAccountResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }
}

class MatterbridgeClient {
  MatterbridgeClient(this._rootClient);

  final Client _rootClient;

  /// Get bridge information of one room.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Return list of configured bridges
  ///
  /// See:
  ///  * [getBridgeOfRoomRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<MatterbridgeGetBridgeOfRoomResponseApplicationJson, void>> getBridgeOfRoom({
    required final String token,
    final MatterbridgeGetBridgeOfRoomApiVersion apiVersion = MatterbridgeGetBridgeOfRoomApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = getBridgeOfRoomRaw(
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Get bridge information of one room.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Return list of configured bridges
  ///
  /// See:
  ///  * [getBridgeOfRoom] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<MatterbridgeGetBridgeOfRoomResponseApplicationJson, void> getBridgeOfRoomRaw({
    required final String token,
    final MatterbridgeGetBridgeOfRoomApiVersion apiVersion = MatterbridgeGetBridgeOfRoomApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/bridge/$token0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<MatterbridgeGetBridgeOfRoomResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(MatterbridgeGetBridgeOfRoomResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Edit bridge information of one room.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [enabled] If the bridge should be enabled.
  ///   * [parts] New parts.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Bridge edited successfully
  ///   * 406: Editing bridge is not possible
  ///
  /// See:
  ///  * [editBridgeOfRoomRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<MatterbridgeEditBridgeOfRoomResponseApplicationJson, void>> editBridgeOfRoom({
    required final int enabled,
    required final String token,
    final ContentString<BuiltList<BuiltMap<String, JsonObject>>>? parts,
    final MatterbridgeEditBridgeOfRoomApiVersion apiVersion = MatterbridgeEditBridgeOfRoomApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = editBridgeOfRoomRaw(
      enabled: enabled,
      token: token,
      parts: parts,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Edit bridge information of one room.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [enabled] If the bridge should be enabled.
  ///   * [parts] New parts.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Bridge edited successfully
  ///   * 406: Editing bridge is not possible
  ///
  /// See:
  ///  * [editBridgeOfRoom] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<MatterbridgeEditBridgeOfRoomResponseApplicationJson, void> editBridgeOfRoomRaw({
    required final int enabled,
    required final String token,
    final ContentString<BuiltList<BuiltMap<String, JsonObject>>>? parts,
    final MatterbridgeEditBridgeOfRoomApiVersion apiVersion = MatterbridgeEditBridgeOfRoomApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    queryParameters['enabled'] = enabled.toString();
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    if (parts != null) {
      queryParameters['parts'] = _jsonSerializers.serialize(
        parts,
        specifiedType: const FullType(ContentString, [
          FullType(BuiltList, [
            FullType(BuiltMap, [FullType(String), FullType(JsonObject)]),
          ]),
        ]),
      );
    }
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/bridge/$token0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<MatterbridgeEditBridgeOfRoomResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'put',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(MatterbridgeEditBridgeOfRoomResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Delete bridge of one room.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Bridge deleted successfully
  ///   * 406: Deleting bridge is not possible
  ///
  /// See:
  ///  * [deleteBridgeOfRoomRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<MatterbridgeDeleteBridgeOfRoomResponseApplicationJson, void>> deleteBridgeOfRoom({
    required final String token,
    final MatterbridgeDeleteBridgeOfRoomApiVersion apiVersion = MatterbridgeDeleteBridgeOfRoomApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = deleteBridgeOfRoomRaw(
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Delete bridge of one room.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Bridge deleted successfully
  ///   * 406: Deleting bridge is not possible
  ///
  /// See:
  ///  * [deleteBridgeOfRoom] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<MatterbridgeDeleteBridgeOfRoomResponseApplicationJson, void> deleteBridgeOfRoomRaw({
    required final String token,
    final MatterbridgeDeleteBridgeOfRoomApiVersion apiVersion = MatterbridgeDeleteBridgeOfRoomApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/bridge/$token0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<MatterbridgeDeleteBridgeOfRoomResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'delete',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(MatterbridgeDeleteBridgeOfRoomResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Get bridge process information.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Return list of running processes
  ///
  /// See:
  ///  * [getBridgeProcessStateRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<MatterbridgeGetBridgeProcessStateResponseApplicationJson, void>> getBridgeProcessState({
    required final String token,
    final MatterbridgeGetBridgeProcessStateApiVersion apiVersion = MatterbridgeGetBridgeProcessStateApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = getBridgeProcessStateRaw(
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Get bridge process information.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Return list of running processes
  ///
  /// See:
  ///  * [getBridgeProcessState] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<MatterbridgeGetBridgeProcessStateResponseApplicationJson, void> getBridgeProcessStateRaw({
    required final String token,
    final MatterbridgeGetBridgeProcessStateApiVersion apiVersion = MatterbridgeGetBridgeProcessStateApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/bridge/$token0/process';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<MatterbridgeGetBridgeProcessStateResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(MatterbridgeGetBridgeProcessStateResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }
}

class MatterbridgeSettingsClient {
  MatterbridgeSettingsClient(this._rootClient);

  final Client _rootClient;

  /// Stop all bridges.
  ///
  /// This endpoint requires admin access.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: All bridges stopped successfully
  ///   * 406: Stopping all bridges is not possible
  ///
  /// See:
  ///  * [stopAllBridgesRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<MatterbridgeSettingsStopAllBridgesResponseApplicationJson, void>> stopAllBridges({
    final MatterbridgeSettingsStopAllBridgesApiVersion apiVersion = MatterbridgeSettingsStopAllBridgesApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = stopAllBridgesRaw(
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Stop all bridges.
  ///
  /// This endpoint requires admin access.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: All bridges stopped successfully
  ///   * 406: Stopping all bridges is not possible
  ///
  /// See:
  ///  * [stopAllBridges] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<MatterbridgeSettingsStopAllBridgesResponseApplicationJson, void> stopAllBridgesRaw({
    final MatterbridgeSettingsStopAllBridgesApiVersion apiVersion = MatterbridgeSettingsStopAllBridgesApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/bridge';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<MatterbridgeSettingsStopAllBridgesResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'delete',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(MatterbridgeSettingsStopAllBridgesResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Get Matterbridge version.
  ///
  /// This endpoint requires admin access.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Bridge version returned
  ///   * 400: Getting bridge version is not possible
  ///
  /// See:
  ///  * [getMatterbridgeVersionRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson, void>>
      getMatterbridgeVersion({
    final MatterbridgeSettingsGetMatterbridgeVersionApiVersion apiVersion =
        MatterbridgeSettingsGetMatterbridgeVersionApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = getMatterbridgeVersionRaw(
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Get Matterbridge version.
  ///
  /// This endpoint requires admin access.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Bridge version returned
  ///   * 400: Getting bridge version is not possible
  ///
  /// See:
  ///  * [getMatterbridgeVersion] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson, void>
      getMatterbridgeVersionRaw({
    final MatterbridgeSettingsGetMatterbridgeVersionApiVersion apiVersion =
        MatterbridgeSettingsGetMatterbridgeVersionApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/bridge/version';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }
}

class PollClient {
  PollClient(this._rootClient);

  final Client _rootClient;

  /// Create a poll.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [question] Question of the poll.
  ///   * [options] Options of the poll.
  ///   * [resultMode] Mode how the results will be shown.
  ///   * [maxVotes] Number of maximum votes per voter.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 201: Poll created successfully
  ///   * 400: Creating poll is not possible
  ///
  /// See:
  ///  * [createPollRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<PollCreatePollResponseApplicationJson, void>> createPoll({
    required final String question,
    required final List<String> options,
    required final int resultMode,
    required final int maxVotes,
    required final String token,
    final PollCreatePollApiVersion apiVersion = PollCreatePollApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = createPollRaw(
      question: question,
      options: options,
      resultMode: resultMode,
      maxVotes: maxVotes,
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Create a poll.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [question] Question of the poll.
  ///   * [options] Options of the poll.
  ///   * [resultMode] Mode how the results will be shown.
  ///   * [maxVotes] Number of maximum votes per voter.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 201: Poll created successfully
  ///   * 400: Creating poll is not possible
  ///
  /// See:
  ///  * [createPoll] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<PollCreatePollResponseApplicationJson, void> createPollRaw({
    required final String question,
    required final List<String> options,
    required final int resultMode,
    required final int maxVotes,
    required final String token,
    final PollCreatePollApiVersion apiVersion = PollCreatePollApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    queryParameters['question'] = question;
    queryParameters['options[]'] = options.map((final e) => e);
    queryParameters['resultMode'] = resultMode.toString();
    queryParameters['maxVotes'] = maxVotes.toString();
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/poll/$token0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<PollCreatePollResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {201},
      ),
      bodyType: const FullType(PollCreatePollResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Get a poll.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [pollId] ID of the poll.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Poll returned
  ///   * 404: Poll not found
  ///
  /// See:
  ///  * [showPollRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<PollShowPollResponseApplicationJson, void>> showPoll({
    required final String token,
    required final int pollId,
    final PollShowPollApiVersion apiVersion = PollShowPollApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = showPollRaw(
      token: token,
      pollId: pollId,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Get a poll.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [pollId] ID of the poll.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Poll returned
  ///   * 404: Poll not found
  ///
  /// See:
  ///  * [showPoll] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<PollShowPollResponseApplicationJson, void> showPollRaw({
    required final String token,
    required final int pollId,
    final PollShowPollApiVersion apiVersion = PollShowPollApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final pollId0 = Uri.encodeQueryComponent(pollId.toString());
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/poll/$token0/$pollId0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<PollShowPollResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(PollShowPollResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Vote on a poll.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [optionIds] IDs of the selected options. Defaults to `[]`.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [pollId] ID of the poll.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Voted successfully
  ///   * 400: Voting is not possible
  ///   * 404: Poll not found
  ///
  /// See:
  ///  * [votePollRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<PollVotePollResponseApplicationJson, void>> votePoll({
    required final String token,
    required final int pollId,
    final List<int> optionIds = const <int>[],
    final PollVotePollApiVersion apiVersion = PollVotePollApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = votePollRaw(
      token: token,
      pollId: pollId,
      optionIds: optionIds,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Vote on a poll.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [optionIds] IDs of the selected options. Defaults to `[]`.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [pollId] ID of the poll.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Voted successfully
  ///   * 400: Voting is not possible
  ///   * 404: Poll not found
  ///
  /// See:
  ///  * [votePoll] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<PollVotePollResponseApplicationJson, void> votePollRaw({
    required final String token,
    required final int pollId,
    final List<int> optionIds = const <int>[],
    final PollVotePollApiVersion apiVersion = PollVotePollApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final pollId0 = Uri.encodeQueryComponent(pollId.toString());
    if (optionIds != const <int>[]) {
      queryParameters['optionIds[]'] = optionIds.map((final e) => e.toString());
    }
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/poll/$token0/$pollId0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<PollVotePollResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(PollVotePollResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Close a poll.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [pollId] ID of the poll.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Poll closed successfully
  ///   * 400: Poll already closed
  ///   * 403: Missing permissions to close poll
  ///   * 404: Poll not found
  ///   * 500
  ///
  /// See:
  ///  * [closePollRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<PollClosePollResponseApplicationJson, void>> closePoll({
    required final String token,
    required final int pollId,
    final PollClosePollApiVersion apiVersion = PollClosePollApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = closePollRaw(
      token: token,
      pollId: pollId,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Close a poll.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [pollId] ID of the poll.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Poll closed successfully
  ///   * 400: Poll already closed
  ///   * 403: Missing permissions to close poll
  ///   * 404: Poll not found
  ///   * 500
  ///
  /// See:
  ///  * [closePoll] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<PollClosePollResponseApplicationJson, void> closePollRaw({
    required final String token,
    required final int pollId,
    final PollClosePollApiVersion apiVersion = PollClosePollApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final pollId0 = Uri.encodeQueryComponent(pollId.toString());
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/poll/$token0/$pollId0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<PollClosePollResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'delete',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(PollClosePollResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }
}

class PublicShareAuthClient {
  PublicShareAuthClient(this._rootClient);

  final Client _rootClient;

  /// Creates a new room for requesting the password of a share.
  ///
  /// The new room is a public room associated with a "share:password" object with the ID of the share token. Unlike normal rooms in which the owner is the user that created the room these are special rooms always created by a guest or user on behalf of a registered user, the sharer, who will be the owner of the room.
  /// The share must have "send password by Talk" enabled; an error is returned otherwise.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [shareToken] Token of the file share.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 201: Room created successfully
  ///   * 404: Share not found
  ///
  /// See:
  ///  * [createRoomRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<PublicShareAuthCreateRoomResponseApplicationJson, void>> createRoom({
    required final String shareToken,
    final PublicShareAuthCreateRoomApiVersion apiVersion = PublicShareAuthCreateRoomApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = createRoomRaw(
      shareToken: shareToken,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Creates a new room for requesting the password of a share.
  ///
  /// The new room is a public room associated with a "share:password" object with the ID of the share token. Unlike normal rooms in which the owner is the user that created the room these are special rooms always created by a guest or user on behalf of a registered user, the sharer, who will be the owner of the room.
  /// The share must have "send password by Talk" enabled; an error is returned otherwise.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [shareToken] Token of the file share.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 201: Room created successfully
  ///   * 404: Share not found
  ///
  /// See:
  ///  * [createRoom] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<PublicShareAuthCreateRoomResponseApplicationJson, void> createRoomRaw({
    required final String shareToken,
    final PublicShareAuthCreateRoomApiVersion apiVersion = PublicShareAuthCreateRoomApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    queryParameters['shareToken'] = shareToken;
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/publicshareauth';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<PublicShareAuthCreateRoomResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {201},
      ),
      bodyType: const FullType(PublicShareAuthCreateRoomResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }
}

class ReactionClient {
  ReactionClient(this._rootClient);

  final Client _rootClient;

  /// Get a list of reactions for a message.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [reaction] Emoji to filter.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [messageId] ID of the message.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Reactions returned
  ///   * 404: Message or reaction not found
  ///
  /// See:
  ///  * [getReactionsRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<ReactionGetReactionsResponseApplicationJson, void>> getReactions({
    required final String token,
    required final int messageId,
    final String? reaction,
    final ReactionGetReactionsApiVersion apiVersion = ReactionGetReactionsApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = getReactionsRaw(
      token: token,
      messageId: messageId,
      reaction: reaction,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Get a list of reactions for a message.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [reaction] Emoji to filter.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [messageId] ID of the message.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Reactions returned
  ///   * 404: Message or reaction not found
  ///
  /// See:
  ///  * [getReactions] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<ReactionGetReactionsResponseApplicationJson, void> getReactionsRaw({
    required final String token,
    required final int messageId,
    final String? reaction,
    final ReactionGetReactionsApiVersion apiVersion = ReactionGetReactionsApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final messageId0 = Uri.encodeQueryComponent(messageId.toString());
    if (reaction != null) {
      queryParameters['reaction'] = reaction;
    }
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/reaction/$token0/$messageId0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<ReactionGetReactionsResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(ReactionGetReactionsResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Add a reaction to a message.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [reaction] Emoji to add.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [messageId] ID of the message.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Reaction already existed
  ///   * 201: Reaction added successfully
  ///   * 400: Adding reaction is not possible
  ///   * 404: Message not found
  ///
  /// See:
  ///  * [reactRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<ReactionReactResponseApplicationJson, void>> react({
    required final String reaction,
    required final String token,
    required final int messageId,
    final ReactionReactApiVersion apiVersion = ReactionReactApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = reactRaw(
      reaction: reaction,
      token: token,
      messageId: messageId,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Add a reaction to a message.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [reaction] Emoji to add.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [messageId] ID of the message.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Reaction already existed
  ///   * 201: Reaction added successfully
  ///   * 400: Adding reaction is not possible
  ///   * 404: Message not found
  ///
  /// See:
  ///  * [react] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<ReactionReactResponseApplicationJson, void> reactRaw({
    required final String reaction,
    required final String token,
    required final int messageId,
    final ReactionReactApiVersion apiVersion = ReactionReactApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    queryParameters['reaction'] = reaction;
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final messageId0 = Uri.encodeQueryComponent(messageId.toString());
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/reaction/$token0/$messageId0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<ReactionReactResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200, 201},
      ),
      bodyType: const FullType(ReactionReactResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Delete a reaction from a message.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [reaction] Emoji to remove.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [messageId] ID of the message.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Reaction deleted successfully
  ///   * 400: Deleting reaction is not possible
  ///   * 404: Message not found
  ///
  /// See:
  ///  * [deleteRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<ReactionDeleteResponseApplicationJson, void>> delete({
    required final String reaction,
    required final String token,
    required final int messageId,
    final ReactionDeleteApiVersion apiVersion = ReactionDeleteApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = deleteRaw(
      reaction: reaction,
      token: token,
      messageId: messageId,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Delete a reaction from a message.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [reaction] Emoji to remove.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [messageId] ID of the message.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Reaction deleted successfully
  ///   * 400: Deleting reaction is not possible
  ///   * 404: Message not found
  ///
  /// See:
  ///  * [delete] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<ReactionDeleteResponseApplicationJson, void> deleteRaw({
    required final String reaction,
    required final String token,
    required final int messageId,
    final ReactionDeleteApiVersion apiVersion = ReactionDeleteApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    queryParameters['reaction'] = reaction;
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final messageId0 = Uri.encodeQueryComponent(messageId.toString());
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/reaction/$token0/$messageId0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<ReactionDeleteResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'delete',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(ReactionDeleteResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }
}

class RecordingClient {
  RecordingClient(this._rootClient);

  final Client _rootClient;

  /// Get the welcome message of a recording server.
  ///
  /// This endpoint requires admin access.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [serverId] ID of the server.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Welcome message returned
  ///   * 404: Recording server not found or not configured
  ///   * 500
  ///
  /// See:
  ///  * [getWelcomeMessageRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RecordingGetWelcomeMessageResponseApplicationJson, void>> getWelcomeMessage({
    required final int serverId,
    final RecordingGetWelcomeMessageApiVersion apiVersion = RecordingGetWelcomeMessageApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = getWelcomeMessageRaw(
      serverId: serverId,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Get the welcome message of a recording server.
  ///
  /// This endpoint requires admin access.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [serverId] ID of the server.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Welcome message returned
  ///   * 404: Recording server not found or not configured
  ///   * 500
  ///
  /// See:
  ///  * [getWelcomeMessage] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RecordingGetWelcomeMessageResponseApplicationJson, void> getWelcomeMessageRaw({
    required final int serverId,
    final RecordingGetWelcomeMessageApiVersion apiVersion = RecordingGetWelcomeMessageApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    final serverId0 = Uri.encodeQueryComponent(serverId.toString());
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/recording/welcome/$serverId0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RecordingGetWelcomeMessageResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(RecordingGetWelcomeMessageResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Start the recording.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [status] Type of the recording.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Recording started successfully
  ///   * 400: Starting recording is not possible
  ///
  /// See:
  ///  * [startRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RecordingStartResponseApplicationJson, void>> start({
    required final int status,
    required final String token,
    final RecordingStartApiVersion apiVersion = RecordingStartApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = startRaw(
      status: status,
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Start the recording.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [status] Type of the recording.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Recording started successfully
  ///   * 400: Starting recording is not possible
  ///
  /// See:
  ///  * [start] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RecordingStartResponseApplicationJson, void> startRaw({
    required final int status,
    required final String token,
    final RecordingStartApiVersion apiVersion = RecordingStartApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    queryParameters['status'] = status.toString();
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/recording/$token0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RecordingStartResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(RecordingStartResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Stop the recording.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Recording stopped successfully
  ///   * 400: Stopping recording is not possible
  ///
  /// See:
  ///  * [stopRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RecordingStopResponseApplicationJson, void>> stop({
    required final String token,
    final RecordingStopApiVersion apiVersion = RecordingStopApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = stopRaw(
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Stop the recording.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Recording stopped successfully
  ///   * 400: Stopping recording is not possible
  ///
  /// See:
  ///  * [stop] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RecordingStopResponseApplicationJson, void> stopRaw({
    required final String token,
    final RecordingStopApiVersion apiVersion = RecordingStopApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/recording/$token0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RecordingStopResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'delete',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(RecordingStopResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Store the recording.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [owner] User that will own the recording file.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Recording stored successfully
  ///   * 400: Storing recording is not possible
  ///   * 401: Missing permissions to store recording
  ///
  /// See:
  ///  * [storeRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RecordingStoreResponseApplicationJson, void>> store({
    required final String owner,
    required final String token,
    final RecordingStoreApiVersion apiVersion = RecordingStoreApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = storeRaw(
      owner: owner,
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Store the recording.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [owner] User that will own the recording file.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Recording stored successfully
  ///   * 400: Storing recording is not possible
  ///   * 401: Missing permissions to store recording
  ///
  /// See:
  ///  * [store] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RecordingStoreResponseApplicationJson, void> storeRaw({
    required final String owner,
    required final String token,
    final RecordingStoreApiVersion apiVersion = RecordingStoreApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    queryParameters['owner'] = owner;
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/recording/$token0/store';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RecordingStoreResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(RecordingStoreResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Dismiss the store call recording notification.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [timestamp] Timestamp of the notification to be dismissed.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Notification dismissed successfully
  ///   * 400: Dismissing notification is not possible
  ///
  /// See:
  ///  * [notificationDismissRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RecordingNotificationDismissResponseApplicationJson, void>> notificationDismiss({
    required final int timestamp,
    required final String token,
    final RecordingNotificationDismissApiVersion apiVersion = RecordingNotificationDismissApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = notificationDismissRaw(
      timestamp: timestamp,
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Dismiss the store call recording notification.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [timestamp] Timestamp of the notification to be dismissed.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Notification dismissed successfully
  ///   * 400: Dismissing notification is not possible
  ///
  /// See:
  ///  * [notificationDismiss] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RecordingNotificationDismissResponseApplicationJson, void> notificationDismissRaw({
    required final int timestamp,
    required final String token,
    final RecordingNotificationDismissApiVersion apiVersion = RecordingNotificationDismissApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    queryParameters['timestamp'] = timestamp.toString();
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/recording/$token0/notification';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RecordingNotificationDismissResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'delete',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(RecordingNotificationDismissResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Share the recorded file to the chat.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [fileId] ID of the file.
  ///   * [timestamp] Timestamp of the notification to be dismissed.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Recording shared to chat successfully
  ///   * 400: Sharing recording to chat is not possible
  ///
  /// See:
  ///  * [shareToChatRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RecordingShareToChatResponseApplicationJson, void>> shareToChat({
    required final int fileId,
    required final int timestamp,
    required final String token,
    final RecordingShareToChatApiVersion apiVersion = RecordingShareToChatApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = shareToChatRaw(
      fileId: fileId,
      timestamp: timestamp,
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Share the recorded file to the chat.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [fileId] ID of the file.
  ///   * [timestamp] Timestamp of the notification to be dismissed.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Recording shared to chat successfully
  ///   * 400: Sharing recording to chat is not possible
  ///
  /// See:
  ///  * [shareToChat] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RecordingShareToChatResponseApplicationJson, void> shareToChatRaw({
    required final int fileId,
    required final int timestamp,
    required final String token,
    final RecordingShareToChatApiVersion apiVersion = RecordingShareToChatApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    queryParameters['fileId'] = fileId.toString();
    queryParameters['timestamp'] = timestamp.toString();
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/recording/$token0/share-chat';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RecordingShareToChatResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(RecordingShareToChatResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }
}

class RoomClient {
  RoomClient(this._rootClient);

  final Client _rootClient;

  /// Get all currently existent rooms which the user has joined.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [noStatusUpdate] When the user status should not be automatically set to online set to 1 (default 0). Defaults to `0`.
  ///   * [includeStatus] Include the user status. Defaults to `0`.
  ///   * [modifiedSince] Filter rooms modified after a timestamp. Defaults to `0`.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Return list of rooms
  ///
  /// See:
  ///  * [getRoomsRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomGetRoomsResponseApplicationJson, RoomRoomGetRoomsHeaders>> getRooms({
    final int noStatusUpdate = 0,
    final int includeStatus = 0,
    final int modifiedSince = 0,
    final RoomGetRoomsApiVersion apiVersion = RoomGetRoomsApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = getRoomsRaw(
      noStatusUpdate: noStatusUpdate,
      includeStatus: includeStatus,
      modifiedSince: modifiedSince,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Get all currently existent rooms which the user has joined.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [noStatusUpdate] When the user status should not be automatically set to online set to 1 (default 0). Defaults to `0`.
  ///   * [includeStatus] Include the user status. Defaults to `0`.
  ///   * [modifiedSince] Filter rooms modified after a timestamp. Defaults to `0`.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Return list of rooms
  ///
  /// See:
  ///  * [getRooms] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomGetRoomsResponseApplicationJson, RoomRoomGetRoomsHeaders> getRoomsRaw({
    final int noStatusUpdate = 0,
    final int includeStatus = 0,
    final int modifiedSince = 0,
    final RoomGetRoomsApiVersion apiVersion = RoomGetRoomsApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    if (noStatusUpdate != 0) {
      queryParameters['noStatusUpdate'] = noStatusUpdate.toString();
    }
    if (includeStatus != 0) {
      queryParameters['includeStatus'] = includeStatus.toString();
    }
    if (modifiedSince != 0) {
      queryParameters['modifiedSince'] = modifiedSince.toString();
    }
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomGetRoomsResponseApplicationJson, RoomRoomGetRoomsHeaders>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(RoomGetRoomsResponseApplicationJson),
      headersType: const FullType(RoomRoomGetRoomsHeaders),
      serializers: _jsonSerializers,
    );
  }

  /// Create a room with a user, a group or a circle.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [roomType] Type of the room.
  ///   * [invite] User, group, … ID to invite. Defaults to `''`.
  ///   * [roomName] Name of the room. Defaults to `''`.
  ///   * [source] Source of the invite ID ('circles' to create a room with a circle, etc.). Defaults to `''`.
  ///   * [objectType] Type of the object. Defaults to `''`.
  ///   * [objectId] ID of the object. Defaults to `''`.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Room already existed
  ///   * 201: Room created successfully
  ///   * 400: Room type invalid
  ///   * 403: Missing permissions to create room
  ///   * 404: User, group or other target to invite was not found
  ///
  /// See:
  ///  * [createRoomRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomCreateRoomResponseApplicationJson, void>> createRoom({
    required final int roomType,
    final String invite = '',
    final String roomName = '',
    final String source = '',
    final String objectType = '',
    final String objectId = '',
    final RoomCreateRoomApiVersion apiVersion = RoomCreateRoomApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = createRoomRaw(
      roomType: roomType,
      invite: invite,
      roomName: roomName,
      source: source,
      objectType: objectType,
      objectId: objectId,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Create a room with a user, a group or a circle.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [roomType] Type of the room.
  ///   * [invite] User, group, … ID to invite. Defaults to `''`.
  ///   * [roomName] Name of the room. Defaults to `''`.
  ///   * [source] Source of the invite ID ('circles' to create a room with a circle, etc.). Defaults to `''`.
  ///   * [objectType] Type of the object. Defaults to `''`.
  ///   * [objectId] ID of the object. Defaults to `''`.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Room already existed
  ///   * 201: Room created successfully
  ///   * 400: Room type invalid
  ///   * 403: Missing permissions to create room
  ///   * 404: User, group or other target to invite was not found
  ///
  /// See:
  ///  * [createRoom] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomCreateRoomResponseApplicationJson, void> createRoomRaw({
    required final int roomType,
    final String invite = '',
    final String roomName = '',
    final String source = '',
    final String objectType = '',
    final String objectId = '',
    final RoomCreateRoomApiVersion apiVersion = RoomCreateRoomApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    queryParameters['roomType'] = roomType.toString();
    if (invite != '') {
      queryParameters['invite'] = invite;
    }
    if (roomName != '') {
      queryParameters['roomName'] = roomName;
    }
    if (source != '') {
      queryParameters['source'] = source;
    }
    if (objectType != '') {
      queryParameters['objectType'] = objectType;
    }
    if (objectId != '') {
      queryParameters['objectId'] = objectId;
    }
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomCreateRoomResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200, 201},
      ),
      bodyType: const FullType(RoomCreateRoomResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Get listed rooms with optional search term.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [searchTerm] search term. Defaults to `''`.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Return list of matching rooms
  ///
  /// See:
  ///  * [getListedRoomsRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomGetListedRoomsResponseApplicationJson, void>> getListedRooms({
    final String searchTerm = '',
    final RoomGetListedRoomsApiVersion apiVersion = RoomGetListedRoomsApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = getListedRoomsRaw(
      searchTerm: searchTerm,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Get listed rooms with optional search term.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [searchTerm] search term. Defaults to `''`.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Return list of matching rooms
  ///
  /// See:
  ///  * [getListedRooms] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomGetListedRoomsResponseApplicationJson, void> getListedRoomsRaw({
    final String searchTerm = '',
    final RoomGetListedRoomsApiVersion apiVersion = RoomGetListedRoomsApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    if (searchTerm != '') {
      queryParameters['searchTerm'] = searchTerm;
    }
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/listed-room';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomGetListedRoomsResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(RoomGetListedRoomsResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Get the "Note to self" conversation for the user.
  ///
  /// It will be automatically created when it is currently missing.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Room returned successfully
  ///
  /// See:
  ///  * [getNoteToSelfConversationRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<
      DynamiteResponse<RoomGetNoteToSelfConversationResponseApplicationJson,
          RoomRoomGetNoteToSelfConversationHeaders>> getNoteToSelfConversation({
    final RoomGetNoteToSelfConversationApiVersion apiVersion = RoomGetNoteToSelfConversationApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = getNoteToSelfConversationRaw(
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Get the "Note to self" conversation for the user.
  ///
  /// It will be automatically created when it is currently missing.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Room returned successfully
  ///
  /// See:
  ///  * [getNoteToSelfConversation] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomGetNoteToSelfConversationResponseApplicationJson, RoomRoomGetNoteToSelfConversationHeaders>
      getNoteToSelfConversationRaw({
    final RoomGetNoteToSelfConversationApiVersion apiVersion = RoomGetNoteToSelfConversationApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/note-to-self';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomGetNoteToSelfConversationResponseApplicationJson,
        RoomRoomGetNoteToSelfConversationHeaders>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(RoomGetNoteToSelfConversationResponseApplicationJson),
      headersType: const FullType(RoomRoomGetNoteToSelfConversationHeaders),
      serializers: _jsonSerializers,
    );
  }

  /// Get a room.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token] Token of the room.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Room returned
  ///   * 401: SIP request invalid
  ///   * 404: Room not found
  ///
  /// See:
  ///  * [getSingleRoomRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomGetSingleRoomResponseApplicationJson, RoomRoomGetSingleRoomHeaders>> getSingleRoom({
    required final String token,
    final RoomGetSingleRoomApiVersion apiVersion = RoomGetSingleRoomApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = getSingleRoomRaw(
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Get a room.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token] Token of the room.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Room returned
  ///   * 401: SIP request invalid
  ///   * 404: Room not found
  ///
  /// See:
  ///  * [getSingleRoom] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomGetSingleRoomResponseApplicationJson, RoomRoomGetSingleRoomHeaders> getSingleRoomRaw({
    required final String token,
    final RoomGetSingleRoomApiVersion apiVersion = RoomGetSingleRoomApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomGetSingleRoomResponseApplicationJson, RoomRoomGetSingleRoomHeaders>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(RoomGetSingleRoomResponseApplicationJson),
      headersType: const FullType(RoomRoomGetSingleRoomHeaders),
      serializers: _jsonSerializers,
    );
  }

  /// Rename a room.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [roomName] New name.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Room renamed successfully
  ///   * 400: Renaming room is not possible
  ///
  /// See:
  ///  * [renameRoomRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomRenameRoomResponseApplicationJson, void>> renameRoom({
    required final String roomName,
    required final String token,
    final RoomRenameRoomApiVersion apiVersion = RoomRenameRoomApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = renameRoomRaw(
      roomName: roomName,
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Rename a room.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [roomName] New name.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Room renamed successfully
  ///   * 400: Renaming room is not possible
  ///
  /// See:
  ///  * [renameRoom] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomRenameRoomResponseApplicationJson, void> renameRoomRaw({
    required final String roomName,
    required final String token,
    final RoomRenameRoomApiVersion apiVersion = RoomRenameRoomApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    queryParameters['roomName'] = roomName;
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomRenameRoomResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'put',
        uri,
        headers,
        body,
        const {200, 400},
      ),
      bodyType: const FullType(RoomRenameRoomResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Delete a room.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Room successfully deleted
  ///   * 400: Deleting room is not possible
  ///
  /// See:
  ///  * [deleteRoomRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomDeleteRoomResponseApplicationJson, void>> deleteRoom({
    required final String token,
    final RoomDeleteRoomApiVersion apiVersion = RoomDeleteRoomApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = deleteRoomRaw(
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Delete a room.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Room successfully deleted
  ///   * 400: Deleting room is not possible
  ///
  /// See:
  ///  * [deleteRoom] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomDeleteRoomResponseApplicationJson, void> deleteRoomRaw({
    required final String token,
    final RoomDeleteRoomApiVersion apiVersion = RoomDeleteRoomApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomDeleteRoomResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'delete',
        uri,
        headers,
        body,
        const {200, 400},
      ),
      bodyType: const FullType(RoomDeleteRoomResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Get all (for moderators and in case of "free selection") or the assigned breakout room.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Breakout rooms returned
  ///   * 400: Getting breakout rooms is not possible
  ///
  /// See:
  ///  * [getBreakoutRoomsRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomGetBreakoutRoomsResponseApplicationJson, void>> getBreakoutRooms({
    required final String token,
    final RoomGetBreakoutRoomsApiVersion apiVersion = RoomGetBreakoutRoomsApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = getBreakoutRoomsRaw(
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Get all (for moderators and in case of "free selection") or the assigned breakout room.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Breakout rooms returned
  ///   * 400: Getting breakout rooms is not possible
  ///
  /// See:
  ///  * [getBreakoutRooms] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomGetBreakoutRoomsResponseApplicationJson, void> getBreakoutRoomsRaw({
    required final String token,
    final RoomGetBreakoutRoomsApiVersion apiVersion = RoomGetBreakoutRoomsApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/breakout-rooms';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomGetBreakoutRoomsResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(RoomGetBreakoutRoomsResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Allowed guests to join conversation.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Allowed guests successfully
  ///   * 400: Allowing guests is not possible
  ///
  /// See:
  ///  * [makePublicRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomMakePublicResponseApplicationJson, void>> makePublic({
    required final String token,
    final RoomMakePublicApiVersion apiVersion = RoomMakePublicApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = makePublicRaw(
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Allowed guests to join conversation.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Allowed guests successfully
  ///   * 400: Allowing guests is not possible
  ///
  /// See:
  ///  * [makePublic] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomMakePublicResponseApplicationJson, void> makePublicRaw({
    required final String token,
    final RoomMakePublicApiVersion apiVersion = RoomMakePublicApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/public';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomMakePublicResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200, 400},
      ),
      bodyType: const FullType(RoomMakePublicResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Disallowed guests to join conversation.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Room unpublished Disallowing guests successfully
  ///   * 400: Disallowing guests is not possible
  ///
  /// See:
  ///  * [makePrivateRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomMakePrivateResponseApplicationJson, void>> makePrivate({
    required final String token,
    final RoomMakePrivateApiVersion apiVersion = RoomMakePrivateApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = makePrivateRaw(
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Disallowed guests to join conversation.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Room unpublished Disallowing guests successfully
  ///   * 400: Disallowing guests is not possible
  ///
  /// See:
  ///  * [makePrivate] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomMakePrivateResponseApplicationJson, void> makePrivateRaw({
    required final String token,
    final RoomMakePrivateApiVersion apiVersion = RoomMakePrivateApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/public';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomMakePrivateResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'delete',
        uri,
        headers,
        body,
        const {200, 400},
      ),
      bodyType: const FullType(RoomMakePrivateResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Update the description of a room.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [description] New description.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Description updated successfully
  ///   * 400: Updating description is not possible
  ///
  /// See:
  ///  * [setDescriptionRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomSetDescriptionResponseApplicationJson, void>> setDescription({
    required final String description,
    required final String token,
    final RoomSetDescriptionApiVersion apiVersion = RoomSetDescriptionApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = setDescriptionRaw(
      description: description,
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Update the description of a room.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [description] New description.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Description updated successfully
  ///   * 400: Updating description is not possible
  ///
  /// See:
  ///  * [setDescription] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomSetDescriptionResponseApplicationJson, void> setDescriptionRaw({
    required final String description,
    required final String token,
    final RoomSetDescriptionApiVersion apiVersion = RoomSetDescriptionApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    queryParameters['description'] = description;
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/description';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomSetDescriptionResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'put',
        uri,
        headers,
        body,
        const {200, 400},
      ),
      bodyType: const FullType(RoomSetDescriptionResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Set read-only state of a room.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [state] New read-only state.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Read-only state updated successfully
  ///   * 400: Updating read-only state is not possible
  ///
  /// See:
  ///  * [setReadOnlyRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomSetReadOnlyResponseApplicationJson, void>> setReadOnly({
    required final int state,
    required final String token,
    final RoomSetReadOnlyApiVersion apiVersion = RoomSetReadOnlyApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = setReadOnlyRaw(
      state: state,
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Set read-only state of a room.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [state] New read-only state.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Read-only state updated successfully
  ///   * 400: Updating read-only state is not possible
  ///
  /// See:
  ///  * [setReadOnly] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomSetReadOnlyResponseApplicationJson, void> setReadOnlyRaw({
    required final int state,
    required final String token,
    final RoomSetReadOnlyApiVersion apiVersion = RoomSetReadOnlyApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    queryParameters['state'] = state.toString();
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/read-only';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomSetReadOnlyResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'put',
        uri,
        headers,
        body,
        const {200, 400},
      ),
      bodyType: const FullType(RoomSetReadOnlyResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Make a room listable.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [scope] Scope where the room is listable.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Made room listable successfully
  ///   * 400: Making room listable is not possible
  ///
  /// See:
  ///  * [setListableRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomSetListableResponseApplicationJson, void>> setListable({
    required final int scope,
    required final String token,
    final RoomSetListableApiVersion apiVersion = RoomSetListableApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = setListableRaw(
      scope: scope,
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Make a room listable.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [scope] Scope where the room is listable.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Made room listable successfully
  ///   * 400: Making room listable is not possible
  ///
  /// See:
  ///  * [setListable] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomSetListableResponseApplicationJson, void> setListableRaw({
    required final int scope,
    required final String token,
    final RoomSetListableApiVersion apiVersion = RoomSetListableApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    queryParameters['scope'] = scope.toString();
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/listable';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomSetListableResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'put',
        uri,
        headers,
        body,
        const {200, 400},
      ),
      bodyType: const FullType(RoomSetListableResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Set a password for a room.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [password] New password.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Password set successfully
  ///   * 403: Setting password is not allowed
  ///   * 400: Setting password is not possible
  ///
  /// See:
  ///  * [setPasswordRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomSetPasswordResponseApplicationJson, void>> setPassword({
    required final String password,
    required final String token,
    final RoomSetPasswordApiVersion apiVersion = RoomSetPasswordApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = setPasswordRaw(
      password: password,
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Set a password for a room.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [password] New password.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Password set successfully
  ///   * 403: Setting password is not allowed
  ///   * 400: Setting password is not possible
  ///
  /// See:
  ///  * [setPassword] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomSetPasswordResponseApplicationJson, void> setPasswordRaw({
    required final String password,
    required final String token,
    final RoomSetPasswordApiVersion apiVersion = RoomSetPasswordApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    queryParameters['password'] = password;
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/password';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomSetPasswordResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'put',
        uri,
        headers,
        body,
        const {200, 403},
      ),
      bodyType: const FullType(RoomSetPasswordResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Update the permissions of a room.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [permissions] New permissions.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [mode] Level of the permissions ('call', 'default').
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Permissions updated successfully
  ///   * 400: Updating permissions is not possible
  ///
  /// See:
  ///  * [setPermissionsRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomSetPermissionsResponseApplicationJson, void>> setPermissions({
    required final int permissions,
    required final String token,
    required final String mode,
    final RoomSetPermissionsApiVersion apiVersion = RoomSetPermissionsApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = setPermissionsRaw(
      permissions: permissions,
      token: token,
      mode: mode,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Update the permissions of a room.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [permissions] New permissions.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [mode] Level of the permissions ('call', 'default').
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Permissions updated successfully
  ///   * 400: Updating permissions is not possible
  ///
  /// See:
  ///  * [setPermissions] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomSetPermissionsResponseApplicationJson, void> setPermissionsRaw({
    required final int permissions,
    required final String token,
    required final String mode,
    final RoomSetPermissionsApiVersion apiVersion = RoomSetPermissionsApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    queryParameters['permissions'] = permissions.toString();
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    checkPattern(mode, RegExp(r'^(call|default)$'), 'mode'); // coverage:ignore-line
    final mode0 = Uri.encodeQueryComponent(mode);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/permissions/$mode0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomSetPermissionsResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'put',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(RoomSetPermissionsResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Get a list of participants for a room.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [includeStatus] Include the user statuses. Defaults to `0`.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Participants returned
  ///   * 403: Missing permissions for getting participants
  ///
  /// See:
  ///  * [getParticipantsRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomGetParticipantsResponseApplicationJson, RoomRoomGetParticipantsHeaders>> getParticipants({
    required final String token,
    final int includeStatus = 0,
    final RoomGetParticipantsApiVersion apiVersion = RoomGetParticipantsApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = getParticipantsRaw(
      token: token,
      includeStatus: includeStatus,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Get a list of participants for a room.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [includeStatus] Include the user statuses. Defaults to `0`.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Participants returned
  ///   * 403: Missing permissions for getting participants
  ///
  /// See:
  ///  * [getParticipants] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomGetParticipantsResponseApplicationJson, RoomRoomGetParticipantsHeaders> getParticipantsRaw({
    required final String token,
    final int includeStatus = 0,
    final RoomGetParticipantsApiVersion apiVersion = RoomGetParticipantsApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    if (includeStatus != 0) {
      queryParameters['includeStatus'] = includeStatus.toString();
    }
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/participants';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomGetParticipantsResponseApplicationJson, RoomRoomGetParticipantsHeaders>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(RoomGetParticipantsResponseApplicationJson),
      headersType: const FullType(RoomRoomGetParticipantsHeaders),
      serializers: _jsonSerializers,
    );
  }

  /// Add a participant to a room.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [newParticipant] New participant.
  ///   * [source] Source of the participant. Defaults to `users`.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Participant successfully added
  ///   * 404: User, group or other target to invite was not found
  ///   * 501: SIP dial-out is not configured
  ///   * 400: Adding participant is not possible
  ///
  /// See:
  ///  * [addParticipantToRoomRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomAddParticipantToRoomResponseApplicationJson, void>> addParticipantToRoom({
    required final String newParticipant,
    required final String token,
    final String source = 'users',
    final RoomAddParticipantToRoomApiVersion apiVersion = RoomAddParticipantToRoomApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = addParticipantToRoomRaw(
      newParticipant: newParticipant,
      token: token,
      source: source,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Add a participant to a room.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [newParticipant] New participant.
  ///   * [source] Source of the participant. Defaults to `users`.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Participant successfully added
  ///   * 404: User, group or other target to invite was not found
  ///   * 501: SIP dial-out is not configured
  ///   * 400: Adding participant is not possible
  ///
  /// See:
  ///  * [addParticipantToRoom] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomAddParticipantToRoomResponseApplicationJson, void> addParticipantToRoomRaw({
    required final String newParticipant,
    required final String token,
    final String source = 'users',
    final RoomAddParticipantToRoomApiVersion apiVersion = RoomAddParticipantToRoomApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    queryParameters['newParticipant'] = newParticipant;
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    if (source != 'users') {
      queryParameters['source'] = source;
    }
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/participants';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomAddParticipantToRoomResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(RoomAddParticipantToRoomResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Get the breakout room participants for a room.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [includeStatus] Include the user statuses. Defaults to `0`.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Breakout room participants returned
  ///   * 400: Getting breakout room participants is not possible
  ///   * 403: Missing permissions to get breakout room participants
  ///
  /// See:
  ///  * [getBreakoutRoomParticipantsRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<
      DynamiteResponse<RoomGetBreakoutRoomParticipantsResponseApplicationJson,
          RoomRoomGetBreakoutRoomParticipantsHeaders>> getBreakoutRoomParticipants({
    required final String token,
    final int includeStatus = 0,
    final RoomGetBreakoutRoomParticipantsApiVersion apiVersion = RoomGetBreakoutRoomParticipantsApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = getBreakoutRoomParticipantsRaw(
      token: token,
      includeStatus: includeStatus,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Get the breakout room participants for a room.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [includeStatus] Include the user statuses. Defaults to `0`.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Breakout room participants returned
  ///   * 400: Getting breakout room participants is not possible
  ///   * 403: Missing permissions to get breakout room participants
  ///
  /// See:
  ///  * [getBreakoutRoomParticipants] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomGetBreakoutRoomParticipantsResponseApplicationJson,
      RoomRoomGetBreakoutRoomParticipantsHeaders> getBreakoutRoomParticipantsRaw({
    required final String token,
    final int includeStatus = 0,
    final RoomGetBreakoutRoomParticipantsApiVersion apiVersion = RoomGetBreakoutRoomParticipantsApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    if (includeStatus != 0) {
      queryParameters['includeStatus'] = includeStatus.toString();
    }
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/breakout-rooms/participants';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomGetBreakoutRoomParticipantsResponseApplicationJson,
        RoomRoomGetBreakoutRoomParticipantsHeaders>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(RoomGetBreakoutRoomParticipantsResponseApplicationJson),
      headersType: const FullType(RoomRoomGetBreakoutRoomParticipantsHeaders),
      serializers: _jsonSerializers,
    );
  }

  /// Remove the current user from a room.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Participant removed successfully
  ///   * 400: Removing participant is not possible
  ///   * 404: Participant not found
  ///
  /// See:
  ///  * [removeSelfFromRoomRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomRemoveSelfFromRoomResponseApplicationJson, void>> removeSelfFromRoom({
    required final String token,
    final RoomRemoveSelfFromRoomApiVersion apiVersion = RoomRemoveSelfFromRoomApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = removeSelfFromRoomRaw(
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Remove the current user from a room.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Participant removed successfully
  ///   * 400: Removing participant is not possible
  ///   * 404: Participant not found
  ///
  /// See:
  ///  * [removeSelfFromRoom] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomRemoveSelfFromRoomResponseApplicationJson, void> removeSelfFromRoomRaw({
    required final String token,
    final RoomRemoveSelfFromRoomApiVersion apiVersion = RoomRemoveSelfFromRoomApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/participants/self';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomRemoveSelfFromRoomResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'delete',
        uri,
        headers,
        body,
        const {200, 400, 404},
      ),
      bodyType: const FullType(RoomRemoveSelfFromRoomResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Remove an attendee from a room.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [attendeeId] ID of the attendee.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Attendee removed successfully
  ///   * 400: Removing attendee is not possible
  ///   * 403: Removing attendee is not allowed
  ///   * 404: Attendee not found
  ///
  /// See:
  ///  * [removeAttendeeFromRoomRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomRemoveAttendeeFromRoomResponseApplicationJson, void>> removeAttendeeFromRoom({
    required final int attendeeId,
    required final String token,
    final RoomRemoveAttendeeFromRoomApiVersion apiVersion = RoomRemoveAttendeeFromRoomApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = removeAttendeeFromRoomRaw(
      attendeeId: attendeeId,
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Remove an attendee from a room.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [attendeeId] ID of the attendee.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Attendee removed successfully
  ///   * 400: Removing attendee is not possible
  ///   * 403: Removing attendee is not allowed
  ///   * 404: Attendee not found
  ///
  /// See:
  ///  * [removeAttendeeFromRoom] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomRemoveAttendeeFromRoomResponseApplicationJson, void> removeAttendeeFromRoomRaw({
    required final int attendeeId,
    required final String token,
    final RoomRemoveAttendeeFromRoomApiVersion apiVersion = RoomRemoveAttendeeFromRoomApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    queryParameters['attendeeId'] = attendeeId.toString();
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/attendees';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomRemoveAttendeeFromRoomResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'delete',
        uri,
        headers,
        body,
        const {200, 400, 403, 404},
      ),
      bodyType: const FullType(RoomRemoveAttendeeFromRoomResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Update the permissions of an attendee.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [attendeeId] ID of the attendee.
  ///   * [method] Method of updating permissions ('set', 'remove', 'add').
  ///   * [permissions] New permissions.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Permissions updated successfully
  ///   * 400: Updating permissions is not possible
  ///   * 403: Missing permissions to update permissions
  ///   * 404: Attendee not found
  ///
  /// See:
  ///  * [setAttendeePermissionsRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomSetAttendeePermissionsResponseApplicationJson, void>> setAttendeePermissions({
    required final int attendeeId,
    required final String method,
    required final int permissions,
    required final String token,
    final RoomSetAttendeePermissionsApiVersion apiVersion = RoomSetAttendeePermissionsApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = setAttendeePermissionsRaw(
      attendeeId: attendeeId,
      method: method,
      permissions: permissions,
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Update the permissions of an attendee.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [attendeeId] ID of the attendee.
  ///   * [method] Method of updating permissions ('set', 'remove', 'add').
  ///   * [permissions] New permissions.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Permissions updated successfully
  ///   * 400: Updating permissions is not possible
  ///   * 403: Missing permissions to update permissions
  ///   * 404: Attendee not found
  ///
  /// See:
  ///  * [setAttendeePermissions] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomSetAttendeePermissionsResponseApplicationJson, void> setAttendeePermissionsRaw({
    required final int attendeeId,
    required final String method,
    required final int permissions,
    required final String token,
    final RoomSetAttendeePermissionsApiVersion apiVersion = RoomSetAttendeePermissionsApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    queryParameters['attendeeId'] = attendeeId.toString();
    queryParameters['method'] = method;
    queryParameters['permissions'] = permissions.toString();
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/attendees/permissions';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomSetAttendeePermissionsResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'put',
        uri,
        headers,
        body,
        const {200, 400, 403, 404},
      ),
      bodyType: const FullType(RoomSetAttendeePermissionsResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Update the permissions of all attendees.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [method] Method of updating permissions ('set', 'remove', 'add').
  ///   * [permissions] New permissions.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Permissions updated successfully
  ///   * 400: Updating permissions is not possible
  ///
  /// See:
  ///  * [setAllAttendeesPermissionsRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomSetAllAttendeesPermissionsResponseApplicationJson, void>> setAllAttendeesPermissions({
    required final String method,
    required final int permissions,
    required final String token,
    final RoomSetAllAttendeesPermissionsApiVersion apiVersion = RoomSetAllAttendeesPermissionsApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = setAllAttendeesPermissionsRaw(
      method: method,
      permissions: permissions,
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Update the permissions of all attendees.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [method] Method of updating permissions ('set', 'remove', 'add').
  ///   * [permissions] New permissions.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Permissions updated successfully
  ///   * 400: Updating permissions is not possible
  ///
  /// See:
  ///  * [setAllAttendeesPermissions] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomSetAllAttendeesPermissionsResponseApplicationJson, void> setAllAttendeesPermissionsRaw({
    required final String method,
    required final int permissions,
    required final String token,
    final RoomSetAllAttendeesPermissionsApiVersion apiVersion = RoomSetAllAttendeesPermissionsApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    queryParameters['method'] = method;
    queryParameters['permissions'] = permissions.toString();
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/attendees/permissions/all';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomSetAllAttendeesPermissionsResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'put',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(RoomSetAllAttendeesPermissionsResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Join a room.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [password] Password of the room. Defaults to `''`.
  ///   * [force] Create a new session if necessary. Defaults to `1`.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token] Token of the room.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Room joined successfully
  ///   * 403: Joining room is not allowed
  ///   * 404: Room not found
  ///   * 409: Session already exists
  ///
  /// See:
  ///  * [joinRoomRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomJoinRoomResponseApplicationJson, void>> joinRoom({
    required final String token,
    final String password = '',
    final int force = 1,
    final RoomJoinRoomApiVersion apiVersion = RoomJoinRoomApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = joinRoomRaw(
      token: token,
      password: password,
      force: force,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Join a room.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [password] Password of the room. Defaults to `''`.
  ///   * [force] Create a new session if necessary. Defaults to `1`.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token] Token of the room.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Room joined successfully
  ///   * 403: Joining room is not allowed
  ///   * 404: Room not found
  ///   * 409: Session already exists
  ///
  /// See:
  ///  * [joinRoom] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomJoinRoomResponseApplicationJson, void> joinRoomRaw({
    required final String token,
    final String password = '',
    final int force = 1,
    final RoomJoinRoomApiVersion apiVersion = RoomJoinRoomApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    if (password != '') {
      queryParameters['password'] = password;
    }
    if (force != 1) {
      queryParameters['force'] = force.toString();
    }
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/participants/active';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomJoinRoomResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(RoomJoinRoomResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Leave a room.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token] Token of the room.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Successfully left the room
  ///
  /// See:
  ///  * [leaveRoomRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomLeaveRoomResponseApplicationJson, void>> leaveRoom({
    required final String token,
    final RoomLeaveRoomApiVersion apiVersion = RoomLeaveRoomApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = leaveRoomRaw(
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Leave a room.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token] Token of the room.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Successfully left the room
  ///
  /// See:
  ///  * [leaveRoom] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomLeaveRoomResponseApplicationJson, void> leaveRoomRaw({
    required final String token,
    final RoomLeaveRoomApiVersion apiVersion = RoomLeaveRoomApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/participants/active';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomLeaveRoomResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'delete',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(RoomLeaveRoomResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Resend invitations.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [attendeeId] ID of the attendee.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Invitation resent successfully
  ///   * 404: Attendee not found
  ///
  /// See:
  ///  * [resendInvitationsRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomResendInvitationsResponseApplicationJson, void>> resendInvitations({
    required final String token,
    final int? attendeeId,
    final RoomResendInvitationsApiVersion apiVersion = RoomResendInvitationsApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = resendInvitationsRaw(
      token: token,
      attendeeId: attendeeId,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Resend invitations.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [attendeeId] ID of the attendee.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Invitation resent successfully
  ///   * 404: Attendee not found
  ///
  /// See:
  ///  * [resendInvitations] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomResendInvitationsResponseApplicationJson, void> resendInvitationsRaw({
    required final String token,
    final int? attendeeId,
    final RoomResendInvitationsApiVersion apiVersion = RoomResendInvitationsApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    if (attendeeId != null) {
      queryParameters['attendeeId'] = attendeeId.toString();
    }
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/participants/resend-invitations';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomResendInvitationsResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200, 404},
      ),
      bodyType: const FullType(RoomResendInvitationsResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Set active state for a session.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [state] of the room.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Session state set successfully
  ///   * 400: The provided new state was invalid
  ///
  /// See:
  ///  * [setSessionStateRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomSetSessionStateResponseApplicationJson, void>> setSessionState({
    required final int state,
    required final String token,
    final RoomSetSessionStateApiVersion apiVersion = RoomSetSessionStateApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = setSessionStateRaw(
      state: state,
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Set active state for a session.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [state] of the room.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Session state set successfully
  ///   * 400: The provided new state was invalid
  ///
  /// See:
  ///  * [setSessionState] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomSetSessionStateResponseApplicationJson, void> setSessionStateRaw({
    required final int state,
    required final String token,
    final RoomSetSessionStateApiVersion apiVersion = RoomSetSessionStateApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    queryParameters['state'] = state.toString();
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/participants/state';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomSetSessionStateResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'put',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(RoomSetSessionStateResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Promote an attendee to moderator.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [attendeeId] ID of the attendee.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Attendee promoted to moderator successfully
  ///   * 400: Promoting attendee to moderator is not possible
  ///   * 403: Promoting attendee to moderator is not allowed
  ///   * 404: Attendee not found
  ///
  /// See:
  ///  * [promoteModeratorRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomPromoteModeratorResponseApplicationJson, void>> promoteModerator({
    required final int attendeeId,
    required final String token,
    final RoomPromoteModeratorApiVersion apiVersion = RoomPromoteModeratorApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = promoteModeratorRaw(
      attendeeId: attendeeId,
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Promote an attendee to moderator.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [attendeeId] ID of the attendee.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Attendee promoted to moderator successfully
  ///   * 400: Promoting attendee to moderator is not possible
  ///   * 403: Promoting attendee to moderator is not allowed
  ///   * 404: Attendee not found
  ///
  /// See:
  ///  * [promoteModerator] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomPromoteModeratorResponseApplicationJson, void> promoteModeratorRaw({
    required final int attendeeId,
    required final String token,
    final RoomPromoteModeratorApiVersion apiVersion = RoomPromoteModeratorApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    queryParameters['attendeeId'] = attendeeId.toString();
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/moderators';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomPromoteModeratorResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200, 400, 403, 404},
      ),
      bodyType: const FullType(RoomPromoteModeratorResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Demote an attendee from moderator.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [attendeeId] ID of the attendee.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Attendee demoted from moderator successfully
  ///   * 400: Demoting attendee from moderator is not possible
  ///   * 403: Demoting attendee from moderator is not allowed
  ///   * 404: Attendee not found
  ///
  /// See:
  ///  * [demoteModeratorRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomDemoteModeratorResponseApplicationJson, void>> demoteModerator({
    required final int attendeeId,
    required final String token,
    final RoomDemoteModeratorApiVersion apiVersion = RoomDemoteModeratorApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = demoteModeratorRaw(
      attendeeId: attendeeId,
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Demote an attendee from moderator.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [attendeeId] ID of the attendee.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Attendee demoted from moderator successfully
  ///   * 400: Demoting attendee from moderator is not possible
  ///   * 403: Demoting attendee from moderator is not allowed
  ///   * 404: Attendee not found
  ///
  /// See:
  ///  * [demoteModerator] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomDemoteModeratorResponseApplicationJson, void> demoteModeratorRaw({
    required final int attendeeId,
    required final String token,
    final RoomDemoteModeratorApiVersion apiVersion = RoomDemoteModeratorApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    queryParameters['attendeeId'] = attendeeId.toString();
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/moderators';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomDemoteModeratorResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'delete',
        uri,
        headers,
        body,
        const {200, 400, 403, 404},
      ),
      bodyType: const FullType(RoomDemoteModeratorResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Add a room to the favorites.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Successfully added room to favorites
  ///
  /// See:
  ///  * [addToFavoritesRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomAddToFavoritesResponseApplicationJson, void>> addToFavorites({
    required final String token,
    final RoomAddToFavoritesApiVersion apiVersion = RoomAddToFavoritesApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = addToFavoritesRaw(
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Add a room to the favorites.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Successfully added room to favorites
  ///
  /// See:
  ///  * [addToFavorites] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomAddToFavoritesResponseApplicationJson, void> addToFavoritesRaw({
    required final String token,
    final RoomAddToFavoritesApiVersion apiVersion = RoomAddToFavoritesApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/favorite';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomAddToFavoritesResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(RoomAddToFavoritesResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Remove a room from the favorites.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Successfully removed room from favorites
  ///
  /// See:
  ///  * [removeFromFavoritesRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomRemoveFromFavoritesResponseApplicationJson, void>> removeFromFavorites({
    required final String token,
    final RoomRemoveFromFavoritesApiVersion apiVersion = RoomRemoveFromFavoritesApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = removeFromFavoritesRaw(
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Remove a room from the favorites.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Successfully removed room from favorites
  ///
  /// See:
  ///  * [removeFromFavorites] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomRemoveFromFavoritesResponseApplicationJson, void> removeFromFavoritesRaw({
    required final String token,
    final RoomRemoveFromFavoritesApiVersion apiVersion = RoomRemoveFromFavoritesApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/favorite';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomRemoveFromFavoritesResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'delete',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(RoomRemoveFromFavoritesResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Update the notification level for a room.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [level] New level.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Notification level updated successfully
  ///   * 400: Updating notification level is not possible
  ///
  /// See:
  ///  * [setNotificationLevelRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomSetNotificationLevelResponseApplicationJson, void>> setNotificationLevel({
    required final int level,
    required final String token,
    final RoomSetNotificationLevelApiVersion apiVersion = RoomSetNotificationLevelApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = setNotificationLevelRaw(
      level: level,
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Update the notification level for a room.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [level] New level.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Notification level updated successfully
  ///   * 400: Updating notification level is not possible
  ///
  /// See:
  ///  * [setNotificationLevel] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomSetNotificationLevelResponseApplicationJson, void> setNotificationLevelRaw({
    required final int level,
    required final String token,
    final RoomSetNotificationLevelApiVersion apiVersion = RoomSetNotificationLevelApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    queryParameters['level'] = level.toString();
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/notify';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomSetNotificationLevelResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200, 400},
      ),
      bodyType: const FullType(RoomSetNotificationLevelResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Update call notifications.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [level] New level.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Call notification level updated successfully
  ///   * 400: Updating call notification level is not possible
  ///
  /// See:
  ///  * [setNotificationCallsRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomSetNotificationCallsResponseApplicationJson, void>> setNotificationCalls({
    required final int level,
    required final String token,
    final RoomSetNotificationCallsApiVersion apiVersion = RoomSetNotificationCallsApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = setNotificationCallsRaw(
      level: level,
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Update call notifications.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [level] New level.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Call notification level updated successfully
  ///   * 400: Updating call notification level is not possible
  ///
  /// See:
  ///  * [setNotificationCalls] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomSetNotificationCallsResponseApplicationJson, void> setNotificationCallsRaw({
    required final int level,
    required final String token,
    final RoomSetNotificationCallsApiVersion apiVersion = RoomSetNotificationCallsApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    queryParameters['level'] = level.toString();
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/notify-calls';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomSetNotificationCallsResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200, 400},
      ),
      bodyType: const FullType(RoomSetNotificationCallsResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Update the lobby state for a room.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [state] New state.
  ///   * [timer] Timer when the lobby will be removed.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Lobby state updated successfully
  ///   * 400: Updating lobby state is not possible
  ///
  /// See:
  ///  * [setLobbyRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomSetLobbyResponseApplicationJson, void>> setLobby({
    required final int state,
    required final String token,
    final int? timer,
    final RoomSetLobbyApiVersion apiVersion = RoomSetLobbyApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = setLobbyRaw(
      state: state,
      token: token,
      timer: timer,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Update the lobby state for a room.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [state] New state.
  ///   * [timer] Timer when the lobby will be removed.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Lobby state updated successfully
  ///   * 400: Updating lobby state is not possible
  ///
  /// See:
  ///  * [setLobby] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomSetLobbyResponseApplicationJson, void> setLobbyRaw({
    required final int state,
    required final String token,
    final int? timer,
    final RoomSetLobbyApiVersion apiVersion = RoomSetLobbyApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    queryParameters['state'] = state.toString();
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    if (timer != null) {
      queryParameters['timer'] = timer.toString();
    }
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/webinar/lobby';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomSetLobbyResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'put',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(RoomSetLobbyResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Update SIP enabled state.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [state] New state.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: SIP enabled state updated successfully
  ///   * 400: Updating SIP enabled state is not possible
  ///   * 401: User not found
  ///   * 403: Missing permissions to update SIP enabled state
  ///   * 412: SIP not configured
  ///
  /// See:
  ///  * [setsipEnabledRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomSetsipEnabledResponseApplicationJson, void>> setsipEnabled({
    required final int state,
    required final String token,
    final RoomSetsipEnabledApiVersion apiVersion = RoomSetsipEnabledApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = setsipEnabledRaw(
      state: state,
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Update SIP enabled state.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [state] New state.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: SIP enabled state updated successfully
  ///   * 400: Updating SIP enabled state is not possible
  ///   * 401: User not found
  ///   * 403: Missing permissions to update SIP enabled state
  ///   * 412: SIP not configured
  ///
  /// See:
  ///  * [setsipEnabled] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomSetsipEnabledResponseApplicationJson, void> setsipEnabledRaw({
    required final int state,
    required final String token,
    final RoomSetsipEnabledApiVersion apiVersion = RoomSetsipEnabledApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    queryParameters['state'] = state.toString();
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/webinar/sip';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomSetsipEnabledResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'put',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(RoomSetsipEnabledResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Set recording consent requirement for this conversation.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [recordingConsent] New consent setting for the conversation (Only {@see RecordingService::CONSENT_REQUIRED_NO} and {@see RecordingService::CONSENT_REQUIRED_YES} are allowed here.).
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Recording consent requirement set successfully
  ///   * 400: Setting recording consent requirement is not possible
  ///   * 412: No recording server is configured
  ///
  /// See:
  ///  * [setRecordingConsentRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomSetRecordingConsentResponseApplicationJson, void>> setRecordingConsent({
    required final int recordingConsent,
    required final String token,
    final RoomSetRecordingConsentApiVersion apiVersion = RoomSetRecordingConsentApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = setRecordingConsentRaw(
      recordingConsent: recordingConsent,
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Set recording consent requirement for this conversation.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [recordingConsent] New consent setting for the conversation (Only {@see RecordingService::CONSENT_REQUIRED_NO} and {@see RecordingService::CONSENT_REQUIRED_YES} are allowed here.).
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Recording consent requirement set successfully
  ///   * 400: Setting recording consent requirement is not possible
  ///   * 412: No recording server is configured
  ///
  /// See:
  ///  * [setRecordingConsent] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomSetRecordingConsentResponseApplicationJson, void> setRecordingConsentRaw({
    required final int recordingConsent,
    required final String token,
    final RoomSetRecordingConsentApiVersion apiVersion = RoomSetRecordingConsentApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    queryParameters['recordingConsent'] = recordingConsent.toString();
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/recording-consent';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomSetRecordingConsentResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'put',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(RoomSetRecordingConsentResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Update message expiration time.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [seconds] New time.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Message expiration time updated successfully
  ///   * 400: Updating message expiration time is not possible
  ///
  /// See:
  ///  * [setMessageExpirationRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<RoomSetMessageExpirationResponseApplicationJson, void>> setMessageExpiration({
    required final int seconds,
    required final String token,
    final RoomSetMessageExpirationApiVersion apiVersion = RoomSetMessageExpirationApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = setMessageExpirationRaw(
      seconds: seconds,
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Update message expiration time.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [seconds] New time.
  ///   * [apiVersion] Defaults to `v4`.
  ///   * [token]
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Message expiration time updated successfully
  ///   * 400: Updating message expiration time is not possible
  ///
  /// See:
  ///  * [setMessageExpiration] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<RoomSetMessageExpirationResponseApplicationJson, void> setMessageExpirationRaw({
    required final int seconds,
    required final String token,
    final RoomSetMessageExpirationApiVersion apiVersion = RoomSetMessageExpirationApiVersion.v4,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    queryParameters['seconds'] = seconds.toString();
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/room/$token0/message-expiration';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<RoomSetMessageExpirationResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(RoomSetMessageExpirationResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }
}

class SettingsClient {
  SettingsClient(this._rootClient);

  final Client _rootClient;

  /// Update SIP settings.
  ///
  /// This endpoint requires admin access.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [sipGroups] New SIP groups. Defaults to `[]`.
  ///   * [dialInInfo] New dial info. Defaults to `''`.
  ///   * [sharedSecret] New shared secret. Defaults to `''`.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Successfully set new SIP settings
  ///
  /// See:
  ///  * [setsipSettingsRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<SettingsSetsipSettingsResponseApplicationJson, void>> setsipSettings({
    final List<String> sipGroups = const <String>[],
    final String dialInInfo = '',
    final String sharedSecret = '',
    final SettingsSetsipSettingsApiVersion apiVersion = SettingsSetsipSettingsApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = setsipSettingsRaw(
      sipGroups: sipGroups,
      dialInInfo: dialInInfo,
      sharedSecret: sharedSecret,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Update SIP settings.
  ///
  /// This endpoint requires admin access.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [sipGroups] New SIP groups. Defaults to `[]`.
  ///   * [dialInInfo] New dial info. Defaults to `''`.
  ///   * [sharedSecret] New shared secret. Defaults to `''`.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Successfully set new SIP settings
  ///
  /// See:
  ///  * [setsipSettings] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<SettingsSetsipSettingsResponseApplicationJson, void> setsipSettingsRaw({
    final List<String> sipGroups = const <String>[],
    final String dialInInfo = '',
    final String sharedSecret = '',
    final SettingsSetsipSettingsApiVersion apiVersion = SettingsSetsipSettingsApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    if (sipGroups != const <String>[]) {
      queryParameters['sipGroups[]'] = sipGroups.map((final e) => e);
    }
    if (dialInInfo != '') {
      queryParameters['dialInInfo'] = dialInInfo;
    }
    if (sharedSecret != '') {
      queryParameters['sharedSecret'] = sharedSecret;
    }
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/settings/sip';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<SettingsSetsipSettingsResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(SettingsSetsipSettingsResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Update user setting.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [key] Key to update.
  ///   * [value] New value for the key.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: User setting updated successfully
  ///   * 400: Updating user setting is not possible
  ///
  /// See:
  ///  * [setUserSettingRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<SettingsSetUserSettingResponseApplicationJson, void>> setUserSetting({
    required final String key,
    final ContentString<SettingsSetUserSettingValue>? value,
    final SettingsSetUserSettingApiVersion apiVersion = SettingsSetUserSettingApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = setUserSettingRaw(
      key: key,
      value: value,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Update user setting.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [key] Key to update.
  ///   * [value] New value for the key.
  ///   * [apiVersion] Defaults to `v1`.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: User setting updated successfully
  ///   * 400: Updating user setting is not possible
  ///
  /// See:
  ///  * [setUserSetting] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<SettingsSetUserSettingResponseApplicationJson, void> setUserSettingRaw({
    required final String key,
    final ContentString<SettingsSetUserSettingValue>? value,
    final SettingsSetUserSettingApiVersion apiVersion = SettingsSetUserSettingApiVersion.v1,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    queryParameters['key'] = key;
    if (value != null) {
      queryParameters['value'] = _jsonSerializers.serialize(
        value,
        specifiedType: const FullType(ContentString, [FullType(SettingsSetUserSettingValue)]),
      );
    }
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/settings/user';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<SettingsSetUserSettingResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200, 400},
      ),
      bodyType: const FullType(SettingsSetUserSettingResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }
}

class SignalingClient {
  SignalingClient(this._rootClient);

  final Client _rootClient;

  /// Get the signaling settings.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [token] Token of the room. Defaults to `''`.
  ///   * [apiVersion] Defaults to `v3`.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Signaling settings returned
  ///   * 401: Recording request invalid
  ///   * 404: Room not found
  ///
  /// See:
  ///  * [getSettingsRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<SignalingGetSettingsResponseApplicationJson, void>> getSettings({
    final String token = '',
    final SignalingGetSettingsApiVersion apiVersion = SignalingGetSettingsApiVersion.v3,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = getSettingsRaw(
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Get the signaling settings.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [token] Token of the room. Defaults to `''`.
  ///   * [apiVersion] Defaults to `v3`.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Signaling settings returned
  ///   * 401: Recording request invalid
  ///   * 404: Room not found
  ///
  /// See:
  ///  * [getSettings] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<SignalingGetSettingsResponseApplicationJson, void> getSettingsRaw({
    final String token = '',
    final SignalingGetSettingsApiVersion apiVersion = SignalingGetSettingsApiVersion.v3,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    if (token != '') {
      queryParameters['token'] = token;
    }
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/signaling/settings';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<SignalingGetSettingsResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(SignalingGetSettingsResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Get the welcome message from a signaling server.
  ///
  /// Only available for logged-in users because guests can not use the apps right now.
  /// This endpoint requires admin access.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v3`.
  ///   * [serverId] ID of the signaling server.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Welcome message returned
  ///   * 404: Signaling server not found
  ///   * 500
  ///
  /// See:
  ///  * [getWelcomeMessageRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<SignalingGetWelcomeMessageResponseApplicationJson, void>> getWelcomeMessage({
    required final int serverId,
    final SignalingGetWelcomeMessageApiVersion apiVersion = SignalingGetWelcomeMessageApiVersion.v3,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = getWelcomeMessageRaw(
      serverId: serverId,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Get the welcome message from a signaling server.
  ///
  /// Only available for logged-in users because guests can not use the apps right now.
  /// This endpoint requires admin access.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v3`.
  ///   * [serverId] ID of the signaling server.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Welcome message returned
  ///   * 404: Signaling server not found
  ///   * 500
  ///
  /// See:
  ///  * [getWelcomeMessage] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<SignalingGetWelcomeMessageResponseApplicationJson, void> getWelcomeMessageRaw({
    required final int serverId,
    final SignalingGetWelcomeMessageApiVersion apiVersion = SignalingGetWelcomeMessageApiVersion.v3,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    final serverId0 = Uri.encodeQueryComponent(serverId.toString());
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/signaling/welcome/$serverId0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<SignalingGetWelcomeMessageResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(SignalingGetWelcomeMessageResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Get signaling messages.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v3`.
  ///   * [token] Token of the room.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Signaling messages returned
  ///   * 404: Session, room or participant not found
  ///   * 409: Session killed
  ///   * 400: Getting signaling messages is not possible
  ///
  /// See:
  ///  * [pullMessagesRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<SignalingPullMessagesResponseApplicationJson, void>> pullMessages({
    required final String token,
    final SignalingPullMessagesApiVersion apiVersion = SignalingPullMessagesApiVersion.v3,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = pullMessagesRaw(
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Get signaling messages.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [apiVersion] Defaults to `v3`.
  ///   * [token] Token of the room.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Signaling messages returned
  ///   * 404: Session, room or participant not found
  ///   * 409: Session killed
  ///   * 400: Getting signaling messages is not possible
  ///
  /// See:
  ///  * [pullMessages] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<SignalingPullMessagesResponseApplicationJson, void> pullMessagesRaw({
    required final String token,
    final SignalingPullMessagesApiVersion apiVersion = SignalingPullMessagesApiVersion.v3,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/signaling/$token0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<SignalingPullMessagesResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'get',
        uri,
        headers,
        body,
        const {200, 404, 409},
      ),
      bodyType: const FullType(SignalingPullMessagesResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Send signaling messages.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [messages] JSON encoded messages.
  ///   * [apiVersion] Defaults to `v3`.
  ///   * [token] Token of the room.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Signaling message sent successfully
  ///   * 400: Sending signaling message is not possible
  ///
  /// See:
  ///  * [sendMessagesRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<SignalingSendMessagesResponseApplicationJson, void>> sendMessages({
    required final String messages,
    required final String token,
    final SignalingSendMessagesApiVersion apiVersion = SignalingSendMessagesApiVersion.v3,
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = sendMessagesRaw(
      messages: messages,
      token: token,
      apiVersion: apiVersion,
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Send signaling messages.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [messages] JSON encoded messages.
  ///   * [apiVersion] Defaults to `v3`.
  ///   * [token] Token of the room.
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Signaling message sent successfully
  ///   * 400: Sending signaling message is not possible
  ///
  /// See:
  ///  * [sendMessages] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<SignalingSendMessagesResponseApplicationJson, void> sendMessagesRaw({
    required final String messages,
    required final String token,
    final SignalingSendMessagesApiVersion apiVersion = SignalingSendMessagesApiVersion.v3,
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    }

// coverage:ignore-end
    queryParameters['messages'] = messages;
    checkPattern(token, RegExp(r'^[a-z0-9]{4,30}$'), 'token'); // coverage:ignore-line
    final token0 = Uri.encodeQueryComponent(token);
    final apiVersion0 = Uri.encodeQueryComponent(apiVersion.name);
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    final path = '/ocs/v2.php/apps/spreed/api/$apiVersion0/signaling/$token0';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<SignalingSendMessagesResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(SignalingSendMessagesResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }
}

class TempAvatarClient {
  TempAvatarClient(this._rootClient);

  final Client _rootClient;

  /// Upload a temporary avatar.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Avatar uploaded successfully
  ///   * 400: Uploading avatar is not possible
  ///
  /// See:
  ///  * [postAvatarRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<TempAvatarPostAvatarResponseApplicationJson, void>> postAvatar({
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = postAvatarRaw(
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Upload a temporary avatar.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Avatar uploaded successfully
  ///   * 400: Uploading avatar is not possible
  ///
  /// See:
  ///  * [postAvatar] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<TempAvatarPostAvatarResponseApplicationJson, void> postAvatarRaw({
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    const path = '/ocs/v2.php/apps/spreed/temp-user-avatar';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<TempAvatarPostAvatarResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'post',
        uri,
        headers,
        body,
        const {200},
      ),
      bodyType: const FullType(TempAvatarPostAvatarResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }

  /// Delete a temporary avatar.
  ///
  /// Returns a [Future] containing a [DynamiteResponse] with the status code, deserialized body and headers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Avatar deleted successfully
  ///   * 400: Deleting avatar is not possible
  ///
  /// See:
  ///  * [deleteAvatarRaw] for an experimental operation that returns a [DynamiteRawResponse] that can be serialized.
  Future<DynamiteResponse<TempAvatarDeleteAvatarResponseApplicationJson, void>> deleteAvatar({
    final bool oCSAPIRequest = true,
  }) async {
    final rawResponse = deleteAvatarRaw(
      oCSAPIRequest: oCSAPIRequest,
    );

    return rawResponse.future;
  }

  /// Delete a temporary avatar.
  ///
  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a [DynamiteRawResponse] with the raw [HttpClientResponse] and serialization helpers.
  /// Throws a [DynamiteApiException] if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [oCSAPIRequest] Required to be true for the API request to pass. Defaults to `true`.
  ///
  /// Status codes:
  ///   * 200: Avatar deleted successfully
  ///   * 400: Deleting avatar is not possible
  ///
  /// See:
  ///  * [deleteAvatar] for an operation that returns a [DynamiteResponse] with a stable API.
  @experimental
  DynamiteRawResponse<TempAvatarDeleteAvatarResponseApplicationJson, void> deleteAvatarRaw({
    final bool oCSAPIRequest = true,
  }) {
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
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
    headers['OCS-APIRequest'] = oCSAPIRequest.toString();
    const path = '/ocs/v2.php/apps/spreed/temp-user-avatar';
    final uri = Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null);

    return DynamiteRawResponse<TempAvatarDeleteAvatarResponseApplicationJson, void>(
      response: _rootClient.executeRequest(
        'delete',
        uri,
        headers,
        body,
        const {200, 400},
      ),
      bodyType: const FullType(TempAvatarDeleteAvatarResponseApplicationJson),
      headersType: null,
      serializers: _jsonSerializers,
    );
  }
}

class AvatarGetAvatarApiVersion extends EnumClass {
  const AvatarGetAvatarApiVersion._(super.name);

  static const AvatarGetAvatarApiVersion v1 = _$avatarGetAvatarApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<AvatarGetAvatarApiVersion> get values => _$avatarGetAvatarApiVersionValues;
  // coverage:ignore-end
  static AvatarGetAvatarApiVersion valueOf(final String name) => _$valueOfAvatarGetAvatarApiVersion(name);
  static Serializer<AvatarGetAvatarApiVersion> get serializer => _$avatarGetAvatarApiVersionSerializer;
}

class AvatarUploadAvatarApiVersion extends EnumClass {
  const AvatarUploadAvatarApiVersion._(super.name);

  static const AvatarUploadAvatarApiVersion v1 = _$avatarUploadAvatarApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<AvatarUploadAvatarApiVersion> get values => _$avatarUploadAvatarApiVersionValues;
  // coverage:ignore-end
  static AvatarUploadAvatarApiVersion valueOf(final String name) => _$valueOfAvatarUploadAvatarApiVersion(name);
  static Serializer<AvatarUploadAvatarApiVersion> get serializer => _$avatarUploadAvatarApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class OCSMetaInterface {
  String get status;
  int get statuscode;
  String? get message;
  String? get totalitems;
  String? get itemsperpage;
}

abstract class OCSMeta implements OCSMetaInterface, Built<OCSMeta, OCSMetaBuilder> {
  factory OCSMeta([final void Function(OCSMetaBuilder)? b]) = _$OCSMeta;

  // coverage:ignore-start
  const OCSMeta._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory OCSMeta.fromJson(final Map<String, dynamic> json) => _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<OCSMeta> get serializer => _$oCSMetaSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatMessageInterface {
  String get actorDisplayName;
  String get actorId;
  String get actorType;
  bool? get deleted;
  int get expirationTimestamp;
  int get id;
  bool get isReplyable;
  bool get markdown;
  String get message;
  BuiltMap<String, BuiltMap<String, JsonObject>> get messageParameters;
  String get messageType;
  BuiltMap<String, int> get reactions;
  String get referenceId;
  String get systemMessage;
  int get timestamp;
  String get token;
}

abstract class ChatMessage implements ChatMessageInterface, Built<ChatMessage, ChatMessageBuilder> {
  factory ChatMessage([final void Function(ChatMessageBuilder)? b]) = _$ChatMessage;

  // coverage:ignore-start
  const ChatMessage._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatMessage.fromJson(final Map<String, dynamic> json) => _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatMessage> get serializer => _$chatMessageSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class Room_LastMessageInterface {
  ChatMessage? get chatMessage;
  BuiltList<JsonObject>? get builtListJsonObject;
}

abstract class Room_LastMessage implements Room_LastMessageInterface, Built<Room_LastMessage, Room_LastMessageBuilder> {
  factory Room_LastMessage([final void Function(Room_LastMessageBuilder)? b]) = _$Room_LastMessage;

  // coverage:ignore-start
  const Room_LastMessage._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory Room_LastMessage.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  @BuiltValueSerializer(custom: true)
  static Serializer<Room_LastMessage> get serializer => _$Room_LastMessageSerializer();
  JsonObject get data;
  @BuiltValueHook(finalizeBuilder: true)
  static void _validate(final Room_LastMessageBuilder b) {
    // When this is rebuild from another builder
    if (b._data == null) {
      return;
    }

    final match = [b._chatMessage, b._builtListJsonObject].firstWhereOrNull((final x) => x != null);
    if (match == null) {
      throw StateError("Need at least one of 'chatMessage', 'builtListJsonObject' for ${b._data}");
    }
  }
}

class _$Room_LastMessageSerializer implements PrimitiveSerializer<Room_LastMessage> {
  @override
  final Iterable<Type> types = const [Room_LastMessage, _$Room_LastMessage];

  @override
  final String wireName = 'Room_LastMessage';

  @override
  Object serialize(
    final Serializers serializers,
    final Room_LastMessage object, {
    final FullType specifiedType = FullType.unspecified,
  }) =>
      object.data.value;

  @override
  Room_LastMessage deserialize(
    final Serializers serializers,
    final Object data, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    final result = Room_LastMessageBuilder()..data = JsonObject(data);
    try {
      final value = _jsonSerializers.deserialize(data, specifiedType: const FullType(ChatMessage))! as ChatMessage;
      result.chatMessage.replace(value);
    } catch (_) {}
    try {
      final value = _jsonSerializers.deserialize(
        data,
        specifiedType: const FullType(BuiltList, [FullType(JsonObject)]),
      )! as BuiltList<JsonObject>;
      result.builtListJsonObject.replace(value);
    } catch (_) {}
    return result.build();
  }
}

@BuiltValue(instantiable: false)
abstract interface class RoomInterface {
  String get actorId;
  String get actorType;
  int get attendeeId;
  int get attendeePermissions;
  String? get attendeePin;
  String get avatarVersion;
  int get breakoutRoomMode;
  int get breakoutRoomStatus;
  int get callFlag;
  int get callPermissions;
  int get callRecording;
  int get callStartTime;
  bool get canDeleteConversation;
  bool get canEnableSIP;
  bool get canLeaveConversation;
  bool get canStartCall;
  int get defaultPermissions;
  String get description;
  String get displayName;
  bool get hasCall;
  bool get hasPassword;
  int get id;
  bool get isCustomAvatar;
  bool get isFavorite;
  int get lastActivity;
  int get lastCommonReadMessage;
  Room_LastMessage get lastMessage;
  int get lastPing;
  int get lastReadMessage;
  int get listable;
  int get lobbyState;
  int get lobbyTimer;
  int get messageExpiration;
  String get name;
  int get notificationCalls;
  int get notificationLevel;
  String get objectId;
  String get objectType;
  int get participantFlags;
  int get participantType;
  int get permissions;
  int get readOnly;
  int? get recordingConsent;
  String get sessionId;
  int get sipEnabled;
  String? get status;
  int? get statusClearAt;
  String? get statusIcon;
  String? get statusMessage;
  String get token;
  int get type;
  bool get unreadMention;
  bool get unreadMentionDirect;
  int get unreadMessages;
}

abstract class Room implements RoomInterface, Built<Room, RoomBuilder> {
  factory Room([final void Function(RoomBuilder)? b]) = _$Room;

  // coverage:ignore-start
  const Room._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory Room.fromJson(final Map<String, dynamic> json) => _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<Room> get serializer => _$roomSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class AvatarUploadAvatarResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  Room get data;
}

abstract class AvatarUploadAvatarResponseApplicationJson_Ocs
    implements
        AvatarUploadAvatarResponseApplicationJson_OcsInterface,
        Built<AvatarUploadAvatarResponseApplicationJson_Ocs, AvatarUploadAvatarResponseApplicationJson_OcsBuilder> {
  factory AvatarUploadAvatarResponseApplicationJson_Ocs([
    final void Function(AvatarUploadAvatarResponseApplicationJson_OcsBuilder)? b,
  ]) = _$AvatarUploadAvatarResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const AvatarUploadAvatarResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory AvatarUploadAvatarResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<AvatarUploadAvatarResponseApplicationJson_Ocs> get serializer =>
      _$avatarUploadAvatarResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class AvatarUploadAvatarResponseApplicationJsonInterface {
  AvatarUploadAvatarResponseApplicationJson_Ocs get ocs;
}

abstract class AvatarUploadAvatarResponseApplicationJson
    implements
        AvatarUploadAvatarResponseApplicationJsonInterface,
        Built<AvatarUploadAvatarResponseApplicationJson, AvatarUploadAvatarResponseApplicationJsonBuilder> {
  factory AvatarUploadAvatarResponseApplicationJson([
    final void Function(AvatarUploadAvatarResponseApplicationJsonBuilder)? b,
  ]) = _$AvatarUploadAvatarResponseApplicationJson;

  // coverage:ignore-start
  const AvatarUploadAvatarResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory AvatarUploadAvatarResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<AvatarUploadAvatarResponseApplicationJson> get serializer =>
      _$avatarUploadAvatarResponseApplicationJsonSerializer;
}

class AvatarDeleteAvatarApiVersion extends EnumClass {
  const AvatarDeleteAvatarApiVersion._(super.name);

  static const AvatarDeleteAvatarApiVersion v1 = _$avatarDeleteAvatarApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<AvatarDeleteAvatarApiVersion> get values => _$avatarDeleteAvatarApiVersionValues;
  // coverage:ignore-end
  static AvatarDeleteAvatarApiVersion valueOf(final String name) => _$valueOfAvatarDeleteAvatarApiVersion(name);
  static Serializer<AvatarDeleteAvatarApiVersion> get serializer => _$avatarDeleteAvatarApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class AvatarDeleteAvatarResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  Room get data;
}

abstract class AvatarDeleteAvatarResponseApplicationJson_Ocs
    implements
        AvatarDeleteAvatarResponseApplicationJson_OcsInterface,
        Built<AvatarDeleteAvatarResponseApplicationJson_Ocs, AvatarDeleteAvatarResponseApplicationJson_OcsBuilder> {
  factory AvatarDeleteAvatarResponseApplicationJson_Ocs([
    final void Function(AvatarDeleteAvatarResponseApplicationJson_OcsBuilder)? b,
  ]) = _$AvatarDeleteAvatarResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const AvatarDeleteAvatarResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory AvatarDeleteAvatarResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<AvatarDeleteAvatarResponseApplicationJson_Ocs> get serializer =>
      _$avatarDeleteAvatarResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class AvatarDeleteAvatarResponseApplicationJsonInterface {
  AvatarDeleteAvatarResponseApplicationJson_Ocs get ocs;
}

abstract class AvatarDeleteAvatarResponseApplicationJson
    implements
        AvatarDeleteAvatarResponseApplicationJsonInterface,
        Built<AvatarDeleteAvatarResponseApplicationJson, AvatarDeleteAvatarResponseApplicationJsonBuilder> {
  factory AvatarDeleteAvatarResponseApplicationJson([
    final void Function(AvatarDeleteAvatarResponseApplicationJsonBuilder)? b,
  ]) = _$AvatarDeleteAvatarResponseApplicationJson;

  // coverage:ignore-start
  const AvatarDeleteAvatarResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory AvatarDeleteAvatarResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<AvatarDeleteAvatarResponseApplicationJson> get serializer =>
      _$avatarDeleteAvatarResponseApplicationJsonSerializer;
}

class AvatarEmojiAvatarApiVersion extends EnumClass {
  const AvatarEmojiAvatarApiVersion._(super.name);

  static const AvatarEmojiAvatarApiVersion v1 = _$avatarEmojiAvatarApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<AvatarEmojiAvatarApiVersion> get values => _$avatarEmojiAvatarApiVersionValues;
  // coverage:ignore-end
  static AvatarEmojiAvatarApiVersion valueOf(final String name) => _$valueOfAvatarEmojiAvatarApiVersion(name);
  static Serializer<AvatarEmojiAvatarApiVersion> get serializer => _$avatarEmojiAvatarApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class AvatarEmojiAvatarResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  Room get data;
}

abstract class AvatarEmojiAvatarResponseApplicationJson_Ocs
    implements
        AvatarEmojiAvatarResponseApplicationJson_OcsInterface,
        Built<AvatarEmojiAvatarResponseApplicationJson_Ocs, AvatarEmojiAvatarResponseApplicationJson_OcsBuilder> {
  factory AvatarEmojiAvatarResponseApplicationJson_Ocs([
    final void Function(AvatarEmojiAvatarResponseApplicationJson_OcsBuilder)? b,
  ]) = _$AvatarEmojiAvatarResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const AvatarEmojiAvatarResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory AvatarEmojiAvatarResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<AvatarEmojiAvatarResponseApplicationJson_Ocs> get serializer =>
      _$avatarEmojiAvatarResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class AvatarEmojiAvatarResponseApplicationJsonInterface {
  AvatarEmojiAvatarResponseApplicationJson_Ocs get ocs;
}

abstract class AvatarEmojiAvatarResponseApplicationJson
    implements
        AvatarEmojiAvatarResponseApplicationJsonInterface,
        Built<AvatarEmojiAvatarResponseApplicationJson, AvatarEmojiAvatarResponseApplicationJsonBuilder> {
  factory AvatarEmojiAvatarResponseApplicationJson([
    final void Function(AvatarEmojiAvatarResponseApplicationJsonBuilder)? b,
  ]) = _$AvatarEmojiAvatarResponseApplicationJson;

  // coverage:ignore-start
  const AvatarEmojiAvatarResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory AvatarEmojiAvatarResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<AvatarEmojiAvatarResponseApplicationJson> get serializer =>
      _$avatarEmojiAvatarResponseApplicationJsonSerializer;
}

class AvatarGetAvatarDarkApiVersion extends EnumClass {
  const AvatarGetAvatarDarkApiVersion._(super.name);

  static const AvatarGetAvatarDarkApiVersion v1 = _$avatarGetAvatarDarkApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<AvatarGetAvatarDarkApiVersion> get values => _$avatarGetAvatarDarkApiVersionValues;
  // coverage:ignore-end
  static AvatarGetAvatarDarkApiVersion valueOf(final String name) => _$valueOfAvatarGetAvatarDarkApiVersion(name);
  static Serializer<AvatarGetAvatarDarkApiVersion> get serializer => _$avatarGetAvatarDarkApiVersionSerializer;
}

class BotSendMessageApiVersion extends EnumClass {
  const BotSendMessageApiVersion._(super.name);

  static const BotSendMessageApiVersion v1 = _$botSendMessageApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<BotSendMessageApiVersion> get values => _$botSendMessageApiVersionValues;
  // coverage:ignore-end
  static BotSendMessageApiVersion valueOf(final String name) => _$valueOfBotSendMessageApiVersion(name);
  static Serializer<BotSendMessageApiVersion> get serializer => _$botSendMessageApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BotSendMessageResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class BotSendMessageResponseApplicationJson_Ocs
    implements
        BotSendMessageResponseApplicationJson_OcsInterface,
        Built<BotSendMessageResponseApplicationJson_Ocs, BotSendMessageResponseApplicationJson_OcsBuilder> {
  factory BotSendMessageResponseApplicationJson_Ocs([
    final void Function(BotSendMessageResponseApplicationJson_OcsBuilder)? b,
  ]) = _$BotSendMessageResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const BotSendMessageResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BotSendMessageResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BotSendMessageResponseApplicationJson_Ocs> get serializer =>
      _$botSendMessageResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BotSendMessageResponseApplicationJsonInterface {
  BotSendMessageResponseApplicationJson_Ocs get ocs;
}

abstract class BotSendMessageResponseApplicationJson
    implements
        BotSendMessageResponseApplicationJsonInterface,
        Built<BotSendMessageResponseApplicationJson, BotSendMessageResponseApplicationJsonBuilder> {
  factory BotSendMessageResponseApplicationJson([
    final void Function(BotSendMessageResponseApplicationJsonBuilder)? b,
  ]) = _$BotSendMessageResponseApplicationJson;

  // coverage:ignore-start
  const BotSendMessageResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BotSendMessageResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BotSendMessageResponseApplicationJson> get serializer =>
      _$botSendMessageResponseApplicationJsonSerializer;
}

class BotReactApiVersion extends EnumClass {
  const BotReactApiVersion._(super.name);

  static const BotReactApiVersion v1 = _$botReactApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<BotReactApiVersion> get values => _$botReactApiVersionValues;
  // coverage:ignore-end
  static BotReactApiVersion valueOf(final String name) => _$valueOfBotReactApiVersion(name);
  static Serializer<BotReactApiVersion> get serializer => _$botReactApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BotReactResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class BotReactResponseApplicationJson_Ocs
    implements
        BotReactResponseApplicationJson_OcsInterface,
        Built<BotReactResponseApplicationJson_Ocs, BotReactResponseApplicationJson_OcsBuilder> {
  factory BotReactResponseApplicationJson_Ocs([final void Function(BotReactResponseApplicationJson_OcsBuilder)? b]) =
      _$BotReactResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const BotReactResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BotReactResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BotReactResponseApplicationJson_Ocs> get serializer =>
      _$botReactResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BotReactResponseApplicationJsonInterface {
  BotReactResponseApplicationJson_Ocs get ocs;
}

abstract class BotReactResponseApplicationJson
    implements
        BotReactResponseApplicationJsonInterface,
        Built<BotReactResponseApplicationJson, BotReactResponseApplicationJsonBuilder> {
  factory BotReactResponseApplicationJson([final void Function(BotReactResponseApplicationJsonBuilder)? b]) =
      _$BotReactResponseApplicationJson;

  // coverage:ignore-start
  const BotReactResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BotReactResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BotReactResponseApplicationJson> get serializer => _$botReactResponseApplicationJsonSerializer;
}

class BotDeleteReactionApiVersion extends EnumClass {
  const BotDeleteReactionApiVersion._(super.name);

  static const BotDeleteReactionApiVersion v1 = _$botDeleteReactionApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<BotDeleteReactionApiVersion> get values => _$botDeleteReactionApiVersionValues;
  // coverage:ignore-end
  static BotDeleteReactionApiVersion valueOf(final String name) => _$valueOfBotDeleteReactionApiVersion(name);
  static Serializer<BotDeleteReactionApiVersion> get serializer => _$botDeleteReactionApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BotDeleteReactionResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class BotDeleteReactionResponseApplicationJson_Ocs
    implements
        BotDeleteReactionResponseApplicationJson_OcsInterface,
        Built<BotDeleteReactionResponseApplicationJson_Ocs, BotDeleteReactionResponseApplicationJson_OcsBuilder> {
  factory BotDeleteReactionResponseApplicationJson_Ocs([
    final void Function(BotDeleteReactionResponseApplicationJson_OcsBuilder)? b,
  ]) = _$BotDeleteReactionResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const BotDeleteReactionResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BotDeleteReactionResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BotDeleteReactionResponseApplicationJson_Ocs> get serializer =>
      _$botDeleteReactionResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BotDeleteReactionResponseApplicationJsonInterface {
  BotDeleteReactionResponseApplicationJson_Ocs get ocs;
}

abstract class BotDeleteReactionResponseApplicationJson
    implements
        BotDeleteReactionResponseApplicationJsonInterface,
        Built<BotDeleteReactionResponseApplicationJson, BotDeleteReactionResponseApplicationJsonBuilder> {
  factory BotDeleteReactionResponseApplicationJson([
    final void Function(BotDeleteReactionResponseApplicationJsonBuilder)? b,
  ]) = _$BotDeleteReactionResponseApplicationJson;

  // coverage:ignore-start
  const BotDeleteReactionResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BotDeleteReactionResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BotDeleteReactionResponseApplicationJson> get serializer =>
      _$botDeleteReactionResponseApplicationJsonSerializer;
}

class BotAdminListBotsApiVersion extends EnumClass {
  const BotAdminListBotsApiVersion._(super.name);

  static const BotAdminListBotsApiVersion v1 = _$botAdminListBotsApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<BotAdminListBotsApiVersion> get values => _$botAdminListBotsApiVersionValues;
  // coverage:ignore-end
  static BotAdminListBotsApiVersion valueOf(final String name) => _$valueOfBotAdminListBotsApiVersion(name);
  static Serializer<BotAdminListBotsApiVersion> get serializer => _$botAdminListBotsApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BotInterface {
  String? get description;
  int get id;
  String get name;
  int get state;
}

abstract class Bot implements BotInterface, Built<Bot, BotBuilder> {
  factory Bot([final void Function(BotBuilder)? b]) = _$Bot;

  // coverage:ignore-start
  const Bot._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory Bot.fromJson(final Map<String, dynamic> json) => _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<Bot> get serializer => _$botSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BotWithDetails_1Interface {
  @BuiltValueField(wireName: 'error_count')
  int get errorCount;
  int get features;
  @BuiltValueField(wireName: 'last_error_date')
  int get lastErrorDate;
  @BuiltValueField(wireName: 'last_error_message')
  String get lastErrorMessage;
  String get url;
  @BuiltValueField(wireName: 'url_hash')
  String get urlHash;
}

@BuiltValue(instantiable: false)
abstract interface class BotWithDetailsInterface implements BotInterface, BotWithDetails_1Interface {}

abstract class BotWithDetails implements BotWithDetailsInterface, Built<BotWithDetails, BotWithDetailsBuilder> {
  factory BotWithDetails([final void Function(BotWithDetailsBuilder)? b]) = _$BotWithDetails;

  // coverage:ignore-start
  const BotWithDetails._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BotWithDetails.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BotWithDetails> get serializer => _$botWithDetailsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BotAdminListBotsResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  BuiltList<BotWithDetails> get data;
}

abstract class BotAdminListBotsResponseApplicationJson_Ocs
    implements
        BotAdminListBotsResponseApplicationJson_OcsInterface,
        Built<BotAdminListBotsResponseApplicationJson_Ocs, BotAdminListBotsResponseApplicationJson_OcsBuilder> {
  factory BotAdminListBotsResponseApplicationJson_Ocs([
    final void Function(BotAdminListBotsResponseApplicationJson_OcsBuilder)? b,
  ]) = _$BotAdminListBotsResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const BotAdminListBotsResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BotAdminListBotsResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BotAdminListBotsResponseApplicationJson_Ocs> get serializer =>
      _$botAdminListBotsResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BotAdminListBotsResponseApplicationJsonInterface {
  BotAdminListBotsResponseApplicationJson_Ocs get ocs;
}

abstract class BotAdminListBotsResponseApplicationJson
    implements
        BotAdminListBotsResponseApplicationJsonInterface,
        Built<BotAdminListBotsResponseApplicationJson, BotAdminListBotsResponseApplicationJsonBuilder> {
  factory BotAdminListBotsResponseApplicationJson([
    final void Function(BotAdminListBotsResponseApplicationJsonBuilder)? b,
  ]) = _$BotAdminListBotsResponseApplicationJson;

  // coverage:ignore-start
  const BotAdminListBotsResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BotAdminListBotsResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BotAdminListBotsResponseApplicationJson> get serializer =>
      _$botAdminListBotsResponseApplicationJsonSerializer;
}

class BotListBotsApiVersion extends EnumClass {
  const BotListBotsApiVersion._(super.name);

  static const BotListBotsApiVersion v1 = _$botListBotsApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<BotListBotsApiVersion> get values => _$botListBotsApiVersionValues;
  // coverage:ignore-end
  static BotListBotsApiVersion valueOf(final String name) => _$valueOfBotListBotsApiVersion(name);
  static Serializer<BotListBotsApiVersion> get serializer => _$botListBotsApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BotListBotsResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  BuiltList<Bot> get data;
}

abstract class BotListBotsResponseApplicationJson_Ocs
    implements
        BotListBotsResponseApplicationJson_OcsInterface,
        Built<BotListBotsResponseApplicationJson_Ocs, BotListBotsResponseApplicationJson_OcsBuilder> {
  factory BotListBotsResponseApplicationJson_Ocs([
    final void Function(BotListBotsResponseApplicationJson_OcsBuilder)? b,
  ]) = _$BotListBotsResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const BotListBotsResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BotListBotsResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BotListBotsResponseApplicationJson_Ocs> get serializer =>
      _$botListBotsResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BotListBotsResponseApplicationJsonInterface {
  BotListBotsResponseApplicationJson_Ocs get ocs;
}

abstract class BotListBotsResponseApplicationJson
    implements
        BotListBotsResponseApplicationJsonInterface,
        Built<BotListBotsResponseApplicationJson, BotListBotsResponseApplicationJsonBuilder> {
  factory BotListBotsResponseApplicationJson([final void Function(BotListBotsResponseApplicationJsonBuilder)? b]) =
      _$BotListBotsResponseApplicationJson;

  // coverage:ignore-start
  const BotListBotsResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BotListBotsResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BotListBotsResponseApplicationJson> get serializer =>
      _$botListBotsResponseApplicationJsonSerializer;
}

class BotEnableBotApiVersion extends EnumClass {
  const BotEnableBotApiVersion._(super.name);

  static const BotEnableBotApiVersion v1 = _$botEnableBotApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<BotEnableBotApiVersion> get values => _$botEnableBotApiVersionValues;
  // coverage:ignore-end
  static BotEnableBotApiVersion valueOf(final String name) => _$valueOfBotEnableBotApiVersion(name);
  static Serializer<BotEnableBotApiVersion> get serializer => _$botEnableBotApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BotEnableBotResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  Bot? get data;
}

abstract class BotEnableBotResponseApplicationJson_Ocs
    implements
        BotEnableBotResponseApplicationJson_OcsInterface,
        Built<BotEnableBotResponseApplicationJson_Ocs, BotEnableBotResponseApplicationJson_OcsBuilder> {
  factory BotEnableBotResponseApplicationJson_Ocs([
    final void Function(BotEnableBotResponseApplicationJson_OcsBuilder)? b,
  ]) = _$BotEnableBotResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const BotEnableBotResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BotEnableBotResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BotEnableBotResponseApplicationJson_Ocs> get serializer =>
      _$botEnableBotResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BotEnableBotResponseApplicationJsonInterface {
  BotEnableBotResponseApplicationJson_Ocs get ocs;
}

abstract class BotEnableBotResponseApplicationJson
    implements
        BotEnableBotResponseApplicationJsonInterface,
        Built<BotEnableBotResponseApplicationJson, BotEnableBotResponseApplicationJsonBuilder> {
  factory BotEnableBotResponseApplicationJson([final void Function(BotEnableBotResponseApplicationJsonBuilder)? b]) =
      _$BotEnableBotResponseApplicationJson;

  // coverage:ignore-start
  const BotEnableBotResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BotEnableBotResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BotEnableBotResponseApplicationJson> get serializer =>
      _$botEnableBotResponseApplicationJsonSerializer;
}

class BotDisableBotApiVersion extends EnumClass {
  const BotDisableBotApiVersion._(super.name);

  static const BotDisableBotApiVersion v1 = _$botDisableBotApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<BotDisableBotApiVersion> get values => _$botDisableBotApiVersionValues;
  // coverage:ignore-end
  static BotDisableBotApiVersion valueOf(final String name) => _$valueOfBotDisableBotApiVersion(name);
  static Serializer<BotDisableBotApiVersion> get serializer => _$botDisableBotApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BotDisableBotResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  Bot? get data;
}

abstract class BotDisableBotResponseApplicationJson_Ocs
    implements
        BotDisableBotResponseApplicationJson_OcsInterface,
        Built<BotDisableBotResponseApplicationJson_Ocs, BotDisableBotResponseApplicationJson_OcsBuilder> {
  factory BotDisableBotResponseApplicationJson_Ocs([
    final void Function(BotDisableBotResponseApplicationJson_OcsBuilder)? b,
  ]) = _$BotDisableBotResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const BotDisableBotResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BotDisableBotResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BotDisableBotResponseApplicationJson_Ocs> get serializer =>
      _$botDisableBotResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BotDisableBotResponseApplicationJsonInterface {
  BotDisableBotResponseApplicationJson_Ocs get ocs;
}

abstract class BotDisableBotResponseApplicationJson
    implements
        BotDisableBotResponseApplicationJsonInterface,
        Built<BotDisableBotResponseApplicationJson, BotDisableBotResponseApplicationJsonBuilder> {
  factory BotDisableBotResponseApplicationJson([final void Function(BotDisableBotResponseApplicationJsonBuilder)? b]) =
      _$BotDisableBotResponseApplicationJson;

  // coverage:ignore-start
  const BotDisableBotResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BotDisableBotResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BotDisableBotResponseApplicationJson> get serializer =>
      _$botDisableBotResponseApplicationJsonSerializer;
}

class BreakoutRoomConfigureBreakoutRoomsApiVersion extends EnumClass {
  const BreakoutRoomConfigureBreakoutRoomsApiVersion._(super.name);

  static const BreakoutRoomConfigureBreakoutRoomsApiVersion v1 = _$breakoutRoomConfigureBreakoutRoomsApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<BreakoutRoomConfigureBreakoutRoomsApiVersion> get values =>
      _$breakoutRoomConfigureBreakoutRoomsApiVersionValues;
  // coverage:ignore-end
  static BreakoutRoomConfigureBreakoutRoomsApiVersion valueOf(final String name) =>
      _$valueOfBreakoutRoomConfigureBreakoutRoomsApiVersion(name);
  static Serializer<BreakoutRoomConfigureBreakoutRoomsApiVersion> get serializer =>
      _$breakoutRoomConfigureBreakoutRoomsApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BreakoutRoomConfigureBreakoutRoomsResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  BuiltList<Room> get data;
}

abstract class BreakoutRoomConfigureBreakoutRoomsResponseApplicationJson_Ocs
    implements
        BreakoutRoomConfigureBreakoutRoomsResponseApplicationJson_OcsInterface,
        Built<BreakoutRoomConfigureBreakoutRoomsResponseApplicationJson_Ocs,
            BreakoutRoomConfigureBreakoutRoomsResponseApplicationJson_OcsBuilder> {
  factory BreakoutRoomConfigureBreakoutRoomsResponseApplicationJson_Ocs([
    final void Function(BreakoutRoomConfigureBreakoutRoomsResponseApplicationJson_OcsBuilder)? b,
  ]) = _$BreakoutRoomConfigureBreakoutRoomsResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const BreakoutRoomConfigureBreakoutRoomsResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BreakoutRoomConfigureBreakoutRoomsResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BreakoutRoomConfigureBreakoutRoomsResponseApplicationJson_Ocs> get serializer =>
      _$breakoutRoomConfigureBreakoutRoomsResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BreakoutRoomConfigureBreakoutRoomsResponseApplicationJsonInterface {
  BreakoutRoomConfigureBreakoutRoomsResponseApplicationJson_Ocs get ocs;
}

abstract class BreakoutRoomConfigureBreakoutRoomsResponseApplicationJson
    implements
        BreakoutRoomConfigureBreakoutRoomsResponseApplicationJsonInterface,
        Built<BreakoutRoomConfigureBreakoutRoomsResponseApplicationJson,
            BreakoutRoomConfigureBreakoutRoomsResponseApplicationJsonBuilder> {
  factory BreakoutRoomConfigureBreakoutRoomsResponseApplicationJson([
    final void Function(BreakoutRoomConfigureBreakoutRoomsResponseApplicationJsonBuilder)? b,
  ]) = _$BreakoutRoomConfigureBreakoutRoomsResponseApplicationJson;

  // coverage:ignore-start
  const BreakoutRoomConfigureBreakoutRoomsResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BreakoutRoomConfigureBreakoutRoomsResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BreakoutRoomConfigureBreakoutRoomsResponseApplicationJson> get serializer =>
      _$breakoutRoomConfigureBreakoutRoomsResponseApplicationJsonSerializer;
}

class BreakoutRoomRemoveBreakoutRoomsApiVersion extends EnumClass {
  const BreakoutRoomRemoveBreakoutRoomsApiVersion._(super.name);

  static const BreakoutRoomRemoveBreakoutRoomsApiVersion v1 = _$breakoutRoomRemoveBreakoutRoomsApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<BreakoutRoomRemoveBreakoutRoomsApiVersion> get values =>
      _$breakoutRoomRemoveBreakoutRoomsApiVersionValues;
  // coverage:ignore-end
  static BreakoutRoomRemoveBreakoutRoomsApiVersion valueOf(final String name) =>
      _$valueOfBreakoutRoomRemoveBreakoutRoomsApiVersion(name);
  static Serializer<BreakoutRoomRemoveBreakoutRoomsApiVersion> get serializer =>
      _$breakoutRoomRemoveBreakoutRoomsApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BreakoutRoomRemoveBreakoutRoomsResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  Room get data;
}

abstract class BreakoutRoomRemoveBreakoutRoomsResponseApplicationJson_Ocs
    implements
        BreakoutRoomRemoveBreakoutRoomsResponseApplicationJson_OcsInterface,
        Built<BreakoutRoomRemoveBreakoutRoomsResponseApplicationJson_Ocs,
            BreakoutRoomRemoveBreakoutRoomsResponseApplicationJson_OcsBuilder> {
  factory BreakoutRoomRemoveBreakoutRoomsResponseApplicationJson_Ocs([
    final void Function(BreakoutRoomRemoveBreakoutRoomsResponseApplicationJson_OcsBuilder)? b,
  ]) = _$BreakoutRoomRemoveBreakoutRoomsResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const BreakoutRoomRemoveBreakoutRoomsResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BreakoutRoomRemoveBreakoutRoomsResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BreakoutRoomRemoveBreakoutRoomsResponseApplicationJson_Ocs> get serializer =>
      _$breakoutRoomRemoveBreakoutRoomsResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BreakoutRoomRemoveBreakoutRoomsResponseApplicationJsonInterface {
  BreakoutRoomRemoveBreakoutRoomsResponseApplicationJson_Ocs get ocs;
}

abstract class BreakoutRoomRemoveBreakoutRoomsResponseApplicationJson
    implements
        BreakoutRoomRemoveBreakoutRoomsResponseApplicationJsonInterface,
        Built<BreakoutRoomRemoveBreakoutRoomsResponseApplicationJson,
            BreakoutRoomRemoveBreakoutRoomsResponseApplicationJsonBuilder> {
  factory BreakoutRoomRemoveBreakoutRoomsResponseApplicationJson([
    final void Function(BreakoutRoomRemoveBreakoutRoomsResponseApplicationJsonBuilder)? b,
  ]) = _$BreakoutRoomRemoveBreakoutRoomsResponseApplicationJson;

  // coverage:ignore-start
  const BreakoutRoomRemoveBreakoutRoomsResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BreakoutRoomRemoveBreakoutRoomsResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BreakoutRoomRemoveBreakoutRoomsResponseApplicationJson> get serializer =>
      _$breakoutRoomRemoveBreakoutRoomsResponseApplicationJsonSerializer;
}

class BreakoutRoomBroadcastChatMessageApiVersion extends EnumClass {
  const BreakoutRoomBroadcastChatMessageApiVersion._(super.name);

  static const BreakoutRoomBroadcastChatMessageApiVersion v1 = _$breakoutRoomBroadcastChatMessageApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<BreakoutRoomBroadcastChatMessageApiVersion> get values =>
      _$breakoutRoomBroadcastChatMessageApiVersionValues;
  // coverage:ignore-end
  static BreakoutRoomBroadcastChatMessageApiVersion valueOf(final String name) =>
      _$valueOfBreakoutRoomBroadcastChatMessageApiVersion(name);
  static Serializer<BreakoutRoomBroadcastChatMessageApiVersion> get serializer =>
      _$breakoutRoomBroadcastChatMessageApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BreakoutRoomBroadcastChatMessageResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  BuiltList<Room> get data;
}

abstract class BreakoutRoomBroadcastChatMessageResponseApplicationJson_Ocs
    implements
        BreakoutRoomBroadcastChatMessageResponseApplicationJson_OcsInterface,
        Built<BreakoutRoomBroadcastChatMessageResponseApplicationJson_Ocs,
            BreakoutRoomBroadcastChatMessageResponseApplicationJson_OcsBuilder> {
  factory BreakoutRoomBroadcastChatMessageResponseApplicationJson_Ocs([
    final void Function(BreakoutRoomBroadcastChatMessageResponseApplicationJson_OcsBuilder)? b,
  ]) = _$BreakoutRoomBroadcastChatMessageResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const BreakoutRoomBroadcastChatMessageResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BreakoutRoomBroadcastChatMessageResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BreakoutRoomBroadcastChatMessageResponseApplicationJson_Ocs> get serializer =>
      _$breakoutRoomBroadcastChatMessageResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BreakoutRoomBroadcastChatMessageResponseApplicationJsonInterface {
  BreakoutRoomBroadcastChatMessageResponseApplicationJson_Ocs get ocs;
}

abstract class BreakoutRoomBroadcastChatMessageResponseApplicationJson
    implements
        BreakoutRoomBroadcastChatMessageResponseApplicationJsonInterface,
        Built<BreakoutRoomBroadcastChatMessageResponseApplicationJson,
            BreakoutRoomBroadcastChatMessageResponseApplicationJsonBuilder> {
  factory BreakoutRoomBroadcastChatMessageResponseApplicationJson([
    final void Function(BreakoutRoomBroadcastChatMessageResponseApplicationJsonBuilder)? b,
  ]) = _$BreakoutRoomBroadcastChatMessageResponseApplicationJson;

  // coverage:ignore-start
  const BreakoutRoomBroadcastChatMessageResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BreakoutRoomBroadcastChatMessageResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BreakoutRoomBroadcastChatMessageResponseApplicationJson> get serializer =>
      _$breakoutRoomBroadcastChatMessageResponseApplicationJsonSerializer;
}

class BreakoutRoomApplyAttendeeMapApiVersion extends EnumClass {
  const BreakoutRoomApplyAttendeeMapApiVersion._(super.name);

  static const BreakoutRoomApplyAttendeeMapApiVersion v1 = _$breakoutRoomApplyAttendeeMapApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<BreakoutRoomApplyAttendeeMapApiVersion> get values => _$breakoutRoomApplyAttendeeMapApiVersionValues;
  // coverage:ignore-end
  static BreakoutRoomApplyAttendeeMapApiVersion valueOf(final String name) =>
      _$valueOfBreakoutRoomApplyAttendeeMapApiVersion(name);
  static Serializer<BreakoutRoomApplyAttendeeMapApiVersion> get serializer =>
      _$breakoutRoomApplyAttendeeMapApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BreakoutRoomApplyAttendeeMapResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  BuiltList<Room> get data;
}

abstract class BreakoutRoomApplyAttendeeMapResponseApplicationJson_Ocs
    implements
        BreakoutRoomApplyAttendeeMapResponseApplicationJson_OcsInterface,
        Built<BreakoutRoomApplyAttendeeMapResponseApplicationJson_Ocs,
            BreakoutRoomApplyAttendeeMapResponseApplicationJson_OcsBuilder> {
  factory BreakoutRoomApplyAttendeeMapResponseApplicationJson_Ocs([
    final void Function(BreakoutRoomApplyAttendeeMapResponseApplicationJson_OcsBuilder)? b,
  ]) = _$BreakoutRoomApplyAttendeeMapResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const BreakoutRoomApplyAttendeeMapResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BreakoutRoomApplyAttendeeMapResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BreakoutRoomApplyAttendeeMapResponseApplicationJson_Ocs> get serializer =>
      _$breakoutRoomApplyAttendeeMapResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BreakoutRoomApplyAttendeeMapResponseApplicationJsonInterface {
  BreakoutRoomApplyAttendeeMapResponseApplicationJson_Ocs get ocs;
}

abstract class BreakoutRoomApplyAttendeeMapResponseApplicationJson
    implements
        BreakoutRoomApplyAttendeeMapResponseApplicationJsonInterface,
        Built<BreakoutRoomApplyAttendeeMapResponseApplicationJson,
            BreakoutRoomApplyAttendeeMapResponseApplicationJsonBuilder> {
  factory BreakoutRoomApplyAttendeeMapResponseApplicationJson([
    final void Function(BreakoutRoomApplyAttendeeMapResponseApplicationJsonBuilder)? b,
  ]) = _$BreakoutRoomApplyAttendeeMapResponseApplicationJson;

  // coverage:ignore-start
  const BreakoutRoomApplyAttendeeMapResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BreakoutRoomApplyAttendeeMapResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BreakoutRoomApplyAttendeeMapResponseApplicationJson> get serializer =>
      _$breakoutRoomApplyAttendeeMapResponseApplicationJsonSerializer;
}

class BreakoutRoomRequestAssistanceApiVersion extends EnumClass {
  const BreakoutRoomRequestAssistanceApiVersion._(super.name);

  static const BreakoutRoomRequestAssistanceApiVersion v1 = _$breakoutRoomRequestAssistanceApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<BreakoutRoomRequestAssistanceApiVersion> get values =>
      _$breakoutRoomRequestAssistanceApiVersionValues;
  // coverage:ignore-end
  static BreakoutRoomRequestAssistanceApiVersion valueOf(final String name) =>
      _$valueOfBreakoutRoomRequestAssistanceApiVersion(name);
  static Serializer<BreakoutRoomRequestAssistanceApiVersion> get serializer =>
      _$breakoutRoomRequestAssistanceApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BreakoutRoomRequestAssistanceResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  Room get data;
}

abstract class BreakoutRoomRequestAssistanceResponseApplicationJson_Ocs
    implements
        BreakoutRoomRequestAssistanceResponseApplicationJson_OcsInterface,
        Built<BreakoutRoomRequestAssistanceResponseApplicationJson_Ocs,
            BreakoutRoomRequestAssistanceResponseApplicationJson_OcsBuilder> {
  factory BreakoutRoomRequestAssistanceResponseApplicationJson_Ocs([
    final void Function(BreakoutRoomRequestAssistanceResponseApplicationJson_OcsBuilder)? b,
  ]) = _$BreakoutRoomRequestAssistanceResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const BreakoutRoomRequestAssistanceResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BreakoutRoomRequestAssistanceResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BreakoutRoomRequestAssistanceResponseApplicationJson_Ocs> get serializer =>
      _$breakoutRoomRequestAssistanceResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BreakoutRoomRequestAssistanceResponseApplicationJsonInterface {
  BreakoutRoomRequestAssistanceResponseApplicationJson_Ocs get ocs;
}

abstract class BreakoutRoomRequestAssistanceResponseApplicationJson
    implements
        BreakoutRoomRequestAssistanceResponseApplicationJsonInterface,
        Built<BreakoutRoomRequestAssistanceResponseApplicationJson,
            BreakoutRoomRequestAssistanceResponseApplicationJsonBuilder> {
  factory BreakoutRoomRequestAssistanceResponseApplicationJson([
    final void Function(BreakoutRoomRequestAssistanceResponseApplicationJsonBuilder)? b,
  ]) = _$BreakoutRoomRequestAssistanceResponseApplicationJson;

  // coverage:ignore-start
  const BreakoutRoomRequestAssistanceResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BreakoutRoomRequestAssistanceResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BreakoutRoomRequestAssistanceResponseApplicationJson> get serializer =>
      _$breakoutRoomRequestAssistanceResponseApplicationJsonSerializer;
}

class BreakoutRoomResetRequestForAssistanceApiVersion extends EnumClass {
  const BreakoutRoomResetRequestForAssistanceApiVersion._(super.name);

  static const BreakoutRoomResetRequestForAssistanceApiVersion v1 = _$breakoutRoomResetRequestForAssistanceApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<BreakoutRoomResetRequestForAssistanceApiVersion> get values =>
      _$breakoutRoomResetRequestForAssistanceApiVersionValues;
  // coverage:ignore-end
  static BreakoutRoomResetRequestForAssistanceApiVersion valueOf(final String name) =>
      _$valueOfBreakoutRoomResetRequestForAssistanceApiVersion(name);
  static Serializer<BreakoutRoomResetRequestForAssistanceApiVersion> get serializer =>
      _$breakoutRoomResetRequestForAssistanceApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BreakoutRoomResetRequestForAssistanceResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  Room get data;
}

abstract class BreakoutRoomResetRequestForAssistanceResponseApplicationJson_Ocs
    implements
        BreakoutRoomResetRequestForAssistanceResponseApplicationJson_OcsInterface,
        Built<BreakoutRoomResetRequestForAssistanceResponseApplicationJson_Ocs,
            BreakoutRoomResetRequestForAssistanceResponseApplicationJson_OcsBuilder> {
  factory BreakoutRoomResetRequestForAssistanceResponseApplicationJson_Ocs([
    final void Function(BreakoutRoomResetRequestForAssistanceResponseApplicationJson_OcsBuilder)? b,
  ]) = _$BreakoutRoomResetRequestForAssistanceResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const BreakoutRoomResetRequestForAssistanceResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BreakoutRoomResetRequestForAssistanceResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BreakoutRoomResetRequestForAssistanceResponseApplicationJson_Ocs> get serializer =>
      _$breakoutRoomResetRequestForAssistanceResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BreakoutRoomResetRequestForAssistanceResponseApplicationJsonInterface {
  BreakoutRoomResetRequestForAssistanceResponseApplicationJson_Ocs get ocs;
}

abstract class BreakoutRoomResetRequestForAssistanceResponseApplicationJson
    implements
        BreakoutRoomResetRequestForAssistanceResponseApplicationJsonInterface,
        Built<BreakoutRoomResetRequestForAssistanceResponseApplicationJson,
            BreakoutRoomResetRequestForAssistanceResponseApplicationJsonBuilder> {
  factory BreakoutRoomResetRequestForAssistanceResponseApplicationJson([
    final void Function(BreakoutRoomResetRequestForAssistanceResponseApplicationJsonBuilder)? b,
  ]) = _$BreakoutRoomResetRequestForAssistanceResponseApplicationJson;

  // coverage:ignore-start
  const BreakoutRoomResetRequestForAssistanceResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BreakoutRoomResetRequestForAssistanceResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BreakoutRoomResetRequestForAssistanceResponseApplicationJson> get serializer =>
      _$breakoutRoomResetRequestForAssistanceResponseApplicationJsonSerializer;
}

class BreakoutRoomStartBreakoutRoomsApiVersion extends EnumClass {
  const BreakoutRoomStartBreakoutRoomsApiVersion._(super.name);

  static const BreakoutRoomStartBreakoutRoomsApiVersion v1 = _$breakoutRoomStartBreakoutRoomsApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<BreakoutRoomStartBreakoutRoomsApiVersion> get values =>
      _$breakoutRoomStartBreakoutRoomsApiVersionValues;
  // coverage:ignore-end
  static BreakoutRoomStartBreakoutRoomsApiVersion valueOf(final String name) =>
      _$valueOfBreakoutRoomStartBreakoutRoomsApiVersion(name);
  static Serializer<BreakoutRoomStartBreakoutRoomsApiVersion> get serializer =>
      _$breakoutRoomStartBreakoutRoomsApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BreakoutRoomStartBreakoutRoomsResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  BuiltList<Room> get data;
}

abstract class BreakoutRoomStartBreakoutRoomsResponseApplicationJson_Ocs
    implements
        BreakoutRoomStartBreakoutRoomsResponseApplicationJson_OcsInterface,
        Built<BreakoutRoomStartBreakoutRoomsResponseApplicationJson_Ocs,
            BreakoutRoomStartBreakoutRoomsResponseApplicationJson_OcsBuilder> {
  factory BreakoutRoomStartBreakoutRoomsResponseApplicationJson_Ocs([
    final void Function(BreakoutRoomStartBreakoutRoomsResponseApplicationJson_OcsBuilder)? b,
  ]) = _$BreakoutRoomStartBreakoutRoomsResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const BreakoutRoomStartBreakoutRoomsResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BreakoutRoomStartBreakoutRoomsResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BreakoutRoomStartBreakoutRoomsResponseApplicationJson_Ocs> get serializer =>
      _$breakoutRoomStartBreakoutRoomsResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BreakoutRoomStartBreakoutRoomsResponseApplicationJsonInterface {
  BreakoutRoomStartBreakoutRoomsResponseApplicationJson_Ocs get ocs;
}

abstract class BreakoutRoomStartBreakoutRoomsResponseApplicationJson
    implements
        BreakoutRoomStartBreakoutRoomsResponseApplicationJsonInterface,
        Built<BreakoutRoomStartBreakoutRoomsResponseApplicationJson,
            BreakoutRoomStartBreakoutRoomsResponseApplicationJsonBuilder> {
  factory BreakoutRoomStartBreakoutRoomsResponseApplicationJson([
    final void Function(BreakoutRoomStartBreakoutRoomsResponseApplicationJsonBuilder)? b,
  ]) = _$BreakoutRoomStartBreakoutRoomsResponseApplicationJson;

  // coverage:ignore-start
  const BreakoutRoomStartBreakoutRoomsResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BreakoutRoomStartBreakoutRoomsResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BreakoutRoomStartBreakoutRoomsResponseApplicationJson> get serializer =>
      _$breakoutRoomStartBreakoutRoomsResponseApplicationJsonSerializer;
}

class BreakoutRoomStopBreakoutRoomsApiVersion extends EnumClass {
  const BreakoutRoomStopBreakoutRoomsApiVersion._(super.name);

  static const BreakoutRoomStopBreakoutRoomsApiVersion v1 = _$breakoutRoomStopBreakoutRoomsApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<BreakoutRoomStopBreakoutRoomsApiVersion> get values =>
      _$breakoutRoomStopBreakoutRoomsApiVersionValues;
  // coverage:ignore-end
  static BreakoutRoomStopBreakoutRoomsApiVersion valueOf(final String name) =>
      _$valueOfBreakoutRoomStopBreakoutRoomsApiVersion(name);
  static Serializer<BreakoutRoomStopBreakoutRoomsApiVersion> get serializer =>
      _$breakoutRoomStopBreakoutRoomsApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BreakoutRoomStopBreakoutRoomsResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  BuiltList<Room> get data;
}

abstract class BreakoutRoomStopBreakoutRoomsResponseApplicationJson_Ocs
    implements
        BreakoutRoomStopBreakoutRoomsResponseApplicationJson_OcsInterface,
        Built<BreakoutRoomStopBreakoutRoomsResponseApplicationJson_Ocs,
            BreakoutRoomStopBreakoutRoomsResponseApplicationJson_OcsBuilder> {
  factory BreakoutRoomStopBreakoutRoomsResponseApplicationJson_Ocs([
    final void Function(BreakoutRoomStopBreakoutRoomsResponseApplicationJson_OcsBuilder)? b,
  ]) = _$BreakoutRoomStopBreakoutRoomsResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const BreakoutRoomStopBreakoutRoomsResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BreakoutRoomStopBreakoutRoomsResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BreakoutRoomStopBreakoutRoomsResponseApplicationJson_Ocs> get serializer =>
      _$breakoutRoomStopBreakoutRoomsResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BreakoutRoomStopBreakoutRoomsResponseApplicationJsonInterface {
  BreakoutRoomStopBreakoutRoomsResponseApplicationJson_Ocs get ocs;
}

abstract class BreakoutRoomStopBreakoutRoomsResponseApplicationJson
    implements
        BreakoutRoomStopBreakoutRoomsResponseApplicationJsonInterface,
        Built<BreakoutRoomStopBreakoutRoomsResponseApplicationJson,
            BreakoutRoomStopBreakoutRoomsResponseApplicationJsonBuilder> {
  factory BreakoutRoomStopBreakoutRoomsResponseApplicationJson([
    final void Function(BreakoutRoomStopBreakoutRoomsResponseApplicationJsonBuilder)? b,
  ]) = _$BreakoutRoomStopBreakoutRoomsResponseApplicationJson;

  // coverage:ignore-start
  const BreakoutRoomStopBreakoutRoomsResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BreakoutRoomStopBreakoutRoomsResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BreakoutRoomStopBreakoutRoomsResponseApplicationJson> get serializer =>
      _$breakoutRoomStopBreakoutRoomsResponseApplicationJsonSerializer;
}

class BreakoutRoomSwitchBreakoutRoomApiVersion extends EnumClass {
  const BreakoutRoomSwitchBreakoutRoomApiVersion._(super.name);

  static const BreakoutRoomSwitchBreakoutRoomApiVersion v1 = _$breakoutRoomSwitchBreakoutRoomApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<BreakoutRoomSwitchBreakoutRoomApiVersion> get values =>
      _$breakoutRoomSwitchBreakoutRoomApiVersionValues;
  // coverage:ignore-end
  static BreakoutRoomSwitchBreakoutRoomApiVersion valueOf(final String name) =>
      _$valueOfBreakoutRoomSwitchBreakoutRoomApiVersion(name);
  static Serializer<BreakoutRoomSwitchBreakoutRoomApiVersion> get serializer =>
      _$breakoutRoomSwitchBreakoutRoomApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BreakoutRoomSwitchBreakoutRoomResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  Room get data;
}

abstract class BreakoutRoomSwitchBreakoutRoomResponseApplicationJson_Ocs
    implements
        BreakoutRoomSwitchBreakoutRoomResponseApplicationJson_OcsInterface,
        Built<BreakoutRoomSwitchBreakoutRoomResponseApplicationJson_Ocs,
            BreakoutRoomSwitchBreakoutRoomResponseApplicationJson_OcsBuilder> {
  factory BreakoutRoomSwitchBreakoutRoomResponseApplicationJson_Ocs([
    final void Function(BreakoutRoomSwitchBreakoutRoomResponseApplicationJson_OcsBuilder)? b,
  ]) = _$BreakoutRoomSwitchBreakoutRoomResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const BreakoutRoomSwitchBreakoutRoomResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BreakoutRoomSwitchBreakoutRoomResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BreakoutRoomSwitchBreakoutRoomResponseApplicationJson_Ocs> get serializer =>
      _$breakoutRoomSwitchBreakoutRoomResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BreakoutRoomSwitchBreakoutRoomResponseApplicationJsonInterface {
  BreakoutRoomSwitchBreakoutRoomResponseApplicationJson_Ocs get ocs;
}

abstract class BreakoutRoomSwitchBreakoutRoomResponseApplicationJson
    implements
        BreakoutRoomSwitchBreakoutRoomResponseApplicationJsonInterface,
        Built<BreakoutRoomSwitchBreakoutRoomResponseApplicationJson,
            BreakoutRoomSwitchBreakoutRoomResponseApplicationJsonBuilder> {
  factory BreakoutRoomSwitchBreakoutRoomResponseApplicationJson([
    final void Function(BreakoutRoomSwitchBreakoutRoomResponseApplicationJsonBuilder)? b,
  ]) = _$BreakoutRoomSwitchBreakoutRoomResponseApplicationJson;

  // coverage:ignore-start
  const BreakoutRoomSwitchBreakoutRoomResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BreakoutRoomSwitchBreakoutRoomResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BreakoutRoomSwitchBreakoutRoomResponseApplicationJson> get serializer =>
      _$breakoutRoomSwitchBreakoutRoomResponseApplicationJsonSerializer;
}

class CallGetPeersForCallApiVersion extends EnumClass {
  const CallGetPeersForCallApiVersion._(super.name);

  static const CallGetPeersForCallApiVersion v4 = _$callGetPeersForCallApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<CallGetPeersForCallApiVersion> get values => _$callGetPeersForCallApiVersionValues;
  // coverage:ignore-end
  static CallGetPeersForCallApiVersion valueOf(final String name) => _$valueOfCallGetPeersForCallApiVersion(name);
  static Serializer<CallGetPeersForCallApiVersion> get serializer => _$callGetPeersForCallApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class CallPeerInterface {
  String get actorId;
  String get actorType;
  String get displayName;
  int get lastPing;
  String get sessionId;
  String get token;
}

abstract class CallPeer implements CallPeerInterface, Built<CallPeer, CallPeerBuilder> {
  factory CallPeer([final void Function(CallPeerBuilder)? b]) = _$CallPeer;

  // coverage:ignore-start
  const CallPeer._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory CallPeer.fromJson(final Map<String, dynamic> json) => _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<CallPeer> get serializer => _$callPeerSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class CallGetPeersForCallResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  BuiltList<CallPeer> get data;
}

abstract class CallGetPeersForCallResponseApplicationJson_Ocs
    implements
        CallGetPeersForCallResponseApplicationJson_OcsInterface,
        Built<CallGetPeersForCallResponseApplicationJson_Ocs, CallGetPeersForCallResponseApplicationJson_OcsBuilder> {
  factory CallGetPeersForCallResponseApplicationJson_Ocs([
    final void Function(CallGetPeersForCallResponseApplicationJson_OcsBuilder)? b,
  ]) = _$CallGetPeersForCallResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const CallGetPeersForCallResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory CallGetPeersForCallResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<CallGetPeersForCallResponseApplicationJson_Ocs> get serializer =>
      _$callGetPeersForCallResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class CallGetPeersForCallResponseApplicationJsonInterface {
  CallGetPeersForCallResponseApplicationJson_Ocs get ocs;
}

abstract class CallGetPeersForCallResponseApplicationJson
    implements
        CallGetPeersForCallResponseApplicationJsonInterface,
        Built<CallGetPeersForCallResponseApplicationJson, CallGetPeersForCallResponseApplicationJsonBuilder> {
  factory CallGetPeersForCallResponseApplicationJson([
    final void Function(CallGetPeersForCallResponseApplicationJsonBuilder)? b,
  ]) = _$CallGetPeersForCallResponseApplicationJson;

  // coverage:ignore-start
  const CallGetPeersForCallResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory CallGetPeersForCallResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<CallGetPeersForCallResponseApplicationJson> get serializer =>
      _$callGetPeersForCallResponseApplicationJsonSerializer;
}

class CallUpdateCallFlagsApiVersion extends EnumClass {
  const CallUpdateCallFlagsApiVersion._(super.name);

  static const CallUpdateCallFlagsApiVersion v4 = _$callUpdateCallFlagsApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<CallUpdateCallFlagsApiVersion> get values => _$callUpdateCallFlagsApiVersionValues;
  // coverage:ignore-end
  static CallUpdateCallFlagsApiVersion valueOf(final String name) => _$valueOfCallUpdateCallFlagsApiVersion(name);
  static Serializer<CallUpdateCallFlagsApiVersion> get serializer => _$callUpdateCallFlagsApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class CallUpdateCallFlagsResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class CallUpdateCallFlagsResponseApplicationJson_Ocs
    implements
        CallUpdateCallFlagsResponseApplicationJson_OcsInterface,
        Built<CallUpdateCallFlagsResponseApplicationJson_Ocs, CallUpdateCallFlagsResponseApplicationJson_OcsBuilder> {
  factory CallUpdateCallFlagsResponseApplicationJson_Ocs([
    final void Function(CallUpdateCallFlagsResponseApplicationJson_OcsBuilder)? b,
  ]) = _$CallUpdateCallFlagsResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const CallUpdateCallFlagsResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory CallUpdateCallFlagsResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<CallUpdateCallFlagsResponseApplicationJson_Ocs> get serializer =>
      _$callUpdateCallFlagsResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class CallUpdateCallFlagsResponseApplicationJsonInterface {
  CallUpdateCallFlagsResponseApplicationJson_Ocs get ocs;
}

abstract class CallUpdateCallFlagsResponseApplicationJson
    implements
        CallUpdateCallFlagsResponseApplicationJsonInterface,
        Built<CallUpdateCallFlagsResponseApplicationJson, CallUpdateCallFlagsResponseApplicationJsonBuilder> {
  factory CallUpdateCallFlagsResponseApplicationJson([
    final void Function(CallUpdateCallFlagsResponseApplicationJsonBuilder)? b,
  ]) = _$CallUpdateCallFlagsResponseApplicationJson;

  // coverage:ignore-start
  const CallUpdateCallFlagsResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory CallUpdateCallFlagsResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<CallUpdateCallFlagsResponseApplicationJson> get serializer =>
      _$callUpdateCallFlagsResponseApplicationJsonSerializer;
}

class CallJoinCallApiVersion extends EnumClass {
  const CallJoinCallApiVersion._(super.name);

  static const CallJoinCallApiVersion v4 = _$callJoinCallApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<CallJoinCallApiVersion> get values => _$callJoinCallApiVersionValues;
  // coverage:ignore-end
  static CallJoinCallApiVersion valueOf(final String name) => _$valueOfCallJoinCallApiVersion(name);
  static Serializer<CallJoinCallApiVersion> get serializer => _$callJoinCallApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class CallJoinCallResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class CallJoinCallResponseApplicationJson_Ocs
    implements
        CallJoinCallResponseApplicationJson_OcsInterface,
        Built<CallJoinCallResponseApplicationJson_Ocs, CallJoinCallResponseApplicationJson_OcsBuilder> {
  factory CallJoinCallResponseApplicationJson_Ocs([
    final void Function(CallJoinCallResponseApplicationJson_OcsBuilder)? b,
  ]) = _$CallJoinCallResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const CallJoinCallResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory CallJoinCallResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<CallJoinCallResponseApplicationJson_Ocs> get serializer =>
      _$callJoinCallResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class CallJoinCallResponseApplicationJsonInterface {
  CallJoinCallResponseApplicationJson_Ocs get ocs;
}

abstract class CallJoinCallResponseApplicationJson
    implements
        CallJoinCallResponseApplicationJsonInterface,
        Built<CallJoinCallResponseApplicationJson, CallJoinCallResponseApplicationJsonBuilder> {
  factory CallJoinCallResponseApplicationJson([final void Function(CallJoinCallResponseApplicationJsonBuilder)? b]) =
      _$CallJoinCallResponseApplicationJson;

  // coverage:ignore-start
  const CallJoinCallResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory CallJoinCallResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<CallJoinCallResponseApplicationJson> get serializer =>
      _$callJoinCallResponseApplicationJsonSerializer;
}

class CallLeaveCallApiVersion extends EnumClass {
  const CallLeaveCallApiVersion._(super.name);

  static const CallLeaveCallApiVersion v4 = _$callLeaveCallApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<CallLeaveCallApiVersion> get values => _$callLeaveCallApiVersionValues;
  // coverage:ignore-end
  static CallLeaveCallApiVersion valueOf(final String name) => _$valueOfCallLeaveCallApiVersion(name);
  static Serializer<CallLeaveCallApiVersion> get serializer => _$callLeaveCallApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class CallLeaveCallResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class CallLeaveCallResponseApplicationJson_Ocs
    implements
        CallLeaveCallResponseApplicationJson_OcsInterface,
        Built<CallLeaveCallResponseApplicationJson_Ocs, CallLeaveCallResponseApplicationJson_OcsBuilder> {
  factory CallLeaveCallResponseApplicationJson_Ocs([
    final void Function(CallLeaveCallResponseApplicationJson_OcsBuilder)? b,
  ]) = _$CallLeaveCallResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const CallLeaveCallResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory CallLeaveCallResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<CallLeaveCallResponseApplicationJson_Ocs> get serializer =>
      _$callLeaveCallResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class CallLeaveCallResponseApplicationJsonInterface {
  CallLeaveCallResponseApplicationJson_Ocs get ocs;
}

abstract class CallLeaveCallResponseApplicationJson
    implements
        CallLeaveCallResponseApplicationJsonInterface,
        Built<CallLeaveCallResponseApplicationJson, CallLeaveCallResponseApplicationJsonBuilder> {
  factory CallLeaveCallResponseApplicationJson([final void Function(CallLeaveCallResponseApplicationJsonBuilder)? b]) =
      _$CallLeaveCallResponseApplicationJson;

  // coverage:ignore-start
  const CallLeaveCallResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory CallLeaveCallResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<CallLeaveCallResponseApplicationJson> get serializer =>
      _$callLeaveCallResponseApplicationJsonSerializer;
}

class CallRingAttendeeApiVersion extends EnumClass {
  const CallRingAttendeeApiVersion._(super.name);

  static const CallRingAttendeeApiVersion v4 = _$callRingAttendeeApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<CallRingAttendeeApiVersion> get values => _$callRingAttendeeApiVersionValues;
  // coverage:ignore-end
  static CallRingAttendeeApiVersion valueOf(final String name) => _$valueOfCallRingAttendeeApiVersion(name);
  static Serializer<CallRingAttendeeApiVersion> get serializer => _$callRingAttendeeApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class CallRingAttendeeResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class CallRingAttendeeResponseApplicationJson_Ocs
    implements
        CallRingAttendeeResponseApplicationJson_OcsInterface,
        Built<CallRingAttendeeResponseApplicationJson_Ocs, CallRingAttendeeResponseApplicationJson_OcsBuilder> {
  factory CallRingAttendeeResponseApplicationJson_Ocs([
    final void Function(CallRingAttendeeResponseApplicationJson_OcsBuilder)? b,
  ]) = _$CallRingAttendeeResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const CallRingAttendeeResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory CallRingAttendeeResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<CallRingAttendeeResponseApplicationJson_Ocs> get serializer =>
      _$callRingAttendeeResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class CallRingAttendeeResponseApplicationJsonInterface {
  CallRingAttendeeResponseApplicationJson_Ocs get ocs;
}

abstract class CallRingAttendeeResponseApplicationJson
    implements
        CallRingAttendeeResponseApplicationJsonInterface,
        Built<CallRingAttendeeResponseApplicationJson, CallRingAttendeeResponseApplicationJsonBuilder> {
  factory CallRingAttendeeResponseApplicationJson([
    final void Function(CallRingAttendeeResponseApplicationJsonBuilder)? b,
  ]) = _$CallRingAttendeeResponseApplicationJson;

  // coverage:ignore-start
  const CallRingAttendeeResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory CallRingAttendeeResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<CallRingAttendeeResponseApplicationJson> get serializer =>
      _$callRingAttendeeResponseApplicationJsonSerializer;
}

class CallSipDialOutApiVersion extends EnumClass {
  const CallSipDialOutApiVersion._(super.name);

  static const CallSipDialOutApiVersion v4 = _$callSipDialOutApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<CallSipDialOutApiVersion> get values => _$callSipDialOutApiVersionValues;
  // coverage:ignore-end
  static CallSipDialOutApiVersion valueOf(final String name) => _$valueOfCallSipDialOutApiVersion(name);
  static Serializer<CallSipDialOutApiVersion> get serializer => _$callSipDialOutApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class CallSipDialOutResponseApplicationJson_Ocs_DataInterface {
  String? get error;
  String? get message;
}

abstract class CallSipDialOutResponseApplicationJson_Ocs_Data
    implements
        CallSipDialOutResponseApplicationJson_Ocs_DataInterface,
        Built<CallSipDialOutResponseApplicationJson_Ocs_Data, CallSipDialOutResponseApplicationJson_Ocs_DataBuilder> {
  factory CallSipDialOutResponseApplicationJson_Ocs_Data([
    final void Function(CallSipDialOutResponseApplicationJson_Ocs_DataBuilder)? b,
  ]) = _$CallSipDialOutResponseApplicationJson_Ocs_Data;

  // coverage:ignore-start
  const CallSipDialOutResponseApplicationJson_Ocs_Data._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory CallSipDialOutResponseApplicationJson_Ocs_Data.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<CallSipDialOutResponseApplicationJson_Ocs_Data> get serializer =>
      _$callSipDialOutResponseApplicationJsonOcsDataSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class CallSipDialOutResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  CallSipDialOutResponseApplicationJson_Ocs_Data get data;
}

abstract class CallSipDialOutResponseApplicationJson_Ocs
    implements
        CallSipDialOutResponseApplicationJson_OcsInterface,
        Built<CallSipDialOutResponseApplicationJson_Ocs, CallSipDialOutResponseApplicationJson_OcsBuilder> {
  factory CallSipDialOutResponseApplicationJson_Ocs([
    final void Function(CallSipDialOutResponseApplicationJson_OcsBuilder)? b,
  ]) = _$CallSipDialOutResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const CallSipDialOutResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory CallSipDialOutResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<CallSipDialOutResponseApplicationJson_Ocs> get serializer =>
      _$callSipDialOutResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class CallSipDialOutResponseApplicationJsonInterface {
  CallSipDialOutResponseApplicationJson_Ocs get ocs;
}

abstract class CallSipDialOutResponseApplicationJson
    implements
        CallSipDialOutResponseApplicationJsonInterface,
        Built<CallSipDialOutResponseApplicationJson, CallSipDialOutResponseApplicationJsonBuilder> {
  factory CallSipDialOutResponseApplicationJson([
    final void Function(CallSipDialOutResponseApplicationJsonBuilder)? b,
  ]) = _$CallSipDialOutResponseApplicationJson;

  // coverage:ignore-start
  const CallSipDialOutResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory CallSipDialOutResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<CallSipDialOutResponseApplicationJson> get serializer =>
      _$callSipDialOutResponseApplicationJsonSerializer;
}

class CertificateGetCertificateExpirationApiVersion extends EnumClass {
  const CertificateGetCertificateExpirationApiVersion._(super.name);

  static const CertificateGetCertificateExpirationApiVersion v1 = _$certificateGetCertificateExpirationApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<CertificateGetCertificateExpirationApiVersion> get values =>
      _$certificateGetCertificateExpirationApiVersionValues;
  // coverage:ignore-end
  static CertificateGetCertificateExpirationApiVersion valueOf(final String name) =>
      _$valueOfCertificateGetCertificateExpirationApiVersion(name);
  static Serializer<CertificateGetCertificateExpirationApiVersion> get serializer =>
      _$certificateGetCertificateExpirationApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class CertificateGetCertificateExpirationResponseApplicationJson_Ocs_DataInterface {
  @BuiltValueField(wireName: 'expiration_in_days')
  int? get expirationInDays;
}

abstract class CertificateGetCertificateExpirationResponseApplicationJson_Ocs_Data
    implements
        CertificateGetCertificateExpirationResponseApplicationJson_Ocs_DataInterface,
        Built<CertificateGetCertificateExpirationResponseApplicationJson_Ocs_Data,
            CertificateGetCertificateExpirationResponseApplicationJson_Ocs_DataBuilder> {
  factory CertificateGetCertificateExpirationResponseApplicationJson_Ocs_Data([
    final void Function(CertificateGetCertificateExpirationResponseApplicationJson_Ocs_DataBuilder)? b,
  ]) = _$CertificateGetCertificateExpirationResponseApplicationJson_Ocs_Data;

  // coverage:ignore-start
  const CertificateGetCertificateExpirationResponseApplicationJson_Ocs_Data._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory CertificateGetCertificateExpirationResponseApplicationJson_Ocs_Data.fromJson(
    final Map<String, dynamic> json,
  ) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<CertificateGetCertificateExpirationResponseApplicationJson_Ocs_Data> get serializer =>
      _$certificateGetCertificateExpirationResponseApplicationJsonOcsDataSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class CertificateGetCertificateExpirationResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  CertificateGetCertificateExpirationResponseApplicationJson_Ocs_Data get data;
}

abstract class CertificateGetCertificateExpirationResponseApplicationJson_Ocs
    implements
        CertificateGetCertificateExpirationResponseApplicationJson_OcsInterface,
        Built<CertificateGetCertificateExpirationResponseApplicationJson_Ocs,
            CertificateGetCertificateExpirationResponseApplicationJson_OcsBuilder> {
  factory CertificateGetCertificateExpirationResponseApplicationJson_Ocs([
    final void Function(CertificateGetCertificateExpirationResponseApplicationJson_OcsBuilder)? b,
  ]) = _$CertificateGetCertificateExpirationResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const CertificateGetCertificateExpirationResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory CertificateGetCertificateExpirationResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<CertificateGetCertificateExpirationResponseApplicationJson_Ocs> get serializer =>
      _$certificateGetCertificateExpirationResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class CertificateGetCertificateExpirationResponseApplicationJsonInterface {
  CertificateGetCertificateExpirationResponseApplicationJson_Ocs get ocs;
}

abstract class CertificateGetCertificateExpirationResponseApplicationJson
    implements
        CertificateGetCertificateExpirationResponseApplicationJsonInterface,
        Built<CertificateGetCertificateExpirationResponseApplicationJson,
            CertificateGetCertificateExpirationResponseApplicationJsonBuilder> {
  factory CertificateGetCertificateExpirationResponseApplicationJson([
    final void Function(CertificateGetCertificateExpirationResponseApplicationJsonBuilder)? b,
  ]) = _$CertificateGetCertificateExpirationResponseApplicationJson;

  // coverage:ignore-start
  const CertificateGetCertificateExpirationResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory CertificateGetCertificateExpirationResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<CertificateGetCertificateExpirationResponseApplicationJson> get serializer =>
      _$certificateGetCertificateExpirationResponseApplicationJsonSerializer;
}

class ChatReceiveMessagesApiVersion extends EnumClass {
  const ChatReceiveMessagesApiVersion._(super.name);

  static const ChatReceiveMessagesApiVersion v1 = _$chatReceiveMessagesApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<ChatReceiveMessagesApiVersion> get values => _$chatReceiveMessagesApiVersionValues;
  // coverage:ignore-end
  static ChatReceiveMessagesApiVersion valueOf(final String name) => _$valueOfChatReceiveMessagesApiVersion(name);
  static Serializer<ChatReceiveMessagesApiVersion> get serializer => _$chatReceiveMessagesApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatChatReceiveMessagesHeadersInterface {
  @BuiltValueField(wireName: 'x-chat-last-common-read')
  String? get xChatLastCommonRead;
  @BuiltValueField(wireName: 'x-chat-last-given')
  String? get xChatLastGiven;
}

abstract class ChatChatReceiveMessagesHeaders
    implements
        ChatChatReceiveMessagesHeadersInterface,
        Built<ChatChatReceiveMessagesHeaders, ChatChatReceiveMessagesHeadersBuilder> {
  factory ChatChatReceiveMessagesHeaders([final void Function(ChatChatReceiveMessagesHeadersBuilder)? b]) =
      _$ChatChatReceiveMessagesHeaders;

  // coverage:ignore-start
  const ChatChatReceiveMessagesHeaders._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatChatReceiveMessagesHeaders.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  @BuiltValueSerializer(custom: true)
  static Serializer<ChatChatReceiveMessagesHeaders> get serializer => _$ChatChatReceiveMessagesHeadersSerializer();
}

class _$ChatChatReceiveMessagesHeadersSerializer implements StructuredSerializer<ChatChatReceiveMessagesHeaders> {
  @override
  final Iterable<Type> types = const [ChatChatReceiveMessagesHeaders, _$ChatChatReceiveMessagesHeaders];

  @override
  final String wireName = 'ChatChatReceiveMessagesHeaders';

  @override
  Iterable<Object?> serialize(
    final Serializers serializers,
    final ChatChatReceiveMessagesHeaders object, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    throw UnimplementedError();
  }

  @override
  ChatChatReceiveMessagesHeaders deserialize(
    final Serializers serializers,
    final Iterable<Object?> serialized, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatChatReceiveMessagesHeadersBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final value = iterator.current! as String;
      switch (key) {
        case 'x-chat-last-common-read':
          result.xChatLastCommonRead = value;
        case 'x-chat-last-given':
          result.xChatLastGiven = value;
      }
    }

    return result.build();
  }
}

@BuiltValue(instantiable: false)
abstract interface class ChatMessageWithParent_1Interface {
  ChatMessage? get parent;
}

@BuiltValue(instantiable: false)
abstract interface class ChatMessageWithParentInterface
    implements ChatMessageInterface, ChatMessageWithParent_1Interface {}

abstract class ChatMessageWithParent
    implements ChatMessageWithParentInterface, Built<ChatMessageWithParent, ChatMessageWithParentBuilder> {
  factory ChatMessageWithParent([final void Function(ChatMessageWithParentBuilder)? b]) = _$ChatMessageWithParent;

  // coverage:ignore-start
  const ChatMessageWithParent._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatMessageWithParent.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatMessageWithParent> get serializer => _$chatMessageWithParentSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatReceiveMessagesResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  BuiltList<ChatMessageWithParent> get data;
}

abstract class ChatReceiveMessagesResponseApplicationJson_Ocs
    implements
        ChatReceiveMessagesResponseApplicationJson_OcsInterface,
        Built<ChatReceiveMessagesResponseApplicationJson_Ocs, ChatReceiveMessagesResponseApplicationJson_OcsBuilder> {
  factory ChatReceiveMessagesResponseApplicationJson_Ocs([
    final void Function(ChatReceiveMessagesResponseApplicationJson_OcsBuilder)? b,
  ]) = _$ChatReceiveMessagesResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const ChatReceiveMessagesResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatReceiveMessagesResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatReceiveMessagesResponseApplicationJson_Ocs> get serializer =>
      _$chatReceiveMessagesResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatReceiveMessagesResponseApplicationJsonInterface {
  ChatReceiveMessagesResponseApplicationJson_Ocs get ocs;
}

abstract class ChatReceiveMessagesResponseApplicationJson
    implements
        ChatReceiveMessagesResponseApplicationJsonInterface,
        Built<ChatReceiveMessagesResponseApplicationJson, ChatReceiveMessagesResponseApplicationJsonBuilder> {
  factory ChatReceiveMessagesResponseApplicationJson([
    final void Function(ChatReceiveMessagesResponseApplicationJsonBuilder)? b,
  ]) = _$ChatReceiveMessagesResponseApplicationJson;

  // coverage:ignore-start
  const ChatReceiveMessagesResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatReceiveMessagesResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatReceiveMessagesResponseApplicationJson> get serializer =>
      _$chatReceiveMessagesResponseApplicationJsonSerializer;
}

class ChatSendMessageApiVersion extends EnumClass {
  const ChatSendMessageApiVersion._(super.name);

  static const ChatSendMessageApiVersion v1 = _$chatSendMessageApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<ChatSendMessageApiVersion> get values => _$chatSendMessageApiVersionValues;
  // coverage:ignore-end
  static ChatSendMessageApiVersion valueOf(final String name) => _$valueOfChatSendMessageApiVersion(name);
  static Serializer<ChatSendMessageApiVersion> get serializer => _$chatSendMessageApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatChatSendMessageHeadersInterface {
  @BuiltValueField(wireName: 'x-chat-last-common-read')
  String? get xChatLastCommonRead;
}

abstract class ChatChatSendMessageHeaders
    implements
        ChatChatSendMessageHeadersInterface,
        Built<ChatChatSendMessageHeaders, ChatChatSendMessageHeadersBuilder> {
  factory ChatChatSendMessageHeaders([final void Function(ChatChatSendMessageHeadersBuilder)? b]) =
      _$ChatChatSendMessageHeaders;

  // coverage:ignore-start
  const ChatChatSendMessageHeaders._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatChatSendMessageHeaders.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  @BuiltValueSerializer(custom: true)
  static Serializer<ChatChatSendMessageHeaders> get serializer => _$ChatChatSendMessageHeadersSerializer();
}

class _$ChatChatSendMessageHeadersSerializer implements StructuredSerializer<ChatChatSendMessageHeaders> {
  @override
  final Iterable<Type> types = const [ChatChatSendMessageHeaders, _$ChatChatSendMessageHeaders];

  @override
  final String wireName = 'ChatChatSendMessageHeaders';

  @override
  Iterable<Object?> serialize(
    final Serializers serializers,
    final ChatChatSendMessageHeaders object, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    throw UnimplementedError();
  }

  @override
  ChatChatSendMessageHeaders deserialize(
    final Serializers serializers,
    final Iterable<Object?> serialized, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatChatSendMessageHeadersBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final value = iterator.current! as String;
      switch (key) {
        case 'x-chat-last-common-read':
          result.xChatLastCommonRead = value;
      }
    }

    return result.build();
  }
}

@BuiltValue(instantiable: false)
abstract interface class ChatSendMessageResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  ChatMessageWithParent? get data;
}

abstract class ChatSendMessageResponseApplicationJson_Ocs
    implements
        ChatSendMessageResponseApplicationJson_OcsInterface,
        Built<ChatSendMessageResponseApplicationJson_Ocs, ChatSendMessageResponseApplicationJson_OcsBuilder> {
  factory ChatSendMessageResponseApplicationJson_Ocs([
    final void Function(ChatSendMessageResponseApplicationJson_OcsBuilder)? b,
  ]) = _$ChatSendMessageResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const ChatSendMessageResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatSendMessageResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatSendMessageResponseApplicationJson_Ocs> get serializer =>
      _$chatSendMessageResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatSendMessageResponseApplicationJsonInterface {
  ChatSendMessageResponseApplicationJson_Ocs get ocs;
}

abstract class ChatSendMessageResponseApplicationJson
    implements
        ChatSendMessageResponseApplicationJsonInterface,
        Built<ChatSendMessageResponseApplicationJson, ChatSendMessageResponseApplicationJsonBuilder> {
  factory ChatSendMessageResponseApplicationJson([
    final void Function(ChatSendMessageResponseApplicationJsonBuilder)? b,
  ]) = _$ChatSendMessageResponseApplicationJson;

  // coverage:ignore-start
  const ChatSendMessageResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatSendMessageResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatSendMessageResponseApplicationJson> get serializer =>
      _$chatSendMessageResponseApplicationJsonSerializer;
}

class ChatClearHistoryApiVersion extends EnumClass {
  const ChatClearHistoryApiVersion._(super.name);

  static const ChatClearHistoryApiVersion v1 = _$chatClearHistoryApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<ChatClearHistoryApiVersion> get values => _$chatClearHistoryApiVersionValues;
  // coverage:ignore-end
  static ChatClearHistoryApiVersion valueOf(final String name) => _$valueOfChatClearHistoryApiVersion(name);
  static Serializer<ChatClearHistoryApiVersion> get serializer => _$chatClearHistoryApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatChatClearHistoryHeadersInterface {
  @BuiltValueField(wireName: 'x-chat-last-common-read')
  String? get xChatLastCommonRead;
}

abstract class ChatChatClearHistoryHeaders
    implements
        ChatChatClearHistoryHeadersInterface,
        Built<ChatChatClearHistoryHeaders, ChatChatClearHistoryHeadersBuilder> {
  factory ChatChatClearHistoryHeaders([final void Function(ChatChatClearHistoryHeadersBuilder)? b]) =
      _$ChatChatClearHistoryHeaders;

  // coverage:ignore-start
  const ChatChatClearHistoryHeaders._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatChatClearHistoryHeaders.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  @BuiltValueSerializer(custom: true)
  static Serializer<ChatChatClearHistoryHeaders> get serializer => _$ChatChatClearHistoryHeadersSerializer();
}

class _$ChatChatClearHistoryHeadersSerializer implements StructuredSerializer<ChatChatClearHistoryHeaders> {
  @override
  final Iterable<Type> types = const [ChatChatClearHistoryHeaders, _$ChatChatClearHistoryHeaders];

  @override
  final String wireName = 'ChatChatClearHistoryHeaders';

  @override
  Iterable<Object?> serialize(
    final Serializers serializers,
    final ChatChatClearHistoryHeaders object, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    throw UnimplementedError();
  }

  @override
  ChatChatClearHistoryHeaders deserialize(
    final Serializers serializers,
    final Iterable<Object?> serialized, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatChatClearHistoryHeadersBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final value = iterator.current! as String;
      switch (key) {
        case 'x-chat-last-common-read':
          result.xChatLastCommonRead = value;
      }
    }

    return result.build();
  }
}

@BuiltValue(instantiable: false)
abstract interface class ChatClearHistoryResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  ChatMessage get data;
}

abstract class ChatClearHistoryResponseApplicationJson_Ocs
    implements
        ChatClearHistoryResponseApplicationJson_OcsInterface,
        Built<ChatClearHistoryResponseApplicationJson_Ocs, ChatClearHistoryResponseApplicationJson_OcsBuilder> {
  factory ChatClearHistoryResponseApplicationJson_Ocs([
    final void Function(ChatClearHistoryResponseApplicationJson_OcsBuilder)? b,
  ]) = _$ChatClearHistoryResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const ChatClearHistoryResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatClearHistoryResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatClearHistoryResponseApplicationJson_Ocs> get serializer =>
      _$chatClearHistoryResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatClearHistoryResponseApplicationJsonInterface {
  ChatClearHistoryResponseApplicationJson_Ocs get ocs;
}

abstract class ChatClearHistoryResponseApplicationJson
    implements
        ChatClearHistoryResponseApplicationJsonInterface,
        Built<ChatClearHistoryResponseApplicationJson, ChatClearHistoryResponseApplicationJsonBuilder> {
  factory ChatClearHistoryResponseApplicationJson([
    final void Function(ChatClearHistoryResponseApplicationJsonBuilder)? b,
  ]) = _$ChatClearHistoryResponseApplicationJson;

  // coverage:ignore-start
  const ChatClearHistoryResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatClearHistoryResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatClearHistoryResponseApplicationJson> get serializer =>
      _$chatClearHistoryResponseApplicationJsonSerializer;
}

class ChatDeleteMessageApiVersion extends EnumClass {
  const ChatDeleteMessageApiVersion._(super.name);

  static const ChatDeleteMessageApiVersion v1 = _$chatDeleteMessageApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<ChatDeleteMessageApiVersion> get values => _$chatDeleteMessageApiVersionValues;
  // coverage:ignore-end
  static ChatDeleteMessageApiVersion valueOf(final String name) => _$valueOfChatDeleteMessageApiVersion(name);
  static Serializer<ChatDeleteMessageApiVersion> get serializer => _$chatDeleteMessageApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatChatDeleteMessageHeadersInterface {
  @BuiltValueField(wireName: 'x-chat-last-common-read')
  String? get xChatLastCommonRead;
}

abstract class ChatChatDeleteMessageHeaders
    implements
        ChatChatDeleteMessageHeadersInterface,
        Built<ChatChatDeleteMessageHeaders, ChatChatDeleteMessageHeadersBuilder> {
  factory ChatChatDeleteMessageHeaders([final void Function(ChatChatDeleteMessageHeadersBuilder)? b]) =
      _$ChatChatDeleteMessageHeaders;

  // coverage:ignore-start
  const ChatChatDeleteMessageHeaders._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatChatDeleteMessageHeaders.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  @BuiltValueSerializer(custom: true)
  static Serializer<ChatChatDeleteMessageHeaders> get serializer => _$ChatChatDeleteMessageHeadersSerializer();
}

class _$ChatChatDeleteMessageHeadersSerializer implements StructuredSerializer<ChatChatDeleteMessageHeaders> {
  @override
  final Iterable<Type> types = const [ChatChatDeleteMessageHeaders, _$ChatChatDeleteMessageHeaders];

  @override
  final String wireName = 'ChatChatDeleteMessageHeaders';

  @override
  Iterable<Object?> serialize(
    final Serializers serializers,
    final ChatChatDeleteMessageHeaders object, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    throw UnimplementedError();
  }

  @override
  ChatChatDeleteMessageHeaders deserialize(
    final Serializers serializers,
    final Iterable<Object?> serialized, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatChatDeleteMessageHeadersBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final value = iterator.current! as String;
      switch (key) {
        case 'x-chat-last-common-read':
          result.xChatLastCommonRead = value;
      }
    }

    return result.build();
  }
}

@BuiltValue(instantiable: false)
abstract interface class ChatDeleteMessageResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  ChatMessageWithParent get data;
}

abstract class ChatDeleteMessageResponseApplicationJson_Ocs
    implements
        ChatDeleteMessageResponseApplicationJson_OcsInterface,
        Built<ChatDeleteMessageResponseApplicationJson_Ocs, ChatDeleteMessageResponseApplicationJson_OcsBuilder> {
  factory ChatDeleteMessageResponseApplicationJson_Ocs([
    final void Function(ChatDeleteMessageResponseApplicationJson_OcsBuilder)? b,
  ]) = _$ChatDeleteMessageResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const ChatDeleteMessageResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatDeleteMessageResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatDeleteMessageResponseApplicationJson_Ocs> get serializer =>
      _$chatDeleteMessageResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatDeleteMessageResponseApplicationJsonInterface {
  ChatDeleteMessageResponseApplicationJson_Ocs get ocs;
}

abstract class ChatDeleteMessageResponseApplicationJson
    implements
        ChatDeleteMessageResponseApplicationJsonInterface,
        Built<ChatDeleteMessageResponseApplicationJson, ChatDeleteMessageResponseApplicationJsonBuilder> {
  factory ChatDeleteMessageResponseApplicationJson([
    final void Function(ChatDeleteMessageResponseApplicationJsonBuilder)? b,
  ]) = _$ChatDeleteMessageResponseApplicationJson;

  // coverage:ignore-start
  const ChatDeleteMessageResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatDeleteMessageResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatDeleteMessageResponseApplicationJson> get serializer =>
      _$chatDeleteMessageResponseApplicationJsonSerializer;
}

class ChatGetMessageContextApiVersion extends EnumClass {
  const ChatGetMessageContextApiVersion._(super.name);

  static const ChatGetMessageContextApiVersion v1 = _$chatGetMessageContextApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<ChatGetMessageContextApiVersion> get values => _$chatGetMessageContextApiVersionValues;
  // coverage:ignore-end
  static ChatGetMessageContextApiVersion valueOf(final String name) => _$valueOfChatGetMessageContextApiVersion(name);
  static Serializer<ChatGetMessageContextApiVersion> get serializer => _$chatGetMessageContextApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatChatGetMessageContextHeadersInterface {
  @BuiltValueField(wireName: 'x-chat-last-common-read')
  String? get xChatLastCommonRead;
  @BuiltValueField(wireName: 'x-chat-last-given')
  String? get xChatLastGiven;
}

abstract class ChatChatGetMessageContextHeaders
    implements
        ChatChatGetMessageContextHeadersInterface,
        Built<ChatChatGetMessageContextHeaders, ChatChatGetMessageContextHeadersBuilder> {
  factory ChatChatGetMessageContextHeaders([final void Function(ChatChatGetMessageContextHeadersBuilder)? b]) =
      _$ChatChatGetMessageContextHeaders;

  // coverage:ignore-start
  const ChatChatGetMessageContextHeaders._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatChatGetMessageContextHeaders.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  @BuiltValueSerializer(custom: true)
  static Serializer<ChatChatGetMessageContextHeaders> get serializer => _$ChatChatGetMessageContextHeadersSerializer();
}

class _$ChatChatGetMessageContextHeadersSerializer implements StructuredSerializer<ChatChatGetMessageContextHeaders> {
  @override
  final Iterable<Type> types = const [ChatChatGetMessageContextHeaders, _$ChatChatGetMessageContextHeaders];

  @override
  final String wireName = 'ChatChatGetMessageContextHeaders';

  @override
  Iterable<Object?> serialize(
    final Serializers serializers,
    final ChatChatGetMessageContextHeaders object, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    throw UnimplementedError();
  }

  @override
  ChatChatGetMessageContextHeaders deserialize(
    final Serializers serializers,
    final Iterable<Object?> serialized, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatChatGetMessageContextHeadersBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final value = iterator.current! as String;
      switch (key) {
        case 'x-chat-last-common-read':
          result.xChatLastCommonRead = value;
        case 'x-chat-last-given':
          result.xChatLastGiven = value;
      }
    }

    return result.build();
  }
}

@BuiltValue(instantiable: false)
abstract interface class ChatGetMessageContextResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  BuiltList<ChatMessageWithParent> get data;
}

abstract class ChatGetMessageContextResponseApplicationJson_Ocs
    implements
        ChatGetMessageContextResponseApplicationJson_OcsInterface,
        Built<ChatGetMessageContextResponseApplicationJson_Ocs,
            ChatGetMessageContextResponseApplicationJson_OcsBuilder> {
  factory ChatGetMessageContextResponseApplicationJson_Ocs([
    final void Function(ChatGetMessageContextResponseApplicationJson_OcsBuilder)? b,
  ]) = _$ChatGetMessageContextResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const ChatGetMessageContextResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatGetMessageContextResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatGetMessageContextResponseApplicationJson_Ocs> get serializer =>
      _$chatGetMessageContextResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatGetMessageContextResponseApplicationJsonInterface {
  ChatGetMessageContextResponseApplicationJson_Ocs get ocs;
}

abstract class ChatGetMessageContextResponseApplicationJson
    implements
        ChatGetMessageContextResponseApplicationJsonInterface,
        Built<ChatGetMessageContextResponseApplicationJson, ChatGetMessageContextResponseApplicationJsonBuilder> {
  factory ChatGetMessageContextResponseApplicationJson([
    final void Function(ChatGetMessageContextResponseApplicationJsonBuilder)? b,
  ]) = _$ChatGetMessageContextResponseApplicationJson;

  // coverage:ignore-start
  const ChatGetMessageContextResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatGetMessageContextResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatGetMessageContextResponseApplicationJson> get serializer =>
      _$chatGetMessageContextResponseApplicationJsonSerializer;
}

class ChatGetReminderApiVersion extends EnumClass {
  const ChatGetReminderApiVersion._(super.name);

  static const ChatGetReminderApiVersion v1 = _$chatGetReminderApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<ChatGetReminderApiVersion> get values => _$chatGetReminderApiVersionValues;
  // coverage:ignore-end
  static ChatGetReminderApiVersion valueOf(final String name) => _$valueOfChatGetReminderApiVersion(name);
  static Serializer<ChatGetReminderApiVersion> get serializer => _$chatGetReminderApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatReminderInterface {
  int get messageId;
  int get timestamp;
  String get token;
  String get userId;
}

abstract class ChatReminder implements ChatReminderInterface, Built<ChatReminder, ChatReminderBuilder> {
  factory ChatReminder([final void Function(ChatReminderBuilder)? b]) = _$ChatReminder;

  // coverage:ignore-start
  const ChatReminder._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatReminder.fromJson(final Map<String, dynamic> json) => _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatReminder> get serializer => _$chatReminderSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatGetReminderResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  ChatReminder get data;
}

abstract class ChatGetReminderResponseApplicationJson_Ocs
    implements
        ChatGetReminderResponseApplicationJson_OcsInterface,
        Built<ChatGetReminderResponseApplicationJson_Ocs, ChatGetReminderResponseApplicationJson_OcsBuilder> {
  factory ChatGetReminderResponseApplicationJson_Ocs([
    final void Function(ChatGetReminderResponseApplicationJson_OcsBuilder)? b,
  ]) = _$ChatGetReminderResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const ChatGetReminderResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatGetReminderResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatGetReminderResponseApplicationJson_Ocs> get serializer =>
      _$chatGetReminderResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatGetReminderResponseApplicationJsonInterface {
  ChatGetReminderResponseApplicationJson_Ocs get ocs;
}

abstract class ChatGetReminderResponseApplicationJson
    implements
        ChatGetReminderResponseApplicationJsonInterface,
        Built<ChatGetReminderResponseApplicationJson, ChatGetReminderResponseApplicationJsonBuilder> {
  factory ChatGetReminderResponseApplicationJson([
    final void Function(ChatGetReminderResponseApplicationJsonBuilder)? b,
  ]) = _$ChatGetReminderResponseApplicationJson;

  // coverage:ignore-start
  const ChatGetReminderResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatGetReminderResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatGetReminderResponseApplicationJson> get serializer =>
      _$chatGetReminderResponseApplicationJsonSerializer;
}

class ChatSetReminderApiVersion extends EnumClass {
  const ChatSetReminderApiVersion._(super.name);

  static const ChatSetReminderApiVersion v1 = _$chatSetReminderApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<ChatSetReminderApiVersion> get values => _$chatSetReminderApiVersionValues;
  // coverage:ignore-end
  static ChatSetReminderApiVersion valueOf(final String name) => _$valueOfChatSetReminderApiVersion(name);
  static Serializer<ChatSetReminderApiVersion> get serializer => _$chatSetReminderApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatSetReminderResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  ChatReminder get data;
}

abstract class ChatSetReminderResponseApplicationJson_Ocs
    implements
        ChatSetReminderResponseApplicationJson_OcsInterface,
        Built<ChatSetReminderResponseApplicationJson_Ocs, ChatSetReminderResponseApplicationJson_OcsBuilder> {
  factory ChatSetReminderResponseApplicationJson_Ocs([
    final void Function(ChatSetReminderResponseApplicationJson_OcsBuilder)? b,
  ]) = _$ChatSetReminderResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const ChatSetReminderResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatSetReminderResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatSetReminderResponseApplicationJson_Ocs> get serializer =>
      _$chatSetReminderResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatSetReminderResponseApplicationJsonInterface {
  ChatSetReminderResponseApplicationJson_Ocs get ocs;
}

abstract class ChatSetReminderResponseApplicationJson
    implements
        ChatSetReminderResponseApplicationJsonInterface,
        Built<ChatSetReminderResponseApplicationJson, ChatSetReminderResponseApplicationJsonBuilder> {
  factory ChatSetReminderResponseApplicationJson([
    final void Function(ChatSetReminderResponseApplicationJsonBuilder)? b,
  ]) = _$ChatSetReminderResponseApplicationJson;

  // coverage:ignore-start
  const ChatSetReminderResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatSetReminderResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatSetReminderResponseApplicationJson> get serializer =>
      _$chatSetReminderResponseApplicationJsonSerializer;
}

class ChatDeleteReminderApiVersion extends EnumClass {
  const ChatDeleteReminderApiVersion._(super.name);

  static const ChatDeleteReminderApiVersion v1 = _$chatDeleteReminderApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<ChatDeleteReminderApiVersion> get values => _$chatDeleteReminderApiVersionValues;
  // coverage:ignore-end
  static ChatDeleteReminderApiVersion valueOf(final String name) => _$valueOfChatDeleteReminderApiVersion(name);
  static Serializer<ChatDeleteReminderApiVersion> get serializer => _$chatDeleteReminderApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatDeleteReminderResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class ChatDeleteReminderResponseApplicationJson_Ocs
    implements
        ChatDeleteReminderResponseApplicationJson_OcsInterface,
        Built<ChatDeleteReminderResponseApplicationJson_Ocs, ChatDeleteReminderResponseApplicationJson_OcsBuilder> {
  factory ChatDeleteReminderResponseApplicationJson_Ocs([
    final void Function(ChatDeleteReminderResponseApplicationJson_OcsBuilder)? b,
  ]) = _$ChatDeleteReminderResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const ChatDeleteReminderResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatDeleteReminderResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatDeleteReminderResponseApplicationJson_Ocs> get serializer =>
      _$chatDeleteReminderResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatDeleteReminderResponseApplicationJsonInterface {
  ChatDeleteReminderResponseApplicationJson_Ocs get ocs;
}

abstract class ChatDeleteReminderResponseApplicationJson
    implements
        ChatDeleteReminderResponseApplicationJsonInterface,
        Built<ChatDeleteReminderResponseApplicationJson, ChatDeleteReminderResponseApplicationJsonBuilder> {
  factory ChatDeleteReminderResponseApplicationJson([
    final void Function(ChatDeleteReminderResponseApplicationJsonBuilder)? b,
  ]) = _$ChatDeleteReminderResponseApplicationJson;

  // coverage:ignore-start
  const ChatDeleteReminderResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatDeleteReminderResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatDeleteReminderResponseApplicationJson> get serializer =>
      _$chatDeleteReminderResponseApplicationJsonSerializer;
}

class ChatSetReadMarkerApiVersion extends EnumClass {
  const ChatSetReadMarkerApiVersion._(super.name);

  static const ChatSetReadMarkerApiVersion v1 = _$chatSetReadMarkerApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<ChatSetReadMarkerApiVersion> get values => _$chatSetReadMarkerApiVersionValues;
  // coverage:ignore-end
  static ChatSetReadMarkerApiVersion valueOf(final String name) => _$valueOfChatSetReadMarkerApiVersion(name);
  static Serializer<ChatSetReadMarkerApiVersion> get serializer => _$chatSetReadMarkerApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatChatSetReadMarkerHeadersInterface {
  @BuiltValueField(wireName: 'x-chat-last-common-read')
  String? get xChatLastCommonRead;
}

abstract class ChatChatSetReadMarkerHeaders
    implements
        ChatChatSetReadMarkerHeadersInterface,
        Built<ChatChatSetReadMarkerHeaders, ChatChatSetReadMarkerHeadersBuilder> {
  factory ChatChatSetReadMarkerHeaders([final void Function(ChatChatSetReadMarkerHeadersBuilder)? b]) =
      _$ChatChatSetReadMarkerHeaders;

  // coverage:ignore-start
  const ChatChatSetReadMarkerHeaders._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatChatSetReadMarkerHeaders.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  @BuiltValueSerializer(custom: true)
  static Serializer<ChatChatSetReadMarkerHeaders> get serializer => _$ChatChatSetReadMarkerHeadersSerializer();
}

class _$ChatChatSetReadMarkerHeadersSerializer implements StructuredSerializer<ChatChatSetReadMarkerHeaders> {
  @override
  final Iterable<Type> types = const [ChatChatSetReadMarkerHeaders, _$ChatChatSetReadMarkerHeaders];

  @override
  final String wireName = 'ChatChatSetReadMarkerHeaders';

  @override
  Iterable<Object?> serialize(
    final Serializers serializers,
    final ChatChatSetReadMarkerHeaders object, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    throw UnimplementedError();
  }

  @override
  ChatChatSetReadMarkerHeaders deserialize(
    final Serializers serializers,
    final Iterable<Object?> serialized, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatChatSetReadMarkerHeadersBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final value = iterator.current! as String;
      switch (key) {
        case 'x-chat-last-common-read':
          result.xChatLastCommonRead = value;
      }
    }

    return result.build();
  }
}

@BuiltValue(instantiable: false)
abstract interface class ChatSetReadMarkerResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class ChatSetReadMarkerResponseApplicationJson_Ocs
    implements
        ChatSetReadMarkerResponseApplicationJson_OcsInterface,
        Built<ChatSetReadMarkerResponseApplicationJson_Ocs, ChatSetReadMarkerResponseApplicationJson_OcsBuilder> {
  factory ChatSetReadMarkerResponseApplicationJson_Ocs([
    final void Function(ChatSetReadMarkerResponseApplicationJson_OcsBuilder)? b,
  ]) = _$ChatSetReadMarkerResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const ChatSetReadMarkerResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatSetReadMarkerResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatSetReadMarkerResponseApplicationJson_Ocs> get serializer =>
      _$chatSetReadMarkerResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatSetReadMarkerResponseApplicationJsonInterface {
  ChatSetReadMarkerResponseApplicationJson_Ocs get ocs;
}

abstract class ChatSetReadMarkerResponseApplicationJson
    implements
        ChatSetReadMarkerResponseApplicationJsonInterface,
        Built<ChatSetReadMarkerResponseApplicationJson, ChatSetReadMarkerResponseApplicationJsonBuilder> {
  factory ChatSetReadMarkerResponseApplicationJson([
    final void Function(ChatSetReadMarkerResponseApplicationJsonBuilder)? b,
  ]) = _$ChatSetReadMarkerResponseApplicationJson;

  // coverage:ignore-start
  const ChatSetReadMarkerResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatSetReadMarkerResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatSetReadMarkerResponseApplicationJson> get serializer =>
      _$chatSetReadMarkerResponseApplicationJsonSerializer;
}

class ChatMarkUnreadApiVersion extends EnumClass {
  const ChatMarkUnreadApiVersion._(super.name);

  static const ChatMarkUnreadApiVersion v1 = _$chatMarkUnreadApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<ChatMarkUnreadApiVersion> get values => _$chatMarkUnreadApiVersionValues;
  // coverage:ignore-end
  static ChatMarkUnreadApiVersion valueOf(final String name) => _$valueOfChatMarkUnreadApiVersion(name);
  static Serializer<ChatMarkUnreadApiVersion> get serializer => _$chatMarkUnreadApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatChatMarkUnreadHeadersInterface {
  @BuiltValueField(wireName: 'x-chat-last-common-read')
  String? get xChatLastCommonRead;
}

abstract class ChatChatMarkUnreadHeaders
    implements ChatChatMarkUnreadHeadersInterface, Built<ChatChatMarkUnreadHeaders, ChatChatMarkUnreadHeadersBuilder> {
  factory ChatChatMarkUnreadHeaders([final void Function(ChatChatMarkUnreadHeadersBuilder)? b]) =
      _$ChatChatMarkUnreadHeaders;

  // coverage:ignore-start
  const ChatChatMarkUnreadHeaders._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatChatMarkUnreadHeaders.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  @BuiltValueSerializer(custom: true)
  static Serializer<ChatChatMarkUnreadHeaders> get serializer => _$ChatChatMarkUnreadHeadersSerializer();
}

class _$ChatChatMarkUnreadHeadersSerializer implements StructuredSerializer<ChatChatMarkUnreadHeaders> {
  @override
  final Iterable<Type> types = const [ChatChatMarkUnreadHeaders, _$ChatChatMarkUnreadHeaders];

  @override
  final String wireName = 'ChatChatMarkUnreadHeaders';

  @override
  Iterable<Object?> serialize(
    final Serializers serializers,
    final ChatChatMarkUnreadHeaders object, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    throw UnimplementedError();
  }

  @override
  ChatChatMarkUnreadHeaders deserialize(
    final Serializers serializers,
    final Iterable<Object?> serialized, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatChatMarkUnreadHeadersBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final value = iterator.current! as String;
      switch (key) {
        case 'x-chat-last-common-read':
          result.xChatLastCommonRead = value;
      }
    }

    return result.build();
  }
}

@BuiltValue(instantiable: false)
abstract interface class ChatMarkUnreadResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class ChatMarkUnreadResponseApplicationJson_Ocs
    implements
        ChatMarkUnreadResponseApplicationJson_OcsInterface,
        Built<ChatMarkUnreadResponseApplicationJson_Ocs, ChatMarkUnreadResponseApplicationJson_OcsBuilder> {
  factory ChatMarkUnreadResponseApplicationJson_Ocs([
    final void Function(ChatMarkUnreadResponseApplicationJson_OcsBuilder)? b,
  ]) = _$ChatMarkUnreadResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const ChatMarkUnreadResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatMarkUnreadResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatMarkUnreadResponseApplicationJson_Ocs> get serializer =>
      _$chatMarkUnreadResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatMarkUnreadResponseApplicationJsonInterface {
  ChatMarkUnreadResponseApplicationJson_Ocs get ocs;
}

abstract class ChatMarkUnreadResponseApplicationJson
    implements
        ChatMarkUnreadResponseApplicationJsonInterface,
        Built<ChatMarkUnreadResponseApplicationJson, ChatMarkUnreadResponseApplicationJsonBuilder> {
  factory ChatMarkUnreadResponseApplicationJson([
    final void Function(ChatMarkUnreadResponseApplicationJsonBuilder)? b,
  ]) = _$ChatMarkUnreadResponseApplicationJson;

  // coverage:ignore-start
  const ChatMarkUnreadResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatMarkUnreadResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatMarkUnreadResponseApplicationJson> get serializer =>
      _$chatMarkUnreadResponseApplicationJsonSerializer;
}

class ChatMentionsApiVersion extends EnumClass {
  const ChatMentionsApiVersion._(super.name);

  static const ChatMentionsApiVersion v1 = _$chatMentionsApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<ChatMentionsApiVersion> get values => _$chatMentionsApiVersionValues;
  // coverage:ignore-end
  static ChatMentionsApiVersion valueOf(final String name) => _$valueOfChatMentionsApiVersion(name);
  static Serializer<ChatMentionsApiVersion> get serializer => _$chatMentionsApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatMentionSuggestionInterface {
  String get id;
  String get label;
  String get source;
  String? get status;
  int? get statusClearAt;
  String? get statusIcon;
  String? get statusMessage;
}

abstract class ChatMentionSuggestion
    implements ChatMentionSuggestionInterface, Built<ChatMentionSuggestion, ChatMentionSuggestionBuilder> {
  factory ChatMentionSuggestion([final void Function(ChatMentionSuggestionBuilder)? b]) = _$ChatMentionSuggestion;

  // coverage:ignore-start
  const ChatMentionSuggestion._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatMentionSuggestion.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatMentionSuggestion> get serializer => _$chatMentionSuggestionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatMentionsResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  BuiltList<ChatMentionSuggestion> get data;
}

abstract class ChatMentionsResponseApplicationJson_Ocs
    implements
        ChatMentionsResponseApplicationJson_OcsInterface,
        Built<ChatMentionsResponseApplicationJson_Ocs, ChatMentionsResponseApplicationJson_OcsBuilder> {
  factory ChatMentionsResponseApplicationJson_Ocs([
    final void Function(ChatMentionsResponseApplicationJson_OcsBuilder)? b,
  ]) = _$ChatMentionsResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const ChatMentionsResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatMentionsResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatMentionsResponseApplicationJson_Ocs> get serializer =>
      _$chatMentionsResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatMentionsResponseApplicationJsonInterface {
  ChatMentionsResponseApplicationJson_Ocs get ocs;
}

abstract class ChatMentionsResponseApplicationJson
    implements
        ChatMentionsResponseApplicationJsonInterface,
        Built<ChatMentionsResponseApplicationJson, ChatMentionsResponseApplicationJsonBuilder> {
  factory ChatMentionsResponseApplicationJson([final void Function(ChatMentionsResponseApplicationJsonBuilder)? b]) =
      _$ChatMentionsResponseApplicationJson;

  // coverage:ignore-start
  const ChatMentionsResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatMentionsResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatMentionsResponseApplicationJson> get serializer =>
      _$chatMentionsResponseApplicationJsonSerializer;
}

class ChatGetObjectsSharedInRoomApiVersion extends EnumClass {
  const ChatGetObjectsSharedInRoomApiVersion._(super.name);

  static const ChatGetObjectsSharedInRoomApiVersion v1 = _$chatGetObjectsSharedInRoomApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<ChatGetObjectsSharedInRoomApiVersion> get values => _$chatGetObjectsSharedInRoomApiVersionValues;
  // coverage:ignore-end
  static ChatGetObjectsSharedInRoomApiVersion valueOf(final String name) =>
      _$valueOfChatGetObjectsSharedInRoomApiVersion(name);
  static Serializer<ChatGetObjectsSharedInRoomApiVersion> get serializer =>
      _$chatGetObjectsSharedInRoomApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatChatGetObjectsSharedInRoomHeadersInterface {
  @BuiltValueField(wireName: 'x-chat-last-given')
  String? get xChatLastGiven;
}

abstract class ChatChatGetObjectsSharedInRoomHeaders
    implements
        ChatChatGetObjectsSharedInRoomHeadersInterface,
        Built<ChatChatGetObjectsSharedInRoomHeaders, ChatChatGetObjectsSharedInRoomHeadersBuilder> {
  factory ChatChatGetObjectsSharedInRoomHeaders([
    final void Function(ChatChatGetObjectsSharedInRoomHeadersBuilder)? b,
  ]) = _$ChatChatGetObjectsSharedInRoomHeaders;

  // coverage:ignore-start
  const ChatChatGetObjectsSharedInRoomHeaders._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatChatGetObjectsSharedInRoomHeaders.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  @BuiltValueSerializer(custom: true)
  static Serializer<ChatChatGetObjectsSharedInRoomHeaders> get serializer =>
      _$ChatChatGetObjectsSharedInRoomHeadersSerializer();
}

class _$ChatChatGetObjectsSharedInRoomHeadersSerializer
    implements StructuredSerializer<ChatChatGetObjectsSharedInRoomHeaders> {
  @override
  final Iterable<Type> types = const [ChatChatGetObjectsSharedInRoomHeaders, _$ChatChatGetObjectsSharedInRoomHeaders];

  @override
  final String wireName = 'ChatChatGetObjectsSharedInRoomHeaders';

  @override
  Iterable<Object?> serialize(
    final Serializers serializers,
    final ChatChatGetObjectsSharedInRoomHeaders object, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    throw UnimplementedError();
  }

  @override
  ChatChatGetObjectsSharedInRoomHeaders deserialize(
    final Serializers serializers,
    final Iterable<Object?> serialized, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatChatGetObjectsSharedInRoomHeadersBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final value = iterator.current! as String;
      switch (key) {
        case 'x-chat-last-given':
          result.xChatLastGiven = value;
      }
    }

    return result.build();
  }
}

@BuiltValue(instantiable: false)
abstract interface class ChatGetObjectsSharedInRoomResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  BuiltList<ChatMessage> get data;
}

abstract class ChatGetObjectsSharedInRoomResponseApplicationJson_Ocs
    implements
        ChatGetObjectsSharedInRoomResponseApplicationJson_OcsInterface,
        Built<ChatGetObjectsSharedInRoomResponseApplicationJson_Ocs,
            ChatGetObjectsSharedInRoomResponseApplicationJson_OcsBuilder> {
  factory ChatGetObjectsSharedInRoomResponseApplicationJson_Ocs([
    final void Function(ChatGetObjectsSharedInRoomResponseApplicationJson_OcsBuilder)? b,
  ]) = _$ChatGetObjectsSharedInRoomResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const ChatGetObjectsSharedInRoomResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatGetObjectsSharedInRoomResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatGetObjectsSharedInRoomResponseApplicationJson_Ocs> get serializer =>
      _$chatGetObjectsSharedInRoomResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatGetObjectsSharedInRoomResponseApplicationJsonInterface {
  ChatGetObjectsSharedInRoomResponseApplicationJson_Ocs get ocs;
}

abstract class ChatGetObjectsSharedInRoomResponseApplicationJson
    implements
        ChatGetObjectsSharedInRoomResponseApplicationJsonInterface,
        Built<ChatGetObjectsSharedInRoomResponseApplicationJson,
            ChatGetObjectsSharedInRoomResponseApplicationJsonBuilder> {
  factory ChatGetObjectsSharedInRoomResponseApplicationJson([
    final void Function(ChatGetObjectsSharedInRoomResponseApplicationJsonBuilder)? b,
  ]) = _$ChatGetObjectsSharedInRoomResponseApplicationJson;

  // coverage:ignore-start
  const ChatGetObjectsSharedInRoomResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatGetObjectsSharedInRoomResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatGetObjectsSharedInRoomResponseApplicationJson> get serializer =>
      _$chatGetObjectsSharedInRoomResponseApplicationJsonSerializer;
}

class ChatShareObjectToChatApiVersion extends EnumClass {
  const ChatShareObjectToChatApiVersion._(super.name);

  static const ChatShareObjectToChatApiVersion v1 = _$chatShareObjectToChatApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<ChatShareObjectToChatApiVersion> get values => _$chatShareObjectToChatApiVersionValues;
  // coverage:ignore-end
  static ChatShareObjectToChatApiVersion valueOf(final String name) => _$valueOfChatShareObjectToChatApiVersion(name);
  static Serializer<ChatShareObjectToChatApiVersion> get serializer => _$chatShareObjectToChatApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatChatShareObjectToChatHeadersInterface {
  @BuiltValueField(wireName: 'x-chat-last-common-read')
  String? get xChatLastCommonRead;
}

abstract class ChatChatShareObjectToChatHeaders
    implements
        ChatChatShareObjectToChatHeadersInterface,
        Built<ChatChatShareObjectToChatHeaders, ChatChatShareObjectToChatHeadersBuilder> {
  factory ChatChatShareObjectToChatHeaders([final void Function(ChatChatShareObjectToChatHeadersBuilder)? b]) =
      _$ChatChatShareObjectToChatHeaders;

  // coverage:ignore-start
  const ChatChatShareObjectToChatHeaders._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatChatShareObjectToChatHeaders.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  @BuiltValueSerializer(custom: true)
  static Serializer<ChatChatShareObjectToChatHeaders> get serializer => _$ChatChatShareObjectToChatHeadersSerializer();
}

class _$ChatChatShareObjectToChatHeadersSerializer implements StructuredSerializer<ChatChatShareObjectToChatHeaders> {
  @override
  final Iterable<Type> types = const [ChatChatShareObjectToChatHeaders, _$ChatChatShareObjectToChatHeaders];

  @override
  final String wireName = 'ChatChatShareObjectToChatHeaders';

  @override
  Iterable<Object?> serialize(
    final Serializers serializers,
    final ChatChatShareObjectToChatHeaders object, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    throw UnimplementedError();
  }

  @override
  ChatChatShareObjectToChatHeaders deserialize(
    final Serializers serializers,
    final Iterable<Object?> serialized, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatChatShareObjectToChatHeadersBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final value = iterator.current! as String;
      switch (key) {
        case 'x-chat-last-common-read':
          result.xChatLastCommonRead = value;
      }
    }

    return result.build();
  }
}

@BuiltValue(instantiable: false)
abstract interface class ChatShareObjectToChatResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  ChatMessageWithParent? get data;
}

abstract class ChatShareObjectToChatResponseApplicationJson_Ocs
    implements
        ChatShareObjectToChatResponseApplicationJson_OcsInterface,
        Built<ChatShareObjectToChatResponseApplicationJson_Ocs,
            ChatShareObjectToChatResponseApplicationJson_OcsBuilder> {
  factory ChatShareObjectToChatResponseApplicationJson_Ocs([
    final void Function(ChatShareObjectToChatResponseApplicationJson_OcsBuilder)? b,
  ]) = _$ChatShareObjectToChatResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const ChatShareObjectToChatResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatShareObjectToChatResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatShareObjectToChatResponseApplicationJson_Ocs> get serializer =>
      _$chatShareObjectToChatResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatShareObjectToChatResponseApplicationJsonInterface {
  ChatShareObjectToChatResponseApplicationJson_Ocs get ocs;
}

abstract class ChatShareObjectToChatResponseApplicationJson
    implements
        ChatShareObjectToChatResponseApplicationJsonInterface,
        Built<ChatShareObjectToChatResponseApplicationJson, ChatShareObjectToChatResponseApplicationJsonBuilder> {
  factory ChatShareObjectToChatResponseApplicationJson([
    final void Function(ChatShareObjectToChatResponseApplicationJsonBuilder)? b,
  ]) = _$ChatShareObjectToChatResponseApplicationJson;

  // coverage:ignore-start
  const ChatShareObjectToChatResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatShareObjectToChatResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatShareObjectToChatResponseApplicationJson> get serializer =>
      _$chatShareObjectToChatResponseApplicationJsonSerializer;
}

class ChatGetObjectsSharedInRoomOverviewApiVersion extends EnumClass {
  const ChatGetObjectsSharedInRoomOverviewApiVersion._(super.name);

  static const ChatGetObjectsSharedInRoomOverviewApiVersion v1 = _$chatGetObjectsSharedInRoomOverviewApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<ChatGetObjectsSharedInRoomOverviewApiVersion> get values =>
      _$chatGetObjectsSharedInRoomOverviewApiVersionValues;
  // coverage:ignore-end
  static ChatGetObjectsSharedInRoomOverviewApiVersion valueOf(final String name) =>
      _$valueOfChatGetObjectsSharedInRoomOverviewApiVersion(name);
  static Serializer<ChatGetObjectsSharedInRoomOverviewApiVersion> get serializer =>
      _$chatGetObjectsSharedInRoomOverviewApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatGetObjectsSharedInRoomOverviewResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  BuiltMap<String, BuiltList<ChatMessage>> get data;
}

abstract class ChatGetObjectsSharedInRoomOverviewResponseApplicationJson_Ocs
    implements
        ChatGetObjectsSharedInRoomOverviewResponseApplicationJson_OcsInterface,
        Built<ChatGetObjectsSharedInRoomOverviewResponseApplicationJson_Ocs,
            ChatGetObjectsSharedInRoomOverviewResponseApplicationJson_OcsBuilder> {
  factory ChatGetObjectsSharedInRoomOverviewResponseApplicationJson_Ocs([
    final void Function(ChatGetObjectsSharedInRoomOverviewResponseApplicationJson_OcsBuilder)? b,
  ]) = _$ChatGetObjectsSharedInRoomOverviewResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const ChatGetObjectsSharedInRoomOverviewResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatGetObjectsSharedInRoomOverviewResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatGetObjectsSharedInRoomOverviewResponseApplicationJson_Ocs> get serializer =>
      _$chatGetObjectsSharedInRoomOverviewResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ChatGetObjectsSharedInRoomOverviewResponseApplicationJsonInterface {
  ChatGetObjectsSharedInRoomOverviewResponseApplicationJson_Ocs get ocs;
}

abstract class ChatGetObjectsSharedInRoomOverviewResponseApplicationJson
    implements
        ChatGetObjectsSharedInRoomOverviewResponseApplicationJsonInterface,
        Built<ChatGetObjectsSharedInRoomOverviewResponseApplicationJson,
            ChatGetObjectsSharedInRoomOverviewResponseApplicationJsonBuilder> {
  factory ChatGetObjectsSharedInRoomOverviewResponseApplicationJson([
    final void Function(ChatGetObjectsSharedInRoomOverviewResponseApplicationJsonBuilder)? b,
  ]) = _$ChatGetObjectsSharedInRoomOverviewResponseApplicationJson;

  // coverage:ignore-start
  const ChatGetObjectsSharedInRoomOverviewResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ChatGetObjectsSharedInRoomOverviewResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ChatGetObjectsSharedInRoomOverviewResponseApplicationJson> get serializer =>
      _$chatGetObjectsSharedInRoomOverviewResponseApplicationJsonSerializer;
}

class FederationAcceptShareApiVersion extends EnumClass {
  const FederationAcceptShareApiVersion._(super.name);

  static const FederationAcceptShareApiVersion v1 = _$federationAcceptShareApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<FederationAcceptShareApiVersion> get values => _$federationAcceptShareApiVersionValues;
  // coverage:ignore-end
  static FederationAcceptShareApiVersion valueOf(final String name) => _$valueOfFederationAcceptShareApiVersion(name);
  static Serializer<FederationAcceptShareApiVersion> get serializer => _$federationAcceptShareApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class FederationAcceptShareResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class FederationAcceptShareResponseApplicationJson_Ocs
    implements
        FederationAcceptShareResponseApplicationJson_OcsInterface,
        Built<FederationAcceptShareResponseApplicationJson_Ocs,
            FederationAcceptShareResponseApplicationJson_OcsBuilder> {
  factory FederationAcceptShareResponseApplicationJson_Ocs([
    final void Function(FederationAcceptShareResponseApplicationJson_OcsBuilder)? b,
  ]) = _$FederationAcceptShareResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const FederationAcceptShareResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory FederationAcceptShareResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<FederationAcceptShareResponseApplicationJson_Ocs> get serializer =>
      _$federationAcceptShareResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class FederationAcceptShareResponseApplicationJsonInterface {
  FederationAcceptShareResponseApplicationJson_Ocs get ocs;
}

abstract class FederationAcceptShareResponseApplicationJson
    implements
        FederationAcceptShareResponseApplicationJsonInterface,
        Built<FederationAcceptShareResponseApplicationJson, FederationAcceptShareResponseApplicationJsonBuilder> {
  factory FederationAcceptShareResponseApplicationJson([
    final void Function(FederationAcceptShareResponseApplicationJsonBuilder)? b,
  ]) = _$FederationAcceptShareResponseApplicationJson;

  // coverage:ignore-start
  const FederationAcceptShareResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory FederationAcceptShareResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<FederationAcceptShareResponseApplicationJson> get serializer =>
      _$federationAcceptShareResponseApplicationJsonSerializer;
}

class FederationRejectShareApiVersion extends EnumClass {
  const FederationRejectShareApiVersion._(super.name);

  static const FederationRejectShareApiVersion v1 = _$federationRejectShareApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<FederationRejectShareApiVersion> get values => _$federationRejectShareApiVersionValues;
  // coverage:ignore-end
  static FederationRejectShareApiVersion valueOf(final String name) => _$valueOfFederationRejectShareApiVersion(name);
  static Serializer<FederationRejectShareApiVersion> get serializer => _$federationRejectShareApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class FederationRejectShareResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class FederationRejectShareResponseApplicationJson_Ocs
    implements
        FederationRejectShareResponseApplicationJson_OcsInterface,
        Built<FederationRejectShareResponseApplicationJson_Ocs,
            FederationRejectShareResponseApplicationJson_OcsBuilder> {
  factory FederationRejectShareResponseApplicationJson_Ocs([
    final void Function(FederationRejectShareResponseApplicationJson_OcsBuilder)? b,
  ]) = _$FederationRejectShareResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const FederationRejectShareResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory FederationRejectShareResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<FederationRejectShareResponseApplicationJson_Ocs> get serializer =>
      _$federationRejectShareResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class FederationRejectShareResponseApplicationJsonInterface {
  FederationRejectShareResponseApplicationJson_Ocs get ocs;
}

abstract class FederationRejectShareResponseApplicationJson
    implements
        FederationRejectShareResponseApplicationJsonInterface,
        Built<FederationRejectShareResponseApplicationJson, FederationRejectShareResponseApplicationJsonBuilder> {
  factory FederationRejectShareResponseApplicationJson([
    final void Function(FederationRejectShareResponseApplicationJsonBuilder)? b,
  ]) = _$FederationRejectShareResponseApplicationJson;

  // coverage:ignore-start
  const FederationRejectShareResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory FederationRejectShareResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<FederationRejectShareResponseApplicationJson> get serializer =>
      _$federationRejectShareResponseApplicationJsonSerializer;
}

class FederationGetSharesApiVersion extends EnumClass {
  const FederationGetSharesApiVersion._(super.name);

  static const FederationGetSharesApiVersion v1 = _$federationGetSharesApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<FederationGetSharesApiVersion> get values => _$federationGetSharesApiVersionValues;
  // coverage:ignore-end
  static FederationGetSharesApiVersion valueOf(final String name) => _$valueOfFederationGetSharesApiVersion(name);
  static Serializer<FederationGetSharesApiVersion> get serializer => _$federationGetSharesApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class FederationInviteInterface {
  @BuiltValueField(wireName: 'access_token')
  String get accessToken;
  int get id;
  @BuiltValueField(wireName: 'remote_id')
  String get remoteId;
  @BuiltValueField(wireName: 'remote_server')
  String get remoteServer;
  @BuiltValueField(wireName: 'remote_token')
  String get remoteToken;
  @BuiltValueField(wireName: 'room_id')
  int get roomId;
  @BuiltValueField(wireName: 'user_id')
  String get userId;
}

abstract class FederationInvite implements FederationInviteInterface, Built<FederationInvite, FederationInviteBuilder> {
  factory FederationInvite([final void Function(FederationInviteBuilder)? b]) = _$FederationInvite;

  // coverage:ignore-start
  const FederationInvite._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory FederationInvite.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<FederationInvite> get serializer => _$federationInviteSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class FederationGetSharesResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  BuiltList<FederationInvite> get data;
}

abstract class FederationGetSharesResponseApplicationJson_Ocs
    implements
        FederationGetSharesResponseApplicationJson_OcsInterface,
        Built<FederationGetSharesResponseApplicationJson_Ocs, FederationGetSharesResponseApplicationJson_OcsBuilder> {
  factory FederationGetSharesResponseApplicationJson_Ocs([
    final void Function(FederationGetSharesResponseApplicationJson_OcsBuilder)? b,
  ]) = _$FederationGetSharesResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const FederationGetSharesResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory FederationGetSharesResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<FederationGetSharesResponseApplicationJson_Ocs> get serializer =>
      _$federationGetSharesResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class FederationGetSharesResponseApplicationJsonInterface {
  FederationGetSharesResponseApplicationJson_Ocs get ocs;
}

abstract class FederationGetSharesResponseApplicationJson
    implements
        FederationGetSharesResponseApplicationJsonInterface,
        Built<FederationGetSharesResponseApplicationJson, FederationGetSharesResponseApplicationJsonBuilder> {
  factory FederationGetSharesResponseApplicationJson([
    final void Function(FederationGetSharesResponseApplicationJsonBuilder)? b,
  ]) = _$FederationGetSharesResponseApplicationJson;

  // coverage:ignore-start
  const FederationGetSharesResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory FederationGetSharesResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<FederationGetSharesResponseApplicationJson> get serializer =>
      _$federationGetSharesResponseApplicationJsonSerializer;
}

class FilesIntegrationGetRoomByFileIdApiVersion extends EnumClass {
  const FilesIntegrationGetRoomByFileIdApiVersion._(super.name);

  static const FilesIntegrationGetRoomByFileIdApiVersion v1 = _$filesIntegrationGetRoomByFileIdApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<FilesIntegrationGetRoomByFileIdApiVersion> get values =>
      _$filesIntegrationGetRoomByFileIdApiVersionValues;
  // coverage:ignore-end
  static FilesIntegrationGetRoomByFileIdApiVersion valueOf(final String name) =>
      _$valueOfFilesIntegrationGetRoomByFileIdApiVersion(name);
  static Serializer<FilesIntegrationGetRoomByFileIdApiVersion> get serializer =>
      _$filesIntegrationGetRoomByFileIdApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class FilesIntegrationGetRoomByFileIdResponseApplicationJson_Ocs_DataInterface {
  String get token;
}

abstract class FilesIntegrationGetRoomByFileIdResponseApplicationJson_Ocs_Data
    implements
        FilesIntegrationGetRoomByFileIdResponseApplicationJson_Ocs_DataInterface,
        Built<FilesIntegrationGetRoomByFileIdResponseApplicationJson_Ocs_Data,
            FilesIntegrationGetRoomByFileIdResponseApplicationJson_Ocs_DataBuilder> {
  factory FilesIntegrationGetRoomByFileIdResponseApplicationJson_Ocs_Data([
    final void Function(FilesIntegrationGetRoomByFileIdResponseApplicationJson_Ocs_DataBuilder)? b,
  ]) = _$FilesIntegrationGetRoomByFileIdResponseApplicationJson_Ocs_Data;

  // coverage:ignore-start
  const FilesIntegrationGetRoomByFileIdResponseApplicationJson_Ocs_Data._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory FilesIntegrationGetRoomByFileIdResponseApplicationJson_Ocs_Data.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<FilesIntegrationGetRoomByFileIdResponseApplicationJson_Ocs_Data> get serializer =>
      _$filesIntegrationGetRoomByFileIdResponseApplicationJsonOcsDataSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class FilesIntegrationGetRoomByFileIdResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  FilesIntegrationGetRoomByFileIdResponseApplicationJson_Ocs_Data get data;
}

abstract class FilesIntegrationGetRoomByFileIdResponseApplicationJson_Ocs
    implements
        FilesIntegrationGetRoomByFileIdResponseApplicationJson_OcsInterface,
        Built<FilesIntegrationGetRoomByFileIdResponseApplicationJson_Ocs,
            FilesIntegrationGetRoomByFileIdResponseApplicationJson_OcsBuilder> {
  factory FilesIntegrationGetRoomByFileIdResponseApplicationJson_Ocs([
    final void Function(FilesIntegrationGetRoomByFileIdResponseApplicationJson_OcsBuilder)? b,
  ]) = _$FilesIntegrationGetRoomByFileIdResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const FilesIntegrationGetRoomByFileIdResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory FilesIntegrationGetRoomByFileIdResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<FilesIntegrationGetRoomByFileIdResponseApplicationJson_Ocs> get serializer =>
      _$filesIntegrationGetRoomByFileIdResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class FilesIntegrationGetRoomByFileIdResponseApplicationJsonInterface {
  FilesIntegrationGetRoomByFileIdResponseApplicationJson_Ocs get ocs;
}

abstract class FilesIntegrationGetRoomByFileIdResponseApplicationJson
    implements
        FilesIntegrationGetRoomByFileIdResponseApplicationJsonInterface,
        Built<FilesIntegrationGetRoomByFileIdResponseApplicationJson,
            FilesIntegrationGetRoomByFileIdResponseApplicationJsonBuilder> {
  factory FilesIntegrationGetRoomByFileIdResponseApplicationJson([
    final void Function(FilesIntegrationGetRoomByFileIdResponseApplicationJsonBuilder)? b,
  ]) = _$FilesIntegrationGetRoomByFileIdResponseApplicationJson;

  // coverage:ignore-start
  const FilesIntegrationGetRoomByFileIdResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory FilesIntegrationGetRoomByFileIdResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<FilesIntegrationGetRoomByFileIdResponseApplicationJson> get serializer =>
      _$filesIntegrationGetRoomByFileIdResponseApplicationJsonSerializer;
}

class FilesIntegrationGetRoomByShareTokenApiVersion extends EnumClass {
  const FilesIntegrationGetRoomByShareTokenApiVersion._(super.name);

  static const FilesIntegrationGetRoomByShareTokenApiVersion v1 = _$filesIntegrationGetRoomByShareTokenApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<FilesIntegrationGetRoomByShareTokenApiVersion> get values =>
      _$filesIntegrationGetRoomByShareTokenApiVersionValues;
  // coverage:ignore-end
  static FilesIntegrationGetRoomByShareTokenApiVersion valueOf(final String name) =>
      _$valueOfFilesIntegrationGetRoomByShareTokenApiVersion(name);
  static Serializer<FilesIntegrationGetRoomByShareTokenApiVersion> get serializer =>
      _$filesIntegrationGetRoomByShareTokenApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class FilesIntegrationGetRoomByShareTokenResponseApplicationJson_Ocs_DataInterface {
  String get token;
  String get userId;
  String get userDisplayName;
}

abstract class FilesIntegrationGetRoomByShareTokenResponseApplicationJson_Ocs_Data
    implements
        FilesIntegrationGetRoomByShareTokenResponseApplicationJson_Ocs_DataInterface,
        Built<FilesIntegrationGetRoomByShareTokenResponseApplicationJson_Ocs_Data,
            FilesIntegrationGetRoomByShareTokenResponseApplicationJson_Ocs_DataBuilder> {
  factory FilesIntegrationGetRoomByShareTokenResponseApplicationJson_Ocs_Data([
    final void Function(FilesIntegrationGetRoomByShareTokenResponseApplicationJson_Ocs_DataBuilder)? b,
  ]) = _$FilesIntegrationGetRoomByShareTokenResponseApplicationJson_Ocs_Data;

  // coverage:ignore-start
  const FilesIntegrationGetRoomByShareTokenResponseApplicationJson_Ocs_Data._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory FilesIntegrationGetRoomByShareTokenResponseApplicationJson_Ocs_Data.fromJson(
    final Map<String, dynamic> json,
  ) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<FilesIntegrationGetRoomByShareTokenResponseApplicationJson_Ocs_Data> get serializer =>
      _$filesIntegrationGetRoomByShareTokenResponseApplicationJsonOcsDataSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class FilesIntegrationGetRoomByShareTokenResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  FilesIntegrationGetRoomByShareTokenResponseApplicationJson_Ocs_Data get data;
}

abstract class FilesIntegrationGetRoomByShareTokenResponseApplicationJson_Ocs
    implements
        FilesIntegrationGetRoomByShareTokenResponseApplicationJson_OcsInterface,
        Built<FilesIntegrationGetRoomByShareTokenResponseApplicationJson_Ocs,
            FilesIntegrationGetRoomByShareTokenResponseApplicationJson_OcsBuilder> {
  factory FilesIntegrationGetRoomByShareTokenResponseApplicationJson_Ocs([
    final void Function(FilesIntegrationGetRoomByShareTokenResponseApplicationJson_OcsBuilder)? b,
  ]) = _$FilesIntegrationGetRoomByShareTokenResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const FilesIntegrationGetRoomByShareTokenResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory FilesIntegrationGetRoomByShareTokenResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<FilesIntegrationGetRoomByShareTokenResponseApplicationJson_Ocs> get serializer =>
      _$filesIntegrationGetRoomByShareTokenResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class FilesIntegrationGetRoomByShareTokenResponseApplicationJsonInterface {
  FilesIntegrationGetRoomByShareTokenResponseApplicationJson_Ocs get ocs;
}

abstract class FilesIntegrationGetRoomByShareTokenResponseApplicationJson
    implements
        FilesIntegrationGetRoomByShareTokenResponseApplicationJsonInterface,
        Built<FilesIntegrationGetRoomByShareTokenResponseApplicationJson,
            FilesIntegrationGetRoomByShareTokenResponseApplicationJsonBuilder> {
  factory FilesIntegrationGetRoomByShareTokenResponseApplicationJson([
    final void Function(FilesIntegrationGetRoomByShareTokenResponseApplicationJsonBuilder)? b,
  ]) = _$FilesIntegrationGetRoomByShareTokenResponseApplicationJson;

  // coverage:ignore-start
  const FilesIntegrationGetRoomByShareTokenResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory FilesIntegrationGetRoomByShareTokenResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<FilesIntegrationGetRoomByShareTokenResponseApplicationJson> get serializer =>
      _$filesIntegrationGetRoomByShareTokenResponseApplicationJsonSerializer;
}

class GuestSetDisplayNameApiVersion extends EnumClass {
  const GuestSetDisplayNameApiVersion._(super.name);

  static const GuestSetDisplayNameApiVersion v1 = _$guestSetDisplayNameApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<GuestSetDisplayNameApiVersion> get values => _$guestSetDisplayNameApiVersionValues;
  // coverage:ignore-end
  static GuestSetDisplayNameApiVersion valueOf(final String name) => _$valueOfGuestSetDisplayNameApiVersion(name);
  static Serializer<GuestSetDisplayNameApiVersion> get serializer => _$guestSetDisplayNameApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class GuestSetDisplayNameResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class GuestSetDisplayNameResponseApplicationJson_Ocs
    implements
        GuestSetDisplayNameResponseApplicationJson_OcsInterface,
        Built<GuestSetDisplayNameResponseApplicationJson_Ocs, GuestSetDisplayNameResponseApplicationJson_OcsBuilder> {
  factory GuestSetDisplayNameResponseApplicationJson_Ocs([
    final void Function(GuestSetDisplayNameResponseApplicationJson_OcsBuilder)? b,
  ]) = _$GuestSetDisplayNameResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const GuestSetDisplayNameResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory GuestSetDisplayNameResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<GuestSetDisplayNameResponseApplicationJson_Ocs> get serializer =>
      _$guestSetDisplayNameResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class GuestSetDisplayNameResponseApplicationJsonInterface {
  GuestSetDisplayNameResponseApplicationJson_Ocs get ocs;
}

abstract class GuestSetDisplayNameResponseApplicationJson
    implements
        GuestSetDisplayNameResponseApplicationJsonInterface,
        Built<GuestSetDisplayNameResponseApplicationJson, GuestSetDisplayNameResponseApplicationJsonBuilder> {
  factory GuestSetDisplayNameResponseApplicationJson([
    final void Function(GuestSetDisplayNameResponseApplicationJsonBuilder)? b,
  ]) = _$GuestSetDisplayNameResponseApplicationJson;

  // coverage:ignore-start
  const GuestSetDisplayNameResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory GuestSetDisplayNameResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<GuestSetDisplayNameResponseApplicationJson> get serializer =>
      _$guestSetDisplayNameResponseApplicationJsonSerializer;
}

class HostedSignalingServerRequestTrialApiVersion extends EnumClass {
  const HostedSignalingServerRequestTrialApiVersion._(super.name);

  static const HostedSignalingServerRequestTrialApiVersion v1 = _$hostedSignalingServerRequestTrialApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<HostedSignalingServerRequestTrialApiVersion> get values =>
      _$hostedSignalingServerRequestTrialApiVersionValues;
  // coverage:ignore-end
  static HostedSignalingServerRequestTrialApiVersion valueOf(final String name) =>
      _$valueOfHostedSignalingServerRequestTrialApiVersion(name);
  static Serializer<HostedSignalingServerRequestTrialApiVersion> get serializer =>
      _$hostedSignalingServerRequestTrialApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class HostedSignalingServerRequestTrialResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  BuiltMap<String, JsonObject> get data;
}

abstract class HostedSignalingServerRequestTrialResponseApplicationJson_Ocs
    implements
        HostedSignalingServerRequestTrialResponseApplicationJson_OcsInterface,
        Built<HostedSignalingServerRequestTrialResponseApplicationJson_Ocs,
            HostedSignalingServerRequestTrialResponseApplicationJson_OcsBuilder> {
  factory HostedSignalingServerRequestTrialResponseApplicationJson_Ocs([
    final void Function(HostedSignalingServerRequestTrialResponseApplicationJson_OcsBuilder)? b,
  ]) = _$HostedSignalingServerRequestTrialResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const HostedSignalingServerRequestTrialResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory HostedSignalingServerRequestTrialResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<HostedSignalingServerRequestTrialResponseApplicationJson_Ocs> get serializer =>
      _$hostedSignalingServerRequestTrialResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class HostedSignalingServerRequestTrialResponseApplicationJsonInterface {
  HostedSignalingServerRequestTrialResponseApplicationJson_Ocs get ocs;
}

abstract class HostedSignalingServerRequestTrialResponseApplicationJson
    implements
        HostedSignalingServerRequestTrialResponseApplicationJsonInterface,
        Built<HostedSignalingServerRequestTrialResponseApplicationJson,
            HostedSignalingServerRequestTrialResponseApplicationJsonBuilder> {
  factory HostedSignalingServerRequestTrialResponseApplicationJson([
    final void Function(HostedSignalingServerRequestTrialResponseApplicationJsonBuilder)? b,
  ]) = _$HostedSignalingServerRequestTrialResponseApplicationJson;

  // coverage:ignore-start
  const HostedSignalingServerRequestTrialResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory HostedSignalingServerRequestTrialResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<HostedSignalingServerRequestTrialResponseApplicationJson> get serializer =>
      _$hostedSignalingServerRequestTrialResponseApplicationJsonSerializer;
}

class HostedSignalingServerDeleteAccountApiVersion extends EnumClass {
  const HostedSignalingServerDeleteAccountApiVersion._(super.name);

  static const HostedSignalingServerDeleteAccountApiVersion v1 = _$hostedSignalingServerDeleteAccountApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<HostedSignalingServerDeleteAccountApiVersion> get values =>
      _$hostedSignalingServerDeleteAccountApiVersionValues;
  // coverage:ignore-end
  static HostedSignalingServerDeleteAccountApiVersion valueOf(final String name) =>
      _$valueOfHostedSignalingServerDeleteAccountApiVersion(name);
  static Serializer<HostedSignalingServerDeleteAccountApiVersion> get serializer =>
      _$hostedSignalingServerDeleteAccountApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class HostedSignalingServerDeleteAccountResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class HostedSignalingServerDeleteAccountResponseApplicationJson_Ocs
    implements
        HostedSignalingServerDeleteAccountResponseApplicationJson_OcsInterface,
        Built<HostedSignalingServerDeleteAccountResponseApplicationJson_Ocs,
            HostedSignalingServerDeleteAccountResponseApplicationJson_OcsBuilder> {
  factory HostedSignalingServerDeleteAccountResponseApplicationJson_Ocs([
    final void Function(HostedSignalingServerDeleteAccountResponseApplicationJson_OcsBuilder)? b,
  ]) = _$HostedSignalingServerDeleteAccountResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const HostedSignalingServerDeleteAccountResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory HostedSignalingServerDeleteAccountResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<HostedSignalingServerDeleteAccountResponseApplicationJson_Ocs> get serializer =>
      _$hostedSignalingServerDeleteAccountResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class HostedSignalingServerDeleteAccountResponseApplicationJsonInterface {
  HostedSignalingServerDeleteAccountResponseApplicationJson_Ocs get ocs;
}

abstract class HostedSignalingServerDeleteAccountResponseApplicationJson
    implements
        HostedSignalingServerDeleteAccountResponseApplicationJsonInterface,
        Built<HostedSignalingServerDeleteAccountResponseApplicationJson,
            HostedSignalingServerDeleteAccountResponseApplicationJsonBuilder> {
  factory HostedSignalingServerDeleteAccountResponseApplicationJson([
    final void Function(HostedSignalingServerDeleteAccountResponseApplicationJsonBuilder)? b,
  ]) = _$HostedSignalingServerDeleteAccountResponseApplicationJson;

  // coverage:ignore-start
  const HostedSignalingServerDeleteAccountResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory HostedSignalingServerDeleteAccountResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<HostedSignalingServerDeleteAccountResponseApplicationJson> get serializer =>
      _$hostedSignalingServerDeleteAccountResponseApplicationJsonSerializer;
}

class MatterbridgeGetBridgeOfRoomApiVersion extends EnumClass {
  const MatterbridgeGetBridgeOfRoomApiVersion._(super.name);

  static const MatterbridgeGetBridgeOfRoomApiVersion v1 = _$matterbridgeGetBridgeOfRoomApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<MatterbridgeGetBridgeOfRoomApiVersion> get values => _$matterbridgeGetBridgeOfRoomApiVersionValues;
  // coverage:ignore-end
  static MatterbridgeGetBridgeOfRoomApiVersion valueOf(final String name) =>
      _$valueOfMatterbridgeGetBridgeOfRoomApiVersion(name);
  static Serializer<MatterbridgeGetBridgeOfRoomApiVersion> get serializer =>
      _$matterbridgeGetBridgeOfRoomApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class MatterbridgeInterface {
  bool get enabled;
  BuiltList<BuiltMap<String, JsonObject>> get parts;
  int get pid;
}

abstract class Matterbridge implements MatterbridgeInterface, Built<Matterbridge, MatterbridgeBuilder> {
  factory Matterbridge([final void Function(MatterbridgeBuilder)? b]) = _$Matterbridge;

  // coverage:ignore-start
  const Matterbridge._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory Matterbridge.fromJson(final Map<String, dynamic> json) => _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<Matterbridge> get serializer => _$matterbridgeSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class MatterbridgeProcessStateInterface {
  String get log;
  bool get running;
}

abstract class MatterbridgeProcessState
    implements MatterbridgeProcessStateInterface, Built<MatterbridgeProcessState, MatterbridgeProcessStateBuilder> {
  factory MatterbridgeProcessState([final void Function(MatterbridgeProcessStateBuilder)? b]) =
      _$MatterbridgeProcessState;

  // coverage:ignore-start
  const MatterbridgeProcessState._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory MatterbridgeProcessState.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<MatterbridgeProcessState> get serializer => _$matterbridgeProcessStateSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class MatterbridgeWithProcessStateInterface
    implements MatterbridgeInterface, MatterbridgeProcessStateInterface {}

abstract class MatterbridgeWithProcessState
    implements
        MatterbridgeWithProcessStateInterface,
        Built<MatterbridgeWithProcessState, MatterbridgeWithProcessStateBuilder> {
  factory MatterbridgeWithProcessState([final void Function(MatterbridgeWithProcessStateBuilder)? b]) =
      _$MatterbridgeWithProcessState;

  // coverage:ignore-start
  const MatterbridgeWithProcessState._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory MatterbridgeWithProcessState.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<MatterbridgeWithProcessState> get serializer => _$matterbridgeWithProcessStateSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class MatterbridgeGetBridgeOfRoomResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  MatterbridgeWithProcessState get data;
}

abstract class MatterbridgeGetBridgeOfRoomResponseApplicationJson_Ocs
    implements
        MatterbridgeGetBridgeOfRoomResponseApplicationJson_OcsInterface,
        Built<MatterbridgeGetBridgeOfRoomResponseApplicationJson_Ocs,
            MatterbridgeGetBridgeOfRoomResponseApplicationJson_OcsBuilder> {
  factory MatterbridgeGetBridgeOfRoomResponseApplicationJson_Ocs([
    final void Function(MatterbridgeGetBridgeOfRoomResponseApplicationJson_OcsBuilder)? b,
  ]) = _$MatterbridgeGetBridgeOfRoomResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const MatterbridgeGetBridgeOfRoomResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory MatterbridgeGetBridgeOfRoomResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<MatterbridgeGetBridgeOfRoomResponseApplicationJson_Ocs> get serializer =>
      _$matterbridgeGetBridgeOfRoomResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class MatterbridgeGetBridgeOfRoomResponseApplicationJsonInterface {
  MatterbridgeGetBridgeOfRoomResponseApplicationJson_Ocs get ocs;
}

abstract class MatterbridgeGetBridgeOfRoomResponseApplicationJson
    implements
        MatterbridgeGetBridgeOfRoomResponseApplicationJsonInterface,
        Built<MatterbridgeGetBridgeOfRoomResponseApplicationJson,
            MatterbridgeGetBridgeOfRoomResponseApplicationJsonBuilder> {
  factory MatterbridgeGetBridgeOfRoomResponseApplicationJson([
    final void Function(MatterbridgeGetBridgeOfRoomResponseApplicationJsonBuilder)? b,
  ]) = _$MatterbridgeGetBridgeOfRoomResponseApplicationJson;

  // coverage:ignore-start
  const MatterbridgeGetBridgeOfRoomResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory MatterbridgeGetBridgeOfRoomResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<MatterbridgeGetBridgeOfRoomResponseApplicationJson> get serializer =>
      _$matterbridgeGetBridgeOfRoomResponseApplicationJsonSerializer;
}

class MatterbridgeEditBridgeOfRoomApiVersion extends EnumClass {
  const MatterbridgeEditBridgeOfRoomApiVersion._(super.name);

  static const MatterbridgeEditBridgeOfRoomApiVersion v1 = _$matterbridgeEditBridgeOfRoomApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<MatterbridgeEditBridgeOfRoomApiVersion> get values => _$matterbridgeEditBridgeOfRoomApiVersionValues;
  // coverage:ignore-end
  static MatterbridgeEditBridgeOfRoomApiVersion valueOf(final String name) =>
      _$valueOfMatterbridgeEditBridgeOfRoomApiVersion(name);
  static Serializer<MatterbridgeEditBridgeOfRoomApiVersion> get serializer =>
      _$matterbridgeEditBridgeOfRoomApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class MatterbridgeEditBridgeOfRoomResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  MatterbridgeProcessState get data;
}

abstract class MatterbridgeEditBridgeOfRoomResponseApplicationJson_Ocs
    implements
        MatterbridgeEditBridgeOfRoomResponseApplicationJson_OcsInterface,
        Built<MatterbridgeEditBridgeOfRoomResponseApplicationJson_Ocs,
            MatterbridgeEditBridgeOfRoomResponseApplicationJson_OcsBuilder> {
  factory MatterbridgeEditBridgeOfRoomResponseApplicationJson_Ocs([
    final void Function(MatterbridgeEditBridgeOfRoomResponseApplicationJson_OcsBuilder)? b,
  ]) = _$MatterbridgeEditBridgeOfRoomResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const MatterbridgeEditBridgeOfRoomResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory MatterbridgeEditBridgeOfRoomResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<MatterbridgeEditBridgeOfRoomResponseApplicationJson_Ocs> get serializer =>
      _$matterbridgeEditBridgeOfRoomResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class MatterbridgeEditBridgeOfRoomResponseApplicationJsonInterface {
  MatterbridgeEditBridgeOfRoomResponseApplicationJson_Ocs get ocs;
}

abstract class MatterbridgeEditBridgeOfRoomResponseApplicationJson
    implements
        MatterbridgeEditBridgeOfRoomResponseApplicationJsonInterface,
        Built<MatterbridgeEditBridgeOfRoomResponseApplicationJson,
            MatterbridgeEditBridgeOfRoomResponseApplicationJsonBuilder> {
  factory MatterbridgeEditBridgeOfRoomResponseApplicationJson([
    final void Function(MatterbridgeEditBridgeOfRoomResponseApplicationJsonBuilder)? b,
  ]) = _$MatterbridgeEditBridgeOfRoomResponseApplicationJson;

  // coverage:ignore-start
  const MatterbridgeEditBridgeOfRoomResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory MatterbridgeEditBridgeOfRoomResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<MatterbridgeEditBridgeOfRoomResponseApplicationJson> get serializer =>
      _$matterbridgeEditBridgeOfRoomResponseApplicationJsonSerializer;
}

class MatterbridgeDeleteBridgeOfRoomApiVersion extends EnumClass {
  const MatterbridgeDeleteBridgeOfRoomApiVersion._(super.name);

  static const MatterbridgeDeleteBridgeOfRoomApiVersion v1 = _$matterbridgeDeleteBridgeOfRoomApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<MatterbridgeDeleteBridgeOfRoomApiVersion> get values =>
      _$matterbridgeDeleteBridgeOfRoomApiVersionValues;
  // coverage:ignore-end
  static MatterbridgeDeleteBridgeOfRoomApiVersion valueOf(final String name) =>
      _$valueOfMatterbridgeDeleteBridgeOfRoomApiVersion(name);
  static Serializer<MatterbridgeDeleteBridgeOfRoomApiVersion> get serializer =>
      _$matterbridgeDeleteBridgeOfRoomApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class MatterbridgeDeleteBridgeOfRoomResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  bool get data;
}

abstract class MatterbridgeDeleteBridgeOfRoomResponseApplicationJson_Ocs
    implements
        MatterbridgeDeleteBridgeOfRoomResponseApplicationJson_OcsInterface,
        Built<MatterbridgeDeleteBridgeOfRoomResponseApplicationJson_Ocs,
            MatterbridgeDeleteBridgeOfRoomResponseApplicationJson_OcsBuilder> {
  factory MatterbridgeDeleteBridgeOfRoomResponseApplicationJson_Ocs([
    final void Function(MatterbridgeDeleteBridgeOfRoomResponseApplicationJson_OcsBuilder)? b,
  ]) = _$MatterbridgeDeleteBridgeOfRoomResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const MatterbridgeDeleteBridgeOfRoomResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory MatterbridgeDeleteBridgeOfRoomResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<MatterbridgeDeleteBridgeOfRoomResponseApplicationJson_Ocs> get serializer =>
      _$matterbridgeDeleteBridgeOfRoomResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class MatterbridgeDeleteBridgeOfRoomResponseApplicationJsonInterface {
  MatterbridgeDeleteBridgeOfRoomResponseApplicationJson_Ocs get ocs;
}

abstract class MatterbridgeDeleteBridgeOfRoomResponseApplicationJson
    implements
        MatterbridgeDeleteBridgeOfRoomResponseApplicationJsonInterface,
        Built<MatterbridgeDeleteBridgeOfRoomResponseApplicationJson,
            MatterbridgeDeleteBridgeOfRoomResponseApplicationJsonBuilder> {
  factory MatterbridgeDeleteBridgeOfRoomResponseApplicationJson([
    final void Function(MatterbridgeDeleteBridgeOfRoomResponseApplicationJsonBuilder)? b,
  ]) = _$MatterbridgeDeleteBridgeOfRoomResponseApplicationJson;

  // coverage:ignore-start
  const MatterbridgeDeleteBridgeOfRoomResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory MatterbridgeDeleteBridgeOfRoomResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<MatterbridgeDeleteBridgeOfRoomResponseApplicationJson> get serializer =>
      _$matterbridgeDeleteBridgeOfRoomResponseApplicationJsonSerializer;
}

class MatterbridgeGetBridgeProcessStateApiVersion extends EnumClass {
  const MatterbridgeGetBridgeProcessStateApiVersion._(super.name);

  static const MatterbridgeGetBridgeProcessStateApiVersion v1 = _$matterbridgeGetBridgeProcessStateApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<MatterbridgeGetBridgeProcessStateApiVersion> get values =>
      _$matterbridgeGetBridgeProcessStateApiVersionValues;
  // coverage:ignore-end
  static MatterbridgeGetBridgeProcessStateApiVersion valueOf(final String name) =>
      _$valueOfMatterbridgeGetBridgeProcessStateApiVersion(name);
  static Serializer<MatterbridgeGetBridgeProcessStateApiVersion> get serializer =>
      _$matterbridgeGetBridgeProcessStateApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class MatterbridgeGetBridgeProcessStateResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  MatterbridgeProcessState get data;
}

abstract class MatterbridgeGetBridgeProcessStateResponseApplicationJson_Ocs
    implements
        MatterbridgeGetBridgeProcessStateResponseApplicationJson_OcsInterface,
        Built<MatterbridgeGetBridgeProcessStateResponseApplicationJson_Ocs,
            MatterbridgeGetBridgeProcessStateResponseApplicationJson_OcsBuilder> {
  factory MatterbridgeGetBridgeProcessStateResponseApplicationJson_Ocs([
    final void Function(MatterbridgeGetBridgeProcessStateResponseApplicationJson_OcsBuilder)? b,
  ]) = _$MatterbridgeGetBridgeProcessStateResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const MatterbridgeGetBridgeProcessStateResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory MatterbridgeGetBridgeProcessStateResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<MatterbridgeGetBridgeProcessStateResponseApplicationJson_Ocs> get serializer =>
      _$matterbridgeGetBridgeProcessStateResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class MatterbridgeGetBridgeProcessStateResponseApplicationJsonInterface {
  MatterbridgeGetBridgeProcessStateResponseApplicationJson_Ocs get ocs;
}

abstract class MatterbridgeGetBridgeProcessStateResponseApplicationJson
    implements
        MatterbridgeGetBridgeProcessStateResponseApplicationJsonInterface,
        Built<MatterbridgeGetBridgeProcessStateResponseApplicationJson,
            MatterbridgeGetBridgeProcessStateResponseApplicationJsonBuilder> {
  factory MatterbridgeGetBridgeProcessStateResponseApplicationJson([
    final void Function(MatterbridgeGetBridgeProcessStateResponseApplicationJsonBuilder)? b,
  ]) = _$MatterbridgeGetBridgeProcessStateResponseApplicationJson;

  // coverage:ignore-start
  const MatterbridgeGetBridgeProcessStateResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory MatterbridgeGetBridgeProcessStateResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<MatterbridgeGetBridgeProcessStateResponseApplicationJson> get serializer =>
      _$matterbridgeGetBridgeProcessStateResponseApplicationJsonSerializer;
}

class MatterbridgeSettingsStopAllBridgesApiVersion extends EnumClass {
  const MatterbridgeSettingsStopAllBridgesApiVersion._(super.name);

  static const MatterbridgeSettingsStopAllBridgesApiVersion v1 = _$matterbridgeSettingsStopAllBridgesApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<MatterbridgeSettingsStopAllBridgesApiVersion> get values =>
      _$matterbridgeSettingsStopAllBridgesApiVersionValues;
  // coverage:ignore-end
  static MatterbridgeSettingsStopAllBridgesApiVersion valueOf(final String name) =>
      _$valueOfMatterbridgeSettingsStopAllBridgesApiVersion(name);
  static Serializer<MatterbridgeSettingsStopAllBridgesApiVersion> get serializer =>
      _$matterbridgeSettingsStopAllBridgesApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class MatterbridgeSettingsStopAllBridgesResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  bool get data;
}

abstract class MatterbridgeSettingsStopAllBridgesResponseApplicationJson_Ocs
    implements
        MatterbridgeSettingsStopAllBridgesResponseApplicationJson_OcsInterface,
        Built<MatterbridgeSettingsStopAllBridgesResponseApplicationJson_Ocs,
            MatterbridgeSettingsStopAllBridgesResponseApplicationJson_OcsBuilder> {
  factory MatterbridgeSettingsStopAllBridgesResponseApplicationJson_Ocs([
    final void Function(MatterbridgeSettingsStopAllBridgesResponseApplicationJson_OcsBuilder)? b,
  ]) = _$MatterbridgeSettingsStopAllBridgesResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const MatterbridgeSettingsStopAllBridgesResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory MatterbridgeSettingsStopAllBridgesResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<MatterbridgeSettingsStopAllBridgesResponseApplicationJson_Ocs> get serializer =>
      _$matterbridgeSettingsStopAllBridgesResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class MatterbridgeSettingsStopAllBridgesResponseApplicationJsonInterface {
  MatterbridgeSettingsStopAllBridgesResponseApplicationJson_Ocs get ocs;
}

abstract class MatterbridgeSettingsStopAllBridgesResponseApplicationJson
    implements
        MatterbridgeSettingsStopAllBridgesResponseApplicationJsonInterface,
        Built<MatterbridgeSettingsStopAllBridgesResponseApplicationJson,
            MatterbridgeSettingsStopAllBridgesResponseApplicationJsonBuilder> {
  factory MatterbridgeSettingsStopAllBridgesResponseApplicationJson([
    final void Function(MatterbridgeSettingsStopAllBridgesResponseApplicationJsonBuilder)? b,
  ]) = _$MatterbridgeSettingsStopAllBridgesResponseApplicationJson;

  // coverage:ignore-start
  const MatterbridgeSettingsStopAllBridgesResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory MatterbridgeSettingsStopAllBridgesResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<MatterbridgeSettingsStopAllBridgesResponseApplicationJson> get serializer =>
      _$matterbridgeSettingsStopAllBridgesResponseApplicationJsonSerializer;
}

class MatterbridgeSettingsGetMatterbridgeVersionApiVersion extends EnumClass {
  const MatterbridgeSettingsGetMatterbridgeVersionApiVersion._(super.name);

  static const MatterbridgeSettingsGetMatterbridgeVersionApiVersion v1 =
      _$matterbridgeSettingsGetMatterbridgeVersionApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<MatterbridgeSettingsGetMatterbridgeVersionApiVersion> get values =>
      _$matterbridgeSettingsGetMatterbridgeVersionApiVersionValues;
  // coverage:ignore-end
  static MatterbridgeSettingsGetMatterbridgeVersionApiVersion valueOf(final String name) =>
      _$valueOfMatterbridgeSettingsGetMatterbridgeVersionApiVersion(name);
  static Serializer<MatterbridgeSettingsGetMatterbridgeVersionApiVersion> get serializer =>
      _$matterbridgeSettingsGetMatterbridgeVersionApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson_Ocs_DataInterface {
  String get version;
}

abstract class MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson_Ocs_Data
    implements
        MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson_Ocs_DataInterface,
        Built<MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson_Ocs_Data,
            MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson_Ocs_DataBuilder> {
  factory MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson_Ocs_Data([
    final void Function(MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson_Ocs_DataBuilder)? b,
  ]) = _$MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson_Ocs_Data;

  // coverage:ignore-start
  const MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson_Ocs_Data._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson_Ocs_Data.fromJson(
    final Map<String, dynamic> json,
  ) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson_Ocs_Data> get serializer =>
      _$matterbridgeSettingsGetMatterbridgeVersionResponseApplicationJsonOcsDataSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson_Ocs_Data get data;
}

abstract class MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson_Ocs
    implements
        MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson_OcsInterface,
        Built<MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson_Ocs,
            MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson_OcsBuilder> {
  factory MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson_Ocs([
    final void Function(MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson_OcsBuilder)? b,
  ]) = _$MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson_Ocs.fromJson(
    final Map<String, dynamic> json,
  ) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson_Ocs> get serializer =>
      _$matterbridgeSettingsGetMatterbridgeVersionResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJsonInterface {
  MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson_Ocs get ocs;
}

abstract class MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson
    implements
        MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJsonInterface,
        Built<MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson,
            MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJsonBuilder> {
  factory MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson([
    final void Function(MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJsonBuilder)? b,
  ]) = _$MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson;

  // coverage:ignore-start
  const MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson> get serializer =>
      _$matterbridgeSettingsGetMatterbridgeVersionResponseApplicationJsonSerializer;
}

class PollCreatePollApiVersion extends EnumClass {
  const PollCreatePollApiVersion._(super.name);

  static const PollCreatePollApiVersion v1 = _$pollCreatePollApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<PollCreatePollApiVersion> get values => _$pollCreatePollApiVersionValues;
  // coverage:ignore-end
  static PollCreatePollApiVersion valueOf(final String name) => _$valueOfPollCreatePollApiVersion(name);
  static Serializer<PollCreatePollApiVersion> get serializer => _$pollCreatePollApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class PollVoteInterface {
  String get actorDisplayName;
  String get actorId;
  String get actorType;
  int get optionId;
}

abstract class PollVote implements PollVoteInterface, Built<PollVote, PollVoteBuilder> {
  factory PollVote([final void Function(PollVoteBuilder)? b]) = _$PollVote;

  // coverage:ignore-start
  const PollVote._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory PollVote.fromJson(final Map<String, dynamic> json) => _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<PollVote> get serializer => _$pollVoteSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class PollInterface {
  String get actorDisplayName;
  String get actorId;
  String get actorType;
  BuiltList<PollVote>? get details;
  int get id;
  int get maxVotes;
  int? get numVoters;
  BuiltList<String> get options;
  String get question;
  int get resultMode;
  int get status;
  BuiltList<int>? get votedSelf;
  BuiltMap<String, int>? get votes;
}

abstract class Poll implements PollInterface, Built<Poll, PollBuilder> {
  factory Poll([final void Function(PollBuilder)? b]) = _$Poll;

  // coverage:ignore-start
  const Poll._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory Poll.fromJson(final Map<String, dynamic> json) => _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<Poll> get serializer => _$pollSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class PollCreatePollResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  Poll get data;
}

abstract class PollCreatePollResponseApplicationJson_Ocs
    implements
        PollCreatePollResponseApplicationJson_OcsInterface,
        Built<PollCreatePollResponseApplicationJson_Ocs, PollCreatePollResponseApplicationJson_OcsBuilder> {
  factory PollCreatePollResponseApplicationJson_Ocs([
    final void Function(PollCreatePollResponseApplicationJson_OcsBuilder)? b,
  ]) = _$PollCreatePollResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const PollCreatePollResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory PollCreatePollResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<PollCreatePollResponseApplicationJson_Ocs> get serializer =>
      _$pollCreatePollResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class PollCreatePollResponseApplicationJsonInterface {
  PollCreatePollResponseApplicationJson_Ocs get ocs;
}

abstract class PollCreatePollResponseApplicationJson
    implements
        PollCreatePollResponseApplicationJsonInterface,
        Built<PollCreatePollResponseApplicationJson, PollCreatePollResponseApplicationJsonBuilder> {
  factory PollCreatePollResponseApplicationJson([
    final void Function(PollCreatePollResponseApplicationJsonBuilder)? b,
  ]) = _$PollCreatePollResponseApplicationJson;

  // coverage:ignore-start
  const PollCreatePollResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory PollCreatePollResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<PollCreatePollResponseApplicationJson> get serializer =>
      _$pollCreatePollResponseApplicationJsonSerializer;
}

class PollShowPollApiVersion extends EnumClass {
  const PollShowPollApiVersion._(super.name);

  static const PollShowPollApiVersion v1 = _$pollShowPollApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<PollShowPollApiVersion> get values => _$pollShowPollApiVersionValues;
  // coverage:ignore-end
  static PollShowPollApiVersion valueOf(final String name) => _$valueOfPollShowPollApiVersion(name);
  static Serializer<PollShowPollApiVersion> get serializer => _$pollShowPollApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class PollShowPollResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  Poll get data;
}

abstract class PollShowPollResponseApplicationJson_Ocs
    implements
        PollShowPollResponseApplicationJson_OcsInterface,
        Built<PollShowPollResponseApplicationJson_Ocs, PollShowPollResponseApplicationJson_OcsBuilder> {
  factory PollShowPollResponseApplicationJson_Ocs([
    final void Function(PollShowPollResponseApplicationJson_OcsBuilder)? b,
  ]) = _$PollShowPollResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const PollShowPollResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory PollShowPollResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<PollShowPollResponseApplicationJson_Ocs> get serializer =>
      _$pollShowPollResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class PollShowPollResponseApplicationJsonInterface {
  PollShowPollResponseApplicationJson_Ocs get ocs;
}

abstract class PollShowPollResponseApplicationJson
    implements
        PollShowPollResponseApplicationJsonInterface,
        Built<PollShowPollResponseApplicationJson, PollShowPollResponseApplicationJsonBuilder> {
  factory PollShowPollResponseApplicationJson([final void Function(PollShowPollResponseApplicationJsonBuilder)? b]) =
      _$PollShowPollResponseApplicationJson;

  // coverage:ignore-start
  const PollShowPollResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory PollShowPollResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<PollShowPollResponseApplicationJson> get serializer =>
      _$pollShowPollResponseApplicationJsonSerializer;
}

class PollVotePollApiVersion extends EnumClass {
  const PollVotePollApiVersion._(super.name);

  static const PollVotePollApiVersion v1 = _$pollVotePollApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<PollVotePollApiVersion> get values => _$pollVotePollApiVersionValues;
  // coverage:ignore-end
  static PollVotePollApiVersion valueOf(final String name) => _$valueOfPollVotePollApiVersion(name);
  static Serializer<PollVotePollApiVersion> get serializer => _$pollVotePollApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class PollVotePollResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  Poll get data;
}

abstract class PollVotePollResponseApplicationJson_Ocs
    implements
        PollVotePollResponseApplicationJson_OcsInterface,
        Built<PollVotePollResponseApplicationJson_Ocs, PollVotePollResponseApplicationJson_OcsBuilder> {
  factory PollVotePollResponseApplicationJson_Ocs([
    final void Function(PollVotePollResponseApplicationJson_OcsBuilder)? b,
  ]) = _$PollVotePollResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const PollVotePollResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory PollVotePollResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<PollVotePollResponseApplicationJson_Ocs> get serializer =>
      _$pollVotePollResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class PollVotePollResponseApplicationJsonInterface {
  PollVotePollResponseApplicationJson_Ocs get ocs;
}

abstract class PollVotePollResponseApplicationJson
    implements
        PollVotePollResponseApplicationJsonInterface,
        Built<PollVotePollResponseApplicationJson, PollVotePollResponseApplicationJsonBuilder> {
  factory PollVotePollResponseApplicationJson([final void Function(PollVotePollResponseApplicationJsonBuilder)? b]) =
      _$PollVotePollResponseApplicationJson;

  // coverage:ignore-start
  const PollVotePollResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory PollVotePollResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<PollVotePollResponseApplicationJson> get serializer =>
      _$pollVotePollResponseApplicationJsonSerializer;
}

class PollClosePollApiVersion extends EnumClass {
  const PollClosePollApiVersion._(super.name);

  static const PollClosePollApiVersion v1 = _$pollClosePollApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<PollClosePollApiVersion> get values => _$pollClosePollApiVersionValues;
  // coverage:ignore-end
  static PollClosePollApiVersion valueOf(final String name) => _$valueOfPollClosePollApiVersion(name);
  static Serializer<PollClosePollApiVersion> get serializer => _$pollClosePollApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class PollClosePollResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  Poll get data;
}

abstract class PollClosePollResponseApplicationJson_Ocs
    implements
        PollClosePollResponseApplicationJson_OcsInterface,
        Built<PollClosePollResponseApplicationJson_Ocs, PollClosePollResponseApplicationJson_OcsBuilder> {
  factory PollClosePollResponseApplicationJson_Ocs([
    final void Function(PollClosePollResponseApplicationJson_OcsBuilder)? b,
  ]) = _$PollClosePollResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const PollClosePollResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory PollClosePollResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<PollClosePollResponseApplicationJson_Ocs> get serializer =>
      _$pollClosePollResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class PollClosePollResponseApplicationJsonInterface {
  PollClosePollResponseApplicationJson_Ocs get ocs;
}

abstract class PollClosePollResponseApplicationJson
    implements
        PollClosePollResponseApplicationJsonInterface,
        Built<PollClosePollResponseApplicationJson, PollClosePollResponseApplicationJsonBuilder> {
  factory PollClosePollResponseApplicationJson([final void Function(PollClosePollResponseApplicationJsonBuilder)? b]) =
      _$PollClosePollResponseApplicationJson;

  // coverage:ignore-start
  const PollClosePollResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory PollClosePollResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<PollClosePollResponseApplicationJson> get serializer =>
      _$pollClosePollResponseApplicationJsonSerializer;
}

class PublicShareAuthCreateRoomApiVersion extends EnumClass {
  const PublicShareAuthCreateRoomApiVersion._(super.name);

  static const PublicShareAuthCreateRoomApiVersion v1 = _$publicShareAuthCreateRoomApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<PublicShareAuthCreateRoomApiVersion> get values => _$publicShareAuthCreateRoomApiVersionValues;
  // coverage:ignore-end
  static PublicShareAuthCreateRoomApiVersion valueOf(final String name) =>
      _$valueOfPublicShareAuthCreateRoomApiVersion(name);
  static Serializer<PublicShareAuthCreateRoomApiVersion> get serializer =>
      _$publicShareAuthCreateRoomApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class PublicShareAuthCreateRoomResponseApplicationJson_Ocs_DataInterface {
  String get token;
  String get name;
  String get displayName;
}

abstract class PublicShareAuthCreateRoomResponseApplicationJson_Ocs_Data
    implements
        PublicShareAuthCreateRoomResponseApplicationJson_Ocs_DataInterface,
        Built<PublicShareAuthCreateRoomResponseApplicationJson_Ocs_Data,
            PublicShareAuthCreateRoomResponseApplicationJson_Ocs_DataBuilder> {
  factory PublicShareAuthCreateRoomResponseApplicationJson_Ocs_Data([
    final void Function(PublicShareAuthCreateRoomResponseApplicationJson_Ocs_DataBuilder)? b,
  ]) = _$PublicShareAuthCreateRoomResponseApplicationJson_Ocs_Data;

  // coverage:ignore-start
  const PublicShareAuthCreateRoomResponseApplicationJson_Ocs_Data._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory PublicShareAuthCreateRoomResponseApplicationJson_Ocs_Data.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<PublicShareAuthCreateRoomResponseApplicationJson_Ocs_Data> get serializer =>
      _$publicShareAuthCreateRoomResponseApplicationJsonOcsDataSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class PublicShareAuthCreateRoomResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  PublicShareAuthCreateRoomResponseApplicationJson_Ocs_Data get data;
}

abstract class PublicShareAuthCreateRoomResponseApplicationJson_Ocs
    implements
        PublicShareAuthCreateRoomResponseApplicationJson_OcsInterface,
        Built<PublicShareAuthCreateRoomResponseApplicationJson_Ocs,
            PublicShareAuthCreateRoomResponseApplicationJson_OcsBuilder> {
  factory PublicShareAuthCreateRoomResponseApplicationJson_Ocs([
    final void Function(PublicShareAuthCreateRoomResponseApplicationJson_OcsBuilder)? b,
  ]) = _$PublicShareAuthCreateRoomResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const PublicShareAuthCreateRoomResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory PublicShareAuthCreateRoomResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<PublicShareAuthCreateRoomResponseApplicationJson_Ocs> get serializer =>
      _$publicShareAuthCreateRoomResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class PublicShareAuthCreateRoomResponseApplicationJsonInterface {
  PublicShareAuthCreateRoomResponseApplicationJson_Ocs get ocs;
}

abstract class PublicShareAuthCreateRoomResponseApplicationJson
    implements
        PublicShareAuthCreateRoomResponseApplicationJsonInterface,
        Built<PublicShareAuthCreateRoomResponseApplicationJson,
            PublicShareAuthCreateRoomResponseApplicationJsonBuilder> {
  factory PublicShareAuthCreateRoomResponseApplicationJson([
    final void Function(PublicShareAuthCreateRoomResponseApplicationJsonBuilder)? b,
  ]) = _$PublicShareAuthCreateRoomResponseApplicationJson;

  // coverage:ignore-start
  const PublicShareAuthCreateRoomResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory PublicShareAuthCreateRoomResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<PublicShareAuthCreateRoomResponseApplicationJson> get serializer =>
      _$publicShareAuthCreateRoomResponseApplicationJsonSerializer;
}

class ReactionGetReactionsApiVersion extends EnumClass {
  const ReactionGetReactionsApiVersion._(super.name);

  static const ReactionGetReactionsApiVersion v1 = _$reactionGetReactionsApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<ReactionGetReactionsApiVersion> get values => _$reactionGetReactionsApiVersionValues;
  // coverage:ignore-end
  static ReactionGetReactionsApiVersion valueOf(final String name) => _$valueOfReactionGetReactionsApiVersion(name);
  static Serializer<ReactionGetReactionsApiVersion> get serializer => _$reactionGetReactionsApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ReactionInterface {
  String get actorDisplayName;
  String get actorId;
  String get actorType;
  int get timestamp;
}

abstract class Reaction implements ReactionInterface, Built<Reaction, ReactionBuilder> {
  factory Reaction([final void Function(ReactionBuilder)? b]) = _$Reaction;

  // coverage:ignore-start
  const Reaction._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory Reaction.fromJson(final Map<String, dynamic> json) => _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<Reaction> get serializer => _$reactionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ReactionGetReactionsResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  BuiltMap<String, BuiltList<Reaction>> get data;
}

abstract class ReactionGetReactionsResponseApplicationJson_Ocs
    implements
        ReactionGetReactionsResponseApplicationJson_OcsInterface,
        Built<ReactionGetReactionsResponseApplicationJson_Ocs, ReactionGetReactionsResponseApplicationJson_OcsBuilder> {
  factory ReactionGetReactionsResponseApplicationJson_Ocs([
    final void Function(ReactionGetReactionsResponseApplicationJson_OcsBuilder)? b,
  ]) = _$ReactionGetReactionsResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const ReactionGetReactionsResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ReactionGetReactionsResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ReactionGetReactionsResponseApplicationJson_Ocs> get serializer =>
      _$reactionGetReactionsResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ReactionGetReactionsResponseApplicationJsonInterface {
  ReactionGetReactionsResponseApplicationJson_Ocs get ocs;
}

abstract class ReactionGetReactionsResponseApplicationJson
    implements
        ReactionGetReactionsResponseApplicationJsonInterface,
        Built<ReactionGetReactionsResponseApplicationJson, ReactionGetReactionsResponseApplicationJsonBuilder> {
  factory ReactionGetReactionsResponseApplicationJson([
    final void Function(ReactionGetReactionsResponseApplicationJsonBuilder)? b,
  ]) = _$ReactionGetReactionsResponseApplicationJson;

  // coverage:ignore-start
  const ReactionGetReactionsResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ReactionGetReactionsResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ReactionGetReactionsResponseApplicationJson> get serializer =>
      _$reactionGetReactionsResponseApplicationJsonSerializer;
}

class ReactionReactApiVersion extends EnumClass {
  const ReactionReactApiVersion._(super.name);

  static const ReactionReactApiVersion v1 = _$reactionReactApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<ReactionReactApiVersion> get values => _$reactionReactApiVersionValues;
  // coverage:ignore-end
  static ReactionReactApiVersion valueOf(final String name) => _$valueOfReactionReactApiVersion(name);
  static Serializer<ReactionReactApiVersion> get serializer => _$reactionReactApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ReactionReactResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  BuiltMap<String, BuiltList<Reaction>> get data;
}

abstract class ReactionReactResponseApplicationJson_Ocs
    implements
        ReactionReactResponseApplicationJson_OcsInterface,
        Built<ReactionReactResponseApplicationJson_Ocs, ReactionReactResponseApplicationJson_OcsBuilder> {
  factory ReactionReactResponseApplicationJson_Ocs([
    final void Function(ReactionReactResponseApplicationJson_OcsBuilder)? b,
  ]) = _$ReactionReactResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const ReactionReactResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ReactionReactResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ReactionReactResponseApplicationJson_Ocs> get serializer =>
      _$reactionReactResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ReactionReactResponseApplicationJsonInterface {
  ReactionReactResponseApplicationJson_Ocs get ocs;
}

abstract class ReactionReactResponseApplicationJson
    implements
        ReactionReactResponseApplicationJsonInterface,
        Built<ReactionReactResponseApplicationJson, ReactionReactResponseApplicationJsonBuilder> {
  factory ReactionReactResponseApplicationJson([final void Function(ReactionReactResponseApplicationJsonBuilder)? b]) =
      _$ReactionReactResponseApplicationJson;

  // coverage:ignore-start
  const ReactionReactResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ReactionReactResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ReactionReactResponseApplicationJson> get serializer =>
      _$reactionReactResponseApplicationJsonSerializer;
}

class ReactionDeleteApiVersion extends EnumClass {
  const ReactionDeleteApiVersion._(super.name);

  static const ReactionDeleteApiVersion v1 = _$reactionDeleteApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<ReactionDeleteApiVersion> get values => _$reactionDeleteApiVersionValues;
  // coverage:ignore-end
  static ReactionDeleteApiVersion valueOf(final String name) => _$valueOfReactionDeleteApiVersion(name);
  static Serializer<ReactionDeleteApiVersion> get serializer => _$reactionDeleteApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ReactionDeleteResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  BuiltMap<String, BuiltList<Reaction>> get data;
}

abstract class ReactionDeleteResponseApplicationJson_Ocs
    implements
        ReactionDeleteResponseApplicationJson_OcsInterface,
        Built<ReactionDeleteResponseApplicationJson_Ocs, ReactionDeleteResponseApplicationJson_OcsBuilder> {
  factory ReactionDeleteResponseApplicationJson_Ocs([
    final void Function(ReactionDeleteResponseApplicationJson_OcsBuilder)? b,
  ]) = _$ReactionDeleteResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const ReactionDeleteResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ReactionDeleteResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ReactionDeleteResponseApplicationJson_Ocs> get serializer =>
      _$reactionDeleteResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class ReactionDeleteResponseApplicationJsonInterface {
  ReactionDeleteResponseApplicationJson_Ocs get ocs;
}

abstract class ReactionDeleteResponseApplicationJson
    implements
        ReactionDeleteResponseApplicationJsonInterface,
        Built<ReactionDeleteResponseApplicationJson, ReactionDeleteResponseApplicationJsonBuilder> {
  factory ReactionDeleteResponseApplicationJson([
    final void Function(ReactionDeleteResponseApplicationJsonBuilder)? b,
  ]) = _$ReactionDeleteResponseApplicationJson;

  // coverage:ignore-start
  const ReactionDeleteResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory ReactionDeleteResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<ReactionDeleteResponseApplicationJson> get serializer =>
      _$reactionDeleteResponseApplicationJsonSerializer;
}

class RecordingGetWelcomeMessageApiVersion extends EnumClass {
  const RecordingGetWelcomeMessageApiVersion._(super.name);

  static const RecordingGetWelcomeMessageApiVersion v1 = _$recordingGetWelcomeMessageApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<RecordingGetWelcomeMessageApiVersion> get values => _$recordingGetWelcomeMessageApiVersionValues;
  // coverage:ignore-end
  static RecordingGetWelcomeMessageApiVersion valueOf(final String name) =>
      _$valueOfRecordingGetWelcomeMessageApiVersion(name);
  static Serializer<RecordingGetWelcomeMessageApiVersion> get serializer =>
      _$recordingGetWelcomeMessageApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RecordingGetWelcomeMessageResponseApplicationJson_Ocs_DataInterface {
  double get version;
}

abstract class RecordingGetWelcomeMessageResponseApplicationJson_Ocs_Data
    implements
        RecordingGetWelcomeMessageResponseApplicationJson_Ocs_DataInterface,
        Built<RecordingGetWelcomeMessageResponseApplicationJson_Ocs_Data,
            RecordingGetWelcomeMessageResponseApplicationJson_Ocs_DataBuilder> {
  factory RecordingGetWelcomeMessageResponseApplicationJson_Ocs_Data([
    final void Function(RecordingGetWelcomeMessageResponseApplicationJson_Ocs_DataBuilder)? b,
  ]) = _$RecordingGetWelcomeMessageResponseApplicationJson_Ocs_Data;

  // coverage:ignore-start
  const RecordingGetWelcomeMessageResponseApplicationJson_Ocs_Data._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RecordingGetWelcomeMessageResponseApplicationJson_Ocs_Data.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RecordingGetWelcomeMessageResponseApplicationJson_Ocs_Data> get serializer =>
      _$recordingGetWelcomeMessageResponseApplicationJsonOcsDataSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RecordingGetWelcomeMessageResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  RecordingGetWelcomeMessageResponseApplicationJson_Ocs_Data get data;
}

abstract class RecordingGetWelcomeMessageResponseApplicationJson_Ocs
    implements
        RecordingGetWelcomeMessageResponseApplicationJson_OcsInterface,
        Built<RecordingGetWelcomeMessageResponseApplicationJson_Ocs,
            RecordingGetWelcomeMessageResponseApplicationJson_OcsBuilder> {
  factory RecordingGetWelcomeMessageResponseApplicationJson_Ocs([
    final void Function(RecordingGetWelcomeMessageResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RecordingGetWelcomeMessageResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RecordingGetWelcomeMessageResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RecordingGetWelcomeMessageResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RecordingGetWelcomeMessageResponseApplicationJson_Ocs> get serializer =>
      _$recordingGetWelcomeMessageResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RecordingGetWelcomeMessageResponseApplicationJsonInterface {
  RecordingGetWelcomeMessageResponseApplicationJson_Ocs get ocs;
}

abstract class RecordingGetWelcomeMessageResponseApplicationJson
    implements
        RecordingGetWelcomeMessageResponseApplicationJsonInterface,
        Built<RecordingGetWelcomeMessageResponseApplicationJson,
            RecordingGetWelcomeMessageResponseApplicationJsonBuilder> {
  factory RecordingGetWelcomeMessageResponseApplicationJson([
    final void Function(RecordingGetWelcomeMessageResponseApplicationJsonBuilder)? b,
  ]) = _$RecordingGetWelcomeMessageResponseApplicationJson;

  // coverage:ignore-start
  const RecordingGetWelcomeMessageResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RecordingGetWelcomeMessageResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RecordingGetWelcomeMessageResponseApplicationJson> get serializer =>
      _$recordingGetWelcomeMessageResponseApplicationJsonSerializer;
}

class RecordingStartApiVersion extends EnumClass {
  const RecordingStartApiVersion._(super.name);

  static const RecordingStartApiVersion v1 = _$recordingStartApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<RecordingStartApiVersion> get values => _$recordingStartApiVersionValues;
  // coverage:ignore-end
  static RecordingStartApiVersion valueOf(final String name) => _$valueOfRecordingStartApiVersion(name);
  static Serializer<RecordingStartApiVersion> get serializer => _$recordingStartApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RecordingStartResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class RecordingStartResponseApplicationJson_Ocs
    implements
        RecordingStartResponseApplicationJson_OcsInterface,
        Built<RecordingStartResponseApplicationJson_Ocs, RecordingStartResponseApplicationJson_OcsBuilder> {
  factory RecordingStartResponseApplicationJson_Ocs([
    final void Function(RecordingStartResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RecordingStartResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RecordingStartResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RecordingStartResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RecordingStartResponseApplicationJson_Ocs> get serializer =>
      _$recordingStartResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RecordingStartResponseApplicationJsonInterface {
  RecordingStartResponseApplicationJson_Ocs get ocs;
}

abstract class RecordingStartResponseApplicationJson
    implements
        RecordingStartResponseApplicationJsonInterface,
        Built<RecordingStartResponseApplicationJson, RecordingStartResponseApplicationJsonBuilder> {
  factory RecordingStartResponseApplicationJson([
    final void Function(RecordingStartResponseApplicationJsonBuilder)? b,
  ]) = _$RecordingStartResponseApplicationJson;

  // coverage:ignore-start
  const RecordingStartResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RecordingStartResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RecordingStartResponseApplicationJson> get serializer =>
      _$recordingStartResponseApplicationJsonSerializer;
}

class RecordingStopApiVersion extends EnumClass {
  const RecordingStopApiVersion._(super.name);

  static const RecordingStopApiVersion v1 = _$recordingStopApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<RecordingStopApiVersion> get values => _$recordingStopApiVersionValues;
  // coverage:ignore-end
  static RecordingStopApiVersion valueOf(final String name) => _$valueOfRecordingStopApiVersion(name);
  static Serializer<RecordingStopApiVersion> get serializer => _$recordingStopApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RecordingStopResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class RecordingStopResponseApplicationJson_Ocs
    implements
        RecordingStopResponseApplicationJson_OcsInterface,
        Built<RecordingStopResponseApplicationJson_Ocs, RecordingStopResponseApplicationJson_OcsBuilder> {
  factory RecordingStopResponseApplicationJson_Ocs([
    final void Function(RecordingStopResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RecordingStopResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RecordingStopResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RecordingStopResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RecordingStopResponseApplicationJson_Ocs> get serializer =>
      _$recordingStopResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RecordingStopResponseApplicationJsonInterface {
  RecordingStopResponseApplicationJson_Ocs get ocs;
}

abstract class RecordingStopResponseApplicationJson
    implements
        RecordingStopResponseApplicationJsonInterface,
        Built<RecordingStopResponseApplicationJson, RecordingStopResponseApplicationJsonBuilder> {
  factory RecordingStopResponseApplicationJson([final void Function(RecordingStopResponseApplicationJsonBuilder)? b]) =
      _$RecordingStopResponseApplicationJson;

  // coverage:ignore-start
  const RecordingStopResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RecordingStopResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RecordingStopResponseApplicationJson> get serializer =>
      _$recordingStopResponseApplicationJsonSerializer;
}

class RecordingStoreApiVersion extends EnumClass {
  const RecordingStoreApiVersion._(super.name);

  static const RecordingStoreApiVersion v1 = _$recordingStoreApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<RecordingStoreApiVersion> get values => _$recordingStoreApiVersionValues;
  // coverage:ignore-end
  static RecordingStoreApiVersion valueOf(final String name) => _$valueOfRecordingStoreApiVersion(name);
  static Serializer<RecordingStoreApiVersion> get serializer => _$recordingStoreApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RecordingStoreResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class RecordingStoreResponseApplicationJson_Ocs
    implements
        RecordingStoreResponseApplicationJson_OcsInterface,
        Built<RecordingStoreResponseApplicationJson_Ocs, RecordingStoreResponseApplicationJson_OcsBuilder> {
  factory RecordingStoreResponseApplicationJson_Ocs([
    final void Function(RecordingStoreResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RecordingStoreResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RecordingStoreResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RecordingStoreResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RecordingStoreResponseApplicationJson_Ocs> get serializer =>
      _$recordingStoreResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RecordingStoreResponseApplicationJsonInterface {
  RecordingStoreResponseApplicationJson_Ocs get ocs;
}

abstract class RecordingStoreResponseApplicationJson
    implements
        RecordingStoreResponseApplicationJsonInterface,
        Built<RecordingStoreResponseApplicationJson, RecordingStoreResponseApplicationJsonBuilder> {
  factory RecordingStoreResponseApplicationJson([
    final void Function(RecordingStoreResponseApplicationJsonBuilder)? b,
  ]) = _$RecordingStoreResponseApplicationJson;

  // coverage:ignore-start
  const RecordingStoreResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RecordingStoreResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RecordingStoreResponseApplicationJson> get serializer =>
      _$recordingStoreResponseApplicationJsonSerializer;
}

class RecordingNotificationDismissApiVersion extends EnumClass {
  const RecordingNotificationDismissApiVersion._(super.name);

  static const RecordingNotificationDismissApiVersion v1 = _$recordingNotificationDismissApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<RecordingNotificationDismissApiVersion> get values => _$recordingNotificationDismissApiVersionValues;
  // coverage:ignore-end
  static RecordingNotificationDismissApiVersion valueOf(final String name) =>
      _$valueOfRecordingNotificationDismissApiVersion(name);
  static Serializer<RecordingNotificationDismissApiVersion> get serializer =>
      _$recordingNotificationDismissApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RecordingNotificationDismissResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class RecordingNotificationDismissResponseApplicationJson_Ocs
    implements
        RecordingNotificationDismissResponseApplicationJson_OcsInterface,
        Built<RecordingNotificationDismissResponseApplicationJson_Ocs,
            RecordingNotificationDismissResponseApplicationJson_OcsBuilder> {
  factory RecordingNotificationDismissResponseApplicationJson_Ocs([
    final void Function(RecordingNotificationDismissResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RecordingNotificationDismissResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RecordingNotificationDismissResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RecordingNotificationDismissResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RecordingNotificationDismissResponseApplicationJson_Ocs> get serializer =>
      _$recordingNotificationDismissResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RecordingNotificationDismissResponseApplicationJsonInterface {
  RecordingNotificationDismissResponseApplicationJson_Ocs get ocs;
}

abstract class RecordingNotificationDismissResponseApplicationJson
    implements
        RecordingNotificationDismissResponseApplicationJsonInterface,
        Built<RecordingNotificationDismissResponseApplicationJson,
            RecordingNotificationDismissResponseApplicationJsonBuilder> {
  factory RecordingNotificationDismissResponseApplicationJson([
    final void Function(RecordingNotificationDismissResponseApplicationJsonBuilder)? b,
  ]) = _$RecordingNotificationDismissResponseApplicationJson;

  // coverage:ignore-start
  const RecordingNotificationDismissResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RecordingNotificationDismissResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RecordingNotificationDismissResponseApplicationJson> get serializer =>
      _$recordingNotificationDismissResponseApplicationJsonSerializer;
}

class RecordingShareToChatApiVersion extends EnumClass {
  const RecordingShareToChatApiVersion._(super.name);

  static const RecordingShareToChatApiVersion v1 = _$recordingShareToChatApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<RecordingShareToChatApiVersion> get values => _$recordingShareToChatApiVersionValues;
  // coverage:ignore-end
  static RecordingShareToChatApiVersion valueOf(final String name) => _$valueOfRecordingShareToChatApiVersion(name);
  static Serializer<RecordingShareToChatApiVersion> get serializer => _$recordingShareToChatApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RecordingShareToChatResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class RecordingShareToChatResponseApplicationJson_Ocs
    implements
        RecordingShareToChatResponseApplicationJson_OcsInterface,
        Built<RecordingShareToChatResponseApplicationJson_Ocs, RecordingShareToChatResponseApplicationJson_OcsBuilder> {
  factory RecordingShareToChatResponseApplicationJson_Ocs([
    final void Function(RecordingShareToChatResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RecordingShareToChatResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RecordingShareToChatResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RecordingShareToChatResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RecordingShareToChatResponseApplicationJson_Ocs> get serializer =>
      _$recordingShareToChatResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RecordingShareToChatResponseApplicationJsonInterface {
  RecordingShareToChatResponseApplicationJson_Ocs get ocs;
}

abstract class RecordingShareToChatResponseApplicationJson
    implements
        RecordingShareToChatResponseApplicationJsonInterface,
        Built<RecordingShareToChatResponseApplicationJson, RecordingShareToChatResponseApplicationJsonBuilder> {
  factory RecordingShareToChatResponseApplicationJson([
    final void Function(RecordingShareToChatResponseApplicationJsonBuilder)? b,
  ]) = _$RecordingShareToChatResponseApplicationJson;

  // coverage:ignore-start
  const RecordingShareToChatResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RecordingShareToChatResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RecordingShareToChatResponseApplicationJson> get serializer =>
      _$recordingShareToChatResponseApplicationJsonSerializer;
}

class RoomGetRoomsApiVersion extends EnumClass {
  const RoomGetRoomsApiVersion._(super.name);

  static const RoomGetRoomsApiVersion v4 = _$roomGetRoomsApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomGetRoomsApiVersion> get values => _$roomGetRoomsApiVersionValues;
  // coverage:ignore-end
  static RoomGetRoomsApiVersion valueOf(final String name) => _$valueOfRoomGetRoomsApiVersion(name);
  static Serializer<RoomGetRoomsApiVersion> get serializer => _$roomGetRoomsApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomRoomGetRoomsHeadersInterface {
  @BuiltValueField(wireName: 'x-nextcloud-talk-hash')
  String? get xNextcloudTalkHash;
  @BuiltValueField(wireName: 'x-nextcloud-talk-modified-before')
  String? get xNextcloudTalkModifiedBefore;
}

abstract class RoomRoomGetRoomsHeaders
    implements RoomRoomGetRoomsHeadersInterface, Built<RoomRoomGetRoomsHeaders, RoomRoomGetRoomsHeadersBuilder> {
  factory RoomRoomGetRoomsHeaders([final void Function(RoomRoomGetRoomsHeadersBuilder)? b]) = _$RoomRoomGetRoomsHeaders;

  // coverage:ignore-start
  const RoomRoomGetRoomsHeaders._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomRoomGetRoomsHeaders.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  @BuiltValueSerializer(custom: true)
  static Serializer<RoomRoomGetRoomsHeaders> get serializer => _$RoomRoomGetRoomsHeadersSerializer();
}

class _$RoomRoomGetRoomsHeadersSerializer implements StructuredSerializer<RoomRoomGetRoomsHeaders> {
  @override
  final Iterable<Type> types = const [RoomRoomGetRoomsHeaders, _$RoomRoomGetRoomsHeaders];

  @override
  final String wireName = 'RoomRoomGetRoomsHeaders';

  @override
  Iterable<Object?> serialize(
    final Serializers serializers,
    final RoomRoomGetRoomsHeaders object, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    throw UnimplementedError();
  }

  @override
  RoomRoomGetRoomsHeaders deserialize(
    final Serializers serializers,
    final Iterable<Object?> serialized, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    final result = RoomRoomGetRoomsHeadersBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final value = iterator.current! as String;
      switch (key) {
        case 'x-nextcloud-talk-hash':
          result.xNextcloudTalkHash = value;
        case 'x-nextcloud-talk-modified-before':
          result.xNextcloudTalkModifiedBefore = value;
      }
    }

    return result.build();
  }
}

@BuiltValue(instantiable: false)
abstract interface class RoomGetRoomsResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  BuiltList<Room> get data;
}

abstract class RoomGetRoomsResponseApplicationJson_Ocs
    implements
        RoomGetRoomsResponseApplicationJson_OcsInterface,
        Built<RoomGetRoomsResponseApplicationJson_Ocs, RoomGetRoomsResponseApplicationJson_OcsBuilder> {
  factory RoomGetRoomsResponseApplicationJson_Ocs([
    final void Function(RoomGetRoomsResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomGetRoomsResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomGetRoomsResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomGetRoomsResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomGetRoomsResponseApplicationJson_Ocs> get serializer =>
      _$roomGetRoomsResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomGetRoomsResponseApplicationJsonInterface {
  RoomGetRoomsResponseApplicationJson_Ocs get ocs;
}

abstract class RoomGetRoomsResponseApplicationJson
    implements
        RoomGetRoomsResponseApplicationJsonInterface,
        Built<RoomGetRoomsResponseApplicationJson, RoomGetRoomsResponseApplicationJsonBuilder> {
  factory RoomGetRoomsResponseApplicationJson([final void Function(RoomGetRoomsResponseApplicationJsonBuilder)? b]) =
      _$RoomGetRoomsResponseApplicationJson;

  // coverage:ignore-start
  const RoomGetRoomsResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomGetRoomsResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomGetRoomsResponseApplicationJson> get serializer =>
      _$roomGetRoomsResponseApplicationJsonSerializer;
}

class RoomCreateRoomApiVersion extends EnumClass {
  const RoomCreateRoomApiVersion._(super.name);

  static const RoomCreateRoomApiVersion v4 = _$roomCreateRoomApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomCreateRoomApiVersion> get values => _$roomCreateRoomApiVersionValues;
  // coverage:ignore-end
  static RoomCreateRoomApiVersion valueOf(final String name) => _$valueOfRoomCreateRoomApiVersion(name);
  static Serializer<RoomCreateRoomApiVersion> get serializer => _$roomCreateRoomApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomCreateRoomResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  Room get data;
}

abstract class RoomCreateRoomResponseApplicationJson_Ocs
    implements
        RoomCreateRoomResponseApplicationJson_OcsInterface,
        Built<RoomCreateRoomResponseApplicationJson_Ocs, RoomCreateRoomResponseApplicationJson_OcsBuilder> {
  factory RoomCreateRoomResponseApplicationJson_Ocs([
    final void Function(RoomCreateRoomResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomCreateRoomResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomCreateRoomResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomCreateRoomResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomCreateRoomResponseApplicationJson_Ocs> get serializer =>
      _$roomCreateRoomResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomCreateRoomResponseApplicationJsonInterface {
  RoomCreateRoomResponseApplicationJson_Ocs get ocs;
}

abstract class RoomCreateRoomResponseApplicationJson
    implements
        RoomCreateRoomResponseApplicationJsonInterface,
        Built<RoomCreateRoomResponseApplicationJson, RoomCreateRoomResponseApplicationJsonBuilder> {
  factory RoomCreateRoomResponseApplicationJson([
    final void Function(RoomCreateRoomResponseApplicationJsonBuilder)? b,
  ]) = _$RoomCreateRoomResponseApplicationJson;

  // coverage:ignore-start
  const RoomCreateRoomResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomCreateRoomResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomCreateRoomResponseApplicationJson> get serializer =>
      _$roomCreateRoomResponseApplicationJsonSerializer;
}

class RoomGetListedRoomsApiVersion extends EnumClass {
  const RoomGetListedRoomsApiVersion._(super.name);

  static const RoomGetListedRoomsApiVersion v4 = _$roomGetListedRoomsApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomGetListedRoomsApiVersion> get values => _$roomGetListedRoomsApiVersionValues;
  // coverage:ignore-end
  static RoomGetListedRoomsApiVersion valueOf(final String name) => _$valueOfRoomGetListedRoomsApiVersion(name);
  static Serializer<RoomGetListedRoomsApiVersion> get serializer => _$roomGetListedRoomsApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomGetListedRoomsResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  BuiltList<Room> get data;
}

abstract class RoomGetListedRoomsResponseApplicationJson_Ocs
    implements
        RoomGetListedRoomsResponseApplicationJson_OcsInterface,
        Built<RoomGetListedRoomsResponseApplicationJson_Ocs, RoomGetListedRoomsResponseApplicationJson_OcsBuilder> {
  factory RoomGetListedRoomsResponseApplicationJson_Ocs([
    final void Function(RoomGetListedRoomsResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomGetListedRoomsResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomGetListedRoomsResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomGetListedRoomsResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomGetListedRoomsResponseApplicationJson_Ocs> get serializer =>
      _$roomGetListedRoomsResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomGetListedRoomsResponseApplicationJsonInterface {
  RoomGetListedRoomsResponseApplicationJson_Ocs get ocs;
}

abstract class RoomGetListedRoomsResponseApplicationJson
    implements
        RoomGetListedRoomsResponseApplicationJsonInterface,
        Built<RoomGetListedRoomsResponseApplicationJson, RoomGetListedRoomsResponseApplicationJsonBuilder> {
  factory RoomGetListedRoomsResponseApplicationJson([
    final void Function(RoomGetListedRoomsResponseApplicationJsonBuilder)? b,
  ]) = _$RoomGetListedRoomsResponseApplicationJson;

  // coverage:ignore-start
  const RoomGetListedRoomsResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomGetListedRoomsResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomGetListedRoomsResponseApplicationJson> get serializer =>
      _$roomGetListedRoomsResponseApplicationJsonSerializer;
}

class RoomGetNoteToSelfConversationApiVersion extends EnumClass {
  const RoomGetNoteToSelfConversationApiVersion._(super.name);

  static const RoomGetNoteToSelfConversationApiVersion v4 = _$roomGetNoteToSelfConversationApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomGetNoteToSelfConversationApiVersion> get values =>
      _$roomGetNoteToSelfConversationApiVersionValues;
  // coverage:ignore-end
  static RoomGetNoteToSelfConversationApiVersion valueOf(final String name) =>
      _$valueOfRoomGetNoteToSelfConversationApiVersion(name);
  static Serializer<RoomGetNoteToSelfConversationApiVersion> get serializer =>
      _$roomGetNoteToSelfConversationApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomRoomGetNoteToSelfConversationHeadersInterface {
  @BuiltValueField(wireName: 'x-nextcloud-talk-hash')
  String? get xNextcloudTalkHash;
}

abstract class RoomRoomGetNoteToSelfConversationHeaders
    implements
        RoomRoomGetNoteToSelfConversationHeadersInterface,
        Built<RoomRoomGetNoteToSelfConversationHeaders, RoomRoomGetNoteToSelfConversationHeadersBuilder> {
  factory RoomRoomGetNoteToSelfConversationHeaders([
    final void Function(RoomRoomGetNoteToSelfConversationHeadersBuilder)? b,
  ]) = _$RoomRoomGetNoteToSelfConversationHeaders;

  // coverage:ignore-start
  const RoomRoomGetNoteToSelfConversationHeaders._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomRoomGetNoteToSelfConversationHeaders.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  @BuiltValueSerializer(custom: true)
  static Serializer<RoomRoomGetNoteToSelfConversationHeaders> get serializer =>
      _$RoomRoomGetNoteToSelfConversationHeadersSerializer();
}

class _$RoomRoomGetNoteToSelfConversationHeadersSerializer
    implements StructuredSerializer<RoomRoomGetNoteToSelfConversationHeaders> {
  @override
  final Iterable<Type> types = const [
    RoomRoomGetNoteToSelfConversationHeaders,
    _$RoomRoomGetNoteToSelfConversationHeaders,
  ];

  @override
  final String wireName = 'RoomRoomGetNoteToSelfConversationHeaders';

  @override
  Iterable<Object?> serialize(
    final Serializers serializers,
    final RoomRoomGetNoteToSelfConversationHeaders object, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    throw UnimplementedError();
  }

  @override
  RoomRoomGetNoteToSelfConversationHeaders deserialize(
    final Serializers serializers,
    final Iterable<Object?> serialized, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    final result = RoomRoomGetNoteToSelfConversationHeadersBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final value = iterator.current! as String;
      switch (key) {
        case 'x-nextcloud-talk-hash':
          result.xNextcloudTalkHash = value;
      }
    }

    return result.build();
  }
}

@BuiltValue(instantiable: false)
abstract interface class RoomGetNoteToSelfConversationResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  Room get data;
}

abstract class RoomGetNoteToSelfConversationResponseApplicationJson_Ocs
    implements
        RoomGetNoteToSelfConversationResponseApplicationJson_OcsInterface,
        Built<RoomGetNoteToSelfConversationResponseApplicationJson_Ocs,
            RoomGetNoteToSelfConversationResponseApplicationJson_OcsBuilder> {
  factory RoomGetNoteToSelfConversationResponseApplicationJson_Ocs([
    final void Function(RoomGetNoteToSelfConversationResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomGetNoteToSelfConversationResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomGetNoteToSelfConversationResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomGetNoteToSelfConversationResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomGetNoteToSelfConversationResponseApplicationJson_Ocs> get serializer =>
      _$roomGetNoteToSelfConversationResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomGetNoteToSelfConversationResponseApplicationJsonInterface {
  RoomGetNoteToSelfConversationResponseApplicationJson_Ocs get ocs;
}

abstract class RoomGetNoteToSelfConversationResponseApplicationJson
    implements
        RoomGetNoteToSelfConversationResponseApplicationJsonInterface,
        Built<RoomGetNoteToSelfConversationResponseApplicationJson,
            RoomGetNoteToSelfConversationResponseApplicationJsonBuilder> {
  factory RoomGetNoteToSelfConversationResponseApplicationJson([
    final void Function(RoomGetNoteToSelfConversationResponseApplicationJsonBuilder)? b,
  ]) = _$RoomGetNoteToSelfConversationResponseApplicationJson;

  // coverage:ignore-start
  const RoomGetNoteToSelfConversationResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomGetNoteToSelfConversationResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomGetNoteToSelfConversationResponseApplicationJson> get serializer =>
      _$roomGetNoteToSelfConversationResponseApplicationJsonSerializer;
}

class RoomGetSingleRoomApiVersion extends EnumClass {
  const RoomGetSingleRoomApiVersion._(super.name);

  static const RoomGetSingleRoomApiVersion v4 = _$roomGetSingleRoomApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomGetSingleRoomApiVersion> get values => _$roomGetSingleRoomApiVersionValues;
  // coverage:ignore-end
  static RoomGetSingleRoomApiVersion valueOf(final String name) => _$valueOfRoomGetSingleRoomApiVersion(name);
  static Serializer<RoomGetSingleRoomApiVersion> get serializer => _$roomGetSingleRoomApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomRoomGetSingleRoomHeadersInterface {
  @BuiltValueField(wireName: 'x-nextcloud-talk-hash')
  String? get xNextcloudTalkHash;
}

abstract class RoomRoomGetSingleRoomHeaders
    implements
        RoomRoomGetSingleRoomHeadersInterface,
        Built<RoomRoomGetSingleRoomHeaders, RoomRoomGetSingleRoomHeadersBuilder> {
  factory RoomRoomGetSingleRoomHeaders([final void Function(RoomRoomGetSingleRoomHeadersBuilder)? b]) =
      _$RoomRoomGetSingleRoomHeaders;

  // coverage:ignore-start
  const RoomRoomGetSingleRoomHeaders._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomRoomGetSingleRoomHeaders.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  @BuiltValueSerializer(custom: true)
  static Serializer<RoomRoomGetSingleRoomHeaders> get serializer => _$RoomRoomGetSingleRoomHeadersSerializer();
}

class _$RoomRoomGetSingleRoomHeadersSerializer implements StructuredSerializer<RoomRoomGetSingleRoomHeaders> {
  @override
  final Iterable<Type> types = const [RoomRoomGetSingleRoomHeaders, _$RoomRoomGetSingleRoomHeaders];

  @override
  final String wireName = 'RoomRoomGetSingleRoomHeaders';

  @override
  Iterable<Object?> serialize(
    final Serializers serializers,
    final RoomRoomGetSingleRoomHeaders object, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    throw UnimplementedError();
  }

  @override
  RoomRoomGetSingleRoomHeaders deserialize(
    final Serializers serializers,
    final Iterable<Object?> serialized, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    final result = RoomRoomGetSingleRoomHeadersBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final value = iterator.current! as String;
      switch (key) {
        case 'x-nextcloud-talk-hash':
          result.xNextcloudTalkHash = value;
      }
    }

    return result.build();
  }
}

@BuiltValue(instantiable: false)
abstract interface class RoomGetSingleRoomResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  Room get data;
}

abstract class RoomGetSingleRoomResponseApplicationJson_Ocs
    implements
        RoomGetSingleRoomResponseApplicationJson_OcsInterface,
        Built<RoomGetSingleRoomResponseApplicationJson_Ocs, RoomGetSingleRoomResponseApplicationJson_OcsBuilder> {
  factory RoomGetSingleRoomResponseApplicationJson_Ocs([
    final void Function(RoomGetSingleRoomResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomGetSingleRoomResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomGetSingleRoomResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomGetSingleRoomResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomGetSingleRoomResponseApplicationJson_Ocs> get serializer =>
      _$roomGetSingleRoomResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomGetSingleRoomResponseApplicationJsonInterface {
  RoomGetSingleRoomResponseApplicationJson_Ocs get ocs;
}

abstract class RoomGetSingleRoomResponseApplicationJson
    implements
        RoomGetSingleRoomResponseApplicationJsonInterface,
        Built<RoomGetSingleRoomResponseApplicationJson, RoomGetSingleRoomResponseApplicationJsonBuilder> {
  factory RoomGetSingleRoomResponseApplicationJson([
    final void Function(RoomGetSingleRoomResponseApplicationJsonBuilder)? b,
  ]) = _$RoomGetSingleRoomResponseApplicationJson;

  // coverage:ignore-start
  const RoomGetSingleRoomResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomGetSingleRoomResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomGetSingleRoomResponseApplicationJson> get serializer =>
      _$roomGetSingleRoomResponseApplicationJsonSerializer;
}

class RoomRenameRoomApiVersion extends EnumClass {
  const RoomRenameRoomApiVersion._(super.name);

  static const RoomRenameRoomApiVersion v4 = _$roomRenameRoomApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomRenameRoomApiVersion> get values => _$roomRenameRoomApiVersionValues;
  // coverage:ignore-end
  static RoomRenameRoomApiVersion valueOf(final String name) => _$valueOfRoomRenameRoomApiVersion(name);
  static Serializer<RoomRenameRoomApiVersion> get serializer => _$roomRenameRoomApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomRenameRoomResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class RoomRenameRoomResponseApplicationJson_Ocs
    implements
        RoomRenameRoomResponseApplicationJson_OcsInterface,
        Built<RoomRenameRoomResponseApplicationJson_Ocs, RoomRenameRoomResponseApplicationJson_OcsBuilder> {
  factory RoomRenameRoomResponseApplicationJson_Ocs([
    final void Function(RoomRenameRoomResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomRenameRoomResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomRenameRoomResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomRenameRoomResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomRenameRoomResponseApplicationJson_Ocs> get serializer =>
      _$roomRenameRoomResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomRenameRoomResponseApplicationJsonInterface {
  RoomRenameRoomResponseApplicationJson_Ocs get ocs;
}

abstract class RoomRenameRoomResponseApplicationJson
    implements
        RoomRenameRoomResponseApplicationJsonInterface,
        Built<RoomRenameRoomResponseApplicationJson, RoomRenameRoomResponseApplicationJsonBuilder> {
  factory RoomRenameRoomResponseApplicationJson([
    final void Function(RoomRenameRoomResponseApplicationJsonBuilder)? b,
  ]) = _$RoomRenameRoomResponseApplicationJson;

  // coverage:ignore-start
  const RoomRenameRoomResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomRenameRoomResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomRenameRoomResponseApplicationJson> get serializer =>
      _$roomRenameRoomResponseApplicationJsonSerializer;
}

class RoomDeleteRoomApiVersion extends EnumClass {
  const RoomDeleteRoomApiVersion._(super.name);

  static const RoomDeleteRoomApiVersion v4 = _$roomDeleteRoomApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomDeleteRoomApiVersion> get values => _$roomDeleteRoomApiVersionValues;
  // coverage:ignore-end
  static RoomDeleteRoomApiVersion valueOf(final String name) => _$valueOfRoomDeleteRoomApiVersion(name);
  static Serializer<RoomDeleteRoomApiVersion> get serializer => _$roomDeleteRoomApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomDeleteRoomResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class RoomDeleteRoomResponseApplicationJson_Ocs
    implements
        RoomDeleteRoomResponseApplicationJson_OcsInterface,
        Built<RoomDeleteRoomResponseApplicationJson_Ocs, RoomDeleteRoomResponseApplicationJson_OcsBuilder> {
  factory RoomDeleteRoomResponseApplicationJson_Ocs([
    final void Function(RoomDeleteRoomResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomDeleteRoomResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomDeleteRoomResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomDeleteRoomResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomDeleteRoomResponseApplicationJson_Ocs> get serializer =>
      _$roomDeleteRoomResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomDeleteRoomResponseApplicationJsonInterface {
  RoomDeleteRoomResponseApplicationJson_Ocs get ocs;
}

abstract class RoomDeleteRoomResponseApplicationJson
    implements
        RoomDeleteRoomResponseApplicationJsonInterface,
        Built<RoomDeleteRoomResponseApplicationJson, RoomDeleteRoomResponseApplicationJsonBuilder> {
  factory RoomDeleteRoomResponseApplicationJson([
    final void Function(RoomDeleteRoomResponseApplicationJsonBuilder)? b,
  ]) = _$RoomDeleteRoomResponseApplicationJson;

  // coverage:ignore-start
  const RoomDeleteRoomResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomDeleteRoomResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomDeleteRoomResponseApplicationJson> get serializer =>
      _$roomDeleteRoomResponseApplicationJsonSerializer;
}

class RoomGetBreakoutRoomsApiVersion extends EnumClass {
  const RoomGetBreakoutRoomsApiVersion._(super.name);

  static const RoomGetBreakoutRoomsApiVersion v4 = _$roomGetBreakoutRoomsApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomGetBreakoutRoomsApiVersion> get values => _$roomGetBreakoutRoomsApiVersionValues;
  // coverage:ignore-end
  static RoomGetBreakoutRoomsApiVersion valueOf(final String name) => _$valueOfRoomGetBreakoutRoomsApiVersion(name);
  static Serializer<RoomGetBreakoutRoomsApiVersion> get serializer => _$roomGetBreakoutRoomsApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomGetBreakoutRoomsResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  BuiltList<Room> get data;
}

abstract class RoomGetBreakoutRoomsResponseApplicationJson_Ocs
    implements
        RoomGetBreakoutRoomsResponseApplicationJson_OcsInterface,
        Built<RoomGetBreakoutRoomsResponseApplicationJson_Ocs, RoomGetBreakoutRoomsResponseApplicationJson_OcsBuilder> {
  factory RoomGetBreakoutRoomsResponseApplicationJson_Ocs([
    final void Function(RoomGetBreakoutRoomsResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomGetBreakoutRoomsResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomGetBreakoutRoomsResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomGetBreakoutRoomsResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomGetBreakoutRoomsResponseApplicationJson_Ocs> get serializer =>
      _$roomGetBreakoutRoomsResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomGetBreakoutRoomsResponseApplicationJsonInterface {
  RoomGetBreakoutRoomsResponseApplicationJson_Ocs get ocs;
}

abstract class RoomGetBreakoutRoomsResponseApplicationJson
    implements
        RoomGetBreakoutRoomsResponseApplicationJsonInterface,
        Built<RoomGetBreakoutRoomsResponseApplicationJson, RoomGetBreakoutRoomsResponseApplicationJsonBuilder> {
  factory RoomGetBreakoutRoomsResponseApplicationJson([
    final void Function(RoomGetBreakoutRoomsResponseApplicationJsonBuilder)? b,
  ]) = _$RoomGetBreakoutRoomsResponseApplicationJson;

  // coverage:ignore-start
  const RoomGetBreakoutRoomsResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomGetBreakoutRoomsResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomGetBreakoutRoomsResponseApplicationJson> get serializer =>
      _$roomGetBreakoutRoomsResponseApplicationJsonSerializer;
}

class RoomMakePublicApiVersion extends EnumClass {
  const RoomMakePublicApiVersion._(super.name);

  static const RoomMakePublicApiVersion v4 = _$roomMakePublicApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomMakePublicApiVersion> get values => _$roomMakePublicApiVersionValues;
  // coverage:ignore-end
  static RoomMakePublicApiVersion valueOf(final String name) => _$valueOfRoomMakePublicApiVersion(name);
  static Serializer<RoomMakePublicApiVersion> get serializer => _$roomMakePublicApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomMakePublicResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class RoomMakePublicResponseApplicationJson_Ocs
    implements
        RoomMakePublicResponseApplicationJson_OcsInterface,
        Built<RoomMakePublicResponseApplicationJson_Ocs, RoomMakePublicResponseApplicationJson_OcsBuilder> {
  factory RoomMakePublicResponseApplicationJson_Ocs([
    final void Function(RoomMakePublicResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomMakePublicResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomMakePublicResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomMakePublicResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomMakePublicResponseApplicationJson_Ocs> get serializer =>
      _$roomMakePublicResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomMakePublicResponseApplicationJsonInterface {
  RoomMakePublicResponseApplicationJson_Ocs get ocs;
}

abstract class RoomMakePublicResponseApplicationJson
    implements
        RoomMakePublicResponseApplicationJsonInterface,
        Built<RoomMakePublicResponseApplicationJson, RoomMakePublicResponseApplicationJsonBuilder> {
  factory RoomMakePublicResponseApplicationJson([
    final void Function(RoomMakePublicResponseApplicationJsonBuilder)? b,
  ]) = _$RoomMakePublicResponseApplicationJson;

  // coverage:ignore-start
  const RoomMakePublicResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomMakePublicResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomMakePublicResponseApplicationJson> get serializer =>
      _$roomMakePublicResponseApplicationJsonSerializer;
}

class RoomMakePrivateApiVersion extends EnumClass {
  const RoomMakePrivateApiVersion._(super.name);

  static const RoomMakePrivateApiVersion v4 = _$roomMakePrivateApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomMakePrivateApiVersion> get values => _$roomMakePrivateApiVersionValues;
  // coverage:ignore-end
  static RoomMakePrivateApiVersion valueOf(final String name) => _$valueOfRoomMakePrivateApiVersion(name);
  static Serializer<RoomMakePrivateApiVersion> get serializer => _$roomMakePrivateApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomMakePrivateResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class RoomMakePrivateResponseApplicationJson_Ocs
    implements
        RoomMakePrivateResponseApplicationJson_OcsInterface,
        Built<RoomMakePrivateResponseApplicationJson_Ocs, RoomMakePrivateResponseApplicationJson_OcsBuilder> {
  factory RoomMakePrivateResponseApplicationJson_Ocs([
    final void Function(RoomMakePrivateResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomMakePrivateResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomMakePrivateResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomMakePrivateResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomMakePrivateResponseApplicationJson_Ocs> get serializer =>
      _$roomMakePrivateResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomMakePrivateResponseApplicationJsonInterface {
  RoomMakePrivateResponseApplicationJson_Ocs get ocs;
}

abstract class RoomMakePrivateResponseApplicationJson
    implements
        RoomMakePrivateResponseApplicationJsonInterface,
        Built<RoomMakePrivateResponseApplicationJson, RoomMakePrivateResponseApplicationJsonBuilder> {
  factory RoomMakePrivateResponseApplicationJson([
    final void Function(RoomMakePrivateResponseApplicationJsonBuilder)? b,
  ]) = _$RoomMakePrivateResponseApplicationJson;

  // coverage:ignore-start
  const RoomMakePrivateResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomMakePrivateResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomMakePrivateResponseApplicationJson> get serializer =>
      _$roomMakePrivateResponseApplicationJsonSerializer;
}

class RoomSetDescriptionApiVersion extends EnumClass {
  const RoomSetDescriptionApiVersion._(super.name);

  static const RoomSetDescriptionApiVersion v4 = _$roomSetDescriptionApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomSetDescriptionApiVersion> get values => _$roomSetDescriptionApiVersionValues;
  // coverage:ignore-end
  static RoomSetDescriptionApiVersion valueOf(final String name) => _$valueOfRoomSetDescriptionApiVersion(name);
  static Serializer<RoomSetDescriptionApiVersion> get serializer => _$roomSetDescriptionApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomSetDescriptionResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class RoomSetDescriptionResponseApplicationJson_Ocs
    implements
        RoomSetDescriptionResponseApplicationJson_OcsInterface,
        Built<RoomSetDescriptionResponseApplicationJson_Ocs, RoomSetDescriptionResponseApplicationJson_OcsBuilder> {
  factory RoomSetDescriptionResponseApplicationJson_Ocs([
    final void Function(RoomSetDescriptionResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomSetDescriptionResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomSetDescriptionResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomSetDescriptionResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomSetDescriptionResponseApplicationJson_Ocs> get serializer =>
      _$roomSetDescriptionResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomSetDescriptionResponseApplicationJsonInterface {
  RoomSetDescriptionResponseApplicationJson_Ocs get ocs;
}

abstract class RoomSetDescriptionResponseApplicationJson
    implements
        RoomSetDescriptionResponseApplicationJsonInterface,
        Built<RoomSetDescriptionResponseApplicationJson, RoomSetDescriptionResponseApplicationJsonBuilder> {
  factory RoomSetDescriptionResponseApplicationJson([
    final void Function(RoomSetDescriptionResponseApplicationJsonBuilder)? b,
  ]) = _$RoomSetDescriptionResponseApplicationJson;

  // coverage:ignore-start
  const RoomSetDescriptionResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomSetDescriptionResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomSetDescriptionResponseApplicationJson> get serializer =>
      _$roomSetDescriptionResponseApplicationJsonSerializer;
}

class RoomSetReadOnlyApiVersion extends EnumClass {
  const RoomSetReadOnlyApiVersion._(super.name);

  static const RoomSetReadOnlyApiVersion v4 = _$roomSetReadOnlyApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomSetReadOnlyApiVersion> get values => _$roomSetReadOnlyApiVersionValues;
  // coverage:ignore-end
  static RoomSetReadOnlyApiVersion valueOf(final String name) => _$valueOfRoomSetReadOnlyApiVersion(name);
  static Serializer<RoomSetReadOnlyApiVersion> get serializer => _$roomSetReadOnlyApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomSetReadOnlyResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class RoomSetReadOnlyResponseApplicationJson_Ocs
    implements
        RoomSetReadOnlyResponseApplicationJson_OcsInterface,
        Built<RoomSetReadOnlyResponseApplicationJson_Ocs, RoomSetReadOnlyResponseApplicationJson_OcsBuilder> {
  factory RoomSetReadOnlyResponseApplicationJson_Ocs([
    final void Function(RoomSetReadOnlyResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomSetReadOnlyResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomSetReadOnlyResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomSetReadOnlyResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomSetReadOnlyResponseApplicationJson_Ocs> get serializer =>
      _$roomSetReadOnlyResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomSetReadOnlyResponseApplicationJsonInterface {
  RoomSetReadOnlyResponseApplicationJson_Ocs get ocs;
}

abstract class RoomSetReadOnlyResponseApplicationJson
    implements
        RoomSetReadOnlyResponseApplicationJsonInterface,
        Built<RoomSetReadOnlyResponseApplicationJson, RoomSetReadOnlyResponseApplicationJsonBuilder> {
  factory RoomSetReadOnlyResponseApplicationJson([
    final void Function(RoomSetReadOnlyResponseApplicationJsonBuilder)? b,
  ]) = _$RoomSetReadOnlyResponseApplicationJson;

  // coverage:ignore-start
  const RoomSetReadOnlyResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomSetReadOnlyResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomSetReadOnlyResponseApplicationJson> get serializer =>
      _$roomSetReadOnlyResponseApplicationJsonSerializer;
}

class RoomSetListableApiVersion extends EnumClass {
  const RoomSetListableApiVersion._(super.name);

  static const RoomSetListableApiVersion v4 = _$roomSetListableApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomSetListableApiVersion> get values => _$roomSetListableApiVersionValues;
  // coverage:ignore-end
  static RoomSetListableApiVersion valueOf(final String name) => _$valueOfRoomSetListableApiVersion(name);
  static Serializer<RoomSetListableApiVersion> get serializer => _$roomSetListableApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomSetListableResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class RoomSetListableResponseApplicationJson_Ocs
    implements
        RoomSetListableResponseApplicationJson_OcsInterface,
        Built<RoomSetListableResponseApplicationJson_Ocs, RoomSetListableResponseApplicationJson_OcsBuilder> {
  factory RoomSetListableResponseApplicationJson_Ocs([
    final void Function(RoomSetListableResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomSetListableResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomSetListableResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomSetListableResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomSetListableResponseApplicationJson_Ocs> get serializer =>
      _$roomSetListableResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomSetListableResponseApplicationJsonInterface {
  RoomSetListableResponseApplicationJson_Ocs get ocs;
}

abstract class RoomSetListableResponseApplicationJson
    implements
        RoomSetListableResponseApplicationJsonInterface,
        Built<RoomSetListableResponseApplicationJson, RoomSetListableResponseApplicationJsonBuilder> {
  factory RoomSetListableResponseApplicationJson([
    final void Function(RoomSetListableResponseApplicationJsonBuilder)? b,
  ]) = _$RoomSetListableResponseApplicationJson;

  // coverage:ignore-start
  const RoomSetListableResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomSetListableResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomSetListableResponseApplicationJson> get serializer =>
      _$roomSetListableResponseApplicationJsonSerializer;
}

class RoomSetPasswordApiVersion extends EnumClass {
  const RoomSetPasswordApiVersion._(super.name);

  static const RoomSetPasswordApiVersion v4 = _$roomSetPasswordApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomSetPasswordApiVersion> get values => _$roomSetPasswordApiVersionValues;
  // coverage:ignore-end
  static RoomSetPasswordApiVersion valueOf(final String name) => _$valueOfRoomSetPasswordApiVersion(name);
  static Serializer<RoomSetPasswordApiVersion> get serializer => _$roomSetPasswordApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomSetPasswordResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class RoomSetPasswordResponseApplicationJson_Ocs
    implements
        RoomSetPasswordResponseApplicationJson_OcsInterface,
        Built<RoomSetPasswordResponseApplicationJson_Ocs, RoomSetPasswordResponseApplicationJson_OcsBuilder> {
  factory RoomSetPasswordResponseApplicationJson_Ocs([
    final void Function(RoomSetPasswordResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomSetPasswordResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomSetPasswordResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomSetPasswordResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomSetPasswordResponseApplicationJson_Ocs> get serializer =>
      _$roomSetPasswordResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomSetPasswordResponseApplicationJsonInterface {
  RoomSetPasswordResponseApplicationJson_Ocs get ocs;
}

abstract class RoomSetPasswordResponseApplicationJson
    implements
        RoomSetPasswordResponseApplicationJsonInterface,
        Built<RoomSetPasswordResponseApplicationJson, RoomSetPasswordResponseApplicationJsonBuilder> {
  factory RoomSetPasswordResponseApplicationJson([
    final void Function(RoomSetPasswordResponseApplicationJsonBuilder)? b,
  ]) = _$RoomSetPasswordResponseApplicationJson;

  // coverage:ignore-start
  const RoomSetPasswordResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomSetPasswordResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomSetPasswordResponseApplicationJson> get serializer =>
      _$roomSetPasswordResponseApplicationJsonSerializer;
}

class RoomSetPermissionsApiVersion extends EnumClass {
  const RoomSetPermissionsApiVersion._(super.name);

  static const RoomSetPermissionsApiVersion v4 = _$roomSetPermissionsApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomSetPermissionsApiVersion> get values => _$roomSetPermissionsApiVersionValues;
  // coverage:ignore-end
  static RoomSetPermissionsApiVersion valueOf(final String name) => _$valueOfRoomSetPermissionsApiVersion(name);
  static Serializer<RoomSetPermissionsApiVersion> get serializer => _$roomSetPermissionsApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomSetPermissionsResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  Room get data;
}

abstract class RoomSetPermissionsResponseApplicationJson_Ocs
    implements
        RoomSetPermissionsResponseApplicationJson_OcsInterface,
        Built<RoomSetPermissionsResponseApplicationJson_Ocs, RoomSetPermissionsResponseApplicationJson_OcsBuilder> {
  factory RoomSetPermissionsResponseApplicationJson_Ocs([
    final void Function(RoomSetPermissionsResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomSetPermissionsResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomSetPermissionsResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomSetPermissionsResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomSetPermissionsResponseApplicationJson_Ocs> get serializer =>
      _$roomSetPermissionsResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomSetPermissionsResponseApplicationJsonInterface {
  RoomSetPermissionsResponseApplicationJson_Ocs get ocs;
}

abstract class RoomSetPermissionsResponseApplicationJson
    implements
        RoomSetPermissionsResponseApplicationJsonInterface,
        Built<RoomSetPermissionsResponseApplicationJson, RoomSetPermissionsResponseApplicationJsonBuilder> {
  factory RoomSetPermissionsResponseApplicationJson([
    final void Function(RoomSetPermissionsResponseApplicationJsonBuilder)? b,
  ]) = _$RoomSetPermissionsResponseApplicationJson;

  // coverage:ignore-start
  const RoomSetPermissionsResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomSetPermissionsResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomSetPermissionsResponseApplicationJson> get serializer =>
      _$roomSetPermissionsResponseApplicationJsonSerializer;
}

class RoomGetParticipantsApiVersion extends EnumClass {
  const RoomGetParticipantsApiVersion._(super.name);

  static const RoomGetParticipantsApiVersion v4 = _$roomGetParticipantsApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomGetParticipantsApiVersion> get values => _$roomGetParticipantsApiVersionValues;
  // coverage:ignore-end
  static RoomGetParticipantsApiVersion valueOf(final String name) => _$valueOfRoomGetParticipantsApiVersion(name);
  static Serializer<RoomGetParticipantsApiVersion> get serializer => _$roomGetParticipantsApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomRoomGetParticipantsHeadersInterface {
  @BuiltValueField(wireName: 'x-nextcloud-has-user-statuses')
  bool? get xNextcloudHasUserStatuses;
}

abstract class RoomRoomGetParticipantsHeaders
    implements
        RoomRoomGetParticipantsHeadersInterface,
        Built<RoomRoomGetParticipantsHeaders, RoomRoomGetParticipantsHeadersBuilder> {
  factory RoomRoomGetParticipantsHeaders([final void Function(RoomRoomGetParticipantsHeadersBuilder)? b]) =
      _$RoomRoomGetParticipantsHeaders;

  // coverage:ignore-start
  const RoomRoomGetParticipantsHeaders._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomRoomGetParticipantsHeaders.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  @BuiltValueSerializer(custom: true)
  static Serializer<RoomRoomGetParticipantsHeaders> get serializer => _$RoomRoomGetParticipantsHeadersSerializer();
}

class _$RoomRoomGetParticipantsHeadersSerializer implements StructuredSerializer<RoomRoomGetParticipantsHeaders> {
  @override
  final Iterable<Type> types = const [RoomRoomGetParticipantsHeaders, _$RoomRoomGetParticipantsHeaders];

  @override
  final String wireName = 'RoomRoomGetParticipantsHeaders';

  @override
  Iterable<Object?> serialize(
    final Serializers serializers,
    final RoomRoomGetParticipantsHeaders object, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    throw UnimplementedError();
  }

  @override
  RoomRoomGetParticipantsHeaders deserialize(
    final Serializers serializers,
    final Iterable<Object?> serialized, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    final result = RoomRoomGetParticipantsHeadersBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final value = iterator.current! as String;
      switch (key) {
        case 'x-nextcloud-has-user-statuses':
          result.xNextcloudHasUserStatuses = _jsonSerializers.deserialize(
            json.decode(value),
            specifiedType: const FullType(bool),
          )! as bool;
      }
    }

    return result.build();
  }
}

@BuiltValue(instantiable: false)
abstract interface class ParticipantInterface {
  String get actorId;
  String get actorType;
  int get attendeeId;
  int get attendeePermissions;
  String get attendeePin;
  String get displayName;
  int get inCall;
  int get lastPing;
  int get participantType;
  int get permissions;
  String get roomToken;
  BuiltList<String> get sessionIds;
  String? get status;
  int? get statusClearAt;
  String? get statusIcon;
  String? get statusMessage;
  String? get phoneNumber;
  String? get callId;
}

abstract class Participant implements ParticipantInterface, Built<Participant, ParticipantBuilder> {
  factory Participant([final void Function(ParticipantBuilder)? b]) = _$Participant;

  // coverage:ignore-start
  const Participant._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory Participant.fromJson(final Map<String, dynamic> json) => _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<Participant> get serializer => _$participantSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomGetParticipantsResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  BuiltList<Participant> get data;
}

abstract class RoomGetParticipantsResponseApplicationJson_Ocs
    implements
        RoomGetParticipantsResponseApplicationJson_OcsInterface,
        Built<RoomGetParticipantsResponseApplicationJson_Ocs, RoomGetParticipantsResponseApplicationJson_OcsBuilder> {
  factory RoomGetParticipantsResponseApplicationJson_Ocs([
    final void Function(RoomGetParticipantsResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomGetParticipantsResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomGetParticipantsResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomGetParticipantsResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomGetParticipantsResponseApplicationJson_Ocs> get serializer =>
      _$roomGetParticipantsResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomGetParticipantsResponseApplicationJsonInterface {
  RoomGetParticipantsResponseApplicationJson_Ocs get ocs;
}

abstract class RoomGetParticipantsResponseApplicationJson
    implements
        RoomGetParticipantsResponseApplicationJsonInterface,
        Built<RoomGetParticipantsResponseApplicationJson, RoomGetParticipantsResponseApplicationJsonBuilder> {
  factory RoomGetParticipantsResponseApplicationJson([
    final void Function(RoomGetParticipantsResponseApplicationJsonBuilder)? b,
  ]) = _$RoomGetParticipantsResponseApplicationJson;

  // coverage:ignore-start
  const RoomGetParticipantsResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomGetParticipantsResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomGetParticipantsResponseApplicationJson> get serializer =>
      _$roomGetParticipantsResponseApplicationJsonSerializer;
}

class RoomAddParticipantToRoomApiVersion extends EnumClass {
  const RoomAddParticipantToRoomApiVersion._(super.name);

  static const RoomAddParticipantToRoomApiVersion v4 = _$roomAddParticipantToRoomApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomAddParticipantToRoomApiVersion> get values => _$roomAddParticipantToRoomApiVersionValues;
  // coverage:ignore-end
  static RoomAddParticipantToRoomApiVersion valueOf(final String name) =>
      _$valueOfRoomAddParticipantToRoomApiVersion(name);
  static Serializer<RoomAddParticipantToRoomApiVersion> get serializer =>
      _$roomAddParticipantToRoomApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data0Interface {
  int get type;
}

abstract class RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data0
    implements
        RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data0Interface,
        Built<RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data0,
            RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data0Builder> {
  factory RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data0([
    final void Function(RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data0Builder)? b,
  ]) = _$RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data0;

  // coverage:ignore-start
  const RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data0._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data0.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data0> get serializer =>
      _$roomAddParticipantToRoomResponseApplicationJsonOcsData0Serializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomAddParticipantToRoomResponseApplicationJson_Ocs_DataInterface {
  RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data0?
      get roomAddParticipantToRoomResponseApplicationJsonOcsData0;
  BuiltList<JsonObject>? get builtListJsonObject;
}

abstract class RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data
    implements
        RoomAddParticipantToRoomResponseApplicationJson_Ocs_DataInterface,
        Built<RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data,
            RoomAddParticipantToRoomResponseApplicationJson_Ocs_DataBuilder> {
  factory RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data([
    final void Function(RoomAddParticipantToRoomResponseApplicationJson_Ocs_DataBuilder)? b,
  ]) = _$RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data;

  // coverage:ignore-start
  const RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  @BuiltValueSerializer(custom: true)
  static Serializer<RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data> get serializer =>
      _$RoomAddParticipantToRoomResponseApplicationJson_Ocs_DataSerializer();
  JsonObject get data;
  @BuiltValueHook(finalizeBuilder: true)
  static void _validate(final RoomAddParticipantToRoomResponseApplicationJson_Ocs_DataBuilder b) {
    // When this is rebuild from another builder
    if (b._data == null) {
      return;
    }

    final match = [b._roomAddParticipantToRoomResponseApplicationJsonOcsData0, b._builtListJsonObject]
        .singleWhereOrNull((final x) => x != null);
    if (match == null) {
      throw StateError(
        "Need exactly one of 'roomAddParticipantToRoomResponseApplicationJsonOcsData0', 'builtListJsonObject' for ${b._data}",
      );
    }
  }
}

class _$RoomAddParticipantToRoomResponseApplicationJson_Ocs_DataSerializer
    implements PrimitiveSerializer<RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data> {
  @override
  final Iterable<Type> types = const [
    RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data,
    _$RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data,
  ];

  @override
  final String wireName = 'RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data';

  @override
  Object serialize(
    final Serializers serializers,
    final RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data object, {
    final FullType specifiedType = FullType.unspecified,
  }) =>
      object.data.value;

  @override
  RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data deserialize(
    final Serializers serializers,
    final Object data, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    final result = RoomAddParticipantToRoomResponseApplicationJson_Ocs_DataBuilder()..data = JsonObject(data);
    try {
      final value = _jsonSerializers.deserialize(
        data,
        specifiedType: const FullType(RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data0),
      )! as RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data0;
      result.roomAddParticipantToRoomResponseApplicationJsonOcsData0.replace(value);
    } catch (_) {}
    try {
      final value = _jsonSerializers.deserialize(
        data,
        specifiedType: const FullType(BuiltList, [FullType(JsonObject)]),
      )! as BuiltList<JsonObject>;
      result.builtListJsonObject.replace(value);
    } catch (_) {}
    return result.build();
  }
}

@BuiltValue(instantiable: false)
abstract interface class RoomAddParticipantToRoomResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data get data;
}

abstract class RoomAddParticipantToRoomResponseApplicationJson_Ocs
    implements
        RoomAddParticipantToRoomResponseApplicationJson_OcsInterface,
        Built<RoomAddParticipantToRoomResponseApplicationJson_Ocs,
            RoomAddParticipantToRoomResponseApplicationJson_OcsBuilder> {
  factory RoomAddParticipantToRoomResponseApplicationJson_Ocs([
    final void Function(RoomAddParticipantToRoomResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomAddParticipantToRoomResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomAddParticipantToRoomResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomAddParticipantToRoomResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomAddParticipantToRoomResponseApplicationJson_Ocs> get serializer =>
      _$roomAddParticipantToRoomResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomAddParticipantToRoomResponseApplicationJsonInterface {
  RoomAddParticipantToRoomResponseApplicationJson_Ocs get ocs;
}

abstract class RoomAddParticipantToRoomResponseApplicationJson
    implements
        RoomAddParticipantToRoomResponseApplicationJsonInterface,
        Built<RoomAddParticipantToRoomResponseApplicationJson, RoomAddParticipantToRoomResponseApplicationJsonBuilder> {
  factory RoomAddParticipantToRoomResponseApplicationJson([
    final void Function(RoomAddParticipantToRoomResponseApplicationJsonBuilder)? b,
  ]) = _$RoomAddParticipantToRoomResponseApplicationJson;

  // coverage:ignore-start
  const RoomAddParticipantToRoomResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomAddParticipantToRoomResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomAddParticipantToRoomResponseApplicationJson> get serializer =>
      _$roomAddParticipantToRoomResponseApplicationJsonSerializer;
}

class RoomGetBreakoutRoomParticipantsApiVersion extends EnumClass {
  const RoomGetBreakoutRoomParticipantsApiVersion._(super.name);

  static const RoomGetBreakoutRoomParticipantsApiVersion v4 = _$roomGetBreakoutRoomParticipantsApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomGetBreakoutRoomParticipantsApiVersion> get values =>
      _$roomGetBreakoutRoomParticipantsApiVersionValues;
  // coverage:ignore-end
  static RoomGetBreakoutRoomParticipantsApiVersion valueOf(final String name) =>
      _$valueOfRoomGetBreakoutRoomParticipantsApiVersion(name);
  static Serializer<RoomGetBreakoutRoomParticipantsApiVersion> get serializer =>
      _$roomGetBreakoutRoomParticipantsApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomRoomGetBreakoutRoomParticipantsHeadersInterface {
  @BuiltValueField(wireName: 'x-nextcloud-has-user-statuses')
  bool? get xNextcloudHasUserStatuses;
}

abstract class RoomRoomGetBreakoutRoomParticipantsHeaders
    implements
        RoomRoomGetBreakoutRoomParticipantsHeadersInterface,
        Built<RoomRoomGetBreakoutRoomParticipantsHeaders, RoomRoomGetBreakoutRoomParticipantsHeadersBuilder> {
  factory RoomRoomGetBreakoutRoomParticipantsHeaders([
    final void Function(RoomRoomGetBreakoutRoomParticipantsHeadersBuilder)? b,
  ]) = _$RoomRoomGetBreakoutRoomParticipantsHeaders;

  // coverage:ignore-start
  const RoomRoomGetBreakoutRoomParticipantsHeaders._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomRoomGetBreakoutRoomParticipantsHeaders.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  @BuiltValueSerializer(custom: true)
  static Serializer<RoomRoomGetBreakoutRoomParticipantsHeaders> get serializer =>
      _$RoomRoomGetBreakoutRoomParticipantsHeadersSerializer();
}

class _$RoomRoomGetBreakoutRoomParticipantsHeadersSerializer
    implements StructuredSerializer<RoomRoomGetBreakoutRoomParticipantsHeaders> {
  @override
  final Iterable<Type> types = const [
    RoomRoomGetBreakoutRoomParticipantsHeaders,
    _$RoomRoomGetBreakoutRoomParticipantsHeaders,
  ];

  @override
  final String wireName = 'RoomRoomGetBreakoutRoomParticipantsHeaders';

  @override
  Iterable<Object?> serialize(
    final Serializers serializers,
    final RoomRoomGetBreakoutRoomParticipantsHeaders object, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    throw UnimplementedError();
  }

  @override
  RoomRoomGetBreakoutRoomParticipantsHeaders deserialize(
    final Serializers serializers,
    final Iterable<Object?> serialized, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    final result = RoomRoomGetBreakoutRoomParticipantsHeadersBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final value = iterator.current! as String;
      switch (key) {
        case 'x-nextcloud-has-user-statuses':
          result.xNextcloudHasUserStatuses = _jsonSerializers.deserialize(
            json.decode(value),
            specifiedType: const FullType(bool),
          )! as bool;
      }
    }

    return result.build();
  }
}

@BuiltValue(instantiable: false)
abstract interface class RoomGetBreakoutRoomParticipantsResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  BuiltList<Participant> get data;
}

abstract class RoomGetBreakoutRoomParticipantsResponseApplicationJson_Ocs
    implements
        RoomGetBreakoutRoomParticipantsResponseApplicationJson_OcsInterface,
        Built<RoomGetBreakoutRoomParticipantsResponseApplicationJson_Ocs,
            RoomGetBreakoutRoomParticipantsResponseApplicationJson_OcsBuilder> {
  factory RoomGetBreakoutRoomParticipantsResponseApplicationJson_Ocs([
    final void Function(RoomGetBreakoutRoomParticipantsResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomGetBreakoutRoomParticipantsResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomGetBreakoutRoomParticipantsResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomGetBreakoutRoomParticipantsResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomGetBreakoutRoomParticipantsResponseApplicationJson_Ocs> get serializer =>
      _$roomGetBreakoutRoomParticipantsResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomGetBreakoutRoomParticipantsResponseApplicationJsonInterface {
  RoomGetBreakoutRoomParticipantsResponseApplicationJson_Ocs get ocs;
}

abstract class RoomGetBreakoutRoomParticipantsResponseApplicationJson
    implements
        RoomGetBreakoutRoomParticipantsResponseApplicationJsonInterface,
        Built<RoomGetBreakoutRoomParticipantsResponseApplicationJson,
            RoomGetBreakoutRoomParticipantsResponseApplicationJsonBuilder> {
  factory RoomGetBreakoutRoomParticipantsResponseApplicationJson([
    final void Function(RoomGetBreakoutRoomParticipantsResponseApplicationJsonBuilder)? b,
  ]) = _$RoomGetBreakoutRoomParticipantsResponseApplicationJson;

  // coverage:ignore-start
  const RoomGetBreakoutRoomParticipantsResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomGetBreakoutRoomParticipantsResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomGetBreakoutRoomParticipantsResponseApplicationJson> get serializer =>
      _$roomGetBreakoutRoomParticipantsResponseApplicationJsonSerializer;
}

class RoomRemoveSelfFromRoomApiVersion extends EnumClass {
  const RoomRemoveSelfFromRoomApiVersion._(super.name);

  static const RoomRemoveSelfFromRoomApiVersion v4 = _$roomRemoveSelfFromRoomApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomRemoveSelfFromRoomApiVersion> get values => _$roomRemoveSelfFromRoomApiVersionValues;
  // coverage:ignore-end
  static RoomRemoveSelfFromRoomApiVersion valueOf(final String name) => _$valueOfRoomRemoveSelfFromRoomApiVersion(name);
  static Serializer<RoomRemoveSelfFromRoomApiVersion> get serializer => _$roomRemoveSelfFromRoomApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomRemoveSelfFromRoomResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class RoomRemoveSelfFromRoomResponseApplicationJson_Ocs
    implements
        RoomRemoveSelfFromRoomResponseApplicationJson_OcsInterface,
        Built<RoomRemoveSelfFromRoomResponseApplicationJson_Ocs,
            RoomRemoveSelfFromRoomResponseApplicationJson_OcsBuilder> {
  factory RoomRemoveSelfFromRoomResponseApplicationJson_Ocs([
    final void Function(RoomRemoveSelfFromRoomResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomRemoveSelfFromRoomResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomRemoveSelfFromRoomResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomRemoveSelfFromRoomResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomRemoveSelfFromRoomResponseApplicationJson_Ocs> get serializer =>
      _$roomRemoveSelfFromRoomResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomRemoveSelfFromRoomResponseApplicationJsonInterface {
  RoomRemoveSelfFromRoomResponseApplicationJson_Ocs get ocs;
}

abstract class RoomRemoveSelfFromRoomResponseApplicationJson
    implements
        RoomRemoveSelfFromRoomResponseApplicationJsonInterface,
        Built<RoomRemoveSelfFromRoomResponseApplicationJson, RoomRemoveSelfFromRoomResponseApplicationJsonBuilder> {
  factory RoomRemoveSelfFromRoomResponseApplicationJson([
    final void Function(RoomRemoveSelfFromRoomResponseApplicationJsonBuilder)? b,
  ]) = _$RoomRemoveSelfFromRoomResponseApplicationJson;

  // coverage:ignore-start
  const RoomRemoveSelfFromRoomResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomRemoveSelfFromRoomResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomRemoveSelfFromRoomResponseApplicationJson> get serializer =>
      _$roomRemoveSelfFromRoomResponseApplicationJsonSerializer;
}

class RoomRemoveAttendeeFromRoomApiVersion extends EnumClass {
  const RoomRemoveAttendeeFromRoomApiVersion._(super.name);

  static const RoomRemoveAttendeeFromRoomApiVersion v4 = _$roomRemoveAttendeeFromRoomApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomRemoveAttendeeFromRoomApiVersion> get values => _$roomRemoveAttendeeFromRoomApiVersionValues;
  // coverage:ignore-end
  static RoomRemoveAttendeeFromRoomApiVersion valueOf(final String name) =>
      _$valueOfRoomRemoveAttendeeFromRoomApiVersion(name);
  static Serializer<RoomRemoveAttendeeFromRoomApiVersion> get serializer =>
      _$roomRemoveAttendeeFromRoomApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomRemoveAttendeeFromRoomResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class RoomRemoveAttendeeFromRoomResponseApplicationJson_Ocs
    implements
        RoomRemoveAttendeeFromRoomResponseApplicationJson_OcsInterface,
        Built<RoomRemoveAttendeeFromRoomResponseApplicationJson_Ocs,
            RoomRemoveAttendeeFromRoomResponseApplicationJson_OcsBuilder> {
  factory RoomRemoveAttendeeFromRoomResponseApplicationJson_Ocs([
    final void Function(RoomRemoveAttendeeFromRoomResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomRemoveAttendeeFromRoomResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomRemoveAttendeeFromRoomResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomRemoveAttendeeFromRoomResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomRemoveAttendeeFromRoomResponseApplicationJson_Ocs> get serializer =>
      _$roomRemoveAttendeeFromRoomResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomRemoveAttendeeFromRoomResponseApplicationJsonInterface {
  RoomRemoveAttendeeFromRoomResponseApplicationJson_Ocs get ocs;
}

abstract class RoomRemoveAttendeeFromRoomResponseApplicationJson
    implements
        RoomRemoveAttendeeFromRoomResponseApplicationJsonInterface,
        Built<RoomRemoveAttendeeFromRoomResponseApplicationJson,
            RoomRemoveAttendeeFromRoomResponseApplicationJsonBuilder> {
  factory RoomRemoveAttendeeFromRoomResponseApplicationJson([
    final void Function(RoomRemoveAttendeeFromRoomResponseApplicationJsonBuilder)? b,
  ]) = _$RoomRemoveAttendeeFromRoomResponseApplicationJson;

  // coverage:ignore-start
  const RoomRemoveAttendeeFromRoomResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomRemoveAttendeeFromRoomResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomRemoveAttendeeFromRoomResponseApplicationJson> get serializer =>
      _$roomRemoveAttendeeFromRoomResponseApplicationJsonSerializer;
}

class RoomSetAttendeePermissionsApiVersion extends EnumClass {
  const RoomSetAttendeePermissionsApiVersion._(super.name);

  static const RoomSetAttendeePermissionsApiVersion v4 = _$roomSetAttendeePermissionsApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomSetAttendeePermissionsApiVersion> get values => _$roomSetAttendeePermissionsApiVersionValues;
  // coverage:ignore-end
  static RoomSetAttendeePermissionsApiVersion valueOf(final String name) =>
      _$valueOfRoomSetAttendeePermissionsApiVersion(name);
  static Serializer<RoomSetAttendeePermissionsApiVersion> get serializer =>
      _$roomSetAttendeePermissionsApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomSetAttendeePermissionsResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class RoomSetAttendeePermissionsResponseApplicationJson_Ocs
    implements
        RoomSetAttendeePermissionsResponseApplicationJson_OcsInterface,
        Built<RoomSetAttendeePermissionsResponseApplicationJson_Ocs,
            RoomSetAttendeePermissionsResponseApplicationJson_OcsBuilder> {
  factory RoomSetAttendeePermissionsResponseApplicationJson_Ocs([
    final void Function(RoomSetAttendeePermissionsResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomSetAttendeePermissionsResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomSetAttendeePermissionsResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomSetAttendeePermissionsResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomSetAttendeePermissionsResponseApplicationJson_Ocs> get serializer =>
      _$roomSetAttendeePermissionsResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomSetAttendeePermissionsResponseApplicationJsonInterface {
  RoomSetAttendeePermissionsResponseApplicationJson_Ocs get ocs;
}

abstract class RoomSetAttendeePermissionsResponseApplicationJson
    implements
        RoomSetAttendeePermissionsResponseApplicationJsonInterface,
        Built<RoomSetAttendeePermissionsResponseApplicationJson,
            RoomSetAttendeePermissionsResponseApplicationJsonBuilder> {
  factory RoomSetAttendeePermissionsResponseApplicationJson([
    final void Function(RoomSetAttendeePermissionsResponseApplicationJsonBuilder)? b,
  ]) = _$RoomSetAttendeePermissionsResponseApplicationJson;

  // coverage:ignore-start
  const RoomSetAttendeePermissionsResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomSetAttendeePermissionsResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomSetAttendeePermissionsResponseApplicationJson> get serializer =>
      _$roomSetAttendeePermissionsResponseApplicationJsonSerializer;
}

class RoomSetAllAttendeesPermissionsApiVersion extends EnumClass {
  const RoomSetAllAttendeesPermissionsApiVersion._(super.name);

  static const RoomSetAllAttendeesPermissionsApiVersion v4 = _$roomSetAllAttendeesPermissionsApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomSetAllAttendeesPermissionsApiVersion> get values =>
      _$roomSetAllAttendeesPermissionsApiVersionValues;
  // coverage:ignore-end
  static RoomSetAllAttendeesPermissionsApiVersion valueOf(final String name) =>
      _$valueOfRoomSetAllAttendeesPermissionsApiVersion(name);
  static Serializer<RoomSetAllAttendeesPermissionsApiVersion> get serializer =>
      _$roomSetAllAttendeesPermissionsApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomSetAllAttendeesPermissionsResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  Room get data;
}

abstract class RoomSetAllAttendeesPermissionsResponseApplicationJson_Ocs
    implements
        RoomSetAllAttendeesPermissionsResponseApplicationJson_OcsInterface,
        Built<RoomSetAllAttendeesPermissionsResponseApplicationJson_Ocs,
            RoomSetAllAttendeesPermissionsResponseApplicationJson_OcsBuilder> {
  factory RoomSetAllAttendeesPermissionsResponseApplicationJson_Ocs([
    final void Function(RoomSetAllAttendeesPermissionsResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomSetAllAttendeesPermissionsResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomSetAllAttendeesPermissionsResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomSetAllAttendeesPermissionsResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomSetAllAttendeesPermissionsResponseApplicationJson_Ocs> get serializer =>
      _$roomSetAllAttendeesPermissionsResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomSetAllAttendeesPermissionsResponseApplicationJsonInterface {
  RoomSetAllAttendeesPermissionsResponseApplicationJson_Ocs get ocs;
}

abstract class RoomSetAllAttendeesPermissionsResponseApplicationJson
    implements
        RoomSetAllAttendeesPermissionsResponseApplicationJsonInterface,
        Built<RoomSetAllAttendeesPermissionsResponseApplicationJson,
            RoomSetAllAttendeesPermissionsResponseApplicationJsonBuilder> {
  factory RoomSetAllAttendeesPermissionsResponseApplicationJson([
    final void Function(RoomSetAllAttendeesPermissionsResponseApplicationJsonBuilder)? b,
  ]) = _$RoomSetAllAttendeesPermissionsResponseApplicationJson;

  // coverage:ignore-start
  const RoomSetAllAttendeesPermissionsResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomSetAllAttendeesPermissionsResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomSetAllAttendeesPermissionsResponseApplicationJson> get serializer =>
      _$roomSetAllAttendeesPermissionsResponseApplicationJsonSerializer;
}

class RoomJoinRoomApiVersion extends EnumClass {
  const RoomJoinRoomApiVersion._(super.name);

  static const RoomJoinRoomApiVersion v4 = _$roomJoinRoomApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomJoinRoomApiVersion> get values => _$roomJoinRoomApiVersionValues;
  // coverage:ignore-end
  static RoomJoinRoomApiVersion valueOf(final String name) => _$valueOfRoomJoinRoomApiVersion(name);
  static Serializer<RoomJoinRoomApiVersion> get serializer => _$roomJoinRoomApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomJoinRoomResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  Room get data;
}

abstract class RoomJoinRoomResponseApplicationJson_Ocs
    implements
        RoomJoinRoomResponseApplicationJson_OcsInterface,
        Built<RoomJoinRoomResponseApplicationJson_Ocs, RoomJoinRoomResponseApplicationJson_OcsBuilder> {
  factory RoomJoinRoomResponseApplicationJson_Ocs([
    final void Function(RoomJoinRoomResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomJoinRoomResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomJoinRoomResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomJoinRoomResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomJoinRoomResponseApplicationJson_Ocs> get serializer =>
      _$roomJoinRoomResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomJoinRoomResponseApplicationJsonInterface {
  RoomJoinRoomResponseApplicationJson_Ocs get ocs;
}

abstract class RoomJoinRoomResponseApplicationJson
    implements
        RoomJoinRoomResponseApplicationJsonInterface,
        Built<RoomJoinRoomResponseApplicationJson, RoomJoinRoomResponseApplicationJsonBuilder> {
  factory RoomJoinRoomResponseApplicationJson([final void Function(RoomJoinRoomResponseApplicationJsonBuilder)? b]) =
      _$RoomJoinRoomResponseApplicationJson;

  // coverage:ignore-start
  const RoomJoinRoomResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomJoinRoomResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomJoinRoomResponseApplicationJson> get serializer =>
      _$roomJoinRoomResponseApplicationJsonSerializer;
}

class RoomLeaveRoomApiVersion extends EnumClass {
  const RoomLeaveRoomApiVersion._(super.name);

  static const RoomLeaveRoomApiVersion v4 = _$roomLeaveRoomApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomLeaveRoomApiVersion> get values => _$roomLeaveRoomApiVersionValues;
  // coverage:ignore-end
  static RoomLeaveRoomApiVersion valueOf(final String name) => _$valueOfRoomLeaveRoomApiVersion(name);
  static Serializer<RoomLeaveRoomApiVersion> get serializer => _$roomLeaveRoomApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomLeaveRoomResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class RoomLeaveRoomResponseApplicationJson_Ocs
    implements
        RoomLeaveRoomResponseApplicationJson_OcsInterface,
        Built<RoomLeaveRoomResponseApplicationJson_Ocs, RoomLeaveRoomResponseApplicationJson_OcsBuilder> {
  factory RoomLeaveRoomResponseApplicationJson_Ocs([
    final void Function(RoomLeaveRoomResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomLeaveRoomResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomLeaveRoomResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomLeaveRoomResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomLeaveRoomResponseApplicationJson_Ocs> get serializer =>
      _$roomLeaveRoomResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomLeaveRoomResponseApplicationJsonInterface {
  RoomLeaveRoomResponseApplicationJson_Ocs get ocs;
}

abstract class RoomLeaveRoomResponseApplicationJson
    implements
        RoomLeaveRoomResponseApplicationJsonInterface,
        Built<RoomLeaveRoomResponseApplicationJson, RoomLeaveRoomResponseApplicationJsonBuilder> {
  factory RoomLeaveRoomResponseApplicationJson([final void Function(RoomLeaveRoomResponseApplicationJsonBuilder)? b]) =
      _$RoomLeaveRoomResponseApplicationJson;

  // coverage:ignore-start
  const RoomLeaveRoomResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomLeaveRoomResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomLeaveRoomResponseApplicationJson> get serializer =>
      _$roomLeaveRoomResponseApplicationJsonSerializer;
}

class RoomResendInvitationsApiVersion extends EnumClass {
  const RoomResendInvitationsApiVersion._(super.name);

  static const RoomResendInvitationsApiVersion v4 = _$roomResendInvitationsApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomResendInvitationsApiVersion> get values => _$roomResendInvitationsApiVersionValues;
  // coverage:ignore-end
  static RoomResendInvitationsApiVersion valueOf(final String name) => _$valueOfRoomResendInvitationsApiVersion(name);
  static Serializer<RoomResendInvitationsApiVersion> get serializer => _$roomResendInvitationsApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomResendInvitationsResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class RoomResendInvitationsResponseApplicationJson_Ocs
    implements
        RoomResendInvitationsResponseApplicationJson_OcsInterface,
        Built<RoomResendInvitationsResponseApplicationJson_Ocs,
            RoomResendInvitationsResponseApplicationJson_OcsBuilder> {
  factory RoomResendInvitationsResponseApplicationJson_Ocs([
    final void Function(RoomResendInvitationsResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomResendInvitationsResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomResendInvitationsResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomResendInvitationsResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomResendInvitationsResponseApplicationJson_Ocs> get serializer =>
      _$roomResendInvitationsResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomResendInvitationsResponseApplicationJsonInterface {
  RoomResendInvitationsResponseApplicationJson_Ocs get ocs;
}

abstract class RoomResendInvitationsResponseApplicationJson
    implements
        RoomResendInvitationsResponseApplicationJsonInterface,
        Built<RoomResendInvitationsResponseApplicationJson, RoomResendInvitationsResponseApplicationJsonBuilder> {
  factory RoomResendInvitationsResponseApplicationJson([
    final void Function(RoomResendInvitationsResponseApplicationJsonBuilder)? b,
  ]) = _$RoomResendInvitationsResponseApplicationJson;

  // coverage:ignore-start
  const RoomResendInvitationsResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomResendInvitationsResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomResendInvitationsResponseApplicationJson> get serializer =>
      _$roomResendInvitationsResponseApplicationJsonSerializer;
}

class RoomSetSessionStateApiVersion extends EnumClass {
  const RoomSetSessionStateApiVersion._(super.name);

  static const RoomSetSessionStateApiVersion v4 = _$roomSetSessionStateApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomSetSessionStateApiVersion> get values => _$roomSetSessionStateApiVersionValues;
  // coverage:ignore-end
  static RoomSetSessionStateApiVersion valueOf(final String name) => _$valueOfRoomSetSessionStateApiVersion(name);
  static Serializer<RoomSetSessionStateApiVersion> get serializer => _$roomSetSessionStateApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomSetSessionStateResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  Room get data;
}

abstract class RoomSetSessionStateResponseApplicationJson_Ocs
    implements
        RoomSetSessionStateResponseApplicationJson_OcsInterface,
        Built<RoomSetSessionStateResponseApplicationJson_Ocs, RoomSetSessionStateResponseApplicationJson_OcsBuilder> {
  factory RoomSetSessionStateResponseApplicationJson_Ocs([
    final void Function(RoomSetSessionStateResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomSetSessionStateResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomSetSessionStateResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomSetSessionStateResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomSetSessionStateResponseApplicationJson_Ocs> get serializer =>
      _$roomSetSessionStateResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomSetSessionStateResponseApplicationJsonInterface {
  RoomSetSessionStateResponseApplicationJson_Ocs get ocs;
}

abstract class RoomSetSessionStateResponseApplicationJson
    implements
        RoomSetSessionStateResponseApplicationJsonInterface,
        Built<RoomSetSessionStateResponseApplicationJson, RoomSetSessionStateResponseApplicationJsonBuilder> {
  factory RoomSetSessionStateResponseApplicationJson([
    final void Function(RoomSetSessionStateResponseApplicationJsonBuilder)? b,
  ]) = _$RoomSetSessionStateResponseApplicationJson;

  // coverage:ignore-start
  const RoomSetSessionStateResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomSetSessionStateResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomSetSessionStateResponseApplicationJson> get serializer =>
      _$roomSetSessionStateResponseApplicationJsonSerializer;
}

class RoomPromoteModeratorApiVersion extends EnumClass {
  const RoomPromoteModeratorApiVersion._(super.name);

  static const RoomPromoteModeratorApiVersion v4 = _$roomPromoteModeratorApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomPromoteModeratorApiVersion> get values => _$roomPromoteModeratorApiVersionValues;
  // coverage:ignore-end
  static RoomPromoteModeratorApiVersion valueOf(final String name) => _$valueOfRoomPromoteModeratorApiVersion(name);
  static Serializer<RoomPromoteModeratorApiVersion> get serializer => _$roomPromoteModeratorApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomPromoteModeratorResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class RoomPromoteModeratorResponseApplicationJson_Ocs
    implements
        RoomPromoteModeratorResponseApplicationJson_OcsInterface,
        Built<RoomPromoteModeratorResponseApplicationJson_Ocs, RoomPromoteModeratorResponseApplicationJson_OcsBuilder> {
  factory RoomPromoteModeratorResponseApplicationJson_Ocs([
    final void Function(RoomPromoteModeratorResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomPromoteModeratorResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomPromoteModeratorResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomPromoteModeratorResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomPromoteModeratorResponseApplicationJson_Ocs> get serializer =>
      _$roomPromoteModeratorResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomPromoteModeratorResponseApplicationJsonInterface {
  RoomPromoteModeratorResponseApplicationJson_Ocs get ocs;
}

abstract class RoomPromoteModeratorResponseApplicationJson
    implements
        RoomPromoteModeratorResponseApplicationJsonInterface,
        Built<RoomPromoteModeratorResponseApplicationJson, RoomPromoteModeratorResponseApplicationJsonBuilder> {
  factory RoomPromoteModeratorResponseApplicationJson([
    final void Function(RoomPromoteModeratorResponseApplicationJsonBuilder)? b,
  ]) = _$RoomPromoteModeratorResponseApplicationJson;

  // coverage:ignore-start
  const RoomPromoteModeratorResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomPromoteModeratorResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomPromoteModeratorResponseApplicationJson> get serializer =>
      _$roomPromoteModeratorResponseApplicationJsonSerializer;
}

class RoomDemoteModeratorApiVersion extends EnumClass {
  const RoomDemoteModeratorApiVersion._(super.name);

  static const RoomDemoteModeratorApiVersion v4 = _$roomDemoteModeratorApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomDemoteModeratorApiVersion> get values => _$roomDemoteModeratorApiVersionValues;
  // coverage:ignore-end
  static RoomDemoteModeratorApiVersion valueOf(final String name) => _$valueOfRoomDemoteModeratorApiVersion(name);
  static Serializer<RoomDemoteModeratorApiVersion> get serializer => _$roomDemoteModeratorApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomDemoteModeratorResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class RoomDemoteModeratorResponseApplicationJson_Ocs
    implements
        RoomDemoteModeratorResponseApplicationJson_OcsInterface,
        Built<RoomDemoteModeratorResponseApplicationJson_Ocs, RoomDemoteModeratorResponseApplicationJson_OcsBuilder> {
  factory RoomDemoteModeratorResponseApplicationJson_Ocs([
    final void Function(RoomDemoteModeratorResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomDemoteModeratorResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomDemoteModeratorResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomDemoteModeratorResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomDemoteModeratorResponseApplicationJson_Ocs> get serializer =>
      _$roomDemoteModeratorResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomDemoteModeratorResponseApplicationJsonInterface {
  RoomDemoteModeratorResponseApplicationJson_Ocs get ocs;
}

abstract class RoomDemoteModeratorResponseApplicationJson
    implements
        RoomDemoteModeratorResponseApplicationJsonInterface,
        Built<RoomDemoteModeratorResponseApplicationJson, RoomDemoteModeratorResponseApplicationJsonBuilder> {
  factory RoomDemoteModeratorResponseApplicationJson([
    final void Function(RoomDemoteModeratorResponseApplicationJsonBuilder)? b,
  ]) = _$RoomDemoteModeratorResponseApplicationJson;

  // coverage:ignore-start
  const RoomDemoteModeratorResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomDemoteModeratorResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomDemoteModeratorResponseApplicationJson> get serializer =>
      _$roomDemoteModeratorResponseApplicationJsonSerializer;
}

class RoomAddToFavoritesApiVersion extends EnumClass {
  const RoomAddToFavoritesApiVersion._(super.name);

  static const RoomAddToFavoritesApiVersion v4 = _$roomAddToFavoritesApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomAddToFavoritesApiVersion> get values => _$roomAddToFavoritesApiVersionValues;
  // coverage:ignore-end
  static RoomAddToFavoritesApiVersion valueOf(final String name) => _$valueOfRoomAddToFavoritesApiVersion(name);
  static Serializer<RoomAddToFavoritesApiVersion> get serializer => _$roomAddToFavoritesApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomAddToFavoritesResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class RoomAddToFavoritesResponseApplicationJson_Ocs
    implements
        RoomAddToFavoritesResponseApplicationJson_OcsInterface,
        Built<RoomAddToFavoritesResponseApplicationJson_Ocs, RoomAddToFavoritesResponseApplicationJson_OcsBuilder> {
  factory RoomAddToFavoritesResponseApplicationJson_Ocs([
    final void Function(RoomAddToFavoritesResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomAddToFavoritesResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomAddToFavoritesResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomAddToFavoritesResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomAddToFavoritesResponseApplicationJson_Ocs> get serializer =>
      _$roomAddToFavoritesResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomAddToFavoritesResponseApplicationJsonInterface {
  RoomAddToFavoritesResponseApplicationJson_Ocs get ocs;
}

abstract class RoomAddToFavoritesResponseApplicationJson
    implements
        RoomAddToFavoritesResponseApplicationJsonInterface,
        Built<RoomAddToFavoritesResponseApplicationJson, RoomAddToFavoritesResponseApplicationJsonBuilder> {
  factory RoomAddToFavoritesResponseApplicationJson([
    final void Function(RoomAddToFavoritesResponseApplicationJsonBuilder)? b,
  ]) = _$RoomAddToFavoritesResponseApplicationJson;

  // coverage:ignore-start
  const RoomAddToFavoritesResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomAddToFavoritesResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomAddToFavoritesResponseApplicationJson> get serializer =>
      _$roomAddToFavoritesResponseApplicationJsonSerializer;
}

class RoomRemoveFromFavoritesApiVersion extends EnumClass {
  const RoomRemoveFromFavoritesApiVersion._(super.name);

  static const RoomRemoveFromFavoritesApiVersion v4 = _$roomRemoveFromFavoritesApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomRemoveFromFavoritesApiVersion> get values => _$roomRemoveFromFavoritesApiVersionValues;
  // coverage:ignore-end
  static RoomRemoveFromFavoritesApiVersion valueOf(final String name) =>
      _$valueOfRoomRemoveFromFavoritesApiVersion(name);
  static Serializer<RoomRemoveFromFavoritesApiVersion> get serializer => _$roomRemoveFromFavoritesApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomRemoveFromFavoritesResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class RoomRemoveFromFavoritesResponseApplicationJson_Ocs
    implements
        RoomRemoveFromFavoritesResponseApplicationJson_OcsInterface,
        Built<RoomRemoveFromFavoritesResponseApplicationJson_Ocs,
            RoomRemoveFromFavoritesResponseApplicationJson_OcsBuilder> {
  factory RoomRemoveFromFavoritesResponseApplicationJson_Ocs([
    final void Function(RoomRemoveFromFavoritesResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomRemoveFromFavoritesResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomRemoveFromFavoritesResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomRemoveFromFavoritesResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomRemoveFromFavoritesResponseApplicationJson_Ocs> get serializer =>
      _$roomRemoveFromFavoritesResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomRemoveFromFavoritesResponseApplicationJsonInterface {
  RoomRemoveFromFavoritesResponseApplicationJson_Ocs get ocs;
}

abstract class RoomRemoveFromFavoritesResponseApplicationJson
    implements
        RoomRemoveFromFavoritesResponseApplicationJsonInterface,
        Built<RoomRemoveFromFavoritesResponseApplicationJson, RoomRemoveFromFavoritesResponseApplicationJsonBuilder> {
  factory RoomRemoveFromFavoritesResponseApplicationJson([
    final void Function(RoomRemoveFromFavoritesResponseApplicationJsonBuilder)? b,
  ]) = _$RoomRemoveFromFavoritesResponseApplicationJson;

  // coverage:ignore-start
  const RoomRemoveFromFavoritesResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomRemoveFromFavoritesResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomRemoveFromFavoritesResponseApplicationJson> get serializer =>
      _$roomRemoveFromFavoritesResponseApplicationJsonSerializer;
}

class RoomSetNotificationLevelApiVersion extends EnumClass {
  const RoomSetNotificationLevelApiVersion._(super.name);

  static const RoomSetNotificationLevelApiVersion v4 = _$roomSetNotificationLevelApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomSetNotificationLevelApiVersion> get values => _$roomSetNotificationLevelApiVersionValues;
  // coverage:ignore-end
  static RoomSetNotificationLevelApiVersion valueOf(final String name) =>
      _$valueOfRoomSetNotificationLevelApiVersion(name);
  static Serializer<RoomSetNotificationLevelApiVersion> get serializer =>
      _$roomSetNotificationLevelApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomSetNotificationLevelResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class RoomSetNotificationLevelResponseApplicationJson_Ocs
    implements
        RoomSetNotificationLevelResponseApplicationJson_OcsInterface,
        Built<RoomSetNotificationLevelResponseApplicationJson_Ocs,
            RoomSetNotificationLevelResponseApplicationJson_OcsBuilder> {
  factory RoomSetNotificationLevelResponseApplicationJson_Ocs([
    final void Function(RoomSetNotificationLevelResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomSetNotificationLevelResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomSetNotificationLevelResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomSetNotificationLevelResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomSetNotificationLevelResponseApplicationJson_Ocs> get serializer =>
      _$roomSetNotificationLevelResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomSetNotificationLevelResponseApplicationJsonInterface {
  RoomSetNotificationLevelResponseApplicationJson_Ocs get ocs;
}

abstract class RoomSetNotificationLevelResponseApplicationJson
    implements
        RoomSetNotificationLevelResponseApplicationJsonInterface,
        Built<RoomSetNotificationLevelResponseApplicationJson, RoomSetNotificationLevelResponseApplicationJsonBuilder> {
  factory RoomSetNotificationLevelResponseApplicationJson([
    final void Function(RoomSetNotificationLevelResponseApplicationJsonBuilder)? b,
  ]) = _$RoomSetNotificationLevelResponseApplicationJson;

  // coverage:ignore-start
  const RoomSetNotificationLevelResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomSetNotificationLevelResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomSetNotificationLevelResponseApplicationJson> get serializer =>
      _$roomSetNotificationLevelResponseApplicationJsonSerializer;
}

class RoomSetNotificationCallsApiVersion extends EnumClass {
  const RoomSetNotificationCallsApiVersion._(super.name);

  static const RoomSetNotificationCallsApiVersion v4 = _$roomSetNotificationCallsApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomSetNotificationCallsApiVersion> get values => _$roomSetNotificationCallsApiVersionValues;
  // coverage:ignore-end
  static RoomSetNotificationCallsApiVersion valueOf(final String name) =>
      _$valueOfRoomSetNotificationCallsApiVersion(name);
  static Serializer<RoomSetNotificationCallsApiVersion> get serializer =>
      _$roomSetNotificationCallsApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomSetNotificationCallsResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class RoomSetNotificationCallsResponseApplicationJson_Ocs
    implements
        RoomSetNotificationCallsResponseApplicationJson_OcsInterface,
        Built<RoomSetNotificationCallsResponseApplicationJson_Ocs,
            RoomSetNotificationCallsResponseApplicationJson_OcsBuilder> {
  factory RoomSetNotificationCallsResponseApplicationJson_Ocs([
    final void Function(RoomSetNotificationCallsResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomSetNotificationCallsResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomSetNotificationCallsResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomSetNotificationCallsResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomSetNotificationCallsResponseApplicationJson_Ocs> get serializer =>
      _$roomSetNotificationCallsResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomSetNotificationCallsResponseApplicationJsonInterface {
  RoomSetNotificationCallsResponseApplicationJson_Ocs get ocs;
}

abstract class RoomSetNotificationCallsResponseApplicationJson
    implements
        RoomSetNotificationCallsResponseApplicationJsonInterface,
        Built<RoomSetNotificationCallsResponseApplicationJson, RoomSetNotificationCallsResponseApplicationJsonBuilder> {
  factory RoomSetNotificationCallsResponseApplicationJson([
    final void Function(RoomSetNotificationCallsResponseApplicationJsonBuilder)? b,
  ]) = _$RoomSetNotificationCallsResponseApplicationJson;

  // coverage:ignore-start
  const RoomSetNotificationCallsResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomSetNotificationCallsResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomSetNotificationCallsResponseApplicationJson> get serializer =>
      _$roomSetNotificationCallsResponseApplicationJsonSerializer;
}

class RoomSetLobbyApiVersion extends EnumClass {
  const RoomSetLobbyApiVersion._(super.name);

  static const RoomSetLobbyApiVersion v4 = _$roomSetLobbyApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomSetLobbyApiVersion> get values => _$roomSetLobbyApiVersionValues;
  // coverage:ignore-end
  static RoomSetLobbyApiVersion valueOf(final String name) => _$valueOfRoomSetLobbyApiVersion(name);
  static Serializer<RoomSetLobbyApiVersion> get serializer => _$roomSetLobbyApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomSetLobbyResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  Room get data;
}

abstract class RoomSetLobbyResponseApplicationJson_Ocs
    implements
        RoomSetLobbyResponseApplicationJson_OcsInterface,
        Built<RoomSetLobbyResponseApplicationJson_Ocs, RoomSetLobbyResponseApplicationJson_OcsBuilder> {
  factory RoomSetLobbyResponseApplicationJson_Ocs([
    final void Function(RoomSetLobbyResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomSetLobbyResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomSetLobbyResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomSetLobbyResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomSetLobbyResponseApplicationJson_Ocs> get serializer =>
      _$roomSetLobbyResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomSetLobbyResponseApplicationJsonInterface {
  RoomSetLobbyResponseApplicationJson_Ocs get ocs;
}

abstract class RoomSetLobbyResponseApplicationJson
    implements
        RoomSetLobbyResponseApplicationJsonInterface,
        Built<RoomSetLobbyResponseApplicationJson, RoomSetLobbyResponseApplicationJsonBuilder> {
  factory RoomSetLobbyResponseApplicationJson([final void Function(RoomSetLobbyResponseApplicationJsonBuilder)? b]) =
      _$RoomSetLobbyResponseApplicationJson;

  // coverage:ignore-start
  const RoomSetLobbyResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomSetLobbyResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomSetLobbyResponseApplicationJson> get serializer =>
      _$roomSetLobbyResponseApplicationJsonSerializer;
}

class RoomSetsipEnabledApiVersion extends EnumClass {
  const RoomSetsipEnabledApiVersion._(super.name);

  static const RoomSetsipEnabledApiVersion v4 = _$roomSetsipEnabledApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomSetsipEnabledApiVersion> get values => _$roomSetsipEnabledApiVersionValues;
  // coverage:ignore-end
  static RoomSetsipEnabledApiVersion valueOf(final String name) => _$valueOfRoomSetsipEnabledApiVersion(name);
  static Serializer<RoomSetsipEnabledApiVersion> get serializer => _$roomSetsipEnabledApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomSetsipEnabledResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  Room get data;
}

abstract class RoomSetsipEnabledResponseApplicationJson_Ocs
    implements
        RoomSetsipEnabledResponseApplicationJson_OcsInterface,
        Built<RoomSetsipEnabledResponseApplicationJson_Ocs, RoomSetsipEnabledResponseApplicationJson_OcsBuilder> {
  factory RoomSetsipEnabledResponseApplicationJson_Ocs([
    final void Function(RoomSetsipEnabledResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomSetsipEnabledResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomSetsipEnabledResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomSetsipEnabledResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomSetsipEnabledResponseApplicationJson_Ocs> get serializer =>
      _$roomSetsipEnabledResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomSetsipEnabledResponseApplicationJsonInterface {
  RoomSetsipEnabledResponseApplicationJson_Ocs get ocs;
}

abstract class RoomSetsipEnabledResponseApplicationJson
    implements
        RoomSetsipEnabledResponseApplicationJsonInterface,
        Built<RoomSetsipEnabledResponseApplicationJson, RoomSetsipEnabledResponseApplicationJsonBuilder> {
  factory RoomSetsipEnabledResponseApplicationJson([
    final void Function(RoomSetsipEnabledResponseApplicationJsonBuilder)? b,
  ]) = _$RoomSetsipEnabledResponseApplicationJson;

  // coverage:ignore-start
  const RoomSetsipEnabledResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomSetsipEnabledResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomSetsipEnabledResponseApplicationJson> get serializer =>
      _$roomSetsipEnabledResponseApplicationJsonSerializer;
}

class RoomSetRecordingConsentApiVersion extends EnumClass {
  const RoomSetRecordingConsentApiVersion._(super.name);

  static const RoomSetRecordingConsentApiVersion v4 = _$roomSetRecordingConsentApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomSetRecordingConsentApiVersion> get values => _$roomSetRecordingConsentApiVersionValues;
  // coverage:ignore-end
  static RoomSetRecordingConsentApiVersion valueOf(final String name) =>
      _$valueOfRoomSetRecordingConsentApiVersion(name);
  static Serializer<RoomSetRecordingConsentApiVersion> get serializer => _$roomSetRecordingConsentApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomSetRecordingConsentResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  Room get data;
}

abstract class RoomSetRecordingConsentResponseApplicationJson_Ocs
    implements
        RoomSetRecordingConsentResponseApplicationJson_OcsInterface,
        Built<RoomSetRecordingConsentResponseApplicationJson_Ocs,
            RoomSetRecordingConsentResponseApplicationJson_OcsBuilder> {
  factory RoomSetRecordingConsentResponseApplicationJson_Ocs([
    final void Function(RoomSetRecordingConsentResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomSetRecordingConsentResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomSetRecordingConsentResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomSetRecordingConsentResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomSetRecordingConsentResponseApplicationJson_Ocs> get serializer =>
      _$roomSetRecordingConsentResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomSetRecordingConsentResponseApplicationJsonInterface {
  RoomSetRecordingConsentResponseApplicationJson_Ocs get ocs;
}

abstract class RoomSetRecordingConsentResponseApplicationJson
    implements
        RoomSetRecordingConsentResponseApplicationJsonInterface,
        Built<RoomSetRecordingConsentResponseApplicationJson, RoomSetRecordingConsentResponseApplicationJsonBuilder> {
  factory RoomSetRecordingConsentResponseApplicationJson([
    final void Function(RoomSetRecordingConsentResponseApplicationJsonBuilder)? b,
  ]) = _$RoomSetRecordingConsentResponseApplicationJson;

  // coverage:ignore-start
  const RoomSetRecordingConsentResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomSetRecordingConsentResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomSetRecordingConsentResponseApplicationJson> get serializer =>
      _$roomSetRecordingConsentResponseApplicationJsonSerializer;
}

class RoomSetMessageExpirationApiVersion extends EnumClass {
  const RoomSetMessageExpirationApiVersion._(super.name);

  static const RoomSetMessageExpirationApiVersion v4 = _$roomSetMessageExpirationApiVersionV4;

  // coverage:ignore-start
  static BuiltSet<RoomSetMessageExpirationApiVersion> get values => _$roomSetMessageExpirationApiVersionValues;
  // coverage:ignore-end
  static RoomSetMessageExpirationApiVersion valueOf(final String name) =>
      _$valueOfRoomSetMessageExpirationApiVersion(name);
  static Serializer<RoomSetMessageExpirationApiVersion> get serializer =>
      _$roomSetMessageExpirationApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomSetMessageExpirationResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class RoomSetMessageExpirationResponseApplicationJson_Ocs
    implements
        RoomSetMessageExpirationResponseApplicationJson_OcsInterface,
        Built<RoomSetMessageExpirationResponseApplicationJson_Ocs,
            RoomSetMessageExpirationResponseApplicationJson_OcsBuilder> {
  factory RoomSetMessageExpirationResponseApplicationJson_Ocs([
    final void Function(RoomSetMessageExpirationResponseApplicationJson_OcsBuilder)? b,
  ]) = _$RoomSetMessageExpirationResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const RoomSetMessageExpirationResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomSetMessageExpirationResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomSetMessageExpirationResponseApplicationJson_Ocs> get serializer =>
      _$roomSetMessageExpirationResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class RoomSetMessageExpirationResponseApplicationJsonInterface {
  RoomSetMessageExpirationResponseApplicationJson_Ocs get ocs;
}

abstract class RoomSetMessageExpirationResponseApplicationJson
    implements
        RoomSetMessageExpirationResponseApplicationJsonInterface,
        Built<RoomSetMessageExpirationResponseApplicationJson, RoomSetMessageExpirationResponseApplicationJsonBuilder> {
  factory RoomSetMessageExpirationResponseApplicationJson([
    final void Function(RoomSetMessageExpirationResponseApplicationJsonBuilder)? b,
  ]) = _$RoomSetMessageExpirationResponseApplicationJson;

  // coverage:ignore-start
  const RoomSetMessageExpirationResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory RoomSetMessageExpirationResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<RoomSetMessageExpirationResponseApplicationJson> get serializer =>
      _$roomSetMessageExpirationResponseApplicationJsonSerializer;
}

class SettingsSetsipSettingsApiVersion extends EnumClass {
  const SettingsSetsipSettingsApiVersion._(super.name);

  static const SettingsSetsipSettingsApiVersion v1 = _$settingsSetsipSettingsApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<SettingsSetsipSettingsApiVersion> get values => _$settingsSetsipSettingsApiVersionValues;
  // coverage:ignore-end
  static SettingsSetsipSettingsApiVersion valueOf(final String name) => _$valueOfSettingsSetsipSettingsApiVersion(name);
  static Serializer<SettingsSetsipSettingsApiVersion> get serializer => _$settingsSetsipSettingsApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class SettingsSetsipSettingsResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class SettingsSetsipSettingsResponseApplicationJson_Ocs
    implements
        SettingsSetsipSettingsResponseApplicationJson_OcsInterface,
        Built<SettingsSetsipSettingsResponseApplicationJson_Ocs,
            SettingsSetsipSettingsResponseApplicationJson_OcsBuilder> {
  factory SettingsSetsipSettingsResponseApplicationJson_Ocs([
    final void Function(SettingsSetsipSettingsResponseApplicationJson_OcsBuilder)? b,
  ]) = _$SettingsSetsipSettingsResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const SettingsSetsipSettingsResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory SettingsSetsipSettingsResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<SettingsSetsipSettingsResponseApplicationJson_Ocs> get serializer =>
      _$settingsSetsipSettingsResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class SettingsSetsipSettingsResponseApplicationJsonInterface {
  SettingsSetsipSettingsResponseApplicationJson_Ocs get ocs;
}

abstract class SettingsSetsipSettingsResponseApplicationJson
    implements
        SettingsSetsipSettingsResponseApplicationJsonInterface,
        Built<SettingsSetsipSettingsResponseApplicationJson, SettingsSetsipSettingsResponseApplicationJsonBuilder> {
  factory SettingsSetsipSettingsResponseApplicationJson([
    final void Function(SettingsSetsipSettingsResponseApplicationJsonBuilder)? b,
  ]) = _$SettingsSetsipSettingsResponseApplicationJson;

  // coverage:ignore-start
  const SettingsSetsipSettingsResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory SettingsSetsipSettingsResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<SettingsSetsipSettingsResponseApplicationJson> get serializer =>
      _$settingsSetsipSettingsResponseApplicationJsonSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class SettingsSetUserSettingValueInterface {
  String? get string;
  int? get $int;
}

abstract class SettingsSetUserSettingValue
    implements
        SettingsSetUserSettingValueInterface,
        Built<SettingsSetUserSettingValue, SettingsSetUserSettingValueBuilder> {
  factory SettingsSetUserSettingValue([final void Function(SettingsSetUserSettingValueBuilder)? b]) =
      _$SettingsSetUserSettingValue;

  // coverage:ignore-start
  const SettingsSetUserSettingValue._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory SettingsSetUserSettingValue.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  @BuiltValueSerializer(custom: true)
  static Serializer<SettingsSetUserSettingValue> get serializer => _$SettingsSetUserSettingValueSerializer();
  JsonObject get data;
  @BuiltValueHook(finalizeBuilder: true)
  static void _validate(final SettingsSetUserSettingValueBuilder b) {
    // When this is rebuild from another builder
    if (b._data == null) {
      return;
    }

    final match = [b._string, b._$int].singleWhereOrNull((final x) => x != null);
    if (match == null) {
      throw StateError("Need exactly one of 'string', '$int' for ${b._data}");
    }
  }
}

class _$SettingsSetUserSettingValueSerializer implements PrimitiveSerializer<SettingsSetUserSettingValue> {
  @override
  final Iterable<Type> types = const [SettingsSetUserSettingValue, _$SettingsSetUserSettingValue];

  @override
  final String wireName = 'SettingsSetUserSettingValue';

  @override
  Object serialize(
    final Serializers serializers,
    final SettingsSetUserSettingValue object, {
    final FullType specifiedType = FullType.unspecified,
  }) =>
      object.data.value;

  @override
  SettingsSetUserSettingValue deserialize(
    final Serializers serializers,
    final Object data, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    final result = SettingsSetUserSettingValueBuilder()..data = JsonObject(data);
    try {
      final value = _jsonSerializers.deserialize(data, specifiedType: const FullType(String))! as String;
      result.string = value;
    } catch (_) {}
    try {
      final value = _jsonSerializers.deserialize(data, specifiedType: const FullType(int))! as int;
      result.$int = value;
    } catch (_) {}
    return result.build();
  }
}

class SettingsSetUserSettingApiVersion extends EnumClass {
  const SettingsSetUserSettingApiVersion._(super.name);

  static const SettingsSetUserSettingApiVersion v1 = _$settingsSetUserSettingApiVersionV1;

  // coverage:ignore-start
  static BuiltSet<SettingsSetUserSettingApiVersion> get values => _$settingsSetUserSettingApiVersionValues;
  // coverage:ignore-end
  static SettingsSetUserSettingApiVersion valueOf(final String name) => _$valueOfSettingsSetUserSettingApiVersion(name);
  static Serializer<SettingsSetUserSettingApiVersion> get serializer => _$settingsSetUserSettingApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class SettingsSetUserSettingResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class SettingsSetUserSettingResponseApplicationJson_Ocs
    implements
        SettingsSetUserSettingResponseApplicationJson_OcsInterface,
        Built<SettingsSetUserSettingResponseApplicationJson_Ocs,
            SettingsSetUserSettingResponseApplicationJson_OcsBuilder> {
  factory SettingsSetUserSettingResponseApplicationJson_Ocs([
    final void Function(SettingsSetUserSettingResponseApplicationJson_OcsBuilder)? b,
  ]) = _$SettingsSetUserSettingResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const SettingsSetUserSettingResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory SettingsSetUserSettingResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<SettingsSetUserSettingResponseApplicationJson_Ocs> get serializer =>
      _$settingsSetUserSettingResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class SettingsSetUserSettingResponseApplicationJsonInterface {
  SettingsSetUserSettingResponseApplicationJson_Ocs get ocs;
}

abstract class SettingsSetUserSettingResponseApplicationJson
    implements
        SettingsSetUserSettingResponseApplicationJsonInterface,
        Built<SettingsSetUserSettingResponseApplicationJson, SettingsSetUserSettingResponseApplicationJsonBuilder> {
  factory SettingsSetUserSettingResponseApplicationJson([
    final void Function(SettingsSetUserSettingResponseApplicationJsonBuilder)? b,
  ]) = _$SettingsSetUserSettingResponseApplicationJson;

  // coverage:ignore-start
  const SettingsSetUserSettingResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory SettingsSetUserSettingResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<SettingsSetUserSettingResponseApplicationJson> get serializer =>
      _$settingsSetUserSettingResponseApplicationJsonSerializer;
}

class SignalingGetSettingsApiVersion extends EnumClass {
  const SignalingGetSettingsApiVersion._(super.name);

  static const SignalingGetSettingsApiVersion v3 = _$signalingGetSettingsApiVersionV3;

  // coverage:ignore-start
  static BuiltSet<SignalingGetSettingsApiVersion> get values => _$signalingGetSettingsApiVersionValues;
  // coverage:ignore-end
  static SignalingGetSettingsApiVersion valueOf(final String name) => _$valueOfSignalingGetSettingsApiVersion(name);
  static Serializer<SignalingGetSettingsApiVersion> get serializer => _$signalingGetSettingsApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class SignalingSettings_HelloAuthParams_$10Interface {
  String? get userid;
  String get ticket;
}

abstract class SignalingSettings_HelloAuthParams_$10
    implements
        SignalingSettings_HelloAuthParams_$10Interface,
        Built<SignalingSettings_HelloAuthParams_$10, SignalingSettings_HelloAuthParams_$10Builder> {
  factory SignalingSettings_HelloAuthParams_$10([
    final void Function(SignalingSettings_HelloAuthParams_$10Builder)? b,
  ]) = _$SignalingSettings_HelloAuthParams_$10;

  // coverage:ignore-start
  const SignalingSettings_HelloAuthParams_$10._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory SignalingSettings_HelloAuthParams_$10.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<SignalingSettings_HelloAuthParams_$10> get serializer =>
      _$signalingSettingsHelloAuthParams$10Serializer;
}

@BuiltValue(instantiable: false)
abstract interface class SignalingSettings_HelloAuthParams_$20Interface {
  String get token;
}

abstract class SignalingSettings_HelloAuthParams_$20
    implements
        SignalingSettings_HelloAuthParams_$20Interface,
        Built<SignalingSettings_HelloAuthParams_$20, SignalingSettings_HelloAuthParams_$20Builder> {
  factory SignalingSettings_HelloAuthParams_$20([
    final void Function(SignalingSettings_HelloAuthParams_$20Builder)? b,
  ]) = _$SignalingSettings_HelloAuthParams_$20;

  // coverage:ignore-start
  const SignalingSettings_HelloAuthParams_$20._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory SignalingSettings_HelloAuthParams_$20.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<SignalingSettings_HelloAuthParams_$20> get serializer =>
      _$signalingSettingsHelloAuthParams$20Serializer;
}

@BuiltValue(instantiable: false)
abstract interface class SignalingSettings_HelloAuthParamsInterface {
  @BuiltValueField(wireName: '1.0')
  SignalingSettings_HelloAuthParams_$10 get $10;
  @BuiltValueField(wireName: '2.0')
  SignalingSettings_HelloAuthParams_$20 get $20;
}

abstract class SignalingSettings_HelloAuthParams
    implements
        SignalingSettings_HelloAuthParamsInterface,
        Built<SignalingSettings_HelloAuthParams, SignalingSettings_HelloAuthParamsBuilder> {
  factory SignalingSettings_HelloAuthParams([final void Function(SignalingSettings_HelloAuthParamsBuilder)? b]) =
      _$SignalingSettings_HelloAuthParams;

  // coverage:ignore-start
  const SignalingSettings_HelloAuthParams._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory SignalingSettings_HelloAuthParams.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<SignalingSettings_HelloAuthParams> get serializer => _$signalingSettingsHelloAuthParamsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class SignalingSettings_StunserversInterface {
  BuiltList<String> get urls;
}

abstract class SignalingSettings_Stunservers
    implements
        SignalingSettings_StunserversInterface,
        Built<SignalingSettings_Stunservers, SignalingSettings_StunserversBuilder> {
  factory SignalingSettings_Stunservers([final void Function(SignalingSettings_StunserversBuilder)? b]) =
      _$SignalingSettings_Stunservers;

  // coverage:ignore-start
  const SignalingSettings_Stunservers._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory SignalingSettings_Stunservers.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<SignalingSettings_Stunservers> get serializer => _$signalingSettingsStunserversSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class SignalingSettings_TurnserversInterface {
  BuiltList<String> get urls;
  String get username;
  JsonObject get credential;
}

abstract class SignalingSettings_Turnservers
    implements
        SignalingSettings_TurnserversInterface,
        Built<SignalingSettings_Turnservers, SignalingSettings_TurnserversBuilder> {
  factory SignalingSettings_Turnservers([final void Function(SignalingSettings_TurnserversBuilder)? b]) =
      _$SignalingSettings_Turnservers;

  // coverage:ignore-start
  const SignalingSettings_Turnservers._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory SignalingSettings_Turnservers.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<SignalingSettings_Turnservers> get serializer => _$signalingSettingsTurnserversSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class SignalingSettingsInterface {
  SignalingSettings_HelloAuthParams get helloAuthParams;
  bool get hideWarning;
  String get server;
  String get signalingMode;
  String get sipDialinInfo;
  BuiltList<SignalingSettings_Stunservers> get stunservers;
  String get ticket;
  BuiltList<SignalingSettings_Turnservers> get turnservers;
  String? get userId;
}

abstract class SignalingSettings
    implements SignalingSettingsInterface, Built<SignalingSettings, SignalingSettingsBuilder> {
  factory SignalingSettings([final void Function(SignalingSettingsBuilder)? b]) = _$SignalingSettings;

  // coverage:ignore-start
  const SignalingSettings._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory SignalingSettings.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<SignalingSettings> get serializer => _$signalingSettingsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class SignalingGetSettingsResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  SignalingSettings get data;
}

abstract class SignalingGetSettingsResponseApplicationJson_Ocs
    implements
        SignalingGetSettingsResponseApplicationJson_OcsInterface,
        Built<SignalingGetSettingsResponseApplicationJson_Ocs, SignalingGetSettingsResponseApplicationJson_OcsBuilder> {
  factory SignalingGetSettingsResponseApplicationJson_Ocs([
    final void Function(SignalingGetSettingsResponseApplicationJson_OcsBuilder)? b,
  ]) = _$SignalingGetSettingsResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const SignalingGetSettingsResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory SignalingGetSettingsResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<SignalingGetSettingsResponseApplicationJson_Ocs> get serializer =>
      _$signalingGetSettingsResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class SignalingGetSettingsResponseApplicationJsonInterface {
  SignalingGetSettingsResponseApplicationJson_Ocs get ocs;
}

abstract class SignalingGetSettingsResponseApplicationJson
    implements
        SignalingGetSettingsResponseApplicationJsonInterface,
        Built<SignalingGetSettingsResponseApplicationJson, SignalingGetSettingsResponseApplicationJsonBuilder> {
  factory SignalingGetSettingsResponseApplicationJson([
    final void Function(SignalingGetSettingsResponseApplicationJsonBuilder)? b,
  ]) = _$SignalingGetSettingsResponseApplicationJson;

  // coverage:ignore-start
  const SignalingGetSettingsResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory SignalingGetSettingsResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<SignalingGetSettingsResponseApplicationJson> get serializer =>
      _$signalingGetSettingsResponseApplicationJsonSerializer;
}

class SignalingGetWelcomeMessageApiVersion extends EnumClass {
  const SignalingGetWelcomeMessageApiVersion._(super.name);

  static const SignalingGetWelcomeMessageApiVersion v3 = _$signalingGetWelcomeMessageApiVersionV3;

  // coverage:ignore-start
  static BuiltSet<SignalingGetWelcomeMessageApiVersion> get values => _$signalingGetWelcomeMessageApiVersionValues;
  // coverage:ignore-end
  static SignalingGetWelcomeMessageApiVersion valueOf(final String name) =>
      _$valueOfSignalingGetWelcomeMessageApiVersion(name);
  static Serializer<SignalingGetWelcomeMessageApiVersion> get serializer =>
      _$signalingGetWelcomeMessageApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class SignalingGetWelcomeMessageResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  BuiltMap<String, JsonObject> get data;
}

abstract class SignalingGetWelcomeMessageResponseApplicationJson_Ocs
    implements
        SignalingGetWelcomeMessageResponseApplicationJson_OcsInterface,
        Built<SignalingGetWelcomeMessageResponseApplicationJson_Ocs,
            SignalingGetWelcomeMessageResponseApplicationJson_OcsBuilder> {
  factory SignalingGetWelcomeMessageResponseApplicationJson_Ocs([
    final void Function(SignalingGetWelcomeMessageResponseApplicationJson_OcsBuilder)? b,
  ]) = _$SignalingGetWelcomeMessageResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const SignalingGetWelcomeMessageResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory SignalingGetWelcomeMessageResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<SignalingGetWelcomeMessageResponseApplicationJson_Ocs> get serializer =>
      _$signalingGetWelcomeMessageResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class SignalingGetWelcomeMessageResponseApplicationJsonInterface {
  SignalingGetWelcomeMessageResponseApplicationJson_Ocs get ocs;
}

abstract class SignalingGetWelcomeMessageResponseApplicationJson
    implements
        SignalingGetWelcomeMessageResponseApplicationJsonInterface,
        Built<SignalingGetWelcomeMessageResponseApplicationJson,
            SignalingGetWelcomeMessageResponseApplicationJsonBuilder> {
  factory SignalingGetWelcomeMessageResponseApplicationJson([
    final void Function(SignalingGetWelcomeMessageResponseApplicationJsonBuilder)? b,
  ]) = _$SignalingGetWelcomeMessageResponseApplicationJson;

  // coverage:ignore-start
  const SignalingGetWelcomeMessageResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory SignalingGetWelcomeMessageResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<SignalingGetWelcomeMessageResponseApplicationJson> get serializer =>
      _$signalingGetWelcomeMessageResponseApplicationJsonSerializer;
}

class SignalingPullMessagesApiVersion extends EnumClass {
  const SignalingPullMessagesApiVersion._(super.name);

  static const SignalingPullMessagesApiVersion v3 = _$signalingPullMessagesApiVersionV3;

  // coverage:ignore-start
  static BuiltSet<SignalingPullMessagesApiVersion> get values => _$signalingPullMessagesApiVersionValues;
  // coverage:ignore-end
  static SignalingPullMessagesApiVersion valueOf(final String name) => _$valueOfSignalingPullMessagesApiVersion(name);
  static Serializer<SignalingPullMessagesApiVersion> get serializer => _$signalingPullMessagesApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class SignalingSessionInterface {
  int get inCall;
  int get lastPing;
  int get participantPermissions;
  int get roomId;
  String get sessionId;
  String get userId;
}

abstract class SignalingSession implements SignalingSessionInterface, Built<SignalingSession, SignalingSessionBuilder> {
  factory SignalingSession([final void Function(SignalingSessionBuilder)? b]) = _$SignalingSession;

  // coverage:ignore-start
  const SignalingSession._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory SignalingSession.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<SignalingSession> get serializer => _$signalingSessionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class SignalingPullMessagesResponseApplicationJson_Ocs_Data_DataInterface {
  BuiltList<SignalingSession>? get builtListSignalingSession;
  String? get string;
}

abstract class SignalingPullMessagesResponseApplicationJson_Ocs_Data_Data
    implements
        SignalingPullMessagesResponseApplicationJson_Ocs_Data_DataInterface,
        Built<SignalingPullMessagesResponseApplicationJson_Ocs_Data_Data,
            SignalingPullMessagesResponseApplicationJson_Ocs_Data_DataBuilder> {
  factory SignalingPullMessagesResponseApplicationJson_Ocs_Data_Data([
    final void Function(SignalingPullMessagesResponseApplicationJson_Ocs_Data_DataBuilder)? b,
  ]) = _$SignalingPullMessagesResponseApplicationJson_Ocs_Data_Data;

  // coverage:ignore-start
  const SignalingPullMessagesResponseApplicationJson_Ocs_Data_Data._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory SignalingPullMessagesResponseApplicationJson_Ocs_Data_Data.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  @BuiltValueSerializer(custom: true)
  static Serializer<SignalingPullMessagesResponseApplicationJson_Ocs_Data_Data> get serializer =>
      _$SignalingPullMessagesResponseApplicationJson_Ocs_Data_DataSerializer();
  JsonObject get data;
  @BuiltValueHook(finalizeBuilder: true)
  static void _validate(final SignalingPullMessagesResponseApplicationJson_Ocs_Data_DataBuilder b) {
    // When this is rebuild from another builder
    if (b._data == null) {
      return;
    }

    final match = [b._builtListSignalingSession, b._string].singleWhereOrNull((final x) => x != null);
    if (match == null) {
      throw StateError("Need exactly one of 'builtListSignalingSession', 'string' for ${b._data}");
    }
  }
}

class _$SignalingPullMessagesResponseApplicationJson_Ocs_Data_DataSerializer
    implements PrimitiveSerializer<SignalingPullMessagesResponseApplicationJson_Ocs_Data_Data> {
  @override
  final Iterable<Type> types = const [
    SignalingPullMessagesResponseApplicationJson_Ocs_Data_Data,
    _$SignalingPullMessagesResponseApplicationJson_Ocs_Data_Data,
  ];

  @override
  final String wireName = 'SignalingPullMessagesResponseApplicationJson_Ocs_Data_Data';

  @override
  Object serialize(
    final Serializers serializers,
    final SignalingPullMessagesResponseApplicationJson_Ocs_Data_Data object, {
    final FullType specifiedType = FullType.unspecified,
  }) =>
      object.data.value;

  @override
  SignalingPullMessagesResponseApplicationJson_Ocs_Data_Data deserialize(
    final Serializers serializers,
    final Object data, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    final result = SignalingPullMessagesResponseApplicationJson_Ocs_Data_DataBuilder()..data = JsonObject(data);
    try {
      final value = _jsonSerializers.deserialize(
        data,
        specifiedType: const FullType(BuiltList, [FullType(SignalingSession)]),
      )! as BuiltList<SignalingSession>;
      result.builtListSignalingSession.replace(value);
    } catch (_) {}
    try {
      final value = _jsonSerializers.deserialize(data, specifiedType: const FullType(String))! as String;
      result.string = value;
    } catch (_) {}
    return result.build();
  }
}

@BuiltValue(instantiable: false)
abstract interface class SignalingPullMessagesResponseApplicationJson_Ocs_DataInterface {
  String get type;
  SignalingPullMessagesResponseApplicationJson_Ocs_Data_Data get data;
}

abstract class SignalingPullMessagesResponseApplicationJson_Ocs_Data
    implements
        SignalingPullMessagesResponseApplicationJson_Ocs_DataInterface,
        Built<SignalingPullMessagesResponseApplicationJson_Ocs_Data,
            SignalingPullMessagesResponseApplicationJson_Ocs_DataBuilder> {
  factory SignalingPullMessagesResponseApplicationJson_Ocs_Data([
    final void Function(SignalingPullMessagesResponseApplicationJson_Ocs_DataBuilder)? b,
  ]) = _$SignalingPullMessagesResponseApplicationJson_Ocs_Data;

  // coverage:ignore-start
  const SignalingPullMessagesResponseApplicationJson_Ocs_Data._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory SignalingPullMessagesResponseApplicationJson_Ocs_Data.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<SignalingPullMessagesResponseApplicationJson_Ocs_Data> get serializer =>
      _$signalingPullMessagesResponseApplicationJsonOcsDataSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class SignalingPullMessagesResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  BuiltList<SignalingPullMessagesResponseApplicationJson_Ocs_Data> get data;
}

abstract class SignalingPullMessagesResponseApplicationJson_Ocs
    implements
        SignalingPullMessagesResponseApplicationJson_OcsInterface,
        Built<SignalingPullMessagesResponseApplicationJson_Ocs,
            SignalingPullMessagesResponseApplicationJson_OcsBuilder> {
  factory SignalingPullMessagesResponseApplicationJson_Ocs([
    final void Function(SignalingPullMessagesResponseApplicationJson_OcsBuilder)? b,
  ]) = _$SignalingPullMessagesResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const SignalingPullMessagesResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory SignalingPullMessagesResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<SignalingPullMessagesResponseApplicationJson_Ocs> get serializer =>
      _$signalingPullMessagesResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class SignalingPullMessagesResponseApplicationJsonInterface {
  SignalingPullMessagesResponseApplicationJson_Ocs get ocs;
}

abstract class SignalingPullMessagesResponseApplicationJson
    implements
        SignalingPullMessagesResponseApplicationJsonInterface,
        Built<SignalingPullMessagesResponseApplicationJson, SignalingPullMessagesResponseApplicationJsonBuilder> {
  factory SignalingPullMessagesResponseApplicationJson([
    final void Function(SignalingPullMessagesResponseApplicationJsonBuilder)? b,
  ]) = _$SignalingPullMessagesResponseApplicationJson;

  // coverage:ignore-start
  const SignalingPullMessagesResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory SignalingPullMessagesResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<SignalingPullMessagesResponseApplicationJson> get serializer =>
      _$signalingPullMessagesResponseApplicationJsonSerializer;
}

class SignalingSendMessagesApiVersion extends EnumClass {
  const SignalingSendMessagesApiVersion._(super.name);

  static const SignalingSendMessagesApiVersion v3 = _$signalingSendMessagesApiVersionV3;

  // coverage:ignore-start
  static BuiltSet<SignalingSendMessagesApiVersion> get values => _$signalingSendMessagesApiVersionValues;
  // coverage:ignore-end
  static SignalingSendMessagesApiVersion valueOf(final String name) => _$valueOfSignalingSendMessagesApiVersion(name);
  static Serializer<SignalingSendMessagesApiVersion> get serializer => _$signalingSendMessagesApiVersionSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class SignalingSendMessagesResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class SignalingSendMessagesResponseApplicationJson_Ocs
    implements
        SignalingSendMessagesResponseApplicationJson_OcsInterface,
        Built<SignalingSendMessagesResponseApplicationJson_Ocs,
            SignalingSendMessagesResponseApplicationJson_OcsBuilder> {
  factory SignalingSendMessagesResponseApplicationJson_Ocs([
    final void Function(SignalingSendMessagesResponseApplicationJson_OcsBuilder)? b,
  ]) = _$SignalingSendMessagesResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const SignalingSendMessagesResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory SignalingSendMessagesResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<SignalingSendMessagesResponseApplicationJson_Ocs> get serializer =>
      _$signalingSendMessagesResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class SignalingSendMessagesResponseApplicationJsonInterface {
  SignalingSendMessagesResponseApplicationJson_Ocs get ocs;
}

abstract class SignalingSendMessagesResponseApplicationJson
    implements
        SignalingSendMessagesResponseApplicationJsonInterface,
        Built<SignalingSendMessagesResponseApplicationJson, SignalingSendMessagesResponseApplicationJsonBuilder> {
  factory SignalingSendMessagesResponseApplicationJson([
    final void Function(SignalingSendMessagesResponseApplicationJsonBuilder)? b,
  ]) = _$SignalingSendMessagesResponseApplicationJson;

  // coverage:ignore-start
  const SignalingSendMessagesResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory SignalingSendMessagesResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<SignalingSendMessagesResponseApplicationJson> get serializer =>
      _$signalingSendMessagesResponseApplicationJsonSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class TempAvatarPostAvatarResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class TempAvatarPostAvatarResponseApplicationJson_Ocs
    implements
        TempAvatarPostAvatarResponseApplicationJson_OcsInterface,
        Built<TempAvatarPostAvatarResponseApplicationJson_Ocs, TempAvatarPostAvatarResponseApplicationJson_OcsBuilder> {
  factory TempAvatarPostAvatarResponseApplicationJson_Ocs([
    final void Function(TempAvatarPostAvatarResponseApplicationJson_OcsBuilder)? b,
  ]) = _$TempAvatarPostAvatarResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const TempAvatarPostAvatarResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory TempAvatarPostAvatarResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<TempAvatarPostAvatarResponseApplicationJson_Ocs> get serializer =>
      _$tempAvatarPostAvatarResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class TempAvatarPostAvatarResponseApplicationJsonInterface {
  TempAvatarPostAvatarResponseApplicationJson_Ocs get ocs;
}

abstract class TempAvatarPostAvatarResponseApplicationJson
    implements
        TempAvatarPostAvatarResponseApplicationJsonInterface,
        Built<TempAvatarPostAvatarResponseApplicationJson, TempAvatarPostAvatarResponseApplicationJsonBuilder> {
  factory TempAvatarPostAvatarResponseApplicationJson([
    final void Function(TempAvatarPostAvatarResponseApplicationJsonBuilder)? b,
  ]) = _$TempAvatarPostAvatarResponseApplicationJson;

  // coverage:ignore-start
  const TempAvatarPostAvatarResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory TempAvatarPostAvatarResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<TempAvatarPostAvatarResponseApplicationJson> get serializer =>
      _$tempAvatarPostAvatarResponseApplicationJsonSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class TempAvatarDeleteAvatarResponseApplicationJson_OcsInterface {
  OCSMeta get meta;
  JsonObject get data;
}

abstract class TempAvatarDeleteAvatarResponseApplicationJson_Ocs
    implements
        TempAvatarDeleteAvatarResponseApplicationJson_OcsInterface,
        Built<TempAvatarDeleteAvatarResponseApplicationJson_Ocs,
            TempAvatarDeleteAvatarResponseApplicationJson_OcsBuilder> {
  factory TempAvatarDeleteAvatarResponseApplicationJson_Ocs([
    final void Function(TempAvatarDeleteAvatarResponseApplicationJson_OcsBuilder)? b,
  ]) = _$TempAvatarDeleteAvatarResponseApplicationJson_Ocs;

  // coverage:ignore-start
  const TempAvatarDeleteAvatarResponseApplicationJson_Ocs._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory TempAvatarDeleteAvatarResponseApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<TempAvatarDeleteAvatarResponseApplicationJson_Ocs> get serializer =>
      _$tempAvatarDeleteAvatarResponseApplicationJsonOcsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class TempAvatarDeleteAvatarResponseApplicationJsonInterface {
  TempAvatarDeleteAvatarResponseApplicationJson_Ocs get ocs;
}

abstract class TempAvatarDeleteAvatarResponseApplicationJson
    implements
        TempAvatarDeleteAvatarResponseApplicationJsonInterface,
        Built<TempAvatarDeleteAvatarResponseApplicationJson, TempAvatarDeleteAvatarResponseApplicationJsonBuilder> {
  factory TempAvatarDeleteAvatarResponseApplicationJson([
    final void Function(TempAvatarDeleteAvatarResponseApplicationJsonBuilder)? b,
  ]) = _$TempAvatarDeleteAvatarResponseApplicationJson;

  // coverage:ignore-start
  const TempAvatarDeleteAvatarResponseApplicationJson._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory TempAvatarDeleteAvatarResponseApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<TempAvatarDeleteAvatarResponseApplicationJson> get serializer =>
      _$tempAvatarDeleteAvatarResponseApplicationJsonSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class BotWithDetailsAndSecret_1Interface {
  String get secret;
}

@BuiltValue(instantiable: false)
abstract interface class BotWithDetailsAndSecretInterface
    implements BotWithDetailsInterface, BotWithDetailsAndSecret_1Interface {}

abstract class BotWithDetailsAndSecret
    implements BotWithDetailsAndSecretInterface, Built<BotWithDetailsAndSecret, BotWithDetailsAndSecretBuilder> {
  factory BotWithDetailsAndSecret([final void Function(BotWithDetailsAndSecretBuilder)? b]) = _$BotWithDetailsAndSecret;

  // coverage:ignore-start
  const BotWithDetailsAndSecret._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory BotWithDetailsAndSecret.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<BotWithDetailsAndSecret> get serializer => _$botWithDetailsAndSecretSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class PublicCapabilities0_Spreed_Config_AttachmentsInterface {
  bool get allowed;
  String? get folder;
}

abstract class PublicCapabilities0_Spreed_Config_Attachments
    implements
        PublicCapabilities0_Spreed_Config_AttachmentsInterface,
        Built<PublicCapabilities0_Spreed_Config_Attachments, PublicCapabilities0_Spreed_Config_AttachmentsBuilder> {
  factory PublicCapabilities0_Spreed_Config_Attachments([
    final void Function(PublicCapabilities0_Spreed_Config_AttachmentsBuilder)? b,
  ]) = _$PublicCapabilities0_Spreed_Config_Attachments;

  // coverage:ignore-start
  const PublicCapabilities0_Spreed_Config_Attachments._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory PublicCapabilities0_Spreed_Config_Attachments.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<PublicCapabilities0_Spreed_Config_Attachments> get serializer =>
      _$publicCapabilities0SpreedConfigAttachmentsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class PublicCapabilities0_Spreed_Config_CallInterface {
  bool get enabled;
  @BuiltValueField(wireName: 'breakout-rooms')
  bool get breakoutRooms;
  bool get recording;
  @BuiltValueField(wireName: 'recording-consent')
  int? get recordingConsent;
  @BuiltValueField(wireName: 'supported-reactions')
  BuiltList<String> get supportedReactions;
  @BuiltValueField(wireName: 'predefined-backgrounds')
  BuiltList<String> get predefinedBackgrounds;
  @BuiltValueField(wireName: 'can-upload-background')
  bool get canUploadBackground;
  @BuiltValueField(wireName: 'sip-enabled')
  bool? get sipEnabled;
  @BuiltValueField(wireName: 'sip-dialout-enabled')
  bool? get sipDialoutEnabled;
  @BuiltValueField(wireName: 'can-enable-sip')
  bool? get canEnableSip;
}

abstract class PublicCapabilities0_Spreed_Config_Call
    implements
        PublicCapabilities0_Spreed_Config_CallInterface,
        Built<PublicCapabilities0_Spreed_Config_Call, PublicCapabilities0_Spreed_Config_CallBuilder> {
  factory PublicCapabilities0_Spreed_Config_Call([
    final void Function(PublicCapabilities0_Spreed_Config_CallBuilder)? b,
  ]) = _$PublicCapabilities0_Spreed_Config_Call;

  // coverage:ignore-start
  const PublicCapabilities0_Spreed_Config_Call._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory PublicCapabilities0_Spreed_Config_Call.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<PublicCapabilities0_Spreed_Config_Call> get serializer =>
      _$publicCapabilities0SpreedConfigCallSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class PublicCapabilities0_Spreed_Config_ChatInterface {
  @BuiltValueField(wireName: 'max-length')
  int get maxLength;
  @BuiltValueField(wireName: 'read-privacy')
  int get readPrivacy;
  @BuiltValueField(wireName: 'has-translation-providers')
  bool? get hasTranslationProviders;
  @BuiltValueField(wireName: 'typing-privacy')
  int get typingPrivacy;
  BuiltList<String>? get translations;
}

abstract class PublicCapabilities0_Spreed_Config_Chat
    implements
        PublicCapabilities0_Spreed_Config_ChatInterface,
        Built<PublicCapabilities0_Spreed_Config_Chat, PublicCapabilities0_Spreed_Config_ChatBuilder> {
  factory PublicCapabilities0_Spreed_Config_Chat([
    final void Function(PublicCapabilities0_Spreed_Config_ChatBuilder)? b,
  ]) = _$PublicCapabilities0_Spreed_Config_Chat;

  // coverage:ignore-start
  const PublicCapabilities0_Spreed_Config_Chat._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory PublicCapabilities0_Spreed_Config_Chat.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<PublicCapabilities0_Spreed_Config_Chat> get serializer =>
      _$publicCapabilities0SpreedConfigChatSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class PublicCapabilities0_Spreed_Config_ConversationsInterface {
  @BuiltValueField(wireName: 'can-create')
  bool get canCreate;
}

abstract class PublicCapabilities0_Spreed_Config_Conversations
    implements
        PublicCapabilities0_Spreed_Config_ConversationsInterface,
        Built<PublicCapabilities0_Spreed_Config_Conversations, PublicCapabilities0_Spreed_Config_ConversationsBuilder> {
  factory PublicCapabilities0_Spreed_Config_Conversations([
    final void Function(PublicCapabilities0_Spreed_Config_ConversationsBuilder)? b,
  ]) = _$PublicCapabilities0_Spreed_Config_Conversations;

  // coverage:ignore-start
  const PublicCapabilities0_Spreed_Config_Conversations._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory PublicCapabilities0_Spreed_Config_Conversations.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<PublicCapabilities0_Spreed_Config_Conversations> get serializer =>
      _$publicCapabilities0SpreedConfigConversationsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class PublicCapabilities0_Spreed_Config_PreviewsInterface {
  @BuiltValueField(wireName: 'max-gif-size')
  int get maxGifSize;
}

abstract class PublicCapabilities0_Spreed_Config_Previews
    implements
        PublicCapabilities0_Spreed_Config_PreviewsInterface,
        Built<PublicCapabilities0_Spreed_Config_Previews, PublicCapabilities0_Spreed_Config_PreviewsBuilder> {
  factory PublicCapabilities0_Spreed_Config_Previews([
    final void Function(PublicCapabilities0_Spreed_Config_PreviewsBuilder)? b,
  ]) = _$PublicCapabilities0_Spreed_Config_Previews;

  // coverage:ignore-start
  const PublicCapabilities0_Spreed_Config_Previews._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory PublicCapabilities0_Spreed_Config_Previews.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<PublicCapabilities0_Spreed_Config_Previews> get serializer =>
      _$publicCapabilities0SpreedConfigPreviewsSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class PublicCapabilities0_Spreed_Config_SignalingInterface {
  @BuiltValueField(wireName: 'session-ping-limit')
  int get sessionPingLimit;
  @BuiltValueField(wireName: 'hello-v2-token-key')
  String? get helloV2TokenKey;
}

abstract class PublicCapabilities0_Spreed_Config_Signaling
    implements
        PublicCapabilities0_Spreed_Config_SignalingInterface,
        Built<PublicCapabilities0_Spreed_Config_Signaling, PublicCapabilities0_Spreed_Config_SignalingBuilder> {
  factory PublicCapabilities0_Spreed_Config_Signaling([
    final void Function(PublicCapabilities0_Spreed_Config_SignalingBuilder)? b,
  ]) = _$PublicCapabilities0_Spreed_Config_Signaling;

  // coverage:ignore-start
  const PublicCapabilities0_Spreed_Config_Signaling._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory PublicCapabilities0_Spreed_Config_Signaling.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<PublicCapabilities0_Spreed_Config_Signaling> get serializer =>
      _$publicCapabilities0SpreedConfigSignalingSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class PublicCapabilities0_Spreed_ConfigInterface {
  PublicCapabilities0_Spreed_Config_Attachments get attachments;
  PublicCapabilities0_Spreed_Config_Call get call;
  PublicCapabilities0_Spreed_Config_Chat get chat;
  PublicCapabilities0_Spreed_Config_Conversations get conversations;
  PublicCapabilities0_Spreed_Config_Previews get previews;
  PublicCapabilities0_Spreed_Config_Signaling get signaling;
}

abstract class PublicCapabilities0_Spreed_Config
    implements
        PublicCapabilities0_Spreed_ConfigInterface,
        Built<PublicCapabilities0_Spreed_Config, PublicCapabilities0_Spreed_ConfigBuilder> {
  factory PublicCapabilities0_Spreed_Config([final void Function(PublicCapabilities0_Spreed_ConfigBuilder)? b]) =
      _$PublicCapabilities0_Spreed_Config;

  // coverage:ignore-start
  const PublicCapabilities0_Spreed_Config._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory PublicCapabilities0_Spreed_Config.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<PublicCapabilities0_Spreed_Config> get serializer => _$publicCapabilities0SpreedConfigSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class PublicCapabilities0_SpreedInterface {
  BuiltList<String> get features;
  PublicCapabilities0_Spreed_Config get config;
  String get version;
}

abstract class PublicCapabilities0_Spreed
    implements
        PublicCapabilities0_SpreedInterface,
        Built<PublicCapabilities0_Spreed, PublicCapabilities0_SpreedBuilder> {
  factory PublicCapabilities0_Spreed([final void Function(PublicCapabilities0_SpreedBuilder)? b]) =
      _$PublicCapabilities0_Spreed;

  // coverage:ignore-start
  const PublicCapabilities0_Spreed._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory PublicCapabilities0_Spreed.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<PublicCapabilities0_Spreed> get serializer => _$publicCapabilities0SpreedSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class PublicCapabilities0Interface {
  PublicCapabilities0_Spreed get spreed;
}

abstract class PublicCapabilities0
    implements PublicCapabilities0Interface, Built<PublicCapabilities0, PublicCapabilities0Builder> {
  factory PublicCapabilities0([final void Function(PublicCapabilities0Builder)? b]) = _$PublicCapabilities0;

  // coverage:ignore-start
  const PublicCapabilities0._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory PublicCapabilities0.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  static Serializer<PublicCapabilities0> get serializer => _$publicCapabilities0Serializer;
}

@BuiltValue(instantiable: false)
abstract interface class PublicCapabilitiesInterface {
  PublicCapabilities0? get publicCapabilities0;
  BuiltList<JsonObject>? get builtListJsonObject;
}

abstract class PublicCapabilities
    implements PublicCapabilitiesInterface, Built<PublicCapabilities, PublicCapabilitiesBuilder> {
  factory PublicCapabilities([final void Function(PublicCapabilitiesBuilder)? b]) = _$PublicCapabilities;

  // coverage:ignore-start
  const PublicCapabilities._();
  // coverage:ignore-end

  // coverage:ignore-start
  factory PublicCapabilities.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  // coverage:ignore-start
  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end
  @BuiltValueSerializer(custom: true)
  static Serializer<PublicCapabilities> get serializer => _$PublicCapabilitiesSerializer();
  JsonObject get data;
  @BuiltValueHook(finalizeBuilder: true)
  static void _validate(final PublicCapabilitiesBuilder b) {
    // When this is rebuild from another builder
    if (b._data == null) {
      return;
    }

    final match = [b._publicCapabilities0, b._builtListJsonObject].firstWhereOrNull((final x) => x != null);
    if (match == null) {
      throw StateError("Need at least one of 'publicCapabilities0', 'builtListJsonObject' for ${b._data}");
    }
  }
}

class _$PublicCapabilitiesSerializer implements PrimitiveSerializer<PublicCapabilities> {
  @override
  final Iterable<Type> types = const [PublicCapabilities, _$PublicCapabilities];

  @override
  final String wireName = 'PublicCapabilities';

  @override
  Object serialize(
    final Serializers serializers,
    final PublicCapabilities object, {
    final FullType specifiedType = FullType.unspecified,
  }) =>
      object.data.value;

  @override
  PublicCapabilities deserialize(
    final Serializers serializers,
    final Object data, {
    final FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicCapabilitiesBuilder()..data = JsonObject(data);
    try {
      final value = _jsonSerializers.deserialize(data, specifiedType: const FullType(PublicCapabilities0))!
          as PublicCapabilities0;
      result.publicCapabilities0.replace(value);
    } catch (_) {}
    try {
      final value = _jsonSerializers.deserialize(
        data,
        specifiedType: const FullType(BuiltList, [FullType(JsonObject)]),
      )! as BuiltList<JsonObject>;
      result.builtListJsonObject.replace(value);
    } catch (_) {}
    return result.build();
  }
}

// coverage:ignore-start
final Serializers _serializers = (Serializers().toBuilder()
      ..add(AvatarGetAvatarApiVersion.serializer)
      ..add(AvatarUploadAvatarApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(AvatarUploadAvatarResponseApplicationJson),
        AvatarUploadAvatarResponseApplicationJson.new,
      )
      ..add(AvatarUploadAvatarResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(AvatarUploadAvatarResponseApplicationJson_Ocs),
        AvatarUploadAvatarResponseApplicationJson_Ocs.new,
      )
      ..add(AvatarUploadAvatarResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(const FullType(OCSMeta), OCSMeta.new)
      ..add(OCSMeta.serializer)
      ..addBuilderFactory(const FullType(Room), Room.new)
      ..add(Room.serializer)
      ..addBuilderFactory(const FullType(Room_LastMessage), Room_LastMessage.new)
      ..add(Room_LastMessage.serializer)
      ..addBuilderFactory(const FullType(ChatMessage), ChatMessage.new)
      ..add(ChatMessage.serializer)
      ..addBuilderFactory(
        const FullType(BuiltMap, [FullType(String), FullType(JsonObject)]),
        MapBuilder<String, JsonObject>.new,
      )
      ..addBuilderFactory(
        const FullType(BuiltMap, [
          FullType(String),
          FullType(BuiltMap, [FullType(String), FullType(JsonObject)]),
        ]),
        MapBuilder<String, BuiltMap>.new,
      )
      ..addBuilderFactory(const FullType(BuiltMap, [FullType(String), FullType(int)]), MapBuilder<String, int>.new)
      ..addBuilderFactory(const FullType(BuiltList, [FullType(JsonObject)]), ListBuilder<JsonObject>.new)
      ..add(AvatarDeleteAvatarApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(AvatarDeleteAvatarResponseApplicationJson),
        AvatarDeleteAvatarResponseApplicationJson.new,
      )
      ..add(AvatarDeleteAvatarResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(AvatarDeleteAvatarResponseApplicationJson_Ocs),
        AvatarDeleteAvatarResponseApplicationJson_Ocs.new,
      )
      ..add(AvatarDeleteAvatarResponseApplicationJson_Ocs.serializer)
      ..add(AvatarEmojiAvatarApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(AvatarEmojiAvatarResponseApplicationJson),
        AvatarEmojiAvatarResponseApplicationJson.new,
      )
      ..add(AvatarEmojiAvatarResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(AvatarEmojiAvatarResponseApplicationJson_Ocs),
        AvatarEmojiAvatarResponseApplicationJson_Ocs.new,
      )
      ..add(AvatarEmojiAvatarResponseApplicationJson_Ocs.serializer)
      ..add(AvatarGetAvatarDarkApiVersion.serializer)
      ..add(BotSendMessageApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(BotSendMessageResponseApplicationJson),
        BotSendMessageResponseApplicationJson.new,
      )
      ..add(BotSendMessageResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(BotSendMessageResponseApplicationJson_Ocs),
        BotSendMessageResponseApplicationJson_Ocs.new,
      )
      ..add(BotSendMessageResponseApplicationJson_Ocs.serializer)
      ..add(BotReactApiVersion.serializer)
      ..addBuilderFactory(const FullType(BotReactResponseApplicationJson), BotReactResponseApplicationJson.new)
      ..add(BotReactResponseApplicationJson.serializer)
      ..addBuilderFactory(const FullType(BotReactResponseApplicationJson_Ocs), BotReactResponseApplicationJson_Ocs.new)
      ..add(BotReactResponseApplicationJson_Ocs.serializer)
      ..add(BotDeleteReactionApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(BotDeleteReactionResponseApplicationJson),
        BotDeleteReactionResponseApplicationJson.new,
      )
      ..add(BotDeleteReactionResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(BotDeleteReactionResponseApplicationJson_Ocs),
        BotDeleteReactionResponseApplicationJson_Ocs.new,
      )
      ..add(BotDeleteReactionResponseApplicationJson_Ocs.serializer)
      ..add(BotAdminListBotsApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(BotAdminListBotsResponseApplicationJson),
        BotAdminListBotsResponseApplicationJson.new,
      )
      ..add(BotAdminListBotsResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(BotAdminListBotsResponseApplicationJson_Ocs),
        BotAdminListBotsResponseApplicationJson_Ocs.new,
      )
      ..add(BotAdminListBotsResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(const FullType(BotWithDetails), BotWithDetails.new)
      ..add(BotWithDetails.serializer)
      ..addBuilderFactory(const FullType(Bot), Bot.new)
      ..add(Bot.serializer)
      ..addBuilderFactory(const FullType(BuiltList, [FullType(BotWithDetails)]), ListBuilder<BotWithDetails>.new)
      ..add(BotListBotsApiVersion.serializer)
      ..addBuilderFactory(const FullType(BotListBotsResponseApplicationJson), BotListBotsResponseApplicationJson.new)
      ..add(BotListBotsResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(BotListBotsResponseApplicationJson_Ocs),
        BotListBotsResponseApplicationJson_Ocs.new,
      )
      ..add(BotListBotsResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(const FullType(BuiltList, [FullType(Bot)]), ListBuilder<Bot>.new)
      ..add(BotEnableBotApiVersion.serializer)
      ..addBuilderFactory(const FullType(BotEnableBotResponseApplicationJson), BotEnableBotResponseApplicationJson.new)
      ..add(BotEnableBotResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(BotEnableBotResponseApplicationJson_Ocs),
        BotEnableBotResponseApplicationJson_Ocs.new,
      )
      ..add(BotEnableBotResponseApplicationJson_Ocs.serializer)
      ..add(BotDisableBotApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(BotDisableBotResponseApplicationJson),
        BotDisableBotResponseApplicationJson.new,
      )
      ..add(BotDisableBotResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(BotDisableBotResponseApplicationJson_Ocs),
        BotDisableBotResponseApplicationJson_Ocs.new,
      )
      ..add(BotDisableBotResponseApplicationJson_Ocs.serializer)
      ..add(BreakoutRoomConfigureBreakoutRoomsApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(BreakoutRoomConfigureBreakoutRoomsResponseApplicationJson),
        BreakoutRoomConfigureBreakoutRoomsResponseApplicationJson.new,
      )
      ..add(BreakoutRoomConfigureBreakoutRoomsResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(BreakoutRoomConfigureBreakoutRoomsResponseApplicationJson_Ocs),
        BreakoutRoomConfigureBreakoutRoomsResponseApplicationJson_Ocs.new,
      )
      ..add(BreakoutRoomConfigureBreakoutRoomsResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(const FullType(BuiltList, [FullType(Room)]), ListBuilder<Room>.new)
      ..add(BreakoutRoomRemoveBreakoutRoomsApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(BreakoutRoomRemoveBreakoutRoomsResponseApplicationJson),
        BreakoutRoomRemoveBreakoutRoomsResponseApplicationJson.new,
      )
      ..add(BreakoutRoomRemoveBreakoutRoomsResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(BreakoutRoomRemoveBreakoutRoomsResponseApplicationJson_Ocs),
        BreakoutRoomRemoveBreakoutRoomsResponseApplicationJson_Ocs.new,
      )
      ..add(BreakoutRoomRemoveBreakoutRoomsResponseApplicationJson_Ocs.serializer)
      ..add(BreakoutRoomBroadcastChatMessageApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(BreakoutRoomBroadcastChatMessageResponseApplicationJson),
        BreakoutRoomBroadcastChatMessageResponseApplicationJson.new,
      )
      ..add(BreakoutRoomBroadcastChatMessageResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(BreakoutRoomBroadcastChatMessageResponseApplicationJson_Ocs),
        BreakoutRoomBroadcastChatMessageResponseApplicationJson_Ocs.new,
      )
      ..add(BreakoutRoomBroadcastChatMessageResponseApplicationJson_Ocs.serializer)
      ..add(BreakoutRoomApplyAttendeeMapApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(BreakoutRoomApplyAttendeeMapResponseApplicationJson),
        BreakoutRoomApplyAttendeeMapResponseApplicationJson.new,
      )
      ..add(BreakoutRoomApplyAttendeeMapResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(BreakoutRoomApplyAttendeeMapResponseApplicationJson_Ocs),
        BreakoutRoomApplyAttendeeMapResponseApplicationJson_Ocs.new,
      )
      ..add(BreakoutRoomApplyAttendeeMapResponseApplicationJson_Ocs.serializer)
      ..add(BreakoutRoomRequestAssistanceApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(BreakoutRoomRequestAssistanceResponseApplicationJson),
        BreakoutRoomRequestAssistanceResponseApplicationJson.new,
      )
      ..add(BreakoutRoomRequestAssistanceResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(BreakoutRoomRequestAssistanceResponseApplicationJson_Ocs),
        BreakoutRoomRequestAssistanceResponseApplicationJson_Ocs.new,
      )
      ..add(BreakoutRoomRequestAssistanceResponseApplicationJson_Ocs.serializer)
      ..add(BreakoutRoomResetRequestForAssistanceApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(BreakoutRoomResetRequestForAssistanceResponseApplicationJson),
        BreakoutRoomResetRequestForAssistanceResponseApplicationJson.new,
      )
      ..add(BreakoutRoomResetRequestForAssistanceResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(BreakoutRoomResetRequestForAssistanceResponseApplicationJson_Ocs),
        BreakoutRoomResetRequestForAssistanceResponseApplicationJson_Ocs.new,
      )
      ..add(BreakoutRoomResetRequestForAssistanceResponseApplicationJson_Ocs.serializer)
      ..add(BreakoutRoomStartBreakoutRoomsApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(BreakoutRoomStartBreakoutRoomsResponseApplicationJson),
        BreakoutRoomStartBreakoutRoomsResponseApplicationJson.new,
      )
      ..add(BreakoutRoomStartBreakoutRoomsResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(BreakoutRoomStartBreakoutRoomsResponseApplicationJson_Ocs),
        BreakoutRoomStartBreakoutRoomsResponseApplicationJson_Ocs.new,
      )
      ..add(BreakoutRoomStartBreakoutRoomsResponseApplicationJson_Ocs.serializer)
      ..add(BreakoutRoomStopBreakoutRoomsApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(BreakoutRoomStopBreakoutRoomsResponseApplicationJson),
        BreakoutRoomStopBreakoutRoomsResponseApplicationJson.new,
      )
      ..add(BreakoutRoomStopBreakoutRoomsResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(BreakoutRoomStopBreakoutRoomsResponseApplicationJson_Ocs),
        BreakoutRoomStopBreakoutRoomsResponseApplicationJson_Ocs.new,
      )
      ..add(BreakoutRoomStopBreakoutRoomsResponseApplicationJson_Ocs.serializer)
      ..add(BreakoutRoomSwitchBreakoutRoomApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(BreakoutRoomSwitchBreakoutRoomResponseApplicationJson),
        BreakoutRoomSwitchBreakoutRoomResponseApplicationJson.new,
      )
      ..add(BreakoutRoomSwitchBreakoutRoomResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(BreakoutRoomSwitchBreakoutRoomResponseApplicationJson_Ocs),
        BreakoutRoomSwitchBreakoutRoomResponseApplicationJson_Ocs.new,
      )
      ..add(BreakoutRoomSwitchBreakoutRoomResponseApplicationJson_Ocs.serializer)
      ..add(CallGetPeersForCallApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(CallGetPeersForCallResponseApplicationJson),
        CallGetPeersForCallResponseApplicationJson.new,
      )
      ..add(CallGetPeersForCallResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(CallGetPeersForCallResponseApplicationJson_Ocs),
        CallGetPeersForCallResponseApplicationJson_Ocs.new,
      )
      ..add(CallGetPeersForCallResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(const FullType(CallPeer), CallPeer.new)
      ..add(CallPeer.serializer)
      ..addBuilderFactory(const FullType(BuiltList, [FullType(CallPeer)]), ListBuilder<CallPeer>.new)
      ..add(CallUpdateCallFlagsApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(CallUpdateCallFlagsResponseApplicationJson),
        CallUpdateCallFlagsResponseApplicationJson.new,
      )
      ..add(CallUpdateCallFlagsResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(CallUpdateCallFlagsResponseApplicationJson_Ocs),
        CallUpdateCallFlagsResponseApplicationJson_Ocs.new,
      )
      ..add(CallUpdateCallFlagsResponseApplicationJson_Ocs.serializer)
      ..add(CallJoinCallApiVersion.serializer)
      ..addBuilderFactory(const FullType(CallJoinCallResponseApplicationJson), CallJoinCallResponseApplicationJson.new)
      ..add(CallJoinCallResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(CallJoinCallResponseApplicationJson_Ocs),
        CallJoinCallResponseApplicationJson_Ocs.new,
      )
      ..add(CallJoinCallResponseApplicationJson_Ocs.serializer)
      ..add(CallLeaveCallApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(CallLeaveCallResponseApplicationJson),
        CallLeaveCallResponseApplicationJson.new,
      )
      ..add(CallLeaveCallResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(CallLeaveCallResponseApplicationJson_Ocs),
        CallLeaveCallResponseApplicationJson_Ocs.new,
      )
      ..add(CallLeaveCallResponseApplicationJson_Ocs.serializer)
      ..add(CallRingAttendeeApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(CallRingAttendeeResponseApplicationJson),
        CallRingAttendeeResponseApplicationJson.new,
      )
      ..add(CallRingAttendeeResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(CallRingAttendeeResponseApplicationJson_Ocs),
        CallRingAttendeeResponseApplicationJson_Ocs.new,
      )
      ..add(CallRingAttendeeResponseApplicationJson_Ocs.serializer)
      ..add(CallSipDialOutApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(CallSipDialOutResponseApplicationJson),
        CallSipDialOutResponseApplicationJson.new,
      )
      ..add(CallSipDialOutResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(CallSipDialOutResponseApplicationJson_Ocs),
        CallSipDialOutResponseApplicationJson_Ocs.new,
      )
      ..add(CallSipDialOutResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(
        const FullType(CallSipDialOutResponseApplicationJson_Ocs_Data),
        CallSipDialOutResponseApplicationJson_Ocs_Data.new,
      )
      ..add(CallSipDialOutResponseApplicationJson_Ocs_Data.serializer)
      ..add(CertificateGetCertificateExpirationApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(CertificateGetCertificateExpirationResponseApplicationJson),
        CertificateGetCertificateExpirationResponseApplicationJson.new,
      )
      ..add(CertificateGetCertificateExpirationResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(CertificateGetCertificateExpirationResponseApplicationJson_Ocs),
        CertificateGetCertificateExpirationResponseApplicationJson_Ocs.new,
      )
      ..add(CertificateGetCertificateExpirationResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(
        const FullType(CertificateGetCertificateExpirationResponseApplicationJson_Ocs_Data),
        CertificateGetCertificateExpirationResponseApplicationJson_Ocs_Data.new,
      )
      ..add(CertificateGetCertificateExpirationResponseApplicationJson_Ocs_Data.serializer)
      ..add(ChatReceiveMessagesApiVersion.serializer)
      ..addBuilderFactory(const FullType(ChatChatReceiveMessagesHeaders), ChatChatReceiveMessagesHeaders.new)
      ..add(ChatChatReceiveMessagesHeaders.serializer)
      ..addBuilderFactory(
        const FullType(ChatReceiveMessagesResponseApplicationJson),
        ChatReceiveMessagesResponseApplicationJson.new,
      )
      ..add(ChatReceiveMessagesResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(ChatReceiveMessagesResponseApplicationJson_Ocs),
        ChatReceiveMessagesResponseApplicationJson_Ocs.new,
      )
      ..add(ChatReceiveMessagesResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(const FullType(ChatMessageWithParent), ChatMessageWithParent.new)
      ..add(ChatMessageWithParent.serializer)
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(ChatMessageWithParent)]),
        ListBuilder<ChatMessageWithParent>.new,
      )
      ..add(ChatSendMessageApiVersion.serializer)
      ..addBuilderFactory(const FullType(ChatChatSendMessageHeaders), ChatChatSendMessageHeaders.new)
      ..add(ChatChatSendMessageHeaders.serializer)
      ..addBuilderFactory(
        const FullType(ChatSendMessageResponseApplicationJson),
        ChatSendMessageResponseApplicationJson.new,
      )
      ..add(ChatSendMessageResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(ChatSendMessageResponseApplicationJson_Ocs),
        ChatSendMessageResponseApplicationJson_Ocs.new,
      )
      ..add(ChatSendMessageResponseApplicationJson_Ocs.serializer)
      ..add(ChatClearHistoryApiVersion.serializer)
      ..addBuilderFactory(const FullType(ChatChatClearHistoryHeaders), ChatChatClearHistoryHeaders.new)
      ..add(ChatChatClearHistoryHeaders.serializer)
      ..addBuilderFactory(
        const FullType(ChatClearHistoryResponseApplicationJson),
        ChatClearHistoryResponseApplicationJson.new,
      )
      ..add(ChatClearHistoryResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(ChatClearHistoryResponseApplicationJson_Ocs),
        ChatClearHistoryResponseApplicationJson_Ocs.new,
      )
      ..add(ChatClearHistoryResponseApplicationJson_Ocs.serializer)
      ..add(ChatDeleteMessageApiVersion.serializer)
      ..addBuilderFactory(const FullType(ChatChatDeleteMessageHeaders), ChatChatDeleteMessageHeaders.new)
      ..add(ChatChatDeleteMessageHeaders.serializer)
      ..addBuilderFactory(
        const FullType(ChatDeleteMessageResponseApplicationJson),
        ChatDeleteMessageResponseApplicationJson.new,
      )
      ..add(ChatDeleteMessageResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(ChatDeleteMessageResponseApplicationJson_Ocs),
        ChatDeleteMessageResponseApplicationJson_Ocs.new,
      )
      ..add(ChatDeleteMessageResponseApplicationJson_Ocs.serializer)
      ..add(ChatGetMessageContextApiVersion.serializer)
      ..addBuilderFactory(const FullType(ChatChatGetMessageContextHeaders), ChatChatGetMessageContextHeaders.new)
      ..add(ChatChatGetMessageContextHeaders.serializer)
      ..addBuilderFactory(
        const FullType(ChatGetMessageContextResponseApplicationJson),
        ChatGetMessageContextResponseApplicationJson.new,
      )
      ..add(ChatGetMessageContextResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(ChatGetMessageContextResponseApplicationJson_Ocs),
        ChatGetMessageContextResponseApplicationJson_Ocs.new,
      )
      ..add(ChatGetMessageContextResponseApplicationJson_Ocs.serializer)
      ..add(ChatGetReminderApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(ChatGetReminderResponseApplicationJson),
        ChatGetReminderResponseApplicationJson.new,
      )
      ..add(ChatGetReminderResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(ChatGetReminderResponseApplicationJson_Ocs),
        ChatGetReminderResponseApplicationJson_Ocs.new,
      )
      ..add(ChatGetReminderResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(const FullType(ChatReminder), ChatReminder.new)
      ..add(ChatReminder.serializer)
      ..add(ChatSetReminderApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(ChatSetReminderResponseApplicationJson),
        ChatSetReminderResponseApplicationJson.new,
      )
      ..add(ChatSetReminderResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(ChatSetReminderResponseApplicationJson_Ocs),
        ChatSetReminderResponseApplicationJson_Ocs.new,
      )
      ..add(ChatSetReminderResponseApplicationJson_Ocs.serializer)
      ..add(ChatDeleteReminderApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(ChatDeleteReminderResponseApplicationJson),
        ChatDeleteReminderResponseApplicationJson.new,
      )
      ..add(ChatDeleteReminderResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(ChatDeleteReminderResponseApplicationJson_Ocs),
        ChatDeleteReminderResponseApplicationJson_Ocs.new,
      )
      ..add(ChatDeleteReminderResponseApplicationJson_Ocs.serializer)
      ..add(ChatSetReadMarkerApiVersion.serializer)
      ..addBuilderFactory(const FullType(ChatChatSetReadMarkerHeaders), ChatChatSetReadMarkerHeaders.new)
      ..add(ChatChatSetReadMarkerHeaders.serializer)
      ..addBuilderFactory(
        const FullType(ChatSetReadMarkerResponseApplicationJson),
        ChatSetReadMarkerResponseApplicationJson.new,
      )
      ..add(ChatSetReadMarkerResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(ChatSetReadMarkerResponseApplicationJson_Ocs),
        ChatSetReadMarkerResponseApplicationJson_Ocs.new,
      )
      ..add(ChatSetReadMarkerResponseApplicationJson_Ocs.serializer)
      ..add(ChatMarkUnreadApiVersion.serializer)
      ..addBuilderFactory(const FullType(ChatChatMarkUnreadHeaders), ChatChatMarkUnreadHeaders.new)
      ..add(ChatChatMarkUnreadHeaders.serializer)
      ..addBuilderFactory(
        const FullType(ChatMarkUnreadResponseApplicationJson),
        ChatMarkUnreadResponseApplicationJson.new,
      )
      ..add(ChatMarkUnreadResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(ChatMarkUnreadResponseApplicationJson_Ocs),
        ChatMarkUnreadResponseApplicationJson_Ocs.new,
      )
      ..add(ChatMarkUnreadResponseApplicationJson_Ocs.serializer)
      ..add(ChatMentionsApiVersion.serializer)
      ..addBuilderFactory(const FullType(ChatMentionsResponseApplicationJson), ChatMentionsResponseApplicationJson.new)
      ..add(ChatMentionsResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(ChatMentionsResponseApplicationJson_Ocs),
        ChatMentionsResponseApplicationJson_Ocs.new,
      )
      ..add(ChatMentionsResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(const FullType(ChatMentionSuggestion), ChatMentionSuggestion.new)
      ..add(ChatMentionSuggestion.serializer)
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(ChatMentionSuggestion)]),
        ListBuilder<ChatMentionSuggestion>.new,
      )
      ..add(ChatGetObjectsSharedInRoomApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(ChatChatGetObjectsSharedInRoomHeaders),
        ChatChatGetObjectsSharedInRoomHeaders.new,
      )
      ..add(ChatChatGetObjectsSharedInRoomHeaders.serializer)
      ..addBuilderFactory(
        const FullType(ChatGetObjectsSharedInRoomResponseApplicationJson),
        ChatGetObjectsSharedInRoomResponseApplicationJson.new,
      )
      ..add(ChatGetObjectsSharedInRoomResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(ChatGetObjectsSharedInRoomResponseApplicationJson_Ocs),
        ChatGetObjectsSharedInRoomResponseApplicationJson_Ocs.new,
      )
      ..add(ChatGetObjectsSharedInRoomResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(const FullType(BuiltList, [FullType(ChatMessage)]), ListBuilder<ChatMessage>.new)
      ..add(ChatShareObjectToChatApiVersion.serializer)
      ..addBuilderFactory(const FullType(ChatChatShareObjectToChatHeaders), ChatChatShareObjectToChatHeaders.new)
      ..add(ChatChatShareObjectToChatHeaders.serializer)
      ..addBuilderFactory(
        const FullType(ChatShareObjectToChatResponseApplicationJson),
        ChatShareObjectToChatResponseApplicationJson.new,
      )
      ..add(ChatShareObjectToChatResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(ChatShareObjectToChatResponseApplicationJson_Ocs),
        ChatShareObjectToChatResponseApplicationJson_Ocs.new,
      )
      ..add(ChatShareObjectToChatResponseApplicationJson_Ocs.serializer)
      ..add(ChatGetObjectsSharedInRoomOverviewApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(ChatGetObjectsSharedInRoomOverviewResponseApplicationJson),
        ChatGetObjectsSharedInRoomOverviewResponseApplicationJson.new,
      )
      ..add(ChatGetObjectsSharedInRoomOverviewResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(ChatGetObjectsSharedInRoomOverviewResponseApplicationJson_Ocs),
        ChatGetObjectsSharedInRoomOverviewResponseApplicationJson_Ocs.new,
      )
      ..add(ChatGetObjectsSharedInRoomOverviewResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(
        const FullType(BuiltMap, [
          FullType(String),
          FullType(BuiltList, [FullType(ChatMessage)]),
        ]),
        MapBuilder<String, BuiltList>.new,
      )
      ..add(FederationAcceptShareApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(FederationAcceptShareResponseApplicationJson),
        FederationAcceptShareResponseApplicationJson.new,
      )
      ..add(FederationAcceptShareResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(FederationAcceptShareResponseApplicationJson_Ocs),
        FederationAcceptShareResponseApplicationJson_Ocs.new,
      )
      ..add(FederationAcceptShareResponseApplicationJson_Ocs.serializer)
      ..add(FederationRejectShareApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(FederationRejectShareResponseApplicationJson),
        FederationRejectShareResponseApplicationJson.new,
      )
      ..add(FederationRejectShareResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(FederationRejectShareResponseApplicationJson_Ocs),
        FederationRejectShareResponseApplicationJson_Ocs.new,
      )
      ..add(FederationRejectShareResponseApplicationJson_Ocs.serializer)
      ..add(FederationGetSharesApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(FederationGetSharesResponseApplicationJson),
        FederationGetSharesResponseApplicationJson.new,
      )
      ..add(FederationGetSharesResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(FederationGetSharesResponseApplicationJson_Ocs),
        FederationGetSharesResponseApplicationJson_Ocs.new,
      )
      ..add(FederationGetSharesResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(const FullType(FederationInvite), FederationInvite.new)
      ..add(FederationInvite.serializer)
      ..addBuilderFactory(const FullType(BuiltList, [FullType(FederationInvite)]), ListBuilder<FederationInvite>.new)
      ..add(FilesIntegrationGetRoomByFileIdApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(FilesIntegrationGetRoomByFileIdResponseApplicationJson),
        FilesIntegrationGetRoomByFileIdResponseApplicationJson.new,
      )
      ..add(FilesIntegrationGetRoomByFileIdResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(FilesIntegrationGetRoomByFileIdResponseApplicationJson_Ocs),
        FilesIntegrationGetRoomByFileIdResponseApplicationJson_Ocs.new,
      )
      ..add(FilesIntegrationGetRoomByFileIdResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(
        const FullType(FilesIntegrationGetRoomByFileIdResponseApplicationJson_Ocs_Data),
        FilesIntegrationGetRoomByFileIdResponseApplicationJson_Ocs_Data.new,
      )
      ..add(FilesIntegrationGetRoomByFileIdResponseApplicationJson_Ocs_Data.serializer)
      ..add(FilesIntegrationGetRoomByShareTokenApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(FilesIntegrationGetRoomByShareTokenResponseApplicationJson),
        FilesIntegrationGetRoomByShareTokenResponseApplicationJson.new,
      )
      ..add(FilesIntegrationGetRoomByShareTokenResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(FilesIntegrationGetRoomByShareTokenResponseApplicationJson_Ocs),
        FilesIntegrationGetRoomByShareTokenResponseApplicationJson_Ocs.new,
      )
      ..add(FilesIntegrationGetRoomByShareTokenResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(
        const FullType(FilesIntegrationGetRoomByShareTokenResponseApplicationJson_Ocs_Data),
        FilesIntegrationGetRoomByShareTokenResponseApplicationJson_Ocs_Data.new,
      )
      ..add(FilesIntegrationGetRoomByShareTokenResponseApplicationJson_Ocs_Data.serializer)
      ..add(GuestSetDisplayNameApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(GuestSetDisplayNameResponseApplicationJson),
        GuestSetDisplayNameResponseApplicationJson.new,
      )
      ..add(GuestSetDisplayNameResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(GuestSetDisplayNameResponseApplicationJson_Ocs),
        GuestSetDisplayNameResponseApplicationJson_Ocs.new,
      )
      ..add(GuestSetDisplayNameResponseApplicationJson_Ocs.serializer)
      ..add(HostedSignalingServerRequestTrialApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(HostedSignalingServerRequestTrialResponseApplicationJson),
        HostedSignalingServerRequestTrialResponseApplicationJson.new,
      )
      ..add(HostedSignalingServerRequestTrialResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(HostedSignalingServerRequestTrialResponseApplicationJson_Ocs),
        HostedSignalingServerRequestTrialResponseApplicationJson_Ocs.new,
      )
      ..add(HostedSignalingServerRequestTrialResponseApplicationJson_Ocs.serializer)
      ..add(HostedSignalingServerDeleteAccountApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(HostedSignalingServerDeleteAccountResponseApplicationJson),
        HostedSignalingServerDeleteAccountResponseApplicationJson.new,
      )
      ..add(HostedSignalingServerDeleteAccountResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(HostedSignalingServerDeleteAccountResponseApplicationJson_Ocs),
        HostedSignalingServerDeleteAccountResponseApplicationJson_Ocs.new,
      )
      ..add(HostedSignalingServerDeleteAccountResponseApplicationJson_Ocs.serializer)
      ..add(MatterbridgeGetBridgeOfRoomApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(MatterbridgeGetBridgeOfRoomResponseApplicationJson),
        MatterbridgeGetBridgeOfRoomResponseApplicationJson.new,
      )
      ..add(MatterbridgeGetBridgeOfRoomResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(MatterbridgeGetBridgeOfRoomResponseApplicationJson_Ocs),
        MatterbridgeGetBridgeOfRoomResponseApplicationJson_Ocs.new,
      )
      ..add(MatterbridgeGetBridgeOfRoomResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(const FullType(MatterbridgeWithProcessState), MatterbridgeWithProcessState.new)
      ..add(MatterbridgeWithProcessState.serializer)
      ..addBuilderFactory(const FullType(Matterbridge), Matterbridge.new)
      ..add(Matterbridge.serializer)
      ..addBuilderFactory(
        const FullType(BuiltList, [
          FullType(BuiltMap, [FullType(String), FullType(JsonObject)]),
        ]),
        ListBuilder<BuiltMap>.new,
      )
      ..addBuilderFactory(const FullType(MatterbridgeProcessState), MatterbridgeProcessState.new)
      ..add(MatterbridgeProcessState.serializer)
      ..addBuilderFactory(
        const FullType(ContentString, [
          FullType(BuiltList, [
            FullType(BuiltMap, [FullType(String), FullType(JsonObject)]),
          ]),
        ]),
        ContentString<BuiltList<BuiltMap<String, JsonObject>>>.new,
      )
      ..add(ContentString.serializer)
      ..add(MatterbridgeEditBridgeOfRoomApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(MatterbridgeEditBridgeOfRoomResponseApplicationJson),
        MatterbridgeEditBridgeOfRoomResponseApplicationJson.new,
      )
      ..add(MatterbridgeEditBridgeOfRoomResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(MatterbridgeEditBridgeOfRoomResponseApplicationJson_Ocs),
        MatterbridgeEditBridgeOfRoomResponseApplicationJson_Ocs.new,
      )
      ..add(MatterbridgeEditBridgeOfRoomResponseApplicationJson_Ocs.serializer)
      ..add(MatterbridgeDeleteBridgeOfRoomApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(MatterbridgeDeleteBridgeOfRoomResponseApplicationJson),
        MatterbridgeDeleteBridgeOfRoomResponseApplicationJson.new,
      )
      ..add(MatterbridgeDeleteBridgeOfRoomResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(MatterbridgeDeleteBridgeOfRoomResponseApplicationJson_Ocs),
        MatterbridgeDeleteBridgeOfRoomResponseApplicationJson_Ocs.new,
      )
      ..add(MatterbridgeDeleteBridgeOfRoomResponseApplicationJson_Ocs.serializer)
      ..add(MatterbridgeGetBridgeProcessStateApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(MatterbridgeGetBridgeProcessStateResponseApplicationJson),
        MatterbridgeGetBridgeProcessStateResponseApplicationJson.new,
      )
      ..add(MatterbridgeGetBridgeProcessStateResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(MatterbridgeGetBridgeProcessStateResponseApplicationJson_Ocs),
        MatterbridgeGetBridgeProcessStateResponseApplicationJson_Ocs.new,
      )
      ..add(MatterbridgeGetBridgeProcessStateResponseApplicationJson_Ocs.serializer)
      ..add(MatterbridgeSettingsStopAllBridgesApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(MatterbridgeSettingsStopAllBridgesResponseApplicationJson),
        MatterbridgeSettingsStopAllBridgesResponseApplicationJson.new,
      )
      ..add(MatterbridgeSettingsStopAllBridgesResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(MatterbridgeSettingsStopAllBridgesResponseApplicationJson_Ocs),
        MatterbridgeSettingsStopAllBridgesResponseApplicationJson_Ocs.new,
      )
      ..add(MatterbridgeSettingsStopAllBridgesResponseApplicationJson_Ocs.serializer)
      ..add(MatterbridgeSettingsGetMatterbridgeVersionApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson),
        MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson.new,
      )
      ..add(MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson_Ocs),
        MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson_Ocs.new,
      )
      ..add(MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(
        const FullType(MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson_Ocs_Data),
        MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson_Ocs_Data.new,
      )
      ..add(MatterbridgeSettingsGetMatterbridgeVersionResponseApplicationJson_Ocs_Data.serializer)
      ..addBuilderFactory(const FullType(BuiltList, [FullType(String)]), ListBuilder<String>.new)
      ..add(PollCreatePollApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(PollCreatePollResponseApplicationJson),
        PollCreatePollResponseApplicationJson.new,
      )
      ..add(PollCreatePollResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(PollCreatePollResponseApplicationJson_Ocs),
        PollCreatePollResponseApplicationJson_Ocs.new,
      )
      ..add(PollCreatePollResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(const FullType(Poll), Poll.new)
      ..add(Poll.serializer)
      ..addBuilderFactory(const FullType(PollVote), PollVote.new)
      ..add(PollVote.serializer)
      ..addBuilderFactory(const FullType(BuiltList, [FullType(PollVote)]), ListBuilder<PollVote>.new)
      ..addBuilderFactory(const FullType(BuiltList, [FullType(int)]), ListBuilder<int>.new)
      ..add(PollShowPollApiVersion.serializer)
      ..addBuilderFactory(const FullType(PollShowPollResponseApplicationJson), PollShowPollResponseApplicationJson.new)
      ..add(PollShowPollResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(PollShowPollResponseApplicationJson_Ocs),
        PollShowPollResponseApplicationJson_Ocs.new,
      )
      ..add(PollShowPollResponseApplicationJson_Ocs.serializer)
      ..add(PollVotePollApiVersion.serializer)
      ..addBuilderFactory(const FullType(PollVotePollResponseApplicationJson), PollVotePollResponseApplicationJson.new)
      ..add(PollVotePollResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(PollVotePollResponseApplicationJson_Ocs),
        PollVotePollResponseApplicationJson_Ocs.new,
      )
      ..add(PollVotePollResponseApplicationJson_Ocs.serializer)
      ..add(PollClosePollApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(PollClosePollResponseApplicationJson),
        PollClosePollResponseApplicationJson.new,
      )
      ..add(PollClosePollResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(PollClosePollResponseApplicationJson_Ocs),
        PollClosePollResponseApplicationJson_Ocs.new,
      )
      ..add(PollClosePollResponseApplicationJson_Ocs.serializer)
      ..add(PublicShareAuthCreateRoomApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(PublicShareAuthCreateRoomResponseApplicationJson),
        PublicShareAuthCreateRoomResponseApplicationJson.new,
      )
      ..add(PublicShareAuthCreateRoomResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(PublicShareAuthCreateRoomResponseApplicationJson_Ocs),
        PublicShareAuthCreateRoomResponseApplicationJson_Ocs.new,
      )
      ..add(PublicShareAuthCreateRoomResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(
        const FullType(PublicShareAuthCreateRoomResponseApplicationJson_Ocs_Data),
        PublicShareAuthCreateRoomResponseApplicationJson_Ocs_Data.new,
      )
      ..add(PublicShareAuthCreateRoomResponseApplicationJson_Ocs_Data.serializer)
      ..add(ReactionGetReactionsApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(ReactionGetReactionsResponseApplicationJson),
        ReactionGetReactionsResponseApplicationJson.new,
      )
      ..add(ReactionGetReactionsResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(ReactionGetReactionsResponseApplicationJson_Ocs),
        ReactionGetReactionsResponseApplicationJson_Ocs.new,
      )
      ..add(ReactionGetReactionsResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(const FullType(Reaction), Reaction.new)
      ..add(Reaction.serializer)
      ..addBuilderFactory(const FullType(BuiltList, [FullType(Reaction)]), ListBuilder<Reaction>.new)
      ..addBuilderFactory(
        const FullType(BuiltMap, [
          FullType(String),
          FullType(BuiltList, [FullType(Reaction)]),
        ]),
        MapBuilder<String, BuiltList>.new,
      )
      ..add(ReactionReactApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(ReactionReactResponseApplicationJson),
        ReactionReactResponseApplicationJson.new,
      )
      ..add(ReactionReactResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(ReactionReactResponseApplicationJson_Ocs),
        ReactionReactResponseApplicationJson_Ocs.new,
      )
      ..add(ReactionReactResponseApplicationJson_Ocs.serializer)
      ..add(ReactionDeleteApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(ReactionDeleteResponseApplicationJson),
        ReactionDeleteResponseApplicationJson.new,
      )
      ..add(ReactionDeleteResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(ReactionDeleteResponseApplicationJson_Ocs),
        ReactionDeleteResponseApplicationJson_Ocs.new,
      )
      ..add(ReactionDeleteResponseApplicationJson_Ocs.serializer)
      ..add(RecordingGetWelcomeMessageApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RecordingGetWelcomeMessageResponseApplicationJson),
        RecordingGetWelcomeMessageResponseApplicationJson.new,
      )
      ..add(RecordingGetWelcomeMessageResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RecordingGetWelcomeMessageResponseApplicationJson_Ocs),
        RecordingGetWelcomeMessageResponseApplicationJson_Ocs.new,
      )
      ..add(RecordingGetWelcomeMessageResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(
        const FullType(RecordingGetWelcomeMessageResponseApplicationJson_Ocs_Data),
        RecordingGetWelcomeMessageResponseApplicationJson_Ocs_Data.new,
      )
      ..add(RecordingGetWelcomeMessageResponseApplicationJson_Ocs_Data.serializer)
      ..add(RecordingStartApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RecordingStartResponseApplicationJson),
        RecordingStartResponseApplicationJson.new,
      )
      ..add(RecordingStartResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RecordingStartResponseApplicationJson_Ocs),
        RecordingStartResponseApplicationJson_Ocs.new,
      )
      ..add(RecordingStartResponseApplicationJson_Ocs.serializer)
      ..add(RecordingStopApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RecordingStopResponseApplicationJson),
        RecordingStopResponseApplicationJson.new,
      )
      ..add(RecordingStopResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RecordingStopResponseApplicationJson_Ocs),
        RecordingStopResponseApplicationJson_Ocs.new,
      )
      ..add(RecordingStopResponseApplicationJson_Ocs.serializer)
      ..add(RecordingStoreApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RecordingStoreResponseApplicationJson),
        RecordingStoreResponseApplicationJson.new,
      )
      ..add(RecordingStoreResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RecordingStoreResponseApplicationJson_Ocs),
        RecordingStoreResponseApplicationJson_Ocs.new,
      )
      ..add(RecordingStoreResponseApplicationJson_Ocs.serializer)
      ..add(RecordingNotificationDismissApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RecordingNotificationDismissResponseApplicationJson),
        RecordingNotificationDismissResponseApplicationJson.new,
      )
      ..add(RecordingNotificationDismissResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RecordingNotificationDismissResponseApplicationJson_Ocs),
        RecordingNotificationDismissResponseApplicationJson_Ocs.new,
      )
      ..add(RecordingNotificationDismissResponseApplicationJson_Ocs.serializer)
      ..add(RecordingShareToChatApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RecordingShareToChatResponseApplicationJson),
        RecordingShareToChatResponseApplicationJson.new,
      )
      ..add(RecordingShareToChatResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RecordingShareToChatResponseApplicationJson_Ocs),
        RecordingShareToChatResponseApplicationJson_Ocs.new,
      )
      ..add(RecordingShareToChatResponseApplicationJson_Ocs.serializer)
      ..add(RoomGetRoomsApiVersion.serializer)
      ..addBuilderFactory(const FullType(RoomRoomGetRoomsHeaders), RoomRoomGetRoomsHeaders.new)
      ..add(RoomRoomGetRoomsHeaders.serializer)
      ..addBuilderFactory(const FullType(RoomGetRoomsResponseApplicationJson), RoomGetRoomsResponseApplicationJson.new)
      ..add(RoomGetRoomsResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomGetRoomsResponseApplicationJson_Ocs),
        RoomGetRoomsResponseApplicationJson_Ocs.new,
      )
      ..add(RoomGetRoomsResponseApplicationJson_Ocs.serializer)
      ..add(RoomCreateRoomApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomCreateRoomResponseApplicationJson),
        RoomCreateRoomResponseApplicationJson.new,
      )
      ..add(RoomCreateRoomResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomCreateRoomResponseApplicationJson_Ocs),
        RoomCreateRoomResponseApplicationJson_Ocs.new,
      )
      ..add(RoomCreateRoomResponseApplicationJson_Ocs.serializer)
      ..add(RoomGetListedRoomsApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomGetListedRoomsResponseApplicationJson),
        RoomGetListedRoomsResponseApplicationJson.new,
      )
      ..add(RoomGetListedRoomsResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomGetListedRoomsResponseApplicationJson_Ocs),
        RoomGetListedRoomsResponseApplicationJson_Ocs.new,
      )
      ..add(RoomGetListedRoomsResponseApplicationJson_Ocs.serializer)
      ..add(RoomGetNoteToSelfConversationApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomRoomGetNoteToSelfConversationHeaders),
        RoomRoomGetNoteToSelfConversationHeaders.new,
      )
      ..add(RoomRoomGetNoteToSelfConversationHeaders.serializer)
      ..addBuilderFactory(
        const FullType(RoomGetNoteToSelfConversationResponseApplicationJson),
        RoomGetNoteToSelfConversationResponseApplicationJson.new,
      )
      ..add(RoomGetNoteToSelfConversationResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomGetNoteToSelfConversationResponseApplicationJson_Ocs),
        RoomGetNoteToSelfConversationResponseApplicationJson_Ocs.new,
      )
      ..add(RoomGetNoteToSelfConversationResponseApplicationJson_Ocs.serializer)
      ..add(RoomGetSingleRoomApiVersion.serializer)
      ..addBuilderFactory(const FullType(RoomRoomGetSingleRoomHeaders), RoomRoomGetSingleRoomHeaders.new)
      ..add(RoomRoomGetSingleRoomHeaders.serializer)
      ..addBuilderFactory(
        const FullType(RoomGetSingleRoomResponseApplicationJson),
        RoomGetSingleRoomResponseApplicationJson.new,
      )
      ..add(RoomGetSingleRoomResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomGetSingleRoomResponseApplicationJson_Ocs),
        RoomGetSingleRoomResponseApplicationJson_Ocs.new,
      )
      ..add(RoomGetSingleRoomResponseApplicationJson_Ocs.serializer)
      ..add(RoomRenameRoomApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomRenameRoomResponseApplicationJson),
        RoomRenameRoomResponseApplicationJson.new,
      )
      ..add(RoomRenameRoomResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomRenameRoomResponseApplicationJson_Ocs),
        RoomRenameRoomResponseApplicationJson_Ocs.new,
      )
      ..add(RoomRenameRoomResponseApplicationJson_Ocs.serializer)
      ..add(RoomDeleteRoomApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomDeleteRoomResponseApplicationJson),
        RoomDeleteRoomResponseApplicationJson.new,
      )
      ..add(RoomDeleteRoomResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomDeleteRoomResponseApplicationJson_Ocs),
        RoomDeleteRoomResponseApplicationJson_Ocs.new,
      )
      ..add(RoomDeleteRoomResponseApplicationJson_Ocs.serializer)
      ..add(RoomGetBreakoutRoomsApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomGetBreakoutRoomsResponseApplicationJson),
        RoomGetBreakoutRoomsResponseApplicationJson.new,
      )
      ..add(RoomGetBreakoutRoomsResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomGetBreakoutRoomsResponseApplicationJson_Ocs),
        RoomGetBreakoutRoomsResponseApplicationJson_Ocs.new,
      )
      ..add(RoomGetBreakoutRoomsResponseApplicationJson_Ocs.serializer)
      ..add(RoomMakePublicApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomMakePublicResponseApplicationJson),
        RoomMakePublicResponseApplicationJson.new,
      )
      ..add(RoomMakePublicResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomMakePublicResponseApplicationJson_Ocs),
        RoomMakePublicResponseApplicationJson_Ocs.new,
      )
      ..add(RoomMakePublicResponseApplicationJson_Ocs.serializer)
      ..add(RoomMakePrivateApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomMakePrivateResponseApplicationJson),
        RoomMakePrivateResponseApplicationJson.new,
      )
      ..add(RoomMakePrivateResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomMakePrivateResponseApplicationJson_Ocs),
        RoomMakePrivateResponseApplicationJson_Ocs.new,
      )
      ..add(RoomMakePrivateResponseApplicationJson_Ocs.serializer)
      ..add(RoomSetDescriptionApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomSetDescriptionResponseApplicationJson),
        RoomSetDescriptionResponseApplicationJson.new,
      )
      ..add(RoomSetDescriptionResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomSetDescriptionResponseApplicationJson_Ocs),
        RoomSetDescriptionResponseApplicationJson_Ocs.new,
      )
      ..add(RoomSetDescriptionResponseApplicationJson_Ocs.serializer)
      ..add(RoomSetReadOnlyApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomSetReadOnlyResponseApplicationJson),
        RoomSetReadOnlyResponseApplicationJson.new,
      )
      ..add(RoomSetReadOnlyResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomSetReadOnlyResponseApplicationJson_Ocs),
        RoomSetReadOnlyResponseApplicationJson_Ocs.new,
      )
      ..add(RoomSetReadOnlyResponseApplicationJson_Ocs.serializer)
      ..add(RoomSetListableApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomSetListableResponseApplicationJson),
        RoomSetListableResponseApplicationJson.new,
      )
      ..add(RoomSetListableResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomSetListableResponseApplicationJson_Ocs),
        RoomSetListableResponseApplicationJson_Ocs.new,
      )
      ..add(RoomSetListableResponseApplicationJson_Ocs.serializer)
      ..add(RoomSetPasswordApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomSetPasswordResponseApplicationJson),
        RoomSetPasswordResponseApplicationJson.new,
      )
      ..add(RoomSetPasswordResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomSetPasswordResponseApplicationJson_Ocs),
        RoomSetPasswordResponseApplicationJson_Ocs.new,
      )
      ..add(RoomSetPasswordResponseApplicationJson_Ocs.serializer)
      ..add(RoomSetPermissionsApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomSetPermissionsResponseApplicationJson),
        RoomSetPermissionsResponseApplicationJson.new,
      )
      ..add(RoomSetPermissionsResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomSetPermissionsResponseApplicationJson_Ocs),
        RoomSetPermissionsResponseApplicationJson_Ocs.new,
      )
      ..add(RoomSetPermissionsResponseApplicationJson_Ocs.serializer)
      ..add(RoomGetParticipantsApiVersion.serializer)
      ..addBuilderFactory(const FullType(RoomRoomGetParticipantsHeaders), RoomRoomGetParticipantsHeaders.new)
      ..add(RoomRoomGetParticipantsHeaders.serializer)
      ..addBuilderFactory(
        const FullType(RoomGetParticipantsResponseApplicationJson),
        RoomGetParticipantsResponseApplicationJson.new,
      )
      ..add(RoomGetParticipantsResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomGetParticipantsResponseApplicationJson_Ocs),
        RoomGetParticipantsResponseApplicationJson_Ocs.new,
      )
      ..add(RoomGetParticipantsResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(const FullType(Participant), Participant.new)
      ..add(Participant.serializer)
      ..addBuilderFactory(const FullType(BuiltList, [FullType(Participant)]), ListBuilder<Participant>.new)
      ..add(RoomAddParticipantToRoomApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomAddParticipantToRoomResponseApplicationJson),
        RoomAddParticipantToRoomResponseApplicationJson.new,
      )
      ..add(RoomAddParticipantToRoomResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomAddParticipantToRoomResponseApplicationJson_Ocs),
        RoomAddParticipantToRoomResponseApplicationJson_Ocs.new,
      )
      ..add(RoomAddParticipantToRoomResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(
        const FullType(RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data),
        RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data.new,
      )
      ..add(RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data.serializer)
      ..addBuilderFactory(
        const FullType(RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data0),
        RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data0.new,
      )
      ..add(RoomAddParticipantToRoomResponseApplicationJson_Ocs_Data0.serializer)
      ..add(RoomGetBreakoutRoomParticipantsApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomRoomGetBreakoutRoomParticipantsHeaders),
        RoomRoomGetBreakoutRoomParticipantsHeaders.new,
      )
      ..add(RoomRoomGetBreakoutRoomParticipantsHeaders.serializer)
      ..addBuilderFactory(
        const FullType(RoomGetBreakoutRoomParticipantsResponseApplicationJson),
        RoomGetBreakoutRoomParticipantsResponseApplicationJson.new,
      )
      ..add(RoomGetBreakoutRoomParticipantsResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomGetBreakoutRoomParticipantsResponseApplicationJson_Ocs),
        RoomGetBreakoutRoomParticipantsResponseApplicationJson_Ocs.new,
      )
      ..add(RoomGetBreakoutRoomParticipantsResponseApplicationJson_Ocs.serializer)
      ..add(RoomRemoveSelfFromRoomApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomRemoveSelfFromRoomResponseApplicationJson),
        RoomRemoveSelfFromRoomResponseApplicationJson.new,
      )
      ..add(RoomRemoveSelfFromRoomResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomRemoveSelfFromRoomResponseApplicationJson_Ocs),
        RoomRemoveSelfFromRoomResponseApplicationJson_Ocs.new,
      )
      ..add(RoomRemoveSelfFromRoomResponseApplicationJson_Ocs.serializer)
      ..add(RoomRemoveAttendeeFromRoomApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomRemoveAttendeeFromRoomResponseApplicationJson),
        RoomRemoveAttendeeFromRoomResponseApplicationJson.new,
      )
      ..add(RoomRemoveAttendeeFromRoomResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomRemoveAttendeeFromRoomResponseApplicationJson_Ocs),
        RoomRemoveAttendeeFromRoomResponseApplicationJson_Ocs.new,
      )
      ..add(RoomRemoveAttendeeFromRoomResponseApplicationJson_Ocs.serializer)
      ..add(RoomSetAttendeePermissionsApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomSetAttendeePermissionsResponseApplicationJson),
        RoomSetAttendeePermissionsResponseApplicationJson.new,
      )
      ..add(RoomSetAttendeePermissionsResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomSetAttendeePermissionsResponseApplicationJson_Ocs),
        RoomSetAttendeePermissionsResponseApplicationJson_Ocs.new,
      )
      ..add(RoomSetAttendeePermissionsResponseApplicationJson_Ocs.serializer)
      ..add(RoomSetAllAttendeesPermissionsApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomSetAllAttendeesPermissionsResponseApplicationJson),
        RoomSetAllAttendeesPermissionsResponseApplicationJson.new,
      )
      ..add(RoomSetAllAttendeesPermissionsResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomSetAllAttendeesPermissionsResponseApplicationJson_Ocs),
        RoomSetAllAttendeesPermissionsResponseApplicationJson_Ocs.new,
      )
      ..add(RoomSetAllAttendeesPermissionsResponseApplicationJson_Ocs.serializer)
      ..add(RoomJoinRoomApiVersion.serializer)
      ..addBuilderFactory(const FullType(RoomJoinRoomResponseApplicationJson), RoomJoinRoomResponseApplicationJson.new)
      ..add(RoomJoinRoomResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomJoinRoomResponseApplicationJson_Ocs),
        RoomJoinRoomResponseApplicationJson_Ocs.new,
      )
      ..add(RoomJoinRoomResponseApplicationJson_Ocs.serializer)
      ..add(RoomLeaveRoomApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomLeaveRoomResponseApplicationJson),
        RoomLeaveRoomResponseApplicationJson.new,
      )
      ..add(RoomLeaveRoomResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomLeaveRoomResponseApplicationJson_Ocs),
        RoomLeaveRoomResponseApplicationJson_Ocs.new,
      )
      ..add(RoomLeaveRoomResponseApplicationJson_Ocs.serializer)
      ..add(RoomResendInvitationsApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomResendInvitationsResponseApplicationJson),
        RoomResendInvitationsResponseApplicationJson.new,
      )
      ..add(RoomResendInvitationsResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomResendInvitationsResponseApplicationJson_Ocs),
        RoomResendInvitationsResponseApplicationJson_Ocs.new,
      )
      ..add(RoomResendInvitationsResponseApplicationJson_Ocs.serializer)
      ..add(RoomSetSessionStateApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomSetSessionStateResponseApplicationJson),
        RoomSetSessionStateResponseApplicationJson.new,
      )
      ..add(RoomSetSessionStateResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomSetSessionStateResponseApplicationJson_Ocs),
        RoomSetSessionStateResponseApplicationJson_Ocs.new,
      )
      ..add(RoomSetSessionStateResponseApplicationJson_Ocs.serializer)
      ..add(RoomPromoteModeratorApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomPromoteModeratorResponseApplicationJson),
        RoomPromoteModeratorResponseApplicationJson.new,
      )
      ..add(RoomPromoteModeratorResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomPromoteModeratorResponseApplicationJson_Ocs),
        RoomPromoteModeratorResponseApplicationJson_Ocs.new,
      )
      ..add(RoomPromoteModeratorResponseApplicationJson_Ocs.serializer)
      ..add(RoomDemoteModeratorApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomDemoteModeratorResponseApplicationJson),
        RoomDemoteModeratorResponseApplicationJson.new,
      )
      ..add(RoomDemoteModeratorResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomDemoteModeratorResponseApplicationJson_Ocs),
        RoomDemoteModeratorResponseApplicationJson_Ocs.new,
      )
      ..add(RoomDemoteModeratorResponseApplicationJson_Ocs.serializer)
      ..add(RoomAddToFavoritesApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomAddToFavoritesResponseApplicationJson),
        RoomAddToFavoritesResponseApplicationJson.new,
      )
      ..add(RoomAddToFavoritesResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomAddToFavoritesResponseApplicationJson_Ocs),
        RoomAddToFavoritesResponseApplicationJson_Ocs.new,
      )
      ..add(RoomAddToFavoritesResponseApplicationJson_Ocs.serializer)
      ..add(RoomRemoveFromFavoritesApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomRemoveFromFavoritesResponseApplicationJson),
        RoomRemoveFromFavoritesResponseApplicationJson.new,
      )
      ..add(RoomRemoveFromFavoritesResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomRemoveFromFavoritesResponseApplicationJson_Ocs),
        RoomRemoveFromFavoritesResponseApplicationJson_Ocs.new,
      )
      ..add(RoomRemoveFromFavoritesResponseApplicationJson_Ocs.serializer)
      ..add(RoomSetNotificationLevelApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomSetNotificationLevelResponseApplicationJson),
        RoomSetNotificationLevelResponseApplicationJson.new,
      )
      ..add(RoomSetNotificationLevelResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomSetNotificationLevelResponseApplicationJson_Ocs),
        RoomSetNotificationLevelResponseApplicationJson_Ocs.new,
      )
      ..add(RoomSetNotificationLevelResponseApplicationJson_Ocs.serializer)
      ..add(RoomSetNotificationCallsApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomSetNotificationCallsResponseApplicationJson),
        RoomSetNotificationCallsResponseApplicationJson.new,
      )
      ..add(RoomSetNotificationCallsResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomSetNotificationCallsResponseApplicationJson_Ocs),
        RoomSetNotificationCallsResponseApplicationJson_Ocs.new,
      )
      ..add(RoomSetNotificationCallsResponseApplicationJson_Ocs.serializer)
      ..add(RoomSetLobbyApiVersion.serializer)
      ..addBuilderFactory(const FullType(RoomSetLobbyResponseApplicationJson), RoomSetLobbyResponseApplicationJson.new)
      ..add(RoomSetLobbyResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomSetLobbyResponseApplicationJson_Ocs),
        RoomSetLobbyResponseApplicationJson_Ocs.new,
      )
      ..add(RoomSetLobbyResponseApplicationJson_Ocs.serializer)
      ..add(RoomSetsipEnabledApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomSetsipEnabledResponseApplicationJson),
        RoomSetsipEnabledResponseApplicationJson.new,
      )
      ..add(RoomSetsipEnabledResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomSetsipEnabledResponseApplicationJson_Ocs),
        RoomSetsipEnabledResponseApplicationJson_Ocs.new,
      )
      ..add(RoomSetsipEnabledResponseApplicationJson_Ocs.serializer)
      ..add(RoomSetRecordingConsentApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomSetRecordingConsentResponseApplicationJson),
        RoomSetRecordingConsentResponseApplicationJson.new,
      )
      ..add(RoomSetRecordingConsentResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomSetRecordingConsentResponseApplicationJson_Ocs),
        RoomSetRecordingConsentResponseApplicationJson_Ocs.new,
      )
      ..add(RoomSetRecordingConsentResponseApplicationJson_Ocs.serializer)
      ..add(RoomSetMessageExpirationApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(RoomSetMessageExpirationResponseApplicationJson),
        RoomSetMessageExpirationResponseApplicationJson.new,
      )
      ..add(RoomSetMessageExpirationResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(RoomSetMessageExpirationResponseApplicationJson_Ocs),
        RoomSetMessageExpirationResponseApplicationJson_Ocs.new,
      )
      ..add(RoomSetMessageExpirationResponseApplicationJson_Ocs.serializer)
      ..add(SettingsSetsipSettingsApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(SettingsSetsipSettingsResponseApplicationJson),
        SettingsSetsipSettingsResponseApplicationJson.new,
      )
      ..add(SettingsSetsipSettingsResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(SettingsSetsipSettingsResponseApplicationJson_Ocs),
        SettingsSetsipSettingsResponseApplicationJson_Ocs.new,
      )
      ..add(SettingsSetsipSettingsResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(const FullType(SettingsSetUserSettingValue), SettingsSetUserSettingValue.new)
      ..add(SettingsSetUserSettingValue.serializer)
      ..addBuilderFactory(
        const FullType(ContentString, [FullType(SettingsSetUserSettingValue)]),
        ContentString<SettingsSetUserSettingValue>.new,
      )
      ..add(SettingsSetUserSettingApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(SettingsSetUserSettingResponseApplicationJson),
        SettingsSetUserSettingResponseApplicationJson.new,
      )
      ..add(SettingsSetUserSettingResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(SettingsSetUserSettingResponseApplicationJson_Ocs),
        SettingsSetUserSettingResponseApplicationJson_Ocs.new,
      )
      ..add(SettingsSetUserSettingResponseApplicationJson_Ocs.serializer)
      ..add(SignalingGetSettingsApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(SignalingGetSettingsResponseApplicationJson),
        SignalingGetSettingsResponseApplicationJson.new,
      )
      ..add(SignalingGetSettingsResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(SignalingGetSettingsResponseApplicationJson_Ocs),
        SignalingGetSettingsResponseApplicationJson_Ocs.new,
      )
      ..add(SignalingGetSettingsResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(const FullType(SignalingSettings), SignalingSettings.new)
      ..add(SignalingSettings.serializer)
      ..addBuilderFactory(const FullType(SignalingSettings_HelloAuthParams), SignalingSettings_HelloAuthParams.new)
      ..add(SignalingSettings_HelloAuthParams.serializer)
      ..addBuilderFactory(
        const FullType(SignalingSettings_HelloAuthParams_$10),
        SignalingSettings_HelloAuthParams_$10.new,
      )
      ..add(SignalingSettings_HelloAuthParams_$10.serializer)
      ..addBuilderFactory(
        const FullType(SignalingSettings_HelloAuthParams_$20),
        SignalingSettings_HelloAuthParams_$20.new,
      )
      ..add(SignalingSettings_HelloAuthParams_$20.serializer)
      ..addBuilderFactory(const FullType(SignalingSettings_Stunservers), SignalingSettings_Stunservers.new)
      ..add(SignalingSettings_Stunservers.serializer)
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(SignalingSettings_Stunservers)]),
        ListBuilder<SignalingSettings_Stunservers>.new,
      )
      ..addBuilderFactory(const FullType(SignalingSettings_Turnservers), SignalingSettings_Turnservers.new)
      ..add(SignalingSettings_Turnservers.serializer)
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(SignalingSettings_Turnservers)]),
        ListBuilder<SignalingSettings_Turnservers>.new,
      )
      ..add(SignalingGetWelcomeMessageApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(SignalingGetWelcomeMessageResponseApplicationJson),
        SignalingGetWelcomeMessageResponseApplicationJson.new,
      )
      ..add(SignalingGetWelcomeMessageResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(SignalingGetWelcomeMessageResponseApplicationJson_Ocs),
        SignalingGetWelcomeMessageResponseApplicationJson_Ocs.new,
      )
      ..add(SignalingGetWelcomeMessageResponseApplicationJson_Ocs.serializer)
      ..add(SignalingPullMessagesApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(SignalingPullMessagesResponseApplicationJson),
        SignalingPullMessagesResponseApplicationJson.new,
      )
      ..add(SignalingPullMessagesResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(SignalingPullMessagesResponseApplicationJson_Ocs),
        SignalingPullMessagesResponseApplicationJson_Ocs.new,
      )
      ..add(SignalingPullMessagesResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(
        const FullType(SignalingPullMessagesResponseApplicationJson_Ocs_Data),
        SignalingPullMessagesResponseApplicationJson_Ocs_Data.new,
      )
      ..add(SignalingPullMessagesResponseApplicationJson_Ocs_Data.serializer)
      ..addBuilderFactory(
        const FullType(SignalingPullMessagesResponseApplicationJson_Ocs_Data_Data),
        SignalingPullMessagesResponseApplicationJson_Ocs_Data_Data.new,
      )
      ..add(SignalingPullMessagesResponseApplicationJson_Ocs_Data_Data.serializer)
      ..addBuilderFactory(const FullType(SignalingSession), SignalingSession.new)
      ..add(SignalingSession.serializer)
      ..addBuilderFactory(const FullType(BuiltList, [FullType(SignalingSession)]), ListBuilder<SignalingSession>.new)
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(SignalingPullMessagesResponseApplicationJson_Ocs_Data)]),
        ListBuilder<SignalingPullMessagesResponseApplicationJson_Ocs_Data>.new,
      )
      ..add(SignalingSendMessagesApiVersion.serializer)
      ..addBuilderFactory(
        const FullType(SignalingSendMessagesResponseApplicationJson),
        SignalingSendMessagesResponseApplicationJson.new,
      )
      ..add(SignalingSendMessagesResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(SignalingSendMessagesResponseApplicationJson_Ocs),
        SignalingSendMessagesResponseApplicationJson_Ocs.new,
      )
      ..add(SignalingSendMessagesResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(
        const FullType(TempAvatarPostAvatarResponseApplicationJson),
        TempAvatarPostAvatarResponseApplicationJson.new,
      )
      ..add(TempAvatarPostAvatarResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(TempAvatarPostAvatarResponseApplicationJson_Ocs),
        TempAvatarPostAvatarResponseApplicationJson_Ocs.new,
      )
      ..add(TempAvatarPostAvatarResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(
        const FullType(TempAvatarDeleteAvatarResponseApplicationJson),
        TempAvatarDeleteAvatarResponseApplicationJson.new,
      )
      ..add(TempAvatarDeleteAvatarResponseApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(TempAvatarDeleteAvatarResponseApplicationJson_Ocs),
        TempAvatarDeleteAvatarResponseApplicationJson_Ocs.new,
      )
      ..add(TempAvatarDeleteAvatarResponseApplicationJson_Ocs.serializer)
      ..addBuilderFactory(const FullType(BotWithDetailsAndSecret), BotWithDetailsAndSecret.new)
      ..add(BotWithDetailsAndSecret.serializer)
      ..addBuilderFactory(const FullType(PublicCapabilities), PublicCapabilities.new)
      ..add(PublicCapabilities.serializer)
      ..addBuilderFactory(const FullType(PublicCapabilities0), PublicCapabilities0.new)
      ..add(PublicCapabilities0.serializer)
      ..addBuilderFactory(const FullType(PublicCapabilities0_Spreed), PublicCapabilities0_Spreed.new)
      ..add(PublicCapabilities0_Spreed.serializer)
      ..addBuilderFactory(const FullType(PublicCapabilities0_Spreed_Config), PublicCapabilities0_Spreed_Config.new)
      ..add(PublicCapabilities0_Spreed_Config.serializer)
      ..addBuilderFactory(
        const FullType(PublicCapabilities0_Spreed_Config_Attachments),
        PublicCapabilities0_Spreed_Config_Attachments.new,
      )
      ..add(PublicCapabilities0_Spreed_Config_Attachments.serializer)
      ..addBuilderFactory(
        const FullType(PublicCapabilities0_Spreed_Config_Call),
        PublicCapabilities0_Spreed_Config_Call.new,
      )
      ..add(PublicCapabilities0_Spreed_Config_Call.serializer)
      ..addBuilderFactory(
        const FullType(PublicCapabilities0_Spreed_Config_Chat),
        PublicCapabilities0_Spreed_Config_Chat.new,
      )
      ..add(PublicCapabilities0_Spreed_Config_Chat.serializer)
      ..addBuilderFactory(
        const FullType(PublicCapabilities0_Spreed_Config_Conversations),
        PublicCapabilities0_Spreed_Config_Conversations.new,
      )
      ..add(PublicCapabilities0_Spreed_Config_Conversations.serializer)
      ..addBuilderFactory(
        const FullType(PublicCapabilities0_Spreed_Config_Previews),
        PublicCapabilities0_Spreed_Config_Previews.new,
      )
      ..add(PublicCapabilities0_Spreed_Config_Previews.serializer)
      ..addBuilderFactory(
        const FullType(PublicCapabilities0_Spreed_Config_Signaling),
        PublicCapabilities0_Spreed_Config_Signaling.new,
      )
      ..add(PublicCapabilities0_Spreed_Config_Signaling.serializer))
    .build();

final Serializers _jsonSerializers = (_serializers.toBuilder()
      ..add(DynamiteDoubleSerializer())
      ..addPlugin(StandardJsonPlugin())
      ..addPlugin(const ContentStringPlugin()))
    .build();
// coverage:ignore-end
