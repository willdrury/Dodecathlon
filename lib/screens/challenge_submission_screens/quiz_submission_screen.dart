import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/providers/quiz_provider.dart';
import 'package:dodecathlon/screens/quiz_start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/quiz.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';

class QuizSubmissionScreen extends ConsumerStatefulWidget {
  const QuizSubmissionScreen({super.key, required this.challenge});

  final Challenge challenge;

  @override
  ConsumerState<QuizSubmissionScreen> createState() => _QuizSubmissionScreenState();
}

class _QuizSubmissionScreenState extends ConsumerState<QuizSubmissionScreen> {

  final bool _shareEnabled = false;
  User? currentUser;

  @override
  Widget build(BuildContext context) {
    AsyncValue<User?> userStream = ref.watch(userProvider);
    if (!userStream.hasValue) {
      return const Center(child: CircularProgressIndicator(),);
    }

    AsyncValue<List<Quiz>> quizStream = ref.watch(quizProvider);

    if (!quizStream.hasValue) {
      return const Center(child: CircularProgressIndicator(),);
    }

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
                  ],
                ),
                SizedBox(height: 30,),
                Text('Answer the following questions', style: TextStyle(fontSize: 25), textAlign: TextAlign.center,),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) =>
                      QuizStartScreen(quiz: quizStream.value![0]) // TODO: Use quiz ID tied to challenge
                    ));
                  },
                  child: Text('Begin')
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}