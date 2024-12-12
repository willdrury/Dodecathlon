import 'package:dodecathlon/data/competition_2025/competition.dart';
import 'package:dodecathlon/data/competition_2025/reading.dart';
import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/competition.dart';
import 'package:dodecathlon/models/submission.dart';
import 'package:dodecathlon/providers/submission_provider.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
import '../widgets/select_difficulty_container.dart';

class SubmissionSelectionScreen extends ConsumerStatefulWidget {
  SubmissionSelectionScreen({super.key});

  @override
  ConsumerState<SubmissionSelectionScreen> createState() => _SubmissionSelectionScreenState();
}

class _SubmissionSelectionScreenState extends ConsumerState<SubmissionSelectionScreen> {

  Competition comp = competition2025;
  final int eventIndex = 0;
  List<Challenge> challenges = readingChallenges;
  Challenge? _currentSelection;

  void onSelected(Challenge? selectedChallenge) {
    setState(() {
      _currentSelection = selectedChallenge;
    });
  }

  void onNext() {
    if (_currentSelection == null) return;
    Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => _currentSelection!.getSubmissionScreen({
          'challenge': _currentSelection,
        }))
    );
  }

  @override
  Widget build(BuildContext context) {

    User currentUser = ref.watch(userProvider)!;
    List<Submission> userSubmissions = ref.watch(submissionsProvider);
    List<String> completedChallengeIds = userSubmissions.map((s) => s.challengeId).toList();
    final now = DateTime.now();

    if (currentUser.currentEventDifficulty.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: SelectDifficultyContainer(eventIndex: eventIndex),
      );
    }

    List<Challenge> bonusChallenges = challenges.where((c) =>
      c.isBonus &&
      !completedChallengeIds.contains(c.id) &&
      c.startDate.isBefore(now) &&
      c.endDate.isAfter(now) &&
      (c.difficulty == currentUser.currentEventDifficulty[0] || c.difficulty == Difficulty.all)
    ).toList();
    List<Challenge> mainChallenges = challenges.where((c) =>
      !c.isBonus &&
      !completedChallengeIds.contains(c.id) &&
      c.startDate.isBefore(now) &&
      c.endDate.isAfter(now) &&
      (c.difficulty == currentUser.currentEventDifficulty[0] || c.difficulty == Difficulty.all)
    ).toList();
    List<Challenge> completedChallenges = challenges.where((c) =>
        completedChallengeIds.contains(c.id)
    ).toList();

    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer.withAlpha(10),
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close', style: TextStyle(fontSize: 20, color: Colors.black)),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: onNext,
                    child: Text(
                        'Next', style: TextStyle(fontSize: 20, color: _currentSelection == null ? Colors.grey : Theme.of(context).colorScheme.primary)),
                  ),
                ],
              ),
              SizedBox(height: 30,),
              Text('Which challenge are you submitting?', style: TextStyle(fontSize: 25), textAlign: TextAlign.center,),
              SizedBox(height: 30,),
              Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(),
                        Text('Bonus'),
                        if (bonusChallenges.isEmpty)
                          ListTile(title: Text('Check back later!', style: TextStyle(color: Colors.grey),),),                          // Text('None', style: TextStyle(color: Colors.grey),),
                        for (Challenge challenge in bonusChallenges)
                          ListTile(
                            leading: Radio<Challenge>(
                                value: challenge,
                                groupValue: _currentSelection,
                                onChanged: onSelected
                            ),
                            title: Text(challenge.name),
                            subtitle: Text('Expires in'),
                            trailing: Text(challenge.maxPoints.toString()),
                          ),
                        Divider(),
                        Text('Main'),
                        if (mainChallenges.isEmpty)
                          ListTile(title: Text('All Done!', style: TextStyle(color: Colors.grey),),),
                        for (Challenge challenge in mainChallenges)
                          ListTile(
                            leading: Radio<Challenge>(
                                value: challenge,
                                groupValue: _currentSelection,
                                onChanged: onSelected
                            ),
                            title: Text(challenge.name),
                            trailing: Text(challenge.maxPoints.toString()),
                          ),
                        Divider(),
                        Text('Completed'),
                        for (Challenge challenge in completedChallenges)
                          ListTile(
                            leading: Icon(Icons.radio_button_checked, color: Colors.grey,),
                            title: Text(challenge.name, style: TextStyle(color: Colors.grey),),
                            trailing: Text(challenge.maxPoints.toString()),
                          ),
                      ],
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}