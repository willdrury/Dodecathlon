import 'package:dodecathlon/models/submission.dart';
import 'package:dodecathlon/screens/challenge_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/challenge.dart';

final formatter = DateFormat('EEE, MMM d, hh:mm');

class SubmissionTileMedium extends StatelessWidget {
  const SubmissionTileMedium({
    super.key,
    required this.submission,
    required this.challenge
  });

  final Submission submission;
  final Challenge challenge;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
            ChallengeDetailsScreen(challenge: challenge, isCompleted: true,)
        ));
      },
      child: Container(
        height: 70,
        width: double.infinity,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 5),
                spreadRadius: 1,
                blurRadius: 5
            )
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              challenge.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text('${submission.points.toString()} pts.'),
                Spacer(),
                Text(formatter.format(submission.createdDate)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}