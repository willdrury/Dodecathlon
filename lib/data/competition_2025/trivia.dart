import 'package:dodecathlon/models/event.dart';
import 'package:flutter/material.dart';

import '../../models/challenge.dart';

Event trivia = Event(
  name: 'Trivia',
  description: 'Compete against fellow dodecathletes in the year\'s first synchronous event. Tune-in on the app to answer questions during a live trivia session.',
  hasMultipleDifficulties: false,
  themeColor: Colors.green,
  icon: Icons.quiz,
  startDate: DateTime(2025, 3),
  endDate: DateTime(2025, 4),
  displayImageUrl: ''
);

Challenge liveTrivia = Challenge(
    name: 'Live Trivia',
    id: '02d378d8-4ba0-40b0-85d4-3b7c3a52191e',
    description: 'Tune in to answer questions and score points',
    eventId: trivia.id!,
    difficulty: Difficulty.all,
    maxPoints: 80,
    scoringMechanism: ScoringMechanism.gradated,
    submissionScreen: SubmissionScreen.pageCount,
    isBonus: false,
    isRecurring: false,
    isEditable: false,
    startDate: DateTime.utc(2024, 1, 25),
    endDate: DateTime(2025, 2),
    prerequisiteChallenges: [],
    conflictingChallenges: [],
);

Challenge sporcleQuiz1 = Challenge(
    name: 'Sporcle Quiz',
    id: '7ebd1ef7-2a0f-43c6-acde-6f029d85f1bb',
    description: 'Submit a screenshot of completing the following quiz: ',
    eventId: trivia.id!,
    difficulty: Difficulty.all,
    maxPoints: 80,
    scoringMechanism: ScoringMechanism.gradated,
    submissionScreen: SubmissionScreen.pageCount,
    isBonus: true,
    isRecurring: false,
    isEditable: false,
    startDate: DateTime.utc(2024, 1, 25),
    endDate: DateTime(2025, 2),
    prerequisiteChallenges: [],
    conflictingChallenges: [],
);

Challenge sporcleQuiz2 = Challenge(
    name: 'Sporcle Quiz',
    id: 'a1b95d59-3d07-41f9-a158-d42a934055cb',
    description: 'Submit a screenshot of completing the following quiz: ',
    eventId: trivia.id!,
    difficulty: Difficulty.all,
    maxPoints: 80,
    scoringMechanism: ScoringMechanism.gradated,
    submissionScreen: SubmissionScreen.pageCount,
    isBonus: true,
    isRecurring: false,
    isEditable: false,
    startDate: DateTime.utc(2024, 1, 25),
    endDate: DateTime(2025, 2),
    prerequisiteChallenges: [],
    conflictingChallenges: [],
);

Challenge sporcleQuiz3 = Challenge(
    name: 'Sporcle Quiz',
    id: '2b25fc80-e8ef-4a2b-b28d-a15beea0956b',
    description: 'Submit a screenshot of completing the following quiz: ',
    eventId: trivia.id!,
    difficulty: Difficulty.all,
    maxPoints: 80,
    scoringMechanism: ScoringMechanism.gradated,
    submissionScreen: SubmissionScreen.pageCount,
    isBonus: true,
    isRecurring: false,
    isEditable: false,
    startDate: DateTime.utc(2024, 1, 25),
    endDate: DateTime(2025, 2),
    prerequisiteChallenges: [],
    conflictingChallenges: [],
);

List<Challenge> triviaChallenges = [
  liveTrivia,
  sporcleQuiz1,
  sporcleQuiz2,
  sporcleQuiz3,
];