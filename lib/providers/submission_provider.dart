import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodecathlon/models/submission.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final submissionsProvider = StreamProvider<List<Submission>>((ref) {
  final userStream  = ref.watch(userProvider);
  if (!userStream.hasValue) {
    return Stream.value([]);
  }
  return FirebaseFirestore.instance
      .collection('submissions')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => Submission.fromMap(doc.data()))
        .toList();
  });
});