import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/submission.dart';
import 'package:dodecathlon/models/user.dart';
import 'package:dodecathlon/providers/submission_provider.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utilities/color_utility.dart';
import 'circular_progress_container.dart';

class EventProgressContainer extends ConsumerWidget {

  EventProgressContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User user = ref.read(userProvider)!;
    List<Submission> submissions = ref.watch(submissionsProvider);

    int _maxMainPoints = 80;
    if (user.currentEventDifficulty == Difficulty.intermediate) {
      _maxMainPoints = 60;
    } else if (user.currentEventDifficulty == Difficulty.beginner) {
      _maxMainPoints = 40;
    }

    int _mainPoints = 0;
    int _bonusPoints = 0;
    for (Submission s in submissions) {
      if (s.isBonus) {
        _bonusPoints += s.points;
      } else {
        _mainPoints += s.points;
      }
    }
    _mainPoints = _mainPoints.clamp(0, _maxMainPoints);
    _bonusPoints = _bonusPoints.clamp(0, 20);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, ColorUtility().lighten(Theme.of(context).colorScheme.primary, .4)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
          )
      ),
      child: Column(
        children: [
          SizedBox(height: 40,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Text(
                    'Main',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 16),
                  )
              ),
              CircularProgressContainer(
                currentPoints: _mainPoints,
                maxPoints: _maxMainPoints,
                circleColor: Colors.white,
                indicatorColor: Theme.of(context).colorScheme.primary,
                upperTextColor: Theme.of(context).colorScheme.primary,
                lowerTextColor: Colors.black,
                circleDiameter: 200,
                indicatorDiameter: 230,
                indicatorWidth: 8,
                indicatorProgress: _mainPoints/_maxMainPoints,
                fontSize: 120,
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
                    'Bonus',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 16),
                  )
              ),
              CircularProgressContainer(
                currentPoints: _bonusPoints,
                maxPoints: 20,
                circleColor: Colors.white,
                indicatorColor: Colors.blue,
                upperTextColor: Colors.blue,
                lowerTextColor: Colors.black,
                circleDiameter: 80,
                indicatorDiameter: 100,
                indicatorWidth: 5,
                indicatorProgress: _bonusPoints/20,
                fontSize: 50,
              ),
              Spacer()
            ],
          ),
          SizedBox(height: 30,),
        ],
      ),
    );
  }
}