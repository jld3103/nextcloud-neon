//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingSharee {
  /// Returns a new [CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingSharee] instance.
  CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingSharee({
    this.queryLookupDefault,
    this.alwaysShowUnique,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? queryLookupDefault;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? alwaysShowUnique;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingSharee &&
          other.queryLookupDefault == queryLookupDefault &&
          other.alwaysShowUnique == alwaysShowUnique;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (queryLookupDefault == null ? 0 : queryLookupDefault!.hashCode) +
      (alwaysShowUnique == null ? 0 : alwaysShowUnique!.hashCode);

  @override
  String toString() =>
      'CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingSharee[queryLookupDefault=$queryLookupDefault, alwaysShowUnique=$alwaysShowUnique]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.queryLookupDefault != null) {
      json[r'query_lookup_default'] = this.queryLookupDefault;
    } else {
      json[r'query_lookup_default'] = null;
    }
    if (this.alwaysShowUnique != null) {
      json[r'always_show_unique'] = this.alwaysShowUnique;
    } else {
      json[r'always_show_unique'] = null;
    }
    return json;
  }

  /// Returns a new [CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingSharee] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingSharee? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingSharee[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingSharee[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingSharee(
        queryLookupDefault: mapValueOfType<bool>(json, r'query_lookup_default'),
        alwaysShowUnique: mapValueOfType<bool>(json, r'always_show_unique'),
      );
    }
    return null;
  }

  static List<CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingSharee>? listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingSharee>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingSharee.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingSharee> mapFromJson(dynamic json) {
    final map = <String, CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingSharee>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingSharee.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingSharee-objects as value to a dart map
  static Map<String, List<CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingSharee>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingSharee>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CoreServerCapabilitiesOcsDataCapabilitiesFilesSharingSharee.listFromJson(
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
