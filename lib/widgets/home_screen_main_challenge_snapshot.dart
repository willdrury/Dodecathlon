import 'dart:math';

import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/submission.dart';
import 'package:dodecathlon/models/user.dart';
import 'package:dodecathlon/providers/submission_provider.dart';
import 'package:dodecathlon/screens/challenge_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/event.dart';

class HomeScreenMainChallengeSnapshot extends ConsumerWidget {

  const HomeScreenMainChallengeSnapshot({
    super.key,
    required this.challenge,
    required this.user,
    required this.event
  });

  final Challenge challenge;
  final User user;
  final Event event;

  // TODO: move to utility class
  String toWeekday(int day) {
    switch (day) {
      case 0:
        return 'Sun';
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
    }
    return '';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    AsyncValue<List<Submission>> submissions = ref.watch(submissionsProvider);
    List<Submission> challengeSubmissions = submissions.value!.where((s) =>
      s.challengeId == challenge.id && s.userId == user.id
    ).toList();

    int startDay = DateTime.now().weekday;
    int numVisibleDays = min(7, DateTime.now().difference(challenge.startDate).inDays);
    Map<int, bool> completedSubmissionMap = {};

    for (int i = numVisibleDays - 1; i >= 0; i--) {
      completedSubmissionMap[(startDay + i) % 7] = false;
    }

    List<Submission> userSubmissionsByDate = submissions.value!.where((s) =>
      s.challengeId == challenge.id &&
      s.userId == user.id &&
      s.isApproved &&
      s.createdDate.isAfter(DateTime.now().subtract(Duration(days: 7))) &&
      s.createdDate.isAfter(challenge.startDate)
    ).toList()..sort((a,b) => a.createdDate.isAfter(b.createdDate) ? 0 : 1);

    // TODO: Verify this is sorting and counting correctly. May also want to move elsewhere and/or make more efficient
    int tempStreak = 0;
    int currentStreak = 0;
    int maxStreak = 0;
    DateTime currentDay = DateTime.now();
    DateTime prevDay = DateTime.now();
    bool inStreak = true;
    for (Submission s in userSubmissionsByDate) {
      completedSubmissionMap[s.createdDate.weekday] = true;

      if (s.createdDate.day == currentDay.day) {
        if (inStreak) currentStreak++;
        tempStreak++;
        prevDay = currentDay;
        currentDay = currentDay.subtract(Duration(days: 1));
        if (tempStreak >= maxStreak) {
          maxStreak = tempStreak;
        }
      } else if (s.createdDate.day != currentDay.day && s.createdDate.day != prevDay.day) {
        inStreak = false;
        tempStreak = 0;
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => ChallengeDetailsScreen(
              challenge: challenge,
              isCompleted: false,
              event: event,
            ))
        );
      },
      child: Container(
        height: 80,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
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
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(challenge.name),
                Spacer(),
                Text(
                  'Current Streak: $currentStreak',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                )
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int day = 1; day <= 7; day++)
                  Column(
                    children: [
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: ((day + startDay) % 7) == DateTime.now().weekday
                            ? Border.all(color: Theme.of(context).colorScheme.primary)
                            : null
                        ),
                        child: completedSubmissionMap[((day + startDay) % 7) ]!
                          ? Icon(Icons.check, color: Colors.green,)
                          : ((day + startDay) % 7)  == DateTime.now().weekday
                            ? null
                            : Icon(Icons.close, color: Theme.of(context).colorScheme.primary),
                      ),
                      Text(toWeekday(((day + startDay) % 7) ), style: TextStyle(fontSize: 10),)
                    ],
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}