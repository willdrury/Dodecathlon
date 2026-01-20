import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/submission.dart';
import 'package:dodecathlon/providers/challenges_provider.dart';
import 'package:dodecathlon/providers/submission_provider.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/widgets/submission_tile_small.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post.dart';
import '../models/user.dart';

class SubmissionApprovalScreen extends ConsumerWidget {
  const SubmissionApprovalScreen({
    super.key,
    required this.submission,
    required this.post,
  });

  final Submission submission;
  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<Challenge>> challengeStream = ref.read(challengesProvider);
    User? user = ref.read(userProvider);

    if (!challengeStream.hasValue || user == null) {
      return Center(child: CircularProgressIndicator(),);
    }

    Challenge challenge = challengeStream.value!.firstWhere((c) =>
      c.id == submission.challengeId
    );

    return Scaffold(
      backgroundColor: Color.lerp(Colors.white, Theme.of(context).colorScheme.primaryContainer, 0.1),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 10),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back)
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${post.user!.userName} is trying to create a submission for the following challenge:',
                        style: TextStyle(fontSize: 20),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.only(top: 20, bottom: 70),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black12),
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
                            Text(challenge.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                            SizedBox(height: 20,),
                            Text(challenge.description, style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),
                      Text(
                        'Based on the submission below, do you believe that this user meets the challenge requirements?',
                        style: TextStyle(fontSize: 20),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.only(top: 20, bottom: 70),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black12),
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
                            Text(post.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                            SizedBox(height: 20,),
                            if (post.imageUrl != null)
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 5
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          offset: Offset(0, 5),
                                          spreadRadius: 1,
                                          blurRadius: 5
                                      )
                                    ]
                                  ),
                                  constraints: BoxConstraints(
                                    maxHeight: 300,
                                  ),
                                  child: Image.network(
                                    post.imageUrl!,
                                    fit: BoxFit.fitWidth,
                                    frameBuilder: (_, image, loadingBuilder, __) {
                                      if (loadingBuilder == null) {
                                        return const SizedBox(
                                          height: 300,
                                          child: Center(child: CircularProgressIndicator()),
                                        );
                                      }
                                      return image;
                                    },
                                    loadingBuilder: (BuildContext ctx, Widget child, ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const SizedBox(
                                        height: 300,
                                        child: Center(child: CircularProgressIndicator()),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            SizedBox(height: 30,),
                            Text(post.description!, style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FilledButton.icon(
                            label: Text(
                              'Approve',
                              style: TextStyle(fontSize: 20, color: Colors.green),),
                            onPressed: () {
                              submission.isApproved = true;
                              submission.upload();
                            },
                            icon: Icon(
                              Icons.thumb_up_rounded,
                              color: Colors.green,
                              size: 20,
                            ),
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(Colors.white),
                              shadowColor: WidgetStatePropertyAll(Colors.black38),
                              elevation: WidgetStatePropertyAll(5)
                            ),
                          ),
                          SizedBox(width: 20,),
                          FilledButton.icon(
                            label: Text(
                              'Deny',
                              style: TextStyle(fontSize: 20, color: Colors.red),
                            ),
                            onPressed: () {
                              // TODO: handle better
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.thumb_down_sharp,
                              color: Colors.red,
                              size: 20,
                            ),
                            style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(Colors.white),
                                shadowColor: WidgetStatePropertyAll(Colors.black38),
                                elevation: WidgetStatePropertyAll(5)
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Align(
                        alignment: Alignment.center,
                        child: FilledButton.icon(
                          label: Text(
                            'Not enough info',
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                          onPressed: () {
                            // TODO: handle better
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.question_mark,
                            size: 20,
                            color: Colors.grey,
                          ),
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(Colors.white),
                              shadowColor: WidgetStatePropertyAll(Colors.black38),
                              elevation: WidgetStatePropertyAll(5)
                          ),
                        ),
                      ),
                      SizedBox(height: 200,),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}