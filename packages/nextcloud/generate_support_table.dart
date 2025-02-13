import 'dart:io';

import 'package:collection/collection.dart';
import 'package:version/version.dart';

final labels = <String, String>{
  'server': '[Server](https://github.com/nextcloud/server) (2)',
  'cookbook': '[Cookbook app](https://github.com/nextcloud/cookbook)',
  'drop_account': '[User account deletion app](https://framagit.org/framasoft/nextcloud/drop_account)',
  'news': '[News app](https://github.com/nextcloud/news)',
  'notes': '[Notes app](https://github.com/nextcloud/notes)',
  'notifications': '[Notifications app](https://github.com/nextcloud/notifications)',
  'password_policy': '[Password Policy app](https://github.com/nextcloud/password_policy)',
  'spreed': '[Talk app](https://github.com/nextcloud/spreed)',
  'tables': '[Tables app](https://github.com/nextcloud/tables)',
  'uppush': '[NextPush app](https://codeberg.org/NextPush/uppush)',
};

void main() {
  var support = <String, ({Version min, Version max})>{};

  final dir = Directory('packages/nextcloud_test_presets/docker/presets');
  for (final appDir in dir.listSync()) {
    if (appDir is! Directory) {
      continue;
    }

    final versions = <Version>[];
    for (final presetFile in appDir.listSync()) {
      final version = Version.parse(presetFile.uri.pathSegments.last);
      versions.add(version);
    }
    versions.sort();

    final app = appDir.uri.pathSegments[appDir.uri.pathSegments.length - 2];
    support[app] = (min: versions.first, max: versions.last);
  }

  support['notifications'] = support['server']!;
  support['password_policy'] = support['server']!;

  support = Map.fromEntries(
    support.entries.sorted((a, b) {
      if (a.key == 'server') {
        return -1;
      }
      if (b.key == 'server') {
        return 1;
      }
      return a.key.compareTo(b.key);
    }),
  );

  final columns = <String, String>{
    'Component': 'Supported versions (1)',
  };
  for (final entry in support.entries) {
    final app = entry.key;
    final min = entry.value.min;
    final max = entry.value.max;

    late String range;
    if (min == max) {
      range = _formatVersionRemoveTrailingZeros(min);
    } else {
      range = '${_formatVersionRemoveTrailingZeros(min)} - ${_formatVersionRemoveTrailingZeros(max)}';
    }

    columns[labels[app]!] = range;
  }

  final firstColumnWidth = columns.keys.sorted((a, b) => a.length.compareTo(b.length)).last.length;
  final secondColumnWidth = columns.values.sorted((a, b) => a.length.compareTo(b.length)).last.length;

  final out = StringBuffer();
  for (final (index, row) in columns.entries.indexed) {
    out.writeln('| ${row.key.padRight(firstColumnWidth)} | ${row.value.padRight(secondColumnWidth)} |');
    if (index == 0) {
      out.writeln('|${''.padRight(firstColumnWidth + 2, '-')}|${''.padRight(secondColumnWidth + 2, '-')}|');
    }
  }

  final file = File('README.md');
  var content = file.readAsStringSync();
  content = content.replaceAllMapped(
    RegExp(
      r'(\[Do not edit manually below]: #\n\n)(.*)(\n\[Do not edit manually above]: #)',
      multiLine: true,
      dotAll: true,
    ),
    (match) => '${match.group(1)}$out${match.group(3)}',
  );
  file.writeAsStringSync(content);
}

String _formatVersionRemoveTrailingZeros(Version version) {
  if (version.patch == 0 && version.minor == 0) {
    return '${version.major}';
  }

  if (version.patch == 0) {
    return '${version.major}.${version.minor}';
  }

  return '${version.major}.${version.minor}.${version.patch}';
}
