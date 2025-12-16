import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post_comment.dart';

final postCommentsProvider = StreamProvider<List<PostComment>>((ref) {
  return FirebaseFirestore.instance
      .collection('post_comments')
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
          .map((doc) => PostComment.fromMap(doc.data()))
          .toList();
      });
});