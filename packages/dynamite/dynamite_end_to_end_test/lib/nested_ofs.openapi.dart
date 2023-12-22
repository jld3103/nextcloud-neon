// ignore_for_file: camel_case_types, discarded_futures
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: public_member_api_docs, unreachable_switch_case
// ignore_for_file: unused_element

library nested_ofs_openapi;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:dynamite_runtime/built_value.dart';
import 'package:dynamite_runtime/utils.dart' as dynamite_utils;
import 'package:meta/meta.dart';

part 'nested_ofs.openapi.g.dart';

@BuiltValue(instantiable: false)
abstract interface class $BaseAllOf_1Interface {
  @BuiltValueField(wireName: 'attribute-allOf')
  String get attributeAllOf;
}

@BuiltValue(instantiable: false)
abstract interface class $BaseAllOfInterface implements $BaseAllOf_1Interface {
  @BuiltValueField(wireName: 'String')
  String get string;
}

abstract class BaseAllOf implements $BaseAllOfInterface, Built<BaseAllOf, BaseAllOfBuilder> {
  factory BaseAllOf([void Function(BaseAllOfBuilder)? b]) = _$BaseAllOf;

  const BaseAllOf._();

  factory BaseAllOf.fromJson(Map<String, dynamic> json) => jsonSerializers.deserializeWith(serializer, json)!;

  Map<String, dynamic> toJson() => jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;

  static Serializer<BaseAllOf> get serializer => _$baseAllOfSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class $BaseOneOf1Interface {
  @BuiltValueField(wireName: 'attribute-oneOf')
  String get attributeOneOf;
}

abstract class BaseOneOf1 implements $BaseOneOf1Interface, Built<BaseOneOf1, BaseOneOf1Builder> {
  factory BaseOneOf1([void Function(BaseOneOf1Builder)? b]) = _$BaseOneOf1;

  const BaseOneOf1._();

  factory BaseOneOf1.fromJson(Map<String, dynamic> json) => jsonSerializers.deserializeWith(serializer, json)!;

  Map<String, dynamic> toJson() => jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;

  static Serializer<BaseOneOf1> get serializer => _$baseOneOf1Serializer;
}

@BuiltValue(instantiable: false)
abstract interface class $BaseAnyOf1Interface {
  @BuiltValueField(wireName: 'attribute-anyOf')
  String get attributeAnyOf;
}

abstract class BaseAnyOf1 implements $BaseAnyOf1Interface, Built<BaseAnyOf1, BaseAnyOf1Builder> {
  factory BaseAnyOf1([void Function(BaseAnyOf1Builder)? b]) = _$BaseAnyOf1;

  const BaseAnyOf1._();

  factory BaseAnyOf1.fromJson(Map<String, dynamic> json) => jsonSerializers.deserializeWith(serializer, json)!;

  Map<String, dynamic> toJson() => jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;

  static Serializer<BaseAnyOf1> get serializer => _$baseAnyOf1Serializer;
}

@BuiltValue(instantiable: false)
abstract interface class $BaseNestedAllOf_3Interface {
  @BuiltValueField(wireName: 'attribute-nested-allOf')
  String get attributeNestedAllOf;
}

@BuiltValue(instantiable: false)
abstract interface class $BaseNestedAllOfInterface implements $BaseAllOfInterface, $BaseNestedAllOf_3Interface {
  @BuiltValueField(wireName: 'BaseOneOf')
  BaseOneOf get baseOneOf;
  @BuiltValueField(wireName: 'BaseAnyOf')
  BaseAnyOf get baseAnyOf;
}

abstract class BaseNestedAllOf implements $BaseNestedAllOfInterface, Built<BaseNestedAllOf, BaseNestedAllOfBuilder> {
  factory BaseNestedAllOf([void Function(BaseNestedAllOfBuilder)? b]) = _$BaseNestedAllOf;

  const BaseNestedAllOf._();

  factory BaseNestedAllOf.fromJson(Map<String, dynamic> json) => jsonSerializers.deserializeWith(serializer, json)!;

  Map<String, dynamic> toJson() => jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;

  static Serializer<BaseNestedAllOf> get serializer => _$baseNestedAllOfSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class $BaseNestedOneOf3Interface {
  @BuiltValueField(wireName: 'attribute-nested-oneOf')
  String get attributeNestedOneOf;
}

abstract class BaseNestedOneOf3
    implements $BaseNestedOneOf3Interface, Built<BaseNestedOneOf3, BaseNestedOneOf3Builder> {
  factory BaseNestedOneOf3([void Function(BaseNestedOneOf3Builder)? b]) = _$BaseNestedOneOf3;

  const BaseNestedOneOf3._();

  factory BaseNestedOneOf3.fromJson(Map<String, dynamic> json) => jsonSerializers.deserializeWith(serializer, json)!;

  Map<String, dynamic> toJson() => jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;

  static Serializer<BaseNestedOneOf3> get serializer => _$baseNestedOneOf3Serializer;
}

@BuiltValue(instantiable: false)
abstract interface class $BaseNestedAnyOf3Interface {
  @BuiltValueField(wireName: 'attribute-nested-anyOf')
  String get attributeNestedAnyOf;
}

abstract class BaseNestedAnyOf3
    implements $BaseNestedAnyOf3Interface, Built<BaseNestedAnyOf3, BaseNestedAnyOf3Builder> {
  factory BaseNestedAnyOf3([void Function(BaseNestedAnyOf3Builder)? b]) = _$BaseNestedAnyOf3;

  const BaseNestedAnyOf3._();

  factory BaseNestedAnyOf3.fromJson(Map<String, dynamic> json) => jsonSerializers.deserializeWith(serializer, json)!;

  Map<String, dynamic> toJson() => jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;

  static Serializer<BaseNestedAnyOf3> get serializer => _$baseNestedAnyOf3Serializer;
}

typedef BaseOneOf = ({BaseOneOf1? baseOneOf1, double? $double});
typedef BaseAnyOf = ({BaseAnyOf1? baseAnyOf1, int? $int});
typedef BaseNestedOneOf = ({
  BaseAllOf? baseAllOf,
  BaseAnyOf? baseAnyOf,
  BaseNestedOneOf3? baseNestedOneOf3,
  BaseOneOf1? baseOneOf1,
  double? $double
});
typedef BaseNestedAnyOf = ({
  BaseAllOf? baseAllOf,
  BaseAnyOf1? baseAnyOf1,
  BaseNestedAnyOf3? baseNestedAnyOf3,
  BaseOneOf? baseOneOf,
  int? $int
});
typedef NestedOptimizedOneOf = ({BaseOneOf1? baseOneOf1, num? $num});
typedef $BaseOneOf1Double = ({BaseOneOf1? baseOneOf1, double? $double});

extension $BaseOneOf1DoubleExtension on $BaseOneOf1Double {
  List<dynamic> get _values => [baseOneOf1, $double];
  void validateOneOf() => dynamite_utils.validateOneOf(_values);
  void validateAnyOf() => dynamite_utils.validateAnyOf(_values);
  static Serializer<$BaseOneOf1Double> get serializer => const _$BaseOneOf1DoubleSerializer();
  static $BaseOneOf1Double fromJson(Object? json) => jsonSerializers.deserializeWith(serializer, json)!;
  Object? toJson() => jsonSerializers.serializeWith(serializer, this);
}

class _$BaseOneOf1DoubleSerializer implements PrimitiveSerializer<$BaseOneOf1Double> {
  const _$BaseOneOf1DoubleSerializer();

  @override
  Iterable<Type> get types => const [$BaseOneOf1Double];

  @override
  String get wireName => r'$BaseOneOf1Double';

  @override
  Object serialize(
    Serializers serializers,
    $BaseOneOf1Double object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    dynamic value;
    value = object.baseOneOf1;
    if (value != null) {
      return serializers.serialize(value, specifiedType: const FullType(BaseOneOf1))!;
    }
    value = object.$double;
    if (value != null) {
      return serializers.serialize(value, specifiedType: const FullType(double))!;
    }
// Should not be possible after validation.
    throw StateError('Tried to serialize without any value.');
  }

  @override
  $BaseOneOf1Double deserialize(
    Serializers serializers,
    Object data, {
    FullType specifiedType = FullType.unspecified,
  }) {
    BaseOneOf1? baseOneOf1;
    try {
      baseOneOf1 = serializers.deserialize(data, specifiedType: const FullType(BaseOneOf1))! as BaseOneOf1;
    } catch (_) {}
    double? $double;
    try {
      $double = serializers.deserialize(data, specifiedType: const FullType(double))! as double;
    } catch (_) {}
    return (baseOneOf1: baseOneOf1, $double: $double);
  }
}

typedef $BaseAnyOf1Int = ({BaseAnyOf1? baseAnyOf1, int? $int});

extension $BaseAnyOf1IntExtension on $BaseAnyOf1Int {
  List<dynamic> get _values => [baseAnyOf1, $int];
  void validateOneOf() => dynamite_utils.validateOneOf(_values);
  void validateAnyOf() => dynamite_utils.validateAnyOf(_values);
  static Serializer<$BaseAnyOf1Int> get serializer => const _$BaseAnyOf1IntSerializer();
  static $BaseAnyOf1Int fromJson(Object? json) => jsonSerializers.deserializeWith(serializer, json)!;
  Object? toJson() => jsonSerializers.serializeWith(serializer, this);
}

class _$BaseAnyOf1IntSerializer implements PrimitiveSerializer<$BaseAnyOf1Int> {
  const _$BaseAnyOf1IntSerializer();

  @override
  Iterable<Type> get types => const [$BaseAnyOf1Int];

  @override
  String get wireName => r'$BaseAnyOf1Int';

  @override
  Object serialize(
    Serializers serializers,
    $BaseAnyOf1Int object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    dynamic value;
    value = object.baseAnyOf1;
    if (value != null) {
      return serializers.serialize(value, specifiedType: const FullType(BaseAnyOf1))!;
    }
    value = object.$int;
    if (value != null) {
      return serializers.serialize(value, specifiedType: const FullType(int))!;
    }
// Should not be possible after validation.
    throw StateError('Tried to serialize without any value.');
  }

  @override
  $BaseAnyOf1Int deserialize(
    Serializers serializers,
    Object data, {
    FullType specifiedType = FullType.unspecified,
  }) {
    BaseAnyOf1? baseAnyOf1;
    try {
      baseAnyOf1 = serializers.deserialize(data, specifiedType: const FullType(BaseAnyOf1))! as BaseAnyOf1;
    } catch (_) {}
    int? $int;
    try {
      $int = serializers.deserialize(data, specifiedType: const FullType(int))! as int;
    } catch (_) {}
    return (baseAnyOf1: baseAnyOf1, $int: $int);
  }
}

typedef $BaseAllOfBaseAnyOfBaseNestedOneOf3BaseOneOf1Double = ({
  BaseAllOf? baseAllOf,
  BaseAnyOf? baseAnyOf,
  BaseNestedOneOf3? baseNestedOneOf3,
  BaseOneOf1? baseOneOf1,
  double? $double
});

extension $BaseAllOfBaseAnyOfBaseNestedOneOf3BaseOneOf1DoubleExtension
    on $BaseAllOfBaseAnyOfBaseNestedOneOf3BaseOneOf1Double {
  List<dynamic> get _values => [baseAllOf, baseAnyOf, baseNestedOneOf3, baseOneOf1, $double];
  void validateOneOf() => dynamite_utils.validateOneOf(_values);
  void validateAnyOf() => dynamite_utils.validateAnyOf(_values);
  static Serializer<$BaseAllOfBaseAnyOfBaseNestedOneOf3BaseOneOf1Double> get serializer =>
      const _$BaseAllOfBaseAnyOfBaseNestedOneOf3BaseOneOf1DoubleSerializer();
  static $BaseAllOfBaseAnyOfBaseNestedOneOf3BaseOneOf1Double fromJson(Object? json) =>
      jsonSerializers.deserializeWith(serializer, json)!;
  Object? toJson() => jsonSerializers.serializeWith(serializer, this);
}

class _$BaseAllOfBaseAnyOfBaseNestedOneOf3BaseOneOf1DoubleSerializer
    implements PrimitiveSerializer<$BaseAllOfBaseAnyOfBaseNestedOneOf3BaseOneOf1Double> {
  const _$BaseAllOfBaseAnyOfBaseNestedOneOf3BaseOneOf1DoubleSerializer();

  @override
  Iterable<Type> get types => const [$BaseAllOfBaseAnyOfBaseNestedOneOf3BaseOneOf1Double];

  @override
  String get wireName => r'$BaseAllOfBaseAnyOfBaseNestedOneOf3BaseOneOf1Double';

  @override
  Object serialize(
    Serializers serializers,
    $BaseAllOfBaseAnyOfBaseNestedOneOf3BaseOneOf1Double object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    dynamic value;
    value = object.baseAllOf;
    if (value != null) {
      return serializers.serialize(value, specifiedType: const FullType(BaseAllOf))!;
    }
    value = object.baseAnyOf;
    if (value != null) {
      return serializers.serialize(value, specifiedType: const FullType(BaseAnyOf))!;
    }
    value = object.baseNestedOneOf3;
    if (value != null) {
      return serializers.serialize(value, specifiedType: const FullType(BaseNestedOneOf3))!;
    }
    value = object.baseOneOf1;
    if (value != null) {
      return serializers.serialize(value, specifiedType: const FullType(BaseOneOf1))!;
    }
    value = object.$double;
    if (value != null) {
      return serializers.serialize(value, specifiedType: const FullType(double))!;
    }
// Should not be possible after validation.
    throw StateError('Tried to serialize without any value.');
  }

  @override
  $BaseAllOfBaseAnyOfBaseNestedOneOf3BaseOneOf1Double deserialize(
    Serializers serializers,
    Object data, {
    FullType specifiedType = FullType.unspecified,
  }) {
    BaseAllOf? baseAllOf;
    try {
      baseAllOf = serializers.deserialize(data, specifiedType: const FullType(BaseAllOf))! as BaseAllOf;
    } catch (_) {}
    BaseAnyOf? baseAnyOf;
    try {
      baseAnyOf =
          ((serializers.deserialize(data, specifiedType: const FullType(BaseAnyOf))! as BaseAnyOf)..validateAnyOf());
    } catch (_) {}
    BaseNestedOneOf3? baseNestedOneOf3;
    try {
      baseNestedOneOf3 =
          serializers.deserialize(data, specifiedType: const FullType(BaseNestedOneOf3))! as BaseNestedOneOf3;
    } catch (_) {}
    BaseOneOf1? baseOneOf1;
    try {
      baseOneOf1 = serializers.deserialize(data, specifiedType: const FullType(BaseOneOf1))! as BaseOneOf1;
    } catch (_) {}
    double? $double;
    try {
      $double = serializers.deserialize(data, specifiedType: const FullType(double))! as double;
    } catch (_) {}
    return (
      baseAllOf: baseAllOf,
      baseAnyOf: baseAnyOf,
      baseNestedOneOf3: baseNestedOneOf3,
      baseOneOf1: baseOneOf1,
      $double: $double
    );
  }
}

typedef $BaseAllOfBaseAnyOf1BaseNestedAnyOf3BaseOneOfInt = ({
  BaseAllOf? baseAllOf,
  BaseAnyOf1? baseAnyOf1,
  BaseNestedAnyOf3? baseNestedAnyOf3,
  BaseOneOf? baseOneOf,
  int? $int
});

extension $BaseAllOfBaseAnyOf1BaseNestedAnyOf3BaseOneOfIntExtension
    on $BaseAllOfBaseAnyOf1BaseNestedAnyOf3BaseOneOfInt {
  List<dynamic> get _values => [baseAllOf, baseAnyOf1, baseNestedAnyOf3, baseOneOf, $int];
  void validateOneOf() => dynamite_utils.validateOneOf(_values);
  void validateAnyOf() => dynamite_utils.validateAnyOf(_values);
  static Serializer<$BaseAllOfBaseAnyOf1BaseNestedAnyOf3BaseOneOfInt> get serializer =>
      const _$BaseAllOfBaseAnyOf1BaseNestedAnyOf3BaseOneOfIntSerializer();
  static $BaseAllOfBaseAnyOf1BaseNestedAnyOf3BaseOneOfInt fromJson(Object? json) =>
      jsonSerializers.deserializeWith(serializer, json)!;
  Object? toJson() => jsonSerializers.serializeWith(serializer, this);
}

class _$BaseAllOfBaseAnyOf1BaseNestedAnyOf3BaseOneOfIntSerializer
    implements PrimitiveSerializer<$BaseAllOfBaseAnyOf1BaseNestedAnyOf3BaseOneOfInt> {
  const _$BaseAllOfBaseAnyOf1BaseNestedAnyOf3BaseOneOfIntSerializer();

  @override
  Iterable<Type> get types => const [$BaseAllOfBaseAnyOf1BaseNestedAnyOf3BaseOneOfInt];

  @override
  String get wireName => r'$BaseAllOfBaseAnyOf1BaseNestedAnyOf3BaseOneOfInt';

  @override
  Object serialize(
    Serializers serializers,
    $BaseAllOfBaseAnyOf1BaseNestedAnyOf3BaseOneOfInt object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    dynamic value;
    value = object.baseAllOf;
    if (value != null) {
      return serializers.serialize(value, specifiedType: const FullType(BaseAllOf))!;
    }
    value = object.baseAnyOf1;
    if (value != null) {
      return serializers.serialize(value, specifiedType: const FullType(BaseAnyOf1))!;
    }
    value = object.baseNestedAnyOf3;
    if (value != null) {
      return serializers.serialize(value, specifiedType: const FullType(BaseNestedAnyOf3))!;
    }
    value = object.baseOneOf;
    if (value != null) {
      return serializers.serialize(value, specifiedType: const FullType(BaseOneOf))!;
    }
    value = object.$int;
    if (value != null) {
      return serializers.serialize(value, specifiedType: const FullType(int))!;
    }
// Should not be possible after validation.
    throw StateError('Tried to serialize without any value.');
  }

  @override
  $BaseAllOfBaseAnyOf1BaseNestedAnyOf3BaseOneOfInt deserialize(
    Serializers serializers,
    Object data, {
    FullType specifiedType = FullType.unspecified,
  }) {
    BaseAllOf? baseAllOf;
    try {
      baseAllOf = serializers.deserialize(data, specifiedType: const FullType(BaseAllOf))! as BaseAllOf;
    } catch (_) {}
    BaseAnyOf1? baseAnyOf1;
    try {
      baseAnyOf1 = serializers.deserialize(data, specifiedType: const FullType(BaseAnyOf1))! as BaseAnyOf1;
    } catch (_) {}
    BaseNestedAnyOf3? baseNestedAnyOf3;
    try {
      baseNestedAnyOf3 =
          serializers.deserialize(data, specifiedType: const FullType(BaseNestedAnyOf3))! as BaseNestedAnyOf3;
    } catch (_) {}
    BaseOneOf? baseOneOf;
    try {
      baseOneOf =
          ((serializers.deserialize(data, specifiedType: const FullType(BaseOneOf))! as BaseOneOf)..validateOneOf());
    } catch (_) {}
    int? $int;
    try {
      $int = serializers.deserialize(data, specifiedType: const FullType(int))! as int;
    } catch (_) {}
    return (
      baseAllOf: baseAllOf,
      baseAnyOf1: baseAnyOf1,
      baseNestedAnyOf3: baseNestedAnyOf3,
      baseOneOf: baseOneOf,
      $int: $int
    );
  }
}

typedef $BaseOneOf1Num = ({BaseOneOf1? baseOneOf1, num? $num});

extension $BaseOneOf1NumExtension on $BaseOneOf1Num {
  List<dynamic> get _values => [baseOneOf1, $num];
  void validateOneOf() => dynamite_utils.validateOneOf(_values);
  void validateAnyOf() => dynamite_utils.validateAnyOf(_values);
  static Serializer<$BaseOneOf1Num> get serializer => const _$BaseOneOf1NumSerializer();
  static $BaseOneOf1Num fromJson(Object? json) => jsonSerializers.deserializeWith(serializer, json)!;
  Object? toJson() => jsonSerializers.serializeWith(serializer, this);
}

class _$BaseOneOf1NumSerializer implements PrimitiveSerializer<$BaseOneOf1Num> {
  const _$BaseOneOf1NumSerializer();

  @override
  Iterable<Type> get types => const [$BaseOneOf1Num];

  @override
  String get wireName => r'$BaseOneOf1Num';

  @override
  Object serialize(
    Serializers serializers,
    $BaseOneOf1Num object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    dynamic value;
    value = object.baseOneOf1;
    if (value != null) {
      return serializers.serialize(value, specifiedType: const FullType(BaseOneOf1))!;
    }
    value = object.$num;
    if (value != null) {
      return serializers.serialize(value, specifiedType: const FullType(num))!;
    }
// Should not be possible after validation.
    throw StateError('Tried to serialize without any value.');
  }

  @override
  $BaseOneOf1Num deserialize(
    Serializers serializers,
    Object data, {
    FullType specifiedType = FullType.unspecified,
  }) {
    BaseOneOf1? baseOneOf1;
    try {
      baseOneOf1 = serializers.deserialize(data, specifiedType: const FullType(BaseOneOf1))! as BaseOneOf1;
    } catch (_) {}
    num? $num;
    try {
      $num = serializers.deserialize(data, specifiedType: const FullType(num))! as num;
    } catch (_) {}
    return (baseOneOf1: baseOneOf1, $num: $num);
  }
}

// coverage:ignore-start
@visibleForTesting
final Serializers serializers = (Serializers().toBuilder()
      ..addBuilderFactory(const FullType(BaseAllOf), BaseAllOfBuilder.new)
      ..add(BaseAllOf.serializer)
      ..addBuilderFactory(const FullType(BaseOneOf1), BaseOneOf1Builder.new)
      ..add(BaseOneOf1.serializer)
      ..add($BaseOneOf1DoubleExtension.serializer)
      ..addBuilderFactory(const FullType(BaseAnyOf1), BaseAnyOf1Builder.new)
      ..add(BaseAnyOf1.serializer)
      ..add($BaseAnyOf1IntExtension.serializer)
      ..addBuilderFactory(const FullType(BaseNestedAllOf), BaseNestedAllOfBuilder.new)
      ..add(BaseNestedAllOf.serializer)
      ..addBuilderFactory(const FullType(BaseNestedOneOf3), BaseNestedOneOf3Builder.new)
      ..add(BaseNestedOneOf3.serializer)
      ..add($BaseAllOfBaseAnyOfBaseNestedOneOf3BaseOneOf1DoubleExtension.serializer)
      ..addBuilderFactory(const FullType(BaseNestedAnyOf3), BaseNestedAnyOf3Builder.new)
      ..add(BaseNestedAnyOf3.serializer)
      ..add($BaseAllOfBaseAnyOf1BaseNestedAnyOf3BaseOneOfIntExtension.serializer)
      ..add($BaseOneOf1NumExtension.serializer))
    .build();
@visibleForTesting
final Serializers jsonSerializers = (serializers.toBuilder()
      ..add(DynamiteDoubleSerializer())
      ..addPlugin(StandardJsonPlugin())
      ..addPlugin(const HeaderPlugin())
      ..addPlugin(const ContentStringPlugin()))
    .build();
// coverage:ignore-end
