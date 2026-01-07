import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/screens/challenge_details_screen.dart';
import 'package:dodecathlon/widgets/bonus_challenge_card.dart';
import 'package:flutter/material.dart';
import '../models/event.dart';

class BonusChallengeCarousel extends StatefulWidget {
  const BonusChallengeCarousel({
    super.key,
    required this.challenges,
    required this.event,
    required this.isCompleted
  });

  final List<Challenge> challenges;
  final Event event;
  final bool isCompleted;

  @override
  State<StatefulWidget> createState() {
    return _BonusChallengeCarouselState();
  }
}

class _BonusChallengeCarouselState extends State<BonusChallengeCarousel> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      lowerBound: 0,
      upperBound: 1,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: SizedBox(
        height: 180,
        child: CarouselView(
          elevation: 5,
          itemSnapping: false,
          padding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          itemExtent: 180,
          shrinkExtent: 180,
          onTap: (int valueChanged) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => ChallengeDetailsScreen(
                  challenge: widget.challenges[valueChanged],
                  isCompleted: widget.isCompleted,
                ))
            );
          },
          children: [
            for (Challenge challenge in widget.challenges)
              BonusChallengeCard(challenge: challenge, event: widget.event, isCompleted: widget.isCompleted)
          ]
        ),
      ),
      builder: (context, child) => SlideTransition(
        position: Tween(
          begin: const Offset(1, 0),
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(
            parent: _animationController, curve: Curves.easeInOut)),
        child: child,
      ),
    );
  }
}