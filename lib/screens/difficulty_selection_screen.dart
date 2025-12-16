import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/event.dart';
import 'package:dodecathlon/models/user.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/widgets/difficulty_selection_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'main_screen.dart';

class DifficultySelectionScreen extends ConsumerStatefulWidget {
  const DifficultySelectionScreen({super.key, required this.event});

  final Event event;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _DifficultySelectionScreenState();
  }
}

class _DifficultySelectionScreenState extends ConsumerState<DifficultySelectionScreen> {

  Future<void> _dialogBuilder(BuildContext context, int value, User currentUser) {
    Difficulty difficulty = Difficulty.all;
    String difficultyString = '';
    switch (value) {
      case 0:
        difficulty = Difficulty.beginner;
        difficultyString = 'Beginner';
      case 1:
        difficulty = Difficulty.intermediate;
        difficultyString = 'Intermediate';
      case 2:
        difficulty = Difficulty.advanced;
        difficultyString = 'Advanced';
    }

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: Text(
            'Once you have selected a difficulty, you will be unable to change your selection. Are you sure you want to compete in the $difficultyString category?',
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
                currentUser.currentEventDifficulty = difficulty;
                UserProvider().setUser(currentUser);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (ctx) => MainScreen()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    User currentUser = ref.watch(userProvider)!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Difficulty Selection'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20,),
          SizedBox(
            height: 700,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              child: CarouselView(
                  onTap: (int valueChanged) {
                    _dialogBuilder(context, valueChanged, currentUser);
                  },
                  elevation: 5,
                  itemSnapping: true,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  itemExtent: 350,
                  shrinkExtent: 350,
                  children: [
                    DifficultySelectionCard(
                        themeColor: Colors.green,
                        title: 'Beginner',
                        subtitle: 'Max points: 60',
                        description: widget.event.beginnerDescription!,
                    ),
                    DifficultySelectionCard(
                        themeColor: Colors.orange,
                        title: 'Intermediate',
                        subtitle: 'Max points: 80',
                        description: widget.event.intermediateDescription!
                    ),
                    DifficultySelectionCard(
                        themeColor: Colors.red,
                        title: 'Advanced',
                        subtitle: 'Max points: 100',
                        description: widget.event.advancedDescription!
                    ),
                  ]
              ),
            ),
          ),
        ],
      ),
    );
  }
}