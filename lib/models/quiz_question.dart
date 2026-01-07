import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class QuizQuestion {

  final String body;
  final DateTime createdAt;
  final Map<int, String> answers; // Correct answer will always have ID of 0
  final String id;
  final String? displayImageUrl;

  QuizQuestion({
    required this.body  ,
    required this.createdAt,
    required this.answers,
    required this.id,
    this.displayImageUrl,
  });

  factory QuizQuestion.fromMap(Map data, String id) {
    try {
      return QuizQuestion(
        body: data['body'],
        createdAt: DateTime.fromMicrosecondsSinceEpoch((data['createdAt'] as Timestamp).microsecondsSinceEpoch),
        answers: Map<int, String>.from(data['answers'] as Map<dynamic, dynamic>),
        id: id,
        displayImageUrl: data['displayImageUrl']
      );
    } catch (e) {
      print('Error converting QuizQuestion from JSON: ${e.toString()}');
    }
    throw Exception(); // TODO: Better exception handling, or handle somewhere else
  }
}