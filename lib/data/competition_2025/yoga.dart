import 'package:dodecathlon/models/event.dart';
import 'package:flutter/material.dart';

import '../../models/challenge.dart';

Event yoga = Event(
  name: 'Yoga',
  description: 'Spend a little time each day focusing on your physical and mental health. Points awarded for consistency over the course of the month.',
  hasMultipleDifficulties: true,
  beginnerDescription: 'I have never done yoga',
  intermediateDescription: 'I have tried yoga a few times but do not practice regularly',
  advancedDescription: 'I do yoga nearly every day or would like to start doing so',
  themeColor: Colors.pink,
  icon: Icons.self_improvement,
  startDate: DateTime(2025, 8),
  endDate: DateTime(2025, 9),
  displayImageUrl: ''
);

List<Challenge> yogaChallenges = [];