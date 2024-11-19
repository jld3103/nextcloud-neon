import 'dart:async';

import 'package:dynamite_runtime/http_client.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_framework/src/bloc/bloc.dart';
import 'package:neon_framework/src/bloc/result.dart';
import 'package:neon_framework/src/utils/request_manager.dart';
import 'package:nextcloud/provisioning_api.dart' as provisioning_api;
import 'package:rxdart/rxdart.dart';

/// Bloc for managing the user details of the account.
@sealed
abstract class UserDetailsBloc implements InteractiveBloc {
  /// Creates a new user details Bloc.
  @internal
  factory UserDetailsBloc({
    required Account account,
  }) = _UserDetailsBloc;

  /// Contains the user details.
  BehaviorSubject<Result<provisioning_api.UserDetails>> get userDetails;

  /// Updates a property of the [userDetails].
  void updateProperty(String key, String value);
}

class _UserDetailsBloc extends InteractiveBloc implements UserDetailsBloc {
  _UserDetailsBloc({
    required this.account,
  }) {
    unawaited(refresh());
  }

  @override
  final log = Logger('UserDetailsBloc');

  final Account account;

  @override
  void dispose() {
    unawaited(userDetails.close());
    super.dispose();
  }

  @override
  final userDetails = BehaviorSubject();

  @override
  Future<void> refresh() async {
    await RequestManager.instance.wrap(
      account: account,
      subject: userDetails,
      getRequest: account.client.provisioningApi.users.$getCurrentUser_Request,
      converter: ResponseConverter(account.client.provisioningApi.users.$getCurrentUser_Serializer()),
      unwrap: (response) => response.body.ocs.data,
    );
  }

  @override
  Future<void> updateProperty(String key, String value) async {
    await wrapAction(
      () async {
        userDetails.add(userDetails.valueOrNull?.asLoading() ?? Result.loading());

        await account.client.provisioningApi.users.editUser(
          userId: account.username,
          $body: provisioning_api.UsersEditUserRequestApplicationJson(
            (b) => b
              ..key = key
              ..value = value,
          ),
        );

        var data = userDetails.valueOrNull?.data;
        if (data == null) {
          return;
        }

        final raw = data.toJson();
        raw[key] = value;
        data = provisioning_api.UserDetails.fromJson(raw);

        userDetails.add(Result.success(data));
      },
      refresh: () async {},
    );
  }
}
