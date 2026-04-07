import 'package:dodecathlon/providers/notification_provider.dart';
import 'package:dodecathlon/widgets/notification_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dodecathlon/models/notification.dart' as dd;

import '../models/user.dart';
import '../providers/user_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<User?> userStream = ref.watch(userProvider);
    if (!userStream.hasValue) {
      return const Center(child: CircularProgressIndicator(),);
    }

    User user = userStream.value!;

    AsyncValue<List<dd.Notification>> notificationsStream = ref.watch(notificationProvider);
    if (!notificationsStream.hasValue) {
      // TODO: Logging
      return Center(child: CircularProgressIndicator(),);
    }

    List<dd.Notification> notifications = notificationsStream.value!.where((n) =>
      n.user == user.id
    ).toList();

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