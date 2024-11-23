import 'package:dodecathlon/models/challenge.dart';
import 'package:flutter/material.dart';

class ChallengeCard extends StatelessWidget {
  ChallengeCard({super.key, required this.challenge});

  Challenge challenge;

  @override
  Widget build(BuildContext context) {

    Widget overlay = Container(
      padding: EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: challenge.imageUrl != null
              ? [Color.fromARGB(0, 255, 255, 255),  Color.fromARGB(255, 80, 80, 80)]
              : [Theme.of(context).colorScheme.primaryContainer, Theme.of(context).colorScheme.primary],
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
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)
          ),
          Text(
            'Max Points: ${challenge.maxPoints}',
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
                child: Image.network(challenge.imageUrl!, fit: BoxFit.cover, height: double.infinity,)
            ),
          overlay,
        ]
    );
  }
}