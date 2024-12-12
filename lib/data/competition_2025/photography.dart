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

List<Challenge> photographyChallenges = [];
