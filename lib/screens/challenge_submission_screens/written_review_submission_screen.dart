import 'package:dodecathlon/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/challenge.dart';
import '../../models/submission.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../post_creation_screen.dart';

class WrittenReviewSubmissionScreen extends ConsumerStatefulWidget {
  const WrittenReviewSubmissionScreen({super.key, required this.challenge});

  final Challenge challenge;

  @override
  ConsumerState<WrittenReviewSubmissionScreen> createState() => _WrittenReviewSubmissionScreenState();
}

class _WrittenReviewSubmissionScreenState extends ConsumerState<WrittenReviewSubmissionScreen> {

  bool _shareEnabled = false;
  User? currentUser;
  late TextEditingController _reviewTextController;
  String? errorText;

  @override
  void initState() {
    super.initState();
    _reviewTextController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _reviewTextController.dispose();
  }

  void uploadSubmission(BuildContext ctx) async {
    if (_reviewTextController.text.length < 1000) {
      setState(() {
        errorText = 'Review must be at least 1000 characters long.\nYou are currently at ${_reviewTextController.text.length}';
      });
      return;
    }

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

    if (_shareEnabled) {
      Navigator.of(ctx).push(
        MaterialPageRoute(builder: (ctx) => PostCreationScreen(
          initialDescription: _reviewTextController.text,
          title: 'How does this look?',
        )),
      );
    }
    else if(ctx.mounted) {
      Navigator.of(ctx).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => MainScreen()),
            (Route<dynamic> route) => false,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    currentUser = ref.watch(userProvider)!;

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
                Text('Tell us about what you read!', style: TextStyle(fontSize: 25), textAlign: TextAlign.center,),
                SizedBox(height: 10,),
                Text(
                  'Your review must be at least 1000 characters, or ~200 words',
                  style: TextStyle(fontSize: 15), textAlign: TextAlign.center,
                ),
                SizedBox(height: 30,),
                Container(
                  padding: EdgeInsets.all(20),
                  height: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: TextField(
                    controller: _reviewTextController,
                    maxLines: null,
                    minLines: null,
                    expands: true,
                    decoration: InputDecoration(
                      errorText: errorText,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.groups),
                  title: const Text('Share to feed'),
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