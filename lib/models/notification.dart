import 'package:dodecathlon/models/user.dart';

class Notification {
  final String title;
  final String body;
  final User user;
  final DateTime createdAt;
  bool isRead;

  Notification({
    required this.title,
    required this.body,
    required this.user,
    required this.createdAt,
    required this.isRead,
  });
}