// ignore_for_file: camel_case_types, discarded_futures
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: public_member_api_docs, unreachable_switch_case
// ignore_for_file: unused_element

library enum_openapi;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:dynamite_runtime/built_value.dart';
import 'package:meta/meta.dart';

part 'enum.openapi.g.dart';

class EnumString extends EnumClass {
  const EnumString._(super.name);

  static const EnumString test = _$enumStringTest;

  @BuiltValueEnumConst(wireName: 'default')
  static const EnumString $default = _$enumString$default;

  @BuiltValueEnumConst(wireName: r'$dollar$')
  static const EnumString dollar = _$enumStringDollar;

  static BuiltSet<EnumString> get values => _$enumStringValues;

  static EnumString valueOf(String name) => _$valueOfEnumString(name);

  String get value => jsonSerializers.serializeWith(serializer, this)! as String;

  @BuiltValueSerializer(custom: true)
  static Serializer<EnumString> get serializer => const _$EnumStringSerializer();
}

class _$EnumStringSerializer implements PrimitiveSerializer<EnumString> {
  const _$EnumStringSerializer();

  static const Map<EnumString, Object> _toWire = <EnumString, Object>{
    EnumString.test: 'test',
    EnumString.$default: 'default',
    EnumString.dollar: r'$dollar$',
  };

  static const Map<Object, EnumString> _fromWire = <Object, EnumString>{
    'test': EnumString.test,
    'default': EnumString.$default,
    r'$dollar$': EnumString.dollar,
  };

  @override
  Iterable<Type> get types => const [EnumString];

  @override
  String get wireName => 'EnumString';

  @override
  Object serialize(
    Serializers serializers,
    EnumString object, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      _toWire[object]!;

  @override
  EnumString deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      _fromWire[serialized]!;
}

class EnumInt extends EnumClass {
  const EnumInt._(super.name);

  @BuiltValueEnumConst(wireName: '0')
  static const EnumInt $0 = _$enumInt$0;

  @BuiltValueEnumConst(wireName: '1')
  static const EnumInt $1 = _$enumInt$1;

  @BuiltValueEnumConst(wireName: '2')
  static const EnumInt $2 = _$enumInt$2;

  static BuiltSet<EnumInt> get values => _$enumIntValues;

  static EnumInt valueOf(String name) => _$valueOfEnumInt(name);

  int get value => jsonSerializers.serializeWith(serializer, this)! as int;

  @BuiltValueSerializer(custom: true)
  static Serializer<EnumInt> get serializer => const _$EnumIntSerializer();
}

class _$EnumIntSerializer implements PrimitiveSerializer<EnumInt> {
  const _$EnumIntSerializer();

  static const Map<EnumInt, Object> _toWire = <EnumInt, Object>{
    EnumInt.$0: 0,
    EnumInt.$1: 1,
    EnumInt.$2: 2,
  };

  static const Map<Object, EnumInt> _fromWire = <Object, EnumInt>{
    0: EnumInt.$0,
    1: EnumInt.$1,
    2: EnumInt.$2,
  };

  @override
  Iterable<Type> get types => const [EnumInt];

  @override
  String get wireName => 'EnumInt';

  @override
  Object serialize(
    Serializers serializers,
    EnumInt object, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      _toWire[object]!;

  @override
  EnumInt deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      _fromWire[serialized]!;
}

class EnumDynamic extends EnumClass {
  const EnumDynamic._(super.name);

  @BuiltValueEnumConst(wireName: '0')
  static const EnumDynamic $0 = _$enumDynamic$0;

  static const EnumDynamic string = _$enumDynamicString;

  @BuiltValueEnumConst(wireName: 'false')
  static const EnumDynamic $false = _$enumDynamic$false;

  static BuiltSet<EnumDynamic> get values => _$enumDynamicValues;

  static EnumDynamic valueOf(String name) => _$valueOfEnumDynamic(name);

  dynamic get value => jsonSerializers.serializeWith(serializer, this)! as dynamic;

  @BuiltValueSerializer(custom: true)
  static Serializer<EnumDynamic> get serializer => const _$EnumDynamicSerializer();
}

class _$EnumDynamicSerializer implements PrimitiveSerializer<EnumDynamic> {
  const _$EnumDynamicSerializer();

  static const Map<EnumDynamic, Object> _toWire = <EnumDynamic, Object>{
    EnumDynamic.$0: 0,
    EnumDynamic.string: 'string',
    EnumDynamic.$false: false,
  };

  static const Map<Object, EnumDynamic> _fromWire = <Object, EnumDynamic>{
    0: EnumDynamic.$0,
    'string': EnumDynamic.string,
    false: EnumDynamic.$false,
  };

  @override
  Iterable<Type> get types => const [EnumDynamic];

  @override
  String get wireName => 'EnumDynamic';

  @override
  Object serialize(
    Serializers serializers,
    EnumDynamic object, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      _toWire[object]!;

  @override
  EnumDynamic deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      _fromWire[serialized]!;
}

class WrappedEnum_CustomString extends EnumClass {
  const WrappedEnum_CustomString._(super.name);

  static const WrappedEnum_CustomString test = _$wrappedEnumCustomStringTest;

  @BuiltValueEnumConst(wireName: 'default')
  static const WrappedEnum_CustomString $default = _$wrappedEnumCustomString$default;

  static BuiltSet<WrappedEnum_CustomString> get values => _$wrappedEnumCustomStringValues;

  static WrappedEnum_CustomString valueOf(String name) => _$valueOfWrappedEnum_CustomString(name);

  String get value => jsonSerializers.serializeWith(serializer, this)! as String;

  @BuiltValueSerializer(custom: true)
  static Serializer<WrappedEnum_CustomString> get serializer => const _$WrappedEnum_CustomStringSerializer();
}

class _$WrappedEnum_CustomStringSerializer implements PrimitiveSerializer<WrappedEnum_CustomString> {
  const _$WrappedEnum_CustomStringSerializer();

  static const Map<WrappedEnum_CustomString, Object> _toWire = <WrappedEnum_CustomString, Object>{
    WrappedEnum_CustomString.test: 'test',
    WrappedEnum_CustomString.$default: 'default',
  };

  static const Map<Object, WrappedEnum_CustomString> _fromWire = <Object, WrappedEnum_CustomString>{
    'test': WrappedEnum_CustomString.test,
    'default': WrappedEnum_CustomString.$default,
  };

  @override
  Iterable<Type> get types => const [WrappedEnum_CustomString];

  @override
  String get wireName => 'WrappedEnum_CustomString';

  @override
  Object serialize(
    Serializers serializers,
    WrappedEnum_CustomString object, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      _toWire[object]!;

  @override
  WrappedEnum_CustomString deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      _fromWire[serialized]!;
}

class WrappedEnum_Integer extends EnumClass {
  const WrappedEnum_Integer._(super.name);

  @BuiltValueEnumConst(wireName: '0')
  static const WrappedEnum_Integer $0 = _$wrappedEnumInteger$0;

  @BuiltValueEnumConst(wireName: '1')
  static const WrappedEnum_Integer $1 = _$wrappedEnumInteger$1;

  @BuiltValueEnumConst(wireName: '2')
  static const WrappedEnum_Integer $2 = _$wrappedEnumInteger$2;

  static BuiltSet<WrappedEnum_Integer> get values => _$wrappedEnumIntegerValues;

  static WrappedEnum_Integer valueOf(String name) => _$valueOfWrappedEnum_Integer(name);

  int get value => jsonSerializers.serializeWith(serializer, this)! as int;

  @BuiltValueSerializer(custom: true)
  static Serializer<WrappedEnum_Integer> get serializer => const _$WrappedEnum_IntegerSerializer();
}

class _$WrappedEnum_IntegerSerializer implements PrimitiveSerializer<WrappedEnum_Integer> {
  const _$WrappedEnum_IntegerSerializer();

  static const Map<WrappedEnum_Integer, Object> _toWire = <WrappedEnum_Integer, Object>{
    WrappedEnum_Integer.$0: 0,
    WrappedEnum_Integer.$1: 1,
    WrappedEnum_Integer.$2: 2,
  };

  static const Map<Object, WrappedEnum_Integer> _fromWire = <Object, WrappedEnum_Integer>{
    0: WrappedEnum_Integer.$0,
    1: WrappedEnum_Integer.$1,
    2: WrappedEnum_Integer.$2,
  };

  @override
  Iterable<Type> get types => const [WrappedEnum_Integer];

  @override
  String get wireName => 'WrappedEnum_Integer';

  @override
  Object serialize(
    Serializers serializers,
    WrappedEnum_Integer object, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      _toWire[object]!;

  @override
  WrappedEnum_Integer deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      _fromWire[serialized]!;
}

@BuiltValue(instantiable: false)
abstract interface class $WrappedEnumInterface {
  @BuiltValueField(wireName: 'custom-string')
  WrappedEnum_CustomString get customString;
  WrappedEnum_Integer get integer;
}

abstract class WrappedEnum implements $WrappedEnumInterface, Built<WrappedEnum, WrappedEnumBuilder> {
  factory WrappedEnum([void Function(WrappedEnumBuilder)? b]) = _$WrappedEnum;

  const WrappedEnum._();

  factory WrappedEnum.fromJson(Map<String, dynamic> json) => jsonSerializers.deserializeWith(serializer, json)!;

  Map<String, dynamic> toJson() => jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;

  static Serializer<WrappedEnum> get serializer => _$wrappedEnumSerializer;
}

// coverage:ignore-start
@visibleForTesting
final Serializers serializers = (Serializers().toBuilder()
      ..add(EnumString.serializer)
      ..add(EnumInt.serializer)
      ..add(EnumDynamic.serializer)
      ..addBuilderFactory(const FullType(WrappedEnum), WrappedEnumBuilder.new)
      ..add(WrappedEnum.serializer)
      ..add(WrappedEnum_CustomString.serializer)
      ..add(WrappedEnum_Integer.serializer))
    .build();
@visibleForTesting
final Serializers jsonSerializers = (serializers.toBuilder()
      ..add(DynamiteDoubleSerializer())
      ..addPlugin(StandardJsonPlugin())
      ..addPlugin(const HeaderPlugin())
      ..addPlugin(const ContentStringPlugin()))
    .build();
// coverage:ignore-end
