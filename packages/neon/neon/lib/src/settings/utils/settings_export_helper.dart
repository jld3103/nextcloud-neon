import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:neon/src/blocs/accounts.dart';
import 'package:neon/src/models/account.dart' show Account, AccountFind;
import 'package:neon/src/models/client_implementation.dart';
import 'package:neon/src/settings/models/exportable.dart';
import 'package:neon/src/settings/models/option.dart';
import 'package:neon/src/settings/models/storage.dart';

/// Helper class to export all [Option]s.
///
/// Json based operations:
/// * [exportToJson]
/// * [applyFromJson]
///
/// [Uint8List] based operations:
/// * [exportToFile]
/// * [applyFromFile]
@internal
@immutable
class SettingsExportHelper {
  const SettingsExportHelper({
    required this.exportables,
  });

  /// Collections of elements to export.
  final Set<Exportable> exportables;

  /// Imports [file] and applies the stored [Option]s.
  ///
  /// See:
  /// * [applyFromJson] to import a json map.
  Future<void> applyFromFile(final Stream<List<int>>? file) async {
    final transformer = const Utf8Decoder().fuse(const JsonDecoder());

    final data = await file?.transform(transformer).single;

    if (data == null) {
      return;
    }

    await applyFromJson(data as Map<String, Object?>);
  }

  /// Imports the [json] data and applies the stored [Option]s.
  ///
  /// See:
  /// * [applyFromFile] to import data from a [Stream<Uint8List>].
  Future<void> applyFromJson(final Map<String, Object?> json) async {
    for (final exportable in exportables) {
      await exportable.import(json);
    }
  }

  /// Exports the stored [Option]s into a [Uint8List].
  ///
  /// See:
  /// * [exportToJson] to export to a json map.
  Uint8List exportToFile() {
    final transformer = JsonUtf8Encoder();

    final json = exportToJson();
    return transformer.convert(json) as Uint8List;
  }

  /// Exports the stored [Option]s into a json map.
  ///
  /// See:
  /// * [exportToFile] to export data to a [Uint8List].
  Map<String, Object?> exportToJson() => Map.fromEntries(exportables.map((final e) => e.export()));
}

/// Helper class to export [ClientImplementation]s implementing the [Exportable] interface.
@internal
@immutable
class ClientImplementationsExporter implements Exportable {
  const ClientImplementationsExporter(this.clientImplementations);

  /// List of clients to export.
  final Iterable<ClientImplementation> clientImplementations;

  /// Key the exported value will be stored at.
  static final _key = StorageKeys.clients.value;

  @override
  MapEntry<String, Object?> export() => MapEntry(
        _key,
        Map.fromEntries(clientImplementations.map((final client) => client.options.export())),
      );

  @override
  void import(final Map<String, Object?> data) {
    final values = data[_key] as Map<String, Object?>?;

    if (values == null) {
      return;
    }

    for (final element in values.entries) {
      final client = clientImplementations.tryFind(element.key);

      if (client != null) {
        client.options.import(values);
      }
    }
  }
}

/// Helper class to export [Account]s implementing the [Exportable] interface.
@internal
@immutable
class AccountsBlocExporter implements Exportable {
  const AccountsBlocExporter(this.accountsBloc);

  /// AccountsBloc containing the accounts to export.
  final AccountsBloc accountsBloc;

  /// Key the exported value will be stored at.
  static final _key = StorageKeys.accounts.value;

  @override
  MapEntry<String, Object?> export() => MapEntry(_key, Map.fromEntries(_serialize()));

  Iterable<MapEntry<String, Object?>> _serialize() sync* {
    for (final account in accountsBloc.accounts.value) {
      yield accountsBloc.getOptionsFor(account).export();
    }
  }

  @override
  void import(final Map<String, Object?> data) {
    final values = data[_key] as Map<String, Object?>?;

    if (values == null) {
      return;
    }

    for (final element in values.entries) {
      final account = accountsBloc.accounts.value.tryFind(element.key);

      if (account != null) {
        accountsBloc.getOptionsFor(account).import(values);
      }
    }
  }
}
