import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_framework/utils.dart';
import 'package:neon_notes/src/options.dart';
import 'package:nextcloud/notes.dart' as $notes;
import 'package:rxdart/rxdart.dart';

sealed class NotesBloc implements InteractiveBloc {
  @internal
  factory NotesBloc(
    NotesOptions options,
    Account account,
  ) =>
      _NotesBloc(
        options,
        account,
      );

  void createNote({
    String title = '',
    String category = '',
  });

  void updateNote(
    int id,
    String etag, {
    String? title,
    String? category,
    String? content,
    bool? favorite,
  });

  void deleteNote(int id);

  BehaviorSubject<Result<BuiltList<$notes.Note>>> get notes;

  NotesOptions get options;
}

class _NotesBloc extends InteractiveBloc implements NotesBloc {
  _NotesBloc(
    this.options,
    this.account,
  ) {
    unawaited(refresh());
  }

  @override
  final NotesOptions options;
  final Account account;

  @override
  void dispose() {
    unawaited(notes.close());
    super.dispose();
  }

  @override
  final notes = BehaviorSubject();

  @override
  Future<void> refresh() async {
    await RequestManager.instance.wrapNextcloud(
      account: account,
      cacheKey: 'notes-notes',
      subject: notes,
      request: account.client.notes.$getNotes_Request(),
      serializer: account.client.notes.$getNotes_Serializer(),
      unwrap: (response) => response.body,
    );
  }

  @override
  Future<void> createNote({String title = '', String category = ''}) async {
    await wrapAction(
      () async => account.client.notes.createNote(
        title: title,
        category: category,
      ),
    );
  }

  @override
  Future<void> deleteNote(int id) async {
    await wrapAction(() async => account.client.notes.deleteNote(id: id));
  }

  @override
  Future<void> updateNote(
    int id,
    String etag, {
    String? title,
    String? category,
    String? content,
    bool? favorite,
  }) async {
    await wrapAction(
      () async => account.client.notes.updateNote(
        id: id,
        title: title,
        category: category,
        content: content,
        favorite: favorite ?? false ? 1 : 0,
        ifMatch: '"$etag"',
      ),
    );
  }
}
