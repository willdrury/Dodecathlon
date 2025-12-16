import 'package:dodecathlon/models/challenge.dart';
import 'package:flutter/material.dart';

class ChallengeDetailsScreen extends StatelessWidget {
  const ChallengeDetailsScreen({super.key, required this.challenge});

  final Challenge challenge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(challenge.name),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (challenge.imageUrl != null)
              Hero(
                  tag: challenge.id,
                  child: Image.network(challenge.imageUrl!, fit: BoxFit.fitWidth, height: 250, width: double.infinity,),
              ),
            Container(
              padding: EdgeInsets.all(20),
              child: Text(challenge.description),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => challenge.getSubmissionScreen({
                          'challenge': challenge,
                        }))
                    );
                  },
                  child: Text('Submit now!')
              ),
            ),
          ],
        ),
    );
  }
}