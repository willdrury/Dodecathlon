import 'package:dodecathlon/models/user.dart';
import 'package:dodecathlon/utilities/color_utility.dart';
import 'package:dodecathlon/widgets/podium_column.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Podium extends StatelessWidget {
  Podium({super.key, required this.users, required this.byEvent});

  final List<User> users;
  final bool byEvent;

  @override
  Widget build(BuildContext context) {
    int e1 = users[0].currentEventPoints[0];
    int e2 = 0;
    int e3 = 0;

    int c1 = users[0].currentCompetitionPoints[0];
    int c2 = 0;
    int c3 = 0;

    if(users.length >= 2) {
      e2 = users[1].currentEventPoints[0];
      c2 = users[1].currentCompetitionPoints[0];
    }

    if(users.length >= 3) {
      e3 = users[2].currentEventPoints[0];
      c3 = users[2].currentCompetitionPoints[0];
    }

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Row(
              children: [
                if (users.length > 2)
                  PodiumColumn(heightFactor:
                    byEvent
                        ? (e1==0 || e3==0) ? 0 : e3/e1
                        : (c1==0 || c3==0) ? 0 : c3/c1,
                    barColor: byEvent ? Theme.of(context).colorScheme.primaryContainer : Colors.lightGreenAccent,
                    user: users[2],
                    isEvent: byEvent,
                  ), // 3rd
                PodiumColumn(
                  heightFactor: 1.0,
                  barColor: byEvent ? ColorUtility().darken(Theme.of(context).colorScheme.primaryContainer, .2) : Colors.green,
                  user: users[0],
                  isEvent: byEvent,),
                if (users.length > 1)// 1st
                  PodiumColumn(heightFactor:
                    byEvent
                        ? (e1==0 || e2==0) ? 0 : e2/e1
                        : (c1==0 || c2==0) ? 0 : c2/c1,
                    barColor: byEvent ? ColorUtility().darken(Theme.of(context).colorScheme.primaryContainer) : ColorUtility().darken(Colors.lightGreenAccent),
                    user: users[1],
                    isEvent: byEvent,
                  ), // 2nd
              ],
            ),
          )
        ],
      ),
    );
  }
}