import 'package:dodecathlon/models/event.dart';
import 'package:flutter/material.dart';

import '../../models/challenge.dart';

Event running = Event(
  name: 'Running',
  description: 'Get your body moving and enjoy some fall weather. Culminates with an optional race, with advanced runners competing in a marathon!',
  hasMultipleDifficulties: true,
  beginnerDescription: 'I don\'t currently run',
  intermediateDescription: 'I would like to get into running or I want to improve my training',
  advancedDescription: 'I have trained seriously and am ready to complete a marathon',
  themeColor: Colors.lightGreen,
  icon: Icons.directions_run,
  startDate: DateTime(2025, 11),
  endDate: DateTime(2025, 12),
  displayImageUrl: ''
);

List<Challenge> runningChallenges = [];