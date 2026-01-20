import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

class Submission {

  final String userId;
  final int points;
  final String challengeId;
  final DateTime createdDate;
  final String id;
  bool isBonus;
  bool isApproved;

  Submission({
    required this.userId,
    required this.points,
    required this.challengeId,
    required this.isBonus,
    required this.isApproved,
  }) : createdDate = DateTime.now(),
      id = uuid.v4();

  Submission.all({
    required this.userId,
    required this.points,
    required this.challengeId,
    required this.createdDate,
    required this.id,
    required this.isBonus,
    required this.isApproved,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'challengeId': challengeId,
    'createdDate': createdDate,
    'id': id,
    'points': points,
    'isBonus': isBonus,
    'isApproved': isApproved,
  };

  factory Submission.fromMap(Map data) {
    return Submission.all(
      userId: data['userId'],
      points: data['points'],
      challengeId: data['challengeId'],
      createdDate: DateTime.fromMicrosecondsSinceEpoch((data['createdDate'] as Timestamp).microsecondsSinceEpoch),
      id: data['id'],
      isBonus: data['isBonus'],
      isApproved: data['isApproved'],
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

  Future<String?> delete() async {
    try {
      await FirebaseFirestore.instance.collection('submissions').doc(id).delete();
    } catch (error) {
      return error.toString();
    }
    return null;
  }

}