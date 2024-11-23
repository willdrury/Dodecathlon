import 'package:dodecathlon/models/user.dart';
import 'package:dodecathlon/utilities/color_utility.dart';
import 'package:flutter/material.dart';

class EventProgressBar extends StatefulWidget {
  EventProgressBar({super.key, required this.user, required this.mainPoints, required this.bonusPoints});

  User user;
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
    return Container(
      height: 40,
      width: 300,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black26
      ),
      child: Stack(
          children: [
            Container(
              height: 40,
              width: 300 * (widget.mainPoints + widget.bonusPoints) / 100,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorUtility().lighten(Colors.blue, .2),
                      Colors.blue,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                  )
              ),
            ),
            Container(
              height: 40,
              width: 300 * widget.mainPoints / 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
                  gradient: LinearGradient(
                      colors: [
                        ColorUtility().lighten(Theme.of(context).colorScheme.primary, .2),
                        Theme.of(context).colorScheme.primary,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                  )
              ),
            ),
          ],
        ),
    );
  }
}