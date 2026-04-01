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
            if (i < 7) {
              child = dayLabels[i];
            }
            else if (i + startDay - 7 <= 0 || i + startDay - 7 > DateUtils.getDaysInMonth(year, month)) {
              child = Text('');
            }
            else if (completedSubmissionMap.containsKey(i + startDay - 7)) {
              bool extendLeft = completedSubmissionMap.containsKey(i + startDay - 8);
              bool extendRight = completedSubmissionMap.containsKey(i + startDay - 6);
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
            else if (i + startDay - 7 > now.day && now.month >= month && now.year >= year){
              child = Text((i + startDay - 7).toString(), style: TextStyle(color: Colors.grey),);
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