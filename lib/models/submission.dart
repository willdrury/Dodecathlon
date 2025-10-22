import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

class Submission {

  final String userId;
  final int points;
  final String challengeId;
  final DateTime createdDate;
  final String id;
  bool isVerified;
  bool isBonus;

  Submission({
    required this.userId,
    required this.points,
    required this.challengeId,
    required this.isVerified,
    required this.isBonus,
  }) : createdDate = DateTime.now(),
        id = uuid.v4();

  Submission.all({
    required this.userId,
    required this.points,
    required this.challengeId,
    required this.isVerified,
    required this.createdDate,
    required this.id,
    required this.isBonus,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'challengeId': challengeId,
    'createdDate': createdDate,
    'id': id,
    'isVerified': isVerified,
    'points': points,
    'isBonus': isBonus,
  };

  factory Submission.fromMap(Map data) {
    return Submission.all(
      userId: data['userId'],
      points: data['points'],
      challengeId: data['challengeId'],
      createdDate: DateTime.fromMicrosecondsSinceEpoch((data['createdDate'] as Timestamp).microsecondsSinceEpoch),
      id: data['id'],
      isVerified: data['isVerified'],
      isBonus: data['isBonus'],
    );
  }

  Future<String?> upload() async {
    try {
      await FirebaseFirestore.instance.collection('submissions').doc(id).set(toJson());
    } catch (error) {
      return error.toString();
    }
    return null;
  }

}