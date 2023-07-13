part of 'neon_files.dart';

class FilesAppSpecificOptions extends NextcloudAppOptions {
  FilesAppSpecificOptions(super.storage) {
    super.categories = [
      generalCategory,
    ];
    super.options = [
      filesSortPropertyOption,
      filesSortBoxOrderOption,
      showPreviewsOption,
      uploadQueueParallelism,
      downloadQueueParallelism,
      uploadSizeWarning,
      downloadSizeWarning,
    ];
  }

  final generalCategory = OptionsCategory(
    name: (final context) => AppLocalizations.of(context).general,
  );

  late final filesSortPropertyOption = SelectOption<FilesSortProperty>(
    storage: super.storage,
    category: generalCategory,
    key: 'files-sort-property',
    label: (final context) => AppLocalizations.of(context).optionsFilesSortProperty,
    defaultValue: FilesSortProperty.name,
    values: {
      FilesSortProperty.name: (final context) => AppLocalizations.of(context).optionsFilesSortPropertyName,
      FilesSortProperty.modifiedDate: (final context) =>
          AppLocalizations.of(context).optionsFilesSortPropertyModifiedDate,
      FilesSortProperty.size: (final context) => AppLocalizations.of(context).optionsFilesSortPropertySize,
    },
  );

  late final filesSortBoxOrderOption = SelectOption<SortBoxOrder>(
    storage: super.storage,
    category: generalCategory,
    key: 'files-sort-box-order',
    label: (final context) => AppLocalizations.of(context).optionsFilesSortOrder,
    defaultValue: SortBoxOrder.ascending,
    values: sortBoxOrderOptionValues,
  );

  late final showPreviewsOption = ToggleOption(
    storage: super.storage,
    category: generalCategory,
    key: 'show-previews',
    label: (final context) => AppLocalizations.of(context).optionsShowPreviews,
    defaultValue: true,
  );

  late final uploadQueueParallelism = SelectOption<int>(
    storage: storage,
    category: generalCategory,
    key: 'upload-queue-parallelism',
    label: (final context) => AppLocalizations.of(context).optionsUploadQueueParallelism,
    defaultValue: 4,
    values: {
      for (var i = 1; i <= 16; i = i * 2) ...{
        i: (final _) => i.toString(),
      },
    },
  );

  late final downloadQueueParallelism = SelectOption<int>(
    storage: storage,
    category: generalCategory,
    key: 'download-queue-parallelism',
    label: (final context) => AppLocalizations.of(context).optionsDownloadQueueParallelism,
    defaultValue: 4,
    values: {
      for (var i = 1; i <= 16; i = i * 2) ...{
        i: (final _) => i.toString(),
      },
    },
  );

  late final _sizeWarningValues = <int?, String Function(BuildContext)>{
    null: (final context) => AppLocalizations.of(context).optionsSizeWarningDisabled,
    for (final i in [
      1,
      10,
      100,
      1024,
      2 * 2024,
      6 * 1024,
      10 * 1024,
    ]) ...{
      _mb(i): (final _) => filesize(_mb(i)),
    },
  };

  int _mb(final int i) => i * 1024 * 1024;

  late final uploadSizeWarning = SelectOption<int?>(
    storage: storage,
    category: generalCategory,
    key: 'upload-size-warning',
    label: (final context) => AppLocalizations.of(context).optionsUploadSizeWarning,
    defaultValue: _mb(10),
    values: _sizeWarningValues,
  );

  late final downloadSizeWarning = SelectOption<int?>(
    storage: storage,
    category: generalCategory,
    key: 'download-size-warning',
    label: (final context) => AppLocalizations.of(context).optionsDownloadSizeWarning,
    defaultValue: _mb(10),
    values: _sizeWarningValues,
  );
}

enum FilesSortProperty {
  name,
  modifiedDate,
  size,
}
