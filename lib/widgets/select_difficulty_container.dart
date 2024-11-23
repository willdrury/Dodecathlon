import 'package:flutter/material.dart';

import '../data/competition_2025/competition.dart';
import '../screens/difficulty_selection_screen.dart';

class SelectDifficultyContainer extends StatelessWidget {
  SelectDifficultyContainer({super.key, required this.eventIndex});

  final int eventIndex;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => DifficultySelectionScreen(event: competition2025.events[eventIndex]))
        );
      },
      child: Container(
        height: 300,
        width: double.infinity,
        color: Colors.white,
        child: Center(child: Text(
          'Select a difficulty to get started!',
          style: TextStyle(fontSize: 30),
          textAlign: TextAlign.center,
        )),
      ),
    );
  }
}