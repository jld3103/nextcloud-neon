import 'package:neon/src/settings/models/option.dart';
import 'package:neon/src/settings/models/options_category.dart';
import 'package:neon/src/settings/models/storage.dart';

abstract class NextcloudAppOptions {
  NextcloudAppOptions(this.storage);

  final AppStorage storage;
  late final List<OptionsCategory> categories;
  late final List<Option> options;

  void reset() {
    for (final option in options) {
      option.reset();
    }
  }

  void dispose() {
    for (final option in options) {
      option.dispose();
    }
  }
}
