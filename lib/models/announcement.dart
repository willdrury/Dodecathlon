import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String title;
  final String body;
  final DateTime createdAt;

  Announcement({
    required this.title,
    required this.body,
    required this.createdAt,
  });

  factory Announcement.fromMap(Map data) {
    return Announcement(
      title: data['title'],
      body: data['body'],
      createdAt: DateTime.fromMicrosecondsSinceEpoch((data['createdAt'] as Timestamp).microsecondsSinceEpoch),
    );
  }

}