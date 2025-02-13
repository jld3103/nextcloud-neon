// ignore: avoid_dart_io
import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neon_framework/testing.dart';
import 'package:neon_rich_text/neon_rich_text.dart';
import 'package:nextcloud/core.dart' as core;

class MockOnReferenceClickedCallback extends Mock {
  void call(String reference);
}

void main() {
  group('buildRichTextSpan', () {
    test('Preview without newlines', () {
      var span = buildRichTextSpan(
        account: MockAccount(),
        text: '123\n456',
        isMarkdown: false,
        parameters: BuiltMap(),
        references: BuiltList(),
        textStyle: const TextStyle(),
        onReferenceClicked: (_) {},
      ).children!.single as TextSpan;
      expect(span.text, '123\n456');

      span = buildRichTextSpan(
        account: MockAccount(),
        text: '123\n456',
        isMarkdown: false,
        parameters: BuiltMap(),
        references: BuiltList(),
        textStyle: const TextStyle(),
        onReferenceClicked: (_) {},
        isPreview: true,
      ).children!.single as TextSpan;
      expect(span.text, '123 456');
    });

    group('Unused parameters', () {
      for (final type in core.RichObjectParameter_Type.values) {
        test(type, () {
          final spans = buildRichTextSpan(
            account: MockAccount(),
            text: 'test',
            isMarkdown: false,
            parameters: BuiltMap({
              type.value: BuiltMap<String, JsonObject>({
                'type': JsonObject(type.value),
                'id': JsonObject(1),
                'name': JsonObject(''),
              }),
            }),
            references: BuiltList(),
            textStyle: const TextStyle(),
            onReferenceClicked: (_) {},
          ).children!;
          if (type == core.RichObjectParameter_Type.file) {
            expect(spans, hasLength(3));
            expect((spans[0] as WidgetSpan).child, isA<NeonRichObjectFile>());
            expect((spans[1] as TextSpan).text, '\n');
            expect((spans[2] as TextSpan).text, 'test');
          } else {
            expect((spans.single as TextSpan).text, 'test');
          }
        });
      }
    });

    test('Used parameters', () {
      final spans = buildRichTextSpan(
        account: MockAccount(),
        text: '123 {actor1} 456 {actor2} 789',
        isMarkdown: false,
        parameters: BuiltMap({
          'actor1': BuiltMap<String, JsonObject>({
            'type': JsonObject('user'),
            'id': JsonObject(''),
            'name': JsonObject(''),
          }),
          'actor2': BuiltMap<String, JsonObject>({
            'type': JsonObject('user'),
            'id': JsonObject(''),
            'name': JsonObject(''),
          }),
        }),
        references: BuiltList(),
        textStyle: const TextStyle(),
        onReferenceClicked: (_) {},
      ).children!;
      expect(spans, hasLength(5));
      expect((spans[0] as TextSpan).text, '123 ');
      expect((spans[1] as WidgetSpan).child, isA<NeonRichObjectMention>());
      expect((spans[2] as TextSpan).text, ' 456 ');
      expect((spans[3] as WidgetSpan).child, isA<NeonRichObjectMention>());
      expect((spans[4] as TextSpan).text, ' 789');
    });

    test('References', () {
      final callback = MockOnReferenceClickedCallback();

      final spans = buildRichTextSpan(
        account: MockAccount(),
        text: 'a 123 b 456 c',
        isMarkdown: false,
        parameters: BuiltMap(),
        references: BuiltList(['123', '456']),
        textStyle: const TextStyle(),
        onReferenceClicked: callback.call,
      ).children!;
      expect(spans, hasLength(5));

      expect((spans[0] as TextSpan).text, 'a ');

      final link1 = spans[1] as TextSpan;
      expect(link1.text, '123');
      (link1.recognizer! as TapGestureRecognizer).onTap!();
      verify(() => callback('123')).called(1);

      expect((spans[2] as TextSpan).text, ' b ');

      final link2 = spans[3] as TextSpan;
      expect(link2.text, '456');
      (link2.recognizer! as TapGestureRecognizer).onTap!();
      verify(() => callback('456')).called(1);

      expect((spans[4] as TextSpan).text, ' c');
    });

    test('Skip empty parts', () {
      final spans = buildRichTextSpan(
        account: MockAccount(),
        text: '{actor}',
        isMarkdown: false,
        parameters: BuiltMap({
          'actor': BuiltMap<String, JsonObject>({
            'type': JsonObject(core.RichObjectParameter_Type.user.name),
            'id': JsonObject(''),
            'name': JsonObject(''),
          }),
        }),
        references: BuiltList(),
        textStyle: const TextStyle(),
        onReferenceClicked: (_) {},
      ).children!;
      expect(spans, hasLength(1));
      expect((spans[0] as WidgetSpan).child, isA<NeonRichObjectMention>());
    });

    group('Markdown', () {
      const defaultFontFamily = 'NotoSans-Regular';

      setUpAll(() async {
        FakeNeonStorage.setup();

        // https://github.com/flutter/flutter/blob/1d60fc784359079041de26bf999e6715aea442f0/packages/flutter/test/material/icons_test.dart#L152
        for (final (name, fontFamily) in [
          (defaultFontFamily, defaultFontFamily),
          ('NotoSansMono-Regular', 'monospace'),
        ]) {
          final fontFile = File('test/fonts/$name.ttf');
          final bytes = Future<ByteData>.value(fontFile.readAsBytesSync().buffer.asByteData());

          await (FontLoader(fontFamily)..addFont(bytes)).load();
        }
      });

      void testMarkdown(
        String name,
        String text, {
        BuiltMap<String, BuiltMap<String, JsonObject>>? parameters,
        void Function(String)? onReferenceClicked,
        Future<void> Function(WidgetTester tester)? body,
      }) {
        testWidgets(name, (tester) async {
          late TextSpan span;

          await tester.pumpWidgetWithAccessibility(
            MaterialApp(
              theme: ThemeData(
                fontFamily: defaultFontFamily,
              ),
              home: Scaffold(
                body: Builder(
                  builder: (context) {
                    final style = Theme.of(context).textTheme.bodyMedium!;
                    span = buildRichTextSpan(
                      account: MockAccount(),
                      text: text,
                      textStyle: style,
                      parameters: parameters ?? BuiltMap(),
                      references: BuiltList(),
                      onReferenceClicked: onReferenceClicked ?? (_) {},
                      isMarkdown: true,
                    );

                    return RichText(
                      text: span,
                    );
                  },
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          await expectLater(
            find.byType(Scaffold).first,
            matchesGoldenFile('goldens/rich_text_${Uri.encodeComponent(name.replaceAll(' ', '_'))}.png'),
          );

          await body?.call(tester);
        });
      }

      // These features are not tested in the nextcloud-vue library, but they do work...
      group('custom', () {
        testMarkdown(
          'subscript',
          'text[^first]\n[^first]: footnote',
        );

        testMarkdown(
          'nested lists',
          '''
- a
  - b
    - c
- d
  - e''',
        );

        // Use a data URI to avoid loading an image over the network
        testMarkdown(
          'image',
          '![alt](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAIAAAD/gAIDAAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw0AcxV9TpUUqDnYQcQhYneyiIrppFYpQIdQKrTqYXPoFTRqSFBdHwbXg4Mdi1cHFWVcHV0EQ/ABxdnBSdJES/5cUWsR4cNyPd/ced+8AoVFhmtU1C2i6baaTCTGbWxVDr4ggjChmMCwzy5iTpBR8x9c9Any9i/Ms/3N/jl41bzEgIBLPMsO0iTeIpzZtg/M+cZSVZJX4nHjMpAsSP3Jd8fiNc9FlgWdGzUx6njhKLBY7WOlgVjI14knimKrplC9kPVY5b3HWKjXWuid/YSSvryxzneYQkljEEiSIUFBDGRXYiNOqk2IhTfsJH/+g65fIpZCrDEaOBVShQXb94H/wu1urMDHuJUUSQPeL43yMAKFdoFl3nO9jx2meAMFn4Epv+6sNYPqT9Hpbix0BfdvAxXVbU/aAyx1g4MmQTdmVgjSFQgF4P6NvygH9t0DPmtdbax+nD0CGukrdAAeHwGiRstd93h3u7O3fM63+fgDncXLVXR+lTAAAAAlwSFlzAAAuIwAALiMBeKU/dgAAAAd0SU1FB+gMCBUAH6Fims8AAAAZdEVYdENvbW1lbnQAQ3JlYXRlZCB3aXRoIEdJTVBXgQ4XAAAAnklEQVR42u3QMQEAAAgDILV/51nBzwci0CmuRoEsWbJkyZKlQJYsWbJkyVIgS5YsWbJkKZAlS5YsWbIUyJIlS5YsWQpkyZIlS5YsBbJkyZIlS5YCWbJkyZIlS4EsWbJkyZKlQJYsWbJkyVIgS5YsWbJkKZAlS5YsWbIUyJIlS5YsWQpkyZIlS5YsBbJkyZIlS5YCWbJkyZIlS4EsWd8Wil4Bx2r6t7cAAAAASUVORK5CYII=)',
          body: (tester) async {
            expect(find.byTooltip('alt'), findsOne);
          },
        );

        testMarkdown(
          'rich object',
          '# *abc {object} def*',
          parameters: BuiltMap({
            'object': BuiltMap<String, JsonObject>({
              'id': JsonObject('object'),
              // Use an unimplemented type to trigger the simple fallback case
              'type': JsonObject('email'),
              'name': JsonObject('object'),
            }),
          }),
        );

        group('reference', () {
          final callback = MockOnReferenceClickedCallback();

          testMarkdown(
            'reference plain',
            'abc https://example.com def',
            onReferenceClicked: callback.call,
            body: (tester) async {
              await tester.tap(find.textContaining('https://example.com', findRichText: true));
              await tester.pumpAndSettle();

              verify(() => callback('https://example.com')).called(1);
            },
          );

          testMarkdown(
            'reference embedded',
            'abc [text](https://example.com) def',
            onReferenceClicked: callback.call,
            body: (tester) async {
              await tester.tap(find.textContaining('text', findRichText: true));
              await tester.pumpAndSettle();

              verify(() => callback('https://example.com')).called(1);
            },
          );
        });
      });

      // https://github.com/nextcloud-libraries/nextcloud-vue/blob/master/cypress/component/richtext.cy.ts
      group('nextcloud-vue', () {
        group('normal text', () {
          testMarkdown(
            'XML-like text (escaped and unescaped)',
            '<span>text&lt;/span&gt;',
          );
        });

        group('headings', () {
          testMarkdown(
            'heading (with hash (#) syntax divided with space from text)',
            '''
# heading 1
## heading 2
### heading 3
#### heading 4
##### heading 5
###### heading 6''',
          );

          testMarkdown(
            'ignored heading (with hash (#) syntax padded to the text)',
            '#heading',
          );

          testMarkdown(
            'heading 1 (with equal (=) syntax on the next line)',
            'heading 1\n==',
          );

          testMarkdown(
            'heading 2 (with dash (-) syntax on the next line)',
            'heading 2\n--',
          );
        });

        group('bold text', () {
          testMarkdown(
            'bold text (single with asterisk syntax)',
            '**bold asterisk**',
          );

          testMarkdown(
            'bold text (single with underscore syntax)',
            '__bold underscore__',
          );

          testMarkdown(
            'bold text (several in line with different syntax)',
            'normal text __bold underscore__ normal text **bold asterisk** normal text',
          );

          testMarkdown(
            'bold text (between normal texts with asterisk syntax)',
            'text**bold**text',
          );

          testMarkdown(
            'ignored bold text (between normal texts with underscore syntax)',
            'text__bold__text',
          );

          testMarkdown(
            'normal text (between bold texts with asterisk syntax)',
            '**bold asterisk**normal text**bold asterisk**',
          );
        });

        group('italic text', () {
          testMarkdown(
            'italic text (single with asterisk syntax)',
            '*italic asterisk*',
          );

          testMarkdown(
            'italic text (single with underscore syntax)',
            '_italic underscore_',
          );

          testMarkdown(
            'italic text (several in line with different syntax)',
            'normal text _italic underscore_ normal text *italic asterisk* normal text',
          );

          testMarkdown(
            'italic text (between normal texts with asterisk syntax)',
            'text*italic*text',
          );

          testMarkdown(
            'ignored italic text (between normal texts with underscore syntax)',
            'text_italic_text',
          );

          testMarkdown(
            'normal text (between italic texts with asterisk syntax)',
            '*italic asterisk*normal text*italic asterisk*',
          );
        });

        group('strikethrough text', () {
          testMarkdown(
            'strikethrough text (with single tilda syntax)',
            '~strikethrough single~',
          );

          testMarkdown(
            'strikethrough text (with double tilda syntax)',
            '~~strikethrough double~~',
          );

          testMarkdown(
            'strikethrough text (several in line with different syntax)',
            'normal text ~strikethrough single~ normal text ~~strikethrough double~~ normal text',
          );

          testMarkdown(
            'strikethrough text (between normal texts with different syntax)',
            'text~strikethrough~text~~strikethrough~~text',
          );
        });

        group('inline code', () {
          testMarkdown(
            'inline code (single with backticks syntax)',
            'normal text `inline code` normal text',
          );

          testMarkdown(
            'inline code (single with double backticks syntax)',
            'normal text ``inline code`` normal text',
          );

          testMarkdown(
            'inline code (single with triple backticks syntax)',
            'normal text ```inline code``` normal text',
          );

          testMarkdown(
            'inline code (several in line)',
            'normal text `inline code 1`normal text ``inline code 2`` normal text',
          );

          testMarkdown(
            'inline code (between normal texts)',
            'text`inline code`text',
          );

          testMarkdown(
            'inline code (with ignored bold, italic, XML-like syntax)',
            '`inline code **bold text** _italic text_ <span>text&lt;/span&gt;`',
          );
        });

        group('multiline code', () {
          testMarkdown(
            'multiline code (with triple backticks syntax)',
            '```\nmultiline code\n```',
          );

          testMarkdown(
            'multiline code (ignored info)',
            '```vue\nmultiline code\n```',
          );

          testMarkdown(
            'empty multiline code',
            '``````',
          );

          testMarkdown(
            'empty multiline code (with new line)',
            '```\n```',
          );

          testMarkdown(
            'multiline code (with several lines)',
            '```\nline 1\nline 2\nline 3\n```',
          );

          testMarkdown(
            'multiline code (with ignored bold, italic, inline code, XML-like syntax)',
            '```\n**bold text**\n_italic text_\n`inline code`\n<span>text&lt;/span&gt;\n```',
          );
        });

        group('blockquote', () {
          testMarkdown(
            'blockquote (with greater then (>) syntax - normal)',
            '> blockquote',
          );

          testMarkdown(
            'blockquote (with greater then (&gt;) syntax - escaped)',
            '&gt; blockquote',
          );

          testMarkdown(
            'blockquote (with bold, italic text, inline code)',
            '> blockquote **bold text** _italic text_ `inline code`',
          );

          testMarkdown(
            'blockquote (with several lines)',
            '> line 1\nline 2\n line 3',
          );

          testMarkdown(
            'blockquote (divided from normal text)',
            'normal text\n> line 1\nline 2\n\nnormal text',
          );

          testMarkdown(
            'blockquote (with several paragraphs)',
            '> line 1\n>\n> line 3',
          );

          testMarkdown(
            'blockquote (with nested blockquote)',
            '> blockquote\n>\n>> nested blockquote',
          );
        });

        group('lists', () {
          testMarkdown(
            'ordered list (with number + `.` syntax divided with space from text)',
            '''
1. item 1
2. item 2
3. item 3''',
          );

          testMarkdown(
            'unordered list (with unite syntax divided with space from text)',
            '''
* item 1
* item 2
* item 3''',
          );

          testMarkdown(
            'unordered lists (with different syntax divided with space from text)',
            '''
* item 1
+ item 2
- item 3''',
          );
        });

        group('task lists', () {
          testMarkdown(
            'task list (with `- [ ]` and `- [x]` syntax divided with space from text)',
            '''
- [ ] item 1
- [x] item 2
- [ ] item 3''',
          );
        });

        group('tables', () {
          testMarkdown(
            'table (with `-- | --` syntax)',
            'Table | Column A | Column B\n-- | -- | --\nRow 1 | Value A1 | Value B1\nRow 2 | Value A2 | Value B2',
          );
        });

        group('dividers', () {
          testMarkdown(
            'dividers (with different syntax)',
            '***\n---\n___',
          );
        });
      });
    });
  });
}
