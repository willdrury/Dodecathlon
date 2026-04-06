import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/submission.dart';
import 'package:dodecathlon/providers/submission_provider.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/widgets/streak_calendar.dart';
import 'package:dodecathlon/widgets/submission_tile_small.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/event.dart';
import '../models/user.dart';

class ChallengeDetailsScreen extends ConsumerWidget {
  const ChallengeDetailsScreen({
    super.key,
    required this.challenge,
    required this.isCompleted,
    required this.event,
  });

  final Challenge challenge;
  final bool isCompleted;
  final Event event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<Submission>> submissions = ref.read(submissionsProvider);
    AsyncValue<User?> userStream = ref.watch(userProvider);
    if (!userStream.hasValue) {
      return const Center(child: CircularProgressIndicator(),);
    }

    User user = userStream.value!;

    List<Submission> challengeSubmissions = [];
    if (submissions.hasValue) {
      challengeSubmissions = submissions.value!.where((s) =>
          s.userId == user.id && s.challengeId == challenge.id
      ).toList();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(challenge.name),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (challenge.imageUrl != null)
                Hero(
                    tag: challenge.id,
                    child: Image.network(challenge.imageUrl!, fit: BoxFit.fitWidth, height: 250, width: double.infinity,),
                ),
              if (challenge.imageUrl == null)
                Container(
                  height: 250,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: event.themeColor,
                  ),
                  child: Icon(event.icon, size: 50, color: Colors.white,)
                ),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Description', style: TextStyle(color: Colors.grey, fontSize: 10),),
                    Text(challenge.description),
                    SizedBox(height: 20,),
                    if (!isCompleted)
                      FilledButton(
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (ctx) => challenge.getSubmissionScreen({
                                'challenge': challenge,
                              }))
                          );
                        },
                        child: Text('Submit now!')
                      ),
                    if (challenge.isRecurring)
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20,),
                            Divider(),
                            SizedBox(height: 20,),
                            ExpansionTile(
                              title: Text('Submission History'),
                              shape: Border(),
                              children: [
                                SizedBox(height: 20,),
                                StreakCalendar(challenge: challenge, challengeSubmissions: challengeSubmissions),
                                SizedBox(height: 50,),
                              ],
                            ),
                          ],
                        )
                      ),
                    if (isCompleted && !challenge.isRecurring)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Divider(),
                          SizedBox(height: 20,),
                          Text(
                            'Submissions',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: 20,),
                          ListView.builder(
                            itemCount: challengeSubmissions.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, i) {
                              return SubmissionTileSmall(submission: challengeSubmissions[i]);
                            }
                          )
                        ],
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}