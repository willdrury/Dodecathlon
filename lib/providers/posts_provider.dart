import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodecathlon/models/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postsProvider = StreamProvider<List<Post>>((ref) {
  return FirebaseFirestore.instance
      .collection('posts')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => Post.fromMap(doc.data()))
        .toList();
  });
});