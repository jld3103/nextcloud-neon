//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingUser {
  /// Returns a new [CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingUser] instance.
  CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingUser({
    this.sendMail,
    this.expireDate,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? sendMail;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingPublicExpireDate? expireDate;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingUser &&
          other.sendMail == sendMail &&
          other.expireDate == expireDate;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (sendMail == null ? 0 : sendMail!.hashCode) + (expireDate == null ? 0 : expireDate!.hashCode);

  @override
  String toString() =>
      'CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingUser[sendMail=$sendMail, expireDate=$expireDate]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.sendMail != null) {
      json[r'send_mail'] = this.sendMail;
    } else {
      json[r'send_mail'] = null;
    }
    if (this.expireDate != null) {
      json[r'expire_date'] = this.expireDate;
    } else {
      json[r'expire_date'] = null;
    }
    return json;
  }

  /// Returns a new [CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingUser] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingUser? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingUser[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingUser[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingUser(
        sendMail: mapValueOfType<bool>(json, r'send_mail'),
        expireDate:
            CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingPublicExpireDate.fromJson(json[r'expire_date']),
      );
    }
    return null;
  }

  static List<CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingUser>? listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingUser>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingUser.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingUser> mapFromJson(dynamic json) {
    final map = <String, CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingUser>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingUser.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingUser-objects as value to a dart map
  static Map<String, List<CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingUser>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingUser>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingUser.listFromJson(
          entry.value,
          growable: growable,
        );
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{};
}
