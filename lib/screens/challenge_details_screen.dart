import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/submission.dart';
import 'package:dodecathlon/providers/submission_provider.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/widgets/submission_tile_small.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';

class ChallengeDetailsScreen extends ConsumerWidget {
  const ChallengeDetailsScreen({
    super.key,
    required this.challenge,
    required this.isCompleted,
  });

  final Challenge challenge;
  final bool isCompleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<Submission>> submissions = ref.read(submissionsProvider);
    User? user = ref.read(userProvider);

    List<Submission> challengeSubmissions = [];
    if (submissions.hasValue && user != null) {
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
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    if (isCompleted)
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