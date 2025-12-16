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

  User? currentUser;

  void navigateToPostCreationScreen(BuildContext ctx) async {
    if (ctx.mounted) {
      Navigator.of(ctx).push(
        MaterialPageRoute(builder: (ctx) => PostCreationScreen(
          title: 'Tell us about what you did!',
          challenge: widget.challenge,
        )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    currentUser = ref.read(userProvider)!;

    return Scaffold(
      body: Container(
        height: double.infinity,
        color: Theme.of(context).colorScheme.primaryContainer.withAlpha(50),
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
                        navigateToPostCreationScreen(context);
                      },
                      child: Text(
                          'Next', style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary)),
                    ),
                  ],
                ),
                SizedBox(height: 40,),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 5),
                          spreadRadius: 1,
                          blurRadius: 10
                      )
                    ]
                  ),
                  child: Column(
                    children: [
                      Text(
                        'To get credit for this challenge, submit a post with evidence of yourself completing the challenge. '
                            'This can be a photo, description of what happened, or anything else which can be used as proof. \n\n'
                            'Once submitted, it will need to be approved by another user in order to receive full points.\n\n'
                            'Click "Next" to submit your evidence!',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 40,),
                      FilledButton(
                        onPressed: () {
                          navigateToPostCreationScreen(context);
                        },
                        child: Text(
                          'Next',
                          style: TextStyle(fontSize: 20)
                        )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}