import 'package:dodecathlon/models/user.dart';
import 'package:dodecathlon/widgets/podium_column.dart';
import 'package:flutter/material.dart';

class Podium extends StatelessWidget {
  const Podium({super.key, required this.currentUser, required this.users, required this.byEvent});

  final User currentUser;
  final List<User> users;
  final bool byEvent;

  @override
  Widget build(BuildContext context) {
    List<User> usersByEvent = List.from(users);
    usersByEvent.sort((a,b) => b.currentEventPoints[0] - a.currentEventPoints[0]);

    List<User> usersByCompetition = List.from(users);
    usersByCompetition.sort((a,b) => b.currentCompetitionPoints[0] - a.currentCompetitionPoints[0]);

    int e1 = usersByEvent[0].currentEventPoints[0];
    int e2 = 0;
    int e3 = 0;

    int c1 = usersByCompetition[0].currentCompetitionPoints[0];
    int c2 = 0;
    int c3 = 0;

    if(users.length >= 2) {
      e2 = usersByEvent[1].currentEventPoints[0];
      c2 = usersByCompetition[1].currentCompetitionPoints[0];
    }

    if(users.length >= 3) {
      e3 = usersByEvent[2].currentEventPoints[0];
      c3 = usersByCompetition[2].currentCompetitionPoints[0];
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PodiumColumn(
            heightFactor: 1.0,
            barColor: byEvent ? Theme.of(context).colorScheme.secondary : Color(0xFFFF6BDC),
            user: byEvent? usersByEvent[0] : usersByCompetition[0],
            isEvent: byEvent,),
          if (users.length > 1)// 1st
            PodiumColumn(
              heightFactor: byEvent
                ? (e1==0 || e2==0) ? 0 : e2/e1
                : (c1==0 || c2==0) ? 0 : c2/c1,
              barColor: byEvent ? Theme.of(context).colorScheme.primary : Color(0xFFFF5858),
              user: byEvent? usersByEvent[1] : usersByCompetition[1],
              isEvent: byEvent,
            ),
          if (users.length > 2)
            PodiumColumn(
              heightFactor: byEvent
                ? (e1==0 || e3==0) ? 0 : e3/e1
                : (c1==0 || c3==0) ? 0 : c3/c1,
              barColor: byEvent ? Theme.of(context).colorScheme.tertiary : Color(0xFFFFC170),
              user: byEvent? usersByEvent[2] : usersByCompetition[2],
              isEvent: byEvent,
            ), // 3rd// 2nd
        ],
      ),
    );
  }
}