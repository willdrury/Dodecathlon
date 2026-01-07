import 'dart:async';
import 'package:dodecathlon/providers/submission_provider.dart';
import 'package:dodecathlon/providers/users_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/challenge.dart';
import '../models/event.dart';
import '../models/submission.dart';
import '../models/user.dart';
import 'challenges_provider.dart';
import 'events_provider.dart';

class UserCompetitionRankingsProvider extends AsyncNotifier<List<(String, int)>> {
  @override
  FutureOr<List<(String, int)>> build() async {
    AsyncValue<List<User>> users = ref.watch(usersProvider);
    AsyncValue<List<Submission>> submissions = ref.watch(submissionsProvider);
    AsyncValue<List<Event>> events = ref.watch(eventProvider);
    AsyncValue<List<Challenge>> challenges = ref.watch(challengesProvider);

    if (!users.hasValue || !submissions.hasValue || !events.hasValue || !challenges.hasValue) {
      return [];
    }

    return await buildRankings(users.value!, submissions.value!, events.value!, challenges.value!);
  }

  Future<List<(String, int)>> buildRankings(
      List<User> users,
      List<Submission> submissions,
      List<Event> events,
      List<Challenge> challenges
      ) async {

    DateTime now = DateTime.now();
    Event? currentEvent = events.where((e) =>
      e.startDate.isBefore(now) & e.endDate.isAfter(now)
    ).firstOrNull;

    if (currentEvent == null) {
      return [];
    }

    // TODO: filter only events in the current competition
    List<Challenge> eventChallenge = challenges.where((c) =>
      true
    ).toList();

    List<String> eventChallengeIds = eventChallenge.map((c) => c.id).toList();

    Map<String, int> userIdEventPointMap = { for (var u in users) u.id! : 0 };
    List<Submission> eventSubmissions = submissions.where((s) =>
        eventChallengeIds.contains(s.challengeId) && s.isApproved == true
    ).toList();

    for (Submission s in eventSubmissions) {
      if (userIdEventPointMap.containsKey(s.userId)) {
        userIdEventPointMap.update(s.userId, (v) => v += s.points);
      }
    }

    List<MapEntry<String, int>> usersByEventPoints = userIdEventPointMap.entries.toList()..sort(
            (a,b) => a.value > b.value ? 0 : 1
    );

    return usersByEventPoints.map((e) =>
    (e.key, e.value)
    ).toList();
  }
}

final userCompetitionRankingsProvider = AsyncNotifierProvider<UserCompetitionRankingsProvider, List<(String, int)>>(UserCompetitionRankingsProvider.new);