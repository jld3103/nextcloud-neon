import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:neon_framework/src/platform/platform.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:web/web.dart';

/// Android specific platform information.
///
/// See:
///   * [NeonPlatform] to initialize and acquire an instance
///   * `LinuxNeonPlatform` for the Linux implementation
///   * `IOSNeonPlatform` for the IOS implementation
///   * `AndroidNeonPlatform` for the Android implementation
@immutable
@internal
final class WebNeonPlatform implements NeonPlatform {
  /// Creates a new Web Neon platform.
  const WebNeonPlatform();

  /// Registers this platform.
  @visibleForTesting
  static void registerWith(dynamic registrar) {
    NeonPlatform.instance = const WebNeonPlatform();
  }

  @override
  bool get canUseCamera => false;

  @override
  bool get canUsePushNotifications => false;

  @override
  bool get canUseQuickActions => false;

  @override
  bool get canUseWebView => false;

  @override
  bool get canUseWindowManager => false;

  @override
  bool get canUseSharing => false;

  @override
  bool get canUsePaths => false;

  @override
  Future<void> init() async {
    databaseFactory = databaseFactoryFfiWeb;
  }

  @override
  Future<String?> saveFileWithPickDialog(String fileName, String mimeType, Uint8List data) async {
    final anchor = HTMLAnchorElement()
      ..href = 'data:$mimeType;base64,${base64.encode(data)}'
      ..target = 'blank'
      ..download = fileName;

    document.body!.appendChild(anchor);

    anchor
      ..click()
      ..remove();

    return fileName;
  }
}
