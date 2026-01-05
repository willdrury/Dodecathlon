import 'package:dodecathlon/models/submission.dart';
import 'package:dodecathlon/screens/competition_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/competition.dart';

final formatter = DateFormat('EEE, MMM d, hh:mm');

class CompetitionTile extends StatelessWidget {
  const CompetitionTile({
    super.key,
    required this.competition,
    required this.onToggle,
    required this.isUserComp
  });

  final Competition competition;
  final Function(String id) onToggle;
  final bool isUserComp;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: competition.themeColor.withAlpha(10),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border.all(
          color: competition.themeColor
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: competition.themeColor.withAlpha(50),
        //     offset: Offset(0, 5),
        //     spreadRadius: 1,
        //     blurRadius: 5
        //   )
        // ]
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                CompetitionDetailsScreen(competition: competition)
              ));
            },
            child: Container(
              width: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    competition.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                    ),
                  ),
                  Spacer(), // TODO: Add num competitiors
                  Text(
                    competition.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () async {
              await onToggle(competition.id);
            },
            icon: isUserComp
              ? Icon(Icons.remove)
              : Icon(Icons.add)
          )
        ],
      ),
    );
  }
}