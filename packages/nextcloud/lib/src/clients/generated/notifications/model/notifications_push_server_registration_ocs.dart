//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class NotificationsPushServerRegistrationOcs {
  /// Returns a new [NotificationsPushServerRegistrationOcs] instance.
  NotificationsPushServerRegistrationOcs({
    this.meta,
    this.data,
  });

  /// Stub
  Object? meta;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  NotificationsPushServerSubscription? data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationsPushServerRegistrationOcs && other.meta == meta && other.data == data;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (meta == null ? 0 : meta!.hashCode) + (data == null ? 0 : data!.hashCode);

  @override
  String toString() => 'NotificationsPushServerRegistrationOcs[meta=$meta, data=$data]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.meta != null) {
      json[r'meta'] = this.meta;
    } else {
      json[r'meta'] = null;
    }
    if (this.data != null) {
      json[r'data'] = this.data;
    } else {
      json[r'data'] = null;
    }
    return json;
  }

  /// Returns a new [NotificationsPushServerRegistrationOcs] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static NotificationsPushServerRegistrationOcs? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "NotificationsPushServerRegistrationOcs[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "NotificationsPushServerRegistrationOcs[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return NotificationsPushServerRegistrationOcs(
        meta: mapValueOfType<Object>(json, r'meta'),
        data: NotificationsPushServerSubscription.fromJson(json[r'data']),
      );
    }
    return null;
  }

  static List<NotificationsPushServerRegistrationOcs>? listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <NotificationsPushServerRegistrationOcs>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = NotificationsPushServerRegistrationOcs.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, NotificationsPushServerRegistrationOcs> mapFromJson(dynamic json) {
    final map = <String, NotificationsPushServerRegistrationOcs>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = NotificationsPushServerRegistrationOcs.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of NotificationsPushServerRegistrationOcs-objects as value to a dart map
  static Map<String, List<NotificationsPushServerRegistrationOcs>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<NotificationsPushServerRegistrationOcs>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = NotificationsPushServerRegistrationOcs.listFromJson(
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
