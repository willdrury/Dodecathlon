import 'package:dodecathlon/models/challenge.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/event.dart';

final formatter = DateFormat('MMM d');

class BonusChallengeCard extends StatelessWidget {
  const BonusChallengeCard({super.key, required this.challenge, required this.event});

  final Challenge challenge;
  final Event event;

  @override
  Widget build(BuildContext context) {

    Widget displayImage = challenge.imageUrl == null
        ? Expanded(
      child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: event.themeColor,
          ),
          child: Icon(event.icon, size: 50, color: Colors.white,)
      ),
    )
        : Expanded(
      child: Hero(
        tag: challenge.id,
        child: Image.network(
          width: double.infinity,
          challenge.imageUrl!,
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext ctx, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        displayImage,
        Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black87,
                    offset: Offset(0, 0),
                    blurRadius: 10,
                  )
                ]
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    challenge.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                    maxLines: 1,
                  ),
                  Text(
                    '(${challenge.maxPoints.toString()} pts)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                    maxLines: 1,
                  ),
                  Spacer(),
                  Text(
                    'Ends ${formatter.format(challenge.endDate)}',
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ],
              ),
            )
        )
      ],
    );
  }
}