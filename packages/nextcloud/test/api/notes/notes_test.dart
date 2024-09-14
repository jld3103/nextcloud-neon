import 'package:built_value_test/matcher.dart';
import 'package:nextcloud/core.dart' as core;
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/notes.dart' as notes;
import 'package:nextcloud_test/nextcloud_test.dart';
import 'package:test/test.dart';

void main() async {
  await presets('notes', 'notes', (tester) {
    tearDown(() async {
      closeFixture();

      final response = await tester.client.notes.getNotes();
      for (final note in response.body) {
        await tester.client.notes.deleteNote(id: note.id);
      }
    });

    test('Is supported', () async {
      final response = await tester.client.core.ocs.getCapabilities();
      expect(response.statusCode, 200);
      expect(() => response.headers, isA<void>());

      final result = tester.client.notes.getVersionCheck(response.body.ocs.data);
      expect(result.versions, isNotNull);
      expect(result.versions, isNotEmpty);
      expect(result.isSupported, isTrue);
    });

    test('Create note favorite', () async {
      final response = await tester.client.notes.createNote(
        title: 'a',
        content: 'b',
        category: 'c',
        favorite: 1,
      );
      expect(response.statusCode, 200);
      expect(() => response.headers, isA<void>());

      expect(response.body.id, isPositive);
      expect(response.body.title, 'a');
      expect(response.body.content, 'b');
      expect(response.body.category, 'c');
      expect(response.body.favorite, true);
      expect(response.body.readonly, false);
      expect(response.body.etag, isNotNull);
      expect(response.body.modified, isNotNull);
    });

    test('Create note not favorite', () async {
      final response = await tester.client.notes.createNote(
        title: 'a',
        content: 'b',
        category: 'c',
      );
      expect(response.statusCode, 200);
      expect(() => response.headers, isA<void>());

      expect(response.body.id, isPositive);
      expect(response.body.title, 'a');
      expect(response.body.content, 'b');
      expect(response.body.category, 'c');
      expect(response.body.favorite, false);
      expect(response.body.readonly, false);
      expect(response.body.etag, isNotNull);
      expect(response.body.modified, isNotNull);
    });

    test('Get notes', () async {
      await tester.client.notes.createNote(title: 'a');
      await tester.client.notes.createNote(title: 'b');

      final response = await tester.client.notes.getNotes();
      expect(response.statusCode, 200);
      expect(() => response.headers, isA<void>());

      expect(response.body, hasLength(2));
      expect(response.body[0].title, 'a');
      expect(response.body[1].title, 'b');
    });

    test('Get note', () async {
      final response = await tester.client.notes.getNote(
        id: (await tester.client.notes.createNote(title: 'a')).body.id,
      );
      expect(response.statusCode, 200);
      expect(() => response.headers, isA<void>());

      expect(response.body.title, 'a');
    });

    test('Update note', () async {
      final id = (await tester.client.notes.createNote(title: 'a')).body.id;
      await tester.client.notes.updateNote(
        id: id,
        title: 'b',
      );

      final response = await tester.client.notes.getNote(id: id);
      expect(response.statusCode, 200);
      expect(() => response.headers, isA<void>());

      expect(response.body.title, 'b');
    });

    test('Update note fail changed on server', () async {
      final response = await tester.client.notes.createNote(title: 'a');
      expect(response.statusCode, 200);
      expect(() => response.headers, isA<void>());

      await tester.client.notes.updateNote(
        id: response.body.id,
        title: 'b',
        ifMatch: '"${response.body.etag}"',
      );
      await expectLater(
        () => tester.client.notes.updateNote(
          id: response.body.id,
          title: 'c',
          ifMatch: '"${response.body.etag}"',
        ),
        throwsA(predicate((e) => (e! as DynamiteStatusCodeException).statusCode == 412)),
      );
    });

    test('Delete note', () async {
      final id = (await tester.client.notes.createNote(title: 'a')).body.id;

      var response = await tester.client.notes.getNotes();
      expect(response.statusCode, 200);
      expect(() => response.headers, isA<void>());

      expect(response.body, hasLength(1));

      await tester.client.notes.deleteNote(id: id);

      response = await tester.client.notes.getNotes();
      expect(response.statusCode, 200);
      expect(() => response.headers, isA<void>());

      expect(response.body, hasLength(0));
    });

    test('Get and update settings', () async {
      final expectedSettings = notes.Settings(
        (b) => b
          ..notesPath = 'Notes'
          ..fileSuffix = '.md'
          ..noteMode = notes.Settings_NoteMode.rich,
      );

      var response = await tester.client.notes.getSettings();
      expect(response.statusCode, 200);
      expect(() => response.headers, isA<void>());

      expect(response.body, equalsBuilt(expectedSettings));

      response = await tester.client.notes.updateSettings(
        $body: notes.Settings(
          (b) => b
            ..notesPath = 'Test Notes'
            ..fileSuffix = '.txt'
            ..noteMode = notes.Settings_NoteMode.preview,
        ),
      );
      addTearDown(() async {
        closeFixture();
        await tester.client.notes.updateSettings($body: expectedSettings);
      });

      expect(response.statusCode, 200);
      expect(() => response.headers, isA<void>());

      expect(response.body.notesPath, 'Test Notes');
      expect(response.body.fileSuffix, '.txt');
      expect(response.body.noteMode, notes.Settings_NoteMode.preview);

      response = await tester.client.notes.getSettings();
      expect(response.statusCode, 200);
      expect(() => response.headers, isA<void>());

      expect(response.body.notesPath, 'Test Notes');
      expect(response.body.fileSuffix, '.txt');
      expect(response.body.noteMode, notes.Settings_NoteMode.preview);
    });
  });
}
