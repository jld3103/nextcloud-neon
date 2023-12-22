import 'dart:async';
import 'dart:convert';

import 'package:build/build.dart';
import 'package:checked_yaml/checked_yaml.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:dynamite/src/builder/client.dart';
import 'package:dynamite/src/builder/generate_ofs.dart';
import 'package:dynamite/src/builder/generate_schemas.dart';
import 'package:dynamite/src/builder/serializer.dart';
import 'package:dynamite/src/builder/state.dart';
import 'package:dynamite/src/helpers/dart_helpers.dart';
import 'package:dynamite/src/helpers/version_checker.dart';
import 'package:dynamite/src/models/config.dart';
import 'package:dynamite/src/models/openapi.dart' as openapi;
import 'package:path/path.dart' as p;
import 'package:version/version.dart';

class OpenAPIBuilder implements Builder {
  OpenAPIBuilder(
    final BuilderOptions options,
  ) : buildConfig = DynamiteConfig.fromJson(options.config);

  @override
  final buildExtensions = const {
    '.openapi.json': ['.openapi.dart'],
    '.openapi.yaml': ['.openapi.dart'],
  };

  /// The minimum openapi version supported by this builder.
  static final Version minSupportedVersion = Version(3, 0, 0);

  /// The maximum openapi version supported by this builder.
  static final Version maxSupportedVersion = minSupportedVersion.incrementMajor();

  /// The configuration for this builder.
  final DynamiteConfig buildConfig;

  @override
  Future<void> build(final BuildStep buildStep) async {
    final result = await helperVersionCheck(buildStep);

    if (result.messages.isNotEmpty) {
      if (result.hasFatal) {
        log.severe(result.messages);
        return;
      } else {
        log.info(result.messages);
      }
    }

    try {
      final inputId = buildStep.inputId;
      final outputId = inputId.changeExtension('.dart');

      final emitter = DartEmitter(
        orderDirectives: true,
        useNullSafetySyntax: true,
      );

      final spec = switch (inputId.extension) {
        '.json' => openapi.serializers.deserializeWith(
            openapi.OpenAPI.serializer,
            json.decode(await buildStep.readAsString(inputId)),
          )!,
        '.yaml' => checkedYamlDecode(
            await buildStep.readAsString(inputId),
            (final m) => openapi.serializers.deserializeWith(openapi.OpenAPI.serializer, m)!,
          ),
        _ => throw StateError('Openapi specs can only be yaml or json.'),
      };

      final version = Version.parse(spec.version);
      if (version < minSupportedVersion || version > maxSupportedVersion) {
        throw Exception('Only OpenAPI between $minSupportedVersion and $maxSupportedVersion are supported.');
      }

      final state = State(buildConfig);

      final output = Library((final b) {
        final analyzerIgnores = state.buildConfig.analyzerIgnores;
        if (analyzerIgnores != null) {
          b.ignoreForFile.addAll(analyzerIgnores);
        }

        b
          ..name = toLibraryName(p.basenameWithoutExtension(inputId.path))
          ..directives.addAll([
            Directive.import('dart:convert'),
            Directive.import('dart:typed_data'),
            Directive.import('package:built_collection/built_collection.dart'),
            Directive.import('package:built_value/built_value.dart'),
            Directive.import('package:built_value/json_object.dart'),
            Directive.import('package:built_value/serializer.dart'),
            Directive.import('package:built_value/standard_json_plugin.dart'),
            Directive.import('package:collection/collection.dart'),
            Directive.import('package:dynamite_runtime/built_value.dart'),
            Directive.import('package:dynamite_runtime/http_client.dart'),
            Directive.import('package:dynamite_runtime/models.dart'),
            Directive.import('package:dynamite_runtime/utils.dart', as: 'dynamite_utils'),
            Directive.import('package:meta/meta.dart'),
            Directive.import('package:universal_io/io.dart'),
            Directive.import('package:uri/uri.dart'),
          ])
          ..body.addAll(generateClients(spec, state))
          ..body.addAll(generateSchemas(spec, state))
          ..body.addAll(buildOfsExtensions(spec, state))
          ..body.addAll(buildSerializer(state));

        // Part directive need to be generated after everything else so we know if we need it.
        if (state.hasResolvedBuiltTypes) {
          b.directives.add(
            Directive.part(p.basename(outputId.changeExtension('.g.dart').path)),
          );
        }
      });

      var outputString = output.accept(emitter).toString();

      final coverageIgnores = state.buildConfig.coverageIgnores;
      if (coverageIgnores != null) {
        for (final ignore in coverageIgnores) {
          final pattern = RegExp(ignore);

          outputString = outputString.replaceAllMapped(
            pattern,
            (final match) => '  // coverage:ignore-start\n${match.group(0)}\n  // coverage:ignore-end',
          );
        }
      }

      final formatter = DartFormatter(pageWidth: buildConfig.pageWidth);
      unawaited(
        buildStep.writeAsString(
          outputId,
          formatter.format(outputString),
        ),
      );
    } catch (e, s) {
      print(s);

      rethrow;
    }
  }
}
