import 'package:dodecathlon/models/event.dart';
import 'package:flutter/material.dart';

import '../../models/challenge.dart';

Event miscellaneous = Event(
  name: 'Miscellaneous',
  description: 'Try new things and make the most of your summer vacation! Events range from bowling, to swimming, to visiting the zoo. ',
  hasMultipleDifficulties: false,
  themeColor: Colors.orange,
  icon: Icons.auto_awesome,
  startDate: DateTime(2025, 7),
  endDate: DateTime(2025, 8),
    displayImageUrl: ''
);

List<Challenge> miscellaneousChallenges = [];