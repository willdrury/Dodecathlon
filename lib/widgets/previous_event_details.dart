import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/event.dart';
import 'package:dodecathlon/widgets/upcoming_challenges_carousel.dart';
import 'package:flutter/material.dart';
import 'bonus_challenge_carousel.dart';

class PreviousEventDetails extends StatelessWidget {
  const PreviousEventDetails({
    super.key,
    required this.currentEvent,
    required this.bonusChallenges,
    required this.mainChallenges,
  });

  final Event currentEvent;
  final List<Challenge> bonusChallenges;
  final List<Challenge> mainChallenges;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Event Recap', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),),

          // Challenge List
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              if (bonusChallenges.isEmpty && mainChallenges.isEmpty)
                Text('Looks like you didn\'t have any completed challenges last month.'),
              if (bonusChallenges.isNotEmpty)
                Text('Completed Bonus\'s', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
              if (bonusChallenges.isNotEmpty)
                BonusChallengeCarousel(challenges: bonusChallenges, event: currentEvent, isCompleted: true,),
              SizedBox(height: 20,),
              if (mainChallenges.isNotEmpty)
                Text('Completed Main Challenges', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
              if (mainChallenges.isNotEmpty)
                UpcomingChallengesCarousel(challenges: mainChallenges, event: currentEvent,),
              SizedBox(height: 80,),
            ],
          ),
        ],
      ),
    );
  }
}