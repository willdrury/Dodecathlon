import 'package:dodecathlon/models/event.dart';
import 'package:dodecathlon/screens/difficulty_selection_screen.dart';
import 'package:flutter/material.dart';

class NewEventDescriptionScreen extends StatelessWidget {
  const NewEventDescriptionScreen({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Back'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => DifficultySelectionScreen(event: event))
                  );
                },
                child: Text('Next'),
            )
          ],
        ),
      ),
    );
  }
}