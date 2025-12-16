import 'package:dodecathlon/models/event.dart';
import 'package:flutter/material.dart';

class NextEventDetails extends StatelessWidget {
  const NextEventDetails({
    super.key,
    required this.currentEvent,
  });

  final Event currentEvent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Check back when the event has started to see a full list of challenges!')
        ],
      ),
    );
  }
}