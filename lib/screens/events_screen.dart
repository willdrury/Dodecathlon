import 'package:dodecathlon/models/event.dart';
import 'package:dodecathlon/models/in_person_event.dart';
import 'package:dodecathlon/models/submission.dart';
import 'package:dodecathlon/providers/submission_provider.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/screens/difficulty_selection_screen.dart';
import 'package:dodecathlon/screens/event_details_screen.dart';
import 'package:dodecathlon/screens/in_person_event_creation_screen.dart';
import 'package:dodecathlon/widgets/in_person_event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/competition_2025/reading.dart';
import '../models/challenge.dart';
import '../models/user.dart';
import '../providers/in_person_event_provider.dart';
import '../widgets/bonus_challenge_carousel.dart';
import '../widgets/upcoming_challenges_carousel.dart';

class EventsScreen extends ConsumerWidget {
  EventsScreen({super.key});

  Event currentEvent = reading;
  List<Challenge> challenges = readingChallenges;
  final DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    User currentUser = ref.read(userProvider)!;
    List<Submission> submissions = ref.watch(submissionsProvider);
    List<String> completedChallengeIds = submissions.map((s) => s.challengeId).toList();
    List<InPersonEvent> inPersonEvents = ref.watch(inPersonEventProvider);

    bool hasSelectedDifficulty = currentUser.currentEventDifficulty.isNotEmpty;
    List<Challenge> bonusChallenges = [];
    List<Challenge> mainChallenges = [];
    if (hasSelectedDifficulty) {
      bonusChallenges = challenges.where((c) =>
      c.isBonus &&
          !completedChallengeIds.contains(c.id) &&
          c.startDate.isBefore(now) &&
          c.endDate.isAfter(now) &&
          (c.difficulty == currentUser.currentEventDifficulty[0] || c.difficulty == Difficulty.all)
      ).toList();
      mainChallenges = challenges.where((c) =>
      !c.isBonus &&
          !completedChallengeIds.contains(c.id) &&
          c.startDate.isBefore(now) &&
          c.endDate.isAfter(now) &&
          (c.difficulty == currentUser.currentEventDifficulty[0] || c.difficulty == Difficulty.all)
      ).toList();
    }
    
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('This Month', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => EventDetailsScreen(event: currentEvent))
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        offset: Offset(0, 2),
                        blurRadius: 5,
                        spreadRadius: 3
                      )
                    ]
                  ),
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Image.network(
                          currentEvent.displayImageUrl,
                          fit: BoxFit.fill,
                          height: 300,
                          width: double.infinity,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          currentEvent.name,
                          style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Upcoming Challenges', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),),
                    if (!hasSelectedDifficulty)
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 50),
                          child: Column(
                            children: [
                              Text('Select a difficulty to get started!', style: TextStyle(fontSize: 15),),
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (ctx) => DifficultySelectionScreen(event: currentEvent,))
                                    );
                                  },
                                  icon: Icon(Icons.add_circle_outline, size: 30,)
                              )
                            ],
                          )
                        ),
                      ),
                    if (hasSelectedDifficulty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          if (bonusChallenges.isEmpty && mainChallenges.isEmpty)
                            Container(
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 20,),
                                  Icon(Icons.celebration, color: Theme.of(context).colorScheme.primary,),
                                  Text(
                                    'Looks like you are all caught up!\nCheck back later for more challenges!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                                  ),
                                ],
                              ),
                            ),
                          if (bonusChallenges.isNotEmpty)
                            Text('Bonus', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                          if (bonusChallenges.isNotEmpty)
                            BonusChallengeCarousel(challenges: bonusChallenges),
                          SizedBox(height: 20,),
                          if (mainChallenges.isNotEmpty)
                            Text('Main', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                          if (mainChallenges.isNotEmpty)
                            UpcomingChallengesCarousel(challenges: mainChallenges),
                          SizedBox(height: 20,),
                        ],
                      ),
                    Text('In-Person Events', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (ctx) => InPersonEventCreationScreen())
                        );
                      },
                      icon: Icon(Icons.add, color: Colors.blue,),
                      label: Text(
                        'Schedule an event',
                        style: TextStyle(color: Colors.blue),),
                    ),
                    for (InPersonEvent event in inPersonEvents)
                      InPersonEventCard(event: event)
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}