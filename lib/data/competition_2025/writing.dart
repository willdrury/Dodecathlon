import 'package:dodecathlon/models/event.dart';
import 'package:flutter/material.dart';

import '../../models/challenge.dart';

Event writing = Event(
  name: 'Writing',
  description: 'Get your creative juices flowing, spend some time reflecting, and practice your writing skills.',
  hasMultipleDifficulties: false,
  themeColor: Colors.orange,
  icon: Icons.auto_awesome,
  startDate: DateTime(2025, 7),
  endDate: DateTime(2025, 8),
    displayImageUrl: ''
);

List<Challenge> miscellaneousChallenges = [];