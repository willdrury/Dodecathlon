import 'package:dodecathlon/models/event.dart';
import 'package:dodecathlon/screens/challenge_submission_screens/book_completion.dart';
import 'package:dodecathlon/screens/challenge_submission_screens/event_attendance_submission_screen.dart';
import 'package:dodecathlon/screens/challenge_submission_screens/page_count_submission_screen.dart';
import 'package:dodecathlon/screens/challenge_submission_screens/quiz_submission_screen.dart';
import 'package:dodecathlon/screens/challenge_submission_screens/written_review_submission_screen.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

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
}

enum SubmissionScreen {
  quiz,
  writtenReview,
  inPersonEventAttendance,

  // Reading
  pageCount,
  bookCompletion,
}

class Challenge {

  final String name;
  final String id;
  final String description;
  final Event event;
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

  Challenge({
    required this.name,
    required this.id,
    required this.description,
    required this.event,
    required this.difficulty,
    required this.maxPoints,
    required this.scoringMechanism,
    required this.submissionScreen,
    required this.isBonus,
    required this.isRecurring,
    required this.isEditable,
    required this.startDate,
    required this.endDate,
    this.enforcement,
    this.imageUrl,
  });

  Widget getSubmissionScreen(Map<dynamic, dynamic> args) {
    switch (submissionScreen) {
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

Difficulty getDifficultyEnumFromString(String diff) {
  switch(diff) {
    case 'beginner':
      return Difficulty.beginner;
    case 'intermediate':
      return Difficulty.intermediate;
    case 'advanced':
      return Difficulty.advanced;
  }
  return Difficulty.all;
}