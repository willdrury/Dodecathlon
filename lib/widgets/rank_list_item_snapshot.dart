import 'package:dodecathlon/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RankListItemSnapshot extends StatelessWidget {
  const RankListItemSnapshot({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Text(
        '${user.eventRank}. ${user.userName} (${user.currentEventPoints[0]})',
        style: TextStyle(fontSize: 15),
    );
  }
}