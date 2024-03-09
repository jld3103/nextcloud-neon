import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_framework/src/bloc/bloc.dart';
import 'package:neon_framework/src/bloc/result.dart';
import 'package:neon_framework/src/blocs/apps.dart';
import 'package:neon_framework/src/utils/request_manager.dart';
import 'package:nextcloud/core.dart' as core;
import 'package:rxdart/rxdart.dart';

/// Bloc for managing unified search.
sealed class UnifiedSearchBloc implements InteractiveBloc {
  @internal
  factory UnifiedSearchBloc(
    AppsBloc appsBloc,
    Account account,
  ) =>
      _UnifiedSearchBloc(
        appsBloc,
        account,
      );

  /// Search for a [term].
  void search(String term);

  /// The available search providers.
  BehaviorSubject<Result<BuiltList<core.UnifiedSearchProvider>>> get providers;

  /// Contains the unified search results mapped by provider.
  BehaviorSubject<BuiltMap<String, Result<core.UnifiedSearchResult>>>
      get results;
}

class _UnifiedSearchBloc extends InteractiveBloc implements UnifiedSearchBloc {
  _UnifiedSearchBloc(
    this.appsBloc,
    this.account,
  ) {
    providers.listen((result) async {
      if (result.isLoading) {
        return;
      }

      if (term.isEmpty) {
        results.add(BuiltMap());
        return;
      }

      await searchProviders(
        result.requireData.map((provider) => provider.id).toList(),
      );
    });
  }

  @override
  final log = Logger('UnifiedSearchBloc');

  final AppsBloc appsBloc;
  final Account account;
  String term = '';

  @override
  final providers = BehaviorSubject.seeded(Result.success(BuiltList()));

  @override
  final results = BehaviorSubject.seeded(BuiltMap());

  @override
  void dispose() {
    unawaited(providers.close());
    unawaited(results.close());
    super.dispose();
  }

  @override
  Future<void> refresh() async {
    await RequestManager.instance.wrapNextcloud(
      account: account,
      cacheKey: 'unified-search-providers',
      subject: providers,
      request: account.client.core.unifiedSearch.$getProviders_Request(),
      serializer: account.client.core.unifiedSearch.$getProviders_Serializer(),
      unwrap: (response) => response.body.ocs.data,
    );
  }

  @override
  Future<void> search(String term) async {
    this.term = term.trim();
    await refresh();
  }

  Future<void> searchProviders(List<String> providerIDs) async {
    results.add(
      BuiltMap.build((b) {
        final loadingEvent = Result<core.UnifiedSearchResult>.loading();

        for (final providerID in providerIDs) {
          b[providerID] = loadingEvent;
        }
      }),
    );

    await Future.wait(
      providerIDs.map((providerID) async {
        try {
          final response = await account.client.core.unifiedSearch.search(
            providerId: providerID,
            term: term,
          );
          updateResults(providerID, Result.success(response.body.ocs.data));
        } on http.ClientException catch (error, stackTrace) {
          log.warning(
            'Error searching in $providerID.',
            error,
            stackTrace,
          );

          updateResults(providerID, Result.error(error));
        }
      }),
    );
  }

  void updateResults(
    String providerID,
    Result<core.UnifiedSearchResult> result,
  ) {
    results.add(
      BuiltMap.build((b) {
        b.addEntries(
          sortResults(
            results.value.rebuild((b) {
              b[providerID] = result;
            }),
          ),
        );
      }),
    );
  }

  Iterable<MapEntry<String, Result<core.UnifiedSearchResult>>> sortResults(
    BuiltMap<String, Result<core.UnifiedSearchResult>> results,
  ) sync* {
    final activeApp = appsBloc.activeApp.value;

    // Unlike non-matching providers (below) we don't filter the empty results,
    // as the active app is more relevant and we want to know if there are no
    // results for the active app.
    yield* results.entries
        .where((entry) => providerMatchesApp(entry.key, activeApp))
        .sorted((a, b) => sortEntriesCount(a.value, b.value));
    yield* results.entries
        .whereNot((entry) => providerMatchesApp(entry.key, activeApp))
        .where((entry) => hasEntries(entry.value))
        .sorted((a, b) => sortEntriesCount(a.value, b.value));
  }

  bool providerMatchesApp(String providerID, AppImplementation app) =>
      providerID == app.id || providerID.startsWith('${app.id}_');

  bool hasEntries(Result<core.UnifiedSearchResult> result) =>
      !result.hasData || result.requireData.entries.isNotEmpty;

  int sortEntriesCount(
    Result<core.UnifiedSearchResult> a,
    Result<core.UnifiedSearchResult> b,
  ) =>
      (b.data?.entries.length ?? 0).compareTo(a.data?.entries.length ?? 0);
}
