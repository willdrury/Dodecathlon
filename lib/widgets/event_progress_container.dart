import 'package:dodecathlon/models/submission.dart';
import 'package:dodecathlon/models/user.dart';
import 'package:dodecathlon/screens/difficulty_selection_screen.dart';
import 'package:dodecathlon/widgets/event_progress_bar.dart';
import 'package:flutter/material.dart';

class EventProgressContainer extends StatelessWidget {

  EventProgressContainer({super.key, required this.user});

  User user;

  @override
  Widget build(BuildContext context) {

    List<Submission> userSubmissions = user.submissionData == null ? [] : user.submissionData!;
    int mainPoints = 0;
    int bonusPoints = 0;
    for (Submission s in userSubmissions) {
      if (s.isBonus) {
        bonusPoints += s.points;
      }
      else {
        mainPoints += s.points;
      }
    }

    int clampedBonusPoints = bonusPoints.clamp(0, 20);
    int clampedMainPoints = mainPoints.clamp(0, 80);
    int currentPoints = clampedMainPoints + clampedBonusPoints;

    String eventPointText = '';
    if (currentPoints == 0) {
      eventPointText = 'Complete your first challenge to get started';
    } else if (currentPoints < 50) {
      eventPointText = 'Keep it up! Still ${100 - currentPoints} points left!';
    } else if (currentPoints < 100) {
      eventPointText = 'Only ${100 - currentPoints} points to go!';
    } else {
      eventPointText = 'Congratulations! You reached the max points for this event!';
    }

    return Container(
      height: 300,
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 40,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              eventPointText,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20,),
          EventProgressBar(user: user, mainPoints: clampedMainPoints, bonusPoints: clampedBonusPoints,),
          SizedBox(height: 40,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(backgroundColor: Theme.of(context).primaryColor, radius: 10,),
              SizedBox(width: 10,),
              Text('Main ($clampedMainPoints/80)'),
              SizedBox(width: 50,),
              CircleAvatar(backgroundColor: Colors.blue, radius: 10,),
              SizedBox(width: 10,),
              Text('Bonus ($clampedBonusPoints/20)')
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(backgroundColor: Colors.black26, radius: 10,),
              SizedBox(width: 10,),
              Text('Remaining (${100 - clampedMainPoints - clampedBonusPoints})')
            ],
          )
        ],
      ),
    );
  }
}