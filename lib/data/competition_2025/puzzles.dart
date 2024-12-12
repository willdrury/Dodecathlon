import 'package:dodecathlon/models/event.dart';
import 'package:flutter/material.dart';

import '../../models/challenge.dart';

Event puzzles = Event(
  name: 'Puzzles',
  description: 'Relax and enjoy some fun puzzles, courtesy of the New York Times. Bonus puzzles also available.',
  hasMultipleDifficulties: true,
  beginnerDescription: 'Sudoku? Doesn\'t that involve math?',
  intermediateDescription: 'I have a 100+ day streak on Wordle right now',
  advancedDescription: 'I solved the NYT Sunday crossword yesterday. Without any hints.',
  themeColor: Colors.teal,
  icon: Icons.extension,
  startDate: DateTime(2025, 12),
  endDate: DateTime(2026, 1),
  displayImageUrl: ''
);

List<Challenge> puzzleChallenges = [];