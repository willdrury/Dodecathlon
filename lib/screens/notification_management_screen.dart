import 'package:flutter/Material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_provider.dart';

class NotificationManagementScreen extends ConsumerStatefulWidget {
  NotificationManagementScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _NotificationManagementScreenState();
  }
}

class _NotificationManagementScreenState extends ConsumerState<NotificationManagementScreen> {

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Management'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            CheckboxListTile(
              title: Text('All'),
              value:
                settings['comment_notifications'] == true &&
                settings['like_notifications'] == true &&
                settings['new_challenge_notifications'] == true &&
                settings['leaderboard_update_notifications'] == true &&
                settings['challenge_reminders'] == true,
              onChanged: (value) {
                if (value!) {
                  settings = {
                    ...settings,
                    'comment_notifications': value,
                    'like_notifications': value,
                    'new_challenge_notifications': value,
                    'leaderboard_update_notifications': value,
                    'challenge_reminders': value,
                  };
                  ref.read(settingsProvider.notifier).updateSettings(settings);
                }
              },
            ),
            CheckboxListTile(
              title: Text('Comments'),
              value: settings['comment_notifications'],
              onChanged: (value) {
                settings = {...settings, 'comment_notifications': value!};
                ref.read(settingsProvider.notifier).updateSettings(settings);
              },
            ),
            CheckboxListTile(
              title: Text('Likes'),
              value: settings['like_notifications'],
              onChanged: (value) {
                settings = {...settings, 'like_notifications': value!};
                ref.read(settingsProvider.notifier).updateSettings(settings);
              },
            ),
            CheckboxListTile(
              title: Text('New challenge alerts'),
              value: settings['new_challenge_notifications'],
              onChanged: (value) {
                settings = {...settings, 'new_challenge_notifications': value!};
                ref.read(settingsProvider.notifier).updateSettings(settings);
              },
            ),
            CheckboxListTile(
              title: Text('Leaderboard updates'),
              value: settings['leaderboard_update_notifications'],
              onChanged: (value) {
                settings = {...settings, 'leaderboard_update_notifications': value!};
                ref.read(settingsProvider.notifier).updateSettings(settings);
              },
            ),
            CheckboxListTile(
              title: Text('Challenge reminders'),
              value: settings['challenge_reminders'],
              onChanged: (value) {
                settings = {...settings, 'challenge_reminders': value!};
                ref.read(settingsProvider.notifier).updateSettings(settings);
              },
            ),
            // New friend alerts
          ],
        ),
      ),
    );
  }
}