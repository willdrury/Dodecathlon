import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/challenge.dart';
import '../../models/submission.dart';
import '../../models/user.dart';
import '../post_creation_screen.dart';

class PageCountSubmissionScreen extends ConsumerStatefulWidget {
  PageCountSubmissionScreen({super.key, required this.challenge});

  Challenge challenge;

  @override
  ConsumerState<PageCountSubmissionScreen> createState() => _PageCountSubmissionScreenState();
}

class _PageCountSubmissionScreenState extends ConsumerState<PageCountSubmissionScreen> {

  bool _shareEnabled = false;
  User? currentUser;
  late TextEditingController _pageCountTextController;

  @override
  void initState() {
    super.initState();
    _pageCountTextController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageCountTextController.dispose();
  }

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

    if (_shareEnabled) {
      Navigator.of(ctx).push(
        MaterialPageRoute(builder: (ctx) => PostCreationScreen(
          initialTitle: 'Just finished ${_pageCountTextController.text} pages!',
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
                SizedBox(height: 100,),
                Text('How many pages have you\nread this month?', style: TextStyle(fontSize: 25), textAlign: TextAlign.center,),
                SizedBox(height: 100,),
                Container(
                  height: 100,
                  width: 200,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black12)
                  ),
                  child: TextField(
                    controller: _pageCountTextController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 60),
                    textAlign: TextAlign.center,
                    maxLength: 3,
                    cursorHeight: 60,
                    decoration: InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      hintText: '000',
                      hintStyle: TextStyle(color: Colors.black12, height: .1),
                    ),
                  ),
                ),
                SizedBox(height: 100,),
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