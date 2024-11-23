import 'package:dodecathlon/data/demo_data/demo_notifications.dart';
import 'package:dodecathlon/widgets/notification_list_tile.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
          itemCount: demoNotifications.length,
          itemBuilder: (ctx, i) {
            return NotificationListTile(notification: demoNotifications[i]);
          })
    );
  }
}