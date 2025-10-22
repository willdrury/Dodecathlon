import 'package:dodecathlon/models/event.dart';
import 'package:flutter/material.dart';

import '../../models/challenge.dart';

Event photography = Event(
  name: 'Photography',
  description: 'Get outside and appreciate the beauty of spring with daily photo challenges. Culminates with a photography competition judged by fellow dodecathletes.',
  hasMultipleDifficulties: true,
  beginnerDescription: 'I do not own a camera',
  intermediateDescription: 'I own a camera',
  advancedDescription: 'I own multiple cameras',
  themeColor: Colors.purple,
  icon: Icons.photo_camera,
  startDate: DateTime(2025, 4),
  endDate: DateTime(2025, 5),
  displayImageUrl: ''
);

Challenge dailyPhoto1 = Challenge(
    name: 'Daily Photo',
    id: '814df04f-8cb5-4584-af78-ba3d2b0ee467',
    description: 'Submit a photo you took today!',
    eventId: photography.id!,
    difficulty: Difficulty.all,
    maxPoints: 1,
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

List<Challenge> photographyChallenges = [
  for (int i = 1; i <= 31; i++)
    Challenge(
      name: 'Daily Photo $i',
      id: '859b7a24-3350-403e-98b9-0101c44ef615',
      description: 'Submit a photo you took today!',
      eventId: photography.id!,
      difficulty: Difficulty.all,
      maxPoints: 5,
      scoringMechanism: ScoringMechanism.gradated,
      submissionScreen: SubmissionScreen.pageCount,
      isBonus: false,
      isRecurring: false,
      isEditable: false,
      startDate: DateTime.utc(2024, 1, 25),
      endDate: DateTime(2025, 2),
      prerequisiteChallenges: [],
      conflictingChallenges: [],
    ),
];
