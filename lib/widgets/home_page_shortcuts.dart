import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/event.dart';
import 'package:flutter/material.dart';

import '../screens/event_details_screen.dart';
import '../screens/event_schedule_screen.dart';
import '../screens/faq_screen.dart';

class HomePageShortcuts extends StatelessWidget {

  const HomePageShortcuts({
    super.key,
    required this.currentEvent,
    required this.eventChallenges,
    required this.nextEvent
  });

  final Event currentEvent;
  final List<Challenge> eventChallenges;
  final Event nextEvent;

  @override
  Widget build(BuildContext context) {
    return GridView(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.7,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => EventDetailsScreen(event: currentEvent, challenges: eventChallenges,))
            );
          },
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                // color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Theme.of(context).colorScheme.primary)
            ),
            child: Text('Current Event', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold),),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => EventDetailsScreen(event: nextEvent, challenges: eventChallenges,))
            );
          },
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                // color: nextEvent.themeColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: nextEvent.themeColor)
            ),
            child: Text('Upcoming Event', style: TextStyle(color: nextEvent.themeColor, fontSize: 20, fontWeight: FontWeight.bold),),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => EventScheduleScreen())
            );
          },
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                // color: Theme.of(context).colorScheme.tertiary,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Theme.of(context).colorScheme.tertiary)
            ),
            child: Text('Event Schedule', style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 20, fontWeight: FontWeight.bold),),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => FaqScreen())
            );
          },
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                // color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Theme.of(context).colorScheme.secondary)
            ),
            child: Text('FAQ', style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 20, fontWeight: FontWeight.bold),),
          ),
        ),
      ],
    );
  }
}