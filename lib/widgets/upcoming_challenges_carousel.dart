import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/screens/challenge_details_screen.dart';
import 'package:dodecathlon/screens/events_screen.dart';
import 'package:dodecathlon/widgets/bonus_challenge_card.dart';
import 'package:dodecathlon/widgets/challenge_card.dart';
import 'package:flutter/material.dart';

class UpcomingChallengesCarousel extends StatefulWidget {
  UpcomingChallengesCarousel({super.key, required this.challenges});

  List<Challenge> challenges;

  @override
  State<StatefulWidget> createState() {
    return _BonusChallengeCarouselState();
  }
}

class _BonusChallengeCarouselState extends State<UpcomingChallengesCarousel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 200,
          child: CarouselView(
              elevation: 5,
              padding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              itemExtent: 300,
              shrinkExtent: 300,
              itemSnapping: true,
              onTap: (int valueChanged) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => ChallengeDetailsScreen(challenge: widget.challenges[valueChanged]))
                );
              },
              children: [
                for (Challenge challenge in widget.challenges)
                  ChallengeCard(challenge: challenge,)
              ]
          ),
        )
      ],
    );
  }
}