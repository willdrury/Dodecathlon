import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/submission.dart';
import 'package:dodecathlon/providers/events_provider.dart';
import 'package:dodecathlon/providers/submission_provider.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event.dart';
import '../models/user.dart';
import '../providers/challenges_provider.dart';
import '../widgets/select_difficulty_container.dart';

class SubmissionSelectionScreen extends ConsumerStatefulWidget {
  SubmissionSelectionScreen({super.key});

  @override
  ConsumerState<SubmissionSelectionScreen> createState() => _SubmissionSelectionScreenState();
}

class _SubmissionSelectionScreenState extends ConsumerState<SubmissionSelectionScreen> {

  Challenge? _currentSelection;

  void onSelected(Challenge? selectedChallenge) {
    setState(() {
      _currentSelection = selectedChallenge;
    });
  }

  void onNext(BuildContext ctx, List<Challenge> challenges) {
    if (_currentSelection == null) return;

    if (_currentSelection!.conflictingChallenges.isNotEmpty) {
      String conflictingChallengeNames = _currentSelection!.conflictingChallenges.map((c) {
        return challenges.where((c1) => c1.id == c).first.name;
      }).toList().join('\n');
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Attention!'),
            content: Text(
              'If you submit this challenge you will be unable to submit the following other challenges:\n\n$conflictingChallengeNames',
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Continue'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => _currentSelection!.getSubmissionScreen({
                        'challenge': _currentSelection,
                      }))
                  );
                },
              ),
            ],
          );
        },
      );
    } else {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => _currentSelection!.getSubmissionScreen({
            'challenge': _currentSelection,
          }))
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final DateTime now = DateTime.now();
    User currentUser = ref.watch(userProvider)!;
    List<Event> events = ref.watch(eventProvider);
      Event currentEvent = events.where((e) =>
        e.startDate.isBefore(now) & e.endDate.isAfter(now)
    ).first;
    List<Submission> userSubmissions = ref.watch(submissionsProvider);
    List<String> completedChallengeIds = userSubmissions.map((s) => s.challengeId).toList();
    AsyncValue<List<Challenge>> challenges = ref.watch(challengesProvider);
    List<Challenge> eventChallenges = [];
    if (challenges.hasValue) {
      eventChallenges = challenges.value!.where((c) => c.eventId == currentEvent.id).toList();
    }

    if (currentUser.currentEventDifficulty == null) {
      return Scaffold(
        appBar: AppBar(),
        body: SelectDifficultyContainer(event: currentEvent),
      );
    }

    List<Challenge> bonusChallenges = eventChallenges.where((c) =>
      c.isBonus &&
      !completedChallengeIds.contains(c.id) &&
      c.startDate.isBefore(now) &&
      c.endDate.isAfter(now) &&
      c.conflictingChallenges.every((e) => !completedChallengeIds.contains(e)) &&
      c.prerequisiteChallenges.every((e) => completedChallengeIds.contains(e)) &&
      (c.difficulty == currentUser.currentEventDifficulty || c.difficulty == Difficulty.all)
    ).toList();
    List<Challenge> mainChallenges = eventChallenges.where((c) =>
      !c.isBonus &&
      !completedChallengeIds.contains(c.id) &&
      c.startDate.isBefore(now) &&
      c.endDate.isAfter(now) &&
      c.conflictingChallenges.every((e) => !completedChallengeIds.contains(e)) &&
      c.prerequisiteChallenges.every((e) => completedChallengeIds.contains(e)) &&
      (c.difficulty == currentUser.currentEventDifficulty || c.difficulty == Difficulty.all)
    ).toList();
    List<Challenge> completedChallenges = eventChallenges.where((c) =>
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
                    onPressed: () {
                      onNext(context, eventChallenges);
                    },
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
                          ListTile(title: Text('All Done!', style: TextStyle(color: Colors.grey),),),                          // Text('None', style: TextStyle(color: Colors.grey),),
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