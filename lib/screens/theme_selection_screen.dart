import 'package:dodecathlon/models/user_settings.dart' as dd;
import 'package:flutter/Material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_provider.dart';

class ThemeSelectionScreen extends ConsumerStatefulWidget {
  const ThemeSelectionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ThemeSelectionScreen();
  }
}

class _ThemeSelectionScreen extends ConsumerState<ThemeSelectionScreen> {

  dd.ThemeMode? _currentTheme;

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> settings = ref.watch(settingsProvider);
    if (settings['theme'] != null) {
      _currentTheme = dd.stringToTheme(settings['theme']);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Theme'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            RadioListTile<dd.ThemeMode>(
              title: const Text('System Default'),
              value: dd.ThemeMode.system,
              groupValue: _currentTheme,
              onChanged: (dd.ThemeMode? value) {
                setState(() {
                  _currentTheme = value;
                  settings = {...settings, 'theme': 'system'};
                  ref.read(settingsProvider.notifier).updateSettings(settings);
                });
              },
            ),
            RadioListTile<dd.ThemeMode>(
              title: const Text('Light'),
              value: dd.ThemeMode.light,
              groupValue: _currentTheme,
              onChanged: (dd.ThemeMode? value) {
                setState(() {
                  _currentTheme = value;
                  settings = {...settings, 'theme': 'light'};
                  ref.read(settingsProvider.notifier).updateSettings(settings);
                });
              },
            ),
            RadioListTile<dd.ThemeMode>(
              title: const Text('Dark'),
              value: dd.ThemeMode.dark,
              groupValue: _currentTheme,
              onChanged: (dd.ThemeMode? value) async {
                settings = {...settings, 'theme': 'dark'};
                ref.read(settingsProvider.notifier).updateSettings(settings);
                setState(() {
                  _currentTheme = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}