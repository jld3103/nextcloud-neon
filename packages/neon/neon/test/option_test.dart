// ignore_for_file: discarded_futures

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neon/src/settings/models/select_option.dart';
import 'package:neon/src/settings/models/storage.dart';
import 'package:neon/src/settings/models/toggle_option.dart';
import 'package:test/test.dart';

class MockStorage extends Mock implements SettingsStorage {}

class MockCallbackFunction extends Mock {
  FutureOr<void> call();
}

enum SelectValues {
  first,
  second,
  third,
}

void main() {
  final storage = MockStorage();
  const key = 'storage-key';
  String labelBuilder(final _) => 'label';

  group('SelectOption', () {
    final valuesLabel = {
      SelectValues.first: (final _) => 'first',
      SelectValues.second: (final _) => 'second',
      SelectValues.third: (final _) => 'third',
    };

    late SelectOption<SelectValues> option;

    setUp(() {
      when(() => storage.setString(key, any())).thenAnswer((final _) async {});
      option = SelectOption<SelectValues>(
        storage: storage,
        key: key,
        label: labelBuilder,
        defaultValue: SelectValues.first,
        values: valuesLabel,
      );
    });

    tearDown(() {
      reset(storage);
      option.dispose();
    });

    test('Create', () {
      expect(option.value, option.defaultValue, reason: 'Should default to defaultValue.');

      when(() => storage.getString(key)).thenReturn('SelectValues.second');

      option = SelectOption<SelectValues>(
        storage: storage,
        key: key,
        label: labelBuilder,
        defaultValue: SelectValues.first,
        values: valuesLabel,
      );

      expect(option.value, SelectValues.second, reason: 'Should load value from storage when available.');
    });

    test('Depend', () {
      final enabled = ValueNotifier(false);
      final callback = MockCallbackFunction();

      option = SelectOption<SelectValues>.depend(
        storage: storage,
        key: key,
        label: labelBuilder,
        defaultValue: SelectValues.first,
        values: valuesLabel,
        enabled: enabled,
      )..addListener(callback.call);

      expect(option.enabled, enabled.value, reason: 'Should initialize with enabled value.');

      enabled.value = true;
      verify(callback.call).called(1);
      expect(option.enabled, enabled.value, reason: 'Should update the enabled state.');
    });

    test('Update', () {
      final callback = MockCallbackFunction();
      option
        ..addListener(callback.call)
        ..value = SelectValues.third;

      verify(callback.call).called(1);
      verify(() => storage.setString(key, 'SelectValues.third')).called(1);
      expect(option.value, SelectValues.third, reason: 'Should update the value.');

      option.value = SelectValues.third;
      verifyNever(callback.call); // Don't notify with the same value
      expect(option.value, SelectValues.third, reason: 'Should keep the value.');
    });

    test('Disable', () {
      final callback = MockCallbackFunction();
      option.addListener(callback.call);

      expect(option.enabled, true, reason: 'Should default to enabled');

      option.enabled = false;
      verify(callback.call).called(1);
      expect(option.enabled, false, reason: 'Should disable option.');

      option.enabled = false;
      verifyNever(callback.call); // Don't notify with the same value
      expect(option.enabled, false, reason: 'Should keep the value.');
    });

    test('Change values', () {
      final callback = MockCallbackFunction();
      option.addListener(callback.call);

      expect(option.values, equals(valuesLabel));

      final newValues = {
        SelectValues.second: (final _) => 'second',
        SelectValues.third: (final _) => 'third',
      };

      option.values = newValues;
      verify(callback.call).called(1);
      expect(option.values, equals(newValues), reason: 'Should change values.');

      option.values = newValues;
      verifyNever(callback.call); // Don't notify with the same value
      expect(option.values, newValues, reason: 'Should keep the values.');
    });

    test('Reset', () {
      final callback = MockCallbackFunction();
      option
        ..value = SelectValues.third
        ..addListener(callback.call);

      expect(option.value, SelectValues.third);

      option.reset();

      verify(callback.call).called(1);
      expect(option.value, option.defaultValue, reason: 'Should reset the value.');
    });
  });

  group('ToggleOption', () {
    late ToggleOption option;

    setUp(() {
      when(() => storage.setBool(key, any())).thenAnswer((final _) async {});
      option = ToggleOption(
        storage: storage,
        key: key,
        label: labelBuilder,
        defaultValue: true,
      );
    });

    tearDown(() {
      reset(storage);
      option.dispose();
    });

    test('Create', () {
      expect(option.value, option.defaultValue, reason: 'Should default to defaultValue.');

      when(() => storage.getBool(key)).thenReturn(true);

      option = ToggleOption(
        storage: storage,
        key: key,
        label: labelBuilder,
        defaultValue: false,
      );

      expect(option.value, true, reason: 'Should load value from storage when available.');
    });

    test('Depend', () {
      final enabled = ValueNotifier(false);
      final callback = MockCallbackFunction();

      option = ToggleOption.depend(
        storage: storage,
        key: key,
        label: labelBuilder,
        defaultValue: true,
        enabled: enabled,
      )..addListener(callback.call);

      expect(option.enabled, enabled.value, reason: 'Should initialize with enabled value.');

      enabled.value = true;
      verify(callback.call).called(1);
      expect(option.enabled, enabled.value, reason: 'Should update the enabled state.');
    });

    test('Update', () {
      final callback = MockCallbackFunction();
      option
        ..addListener(callback.call)
        ..value = false;

      verify(callback.call).called(1);
      verify(() => storage.setBool(key, false)).called(1);
      expect(option.value, false, reason: 'Should update the value.');

      option.value = false;
      verifyNever(callback.call); // Don't notify with the same value
      expect(option.value, false, reason: 'Should keep the value.');
    });

    test('Disable', () {
      final callback = MockCallbackFunction();
      option.addListener(callback.call);

      expect(option.enabled, true, reason: 'Should default to enabled');

      option.enabled = false;
      verify(callback.call).called(1);
      expect(option.enabled, false, reason: 'Should disable option.');

      option.enabled = false;
      verifyNever(callback.call); // Don't notify with the same value
      expect(option.enabled, false, reason: 'Should keep the value.');
    });

    test('Reset', () {
      final callback = MockCallbackFunction();
      option
        ..value = false
        ..addListener(callback.call);

      expect(option.value, false);

      option.reset();

      verify(callback.call).called(1);
      expect(option.value, option.defaultValue, reason: 'Should reset the value.');
    });
  });
}
