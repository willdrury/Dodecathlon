import 'package:dodecathlon/models/challenge.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat('MMM d');

class BonusChallengeCard extends StatelessWidget {
  BonusChallengeCard({super.key, required this.challenge});

  Challenge challenge;

  @override
  Widget build(BuildContext context) {

    Widget overlay = Container(
      padding: EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
          // border: challenge.endDate == null ? null : Border.all(
          //     color: Colors.blue,
          //     width: 4
          // ),
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Color.fromARGB(0, 255, 255, 255), Color.fromARGB(255, 80, 80, 80)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              challenge.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)
          ),
          if (challenge.endDate != null)
            Text(
              'Ends: ${formatter.format(challenge.endDate!)}',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
        ],
      ),
    );

    return Stack(
      children: [
        if (challenge.imageUrl != null)
          Hero(
            tag: challenge.id,
            child: Image.network(challenge.imageUrl!, fit: BoxFit.fill, height: double.infinity,)
          ),
        overlay,
      ]
    );
  }
}