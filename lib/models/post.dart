import 'package:dodecathlon/models/user.dart';

class Post {
  final User user;
  final String title;
  final DateTime createdAt;
  final String? description;
  final String? imageUrl;

  Post({
    required this.user,
    required this.title,
    required this.createdAt,
    this.description,
    this.imageUrl,
  });
}