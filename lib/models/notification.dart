import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  final String title;
  final String body;
  final String user;
  final DateTime createdAt;
  bool isRead;

  Notification({
    required this.title,
    required this.body,
    required this.user,
    required this.createdAt,
    required this.isRead,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'body': body,
    'user': user,
    'createdAt': createdAt,
    'isRead': isRead,
  };

  factory Notification.fromMap(Map data) {
    return Notification(
      title: data['title'],
      body: data['body'],
      user: data['user'],
      createdAt: DateTime.fromMicrosecondsSinceEpoch((data['createdDate'] as Timestamp).microsecondsSinceEpoch),
      isRead: data['isRead'],
    );
  }
}