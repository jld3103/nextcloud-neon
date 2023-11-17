import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dynamite/src/builder/resolve_interface.dart';
import 'package:dynamite/src/builder/resolve_type.dart';
import 'package:dynamite/src/builder/state.dart';
import 'package:dynamite/src/helpers/built_value.dart';
import 'package:dynamite/src/helpers/dart_helpers.dart';
import 'package:dynamite/src/models/openapi.dart' as openapi;
import 'package:dynamite/src/models/type_result.dart';

TypeResult resolveAllOf(
  final openapi.OpenAPI spec,
  final State state,
  final String identifier,
  final openapi.Schema schema, {
  final bool nullable = false,
}) {
  final result = TypeResultObject(
    identifier,
    nullable: nullable,
  );

  if (state.resolvedTypes.add(result)) {
    final interfaces = <TypeResultObject>{};

    for (final s in schema.allOf!) {
      final TypeResultObject interfaceClass;
      if (s.ref != null) {
        final object = resolveType(
          spec,
          state,
          identifier,
          s,
          nullable: nullable,
        );

        if (object is! TypeResultObject) {
          throw StateError('allOf does only allow objects. Please change $identifier');
        }

        interfaceClass = object;
      } else {
        interfaceClass = resolveInterface(
          spec,
          state,
          '${identifier}_${schema.allOf!.indexOf(s)}',
          s,
        );
      }

      interfaces.add(interfaceClass);
    }

    state.output.add(
      buildInterface(identifier, interfaces: interfaces),
    );

    state.output.add(
      buildBuiltClass(
        identifier,
      ),
    );
  }
  return result;
}

TypeResult resolveOfs(
  final openapi.OpenAPI spec,
  final State state,
  final String identifier,
  final openapi.Schema schema, {
  final bool nullable = false,
}) {
  if (schema.allOf != null) {
    throw StateError('allOf should be handled with inheritance');
  }

  final result = TypeResultObject(
    identifier,
    nullable: nullable,
  );

  if (state.resolvedTypes.add(result)) {
    final results = schema.ofs!
        .map(
          (final s) => resolveType(
            spec,
            state,
            '$identifier${schema.ofs!.indexOf(s)}',
            s,
            nullable: true,
          ),
        )
        .toList();

    final fields = <String, String>{};
    for (final result in results) {
      final dartName = toDartName(result.name);
      fields[result.name] = toFieldName(dartName, result.name);
    }

    final interface = buildInterface(
      identifier,
      methods: BuiltList.from(
        results.map(
          (final result) => Method(
            (final b) {
              final s = schema.ofs![results.indexOf(result)];
              b
                ..name = fields[result.name]
                ..returns = refer(result.nullableName)
                ..type = MethodType.getter
                ..docs.addAll(s.formattedDescription);
            },
          ),
        ),
      ),
    );

    final hook = Method((final b) {
      b
        ..name = '_validate'
        ..returns = refer('void')
        ..annotations.add(
          refer('BuiltValueHook').call([], {'finalizeBuilder': literalTrue}),
        )
        ..static = true
        ..requiredParameters.add(
          Parameter(
            (final b) => b
              ..name = 'b'
              ..type = refer('${identifier}Builder'),
          ),
        );

      final buffer = StringBuffer()
        ..writeln('// When this is rebuild from another builder')
        ..writeln('if (b._data == null) { return;}')
        ..writeln()
        ..writeln('final match = ')
        ..writeln('[${fields.values.map((final e) => 'b._$e').join(',')}]')
        ..writeln(schema.oneOf != null ? '.singleWhereOrNull' : '.firstWhereOrNull')
        ..writeln('((final x) => x != null);')
        ..writeln('if (match == null) {')
        ..writeln(
          'throw StateError("Need ${schema.oneOf != null ? 'exactly' : 'at least'} one of ${fields.values.map((final e) => "'$e'").join(', ')} for \${b._data}");',
        )
        ..writeln('}');

      b.body = Code(buffer.toString());
    });

    final $class = buildBuiltClass(
      identifier,
      customSerializer: true,
      methods: BuiltList.build(
        (final b) => b
          ..add(
            Method(
              (final b) {
                b
                  ..name = 'data'
                  ..returns = refer('JsonObject')
                  ..type = MethodType.getter;
              },
            ),
          )
          ..add(hook),
      ),
    );

    final serializer = Class(
      (final b) => b
        ..name = '_\$${identifier}Serializer'
        ..implements.add(refer('PrimitiveSerializer<$identifier>'))
        ..fields.addAll([
          Field(
            (final b) => b
              ..name = 'types'
              ..modifier = FieldModifier.final$
              ..type = refer('Iterable<Type>')
              ..annotations.add(refer('override'))
              ..assignment = Code('const [$identifier, _\$$identifier]'),
          ),
          Field(
            (final b) => b
              ..name = 'wireName'
              ..modifier = FieldModifier.final$
              ..type = refer('String')
              ..annotations.add(refer('override'))
              ..assignment = Code("r'$identifier'"),
          ),
        ])
        ..methods.addAll([
          Method((final b) {
            b
              ..name = 'serialize'
              ..returns = refer('Object')
              ..annotations.add(refer('override'))
              ..requiredParameters.addAll([
                Parameter(
                  (final b) => b
                    ..name = 'serializers'
                    ..type = refer('Serializers'),
                ),
                Parameter(
                  (final b) => b
                    ..name = 'object'
                    ..type = refer(identifier),
                ),
              ])
              ..optionalParameters.add(
                Parameter(
                  (final b) => b
                    ..name = 'specifiedType'
                    ..type = refer('FullType')
                    ..named = true
                    ..defaultTo = const Code('FullType.unspecified'),
                ),
              )
              ..body = const Code('return object.data.value;');
          }),
          Method((final b) {
            b
              ..name = 'deserialize'
              ..returns = refer(identifier)
              ..annotations.add(refer('override'))
              ..requiredParameters.addAll([
                Parameter(
                  (final b) => b
                    ..name = 'serializers'
                    ..type = refer('Serializers'),
                ),
                Parameter(
                  (final b) => b
                    ..name = 'data'
                    ..type = refer('Object'),
                ),
              ])
              ..optionalParameters.add(
                Parameter(
                  (final b) => b
                    ..name = 'specifiedType'
                    ..type = refer('FullType')
                    ..named = true
                    ..defaultTo = const Code('FullType.unspecified'),
                ),
              )
              ..body = Code(
                <String>[
                  'final result = ${identifier}Builder()',
                  '..data = JsonObject(data);',
                  if (schema.discriminator != null) ...[
                    'if (data is! Iterable) {',
                    r"throw StateError('Expected an Iterable but got ${data.runtimeType}');",
                    '}',
                    '',
                    'String? discriminator;',
                    '',
                    'final iterator = data.iterator;',
                    'while (iterator.moveNext()) {',
                    'final key = iterator.current! as String;',
                    'iterator.moveNext();',
                    'final Object? value = iterator.current;',
                    "if (key == '${schema.discriminator!.propertyName}') {",
                    'discriminator = value! as String;',
                    'break;',
                    '}',
                    '}',
                  ],
                  for (final result in results) ...[
                    if (schema.discriminator != null) ...[
                      "if (discriminator == '${result.name}'",
                      if (schema.discriminator!.mapping != null && schema.discriminator!.mapping!.isNotEmpty) ...[
                        for (final key in schema.discriminator!.mapping!.entries
                            .where(
                              (final entry) => entry.value.endsWith('/${result.name}'),
                            )
                            .map((final entry) => entry.key)) ...[
                          " ||  discriminator == '$key'",
                        ],
                        ') {',
                      ],
                    ],
                    'try {',
                    'final value = ${result.deserialize('data')};',
                    if (result is TypeResultBase || result is TypeResultEnum)
                      'result.${fields[result.name]!} = value;'
                    else
                      'result.${fields[result.name]!}.replace(value);',
                    '} catch (_) {',
                    if (schema.discriminator != null) ...[
                      'rethrow;',
                    ],
                    '}',
                    if (schema.discriminator != null) ...[
                      '}',
                    ],
                  ],
                  'return result.build();',
                ].join(),
              );
          }),
        ]),
    );

    state.output.addAll([
      interface,
      $class,
      serializer,
    ]);
  }

  return result;
}
