import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intersperse/intersperse.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:neon_framework/models.dart';
import 'package:neon_framework/widgets.dart';
import 'package:neon_rich_text/src/rich_objects/rich_objects.dart';
import 'package:nextcloud/core.dart' as core;

/// Renders the [text] as a rich [TextSpan].
TextSpan buildRichTextSpan({
  required Account account,
  required String text,
  required TextStyle textStyle,
  required BuiltMap<String, BuiltMap<String, JsonObject>> parameters,
  required BuiltList<String> references,
  required void Function(String reference) onReferenceClicked,
  required bool isMarkdown,
  bool isPreview = false,
}) {
  assert(
    !isPreview || !isMarkdown,
    'A preview must not be markdown',
  );

  if (isPreview) {
    text = text.replaceAll('\n', ' ');
  }

  if (!isMarkdown) {
    return _buildRichObjectSpan(
      text: text,
      textStyle: textStyle,
      parameters: parameters,
      isPreview: isPreview,
      references: references,
      onReferenceClicked: onReferenceClicked,
    );
  }

  final document = md.Document(
    extensionSet: md.ExtensionSet.gitHubFlavored,
    encodeHtml: false,
  );

  final nodes = document.parse(text);

  final spans = _buildMarkdownSpans(
    account: account,
    nodes: nodes,
    textStyle: textStyle,
    parameters: parameters,
    onReferenceClicked: onReferenceClicked,
    isPreview: isPreview,
  );

  // Here we can just ignore the final newline
  return TextSpan(
    children: spans.children,
    style: textStyle,
  );
}

TextSpan _buildRichObjectSpan({
  required String text,
  required TextStyle textStyle,
  required BuiltMap<String, BuiltMap<String, JsonObject>> parameters,
  required bool isPreview,
  BuiltList<String>? references,
  void Function(String reference)? onReferenceClicked,
}) {
  assert(
    (references == null) == (onReferenceClicked == null),
    'Pass both references and onReferenceClicked or neither of them.',
  );

  final unusedParameters = <String, core.RichObjectParameter>{};

  var parts = [text];
  for (final entry in parameters.entries) {
    final newParts = <String>[];

    var found = false;
    for (final part in parts) {
      final p = part.split('{${entry.key}}');
      newParts.addAll(p.intersperse('{${entry.key}}'));
      if (p.length > 1) {
        found = true;
      }
    }

    if (!found) {
      unusedParameters[entry.key] = core.RichObjectParameter.fromJson(
        entry.value.map((key, value) => MapEntry(key, value.toString())).toMap(),
      );
    }

    parts = newParts;
  }
  if (references != null) {
    for (final reference in references) {
      final newParts = <String>[];

      for (final part in parts) {
        final p = part.split(reference);
        newParts.addAll(p.intersperse(reference));
      }

      parts = newParts;
    }
  }

  final children = <InlineSpan>[];

  for (final entry in unusedParameters.entries) {
    if (entry.key == core.RichObjectParameter_Type.file.value) {
      children
        ..add(
          buildRichObjectParameter(
            parameter: entry.value,
            textStyle: textStyle,
            isPreview: isPreview,
          ),
        )
        ..add(const TextSpan(text: '\n'));
    }
  }

  for (final part in parts) {
    if (part.isEmpty) {
      continue;
    }

    var match = false;
    for (final entry in parameters.entries) {
      if ('{${entry.key}}' == part) {
        children.add(
          buildRichObjectParameter(
            parameter: core.RichObjectParameter.fromJson(
              entry.value.map((key, value) => MapEntry(key, value.toString())).toMap(),
            ),
            textStyle: textStyle,
            isPreview: isPreview,
          ),
        );
        match = true;
        break;
      }
    }
    if (references != null) {
      for (final reference in references) {
        if (reference == part) {
          final gestureRecognizer = TapGestureRecognizer()..onTap = () => onReferenceClicked!(reference);

          children.add(
            TextSpan(
              text: part,
              style: textStyle.merge(_linkTextStyle),
              recognizer: gestureRecognizer,
            ),
          );
          match = true;
          break;
        }
      }
    }

    if (!match) {
      children.add(
        TextSpan(
          style: textStyle,
          text: part,
        ),
      );
    }
  }

  return TextSpan(
    style: textStyle,
    children: children,
  );
}

const _linkTextStyle = TextStyle(
  decoration: TextDecoration.underline,
  decorationThickness: 2,
);

enum _MarkdownListType {
  unordered,
  ordered,
}

const _markdownNewlineTags = [
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  'li',
  'p',
];

({List<InlineSpan> children, bool finalNewline}) _buildMarkdownSpans({
  required Account account,
  required List<md.Node> nodes,
  required TextStyle textStyle,
  required BuiltMap<String, BuiltMap<String, JsonObject>> parameters,
  required void Function(String reference) onReferenceClicked,
  required bool isPreview,
  _MarkdownListType? listType,
  int listDepth = 0,
}) {
  final children = <InlineSpan>[];
  var finalNewline = false;

  for (var i = 0; i < nodes.length; i++) {
    final node = nodes[i];
    final span = _buildMarkdownSpan(
      account: account,
      node: node,
      textStyle: textStyle,
      parameters: parameters,
      onReferenceClicked: onReferenceClicked,
      isPreview: isPreview,
      listType: listType,
      listIndex: i,
      listDepth: listDepth,
    );

    children.add(span.child);

    if (span.finalNewline || node is md.Element && _markdownNewlineTags.contains(node.tag)) {
      if (i == nodes.length - 1) {
        finalNewline = true;
      } else {
        children.add(const TextSpan(text: '\n'));
      }
    }
  }

  return (
    children: children,
    finalNewline: finalNewline,
  );
}

({InlineSpan child, bool finalNewline}) _buildMarkdownSpan({
  required Account account,
  required md.Node node,
  required TextStyle textStyle,
  required BuiltMap<String, BuiltMap<String, JsonObject>> parameters,
  required void Function(String reference) onReferenceClicked,
  required bool isPreview,
  _MarkdownListType? listType,
  int listIndex = 0,
  int listDepth = 0,
}) {
  if (node is md.Text) {
    var text = node.text;
    final finalNewline = text.endsWith('\n');
    if (finalNewline) {
      text = text.substring(0, text.length - 1);
    }

    return (
      child: _buildRichObjectSpan(
        text: text,
        textStyle: textStyle,
        parameters: parameters,
        isPreview: isPreview,
        // Don't pass references and onReferenceClicked, as we already resolve them separately.
      ),
      finalNewline: finalNewline,
    );
  }

  if (node is md.Element) {
    var localTextStyle = textStyle;
    var localListType = listType;
    var localListDepth = listDepth;

    final childNodes = node.children ?? [];

    switch (node.tag) {
      case 'a':
        // This introduces a difference between the links resolved by the Reference API and the Markdown parser.
        // The web frontend has the exact same issue, where Markdown embedded links are turned into links inline, but
        // there is no preview displayed below the message because the Regex does not match the Markdown link.
        // A bug report was filed upstream and if it is fixed in the Reference API we will automatically benefit from it as well:
        // https://github.com/nextcloud/spreed/issues/13756
        final href = node.attributes['href'];
        if (href != null) {
          final gestureRecognizer = TapGestureRecognizer()..onTap = () => onReferenceClicked(href);

          return (
            child: TextSpan(
              text: (childNodes[0] as md.Text).text,
              style: localTextStyle.merge(_linkTextStyle),
              recognizer: gestureRecognizer,
            ),
            finalNewline: false,
          );
        }
      case 'blockquote':
        final spans = _buildMarkdownSpans(
          account: account,
          nodes: childNodes,
          textStyle: localTextStyle,
          parameters: parameters,
          onReferenceClicked: onReferenceClicked,
          isPreview: isPreview,
          listType: localListType,
          listDepth: localListDepth,
        );

        return (
          child: WidgetSpan(
            child: Container(
              margin: const EdgeInsets.only(left: 5),
              padding: const EdgeInsets.only(left: 5),
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Colors.grey,
                    width: 2.5,
                  ),
                ),
              ),
              child: Text.rich(
                TextSpan(
                  children: spans.children,
                  style: localTextStyle.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          finalNewline: spans.finalNewline,
        );
      case 'code':
        const backgroundColor = Colors.black;
        const foregroundColor = Colors.white;

        localTextStyle = localTextStyle.copyWith(
          fontFamily: 'monospace',
          backgroundColor: backgroundColor,
          color: foregroundColor,
        );

        final spans = _buildMarkdownSpans(
          account: account,
          nodes: childNodes,
          textStyle: localTextStyle,
          parameters: parameters,
          onReferenceClicked: onReferenceClicked,
          isPreview: isPreview,
          listType: localListType,
          listDepth: localListDepth,
        );

        // Inline code
        if (!spans.finalNewline) {
          return (
            child: TextSpan(
              children: spans.children,
              style: localTextStyle,
            ),
            finalNewline: spans.finalNewline,
          );
        }

        return (
          child: WidgetSpan(
            child: Container(
              color: backgroundColor,
              padding: const EdgeInsets.all(8),
              child: Text.rich(
                TextSpan(
                  children: spans.children,
                  style: localTextStyle,
                ),
              ),
            ),
          ),
          finalNewline: spans.finalNewline,
        );
      case 'del':
        localTextStyle = localTextStyle.copyWith(
          decoration: TextDecoration.lineThrough,
        );
      case 'em':
        localTextStyle = localTextStyle.copyWith(
          fontStyle: FontStyle.italic,
        );
      case 'hr':
        return (
          child: const WidgetSpan(
            child: Divider(),
          ),
          finalNewline: false,
        );
      case 'h1':
        localTextStyle = localTextStyle.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        );
      case 'h2':
        localTextStyle = localTextStyle.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        );
      case 'h3':
        localTextStyle = localTextStyle.copyWith(
          fontSize: 18.72,
          fontWeight: FontWeight.bold,
        );
      case 'h4':
        localTextStyle = localTextStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        );
      case 'h5':
        localTextStyle = localTextStyle.copyWith(
          fontSize: 13.28,
          fontWeight: FontWeight.bold,
        );
      case 'h6':
        localTextStyle = localTextStyle.copyWith(
          fontSize: 10.72,
          fontWeight: FontWeight.bold,
        );
      case 'img':
        return (
          child: WidgetSpan(
            child: Tooltip(
              message: node.attributes['alt'],
              child: NeonUriImage(
                uri: Uri.parse(node.attributes['src']!),
                account: account,
              ),
            ),
          ),
          finalNewline: false,
        );
      case 'input':
        final type = node.attributes['type']!;
        switch (type) {
          case 'checkbox':
            final checked = node.attributes['checked'] == 'true';

            return (
              child: WidgetSpan(
                child: Checkbox(
                  value: checked,
                  onChanged: null,
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity,
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              finalNewline: false,
            );
          default:
            throw UnimplementedError('Unexpected input type $type.'); // coverage:ignore-line
        }
      case 'li':
        localListDepth++;

        final spans = _buildMarkdownSpans(
          account: account,
          nodes: childNodes,
          textStyle: localTextStyle,
          parameters: parameters,
          onReferenceClicked: onReferenceClicked,
          isPreview: isPreview,
          listType: localListType,
          listDepth: localListDepth,
        );

        int? subListIndex;
        for (var i = 0; i < childNodes.length; i++) {
          final childNode = childNodes[i];
          if (childNode is md.Element && (childNode.tag == 'ol' || childNode.tag == 'ul')) {
            subListIndex = i;
            break;
          }
        }

        InlineSpan prefix;
        final firstChildNode = childNodes.firstOrNull;
        if (firstChildNode case md.Element(tag: 'input')) {
          prefix = const TextSpan();
        } else {
          prefix = switch (localListType) {
            _MarkdownListType.ordered => TextSpan(text: '${listIndex + 1}. '),
            _MarkdownListType.unordered => const TextSpan(text: '· '),
            _ => throw ArgumentError('List type must be specified when visiting li element.'), // coverage:ignore-line
          };
        }

        return (
          child: TextSpan(
            children: [
              TextSpan(
                text: ''.padRight(localListDepth),
                style: const TextStyle(
                  fontFamily: 'monospace',
                ),
              ),
              prefix,
              ...spans.children.sublist(0, subListIndex),
              if (subListIndex != null) const TextSpan(text: '\n'),
              if (subListIndex != null) ...spans.children.sublist(subListIndex),
            ],
          ),
          finalNewline: spans.finalNewline,
        );
      case 'ol':
        localListType = _MarkdownListType.ordered;
      case 'p':
        // Do nothing, a final newline will be inserted by the parent _buildMarkdownSpans() call.
        break;
      case 'pre':
        localTextStyle = localTextStyle.copyWith(
          fontFamily: 'monospace',
        );
      case 'section':
      // Do nothing, no special rendering.
      case 'strong':
        localTextStyle = localTextStyle.copyWith(
          fontWeight: FontWeight.bold,
        );
      case 'sup':
        localTextStyle = localTextStyle.copyWith(
          fontFeatures: [
            const FontFeature.superscripts(),
          ],
        );
      case 'table':
        final head = childNodes.firstWhere(
          (childNode) => childNode is md.Element && childNode.tag == 'thead',
        ) as md.Element;
        final columns = (head.children!.first as md.Element).children!.map((childNode) => childNode as md.Element);

        final body = childNodes.firstWhere(
          (childNode) => childNode is md.Element && childNode.tag == 'tbody',
        ) as md.Element;
        final rows = body.children!.map(
          (childNode) => (childNode as md.Element).children!.map(
                (childNode) => childNode as md.Element,
              ),
        );

        return (
          child: WidgetSpan(
            child: DataTable(
              columns: [
                for (final column in columns)
                  DataColumn(
                    headingRowAlignment:
                        column.attributes['align'] == 'right' ? MainAxisAlignment.end : MainAxisAlignment.start,
                    label: Text.rich(
                      _buildMarkdownSpan(
                        account: account,
                        node: column.children!.first,
                        textStyle: textStyle,
                        parameters: parameters,
                        onReferenceClicked: onReferenceClicked,
                        isPreview: isPreview,
                      ).child,
                    ),
                  ),
              ],
              rows: [
                for (final row in rows)
                  DataRow(
                    cells: [
                      for (final cell in row)
                        DataCell(
                          Align(
                            alignment:
                                cell.attributes['align'] == 'right' ? Alignment.centerRight : Alignment.centerLeft,
                            child: Text.rich(
                              _buildMarkdownSpan(
                                account: account,
                                node: cell.children!.first,
                                textStyle: textStyle,
                                parameters: parameters,
                                onReferenceClicked: onReferenceClicked,
                                isPreview: isPreview,
                              ).child,
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
          finalNewline: true,
        );
      case 'ul':
        localListType = _MarkdownListType.unordered;
      default:
        throw UnimplementedError('Unexpected element tag ${node.tag}.'); // coverage:ignore-line
    }

    final spans = _buildMarkdownSpans(
      account: account,
      nodes: childNodes,
      textStyle: localTextStyle,
      parameters: parameters,
      onReferenceClicked: onReferenceClicked,
      isPreview: isPreview,
      listType: localListType,
      listDepth: localListDepth,
    );

    return (
      child: TextSpan(
        children: spans.children,
        style: localTextStyle,
      ),
      finalNewline: spans.finalNewline,
    );
  }

  throw UnimplementedError('Unexpected node type ${node.runtimeType}.'); // coverage:ignore-line
}
