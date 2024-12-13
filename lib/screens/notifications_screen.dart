import 'package:dodecathlon/providers/notification_provider.dart';
import 'package:dodecathlon/widgets/notification_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dodecathlon/models/notification.dart' as dd;

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<dd.Notification> notifications = ref.watch(notificationProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: notifications.isNotEmpty
        ? ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (ctx, i) {
              return NotificationListTile(notification: notifications[i]);
            })
        : Center(child: Text('Looks like you are all caught up!'))
    );
  }
}