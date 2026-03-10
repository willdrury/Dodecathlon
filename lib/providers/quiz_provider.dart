import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodecathlon/models/quiz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final quizProvider = StreamProvider<List<Quiz>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return Stream.value([]);
  }
  return FirebaseFirestore.instance
      .collection('quizzes')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => Quiz.fromMap(doc.data(), doc.id))
        .toList();
  });
});