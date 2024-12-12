import 'package:dodecathlon/models/event.dart';
import 'package:flutter/material.dart';

import '../../models/challenge.dart';

Event videoGames = Event(
  name: 'Video Games',
  description: 'Compete against other players and earn points based on your rank. Points awarded for top 5 finishes over the month.',
  hasMultipleDifficulties: true,
  beginnerDescription: 'I do not own any consoles and/or do not play regularly',
  intermediateDescription: 'I own at least one console and/or play regularly',
  advancedDescription: 'I have 3,000+ hours on Smash',
  themeColor: Colors.blueGrey,
  icon: Icons.sports_esports,
  startDate: DateTime(2025, 10),
  endDate: DateTime(2025, 11),
    displayImageUrl: ''
);

List<Challenge> videoGameChallenges = [];