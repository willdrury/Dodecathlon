import 'package:dodecathlon/models/user.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/submission.dart';
import '../providers/submission_provider.dart';

class HomeScreenEventSnapshot extends ConsumerWidget {

  const HomeScreenEventSnapshot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User user = ref.read(userProvider)!;

    List<Submission> userSubmissions = ref.watch(submissionsProvider);
    List<String> challengeSubmissions = userSubmissions.map((s) => s.challengeId).toList();

    int prevRank = 22;
    int currRank = 20;
    int rankDiff = prevRank - currRank;
    bool showDiffIcon = rankDiff != 0;
    Color textColor;

    if (rankDiff == 0) {
      textColor = Colors.grey;
    } else if (rankDiff > 1) {
      textColor = Colors.green;
    } else {
      textColor = Colors.red;
    }

    return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 5),
                  spreadRadius: 1,
                  blurRadius: 5
              )
            ]
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Weekly progress:"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 7; i++)
                  Container(
                    margin: EdgeInsets.all(10),
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black)
                    ),
                  ),
              ],
            ),
          ],
        )
    );
  }
}