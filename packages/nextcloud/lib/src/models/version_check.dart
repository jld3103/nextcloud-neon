import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';
import 'package:version/version.dart';

/// Holds the [versions], [minimumVersion] of an app.
@immutable
class VersionCheck {
  /// Creates a new [VersionCheck].
  const VersionCheck({
    required this.versions,
    required this.minimumVersion,
    bool? isSupportedOverride,
  }) : _isSupportedOverride = isSupportedOverride;

  /// Current version of the app.
  final BuiltList<Version>? versions;

  /// Minimum version of the app.
  final Version minimumVersion;

  /// Overrides the check if the current version is supported.
  final bool? _isSupportedOverride;

  /// Whether the [versions] is allowed by the [minimumVersion].
  ///
  /// If [versions] is `null` or empty it is assumed that the app is supported.
  /// Only one of the [versions] has to be supported to return `true`.
  bool get isSupported {
    if (_isSupportedOverride != null) {
      return _isSupportedOverride;
    }

    if (versions == null || versions!.isEmpty) {
      return true;
    }

    for (final version in versions!) {
      if (version >= minimumVersion) {
        return true;
      }
    }

    return false;
  }

  @override
  bool operator ==(Object other) =>
      other is VersionCheck &&
      other.versions == versions &&
      other.minimumVersion == minimumVersion &&
      other._isSupportedOverride == _isSupportedOverride;

  @override
  int get hashCode => Object.hashAll([
        versions,
        minimumVersion,
        _isSupportedOverride,
      ]);
}
