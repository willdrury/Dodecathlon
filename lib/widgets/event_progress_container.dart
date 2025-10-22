import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/submission.dart';
import 'package:dodecathlon/models/user.dart';
import 'package:dodecathlon/providers/submission_provider.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/widgets/event_rank_snapshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'circular_progress_container.dart';

class EventProgressContainer extends ConsumerWidget {

  const EventProgressContainer({super.key});

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

    bool isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomRight,
            width: double.infinity,
            padding: EdgeInsets.only(right: 20, top: 80),
            child: EventRankSnapshot(),
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
                  CircularProgressContainer(
                    currentPoints: _mainPoints,
                    maxPoints: _maxMainPoints,
                    circleColor: Theme.of(context).colorScheme.surface,
                    indicatorColor: Theme.of(context).colorScheme.primary,
                    upperTextColor: Theme.of(context).colorScheme.primary,
                    lowerTextColor: Theme.of(context).colorScheme.onSurface,
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
                        'Bonus:',
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
                      )
                  ),
                  CircularProgressContainer(
                    currentPoints: _bonusPoints,
                    maxPoints: 20,
                    circleColor: Theme.of(context).colorScheme.surface,
                    indicatorColor: Colors.blue,
                    upperTextColor: Colors.blue,
                    lowerTextColor: Theme.of(context).colorScheme.onSurface,
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
        ],
      ),
    );
  }
}