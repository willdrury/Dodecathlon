import 'package:flutter/material.dart';
import '../models/event.dart';
import '../screens/difficulty_selection_screen.dart';

class SelectDifficultyContainer extends StatelessWidget {
  const SelectDifficultyContainer({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => DifficultySelectionScreen(event: event))
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