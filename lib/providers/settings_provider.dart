import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Setting {
  darkModeEnabled,
}

class SettingsProvider extends StateNotifier<Map<Setting, bool>> {
  SettingsProvider() : super({
    Setting.darkModeEnabled: false,
  });

  void setDarkMode(bool isActive) {
    state = {
      ...state,
      Setting.darkModeEnabled: isActive,
    };
  }
}

final settingsProvider = StateNotifierProvider<SettingsProvider, Map<Setting, bool>>((ref) {
  return SettingsProvider();
});