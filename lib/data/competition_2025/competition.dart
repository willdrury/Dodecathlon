import 'package:dodecathlon/data/competition_2025/chess.dart';
import 'package:dodecathlon/data/competition_2025/cooking.dart';
import 'package:dodecathlon/data/competition_2025/fitness.dart';
import 'package:dodecathlon/data/competition_2025/writing.dart';
import 'package:dodecathlon/data/competition_2025/photography.dart';
import 'package:dodecathlon/data/competition_2025/puzzles.dart';
import 'package:dodecathlon/data/competition_2025/reading.dart';
import 'package:dodecathlon/data/competition_2025/running.dart';
import 'package:dodecathlon/data/competition_2025/trivia.dart';
import 'package:dodecathlon/data/competition_2025/video_games.dart';
import 'package:dodecathlon/data/competition_2025/volunteering.dart';
import 'package:dodecathlon/data/competition_2025/yoga.dart';
import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/competition.dart';

Competition competition2025 = Competition(
    name: 'Dodecathlon',
    events: [
      reading,          // Jan
      fitness,          // Feb
      meditation,       // Mar
      photography,      // Apr
      volunteering,     // May
      writing,          // June
      yoga,             // Jul
      chess,            // Aug
      cooking,          // Sep
      trivia,           // Oct
      running,          // Nov
      videoGames        // Dec
    ]
);

List<Challenge> competition2025Challenges = [
      ...readingChallenges,
      ...fitnessChallenges,
      ...triviaChallenges,
      ...photographyChallenges,
      ...volunteeringChallenges,
      ...chessChallenges,
      ...miscellaneousChallenges,
      ...yogaChallenges,
      ...cookingChallenges,
      ...cookingChallenges,
      ...videoGameChallenges,
      ...runningChallenges,
      ...meditationChallenges
];