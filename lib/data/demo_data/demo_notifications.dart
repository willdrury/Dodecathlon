import 'package:dodecathlon/data/demo_data/demo_users.dart';
import 'package:dodecathlon/models/notification.dart';

Notification newComment1 = Notification(
    title: 'You have a new comment on your post!',
    body: 'Donal Trump commented: Nobody cares. Go back to Canada loser',
    user: biw,
    createdAt: DateTime.now(),
    isRead: true,
);

Notification newComment2 = Notification(
  title: 'You have a new comment on your post!',
  body: 'Kamala Harris commented: Great work! Don\'t listen to the idiot above me',
  user: biw,
  createdAt: DateTime.now(),
  isRead: false,
);

List<Notification> demoNotifications = [
  newComment1,
  newComment2,
];