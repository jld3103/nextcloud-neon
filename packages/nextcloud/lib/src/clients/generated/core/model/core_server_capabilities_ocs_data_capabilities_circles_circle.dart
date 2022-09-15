//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CoreServerCapabilitiesOcsDataCapabilitiesCirclesCircle {
  /// Returns a new [CoreServerCapabilitiesOcsDataCapabilitiesCirclesCircle] instance.
  CoreServerCapabilitiesOcsDataCapabilitiesCirclesCircle({
    this.constants,
    this.config,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  CoreServerCapabilitiesOcsDataCapabilitiesCirclesCircleConstants? constants;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  CoreServerCapabilitiesOcsDataCapabilitiesCirclesCircleConfig? config;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoreServerCapabilitiesOcsDataCapabilitiesCirclesCircle &&
          other.constants == constants &&
          other.config == config;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (constants == null ? 0 : constants!.hashCode) + (config == null ? 0 : config!.hashCode);

  @override
  String toString() => 'CoreServerCapabilitiesOcsDataCapabilitiesCirclesCircle[constants=$constants, config=$config]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.constants != null) {
      json[r'constants'] = this.constants;
    } else {
      json[r'constants'] = null;
    }
    if (this.config != null) {
      json[r'config'] = this.config;
    } else {
      json[r'config'] = null;
    }
    return json;
  }

  /// Returns a new [CoreServerCapabilitiesOcsDataCapabilitiesCirclesCircle] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CoreServerCapabilitiesOcsDataCapabilitiesCirclesCircle? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "CoreServerCapabilitiesOcsDataCapabilitiesCirclesCircle[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "CoreServerCapabilitiesOcsDataCapabilitiesCirclesCircle[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CoreServerCapabilitiesOcsDataCapabilitiesCirclesCircle(
        constants: CoreServerCapabilitiesOcsDataCapabilitiesCirclesCircleConstants.fromJson(json[r'constants']),
        config: CoreServerCapabilitiesOcsDataCapabilitiesCirclesCircleConfig.fromJson(json[r'config']),
      );
    }
    return null;
  }

  static List<CoreServerCapabilitiesOcsDataCapabilitiesCirclesCircle>? listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CoreServerCapabilitiesOcsDataCapabilitiesCirclesCircle>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CoreServerCapabilitiesOcsDataCapabilitiesCirclesCircle.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CoreServerCapabilitiesOcsDataCapabilitiesCirclesCircle> mapFromJson(dynamic json) {
    final map = <String, CoreServerCapabilitiesOcsDataCapabilitiesCirclesCircle>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CoreServerCapabilitiesOcsDataCapabilitiesCirclesCircle.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CoreServerCapabilitiesOcsDataCapabilitiesCirclesCircle-objects as value to a dart map
  static Map<String, List<CoreServerCapabilitiesOcsDataCapabilitiesCirclesCircle>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<CoreServerCapabilitiesOcsDataCapabilitiesCirclesCircle>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CoreServerCapabilitiesOcsDataCapabilitiesCirclesCircle.listFromJson(
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
