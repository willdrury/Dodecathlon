import 'package:dodecathlon/models/challenge.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/event.dart';

final formatter = DateFormat('MMM d');

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({super.key, required this.challenge, required this.event});

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
            // gradient: LinearGradient(
            //   colors: [event.themeColor, event.themeColor.withAlpha(100)],
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter
            // )
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
          height: 100,
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
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      challenge.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(
                      '${challenge.maxPoints.toString()} pts',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  challenge.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Spacer(),
                Text(
                  'Ends ${formatter.format(challenge.endDate)}',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
        )
      ],
    );
  }
}