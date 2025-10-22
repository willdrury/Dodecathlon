import 'package:dodecathlon/models/event.dart';
import 'package:flutter/material.dart';

import '../../models/challenge.dart';

Event meditation = Event(
  name: 'Meditation',
  description: 'Meditate',
  hasMultipleDifficulties: true,
  beginnerDescription: '5 min a day',
  intermediateDescription: '15 min a day',
  advancedDescription: '30 min a day',
  themeColor: Colors.teal,
  icon: Icons.extension,
  startDate: DateTime(2025, 12),
  endDate: DateTime(2026, 1),
  displayImageUrl: ''
);

List<Challenge> meditationChallenges = [];