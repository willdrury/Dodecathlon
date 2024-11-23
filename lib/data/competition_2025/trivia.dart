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
  endDate: DateTime(2025, 4)
);

List<Challenge> triviaChallenges = [];