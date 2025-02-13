// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sharebymail.openapi.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Capabilities_FilesSharing_Sharebymail_UploadFilesDrop>
    _$capabilitiesFilesSharingSharebymailUploadFilesDropSerializer =
    _$Capabilities_FilesSharing_Sharebymail_UploadFilesDropSerializer();
Serializer<Capabilities_FilesSharing_Sharebymail_Password> _$capabilitiesFilesSharingSharebymailPasswordSerializer =
    _$Capabilities_FilesSharing_Sharebymail_PasswordSerializer();
Serializer<Capabilities_FilesSharing_Sharebymail_ExpireDate> _$capabilitiesFilesSharingSharebymailExpireDateSerializer =
    _$Capabilities_FilesSharing_Sharebymail_ExpireDateSerializer();
Serializer<Capabilities_FilesSharing_Sharebymail> _$capabilitiesFilesSharingSharebymailSerializer =
    _$Capabilities_FilesSharing_SharebymailSerializer();
Serializer<Capabilities_FilesSharing> _$capabilitiesFilesSharingSerializer = _$Capabilities_FilesSharingSerializer();
Serializer<Capabilities> _$capabilitiesSerializer = _$CapabilitiesSerializer();

class _$Capabilities_FilesSharing_Sharebymail_UploadFilesDropSerializer
    implements StructuredSerializer<Capabilities_FilesSharing_Sharebymail_UploadFilesDrop> {
  @override
  final Iterable<Type> types = const [
    Capabilities_FilesSharing_Sharebymail_UploadFilesDrop,
    _$Capabilities_FilesSharing_Sharebymail_UploadFilesDrop
  ];
  @override
  final String wireName = 'Capabilities_FilesSharing_Sharebymail_UploadFilesDrop';

  @override
  Iterable<Object?> serialize(Serializers serializers, Capabilities_FilesSharing_Sharebymail_UploadFilesDrop object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'enabled',
      serializers.serialize(object.enabled, specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  Capabilities_FilesSharing_Sharebymail_UploadFilesDrop deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = Capabilities_FilesSharing_Sharebymail_UploadFilesDropBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'enabled':
          result.enabled = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$Capabilities_FilesSharing_Sharebymail_PasswordSerializer
    implements StructuredSerializer<Capabilities_FilesSharing_Sharebymail_Password> {
  @override
  final Iterable<Type> types = const [
    Capabilities_FilesSharing_Sharebymail_Password,
    _$Capabilities_FilesSharing_Sharebymail_Password
  ];
  @override
  final String wireName = 'Capabilities_FilesSharing_Sharebymail_Password';

  @override
  Iterable<Object?> serialize(Serializers serializers, Capabilities_FilesSharing_Sharebymail_Password object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'enabled',
      serializers.serialize(object.enabled, specifiedType: const FullType(bool)),
      'enforced',
      serializers.serialize(object.enforced, specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  Capabilities_FilesSharing_Sharebymail_Password deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = Capabilities_FilesSharing_Sharebymail_PasswordBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'enabled':
          result.enabled = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
        case 'enforced':
          result.enforced = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$Capabilities_FilesSharing_Sharebymail_ExpireDateSerializer
    implements StructuredSerializer<Capabilities_FilesSharing_Sharebymail_ExpireDate> {
  @override
  final Iterable<Type> types = const [
    Capabilities_FilesSharing_Sharebymail_ExpireDate,
    _$Capabilities_FilesSharing_Sharebymail_ExpireDate
  ];
  @override
  final String wireName = 'Capabilities_FilesSharing_Sharebymail_ExpireDate';

  @override
  Iterable<Object?> serialize(Serializers serializers, Capabilities_FilesSharing_Sharebymail_ExpireDate object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'enabled',
      serializers.serialize(object.enabled, specifiedType: const FullType(bool)),
      'enforced',
      serializers.serialize(object.enforced, specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  Capabilities_FilesSharing_Sharebymail_ExpireDate deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = Capabilities_FilesSharing_Sharebymail_ExpireDateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'enabled':
          result.enabled = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
        case 'enforced':
          result.enforced = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$Capabilities_FilesSharing_SharebymailSerializer
    implements StructuredSerializer<Capabilities_FilesSharing_Sharebymail> {
  @override
  final Iterable<Type> types = const [Capabilities_FilesSharing_Sharebymail, _$Capabilities_FilesSharing_Sharebymail];
  @override
  final String wireName = 'Capabilities_FilesSharing_Sharebymail';

  @override
  Iterable<Object?> serialize(Serializers serializers, Capabilities_FilesSharing_Sharebymail object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'enabled',
      serializers.serialize(object.enabled, specifiedType: const FullType(bool)),
      'send_password_by_mail',
      serializers.serialize(object.sendPasswordByMail, specifiedType: const FullType(bool)),
      'upload_files_drop',
      serializers.serialize(object.uploadFilesDrop,
          specifiedType: const FullType(Capabilities_FilesSharing_Sharebymail_UploadFilesDrop)),
      'password',
      serializers.serialize(object.password,
          specifiedType: const FullType(Capabilities_FilesSharing_Sharebymail_Password)),
      'expire_date',
      serializers.serialize(object.expireDate,
          specifiedType: const FullType(Capabilities_FilesSharing_Sharebymail_ExpireDate)),
    ];

    return result;
  }

  @override
  Capabilities_FilesSharing_Sharebymail deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = Capabilities_FilesSharing_SharebymailBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'enabled':
          result.enabled = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
        case 'send_password_by_mail':
          result.sendPasswordByMail = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
        case 'upload_files_drop':
          result.uploadFilesDrop.replace(serializers.deserialize(value,
                  specifiedType: const FullType(Capabilities_FilesSharing_Sharebymail_UploadFilesDrop))!
              as Capabilities_FilesSharing_Sharebymail_UploadFilesDrop);
          break;
        case 'password':
          result.password.replace(serializers.deserialize(value,
                  specifiedType: const FullType(Capabilities_FilesSharing_Sharebymail_Password))!
              as Capabilities_FilesSharing_Sharebymail_Password);
          break;
        case 'expire_date':
          result.expireDate.replace(serializers.deserialize(value,
                  specifiedType: const FullType(Capabilities_FilesSharing_Sharebymail_ExpireDate))!
              as Capabilities_FilesSharing_Sharebymail_ExpireDate);
          break;
      }
    }

    return result.build();
  }
}

class _$Capabilities_FilesSharingSerializer implements StructuredSerializer<Capabilities_FilesSharing> {
  @override
  final Iterable<Type> types = const [Capabilities_FilesSharing, _$Capabilities_FilesSharing];
  @override
  final String wireName = 'Capabilities_FilesSharing';

  @override
  Iterable<Object?> serialize(Serializers serializers, Capabilities_FilesSharing object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'sharebymail',
      serializers.serialize(object.sharebymail, specifiedType: const FullType(Capabilities_FilesSharing_Sharebymail)),
    ];

    return result;
  }

  @override
  Capabilities_FilesSharing deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = Capabilities_FilesSharingBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'sharebymail':
          result.sharebymail.replace(
              serializers.deserialize(value, specifiedType: const FullType(Capabilities_FilesSharing_Sharebymail))!
                  as Capabilities_FilesSharing_Sharebymail);
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
    final result = <Object?>[];
    Object? value;
    value = object.filesSharing;
    if (value != null) {
      result
        ..add('files_sharing')
        ..add(serializers.serialize(value, specifiedType: const FullType(Capabilities_FilesSharing)));
    }
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
        case 'files_sharing':
          result.filesSharing.replace(serializers.deserialize(value,
              specifiedType: const FullType(Capabilities_FilesSharing))! as Capabilities_FilesSharing);
          break;
      }
    }

    return result.build();
  }
}

abstract mixin class $Capabilities_FilesSharing_Sharebymail_UploadFilesDropInterfaceBuilder {
  void replace($Capabilities_FilesSharing_Sharebymail_UploadFilesDropInterface other);
  void update(void Function($Capabilities_FilesSharing_Sharebymail_UploadFilesDropInterfaceBuilder) updates);
  bool? get enabled;
  set enabled(bool? enabled);
}

class _$Capabilities_FilesSharing_Sharebymail_UploadFilesDrop
    extends Capabilities_FilesSharing_Sharebymail_UploadFilesDrop {
  @override
  final bool enabled;

  factory _$Capabilities_FilesSharing_Sharebymail_UploadFilesDrop(
          [void Function(Capabilities_FilesSharing_Sharebymail_UploadFilesDropBuilder)? updates]) =>
      (Capabilities_FilesSharing_Sharebymail_UploadFilesDropBuilder()..update(updates))._build();

  _$Capabilities_FilesSharing_Sharebymail_UploadFilesDrop._({required this.enabled}) : super._() {
    BuiltValueNullFieldError.checkNotNull(enabled, r'Capabilities_FilesSharing_Sharebymail_UploadFilesDrop', 'enabled');
  }

  @override
  Capabilities_FilesSharing_Sharebymail_UploadFilesDrop rebuild(
          void Function(Capabilities_FilesSharing_Sharebymail_UploadFilesDropBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  Capabilities_FilesSharing_Sharebymail_UploadFilesDropBuilder toBuilder() =>
      Capabilities_FilesSharing_Sharebymail_UploadFilesDropBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Capabilities_FilesSharing_Sharebymail_UploadFilesDrop && enabled == other.enabled;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Capabilities_FilesSharing_Sharebymail_UploadFilesDrop')
          ..add('enabled', enabled))
        .toString();
  }
}

class Capabilities_FilesSharing_Sharebymail_UploadFilesDropBuilder
    implements
        Builder<Capabilities_FilesSharing_Sharebymail_UploadFilesDrop,
            Capabilities_FilesSharing_Sharebymail_UploadFilesDropBuilder>,
        $Capabilities_FilesSharing_Sharebymail_UploadFilesDropInterfaceBuilder {
  _$Capabilities_FilesSharing_Sharebymail_UploadFilesDrop? _$v;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(covariant bool? enabled) => _$this._enabled = enabled;

  Capabilities_FilesSharing_Sharebymail_UploadFilesDropBuilder() {
    Capabilities_FilesSharing_Sharebymail_UploadFilesDrop._defaults(this);
  }

  Capabilities_FilesSharing_Sharebymail_UploadFilesDropBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enabled = $v.enabled;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Capabilities_FilesSharing_Sharebymail_UploadFilesDrop other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Capabilities_FilesSharing_Sharebymail_UploadFilesDrop;
  }

  @override
  void update(void Function(Capabilities_FilesSharing_Sharebymail_UploadFilesDropBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Capabilities_FilesSharing_Sharebymail_UploadFilesDrop build() => _build();

  _$Capabilities_FilesSharing_Sharebymail_UploadFilesDrop _build() {
    Capabilities_FilesSharing_Sharebymail_UploadFilesDrop._validate(this);
    final _$result = _$v ??
        _$Capabilities_FilesSharing_Sharebymail_UploadFilesDrop._(
          enabled: BuiltValueNullFieldError.checkNotNull(
              enabled, r'Capabilities_FilesSharing_Sharebymail_UploadFilesDrop', 'enabled'),
        );
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $Capabilities_FilesSharing_Sharebymail_PasswordInterfaceBuilder {
  void replace($Capabilities_FilesSharing_Sharebymail_PasswordInterface other);
  void update(void Function($Capabilities_FilesSharing_Sharebymail_PasswordInterfaceBuilder) updates);
  bool? get enabled;
  set enabled(bool? enabled);

  bool? get enforced;
  set enforced(bool? enforced);
}

class _$Capabilities_FilesSharing_Sharebymail_Password extends Capabilities_FilesSharing_Sharebymail_Password {
  @override
  final bool enabled;
  @override
  final bool enforced;

  factory _$Capabilities_FilesSharing_Sharebymail_Password(
          [void Function(Capabilities_FilesSharing_Sharebymail_PasswordBuilder)? updates]) =>
      (Capabilities_FilesSharing_Sharebymail_PasswordBuilder()..update(updates))._build();

  _$Capabilities_FilesSharing_Sharebymail_Password._({required this.enabled, required this.enforced}) : super._() {
    BuiltValueNullFieldError.checkNotNull(enabled, r'Capabilities_FilesSharing_Sharebymail_Password', 'enabled');
    BuiltValueNullFieldError.checkNotNull(enforced, r'Capabilities_FilesSharing_Sharebymail_Password', 'enforced');
  }

  @override
  Capabilities_FilesSharing_Sharebymail_Password rebuild(
          void Function(Capabilities_FilesSharing_Sharebymail_PasswordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  Capabilities_FilesSharing_Sharebymail_PasswordBuilder toBuilder() =>
      Capabilities_FilesSharing_Sharebymail_PasswordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Capabilities_FilesSharing_Sharebymail_Password &&
        enabled == other.enabled &&
        enforced == other.enforced;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, enforced.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Capabilities_FilesSharing_Sharebymail_Password')
          ..add('enabled', enabled)
          ..add('enforced', enforced))
        .toString();
  }
}

class Capabilities_FilesSharing_Sharebymail_PasswordBuilder
    implements
        Builder<Capabilities_FilesSharing_Sharebymail_Password, Capabilities_FilesSharing_Sharebymail_PasswordBuilder>,
        $Capabilities_FilesSharing_Sharebymail_PasswordInterfaceBuilder {
  _$Capabilities_FilesSharing_Sharebymail_Password? _$v;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(covariant bool? enabled) => _$this._enabled = enabled;

  bool? _enforced;
  bool? get enforced => _$this._enforced;
  set enforced(covariant bool? enforced) => _$this._enforced = enforced;

  Capabilities_FilesSharing_Sharebymail_PasswordBuilder() {
    Capabilities_FilesSharing_Sharebymail_Password._defaults(this);
  }

  Capabilities_FilesSharing_Sharebymail_PasswordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enabled = $v.enabled;
      _enforced = $v.enforced;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Capabilities_FilesSharing_Sharebymail_Password other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Capabilities_FilesSharing_Sharebymail_Password;
  }

  @override
  void update(void Function(Capabilities_FilesSharing_Sharebymail_PasswordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Capabilities_FilesSharing_Sharebymail_Password build() => _build();

  _$Capabilities_FilesSharing_Sharebymail_Password _build() {
    Capabilities_FilesSharing_Sharebymail_Password._validate(this);
    final _$result = _$v ??
        _$Capabilities_FilesSharing_Sharebymail_Password._(
          enabled: BuiltValueNullFieldError.checkNotNull(
              enabled, r'Capabilities_FilesSharing_Sharebymail_Password', 'enabled'),
          enforced: BuiltValueNullFieldError.checkNotNull(
              enforced, r'Capabilities_FilesSharing_Sharebymail_Password', 'enforced'),
        );
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $Capabilities_FilesSharing_Sharebymail_ExpireDateInterfaceBuilder {
  void replace($Capabilities_FilesSharing_Sharebymail_ExpireDateInterface other);
  void update(void Function($Capabilities_FilesSharing_Sharebymail_ExpireDateInterfaceBuilder) updates);
  bool? get enabled;
  set enabled(bool? enabled);

  bool? get enforced;
  set enforced(bool? enforced);
}

class _$Capabilities_FilesSharing_Sharebymail_ExpireDate extends Capabilities_FilesSharing_Sharebymail_ExpireDate {
  @override
  final bool enabled;
  @override
  final bool enforced;

  factory _$Capabilities_FilesSharing_Sharebymail_ExpireDate(
          [void Function(Capabilities_FilesSharing_Sharebymail_ExpireDateBuilder)? updates]) =>
      (Capabilities_FilesSharing_Sharebymail_ExpireDateBuilder()..update(updates))._build();

  _$Capabilities_FilesSharing_Sharebymail_ExpireDate._({required this.enabled, required this.enforced}) : super._() {
    BuiltValueNullFieldError.checkNotNull(enabled, r'Capabilities_FilesSharing_Sharebymail_ExpireDate', 'enabled');
    BuiltValueNullFieldError.checkNotNull(enforced, r'Capabilities_FilesSharing_Sharebymail_ExpireDate', 'enforced');
  }

  @override
  Capabilities_FilesSharing_Sharebymail_ExpireDate rebuild(
          void Function(Capabilities_FilesSharing_Sharebymail_ExpireDateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  Capabilities_FilesSharing_Sharebymail_ExpireDateBuilder toBuilder() =>
      Capabilities_FilesSharing_Sharebymail_ExpireDateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Capabilities_FilesSharing_Sharebymail_ExpireDate &&
        enabled == other.enabled &&
        enforced == other.enforced;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, enforced.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Capabilities_FilesSharing_Sharebymail_ExpireDate')
          ..add('enabled', enabled)
          ..add('enforced', enforced))
        .toString();
  }
}

class Capabilities_FilesSharing_Sharebymail_ExpireDateBuilder
    implements
        Builder<Capabilities_FilesSharing_Sharebymail_ExpireDate,
            Capabilities_FilesSharing_Sharebymail_ExpireDateBuilder>,
        $Capabilities_FilesSharing_Sharebymail_ExpireDateInterfaceBuilder {
  _$Capabilities_FilesSharing_Sharebymail_ExpireDate? _$v;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(covariant bool? enabled) => _$this._enabled = enabled;

  bool? _enforced;
  bool? get enforced => _$this._enforced;
  set enforced(covariant bool? enforced) => _$this._enforced = enforced;

  Capabilities_FilesSharing_Sharebymail_ExpireDateBuilder() {
    Capabilities_FilesSharing_Sharebymail_ExpireDate._defaults(this);
  }

  Capabilities_FilesSharing_Sharebymail_ExpireDateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enabled = $v.enabled;
      _enforced = $v.enforced;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Capabilities_FilesSharing_Sharebymail_ExpireDate other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Capabilities_FilesSharing_Sharebymail_ExpireDate;
  }

  @override
  void update(void Function(Capabilities_FilesSharing_Sharebymail_ExpireDateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Capabilities_FilesSharing_Sharebymail_ExpireDate build() => _build();

  _$Capabilities_FilesSharing_Sharebymail_ExpireDate _build() {
    Capabilities_FilesSharing_Sharebymail_ExpireDate._validate(this);
    final _$result = _$v ??
        _$Capabilities_FilesSharing_Sharebymail_ExpireDate._(
          enabled: BuiltValueNullFieldError.checkNotNull(
              enabled, r'Capabilities_FilesSharing_Sharebymail_ExpireDate', 'enabled'),
          enforced: BuiltValueNullFieldError.checkNotNull(
              enforced, r'Capabilities_FilesSharing_Sharebymail_ExpireDate', 'enforced'),
        );
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $Capabilities_FilesSharing_SharebymailInterfaceBuilder {
  void replace($Capabilities_FilesSharing_SharebymailInterface other);
  void update(void Function($Capabilities_FilesSharing_SharebymailInterfaceBuilder) updates);
  bool? get enabled;
  set enabled(bool? enabled);

  bool? get sendPasswordByMail;
  set sendPasswordByMail(bool? sendPasswordByMail);

  Capabilities_FilesSharing_Sharebymail_UploadFilesDropBuilder get uploadFilesDrop;
  set uploadFilesDrop(Capabilities_FilesSharing_Sharebymail_UploadFilesDropBuilder? uploadFilesDrop);

  Capabilities_FilesSharing_Sharebymail_PasswordBuilder get password;
  set password(Capabilities_FilesSharing_Sharebymail_PasswordBuilder? password);

  Capabilities_FilesSharing_Sharebymail_ExpireDateBuilder get expireDate;
  set expireDate(Capabilities_FilesSharing_Sharebymail_ExpireDateBuilder? expireDate);
}

class _$Capabilities_FilesSharing_Sharebymail extends Capabilities_FilesSharing_Sharebymail {
  @override
  final bool enabled;
  @override
  final bool sendPasswordByMail;
  @override
  final Capabilities_FilesSharing_Sharebymail_UploadFilesDrop uploadFilesDrop;
  @override
  final Capabilities_FilesSharing_Sharebymail_Password password;
  @override
  final Capabilities_FilesSharing_Sharebymail_ExpireDate expireDate;

  factory _$Capabilities_FilesSharing_Sharebymail(
          [void Function(Capabilities_FilesSharing_SharebymailBuilder)? updates]) =>
      (Capabilities_FilesSharing_SharebymailBuilder()..update(updates))._build();

  _$Capabilities_FilesSharing_Sharebymail._(
      {required this.enabled,
      required this.sendPasswordByMail,
      required this.uploadFilesDrop,
      required this.password,
      required this.expireDate})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(enabled, r'Capabilities_FilesSharing_Sharebymail', 'enabled');
    BuiltValueNullFieldError.checkNotNull(
        sendPasswordByMail, r'Capabilities_FilesSharing_Sharebymail', 'sendPasswordByMail');
    BuiltValueNullFieldError.checkNotNull(uploadFilesDrop, r'Capabilities_FilesSharing_Sharebymail', 'uploadFilesDrop');
    BuiltValueNullFieldError.checkNotNull(password, r'Capabilities_FilesSharing_Sharebymail', 'password');
    BuiltValueNullFieldError.checkNotNull(expireDate, r'Capabilities_FilesSharing_Sharebymail', 'expireDate');
  }

  @override
  Capabilities_FilesSharing_Sharebymail rebuild(void Function(Capabilities_FilesSharing_SharebymailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  Capabilities_FilesSharing_SharebymailBuilder toBuilder() =>
      Capabilities_FilesSharing_SharebymailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Capabilities_FilesSharing_Sharebymail &&
        enabled == other.enabled &&
        sendPasswordByMail == other.sendPasswordByMail &&
        uploadFilesDrop == other.uploadFilesDrop &&
        password == other.password &&
        expireDate == other.expireDate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, sendPasswordByMail.hashCode);
    _$hash = $jc(_$hash, uploadFilesDrop.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, expireDate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Capabilities_FilesSharing_Sharebymail')
          ..add('enabled', enabled)
          ..add('sendPasswordByMail', sendPasswordByMail)
          ..add('uploadFilesDrop', uploadFilesDrop)
          ..add('password', password)
          ..add('expireDate', expireDate))
        .toString();
  }
}

class Capabilities_FilesSharing_SharebymailBuilder
    implements
        Builder<Capabilities_FilesSharing_Sharebymail, Capabilities_FilesSharing_SharebymailBuilder>,
        $Capabilities_FilesSharing_SharebymailInterfaceBuilder {
  _$Capabilities_FilesSharing_Sharebymail? _$v;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(covariant bool? enabled) => _$this._enabled = enabled;

  bool? _sendPasswordByMail;
  bool? get sendPasswordByMail => _$this._sendPasswordByMail;
  set sendPasswordByMail(covariant bool? sendPasswordByMail) => _$this._sendPasswordByMail = sendPasswordByMail;

  Capabilities_FilesSharing_Sharebymail_UploadFilesDropBuilder? _uploadFilesDrop;
  Capabilities_FilesSharing_Sharebymail_UploadFilesDropBuilder get uploadFilesDrop =>
      _$this._uploadFilesDrop ??= Capabilities_FilesSharing_Sharebymail_UploadFilesDropBuilder();
  set uploadFilesDrop(covariant Capabilities_FilesSharing_Sharebymail_UploadFilesDropBuilder? uploadFilesDrop) =>
      _$this._uploadFilesDrop = uploadFilesDrop;

  Capabilities_FilesSharing_Sharebymail_PasswordBuilder? _password;
  Capabilities_FilesSharing_Sharebymail_PasswordBuilder get password =>
      _$this._password ??= Capabilities_FilesSharing_Sharebymail_PasswordBuilder();
  set password(covariant Capabilities_FilesSharing_Sharebymail_PasswordBuilder? password) =>
      _$this._password = password;

  Capabilities_FilesSharing_Sharebymail_ExpireDateBuilder? _expireDate;
  Capabilities_FilesSharing_Sharebymail_ExpireDateBuilder get expireDate =>
      _$this._expireDate ??= Capabilities_FilesSharing_Sharebymail_ExpireDateBuilder();
  set expireDate(covariant Capabilities_FilesSharing_Sharebymail_ExpireDateBuilder? expireDate) =>
      _$this._expireDate = expireDate;

  Capabilities_FilesSharing_SharebymailBuilder() {
    Capabilities_FilesSharing_Sharebymail._defaults(this);
  }

  Capabilities_FilesSharing_SharebymailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enabled = $v.enabled;
      _sendPasswordByMail = $v.sendPasswordByMail;
      _uploadFilesDrop = $v.uploadFilesDrop.toBuilder();
      _password = $v.password.toBuilder();
      _expireDate = $v.expireDate.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Capabilities_FilesSharing_Sharebymail other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Capabilities_FilesSharing_Sharebymail;
  }

  @override
  void update(void Function(Capabilities_FilesSharing_SharebymailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Capabilities_FilesSharing_Sharebymail build() => _build();

  _$Capabilities_FilesSharing_Sharebymail _build() {
    Capabilities_FilesSharing_Sharebymail._validate(this);
    _$Capabilities_FilesSharing_Sharebymail _$result;
    try {
      _$result = _$v ??
          _$Capabilities_FilesSharing_Sharebymail._(
            enabled:
                BuiltValueNullFieldError.checkNotNull(enabled, r'Capabilities_FilesSharing_Sharebymail', 'enabled'),
            sendPasswordByMail: BuiltValueNullFieldError.checkNotNull(
                sendPasswordByMail, r'Capabilities_FilesSharing_Sharebymail', 'sendPasswordByMail'),
            uploadFilesDrop: uploadFilesDrop.build(),
            password: password.build(),
            expireDate: expireDate.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'uploadFilesDrop';
        uploadFilesDrop.build();
        _$failedField = 'password';
        password.build();
        _$failedField = 'expireDate';
        expireDate.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Capabilities_FilesSharing_Sharebymail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $Capabilities_FilesSharingInterfaceBuilder {
  void replace($Capabilities_FilesSharingInterface other);
  void update(void Function($Capabilities_FilesSharingInterfaceBuilder) updates);
  Capabilities_FilesSharing_SharebymailBuilder get sharebymail;
  set sharebymail(Capabilities_FilesSharing_SharebymailBuilder? sharebymail);
}

class _$Capabilities_FilesSharing extends Capabilities_FilesSharing {
  @override
  final Capabilities_FilesSharing_Sharebymail sharebymail;

  factory _$Capabilities_FilesSharing([void Function(Capabilities_FilesSharingBuilder)? updates]) =>
      (Capabilities_FilesSharingBuilder()..update(updates))._build();

  _$Capabilities_FilesSharing._({required this.sharebymail}) : super._() {
    BuiltValueNullFieldError.checkNotNull(sharebymail, r'Capabilities_FilesSharing', 'sharebymail');
  }

  @override
  Capabilities_FilesSharing rebuild(void Function(Capabilities_FilesSharingBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  Capabilities_FilesSharingBuilder toBuilder() => Capabilities_FilesSharingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Capabilities_FilesSharing && sharebymail == other.sharebymail;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sharebymail.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Capabilities_FilesSharing')..add('sharebymail', sharebymail)).toString();
  }
}

class Capabilities_FilesSharingBuilder
    implements
        Builder<Capabilities_FilesSharing, Capabilities_FilesSharingBuilder>,
        $Capabilities_FilesSharingInterfaceBuilder {
  _$Capabilities_FilesSharing? _$v;

  Capabilities_FilesSharing_SharebymailBuilder? _sharebymail;
  Capabilities_FilesSharing_SharebymailBuilder get sharebymail =>
      _$this._sharebymail ??= Capabilities_FilesSharing_SharebymailBuilder();
  set sharebymail(covariant Capabilities_FilesSharing_SharebymailBuilder? sharebymail) =>
      _$this._sharebymail = sharebymail;

  Capabilities_FilesSharingBuilder() {
    Capabilities_FilesSharing._defaults(this);
  }

  Capabilities_FilesSharingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sharebymail = $v.sharebymail.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Capabilities_FilesSharing other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Capabilities_FilesSharing;
  }

  @override
  void update(void Function(Capabilities_FilesSharingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Capabilities_FilesSharing build() => _build();

  _$Capabilities_FilesSharing _build() {
    Capabilities_FilesSharing._validate(this);
    _$Capabilities_FilesSharing _$result;
    try {
      _$result = _$v ??
          _$Capabilities_FilesSharing._(
            sharebymail: sharebymail.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'sharebymail';
        sharebymail.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Capabilities_FilesSharing', _$failedField, e.toString());
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
  Capabilities_FilesSharingBuilder get filesSharing;
  set filesSharing(Capabilities_FilesSharingBuilder? filesSharing);
}

class _$Capabilities extends Capabilities {
  @override
  final Capabilities_FilesSharing? filesSharing;

  factory _$Capabilities([void Function(CapabilitiesBuilder)? updates]) =>
      (CapabilitiesBuilder()..update(updates))._build();

  _$Capabilities._({this.filesSharing}) : super._();

  @override
  Capabilities rebuild(void Function(CapabilitiesBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  CapabilitiesBuilder toBuilder() => CapabilitiesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Capabilities && filesSharing == other.filesSharing;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, filesSharing.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Capabilities')..add('filesSharing', filesSharing)).toString();
  }
}

class CapabilitiesBuilder implements Builder<Capabilities, CapabilitiesBuilder>, $CapabilitiesInterfaceBuilder {
  _$Capabilities? _$v;

  Capabilities_FilesSharingBuilder? _filesSharing;
  Capabilities_FilesSharingBuilder get filesSharing => _$this._filesSharing ??= Capabilities_FilesSharingBuilder();
  set filesSharing(covariant Capabilities_FilesSharingBuilder? filesSharing) => _$this._filesSharing = filesSharing;

  CapabilitiesBuilder() {
    Capabilities._defaults(this);
  }

  CapabilitiesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _filesSharing = $v.filesSharing?.toBuilder();
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
            filesSharing: _filesSharing?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'filesSharing';
        _filesSharing?.build();
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
