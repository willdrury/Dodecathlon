import 'package:dodecathlon/models/user.dart';
import 'package:dodecathlon/widgets/podium.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class LeaderboardSnapshop extends StatefulWidget {

  LeaderboardSnapshop({super.key, required this.currentUser, required this.users});

  User currentUser;
  List<User> users;

  @override
  State<StatefulWidget> createState() {
    return _LeaderboardSnapshotState();
  }
}

class _LeaderboardSnapshotState extends State<LeaderboardSnapshop> {

  bool _isEvent = true;
  late List<User> usersByEvent;
  late List<User> usersByCompetition;
  late int userEventIndex;
  late int userCompetitionIndex;

  @override
  void initState() {
    usersByEvent = List.from(widget.users);
    usersByEvent.sort((a,b) => b.currentEventPoints[0] - a.currentEventPoints[0]);

    usersByCompetition = List.from(widget.users);
    usersByCompetition.sort((a,b) => b.currentCompetitionPoints[0] - a.currentCompetitionPoints[0]);

    List<String> byEventId = usersByEvent.map((e) => e.id!).toList();
    List<String> byCompId = usersByCompetition.map((e) => e.id!).toList();

    userEventIndex = byEventId.indexOf(widget.currentUser.id!);
    userCompetitionIndex = byCompId.indexOf(widget.currentUser.id!);

    super.initState();
  }

  void _changeLeaderboardDisplay() {
    setState(() {
      _isEvent = !_isEvent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          TextButton.icon(
            label: Text(_isEvent ? 'Current Event' : 'Overall', style: TextStyle(fontSize: 20),),
            onPressed: _changeLeaderboardDisplay,
            icon: Icon(Icons.loop),
            iconAlignment: IconAlignment.end,
          ),
          Expanded(
            child: Row(
              children: [
                Podium(users: _isEvent ? usersByEvent : usersByCompetition, byEvent: _isEvent,),
                SizedBox(width: 20,),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_isEvent)
                        for (User user in usersByEvent.sublist(max(userEventIndex - 3, 0), min(userEventIndex + 3, usersByEvent.length)))
                          Text('${usersByEvent.indexOf(user) + 1}. ${user.userName} (${user.currentEventPoints[0]})', style: TextStyle(
                              fontWeight: user.userName == widget.currentUser.userName ? FontWeight.bold : FontWeight.normal
                          ),),
                      if (!_isEvent)
                        for (User user in usersByCompetition.sublist(max(userCompetitionIndex - 3, 0), min(userCompetitionIndex + 3, usersByCompetition.length)))
                          Text('${usersByCompetition.indexOf(user) + 1}. ${user.userName} (${user.currentCompetitionPoints[0]})', style: TextStyle(
                              fontWeight: user.userName == widget.currentUser.userName ? FontWeight.bold : FontWeight.normal
                          ),),
                    ],
                  ),
                )
                // Podium(label: 'Competition', users: usersByCompetition, byEvent: false,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}