import 'package:dodecathlon/models/submission.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat('EEE, MMM d, hh:mm');

class SubmissionTileSmall extends StatelessWidget {
  const SubmissionTileSmall({
    super.key,
    required this.submission
  });

  final Submission submission;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
      child: Row(
        children: [
          Text('${submission.points.toString()} pts.'),
          if (!submission.isApproved)
            Text(
              ' (pending approval)',
              style: TextStyle(color: Colors.grey),
            ),
          Spacer(),
          Text(formatter.format(submission.createdDate)),
        ],
      ),
    );
  }
}