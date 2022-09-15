//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CoreServerCapabilitiesOcsDataCapabilitiesDav {
  /// Returns a new [CoreServerCapabilitiesOcsDataCapabilitiesDav] instance.
  CoreServerCapabilitiesOcsDataCapabilitiesDav({
    this.chunking,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? chunking;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CoreServerCapabilitiesOcsDataCapabilitiesDav && other.chunking == chunking;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (chunking == null ? 0 : chunking!.hashCode);

  @override
  String toString() => 'CoreServerCapabilitiesOcsDataCapabilitiesDav[chunking=$chunking]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.chunking != null) {
      json[r'chunking'] = this.chunking;
    } else {
      json[r'chunking'] = null;
    }
    return json;
  }

  /// Returns a new [CoreServerCapabilitiesOcsDataCapabilitiesDav] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CoreServerCapabilitiesOcsDataCapabilitiesDav? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "CoreServerCapabilitiesOcsDataCapabilitiesDav[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "CoreServerCapabilitiesOcsDataCapabilitiesDav[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CoreServerCapabilitiesOcsDataCapabilitiesDav(
        chunking: mapValueOfType<String>(json, r'chunking'),
      );
    }
    return null;
  }

  static List<CoreServerCapabilitiesOcsDataCapabilitiesDav>? listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CoreServerCapabilitiesOcsDataCapabilitiesDav>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CoreServerCapabilitiesOcsDataCapabilitiesDav.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CoreServerCapabilitiesOcsDataCapabilitiesDav> mapFromJson(dynamic json) {
    final map = <String, CoreServerCapabilitiesOcsDataCapabilitiesDav>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CoreServerCapabilitiesOcsDataCapabilitiesDav.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CoreServerCapabilitiesOcsDataCapabilitiesDav-objects as value to a dart map
  static Map<String, List<CoreServerCapabilitiesOcsDataCapabilitiesDav>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<CoreServerCapabilitiesOcsDataCapabilitiesDav>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CoreServerCapabilitiesOcsDataCapabilitiesDav.listFromJson(
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
