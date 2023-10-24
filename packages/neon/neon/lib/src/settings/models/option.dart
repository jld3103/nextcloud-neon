import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:neon/src/models/disposable.dart';
import 'package:neon/src/models/label_builder.dart';
import 'package:neon/src/settings/models/options_category.dart';
import 'package:neon/src/settings/models/storage.dart';
import 'package:rxdart/rxdart.dart';

/// Listenable option that is persisted in the [SettingsStorage].
///
/// See:
///   * [ToggleOption] for an Option<bool>
///   * [SelectOption] for an Option with multiple values
sealed class Option<T> extends ChangeNotifier implements ValueListenable<T>, Disposable {
  /// Creates an Option
  Option({
    required this.storage,
    required this.key,
    required this.label,
    required this.defaultValue,
    final bool enabled = true,
    this.category,
    final T? initialValue,
  })  : _value = initialValue ?? defaultValue,
        _enabled = enabled;

  /// Creates an Option depending on the State of another one.
  Option.depend({
    required this.storage,
    required this.key,
    required this.label,
    required this.defaultValue,
    required final ValueListenable<bool> enabled,
    this.category,
    final T? initialValue,
  })  : _value = initialValue ?? defaultValue,
        _enabled = enabled.value {
    enabled.addListener(() {
      this.enabled = enabled.value;
    });
  }

  /// Storage to persist the state.
  final SettingsStorage storage;

  /// Storage key to save the state at.
  final Storable key;

  /// Label of the option.
  final LabelBuilder label;

  /// Default value of the option.
  ///
  /// [reset] will restore this value.
  final T defaultValue;

  /// Category of this option.
  ///
  /// This can be used to group multiple options
  final OptionsCategory? category;

  T _value;

  /// The current value stored in this option.
  ///
  /// When the value is replaced with something that is not equal to the old
  /// value as evaluated by the equality operator ==, this class notifies its
  /// listeners.
  @override
  T get value => _value;
  @mustCallSuper
  set value(final T newValue) {
    if (_value == newValue) {
      return;
    }
    _value = newValue;
    notifyListeners();
  }

  bool _enabled;

  /// The current enabled state stored in this option.
  ///
  /// When the value is replaced with something that is not equal to the old
  /// value as evaluated by the equality operator ==, this class notifies its
  /// listeners.
  bool get enabled => _enabled;
  @mustCallSuper
  set enabled(final bool newValue) {
    if (_enabled == newValue) {
      return;
    }
    _enabled = newValue;
    notifyListeners();
  }

  /// Resets the option to its [default] value.
  @mustBeOverridden
  void reset() {
    value = defaultValue;
  }

  /// Loads [data] into [value] by calling [deserialize] on it.
  void load(final Object? data) {
    final value = deserialize(data);

    if (value != null) {
      this.value = value;
    }
  }

  /// Deserializes the data.
  T? deserialize(final Object? data);

  /// Serializes the [value].
  Object? serialize();

  BehaviorSubject<T>? _stream;

  /// A stream of values that is updated on each event.
  ///
  /// This is similar to adding an [addListener] callback and getting the current data in it.
  /// You should generally listen to the notifications directly.
  Stream<T> get stream {
    _stream ??= BehaviorSubject.seeded(_value);

    addListener(() {
      _stream!.add(_value);
    });

    return _stream!;
  }

  @override
  void dispose() {
    unawaited(_stream?.close());

    super.dispose();
  }
}

/// [Option] with multiple available values.
///
/// See:
///   * [SelectOption] for an Option with multiple values

class SelectOption<T> extends Option<T> {
  /// Creates a SelectOption
  SelectOption({
    required super.storage,
    required super.key,
    required super.label,
    required super.defaultValue,
    required final Map<T, LabelBuilder> values,

    /// Force loading the stored value.
    ///
    /// This is needed when [values] is empty but the stored value should still be loaded.
    /// This only works when [T] is of type String?.
    final bool forceLoadValue = true,
    super.category,
    super.enabled,
  })  : _values = values,
        super(initialValue: _loadValue(values, storage.getString(key.value), forceLoad: forceLoadValue));

  /// Creates a SelectOption depending on the State of another [Option].
  SelectOption.depend({
    required super.storage,
    required super.key,
    required super.label,
    required super.defaultValue,
    required final Map<T, LabelBuilder> values,
    required super.enabled,

    /// Force loading the stored value.
    ///
    /// This is needed when [values] is empty but the stored value should still be loaded.
    /// This only works when [T] is of type String?.
    final bool forceLoadValue = true,
    super.category,
  })  : _values = values,
        super.depend(initialValue: _loadValue(values, storage.getString(key.value), forceLoad: forceLoadValue));

  static T? _loadValue<T>(final Map<T, LabelBuilder> vs, final String? stored, {final bool forceLoad = true}) {
    if (forceLoad && vs.isEmpty && stored is T) {
      return stored as T;
    }

    return _deserialize(vs, stored);
  }

  @override
  void reset() {
    unawaited(storage.remove(key.value));

    super.reset();
  }

  Map<T, LabelBuilder> _values;

  @override
  set value(final T value) {
    super.value = value;

    if (value != null) {
      unawaited(storage.setString(key.value, serialize()!));
    }
  }

  /// A collection of different values this can have.
  ///
  /// See:
  /// * [value] for the currently selected one
  Map<T, LabelBuilder> get values => _values;

  /// Updates the collection of possible values.
  ///
  /// It is up to the caller to also change the [value] if it is no longer supported.
  set values(final Map<T, LabelBuilder> newValues) {
    if (_values == newValues) {
      return;
    }
    _values = newValues;
    notifyListeners();
  }

  @override
  String? serialize() => _serialize(value);

  static String? _serialize<T>(final T value) => value?.toString();

  @override
  T? deserialize(final Object? data) => _deserialize(_values, data as String?);

  static T? _deserialize<T>(final Map<T, LabelBuilder> vs, final String? valueStr) {
    if (valueStr == null) {
      return null;
    }

    return vs.keys.firstWhereOrNull((final e) => _serialize(e) == valueStr);
  }
}

/// [Option] with a boolean value.
///
/// See:
///   * [SelectOption] for an Option with multiple values
class ToggleOption extends Option<bool> {
  /// Creates a ToggleOption
  ToggleOption({
    required super.storage,
    required super.key,
    required super.label,
    required final bool defaultValue,
    super.category,
    super.enabled,
  }) : super(defaultValue: storage.getBool(key.value) ?? defaultValue);

  /// Creates a ToggleOption depending on the State of another [Option].
  ToggleOption.depend({
    required super.storage,
    required super.key,
    required super.label,
    required final bool defaultValue,
    required super.enabled,
    super.category,
  }) : super.depend(
          defaultValue: storage.getBool(key.value) ?? defaultValue,
        );

  @override
  void reset() {
    unawaited(storage.remove(key.value));

    super.reset();
  }

  @override
  set value(final bool value) {
    super.value = value;

    unawaited(storage.setBool(key.value, serialize()));
  }

  @override
  bool serialize() => value;

  @override
  bool? deserialize(final Object? data) => data as bool?;
}
