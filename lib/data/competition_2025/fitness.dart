import 'package:dodecathlon/models/event.dart';
import 'package:flutter/material.dart';

import '../../models/challenge.dart';

Event fitness = Event(
  name: 'Fitness',
  description: 'Stay on top of your workout goals with simple body weight exercises. Culminates with a classic CrossFit workout with varying levels of difficulty.',
  hasMultipleDifficulties: true,
  beginnerDescription: 'Cannot do a pull-up',
  intermediateDescription: 'Can do 5-10 pull-ups at a time',
  advancedDescription: 'Can do multiple high-rep sets of pull-ups',
  themeColor: Colors.blue,
  icon: Icons.directions_walk,
  startDate: DateTime(2025, 2),
  endDate: DateTime(2025, 3),
    displayImageUrl: ''
);

Challenge beginnerWorkout = Challenge(
    name: 'Running-Sandwich',
    id: 'd6e25269-57ce-4f7a-9f9c-3661075e9535',
    description: 'Complete the following body weight workout for time: For time:'
        '\n400m run'
        '\n40 air squats'
        '\n30 sit-ups'
        '\n20 burpees'
        '\n10 pull-ups'
        '\n400m run',
    eventId: fitness.id!,
    difficulty: Difficulty.beginner,
    maxPoints: 40,
    scoringMechanism: ScoringMechanism.gradated,
    submissionScreen: SubmissionScreen.pageCount,
    isBonus: false,
    isRecurring: false,
    isEditable: true,
    startDate: DateTime.utc(2024, 1, 25),
    endDate: DateTime(2025, 2),
    prerequisiteChallenges: [],
    conflictingChallenges: [],
);

Challenge halfMurph = Challenge(
    name: 'Half-MURPH',
    id: '8ef0ad69-fc67-475c-ae16-0f82c0152020',
    description: 'Complete half of the classic Cross-Fit workout, the MURPH',
    eventId: fitness.id!,
    difficulty: Difficulty.intermediate,
    maxPoints: 60,
    scoringMechanism: ScoringMechanism.gradated,
    submissionScreen: SubmissionScreen.pageCount,
    isBonus: false,
    isRecurring: false,
    isEditable: true,
    startDate: DateTime.utc(2024, 1, 25),
    endDate: DateTime(2025, 2),
    prerequisiteChallenges: [],
    conflictingChallenges: [],
);

Challenge fullMurph = Challenge(
    name: 'MURPH',
    id: 'e618ca37-d6ea-48ad-92c6-b80e31e146ff',
    description: 'Complete the classic Cross-Fit workout, the MURPH',
    eventId: fitness.id!,
    difficulty: Difficulty.advanced,
    maxPoints: 80,
    scoringMechanism: ScoringMechanism.gradated,
    submissionScreen: SubmissionScreen.pageCount,
    isBonus: false,
    isRecurring: false,
    isEditable: true,
    startDate: DateTime.utc(2024, 1, 25),
    endDate: DateTime(2025, 2),
    prerequisiteChallenges: [],
    conflictingChallenges: [],
);

List<Challenge> fitnessChallenges = [
  halfMurph,
  fullMurph,
];
