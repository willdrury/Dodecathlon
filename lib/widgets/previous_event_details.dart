import 'package:dodecathlon/constants/box_shadows.dart';
import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/event.dart';
import 'package:dodecathlon/widgets/bonus_challenge_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/submission.dart';
import '../models/user.dart';
import 'bonus_challenge_carousel.dart';
import 'circular_progress_container.dart';

class PreviousEventDetails extends StatelessWidget {
  const PreviousEventDetails({
    super.key,
    required this.currentEvent,
    required this.challenges,
    required this.submissions,
    required this.currentUser,
  });

  final Event currentEvent;
  final List<Challenge> challenges;
  final List<Submission> submissions;
  final User currentUser;

  @override
  Widget build(BuildContext context) {

    List<String> challengeIds = challenges.map((e) => e.id).toList();
    List<Challenge> completedChallenges = [];
    Map<String, int> userScoreMap = {};
    for(Submission s in submissions) {
      if (challengeIds.contains(s.challengeId)) {
        userScoreMap[s.userId] = (userScoreMap[s.userId] ?? 0) + s.points;
        if (s.userId == currentUser.id && !completedChallenges.contains(challenges.firstWhere((c) => c.id == s.challengeId))) {
          completedChallenges.add(challenges.firstWhere((c) => c.id == s.challengeId));
        }
      }
    }
    
    int currentUserScore = userScoreMap[currentUser.id] ?? 0;
    int rank = 1;
    for (var entry in userScoreMap.entries) {
      if (entry.value >= currentUserScore && entry.key != currentUser.id) {
        rank++;
      }
    }

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
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Final Score'),
                  SizedBox(width: 20,),
                  CircularProgressContainer(
                    currentPoints: currentUserScore,
                    maxPoints: 100,
                    circleColor: Theme.of(context).colorScheme.surface,
                    indicatorColor: currentEvent.themeColor,
                    upperTextColor: currentEvent.themeColor,
                    lowerTextColor: Theme.of(context).colorScheme.onSurface,
                    circleDiameter: 80,
                    indicatorDiameter: 100,
                    indicatorWidth: 8,
                    indicatorProgress: currentUserScore/100,
                    fontSize: 50,
                  ),
                ],
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Final Rank'),
                  SizedBox(width: 20,),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 5, right: 5),
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 5),
                          spreadRadius: 1,
                          blurRadius: 5
                        )
                      ]
                    ),
                    child: Text(
                      rank.toString(),
                      style: GoogleFonts.shareTech(
                        color: currentEvent.themeColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60,),
              if (challenges.isEmpty)
                Text('Looks like this event had no challanges.'),
              if (challenges.isNotEmpty)
                Text('Completed Challenges', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              if (completedChallenges.isEmpty)
                Text(
                  'Looks like you did not complete any challenges during this event.',
                  style: TextStyle(color: Colors.grey),
                ),
              if (completedChallenges.isNotEmpty)
                BonusChallengeCarousel(
                    challenges: completedChallenges,
                    event: currentEvent,
                    isCompleted: true
                ),
              SizedBox(height: 20,),
              ExpansionTile(
                title: Text(
                  'View full challenge history',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
                shape: Border(),
                dense: true,
                children: [
                  GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: challenges.length,
                    itemBuilder: (ctx, i) {
                      return Container(
                        margin: EdgeInsets.all(15),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 5),
                              spreadRadius: 1,
                              blurRadius: 5
                            )
                          ]
                        ),
                        child: BonusChallengeCard(
                          challenge: challenges[i],
                          event: currentEvent,
                          isCompleted: true,
                        ),
                      );
                    }
                  )
                ],
              ),
              SizedBox(height: 50,)
            ],
          ),
        ],
      ),
    );
  }
}