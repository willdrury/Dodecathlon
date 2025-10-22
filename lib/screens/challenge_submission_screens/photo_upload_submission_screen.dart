import 'package:dodecathlon/models/challenge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/submission.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../post_creation_screen.dart';

class PhotoUploadSubmissionScreen extends ConsumerStatefulWidget {
  const PhotoUploadSubmissionScreen({super.key, required this.challenge});

  final Challenge challenge;

  @override
  ConsumerState<PhotoUploadSubmissionScreen> createState() => _PhotoUploadSubmissionScreenState();
}

class _PhotoUploadSubmissionScreenState extends ConsumerState<PhotoUploadSubmissionScreen> {

  bool _shareEnabled = false;
  User? currentUser;

  void uploadSubmission(BuildContext ctx) async {
    Submission submission = Submission(
      userId: currentUser!.id!,
      points: 0,
      challengeId: widget.challenge.id,
      isVerified: true,
      isBonus: widget.challenge.isBonus,
    );
    String? error = await submission.upload();

    currentUser!.currentCompetitionPoints[0] = currentUser!.currentCompetitionPoints[0] + widget.challenge.maxPoints;
    currentUser!.currentEventPoints[0] = currentUser!.currentEventPoints[0] + widget.challenge.maxPoints;
    currentUser!.submissions.add(submission.id);
    UserProvider().setUser(currentUser!);

    Navigator.of(ctx).push(
      MaterialPageRoute(builder: (ctx) => PostCreationScreen(
        title: 'Tell us about what you did!',
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    currentUser = ref.read(userProvider)!;

    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer.withAlpha(10),
        padding: EdgeInsets.all(20),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Back', style: TextStyle(fontSize: 20, color: Colors.black)),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        uploadSubmission(context);
                      },
                      child: Text(
                          'Next', style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary)),
                    ),
                  ],
                ),
                SizedBox(height: 60,),
                Text(
                  'To get credit for this challenge, submit a post with evidence of yourself completing the challenge. '
                      'This can be a photo, description of what happened, or anything else which can be used as proof. \n\n'
                      'Once submitted, it will need to be approved by another user in order to receive full points.\n\n'
                      'Click "Next" to submit your evidence!',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}