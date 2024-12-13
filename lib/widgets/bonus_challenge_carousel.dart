import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/screens/challenge_details_screen.dart';
import 'package:dodecathlon/widgets/bonus_challenge_card.dart';
import 'package:flutter/material.dart';

class BonusChallengeCarousel extends StatefulWidget {
  BonusChallengeCarousel({super.key, required this.challenges});

  List<Challenge> challenges;

  @override
  State<StatefulWidget> createState() {
    return _BonusChallengeCarouselState();
  }
}

class _BonusChallengeCarouselState extends State<BonusChallengeCarousel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 120,
          child: CarouselView(
              elevation: 5,
              padding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              itemExtent: 150,
              shrinkExtent: 150,
              onTap: (int valueChanged) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => ChallengeDetailsScreen(challenge: widget.challenges[valueChanged]))
                );
              },
              children: [
                for (Challenge challenge in widget.challenges)
                  BonusChallengeCard(challenge: challenge,)
              ]
          ),
        )
      ],
    );
  }
}