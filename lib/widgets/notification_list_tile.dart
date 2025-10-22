import 'package:dodecathlon/screens/notification_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:dodecathlon/models/notification.dart' as dd;


class NotificationListTile extends StatefulWidget {
  const NotificationListTile({super.key, required this.notification});

  final dd.Notification notification;

  @override
  State<NotificationListTile> createState() => _NotificationListTileState();
}

class _NotificationListTileState extends State<NotificationListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.notification.title, style: widget.notification.isRead ? null : TextStyle(fontWeight: FontWeight.bold),),
      subtitle: Text(widget.notification.body, overflow: TextOverflow.ellipsis,),
      onTap: () {
        setState(() {
          widget.notification.isRead = true;
        });
        Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => NotificationDetailsScreen(notification: widget.notification))
        );
      },
    );
  }
}