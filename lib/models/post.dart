import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodecathlon/models/user.dart';

class Post {
  final String userId;
  final String title;
  final DateTime createdAt;
  final String? description;
  final String? imageUrl;
  final String id;
  final List<String> likes;
  final String? submissionId;
  User? user;
  bool highlighted;
  bool reported;

  Post({
    required this.userId,
    required this.title,
    required this.createdAt,
    required this.id,
    required this.likes,
    required this.highlighted,
    required this.reported,
    this.submissionId,
    this.description,
    this.imageUrl,
    this.user,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'title': title,
    'createdAt': createdAt,
    'description': description,
    'imageUrl': imageUrl,
    'id': id,
    'submissionId': submissionId,
    'highlighted': highlighted,
    'reported': reported,
    'likes': likes
  };

  factory Post.fromMap(Map data) {
    return Post(
      userId: data['userId'],
      title: data['title'],
      createdAt: DateTime.fromMicrosecondsSinceEpoch((data['createdAt'] as Timestamp).microsecondsSinceEpoch),
      description: data['description'],
      imageUrl: data['imageUrl'],
      submissionId: data['submissionId'],
      id: data['id'],
      highlighted: data['highlighted'],
      reported: data['reported'],
      likes: List<String>.from(data['likes'] as List<dynamic>),
    );
  }

  Future<String?> upload() async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(id).set(toJson());
    } catch (error) {
      return error.toString();
    }
    return null;
  }

  Future<String?> delete() async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(id).delete();
    } catch (error) {
      return error.toString();
    }
    return null;
  }
}