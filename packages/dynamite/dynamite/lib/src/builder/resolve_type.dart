import 'package:built_collection/built_collection.dart';
import 'package:dynamite/src/builder/resolve_enum.dart';
import 'package:dynamite/src/builder/resolve_object.dart';
import 'package:dynamite/src/builder/resolve_ofs.dart';
import 'package:dynamite/src/builder/state.dart';
import 'package:dynamite/src/helpers/dart_helpers.dart';
import 'package:dynamite/src/models/json_schema.dart' as json_schema;
import 'package:dynamite/src/models/openapi.dart' as openapi;
import 'package:dynamite/src/models/type_result.dart';

/// Resolves the [schema] into a `TypeResult`.
///
/// Resolved types are always added to the [state].
TypeResult resolveType(
  openapi.OpenAPI spec,
  State state,
  String identifier,
  json_schema.Schema schema, {
  bool nullable = false,
}) {
  final result = _resolveType(
    spec,
    state,
    identifier,
    schema,
    nullable: nullable,
  );

  state.resolvedTypes.add(result);
  return result;
}

TypeResult _resolveType(
  openapi.OpenAPI spec,
  State state,
  String identifier,
  json_schema.Schema schema, {
  bool nullable = false,
}) {
  switch (schema) {
    case json_schema.Schema($enum: != null):
      final subResult = resolveType(
        spec,
        state,
        identifier,
        schema.rebuild((b) {
          b.$enum = null;
        }),
        nullable: nullable,
      );

      return resolveEnum(
        spec,
        state,
        identifier,
        schema,
        subResult,
        nullable: nullable,
      );

    case json_schema.Schema(allOf: != null):
      return resolveObject(
        spec,
        state,
        identifier,
        schema,
        nullable: nullable,
      );

    case json_schema.Schema(ref: null, ofs: null, type: null):
      return TypeResultBase(
        'JsonObject',
        nullable: nullable,
      );

    case json_schema.Schema(ref: != null):
      final name = schema.ref!.fragment.split('/').last;
      final subResult = resolveType(
        spec,
        state,
        toDartName(name, className: true),
        schema.resolveRef(state.rootJson),
        nullable: nullable,
      );

      return subResult.asTypeDef;

    case json_schema.Schema(anyOf: != null) || json_schema.Schema(oneOf: != null):
      return resolveSomeOf(
        spec,
        state,
        identifier,
        schema,
        nullable: nullable,
      );

    case json_schema.Schema(isContentString: true):
      final subResult = resolveType(
        spec,
        state,
        identifier,
        schema.contentSchema!,
      );

      return TypeResultObject(
        'ContentString',
        generics: BuiltList([subResult]),
        nullable: nullable,
      );

    case json_schema.Schema(type: json_schema.SchemaType.boolean):
      return TypeResultBase(
        'bool',
        nullable: nullable,
      );

    case json_schema.Schema(type: json_schema.SchemaType.integer):
      return TypeResultBase(
        'int',
        nullable: nullable,
      );

    case json_schema.Schema(type: json_schema.SchemaType.number, format: 'float' || 'double'):
      return TypeResultBase(
        'double',
        nullable: nullable,
      );

    case json_schema.Schema(type: json_schema.SchemaType.number):
      return TypeResultBase(
        'num',
        nullable: nullable,
      );

    case json_schema.Schema(type: json_schema.SchemaType.string, format: 'binary'):
      return TypeResultBase(
        'Uint8List',
        nullable: nullable,
      );

    case json_schema.Schema(type: json_schema.SchemaType.string):
      return TypeResultBase(
        'String',
        nullable: nullable,
      );

    case json_schema.Schema(type: json_schema.SchemaType.array):
      final TypeResult subResult;
      if (schema.maxItems == 0) {
        subResult = TypeResultBase('Never');
      } else if (schema.items != null) {
        subResult = resolveType(
          spec,
          state,
          identifier,
          schema.items!,
        );
      } else {
        subResult = TypeResultBase('JsonObject');
      }

      return TypeResultList(
        'BuiltList',
        subResult,
        nullable: nullable,
      );

    case json_schema.Schema(type: json_schema.SchemaType.object, properties: null):
      if (schema.additionalProperties == null) {
        return TypeResultBase(
          'JsonObject',
          nullable: nullable,
        );
      } else {
        final subResult = resolveType(
          spec,
          state,
          identifier,
          schema.additionalProperties!,
        );
        return TypeResultMap(
          'BuiltMap',
          subResult,
          nullable: nullable,
        );
      }

    case json_schema.Schema(type: json_schema.SchemaType.object, :final properties)
        when properties != null && properties.isEmpty:
      return TypeResultMap(
        'BuiltMap',
        TypeResultBase('JsonObject'),
        nullable: nullable,
      );

    case json_schema.Schema(type: json_schema.SchemaType.object):
      return resolveObject(
        spec,
        state,
        identifier,
        schema,
        nullable: nullable,
      );

    default:
      throw Exception('Can not convert OpenAPI type "$schema" to a Dart type');
  }
}
