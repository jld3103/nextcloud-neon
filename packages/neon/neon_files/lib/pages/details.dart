part of '../neon_files.dart';

class FilesDetailsPage extends StatelessWidget {
  const FilesDetailsPage({
    required this.bloc,
    required this.details,
    super.key,
  });

  final FilesBloc bloc;
  final FileDetails details;

  @override
  Widget build(final BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(details.name),
        ),
        body: Scrollbar(
          child: ListView(
            primary: true,
            children: [
              ColoredBox(
                color: Theme.of(context).colorScheme.primary,
                child: FilePreview(
                  bloc: bloc,
                  details: details,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: Size(
                    MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height / 4,
                  ),
                ),
              ),
              DataTable(
                headingRowHeight: 0,
                columns: const [
                  DataColumn(label: SizedBox()),
                  DataColumn(label: SizedBox()),
                ],
                rows: [
                  for (final entry in {
                    details.isDirectory
                        ? AppLocalizations.of(context).detailsFolderName
                        : AppLocalizations.of(context).detailsFileName: details.name,
                    AppLocalizations.of(context).detailsParentFolder:
                        details.path.length == 1 ? '/' : details.path.sublist(0, details.path.length - 1).join('/'),
                    if (details.size != null)
                      details.isDirectory
                          ? AppLocalizations.of(context).detailsFolderSize
                          : AppLocalizations.of(context).detailsFileSize: filesize(details.size, 1),
                    if (details.lastModified != null)
                      AppLocalizations.of(context).detailsLastModified:
                          details.lastModified!.toLocal().toIso8601String(),
                    if (details.isFavorite != null)
                      AppLocalizations.of(context).detailsIsFavorite: details.isFavorite!
                          ? AppLocalizations.of(context).actionYes
                          : AppLocalizations.of(context).actionNo,
                  }.entries)
                    DataRow(
                      cells: [
                        DataCell(Text(entry.key)),
                        DataCell(Text(entry.value)),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      );
}
