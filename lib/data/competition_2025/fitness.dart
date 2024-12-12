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

List<Challenge> fitnessChallenges = [];
