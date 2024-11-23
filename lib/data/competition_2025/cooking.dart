import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/event.dart';
import 'package:flutter/material.dart';

Event cooking = Event(
    name: 'Cooking',
    description: 'Elevate your cooking game and focus on your diet! Points awarded for using unique ingredients, completing bonus recipes, and engaging with your community.',
    hasMultipleDifficulties: true,
    beginnerDescription: 'Salt? Never heard of it.',
    intermediateDescription: 'Yeah, I use salt 😏',
    advancedDescription: 'I only use Fleur De Sel, thank you very much.',
    themeColor: Colors.brown,
    icon: Icons.local_fire_department,
    startDate: DateTime(2025, 9),
    endDate: DateTime(2025, 10)
);

List<Challenge> cookingChallenges = [];