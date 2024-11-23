import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/submission.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/screens/main_screen.dart';
import 'package:dodecathlon/widgets/challenge_submission_widgets/book_submission_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user.dart';

class BookCompletionScreen extends ConsumerStatefulWidget {
  BookCompletionScreen({super.key, required this.challenge, });

  Challenge challenge;

  @override
  ConsumerState<BookCompletionScreen> createState() => _BookCompletionScreenState();
}

class _BookCompletionScreenState extends ConsumerState<BookCompletionScreen> {

  bool _shareEnabled = false;
  User? currentUser;

  void uploadSubmission(BuildContext ctx) async {
    Submission submission = Submission(
      userId: currentUser!.id!,
      points: widget.challenge.maxPoints,
      challengeId: widget.challenge.id,
      isVerified: true,
      isBonus: widget.challenge.isBonus,
    );
    String? error = await submission.upload();

    currentUser!.currentCompetitionPoints[0] = currentUser!.currentCompetitionPoints[0] + widget.challenge.maxPoints;
    currentUser!.currentEventPoints[0] = currentUser!.currentEventPoints[0] + widget.challenge.maxPoints;
    currentUser!.submissions.add(submission.id);
    UserProvider().setUser(currentUser!);

    if(ctx.mounted) {
      Navigator.of(ctx).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => MainScreen()),
            (Route<dynamic> route) => false,
      );
    }

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
                          'Upload', style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary)),
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                Text('Tell us what you read!', style: TextStyle(fontSize: 25), textAlign: TextAlign.center,),
                SizedBox(height: 30,),
                BookSubmissionForm(),
                SizedBox(height: 30,),
                ListTile(
                  leading: const Icon(Icons.groups),
                  title: const Text('Share With Friends'),
                  trailing: Switch(
                    onChanged: (bool? value) {
                      setState(() {
                        _shareEnabled = value!;
                      });
                    },
                    value: _shareEnabled,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}