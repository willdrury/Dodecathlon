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

List<Challenge> volunteeringChallenges = [];