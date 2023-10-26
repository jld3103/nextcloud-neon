library neon_files;

import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:file_icons/file_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neon/blocs.dart';
import 'package:neon/models.dart';
import 'package:neon/platform.dart';
import 'package:neon/settings.dart';
import 'package:neon/sort_box.dart';
import 'package:neon/theme.dart';
import 'package:neon/utils.dart';
import 'package:neon/widgets.dart';
import 'package:neon_files/l10n/localizations.dart';
import 'package:neon_files/routes.dart';
import 'package:neon_files/widgets/file_list_tile.dart';
import 'package:nextcloud/core.dart' as core;
import 'package:nextcloud/nextcloud.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:queue/queue.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share_plus/share_plus.dart';

part 'blocs/browser.dart';
part 'blocs/files.dart';
part 'dialogs/choose_create.dart';
part 'dialogs/choose_folder.dart';
part 'dialogs/create_folder.dart';
part 'models/file_details.dart';
part 'options.dart';
part 'pages/details.dart';
part 'pages/main.dart';
part 'sort/files.dart';
part 'utils/task.dart';
part 'widgets/browser_view.dart';
part 'widgets/file_preview.dart';
part 'widgets/navigator.dart';

class FilesClient extends ClientImplementation<FilesBloc, FilesClientSpecificOptions> {
  FilesClient();

  @override
  final String id = AppIDs.files;

  @override
  final LocalizationsDelegate<FilesLocalizations> localizationsDelegate = FilesLocalizations.delegate;

  @override
  final List<Locale> supportedLocales = FilesLocalizations.supportedLocales;

  @override
  late final FilesClientSpecificOptions options = FilesClientSpecificOptions(storage);

  @override
  FilesBloc buildBloc(final Account account) => FilesBloc(
        options,
        account,
      );

  @override
  final Widget page = const FilesMainPage();

  @override
  final RouteBase route = $filesClientRoute;

  @override
  (bool? supported, String? minimumVersion) isSupported(
    final Account account,
    final core.OcsGetCapabilitiesResponseApplicationJson_Ocs_Data capabilities,
  ) =>
      const (null, null);
}
