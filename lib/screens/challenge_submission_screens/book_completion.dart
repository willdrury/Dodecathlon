import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/submission.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/screens/main_screen.dart';
import 'package:dodecathlon/screens/post_creation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user.dart';

class BookCompletionScreen extends ConsumerStatefulWidget {
  const BookCompletionScreen({super.key, required this.challenge, });

  final Challenge challenge;

  @override
  ConsumerState<BookCompletionScreen> createState() => _BookCompletionScreenState();
}

class _BookCompletionScreenState extends ConsumerState<BookCompletionScreen> {

  bool _shareEnabled = false;
  User? currentUser;

  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _reviewController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _authorController = TextEditingController();
    _reviewController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _authorController.dispose();
    _reviewController.dispose();
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
          initialTitle: '${currentUser!.userName} just finished ${_titleController.text}',
          initialDescription: _reviewController.text,
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
                Stack(
                  children: [
                    Container(
                      height: 500,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color.fromARGB(255, 250, 248, 198),
                          boxShadow: [
                            BoxShadow(color: Colors.grey, blurRadius: 10, spreadRadius: 1, offset: Offset(0, 10))
                          ]
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          for (var i = 0; i < 18; i++)
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Divider(color: Colors.grey.withAlpha(50),),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      height: 500,
                      width: 300,
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _titleController,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText: 'Title',
                              hintStyle: TextStyle(fontSize: 30, color: Colors.black26),
                              border: InputBorder.none,
                            ),
                          ),
                          TextField(
                            controller: _authorController,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30),
                            decoration: InputDecoration(
                              hintText: 'Author',
                              hintStyle: TextStyle(fontSize: 30, color: Colors.black26),
                              border: InputBorder.none,
                            ),
                          ),
                          SizedBox(height: 50,),
                          TextField(
                            controller: _reviewController,
                            maxLines: 7,
                            decoration: InputDecoration(
                                hintText: 'Review (optional)',
                                hintStyle: TextStyle(fontSize: 20, color: Colors.black26),
                                border: InputBorder.none
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30,),
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