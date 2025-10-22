import 'package:dodecathlon/models/event.dart';
import 'package:flutter/material.dart';

import '../../models/challenge.dart';

Event volunteering = Event(
  name: 'Volunteering',
  description: 'Take a break from competing and spend time helping others for Mental Health Awareness Month. Designed to encourage social activism and promote mental health.',
  hasMultipleDifficulties: false,
  themeColor: Colors.indigo,
  icon: Icons.volunteer_activism,
  startDate: DateTime(2025, 5),
  endDate: DateTime(2025, 6),
  displayImageUrl: ''
);

Challenge inPersonVolunteering = Challenge(
    name: 'Attend in person event',
    id: '5b1c60fa-ac6b-42d6-89de-fcc1624fc800',
    description: 'Attend an in person volunteering event and upload evidence of your attendance.',
    eventId: volunteering.id!,
    difficulty: Difficulty.all,
    maxPoints: 10,
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

Challenge carePackage = Challenge(
    name: 'Send a care package',
    id: '15ddda1d-5a12-4c07-ac9e-cdd97d21568d',
    description: 'Send a care package to someone',
    eventId: volunteering.id!,
    difficulty: Difficulty.all,
    maxPoints: 10,
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

Challenge clothingDonation = Challenge(
    name: 'Donate Clothing',
    id: 'fa8546ce-0df8-4355-b4cc-f6d718f95002',
    description: 'Donate clothing',
    eventId: volunteering.id!,
    difficulty: Difficulty.all,
    maxPoints: 10,
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

Challenge bloodDonation = Challenge(
    name: 'Blood donation',
    id: 'dff2e1b8-ffa3-4fd1-bee4-86bef2dbfc26',
    description: 'Donate blood or plasma',
    eventId: volunteering.id!,
    difficulty: Difficulty.all,
    maxPoints: 10,
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

Challenge sidewalkChalk = Challenge(
    name: 'Sidewalk chalk messages',
    id: '98302d1e-ede1-4d9d-9581-32991e79d21a',
    description: 'Write positive messages with sidewalk chalk around your neighborhood',
    eventId: volunteering.id!,
    difficulty: Difficulty.all,
    maxPoints: 10,
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

Challenge sendALetter = Challenge(
    name: 'Send a Letter',
    id: '1122a7ec-bea0-4920-b0bc-740aac21c272',
    description: 'Send a letter to someone you know. It could be a thank you, something silly, or an appreciation for having them in your life. Totally up to you!',
    eventId: volunteering.id!,
    difficulty: Difficulty.all,
    maxPoints: 10,
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

List<Challenge> volunteeringChallenges = [
  inPersonVolunteering,
  carePackage,
  clothingDonation,
  bloodDonation,
  sidewalkChalk,
  sendALetter,
];