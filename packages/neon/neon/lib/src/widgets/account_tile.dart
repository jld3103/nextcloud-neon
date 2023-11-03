import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intersperse/intersperse.dart';
import 'package:meta/meta.dart';
import 'package:neon/src/bloc/result.dart';
import 'package:neon/src/blocs/accounts.dart';
import 'package:neon/src/models/account.dart';
import 'package:neon/src/utils/provider.dart';
import 'package:neon/src/widgets/adaptive_widgets/list_tile.dart';
import 'package:neon/src/widgets/error.dart';
import 'package:neon/src/widgets/linear_progress_indicator.dart';
import 'package:neon/src/widgets/user_avatar.dart';
import 'package:nextcloud/provisioning_api.dart' as provisioning_api;

/// List tile to display account information.
@internal
class NeonAccountTile extends StatelessWidget {
  /// Creates a new account list tile.
  const NeonAccountTile({
    required this.account,
    this.trailing,
    this.onTap,
    this.showStatus = true,
    super.key,
  });

  /// {@template neon.AccountTile.account}
  /// The account to display inside the tile.
  /// {@endtemplate}
  final Account account;

  /// {@macro neon.AdaptiveListTile.trailing}
  final Widget? trailing;

  /// {@macro neon.AdaptiveListTile.onTap}
  final FutureOr<void> Function()? onTap;

  /// Whether to also show the status on the avatar.
  ///
  /// See:
  ///   * [NeonUserAvatar.showStatus]
  final bool showStatus;

  @override
  Widget build(final BuildContext context) {
    final userDetailsBloc = NeonProvider.of<AccountsBloc>(context).getUserDetailsBlocFor(account);

    return AdaptiveListTile(
      onTap: onTap,
      leading: NeonUserAvatar(
        account: account,
        showStatus: showStatus,
      ),
      trailing: trailing,
      title: ResultBuilder<provisioning_api.UserDetails>.behaviorSubject(
        subject: userDetailsBloc.userDetails,
        builder: (final context, final userDetails) => Row(
          children: [
            if (userDetails.hasData)
              Flexible(
                child: Text(
                  userDetails.requireData.displayname,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            Expanded(
              child: NeonLinearProgressIndicator(
                visible: userDetails.isLoading,
              ),
            ),
            if (userDetails.hasError)
              NeonError(
                userDetails.error,
                type: NeonErrorType.iconOnly,
                iconSize: 24,
                onRetry: userDetailsBloc.refresh,
              ),
          ].intersperse(const SizedBox(width: 5)).toList(),
        ),
      ),
      subtitle: Text(
        account.humanReadableID,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
