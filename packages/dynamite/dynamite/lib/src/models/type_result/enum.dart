part of 'type_result.dart';

@immutable
class TypeResultEnum extends TypeResult {
  TypeResultEnum(
    super.className,
    this.subType, {
    super.nullable,
    super.isTypeDef,
  });

  final TypeResult subType;

  @override
  String? get _builderFactory => null;

  @override
  String encode(
    final String object, {
    final bool onlyChildren = false,
    final String? mimeType,
  }) {
    if (subType.name == 'String' || subType.name == 'int') {
      return '$object.name';
    }

    return super.encode(object, mimeType: mimeType);
  }

  @override
  String decode(final String object) => subType.decode(object);

  @override
  bool operator ==(final Object other) =>
      other is TypeResultEnum && other.className == className && other.generics == generics && other.subType == subType;

  @override
  int get hashCode => className.hashCode + generics.hashCode + subType.hashCode;
}
