import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/event.dart';
import 'package:dodecathlon/widgets/upcoming_challenges_carousel.dart';
import 'package:flutter/material.dart';
import 'bonus_challenge_carousel.dart';

class PreviousEventDetails extends StatelessWidget {
  const PreviousEventDetails({
    super.key,
    required this.currentEvent,
    required this.challenges
  });

  final Event currentEvent;
  final List<Challenge> challenges;

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
              if (challenges.isEmpty)
                Text('Looks like there were no challanges this month.'),
              if (challenges.isNotEmpty)
                Text('Past Challenges', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
              if (challenges.isNotEmpty)
                BonusChallengeCarousel(
                    challenges: challenges,
                    event: currentEvent,
                    isCompleted: true
                ),
            ],
          ),
        ],
      ),
    );
  }
}