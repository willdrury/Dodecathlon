import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodecathlon/models/quiz_question.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final quizQuestionProvider = StreamProvider<List<QuizQuestion>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return Stream.value([]);
  }
  return FirebaseFirestore.instance
      .collection('quizQuestions')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => QuizQuestion.fromMap(doc.data(), doc.id))
        .toList();
  });
});