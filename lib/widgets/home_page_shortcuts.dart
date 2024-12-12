import 'package:dodecathlon/models/event.dart';
import 'package:flutter/material.dart';

import '../screens/event_details_screen.dart';
import '../screens/event_schedule_screen.dart';
import '../screens/faq_screen.dart';

class HomePageShortcuts extends StatelessWidget {

  HomePageShortcuts({super.key, required this.currentEvent, required this.nextEvent});

  Event currentEvent;
  Event nextEvent;

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
                MaterialPageRoute(builder: (ctx) => EventDetailsScreen(event: currentEvent))
            );
          },
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black38,
                      offset: Offset(0, 5),
                      spreadRadius: 1,
                      blurRadius: 5
                  )
                ]
            ),
            child: Text('Current Event', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => EventDetailsScreen(event: nextEvent))
            );
          },
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: nextEvent.themeColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black38,
                      offset: Offset(0, 5),
                      spreadRadius: 1,
                      blurRadius: 5
                  )
                ]
            ),
            child: Text('Upcoming Event', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
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
                color: Theme.of(context).colorScheme.tertiary,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black38,
                      offset: Offset(0, 5),
                      spreadRadius: 1,
                      blurRadius: 5
                  )
                ]
            ),
            child: Text('Event Schedule', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
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
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black38,
                      offset: Offset(0, 5),
                      spreadRadius: 1,
                      blurRadius: 5
                  )
                ]
            ),
            child: Text('FAQ', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
          ),
        ),
      ],
    );
  }
}