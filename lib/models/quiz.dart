import 'package:cloud_firestore/cloud_firestore.dart';

class Quiz {

  final String name;
  final String description;
  final DateTime createdAt;
  final List<String> questions;
  final String id;

  Quiz({
    required this.name,
    required this.description,
    required this.createdAt,
    required this.questions,
    required this.id,
  });

  factory Quiz.fromMap(Map data, String id) {
    try {
      return Quiz(
        name: data['name'],
        description: data['description'],
        createdAt: DateTime.fromMicrosecondsSinceEpoch((data['createdAt'] as Timestamp).microsecondsSinceEpoch),
        questions: List<String>.from(data['questions'] as List<dynamic>),
        id: id
      );
    } catch (e) {
      print('Error converting Quiz from JSON: ${e.toString()}');
      rethrow;
    }
  }
}