import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/screens/challenge_details_screen.dart';
import 'package:dodecathlon/widgets/challenge_card.dart';
import 'package:flutter/material.dart';

import '../models/event.dart';

class UpcomingChallengesCarousel extends StatefulWidget {
  const UpcomingChallengesCarousel({super.key, required this.challenges, required this.event});

  final List<Challenge> challenges;
  final Event event;

  @override
  State<StatefulWidget> createState() {
    return _BonusChallengeCarouselState();
  }
}

class _BonusChallengeCarouselState extends State<UpcomingChallengesCarousel> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      lowerBound: 0,
      upperBound: 1,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: SizedBox(
        height: 250,
        child: CarouselView(
            elevation: 5,
            padding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
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
                ChallengeCard(challenge: challenge, event: widget.event)
            ]
        ),
      ),
      builder: (context, child) => SlideTransition(
        position: Tween(
          begin: const Offset(-1, 0),
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(
            parent: _animationController, curve: Curves.easeInOut)),
        child: child,
      ),
    );
  }
}