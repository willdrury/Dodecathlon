import 'package:flutter/Material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_provider.dart';

class ThemeSelectionScreen extends ConsumerStatefulWidget {
  ThemeSelectionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ThemeSelectionScreen();
  }
}

class _ThemeSelectionScreen extends ConsumerState<ThemeSelectionScreen> {

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Theme'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(title: Text('Phone default'), subtitle: Text('default'),),
            ListTile(title: Text('Light mode')),
            ListTile(title: Text('Dark mode')),
          ],
        ),
      ),
    );
  }
}