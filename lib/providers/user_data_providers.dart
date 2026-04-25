import 'package:dodecathlon/providers/submission_provider.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/challenge.dart';
import '../models/event.dart';
import '../models/submission.dart';
import '../models/user.dart' as dd;
import 'challenges_provider.dart';
import 'events_provider.dart';

// Returns all submissions for the current event
final userEventSubmissionProvider = StreamProvider<List<Submission>?>((ref) {

  AsyncValue<dd.User?> userStream = ref.watch(userProvider);
  if (!userStream.hasValue) {
    return Stream.value(null);
  }

  dd.User user = userStream.value!;
  AsyncValue<List<Submission>> submissions = ref.watch(submissionsProvider);
  AsyncValue<List<Challenge>> challenges = ref.watch(challengesProvider);
  AsyncValue<List<Event>> events = ref.watch(eventProvider);

  if (!events.hasValue || !challenges.hasValue || !submissions.hasValue) {
    return Stream.value(null);
  }

  DateTime now = DateTime.now();
  Event? currentEvent = events.value!.where((e) =>
  e.startDate.isBefore(now) & e.endDate.isAfter(now)
  ).firstOrNull; // TODO: get event tied to current competition

  if (currentEvent == null) {
    return Stream.value(null);
  }

  List<String> currentChallengeIds = challenges.value!.where((c) =>c.eventId == currentEvent.id!)
      .map((c) => c.id)
      .toList();

  List<Submission> userEventSubmissions = submissions.value!.where((s) =>
  currentChallengeIds.contains(s.challengeId) && s.userId == user.id
  ).toList();

  return Stream.value(userEventSubmissions);
});

// Returns tuple containing main and bonus points
final userEventPointProvider = StreamProvider<(int, int)?>((ref) {

  AsyncValue<dd.User?> userStream = ref.watch(userProvider);
  if (!userStream.hasValue) {
    return Stream.value(null);
  }
  dd.User user = userStream.value!;

  AsyncValue<List<Submission>?> userEventSubmissionsStream = ref.watch(userEventSubmissionProvider);
  if (userEventSubmissionsStream.value == null) {
    return Stream.value(null);
  }

  int maxMainPoints = 80;
  if (user.currentEventDifficulty == Difficulty.intermediate) {
    maxMainPoints = 60;
  } else if (user.currentEventDifficulty == Difficulty.beginner) {
    maxMainPoints = 40;
  }

  int mainPoints = 0;
  int bonusPoints = 0;
  for (Submission s in userEventSubmissionsStream.value!) {
    if (s.isApproved) {
      if (s.isBonus) {
        bonusPoints += s.points;
      } else {
        mainPoints += s.points;
      }
    }
  }

  mainPoints = mainPoints.clamp(0, maxMainPoints);
  bonusPoints = bonusPoints.clamp(0, 20);

  return Stream.value((mainPoints, bonusPoints));
});