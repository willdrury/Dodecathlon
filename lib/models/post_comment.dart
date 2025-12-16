import 'package:cloud_firestore/cloud_firestore.dart';

class PostComment {
  final String body;
  final DateTime createdAt;
  final String userId;
  final String postId;

  PostComment({
    required this.body,
    required this.createdAt,
    required this.userId,
    required this.postId,
  });

  factory PostComment.fromMap(Map data) {
    return PostComment(
      body: data['body'],
      createdAt: DateTime.fromMicrosecondsSinceEpoch((data['createdAt'] as Timestamp).microsecondsSinceEpoch),
      userId: data['userId'],
      postId: data['postId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'body': body,
    'createdAt': createdAt,
    'userId': userId,
    'postId': postId,
  };

  Future<String?> upload() async {
    try {
      await FirebaseFirestore.instance.collection('post_comments').doc().set(toJson());
    } catch (error) {
      return error.toString();
    }
    return null;
  }

}