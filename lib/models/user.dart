import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/submission.dart';
import 'package:dodecathlon/utilities/image_utility.dart';

class User {

  final String userName;
  final String email;
  List<int> currentEventPoints;
  List<int> currentCompetitionPoints;
  List<String> submissions;
  List<String> friends;
  Difficulty? currentEventDifficulty;
  String? profileImageUrl;
  List<String>? competitions;
  final String? id;
  List<Submission>? submissionData;
  List<String> likedPostIds;
  DateTime createdDate;

  User({
    required this.userName,
    required this.email,
    required this.currentEventPoints,
    required this.currentCompetitionPoints,
    required this.submissions,
    required this.friends,
    required this.likedPostIds,
    required this.createdDate,
    this.profileImageUrl,
    this.competitions,
    this.currentEventDifficulty,
    this.id,
  });

  Map<String, dynamic> toJson() => {
    'userName': userName,
    'email': email,
    'currentEventPoints': currentEventPoints,
    'currentCompetitionPoints': currentCompetitionPoints,
    'friends': friends,
    'currentEventDifficulty': currentEventDifficulty,
    'profileImageUrl': profileImageUrl,
    'submissions': submissions,
    'competitions': competitions,
    'id': id,
    'likedPostIds': likedPostIds,
    'createdDate': createdDate,
  };

  factory User.fromMap(Map data) {
    return User(
      userName: data['userName'],
      email: data['email'],
      currentEventPoints: List<int>.from(data['currentEventPoints'] as List<dynamic>),
      currentCompetitionPoints: List<int>.from(data['currentCompetitionPoints'] as List<dynamic>),
      friends: List<String>.from(data['friends'] as List<dynamic>),
      currentEventDifficulty: getDifficultyFromString(data['currentEventDifficulty']),
      profileImageUrl: data['profileImageUrl'],
      submissions: List<String>.from(data['submissions'] as List<dynamic>),
      competitions: List<String>.from(data['competitions'] as List<dynamic>),
      id: data['id'],
      likedPostIds: List<String>.from(data['likedPostIds'] as List<dynamic>),
      createdDate: DateTime.fromMicrosecondsSinceEpoch((data['createdDate'] as Timestamp).microsecondsSinceEpoch),
    );
  }

  int get eventRank {
    return 1;
  }

  int get competitionRank {
    return 1;
  }

  Future<String?> update() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(id).update(toJson());
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  Future<String?> updateProfileImage (File profileImage, String path) async {
    final String? imageUrl = await ImageUtility().uploadImage(path, profileImage);

    if (imageUrl == null) return null;
    await FirebaseFirestore.instance.collection('users').doc(id).update({
      'profileImageUrl': imageUrl,
    });
    return null;
  }
  
  Future<List<Submission>> getSubmissions() async {
    if (submissionData != null) return submissionData!;
    if (submissions.isEmpty) return [];
    final querySnapshot = await FirebaseFirestore.instance.collection('submissions').where('id', whereIn: submissions).where('userId', isEqualTo: id).get();
    submissionData = querySnapshot.docs.map((snapshot) => Submission.fromMap(snapshot.data())).toList();
    return submissionData!;
  }

}