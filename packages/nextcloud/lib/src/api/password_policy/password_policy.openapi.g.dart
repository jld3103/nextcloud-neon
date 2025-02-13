// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_policy.openapi.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<OCSMeta> _$oCSMetaSerializer = _$OCSMetaSerializer();
Serializer<ApiGenerateResponseApplicationJson_Ocs_Data> _$apiGenerateResponseApplicationJsonOcsDataSerializer =
    _$ApiGenerateResponseApplicationJson_Ocs_DataSerializer();
Serializer<ApiGenerateResponseApplicationJson_Ocs> _$apiGenerateResponseApplicationJsonOcsSerializer =
    _$ApiGenerateResponseApplicationJson_OcsSerializer();
Serializer<ApiGenerateResponseApplicationJson> _$apiGenerateResponseApplicationJsonSerializer =
    _$ApiGenerateResponseApplicationJsonSerializer();
Serializer<ApiValidateRequestApplicationJson> _$apiValidateRequestApplicationJsonSerializer =
    _$ApiValidateRequestApplicationJsonSerializer();
Serializer<ApiValidateResponseApplicationJson_Ocs_Data> _$apiValidateResponseApplicationJsonOcsDataSerializer =
    _$ApiValidateResponseApplicationJson_Ocs_DataSerializer();
Serializer<ApiValidateResponseApplicationJson_Ocs> _$apiValidateResponseApplicationJsonOcsSerializer =
    _$ApiValidateResponseApplicationJson_OcsSerializer();
Serializer<ApiValidateResponseApplicationJson> _$apiValidateResponseApplicationJsonSerializer =
    _$ApiValidateResponseApplicationJsonSerializer();
Serializer<Capabilities_PasswordPolicy_Api> _$capabilitiesPasswordPolicyApiSerializer =
    _$Capabilities_PasswordPolicy_ApiSerializer();
Serializer<Capabilities_PasswordPolicy> _$capabilitiesPasswordPolicySerializer =
    _$Capabilities_PasswordPolicySerializer();
Serializer<Capabilities> _$capabilitiesSerializer = _$CapabilitiesSerializer();

class _$OCSMetaSerializer implements StructuredSerializer<OCSMeta> {
  @override
  final Iterable<Type> types = const [OCSMeta, _$OCSMeta];
  @override
  final String wireName = 'OCSMeta';

  @override
  Iterable<Object?> serialize(Serializers serializers, OCSMeta object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'status',
      serializers.serialize(object.status, specifiedType: const FullType(String)),
      'statuscode',
      serializers.serialize(object.statuscode, specifiedType: const FullType(int)),
    ];
    Object? value;
    value = object.message;
    if (value != null) {
      result
        ..add('message')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.totalitems;
    if (value != null) {
      result
        ..add('totalitems')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.itemsperpage;
    if (value != null) {
      result
        ..add('itemsperpage')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  OCSMeta deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = OCSMetaBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'status':
          result.status = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'statuscode':
          result.statuscode = serializers.deserialize(value, specifiedType: const FullType(int))! as int;
          break;
        case 'message':
          result.message = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'totalitems':
          result.totalitems = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'itemsperpage':
          result.itemsperpage = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$ApiGenerateResponseApplicationJson_Ocs_DataSerializer
    implements StructuredSerializer<ApiGenerateResponseApplicationJson_Ocs_Data> {
  @override
  final Iterable<Type> types = const [
    ApiGenerateResponseApplicationJson_Ocs_Data,
    _$ApiGenerateResponseApplicationJson_Ocs_Data
  ];
  @override
  final String wireName = 'ApiGenerateResponseApplicationJson_Ocs_Data';

  @override
  Iterable<Object?> serialize(Serializers serializers, ApiGenerateResponseApplicationJson_Ocs_Data object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'password',
      serializers.serialize(object.password, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  ApiGenerateResponseApplicationJson_Ocs_Data deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ApiGenerateResponseApplicationJson_Ocs_DataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'password':
          result.password = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ApiGenerateResponseApplicationJson_OcsSerializer
    implements StructuredSerializer<ApiGenerateResponseApplicationJson_Ocs> {
  @override
  final Iterable<Type> types = const [ApiGenerateResponseApplicationJson_Ocs, _$ApiGenerateResponseApplicationJson_Ocs];
  @override
  final String wireName = 'ApiGenerateResponseApplicationJson_Ocs';

  @override
  Iterable<Object?> serialize(Serializers serializers, ApiGenerateResponseApplicationJson_Ocs object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'meta',
      serializers.serialize(object.meta, specifiedType: const FullType(OCSMeta)),
      'data',
      serializers.serialize(object.data, specifiedType: const FullType(ApiGenerateResponseApplicationJson_Ocs_Data)),
    ];

    return result;
  }

  @override
  ApiGenerateResponseApplicationJson_Ocs deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ApiGenerateResponseApplicationJson_OcsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'meta':
          result.meta.replace(serializers.deserialize(value, specifiedType: const FullType(OCSMeta))! as OCSMeta);
          break;
        case 'data':
          result.data.replace(serializers.deserialize(value,
                  specifiedType: const FullType(ApiGenerateResponseApplicationJson_Ocs_Data))!
              as ApiGenerateResponseApplicationJson_Ocs_Data);
          break;
      }
    }

    return result.build();
  }
}

class _$ApiGenerateResponseApplicationJsonSerializer
    implements StructuredSerializer<ApiGenerateResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [ApiGenerateResponseApplicationJson, _$ApiGenerateResponseApplicationJson];
  @override
  final String wireName = 'ApiGenerateResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, ApiGenerateResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'ocs',
      serializers.serialize(object.ocs, specifiedType: const FullType(ApiGenerateResponseApplicationJson_Ocs)),
    ];

    return result;
  }

  @override
  ApiGenerateResponseApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ApiGenerateResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'ocs':
          result.ocs.replace(
              serializers.deserialize(value, specifiedType: const FullType(ApiGenerateResponseApplicationJson_Ocs))!
                  as ApiGenerateResponseApplicationJson_Ocs);
          break;
      }
    }

    return result.build();
  }
}

class _$ApiValidateRequestApplicationJsonSerializer implements StructuredSerializer<ApiValidateRequestApplicationJson> {
  @override
  final Iterable<Type> types = const [ApiValidateRequestApplicationJson, _$ApiValidateRequestApplicationJson];
  @override
  final String wireName = 'ApiValidateRequestApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, ApiValidateRequestApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'password',
      serializers.serialize(object.password, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  ApiValidateRequestApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ApiValidateRequestApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'password':
          result.password = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ApiValidateResponseApplicationJson_Ocs_DataSerializer
    implements StructuredSerializer<ApiValidateResponseApplicationJson_Ocs_Data> {
  @override
  final Iterable<Type> types = const [
    ApiValidateResponseApplicationJson_Ocs_Data,
    _$ApiValidateResponseApplicationJson_Ocs_Data
  ];
  @override
  final String wireName = 'ApiValidateResponseApplicationJson_Ocs_Data';

  @override
  Iterable<Object?> serialize(Serializers serializers, ApiValidateResponseApplicationJson_Ocs_Data object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'passed',
      serializers.serialize(object.passed, specifiedType: const FullType(bool)),
    ];
    Object? value;
    value = object.reason;
    if (value != null) {
      result
        ..add('reason')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  ApiValidateResponseApplicationJson_Ocs_Data deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ApiValidateResponseApplicationJson_Ocs_DataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'passed':
          result.passed = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
        case 'reason':
          result.reason = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$ApiValidateResponseApplicationJson_OcsSerializer
    implements StructuredSerializer<ApiValidateResponseApplicationJson_Ocs> {
  @override
  final Iterable<Type> types = const [ApiValidateResponseApplicationJson_Ocs, _$ApiValidateResponseApplicationJson_Ocs];
  @override
  final String wireName = 'ApiValidateResponseApplicationJson_Ocs';

  @override
  Iterable<Object?> serialize(Serializers serializers, ApiValidateResponseApplicationJson_Ocs object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'meta',
      serializers.serialize(object.meta, specifiedType: const FullType(OCSMeta)),
      'data',
      serializers.serialize(object.data, specifiedType: const FullType(ApiValidateResponseApplicationJson_Ocs_Data)),
    ];

    return result;
  }

  @override
  ApiValidateResponseApplicationJson_Ocs deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ApiValidateResponseApplicationJson_OcsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'meta':
          result.meta.replace(serializers.deserialize(value, specifiedType: const FullType(OCSMeta))! as OCSMeta);
          break;
        case 'data':
          result.data.replace(serializers.deserialize(value,
                  specifiedType: const FullType(ApiValidateResponseApplicationJson_Ocs_Data))!
              as ApiValidateResponseApplicationJson_Ocs_Data);
          break;
      }
    }

    return result.build();
  }
}

class _$ApiValidateResponseApplicationJsonSerializer
    implements StructuredSerializer<ApiValidateResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [ApiValidateResponseApplicationJson, _$ApiValidateResponseApplicationJson];
  @override
  final String wireName = 'ApiValidateResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, ApiValidateResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'ocs',
      serializers.serialize(object.ocs, specifiedType: const FullType(ApiValidateResponseApplicationJson_Ocs)),
    ];

    return result;
  }

  @override
  ApiValidateResponseApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ApiValidateResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'ocs':
          result.ocs.replace(
              serializers.deserialize(value, specifiedType: const FullType(ApiValidateResponseApplicationJson_Ocs))!
                  as ApiValidateResponseApplicationJson_Ocs);
          break;
      }
    }

    return result.build();
  }
}

class _$Capabilities_PasswordPolicy_ApiSerializer implements StructuredSerializer<Capabilities_PasswordPolicy_Api> {
  @override
  final Iterable<Type> types = const [Capabilities_PasswordPolicy_Api, _$Capabilities_PasswordPolicy_Api];
  @override
  final String wireName = 'Capabilities_PasswordPolicy_Api';

  @override
  Iterable<Object?> serialize(Serializers serializers, Capabilities_PasswordPolicy_Api object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'generate',
      serializers.serialize(object.generate, specifiedType: const FullType(String)),
      'validate',
      serializers.serialize(object.validate, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  Capabilities_PasswordPolicy_Api deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = Capabilities_PasswordPolicy_ApiBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'generate':
          result.generate = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'validate':
          result.validate = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Capabilities_PasswordPolicySerializer implements StructuredSerializer<Capabilities_PasswordPolicy> {
  @override
  final Iterable<Type> types = const [Capabilities_PasswordPolicy, _$Capabilities_PasswordPolicy];
  @override
  final String wireName = 'Capabilities_PasswordPolicy';

  @override
  Iterable<Object?> serialize(Serializers serializers, Capabilities_PasswordPolicy object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'minLength',
      serializers.serialize(object.minLength, specifiedType: const FullType(int)),
      'enforceNonCommonPassword',
      serializers.serialize(object.enforceNonCommonPassword, specifiedType: const FullType(bool)),
      'enforceNumericCharacters',
      serializers.serialize(object.enforceNumericCharacters, specifiedType: const FullType(bool)),
      'enforceSpecialCharacters',
      serializers.serialize(object.enforceSpecialCharacters, specifiedType: const FullType(bool)),
      'enforceUpperLowerCase',
      serializers.serialize(object.enforceUpperLowerCase, specifiedType: const FullType(bool)),
      'api',
      serializers.serialize(object.api, specifiedType: const FullType(Capabilities_PasswordPolicy_Api)),
    ];

    return result;
  }

  @override
  Capabilities_PasswordPolicy deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = Capabilities_PasswordPolicyBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'minLength':
          result.minLength = serializers.deserialize(value, specifiedType: const FullType(int))! as int;
          break;
        case 'enforceNonCommonPassword':
          result.enforceNonCommonPassword =
              serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
        case 'enforceNumericCharacters':
          result.enforceNumericCharacters =
              serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
        case 'enforceSpecialCharacters':
          result.enforceSpecialCharacters =
              serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
        case 'enforceUpperLowerCase':
          result.enforceUpperLowerCase = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
        case 'api':
          result.api.replace(serializers.deserialize(value,
              specifiedType: const FullType(Capabilities_PasswordPolicy_Api))! as Capabilities_PasswordPolicy_Api);
          break;
      }
    }

    return result.build();
  }
}

class _$CapabilitiesSerializer implements StructuredSerializer<Capabilities> {
  @override
  final Iterable<Type> types = const [Capabilities, _$Capabilities];
  @override
  final String wireName = 'Capabilities';

  @override
  Iterable<Object?> serialize(Serializers serializers, Capabilities object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'password_policy',
      serializers.serialize(object.passwordPolicy, specifiedType: const FullType(Capabilities_PasswordPolicy)),
    ];

    return result;
  }

  @override
  Capabilities deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = CapabilitiesBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'password_policy':
          result.passwordPolicy.replace(serializers.deserialize(value,
              specifiedType: const FullType(Capabilities_PasswordPolicy))! as Capabilities_PasswordPolicy);
          break;
      }
    }

    return result.build();
  }
}

abstract mixin class $OCSMetaInterfaceBuilder {
  void replace($OCSMetaInterface other);
  void update(void Function($OCSMetaInterfaceBuilder) updates);
  String? get status;
  set status(String? status);

  int? get statuscode;
  set statuscode(int? statuscode);

  String? get message;
  set message(String? message);

  String? get totalitems;
  set totalitems(String? totalitems);

  String? get itemsperpage;
  set itemsperpage(String? itemsperpage);
}

class _$OCSMeta extends OCSMeta {
  @override
  final String status;
  @override
  final int statuscode;
  @override
  final String? message;
  @override
  final String? totalitems;
  @override
  final String? itemsperpage;

  factory _$OCSMeta([void Function(OCSMetaBuilder)? updates]) => (OCSMetaBuilder()..update(updates))._build();

  _$OCSMeta._({required this.status, required this.statuscode, this.message, this.totalitems, this.itemsperpage})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(status, r'OCSMeta', 'status');
    BuiltValueNullFieldError.checkNotNull(statuscode, r'OCSMeta', 'statuscode');
  }

  @override
  OCSMeta rebuild(void Function(OCSMetaBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  OCSMetaBuilder toBuilder() => OCSMetaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OCSMeta &&
        status == other.status &&
        statuscode == other.statuscode &&
        message == other.message &&
        totalitems == other.totalitems &&
        itemsperpage == other.itemsperpage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, statuscode.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, totalitems.hashCode);
    _$hash = $jc(_$hash, itemsperpage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OCSMeta')
          ..add('status', status)
          ..add('statuscode', statuscode)
          ..add('message', message)
          ..add('totalitems', totalitems)
          ..add('itemsperpage', itemsperpage))
        .toString();
  }
}

class OCSMetaBuilder implements Builder<OCSMeta, OCSMetaBuilder>, $OCSMetaInterfaceBuilder {
  _$OCSMeta? _$v;

  String? _status;
  String? get status => _$this._status;
  set status(covariant String? status) => _$this._status = status;

  int? _statuscode;
  int? get statuscode => _$this._statuscode;
  set statuscode(covariant int? statuscode) => _$this._statuscode = statuscode;

  String? _message;
  String? get message => _$this._message;
  set message(covariant String? message) => _$this._message = message;

  String? _totalitems;
  String? get totalitems => _$this._totalitems;
  set totalitems(covariant String? totalitems) => _$this._totalitems = totalitems;

  String? _itemsperpage;
  String? get itemsperpage => _$this._itemsperpage;
  set itemsperpage(covariant String? itemsperpage) => _$this._itemsperpage = itemsperpage;

  OCSMetaBuilder() {
    OCSMeta._defaults(this);
  }

  OCSMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _statuscode = $v.statuscode;
      _message = $v.message;
      _totalitems = $v.totalitems;
      _itemsperpage = $v.itemsperpage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant OCSMeta other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OCSMeta;
  }

  @override
  void update(void Function(OCSMetaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OCSMeta build() => _build();

  _$OCSMeta _build() {
    OCSMeta._validate(this);
    final _$result = _$v ??
        _$OCSMeta._(
          status: BuiltValueNullFieldError.checkNotNull(status, r'OCSMeta', 'status'),
          statuscode: BuiltValueNullFieldError.checkNotNull(statuscode, r'OCSMeta', 'statuscode'),
          message: message,
          totalitems: totalitems,
          itemsperpage: itemsperpage,
        );
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $ApiGenerateResponseApplicationJson_Ocs_DataInterfaceBuilder {
  void replace($ApiGenerateResponseApplicationJson_Ocs_DataInterface other);
  void update(void Function($ApiGenerateResponseApplicationJson_Ocs_DataInterfaceBuilder) updates);
  String? get password;
  set password(String? password);
}

class _$ApiGenerateResponseApplicationJson_Ocs_Data extends ApiGenerateResponseApplicationJson_Ocs_Data {
  @override
  final String password;

  factory _$ApiGenerateResponseApplicationJson_Ocs_Data(
          [void Function(ApiGenerateResponseApplicationJson_Ocs_DataBuilder)? updates]) =>
      (ApiGenerateResponseApplicationJson_Ocs_DataBuilder()..update(updates))._build();

  _$ApiGenerateResponseApplicationJson_Ocs_Data._({required this.password}) : super._() {
    BuiltValueNullFieldError.checkNotNull(password, r'ApiGenerateResponseApplicationJson_Ocs_Data', 'password');
  }

  @override
  ApiGenerateResponseApplicationJson_Ocs_Data rebuild(
          void Function(ApiGenerateResponseApplicationJson_Ocs_DataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiGenerateResponseApplicationJson_Ocs_DataBuilder toBuilder() =>
      ApiGenerateResponseApplicationJson_Ocs_DataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiGenerateResponseApplicationJson_Ocs_Data && password == other.password;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiGenerateResponseApplicationJson_Ocs_Data')..add('password', password))
        .toString();
  }
}

class ApiGenerateResponseApplicationJson_Ocs_DataBuilder
    implements
        Builder<ApiGenerateResponseApplicationJson_Ocs_Data, ApiGenerateResponseApplicationJson_Ocs_DataBuilder>,
        $ApiGenerateResponseApplicationJson_Ocs_DataInterfaceBuilder {
  _$ApiGenerateResponseApplicationJson_Ocs_Data? _$v;

  String? _password;
  String? get password => _$this._password;
  set password(covariant String? password) => _$this._password = password;

  ApiGenerateResponseApplicationJson_Ocs_DataBuilder() {
    ApiGenerateResponseApplicationJson_Ocs_Data._defaults(this);
  }

  ApiGenerateResponseApplicationJson_Ocs_DataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _password = $v.password;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant ApiGenerateResponseApplicationJson_Ocs_Data other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ApiGenerateResponseApplicationJson_Ocs_Data;
  }

  @override
  void update(void Function(ApiGenerateResponseApplicationJson_Ocs_DataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiGenerateResponseApplicationJson_Ocs_Data build() => _build();

  _$ApiGenerateResponseApplicationJson_Ocs_Data _build() {
    ApiGenerateResponseApplicationJson_Ocs_Data._validate(this);
    final _$result = _$v ??
        _$ApiGenerateResponseApplicationJson_Ocs_Data._(
          password: BuiltValueNullFieldError.checkNotNull(
              password, r'ApiGenerateResponseApplicationJson_Ocs_Data', 'password'),
        );
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $ApiGenerateResponseApplicationJson_OcsInterfaceBuilder {
  void replace($ApiGenerateResponseApplicationJson_OcsInterface other);
  void update(void Function($ApiGenerateResponseApplicationJson_OcsInterfaceBuilder) updates);
  OCSMetaBuilder get meta;
  set meta(OCSMetaBuilder? meta);

  ApiGenerateResponseApplicationJson_Ocs_DataBuilder get data;
  set data(ApiGenerateResponseApplicationJson_Ocs_DataBuilder? data);
}

class _$ApiGenerateResponseApplicationJson_Ocs extends ApiGenerateResponseApplicationJson_Ocs {
  @override
  final OCSMeta meta;
  @override
  final ApiGenerateResponseApplicationJson_Ocs_Data data;

  factory _$ApiGenerateResponseApplicationJson_Ocs(
          [void Function(ApiGenerateResponseApplicationJson_OcsBuilder)? updates]) =>
      (ApiGenerateResponseApplicationJson_OcsBuilder()..update(updates))._build();

  _$ApiGenerateResponseApplicationJson_Ocs._({required this.meta, required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(meta, r'ApiGenerateResponseApplicationJson_Ocs', 'meta');
    BuiltValueNullFieldError.checkNotNull(data, r'ApiGenerateResponseApplicationJson_Ocs', 'data');
  }

  @override
  ApiGenerateResponseApplicationJson_Ocs rebuild(
          void Function(ApiGenerateResponseApplicationJson_OcsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiGenerateResponseApplicationJson_OcsBuilder toBuilder() =>
      ApiGenerateResponseApplicationJson_OcsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiGenerateResponseApplicationJson_Ocs && meta == other.meta && data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, meta.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiGenerateResponseApplicationJson_Ocs')
          ..add('meta', meta)
          ..add('data', data))
        .toString();
  }
}

class ApiGenerateResponseApplicationJson_OcsBuilder
    implements
        Builder<ApiGenerateResponseApplicationJson_Ocs, ApiGenerateResponseApplicationJson_OcsBuilder>,
        $ApiGenerateResponseApplicationJson_OcsInterfaceBuilder {
  _$ApiGenerateResponseApplicationJson_Ocs? _$v;

  OCSMetaBuilder? _meta;
  OCSMetaBuilder get meta => _$this._meta ??= OCSMetaBuilder();
  set meta(covariant OCSMetaBuilder? meta) => _$this._meta = meta;

  ApiGenerateResponseApplicationJson_Ocs_DataBuilder? _data;
  ApiGenerateResponseApplicationJson_Ocs_DataBuilder get data =>
      _$this._data ??= ApiGenerateResponseApplicationJson_Ocs_DataBuilder();
  set data(covariant ApiGenerateResponseApplicationJson_Ocs_DataBuilder? data) => _$this._data = data;

  ApiGenerateResponseApplicationJson_OcsBuilder() {
    ApiGenerateResponseApplicationJson_Ocs._defaults(this);
  }

  ApiGenerateResponseApplicationJson_OcsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _meta = $v.meta.toBuilder();
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant ApiGenerateResponseApplicationJson_Ocs other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ApiGenerateResponseApplicationJson_Ocs;
  }

  @override
  void update(void Function(ApiGenerateResponseApplicationJson_OcsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiGenerateResponseApplicationJson_Ocs build() => _build();

  _$ApiGenerateResponseApplicationJson_Ocs _build() {
    ApiGenerateResponseApplicationJson_Ocs._validate(this);
    _$ApiGenerateResponseApplicationJson_Ocs _$result;
    try {
      _$result = _$v ??
          _$ApiGenerateResponseApplicationJson_Ocs._(
            meta: meta.build(),
            data: data.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'ApiGenerateResponseApplicationJson_Ocs', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $ApiGenerateResponseApplicationJsonInterfaceBuilder {
  void replace($ApiGenerateResponseApplicationJsonInterface other);
  void update(void Function($ApiGenerateResponseApplicationJsonInterfaceBuilder) updates);
  ApiGenerateResponseApplicationJson_OcsBuilder get ocs;
  set ocs(ApiGenerateResponseApplicationJson_OcsBuilder? ocs);
}

class _$ApiGenerateResponseApplicationJson extends ApiGenerateResponseApplicationJson {
  @override
  final ApiGenerateResponseApplicationJson_Ocs ocs;

  factory _$ApiGenerateResponseApplicationJson([void Function(ApiGenerateResponseApplicationJsonBuilder)? updates]) =>
      (ApiGenerateResponseApplicationJsonBuilder()..update(updates))._build();

  _$ApiGenerateResponseApplicationJson._({required this.ocs}) : super._() {
    BuiltValueNullFieldError.checkNotNull(ocs, r'ApiGenerateResponseApplicationJson', 'ocs');
  }

  @override
  ApiGenerateResponseApplicationJson rebuild(void Function(ApiGenerateResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiGenerateResponseApplicationJsonBuilder toBuilder() => ApiGenerateResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiGenerateResponseApplicationJson && ocs == other.ocs;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ocs.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiGenerateResponseApplicationJson')..add('ocs', ocs)).toString();
  }
}

class ApiGenerateResponseApplicationJsonBuilder
    implements
        Builder<ApiGenerateResponseApplicationJson, ApiGenerateResponseApplicationJsonBuilder>,
        $ApiGenerateResponseApplicationJsonInterfaceBuilder {
  _$ApiGenerateResponseApplicationJson? _$v;

  ApiGenerateResponseApplicationJson_OcsBuilder? _ocs;
  ApiGenerateResponseApplicationJson_OcsBuilder get ocs =>
      _$this._ocs ??= ApiGenerateResponseApplicationJson_OcsBuilder();
  set ocs(covariant ApiGenerateResponseApplicationJson_OcsBuilder? ocs) => _$this._ocs = ocs;

  ApiGenerateResponseApplicationJsonBuilder() {
    ApiGenerateResponseApplicationJson._defaults(this);
  }

  ApiGenerateResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ocs = $v.ocs.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant ApiGenerateResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ApiGenerateResponseApplicationJson;
  }

  @override
  void update(void Function(ApiGenerateResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiGenerateResponseApplicationJson build() => _build();

  _$ApiGenerateResponseApplicationJson _build() {
    ApiGenerateResponseApplicationJson._validate(this);
    _$ApiGenerateResponseApplicationJson _$result;
    try {
      _$result = _$v ??
          _$ApiGenerateResponseApplicationJson._(
            ocs: ocs.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ocs';
        ocs.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'ApiGenerateResponseApplicationJson', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $ApiValidateRequestApplicationJsonInterfaceBuilder {
  void replace($ApiValidateRequestApplicationJsonInterface other);
  void update(void Function($ApiValidateRequestApplicationJsonInterfaceBuilder) updates);
  String? get password;
  set password(String? password);
}

class _$ApiValidateRequestApplicationJson extends ApiValidateRequestApplicationJson {
  @override
  final String password;

  factory _$ApiValidateRequestApplicationJson([void Function(ApiValidateRequestApplicationJsonBuilder)? updates]) =>
      (ApiValidateRequestApplicationJsonBuilder()..update(updates))._build();

  _$ApiValidateRequestApplicationJson._({required this.password}) : super._() {
    BuiltValueNullFieldError.checkNotNull(password, r'ApiValidateRequestApplicationJson', 'password');
  }

  @override
  ApiValidateRequestApplicationJson rebuild(void Function(ApiValidateRequestApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiValidateRequestApplicationJsonBuilder toBuilder() => ApiValidateRequestApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiValidateRequestApplicationJson && password == other.password;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiValidateRequestApplicationJson')..add('password', password)).toString();
  }
}

class ApiValidateRequestApplicationJsonBuilder
    implements
        Builder<ApiValidateRequestApplicationJson, ApiValidateRequestApplicationJsonBuilder>,
        $ApiValidateRequestApplicationJsonInterfaceBuilder {
  _$ApiValidateRequestApplicationJson? _$v;

  String? _password;
  String? get password => _$this._password;
  set password(covariant String? password) => _$this._password = password;

  ApiValidateRequestApplicationJsonBuilder() {
    ApiValidateRequestApplicationJson._defaults(this);
  }

  ApiValidateRequestApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _password = $v.password;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant ApiValidateRequestApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ApiValidateRequestApplicationJson;
  }

  @override
  void update(void Function(ApiValidateRequestApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiValidateRequestApplicationJson build() => _build();

  _$ApiValidateRequestApplicationJson _build() {
    ApiValidateRequestApplicationJson._validate(this);
    final _$result = _$v ??
        _$ApiValidateRequestApplicationJson._(
          password: BuiltValueNullFieldError.checkNotNull(password, r'ApiValidateRequestApplicationJson', 'password'),
        );
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $ApiValidateResponseApplicationJson_Ocs_DataInterfaceBuilder {
  void replace($ApiValidateResponseApplicationJson_Ocs_DataInterface other);
  void update(void Function($ApiValidateResponseApplicationJson_Ocs_DataInterfaceBuilder) updates);
  bool? get passed;
  set passed(bool? passed);

  String? get reason;
  set reason(String? reason);
}

class _$ApiValidateResponseApplicationJson_Ocs_Data extends ApiValidateResponseApplicationJson_Ocs_Data {
  @override
  final bool passed;
  @override
  final String? reason;

  factory _$ApiValidateResponseApplicationJson_Ocs_Data(
          [void Function(ApiValidateResponseApplicationJson_Ocs_DataBuilder)? updates]) =>
      (ApiValidateResponseApplicationJson_Ocs_DataBuilder()..update(updates))._build();

  _$ApiValidateResponseApplicationJson_Ocs_Data._({required this.passed, this.reason}) : super._() {
    BuiltValueNullFieldError.checkNotNull(passed, r'ApiValidateResponseApplicationJson_Ocs_Data', 'passed');
  }

  @override
  ApiValidateResponseApplicationJson_Ocs_Data rebuild(
          void Function(ApiValidateResponseApplicationJson_Ocs_DataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiValidateResponseApplicationJson_Ocs_DataBuilder toBuilder() =>
      ApiValidateResponseApplicationJson_Ocs_DataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiValidateResponseApplicationJson_Ocs_Data && passed == other.passed && reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, passed.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiValidateResponseApplicationJson_Ocs_Data')
          ..add('passed', passed)
          ..add('reason', reason))
        .toString();
  }
}

class ApiValidateResponseApplicationJson_Ocs_DataBuilder
    implements
        Builder<ApiValidateResponseApplicationJson_Ocs_Data, ApiValidateResponseApplicationJson_Ocs_DataBuilder>,
        $ApiValidateResponseApplicationJson_Ocs_DataInterfaceBuilder {
  _$ApiValidateResponseApplicationJson_Ocs_Data? _$v;

  bool? _passed;
  bool? get passed => _$this._passed;
  set passed(covariant bool? passed) => _$this._passed = passed;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(covariant String? reason) => _$this._reason = reason;

  ApiValidateResponseApplicationJson_Ocs_DataBuilder() {
    ApiValidateResponseApplicationJson_Ocs_Data._defaults(this);
  }

  ApiValidateResponseApplicationJson_Ocs_DataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _passed = $v.passed;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant ApiValidateResponseApplicationJson_Ocs_Data other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ApiValidateResponseApplicationJson_Ocs_Data;
  }

  @override
  void update(void Function(ApiValidateResponseApplicationJson_Ocs_DataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiValidateResponseApplicationJson_Ocs_Data build() => _build();

  _$ApiValidateResponseApplicationJson_Ocs_Data _build() {
    ApiValidateResponseApplicationJson_Ocs_Data._validate(this);
    final _$result = _$v ??
        _$ApiValidateResponseApplicationJson_Ocs_Data._(
          passed:
              BuiltValueNullFieldError.checkNotNull(passed, r'ApiValidateResponseApplicationJson_Ocs_Data', 'passed'),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $ApiValidateResponseApplicationJson_OcsInterfaceBuilder {
  void replace($ApiValidateResponseApplicationJson_OcsInterface other);
  void update(void Function($ApiValidateResponseApplicationJson_OcsInterfaceBuilder) updates);
  OCSMetaBuilder get meta;
  set meta(OCSMetaBuilder? meta);

  ApiValidateResponseApplicationJson_Ocs_DataBuilder get data;
  set data(ApiValidateResponseApplicationJson_Ocs_DataBuilder? data);
}

class _$ApiValidateResponseApplicationJson_Ocs extends ApiValidateResponseApplicationJson_Ocs {
  @override
  final OCSMeta meta;
  @override
  final ApiValidateResponseApplicationJson_Ocs_Data data;

  factory _$ApiValidateResponseApplicationJson_Ocs(
          [void Function(ApiValidateResponseApplicationJson_OcsBuilder)? updates]) =>
      (ApiValidateResponseApplicationJson_OcsBuilder()..update(updates))._build();

  _$ApiValidateResponseApplicationJson_Ocs._({required this.meta, required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(meta, r'ApiValidateResponseApplicationJson_Ocs', 'meta');
    BuiltValueNullFieldError.checkNotNull(data, r'ApiValidateResponseApplicationJson_Ocs', 'data');
  }

  @override
  ApiValidateResponseApplicationJson_Ocs rebuild(
          void Function(ApiValidateResponseApplicationJson_OcsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiValidateResponseApplicationJson_OcsBuilder toBuilder() =>
      ApiValidateResponseApplicationJson_OcsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiValidateResponseApplicationJson_Ocs && meta == other.meta && data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, meta.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiValidateResponseApplicationJson_Ocs')
          ..add('meta', meta)
          ..add('data', data))
        .toString();
  }
}

class ApiValidateResponseApplicationJson_OcsBuilder
    implements
        Builder<ApiValidateResponseApplicationJson_Ocs, ApiValidateResponseApplicationJson_OcsBuilder>,
        $ApiValidateResponseApplicationJson_OcsInterfaceBuilder {
  _$ApiValidateResponseApplicationJson_Ocs? _$v;

  OCSMetaBuilder? _meta;
  OCSMetaBuilder get meta => _$this._meta ??= OCSMetaBuilder();
  set meta(covariant OCSMetaBuilder? meta) => _$this._meta = meta;

  ApiValidateResponseApplicationJson_Ocs_DataBuilder? _data;
  ApiValidateResponseApplicationJson_Ocs_DataBuilder get data =>
      _$this._data ??= ApiValidateResponseApplicationJson_Ocs_DataBuilder();
  set data(covariant ApiValidateResponseApplicationJson_Ocs_DataBuilder? data) => _$this._data = data;

  ApiValidateResponseApplicationJson_OcsBuilder() {
    ApiValidateResponseApplicationJson_Ocs._defaults(this);
  }

  ApiValidateResponseApplicationJson_OcsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _meta = $v.meta.toBuilder();
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant ApiValidateResponseApplicationJson_Ocs other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ApiValidateResponseApplicationJson_Ocs;
  }

  @override
  void update(void Function(ApiValidateResponseApplicationJson_OcsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiValidateResponseApplicationJson_Ocs build() => _build();

  _$ApiValidateResponseApplicationJson_Ocs _build() {
    ApiValidateResponseApplicationJson_Ocs._validate(this);
    _$ApiValidateResponseApplicationJson_Ocs _$result;
    try {
      _$result = _$v ??
          _$ApiValidateResponseApplicationJson_Ocs._(
            meta: meta.build(),
            data: data.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'ApiValidateResponseApplicationJson_Ocs', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $ApiValidateResponseApplicationJsonInterfaceBuilder {
  void replace($ApiValidateResponseApplicationJsonInterface other);
  void update(void Function($ApiValidateResponseApplicationJsonInterfaceBuilder) updates);
  ApiValidateResponseApplicationJson_OcsBuilder get ocs;
  set ocs(ApiValidateResponseApplicationJson_OcsBuilder? ocs);
}

class _$ApiValidateResponseApplicationJson extends ApiValidateResponseApplicationJson {
  @override
  final ApiValidateResponseApplicationJson_Ocs ocs;

  factory _$ApiValidateResponseApplicationJson([void Function(ApiValidateResponseApplicationJsonBuilder)? updates]) =>
      (ApiValidateResponseApplicationJsonBuilder()..update(updates))._build();

  _$ApiValidateResponseApplicationJson._({required this.ocs}) : super._() {
    BuiltValueNullFieldError.checkNotNull(ocs, r'ApiValidateResponseApplicationJson', 'ocs');
  }

  @override
  ApiValidateResponseApplicationJson rebuild(void Function(ApiValidateResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiValidateResponseApplicationJsonBuilder toBuilder() => ApiValidateResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiValidateResponseApplicationJson && ocs == other.ocs;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ocs.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiValidateResponseApplicationJson')..add('ocs', ocs)).toString();
  }
}

class ApiValidateResponseApplicationJsonBuilder
    implements
        Builder<ApiValidateResponseApplicationJson, ApiValidateResponseApplicationJsonBuilder>,
        $ApiValidateResponseApplicationJsonInterfaceBuilder {
  _$ApiValidateResponseApplicationJson? _$v;

  ApiValidateResponseApplicationJson_OcsBuilder? _ocs;
  ApiValidateResponseApplicationJson_OcsBuilder get ocs =>
      _$this._ocs ??= ApiValidateResponseApplicationJson_OcsBuilder();
  set ocs(covariant ApiValidateResponseApplicationJson_OcsBuilder? ocs) => _$this._ocs = ocs;

  ApiValidateResponseApplicationJsonBuilder() {
    ApiValidateResponseApplicationJson._defaults(this);
  }

  ApiValidateResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ocs = $v.ocs.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant ApiValidateResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ApiValidateResponseApplicationJson;
  }

  @override
  void update(void Function(ApiValidateResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiValidateResponseApplicationJson build() => _build();

  _$ApiValidateResponseApplicationJson _build() {
    ApiValidateResponseApplicationJson._validate(this);
    _$ApiValidateResponseApplicationJson _$result;
    try {
      _$result = _$v ??
          _$ApiValidateResponseApplicationJson._(
            ocs: ocs.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ocs';
        ocs.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'ApiValidateResponseApplicationJson', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $Capabilities_PasswordPolicy_ApiInterfaceBuilder {
  void replace($Capabilities_PasswordPolicy_ApiInterface other);
  void update(void Function($Capabilities_PasswordPolicy_ApiInterfaceBuilder) updates);
  String? get generate;
  set generate(String? generate);

  String? get validate;
  set validate(String? validate);
}

class _$Capabilities_PasswordPolicy_Api extends Capabilities_PasswordPolicy_Api {
  @override
  final String generate;
  @override
  final String validate;

  factory _$Capabilities_PasswordPolicy_Api([void Function(Capabilities_PasswordPolicy_ApiBuilder)? updates]) =>
      (Capabilities_PasswordPolicy_ApiBuilder()..update(updates))._build();

  _$Capabilities_PasswordPolicy_Api._({required this.generate, required this.validate}) : super._() {
    BuiltValueNullFieldError.checkNotNull(generate, r'Capabilities_PasswordPolicy_Api', 'generate');
    BuiltValueNullFieldError.checkNotNull(validate, r'Capabilities_PasswordPolicy_Api', 'validate');
  }

  @override
  Capabilities_PasswordPolicy_Api rebuild(void Function(Capabilities_PasswordPolicy_ApiBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  Capabilities_PasswordPolicy_ApiBuilder toBuilder() => Capabilities_PasswordPolicy_ApiBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Capabilities_PasswordPolicy_Api && generate == other.generate && validate == other.validate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, generate.hashCode);
    _$hash = $jc(_$hash, validate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Capabilities_PasswordPolicy_Api')
          ..add('generate', generate)
          ..add('validate', validate))
        .toString();
  }
}

class Capabilities_PasswordPolicy_ApiBuilder
    implements
        Builder<Capabilities_PasswordPolicy_Api, Capabilities_PasswordPolicy_ApiBuilder>,
        $Capabilities_PasswordPolicy_ApiInterfaceBuilder {
  _$Capabilities_PasswordPolicy_Api? _$v;

  String? _generate;
  String? get generate => _$this._generate;
  set generate(covariant String? generate) => _$this._generate = generate;

  String? _validate;
  String? get validate => _$this._validate;
  set validate(covariant String? validate) => _$this._validate = validate;

  Capabilities_PasswordPolicy_ApiBuilder() {
    Capabilities_PasswordPolicy_Api._defaults(this);
  }

  Capabilities_PasswordPolicy_ApiBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _generate = $v.generate;
      _validate = $v.validate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Capabilities_PasswordPolicy_Api other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Capabilities_PasswordPolicy_Api;
  }

  @override
  void update(void Function(Capabilities_PasswordPolicy_ApiBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Capabilities_PasswordPolicy_Api build() => _build();

  _$Capabilities_PasswordPolicy_Api _build() {
    Capabilities_PasswordPolicy_Api._validate(this);
    final _$result = _$v ??
        _$Capabilities_PasswordPolicy_Api._(
          generate: BuiltValueNullFieldError.checkNotNull(generate, r'Capabilities_PasswordPolicy_Api', 'generate'),
          validate: BuiltValueNullFieldError.checkNotNull(validate, r'Capabilities_PasswordPolicy_Api', 'validate'),
        );
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $Capabilities_PasswordPolicyInterfaceBuilder {
  void replace($Capabilities_PasswordPolicyInterface other);
  void update(void Function($Capabilities_PasswordPolicyInterfaceBuilder) updates);
  int? get minLength;
  set minLength(int? minLength);

  bool? get enforceNonCommonPassword;
  set enforceNonCommonPassword(bool? enforceNonCommonPassword);

  bool? get enforceNumericCharacters;
  set enforceNumericCharacters(bool? enforceNumericCharacters);

  bool? get enforceSpecialCharacters;
  set enforceSpecialCharacters(bool? enforceSpecialCharacters);

  bool? get enforceUpperLowerCase;
  set enforceUpperLowerCase(bool? enforceUpperLowerCase);

  Capabilities_PasswordPolicy_ApiBuilder get api;
  set api(Capabilities_PasswordPolicy_ApiBuilder? api);
}

class _$Capabilities_PasswordPolicy extends Capabilities_PasswordPolicy {
  @override
  final int minLength;
  @override
  final bool enforceNonCommonPassword;
  @override
  final bool enforceNumericCharacters;
  @override
  final bool enforceSpecialCharacters;
  @override
  final bool enforceUpperLowerCase;
  @override
  final Capabilities_PasswordPolicy_Api api;

  factory _$Capabilities_PasswordPolicy([void Function(Capabilities_PasswordPolicyBuilder)? updates]) =>
      (Capabilities_PasswordPolicyBuilder()..update(updates))._build();

  _$Capabilities_PasswordPolicy._(
      {required this.minLength,
      required this.enforceNonCommonPassword,
      required this.enforceNumericCharacters,
      required this.enforceSpecialCharacters,
      required this.enforceUpperLowerCase,
      required this.api})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(minLength, r'Capabilities_PasswordPolicy', 'minLength');
    BuiltValueNullFieldError.checkNotNull(
        enforceNonCommonPassword, r'Capabilities_PasswordPolicy', 'enforceNonCommonPassword');
    BuiltValueNullFieldError.checkNotNull(
        enforceNumericCharacters, r'Capabilities_PasswordPolicy', 'enforceNumericCharacters');
    BuiltValueNullFieldError.checkNotNull(
        enforceSpecialCharacters, r'Capabilities_PasswordPolicy', 'enforceSpecialCharacters');
    BuiltValueNullFieldError.checkNotNull(
        enforceUpperLowerCase, r'Capabilities_PasswordPolicy', 'enforceUpperLowerCase');
    BuiltValueNullFieldError.checkNotNull(api, r'Capabilities_PasswordPolicy', 'api');
  }

  @override
  Capabilities_PasswordPolicy rebuild(void Function(Capabilities_PasswordPolicyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  Capabilities_PasswordPolicyBuilder toBuilder() => Capabilities_PasswordPolicyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Capabilities_PasswordPolicy &&
        minLength == other.minLength &&
        enforceNonCommonPassword == other.enforceNonCommonPassword &&
        enforceNumericCharacters == other.enforceNumericCharacters &&
        enforceSpecialCharacters == other.enforceSpecialCharacters &&
        enforceUpperLowerCase == other.enforceUpperLowerCase &&
        api == other.api;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, minLength.hashCode);
    _$hash = $jc(_$hash, enforceNonCommonPassword.hashCode);
    _$hash = $jc(_$hash, enforceNumericCharacters.hashCode);
    _$hash = $jc(_$hash, enforceSpecialCharacters.hashCode);
    _$hash = $jc(_$hash, enforceUpperLowerCase.hashCode);
    _$hash = $jc(_$hash, api.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Capabilities_PasswordPolicy')
          ..add('minLength', minLength)
          ..add('enforceNonCommonPassword', enforceNonCommonPassword)
          ..add('enforceNumericCharacters', enforceNumericCharacters)
          ..add('enforceSpecialCharacters', enforceSpecialCharacters)
          ..add('enforceUpperLowerCase', enforceUpperLowerCase)
          ..add('api', api))
        .toString();
  }
}

class Capabilities_PasswordPolicyBuilder
    implements
        Builder<Capabilities_PasswordPolicy, Capabilities_PasswordPolicyBuilder>,
        $Capabilities_PasswordPolicyInterfaceBuilder {
  _$Capabilities_PasswordPolicy? _$v;

  int? _minLength;
  int? get minLength => _$this._minLength;
  set minLength(covariant int? minLength) => _$this._minLength = minLength;

  bool? _enforceNonCommonPassword;
  bool? get enforceNonCommonPassword => _$this._enforceNonCommonPassword;
  set enforceNonCommonPassword(covariant bool? enforceNonCommonPassword) =>
      _$this._enforceNonCommonPassword = enforceNonCommonPassword;

  bool? _enforceNumericCharacters;
  bool? get enforceNumericCharacters => _$this._enforceNumericCharacters;
  set enforceNumericCharacters(covariant bool? enforceNumericCharacters) =>
      _$this._enforceNumericCharacters = enforceNumericCharacters;

  bool? _enforceSpecialCharacters;
  bool? get enforceSpecialCharacters => _$this._enforceSpecialCharacters;
  set enforceSpecialCharacters(covariant bool? enforceSpecialCharacters) =>
      _$this._enforceSpecialCharacters = enforceSpecialCharacters;

  bool? _enforceUpperLowerCase;
  bool? get enforceUpperLowerCase => _$this._enforceUpperLowerCase;
  set enforceUpperLowerCase(covariant bool? enforceUpperLowerCase) =>
      _$this._enforceUpperLowerCase = enforceUpperLowerCase;

  Capabilities_PasswordPolicy_ApiBuilder? _api;
  Capabilities_PasswordPolicy_ApiBuilder get api => _$this._api ??= Capabilities_PasswordPolicy_ApiBuilder();
  set api(covariant Capabilities_PasswordPolicy_ApiBuilder? api) => _$this._api = api;

  Capabilities_PasswordPolicyBuilder() {
    Capabilities_PasswordPolicy._defaults(this);
  }

  Capabilities_PasswordPolicyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _minLength = $v.minLength;
      _enforceNonCommonPassword = $v.enforceNonCommonPassword;
      _enforceNumericCharacters = $v.enforceNumericCharacters;
      _enforceSpecialCharacters = $v.enforceSpecialCharacters;
      _enforceUpperLowerCase = $v.enforceUpperLowerCase;
      _api = $v.api.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Capabilities_PasswordPolicy other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Capabilities_PasswordPolicy;
  }

  @override
  void update(void Function(Capabilities_PasswordPolicyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Capabilities_PasswordPolicy build() => _build();

  _$Capabilities_PasswordPolicy _build() {
    Capabilities_PasswordPolicy._validate(this);
    _$Capabilities_PasswordPolicy _$result;
    try {
      _$result = _$v ??
          _$Capabilities_PasswordPolicy._(
            minLength: BuiltValueNullFieldError.checkNotNull(minLength, r'Capabilities_PasswordPolicy', 'minLength'),
            enforceNonCommonPassword: BuiltValueNullFieldError.checkNotNull(
                enforceNonCommonPassword, r'Capabilities_PasswordPolicy', 'enforceNonCommonPassword'),
            enforceNumericCharacters: BuiltValueNullFieldError.checkNotNull(
                enforceNumericCharacters, r'Capabilities_PasswordPolicy', 'enforceNumericCharacters'),
            enforceSpecialCharacters: BuiltValueNullFieldError.checkNotNull(
                enforceSpecialCharacters, r'Capabilities_PasswordPolicy', 'enforceSpecialCharacters'),
            enforceUpperLowerCase: BuiltValueNullFieldError.checkNotNull(
                enforceUpperLowerCase, r'Capabilities_PasswordPolicy', 'enforceUpperLowerCase'),
            api: api.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'api';
        api.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Capabilities_PasswordPolicy', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $CapabilitiesInterfaceBuilder {
  void replace($CapabilitiesInterface other);
  void update(void Function($CapabilitiesInterfaceBuilder) updates);
  Capabilities_PasswordPolicyBuilder get passwordPolicy;
  set passwordPolicy(Capabilities_PasswordPolicyBuilder? passwordPolicy);
}

class _$Capabilities extends Capabilities {
  @override
  final Capabilities_PasswordPolicy passwordPolicy;

  factory _$Capabilities([void Function(CapabilitiesBuilder)? updates]) =>
      (CapabilitiesBuilder()..update(updates))._build();

  _$Capabilities._({required this.passwordPolicy}) : super._() {
    BuiltValueNullFieldError.checkNotNull(passwordPolicy, r'Capabilities', 'passwordPolicy');
  }

  @override
  Capabilities rebuild(void Function(CapabilitiesBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  CapabilitiesBuilder toBuilder() => CapabilitiesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Capabilities && passwordPolicy == other.passwordPolicy;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, passwordPolicy.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Capabilities')..add('passwordPolicy', passwordPolicy)).toString();
  }
}

class CapabilitiesBuilder implements Builder<Capabilities, CapabilitiesBuilder>, $CapabilitiesInterfaceBuilder {
  _$Capabilities? _$v;

  Capabilities_PasswordPolicyBuilder? _passwordPolicy;
  Capabilities_PasswordPolicyBuilder get passwordPolicy =>
      _$this._passwordPolicy ??= Capabilities_PasswordPolicyBuilder();
  set passwordPolicy(covariant Capabilities_PasswordPolicyBuilder? passwordPolicy) =>
      _$this._passwordPolicy = passwordPolicy;

  CapabilitiesBuilder() {
    Capabilities._defaults(this);
  }

  CapabilitiesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _passwordPolicy = $v.passwordPolicy.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Capabilities other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Capabilities;
  }

  @override
  void update(void Function(CapabilitiesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Capabilities build() => _build();

  _$Capabilities _build() {
    Capabilities._validate(this);
    _$Capabilities _$result;
    try {
      _$result = _$v ??
          _$Capabilities._(
            passwordPolicy: passwordPolicy.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'passwordPolicy';
        passwordPolicy.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Capabilities', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
