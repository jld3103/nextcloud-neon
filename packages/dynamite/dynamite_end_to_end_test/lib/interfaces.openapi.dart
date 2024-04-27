// OpenAPI client generated by Dynamite. Do not manually edit this file.

// ignore_for_file: camel_case_extensions, camel_case_types, cascade_invocations
// ignore_for_file: discarded_futures
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: non_constant_identifier_names, public_member_api_docs
// ignore_for_file: unreachable_switch_case, unused_element

/// interfaces test Version: 0.0.1.
library; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart' as _i3;
import 'package:dynamite_runtime/built_value.dart' as _i2;
import 'package:meta/meta.dart' as _i1;

part 'interfaces.openapi.g.dart';

@BuiltValue(instantiable: false)
abstract interface class $BaseInterface {
  String? get attribute;
  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($BaseInterfaceBuilder b) {}
  @BuiltValueHook(finalizeBuilder: true)
  static void _validate($BaseInterfaceBuilder b) {}
}

abstract class Base implements $BaseInterface, Built<Base, BaseBuilder> {
  /// Creates a new Base object using the builder pattern.
  factory Base([void Function(BaseBuilder)? b]) = _$Base;

  const Base._();

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  factory Base.fromJson(Map<String, dynamic> json) => _$jsonSerializers.deserializeWith(serializer, json)!;

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;

  /// Serializer for Base.
  static Serializer<Base> get serializer => _$baseSerializer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BaseBuilder b) {
    $BaseInterface._defaults(b);
  }

  @BuiltValueHook(finalizeBuilder: true)
  static void _validate(BaseBuilder b) {
    $BaseInterface._validate(b);
  }
}

@BuiltValue(instantiable: false)
abstract interface class $BaseInterfaceInterface {
  String? get attribute;
  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($BaseInterfaceInterfaceBuilder b) {}
  @BuiltValueHook(finalizeBuilder: true)
  static void _validate($BaseInterfaceInterfaceBuilder b) {}
}

abstract class BaseInterface implements $BaseInterfaceInterface, Built<BaseInterface, BaseInterfaceBuilder> {
  /// Creates a new BaseInterface object using the builder pattern.
  factory BaseInterface([void Function(BaseInterfaceBuilder)? b]) = _$BaseInterface;

  const BaseInterface._();

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  factory BaseInterface.fromJson(Map<String, dynamic> json) => _$jsonSerializers.deserializeWith(serializer, json)!;

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;

  /// Serializer for BaseInterface.
  static Serializer<BaseInterface> get serializer => _$baseInterfaceSerializer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BaseInterfaceBuilder b) {
    $BaseInterfaceInterface._defaults(b);
  }

  @BuiltValueHook(finalizeBuilder: true)
  static void _validate(BaseInterfaceBuilder b) {
    $BaseInterfaceInterface._validate(b);
  }
}

// coverage:ignore-start
/// Serializer for all values in this library.
///
/// Serializes values into the `built_value` wire format.
/// See: [$jsonSerializers] for serializing into json.
@_i1.visibleForTesting
final Serializers $serializers = _$serializers;
final Serializers _$serializers = (Serializers().toBuilder()
      ..addBuilderFactory(const FullType(Base), BaseBuilder.new)
      ..add(Base.serializer)
      ..addBuilderFactory(const FullType(BaseInterface), BaseInterfaceBuilder.new)
      ..add(BaseInterface.serializer))
    .build();

/// Serializer for all values in this library.
///
/// Serializes values into the json. Json serialization is more expensive than the built_value wire format.
/// See: [$serializers] for serializing into the `built_value` wire format.
@_i1.visibleForTesting
final Serializers $jsonSerializers = _$jsonSerializers;
final Serializers _$jsonSerializers = (_$serializers.toBuilder()
      ..add(_i2.DynamiteDoubleSerializer())
      ..addPlugin(_i3.StandardJsonPlugin())
      ..addPlugin(const _i2.HeaderPlugin())
      ..addPlugin(const _i2.ContentStringPlugin()))
    .build();
// coverage:ignore-end
