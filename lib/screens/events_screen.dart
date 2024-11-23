import 'package:dodecathlon/data/demo_data/demo_in_person_events.dart';
import 'package:dodecathlon/models/event.dart';
import 'package:dodecathlon/models/in_person_event.dart';
import 'package:dodecathlon/models/submission.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/screens/event_details_screen.dart';
import 'package:dodecathlon/widgets/in_person_event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/competition_2025/reading.dart';
import '../models/challenge.dart';
import '../models/user.dart';
import '../widgets/bonus_challenge_carousel.dart';
import '../widgets/upcoming_challenges_carousel.dart';

class EventsScreen extends ConsumerWidget {
  EventsScreen({super.key, required this.submissions});

  Event currentEvent = reading;
  List<InPersonEvent> inPersonEvents = demoInPersonEvents;
  List<Challenge> challenges = readingChallenges;
  final DateTime now = DateTime.now();
  List<Submission> submissions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    User currentUser = ref.read(userProvider)!;
    List<String> completedChallengeIds = submissions.map((s) => s.challengeId).toList();

    List<Challenge> bonusChallenges = challenges.where((c) =>
      c.isBonus &&
      !completedChallengeIds.contains(c.id) &&
      c.startDate.isBefore(now) &&
      c.endDate.isAfter(now) &&
      (c.difficulty == currentUser.currentEventDifficulty[0] || c.difficulty == Difficulty.all)
    ).toList();
    List<Challenge> mainChallenges = challenges.where((c) =>
    !c.isBonus &&
        !completedChallengeIds.contains(c.id) &&
        c.startDate.isBefore(now) &&
        c.endDate.isAfter(now) &&
        (c.difficulty == currentUser.currentEventDifficulty[0] || c.difficulty == Difficulty.all)
    ).toList();

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => EventDetailsScreen(event: currentEvent))
              );
            },
            child: Container(
              height: 150,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.white, Theme.of(context).colorScheme.primaryContainer],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'READING',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                        height: .8,
                        shadows: [
                          Shadow(
                            offset: Offset(3, 3),
                            blurRadius: 3.0,
                            color: Colors.black12,
                          ),
                        ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.grey, offset: Offset(0, -1), spreadRadius: 1, blurRadius: 10)
              ]
            ),
            padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bonus Challenges', style: TextStyle(fontSize: 20),),
                  BonusChallengeCarousel(challenges: bonusChallenges),
                  SizedBox(height: 20,),
                  Text('Upcoming Challenges', style: TextStyle(fontSize: 20),),
                  UpcomingChallengesCarousel(challenges: mainChallenges),
                  SizedBox(height: 20,),
                  if (inPersonEvents.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('In-Person Events', style: TextStyle(fontSize: 20),),
                        for (InPersonEvent event in inPersonEvents)
                          InPersonEventCard(event: event),
                      ],
                    )
                ],
              )
          ),
        ],
      ),
    );
  }
}