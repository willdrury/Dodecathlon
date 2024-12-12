import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/event.dart';
import 'package:flutter/material.dart';

Event chess = Event(
    name: 'Chess',
    description: 'Train your brain to compete in one of the world\'s oldest strategy games. Main event is a virtual chess tournament played against fellow dodecathletes.',
    hasMultipleDifficulties: false,
    themeColor: Colors.cyan,
    icon: Icons.psychology,
    startDate: DateTime(2025, 6),
    endDate: DateTime(2025, 7),
    displayImageUrl: ''
);

List<Challenge> chessChallenges = [];
