import 'package:dodecathlon/models/submission.dart';
import 'package:dodecathlon/screens/submission_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/challenge.dart';

class StreakCalendar extends StatelessWidget {
  const StreakCalendar({
    super.key,
    required this.challenge,
    required this.challengeSubmissions,
  });

  final Challenge challenge;

  // Assumes the list only contains submissions for the current user and challenge.
  final List<Submission> challengeSubmissions;

  Widget generateMonth(int month, int year, BuildContext context) {
    DateTime now = DateTime.now();

    int firstDayOffset = DateUtils.firstDayOffset(year, month, MaterialLocalizations.of(context));
    int numDaysPlusOffset = DateUtils.getDaysInMonth(year, month) + firstDayOffset;
    int numTiles = numDaysPlusOffset + (7 - (numDaysPlusOffset % 7)) + 7;
    int startDay = 1 - firstDayOffset;

    List<Widget> dayLabels = [
      Text('Sun', style: TextStyle(color: Colors.grey),),
      Text('Mon', style: TextStyle(color: Colors.grey)),
      Text('Tue', style: TextStyle(color: Colors.grey)),
      Text('Wed', style: TextStyle(color: Colors.grey)),
      Text('Thu', style: TextStyle(color: Colors.grey)),
      Text('Fri', style: TextStyle(color: Colors.grey)),
      Text('Sat', style: TextStyle(color: Colors.grey))
    ];

    Map<int, Submission> completedSubmissionMap = {};

    for (Submission s in challengeSubmissions) {
      if (s.createdDate.month == month && s.createdDate.year == year) {
        completedSubmissionMap[s.createdDate.day] = s;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${DateFormat.MMMM().format(DateTime(year, month, 1))} $year',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
          ),
          itemCount: numTiles,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, i) {
            Widget child;

            // Weekday labels
            if (i < 7) {
              child = dayLabels[i];
            }

            // Blank spaces before month start and after month end
            else if (i + startDay - 7 <= 0 || i + startDay - 7 > DateUtils.getDaysInMonth(year, month)) {
              child = Text('');
            }

            // User submission not approved
            else if (
              completedSubmissionMap.containsKey(i + startDay - 7) &&
              !completedSubmissionMap[i + startDay - 7]!.isApproved
            ) {
              bool extendLeft =
                  completedSubmissionMap.containsKey(i + startDay - 8) &&
                  !completedSubmissionMap[i + startDay - 8]!.isApproved;
              bool extendRight =
                  completedSubmissionMap.containsKey(i + startDay - 6) &&
                  !completedSubmissionMap[i + startDay - 6]!.isApproved;
              child =  GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => SubmissionDetailsScreen(submission: completedSubmissionMap[i + startDay - 7]!))
                    );
                  },
                  child: Container(
                      height: 30,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.horizontal(
                            left: extendLeft ? Radius.circular(0) : Radius.circular(15),
                            right: extendRight ? Radius.circular(0) : Radius.circular(15)
                        ),
                      ),
                      child: Text((i + startDay - 7).toString(), style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),)
                  )
              );
            }

            // User submission approved
            else if (
              completedSubmissionMap.containsKey(i + startDay - 7) &&
              completedSubmissionMap[i + startDay - 7]!.isApproved
            ) {
              bool extendLeft =
                completedSubmissionMap.containsKey(i + startDay - 8) &&
                completedSubmissionMap[i + startDay - 8]!.isApproved;
              bool extendRight =
                completedSubmissionMap.containsKey(i + startDay - 6) &&
                completedSubmissionMap[i + startDay - 6]!.isApproved;
              child =  GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) =>
                      SubmissionDetailsScreen(submission: completedSubmissionMap[i + startDay - 7]!
                    ))
                  );
                },
                child: Container(
                  height: 30,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.horizontal(
                      left: extendLeft ? Radius.circular(0) : Radius.circular(15),
                      right: extendRight ? Radius.circular(0) : Radius.circular(15)
                    ),
                  ),
                  child: Text((i + startDay - 7).toString(), style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),)
                )
              );
            }

            // No user submission, and day is in future
            else if (i + startDay - 7 > now.day && now.month >= month && now.year >= year){
              child = Text((i + startDay - 7).toString(), style: TextStyle(color: Colors.grey),);

            // No user submission and day is in past
            } else {
              child = Text((i + startDay - 7).toString(),);
            }

            return Container(
              alignment: Alignment.center,
              child: child,
            );
          }
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    int numMonths = DateUtils.monthDelta(challenge.startDate, challenge.endDate);

    return Column(
      children: [
        Row(
          children: [
            Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Text(
              ' = Submitted, Approved',
              style: TextStyle(color: Colors.grey),
            )
          ]
        ),
        Row(
          children: [
            Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Text(
              ' = Submitted, Pending Approval',
              style: TextStyle(color: Colors.grey),
            )
          ]
        ),
        SizedBox(height: 40,),
        for (int i = 0; i < numMonths; i++)
          generateMonth(
            DateUtils.addMonthsToMonthDate(challenge.startDate, i).month,
            DateUtils.addMonthsToMonthDate(challenge.startDate, i).year,
            context
          )
      ]
    );
  }
}