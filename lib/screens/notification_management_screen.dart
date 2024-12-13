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
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Management'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(title: Text('All'), subtitle: Text('default'),),
            ListTile(title: Text('None')),
            ListTile(title: Text('Comments')),
            ListTile(title: Text('Likes')),
            ListTile(title: Text('New challenge alerts')),
            ListTile(title: Text('Leaderboard updates')),
            ListTile(title: Text('Challenge reminders')),
          ],
        ),
      ),
    );
  }
}