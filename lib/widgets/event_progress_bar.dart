import 'package:dodecathlon/models/user.dart';
import 'package:flutter/material.dart';

class EventProgressBar extends StatefulWidget {
  const EventProgressBar({super.key, required this.user, required this.mainPoints, required this.bonusPoints});

  final User user;
  final int mainPoints;
  final int bonusPoints;

  @override
  State<StatefulWidget> createState() {
    return _EventProgressBarState();
  }
}

class _EventProgressBarState extends State<EventProgressBar> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 280,
          width: 280,
          child:  CircularProgressIndicator(
            value: .5,
            strokeWidth: 8,
            strokeCap: StrokeCap.round,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        Container(
          height: 250,
          width: 250,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white
          ),
        ),
        Text('35 of 80'),
      ],
    );
  }
}