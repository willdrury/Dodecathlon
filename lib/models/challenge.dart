import 'package:dodecathlon/screens/challenge_submission_screens/book_completion.dart';
import 'package:dodecathlon/screens/challenge_submission_screens/event_attendance_submission_screen.dart';
import 'package:dodecathlon/screens/challenge_submission_screens/page_count_submission_screen.dart';
import 'package:dodecathlon/screens/challenge_submission_screens/quiz_submission_screen.dart';
import 'package:dodecathlon/screens/challenge_submission_screens/written_review_submission_screen.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../screens/challenge_submission_screens/photo_upload_submission_screen.dart';

Uuid uuid = Uuid();

class Challenge {

  final String name;
  final String id;
  final String description;
  final String eventId;
  final Difficulty difficulty;
  final int maxPoints;
  final bool isBonus;
  final bool isRecurring;
  final bool isEditable;
  final ScoringMechanism scoringMechanism;
  final SubmissionScreen submissionScreen;
  final DateTime startDate;
  final DateTime endDate;
  final Enforcement? enforcement;
  final String? imageUrl;
  final List<String> prerequisiteChallenges;
  final List<String> conflictingChallenges;

  Challenge({
    required this.name,
    required this.id,
    required this.description,
    required this.eventId,
    required this.difficulty,
    required this.maxPoints,
    required this.scoringMechanism,
    required this.submissionScreen,
    required this.isBonus,
    required this.isRecurring,
    required this.isEditable,
    required this.startDate,
    required this.endDate,
    required this.prerequisiteChallenges,
    required this.conflictingChallenges,
    this.enforcement,
    this.imageUrl,
  });

  factory Challenge.fromMap(Map data, String id) {
    return Challenge(
      name: data['name'],
      description: data['description'],
      eventId: data['eventId'],
      difficulty: getDifficultyFromString(data['difficulty']),
      maxPoints: data['maxPoints'],
      scoringMechanism: getScoringMechanismFromString(data['scoringMechanism']),
      submissionScreen: getSubmissionScreenFromString(data['submissionScreen']),
      isBonus: data['isBonus'],
      isRecurring: data['isRecurring'],
      isEditable: data['isEditable'],
      startDate: DateTime.parse((data['startDate'])),
      endDate: DateTime.parse((data['endDate'])),
      prerequisiteChallenges: List<String>.from(data['prerequisiteChallenges']),
      conflictingChallenges: List<String>.from(data['conflictingChallenges']),
      enforcement: getEnforcementFromString(data['enforcement']),
      imageUrl: data['displayImageUrl'],
      id: id
    );
  }

  Widget getSubmissionScreen(Map<dynamic, dynamic> args) {
    switch (submissionScreen) {
      case SubmissionScreen.photoUpload:
        return PhotoUploadSubmissionScreen(challenge: args['challenge']);
      case SubmissionScreen.quiz:
        return QuizSubmissionScreen(challenge: args['challenge']);
      case SubmissionScreen.writtenReview:
        return WrittenReviewSubmissionScreen(challenge: args['challenge']);
      case SubmissionScreen.inPersonEventAttendance:
        return EventAttendanceSubmissionScreen(challenge: args['challenge'],);
      case SubmissionScreen.pageCount:
        return PageCountSubmissionScreen(challenge: args['challenge'],);
      case SubmissionScreen.bookCompletion:
        return BookCompletionScreen(challenge: args['challenge'],);
    }
  }
}

enum Difficulty {
  beginner,
  intermediate,
  advanced,
  all,
}

enum ScoringMechanism {
  completion,
  gradated,
  ranked,
  custom,
}

enum Enforcement {
  quiz,
  link,
  photo,
  partner,
  none,
}

enum SubmissionScreen {
  photoUpload,
  quiz,
  writtenReview,
  inPersonEventAttendance,
  pageCount,
  bookCompletion,
}

Difficulty getDifficultyFromString(String? value) {
  switch(value) {
    case 'beginner':
      return Difficulty.beginner;
    case 'intermediate':
      return Difficulty.intermediate;
    case 'advanced':
      return Difficulty.advanced;
  }
  return Difficulty.all;
}

ScoringMechanism getScoringMechanismFromString(String? value) {
  switch(value) {
    case 'completion':
      return ScoringMechanism.completion;
    case 'gradated':
      return ScoringMechanism.gradated;
    case 'custom':
      return ScoringMechanism.custom;
    case 'ranked':
      return ScoringMechanism.ranked;
  }
  return ScoringMechanism.completion;
}

Enforcement getEnforcementFromString(String? value) {
  switch(value) {
    case 'quiz':
      return Enforcement.quiz;
    case 'partner':
      return Enforcement.partner;
    case 'link':
      return Enforcement.link;
    case 'photo':
      return Enforcement.photo;
    case 'none':
      return Enforcement.none;
  }
  return Enforcement.none;
}

SubmissionScreen getSubmissionScreenFromString(String? value) {
  switch(value) {
    case 'photoUpload':
      return SubmissionScreen.photoUpload;
    case 'quiz':
      return SubmissionScreen.quiz;
    case 'bookCompletion':
      return SubmissionScreen.bookCompletion;
    case 'pageCount':
      return SubmissionScreen.pageCount;
    case 'inPersonEventAttendance':
      return SubmissionScreen.inPersonEventAttendance;
    case 'writtenReview':
      return SubmissionScreen.writtenReview;
  }
  return SubmissionScreen.photoUpload;
}