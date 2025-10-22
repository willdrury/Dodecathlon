import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/event.dart';
import 'package:dodecathlon/widgets/upcoming_challenges_carousel.dart';
import 'package:flutter/material.dart';

import '../models/in_person_event.dart';
import '../screens/difficulty_selection_screen.dart';
import '../screens/in_person_event_creation_screen.dart';
import 'bonus_challenge_carousel.dart';
import 'in_person_event_card.dart';

class CurrentEventDetails extends StatelessWidget {
  const CurrentEventDetails({
    super.key,
    required this.hasSelectedDifficulty,
    required this.currentEvent,
    required this.bonusChallenges,
    required this.mainChallenges,
    required this.inPersonEvents,
  });

  final bool hasSelectedDifficulty;
  final Event currentEvent;
  final List<Challenge> bonusChallenges;
  final List<Challenge> mainChallenges;
  final List<InPersonEvent> inPersonEvents;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Upcoming Challenges', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),),

          // Select Difficulty Container
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

          // Challenge List
          if (hasSelectedDifficulty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                if (bonusChallenges.isEmpty && mainChallenges.isEmpty)
                  Text('Looks like you\'re all caught up!'),
                if (bonusChallenges.isNotEmpty)
                  Text('Bonus', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                if (bonusChallenges.isNotEmpty)
                  BonusChallengeCarousel(challenges: bonusChallenges, event: currentEvent,),
                SizedBox(height: 20,),
                if (mainChallenges.isNotEmpty)
                  Text('Main', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                if (mainChallenges.isNotEmpty)
                  UpcomingChallengesCarousel(challenges: mainChallenges, event: currentEvent!,),
                SizedBox(height: 40,),
              ],
            ),

          // In-Person Events
          Text('In-Person Events', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
          if (inPersonEvents.isEmpty)
            Text('Be the first to schedule a new event!'),
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
            InPersonEventCard(event: event),
          if (inPersonEvents.isEmpty)
            SizedBox(height: 200,)
        ],
      ),
    );
  }
}