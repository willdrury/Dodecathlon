import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/submission.dart';
import 'package:dodecathlon/models/user.dart';
import 'package:dodecathlon/providers/challenges_provider.dart';
import 'package:dodecathlon/providers/events_provider.dart';
import 'package:dodecathlon/providers/submission_provider.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/widgets/event_rank_snapshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event.dart';
import 'circular_progress_container.dart';

class EventProgressContainer extends ConsumerWidget {

  const EventProgressContainer({super.key, required this.onPageChange});

  final Function(int, BuildContext) onPageChange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User user = ref.read(userProvider)!;
    AsyncValue<List<Submission>> submissions = ref.watch(submissionsProvider);
    AsyncValue<List<Challenge>> challenges = ref.watch(challengesProvider);
    AsyncValue<List<Event>> events = ref.watch(eventProvider);

    if (!events.hasValue || !challenges.hasValue || !submissions.hasValue) {
      return Center(child: CircularProgressIndicator());
    }

    DateTime now = DateTime.now();
    Event? currentEvent = events.value!.where((e) =>
      e.startDate.isBefore(now) & e.endDate.isAfter(now)
    ).firstOrNull;

    if (currentEvent == null) {
      return Center(child: CircularProgressIndicator());
    }

    List<String> currentChallengeIds = challenges.value!.where((c) =>c.eventId == currentEvent.id!)
      .map((c) => c.id)
      .toList();

    List<Submission> userEventSubmissions = submissions.value!.where((s) =>
      currentChallengeIds.contains(s.challengeId) && s.userId == user.id
    ).toList();

    int maxMainPoints = 80;
    if (user.currentEventDifficulty == Difficulty.intermediate) {
      maxMainPoints = 60;
    } else if (user.currentEventDifficulty == Difficulty.beginner) {
      maxMainPoints = 40;
    }

    int mainPoints = 0;
    int bonusPoints = 0;
    for (Submission s in userEventSubmissions) {
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

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomRight,
            width: double.infinity,
            padding: EdgeInsets.only(right: 20, top: 80),
            child: EventRankSnapshot(onPageChange: onPageChange,),
          ),
          Column(
            children: [
              SizedBox(height: 20,),
              Align(
                alignment: Alignment.center,
                child: Text('Current Points', style: TextStyle(fontSize: 25,),)
              ),
              SizedBox(height: 20,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Text(
                        'Main:',
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
                      )
                  ),
                  GestureDetector(
                    onTap: () {
                      onPageChange(1, context);
                    },
                    child: CircularProgressContainer(
                      currentPoints: mainPoints,
                      maxPoints: maxMainPoints,
                      circleColor: Theme.of(context).colorScheme.surfaceContainer,
                      indicatorColor: Theme.of(context).colorScheme.primary,
                      upperTextColor: Theme.of(context).colorScheme.primary,
                      lowerTextColor: Theme.of(context).colorScheme.onSurface,
                      circleDiameter: 200,
                      indicatorDiameter: 230,
                      indicatorWidth: 8,
                      indicatorProgress: mainPoints/maxMainPoints,
                      fontSize: 120,
                    ),
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Text(
                        'Bonus:',
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
                      )
                  ),
                  GestureDetector(
                    onTap: () {
                      onPageChange(1, context);
                    },
                    child: CircularProgressContainer(
                      currentPoints: bonusPoints,
                      maxPoints: 20,
                      circleColor: Theme.of(context).colorScheme.surfaceContainer,
                      indicatorColor: Colors.blue,
                      upperTextColor: Colors.blue,
                      lowerTextColor: Theme.of(context).colorScheme.onSurface,
                      circleDiameter: 80,
                      indicatorDiameter: 100,
                      indicatorWidth: 5,
                      indicatorProgress: bonusPoints/20,
                      fontSize: 50,
                    ),
                  ),
                  Spacer()
                ],
              ),
              SizedBox(height: 30,),
            ],
          ),
        ],
      ),
    );
  }
}