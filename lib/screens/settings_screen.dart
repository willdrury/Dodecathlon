import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dodecathlon/providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {

  const SettingsScreen({super.key,});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          SwitchListTile(
            value: settings[Setting.darkModeEnabled]!,
            onChanged: (isChecked) {
              ref.read(settingsProvider.notifier).setDarkMode(isChecked);
            },
            title: Text(
              'Dark Mode',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'Use dark mode (overrides system default)',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            activeColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(left: 34, right: 22),
          ),
          TextButton.icon(
            label: const Text('Sign Out'),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.black),
          )
        ],
      ),
    );
  }
}